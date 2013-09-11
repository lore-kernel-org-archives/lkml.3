Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3IKL1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:27:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3IKL0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:26:44 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_AVAl6mgaRMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=hRPKJiX5yckA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=GaB0eZY4ksT9ifhwxDsA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=SwHhlruamudD19FW:21 a=eTh0V6cWV9RiIXpf:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042901.529516213@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [055/251] skb: report completion status for zero copy skbs
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0055-skb-report-completion-status-for-zero-copy-skbs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit e19d6763cc300fcb706bd291b24ac06be71e1ce6 ]

Even if skb is marked for zero copy, net core might still decide
to copy it later which is somewhat slower than a copy in user context:
besides copying the data we need to pin/unpin the pages.

Add a parameter reporting such cases through zero copy callback:
if this happens a lot, device can take this into account
and switch to copying in user context.

This patch updates all users but ignores the passed value for now:
it will be used by follow-up patches.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/vhost/vhost.c  |    2 +-
 drivers/vhost/vhost.h  |    2 +-
 include/linux/skbuff.h |    4 +++-
 net/core/skbuff.c      |    4 ++--
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ef82a0d..c0492d7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1600,7 +1600,7 @@ void vhost_ubuf_put_and_wait(struct vhost_ubuf_ref *ubufs)
 	kfree(ubufs);
 }
 
-void vhost_zerocopy_callback(struct ubuf_info *ubuf)
+void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool status)
 {
 	struct vhost_ubuf_ref *ubufs = ubuf->ctx;
 	struct vhost_virtqueue *vq = ubufs->vq;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 1125af3..2de4ce2 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -191,7 +191,7 @@ bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 		    unsigned int log_num, u64 len);
-void vhost_zerocopy_callback(struct ubuf_info *);
+void vhost_zerocopy_callback(struct ubuf_info *, bool);
 int vhost_zerocopy_signal_used(struct vhost_virtqueue *vq);
 
 #define vq_err(vq, fmt, ...) do {                                  \
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index adab092..a45dd48 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -235,11 +235,13 @@ enum {
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
  * lower device, the skb last reference should be 0 when calling this.
+ * The zerocopy_success argument is true if zero copy transmit occurred,
+ * false on data copy or out of memory error caused by data copy attempt.
  * The ctx field is used to track device context.
  * The desc field is used to track userspace buffer index.
  */
 struct ubuf_info {
-	void (*callback)(struct ubuf_info *);
+	void (*callback)(struct ubuf_info *, bool zerocopy_success);
 	void *ctx;
 	unsigned long desc;
 };
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 043139d01..eaad7a7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -505,7 +505,7 @@ static void skb_release_data(struct sk_buff *skb)
 
 			uarg = skb_shinfo(skb)->destructor_arg;
 			if (uarg->callback)
-				uarg->callback(uarg);
+				uarg->callback(uarg, true);
 		}
 
 		if (skb_has_frag_list(skb))
@@ -783,7 +783,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 	for (i = 0; i < num_frags; i++)
 		skb_frag_unref(skb, i);
 
-	uarg->callback(uarg);
+	uarg->callback(uarg, false);
 
 	/* skb frags point to kernel buffers */
 	for (i = num_frags - 1; i >= 0; i--) {
-- 
1.7.10.4


