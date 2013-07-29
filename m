Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3G2Ud0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:33:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46061 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab3G2UdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:33:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 29 Jul 2013 22:33:12 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire regression fix
Message-ID: <20130729223312.723167d0@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

please pull from the tag "firewire-fix" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-fix

This fixes corrupted video capture, seen with IIDC/DCAM video and certain
buffer settings.  (Regression since v3.4 inclusive.)
Thanks.

Clemens Ladisch (1):
      firewire: fix libdc1394/FlyCap2 iso event regression

 drivers/firewire/core-cdev.c       |  3 +++
 drivers/firewire/ohci.c            | 10 ++++++++--
 include/linux/firewire.h           |  1 +
 include/uapi/linux/firewire-cdev.h |  4 ++--
 4 files changed, 14 insertions(+), 4 deletions(-)


commit 0699a73af3811b66b1ab5650575acee5eea841ab
Author: Clemens Ladisch <clemens@ladisch.de>
Date:   Mon Jul 22 21:32:09 2013 +0200

    firewire: fix libdc1394/FlyCap2 iso event regression
    
    Commit 18d627113b83 (firewire: prevent dropping of completed iso packet
    header data) was intended to be an obvious bug fix, but libdc1394 and
    FlyCap2 depend on the old behaviour by ignoring all returned information
    and thus not noticing that not all packets have been received yet.  The
    result was that the video frame buffers would be saved before they
    contained the correct data.
    
    Reintroduce the old behaviour for old clients.
    
    Tested-by: Stepan Salenikovich <stepan.salenikovich@gmail.com>
    Tested-by: Josep Bosch <jep250@gmail.com>
    Cc: <stable@vger.kernel.org> # 3.4+
    Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 7ef316f..ac1b43a 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -54,6 +54,7 @@
 #define FW_CDEV_KERNEL_VERSION			5
 #define FW_CDEV_VERSION_EVENT_REQUEST2		4
 #define FW_CDEV_VERSION_ALLOCATE_REGION_END	4
+#define FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW	5
 
 struct client {
 	u32 version;
@@ -1005,6 +1006,8 @@ static int ioctl_create_iso_context(struct client *client, union ioctl_arg *arg)
 			a->channel, a->speed, a->header_size, cb, client);
 	if (IS_ERR(context))
 		return PTR_ERR(context);
+	if (client->version < FW_CDEV_VERSION_AUTO_FLUSH_ISO_OVERFLOW)
+		context->drop_overflow_headers = true;
 
 	/* We only support one context at this time. */
 	spin_lock_irq(&client->lock);
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 9e1db64..afb701e 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2749,8 +2749,11 @@ static void copy_iso_headers(struct iso_context *ctx, const u32 *dma_hdr)
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
@@ -2910,8 +2913,11 @@ static int handle_it_packet(struct context *context,
 
 	sync_it_packet_for_cpu(context, d);
 
-	if (ctx->header_length + 4 > PAGE_SIZE)
+	if (ctx->header_length + 4 > PAGE_SIZE) {
+		if (ctx->base.drop_overflow_headers)
+			return 1;
 		flush_iso_completions(ctx);
+	}
 
 	ctx_hdr = ctx->header + ctx->header_length;
 	ctx->last_timestamp = le16_to_cpu(last->res_count);
diff --git a/include/linux/firewire.h b/include/linux/firewire.h
index 3b0e820..5d7782e 100644
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -436,6 +436,7 @@ struct fw_iso_context {
 	int type;
 	int channel;
 	int speed;
+	bool drop_overflow_headers;
 	size_t header_size;
 	union {
 		fw_iso_callback_t sc;
diff --git a/include/uapi/linux/firewire-cdev.h b/include/uapi/linux/firewire-cdev.h
index d500369..1db453e 100644
--- a/include/uapi/linux/firewire-cdev.h
+++ b/include/uapi/linux/firewire-cdev.h
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

-- 
Stefan Richter
-=====-===-= -=== ===-=
http://arcgraph.de/sr/
