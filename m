Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab3HNKhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:37:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34414 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759781Ab3HNKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 10/75] firewire: fix libdc1394/FlyCap2 iso event regression
Date: Wed, 14 Aug 2013 11:35:59 +0100
Message-Id: <1376476624-10011-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 0699a73af3811b66b1ab5650575acee5eea841ab upstream.

Commit 18d627113b83 (firewire: prevent dropping of completed iso packet
header data) was intended to be an obvious bug fix, but libdc1394 and
FlyCap2 depend on the old behaviour by ignoring all returned information
and thus not noticing that not all packets have been received yet.  The
result was that the video frame buffers would be saved before they
contained the correct data.

Reintroduce the old behaviour for old clients.

Tested-by: Stepan Salenikovich <stepan.salenikovich@gmail.com>
Tested-by: Josep Bosch <jep250@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firewire/core-cdev.c  |  3 +++
 drivers/firewire/ohci.c       | 10 ++++++++--
 include/linux/firewire-cdev.h |  4 ++--
 include/linux/firewire.h      |  1 +
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index f8d2287..87ae86f 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -54,6 +54,7 @@
 #define FW_CDEV_KERNEL_VERSION			5
 #define FW_CDEV_VERSION_EVENT_REQUEST2		4
 #define FW_CDEV_VERSION_ALLOCATE_REGION_END	4
+#define FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW	5
 
 struct client {
 	u32 version;
@@ -1009,6 +1010,8 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 			a->channel, a->speed, a->header_size, cb, client);
 	if (IS_ERR(context))
 		return PTR_ERR(context);
+	if (client->version < FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW)
+		context->drop_overflow_headers = true;
 
 	/* We only support one context at this time. */
 	spin_lock_irq(&client->lock);
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index c1af05e..4f36463 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2692,8 +2692,11 @@ static void copy_iso_headers(struct iso_context *ctx, const u32 *dma_hdr)
 {
 	u32 *ctx_hdr;
 
-	if (ctx->header_length + ctx->base.header_size > PAGE_SIZE)
+	if (ctx->header_length + ctx->base.header_size > PAGE_SIZE) {
+		if (ctx->base.drop_overflow_headers)
+			return;
 		flush_iso_completions(ctx);
+	}
 
 	ctx_hdr = ctx->header + ctx->header_length;
 	ctx->last_timestamp = (u16)le32_to_cpu((__force __le32)dma_hdr[0]);
@@ -2853,8 +2856,11 @@ static int handle_it_packet(struct context *context,
 
 	sync_it_packet_for_cpu(context, d);
 
-	if (ctx->header_length + 4 > PAGE_SIZE)
+	if (ctx->header_length + 4 > PAGE_SIZE) {
+		if (ctx->base.drop_overflow_headers)
+			return 1;
 		flush_iso_completions(ctx);
+	}
 
 	ctx_hdr = ctx->header + ctx->header_length;
 	ctx->last_timestamp = le16_to_cpu(last->res_count);
diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index d500369..1db453e 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -215,8 +215,8 @@ struct fw_cdev_event_request2 {
  * with the %FW_CDEV_ISO_INTERRUPT bit set, when explicitly requested with
  * %FW_CDEV_IOC_FLUSH_ISO, or when there have been so many completed packets
  * without the interrupt bit set that the kernel's internal buffer for @header
- * is about to overflow.  (In the last case, kernels with ABI version < 5 drop
- * header data up to the next interrupt packet.)
+ * is about to overflow.  (In the last case, ABI versions < 5 drop header data
+ * up to the next interrupt packet.)
  *
  * Isochronous transmit events (context type %FW_CDEV_ISO_CONTEXT_TRANSMIT):
  *
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 7edcf10..babdb98 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -426,6 +426,7 @@ struct fw_iso_context {
 	int type;
 	int channel;
 	int speed;
+	bool drop_overflow_headers;
 	size_t header_size;
 	union {
 		fw_iso_callback_t sc;
-- 
1.8.3.2

