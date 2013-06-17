Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3FQR7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:59:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3FQRbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 14/84] usb: musb: make use_sg flag URB specific
Date: Mon, 17 Jun 2013 10:30:18 -0700
Message-Id: <1371490288-23167-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>

commit ed74df12dc3e07a37d99aab60211496e871488a0 upstream.

Since highmem PIO URB handling was introduced in:

8e8a551 usb: musb: host: Handle highmem in PIO mode

when a URB is being handled it may happen that the static use_sg flag
was set by a previous URB with buffer in highmem.  This leads to error
in handling the present URB.

Fix this by making the use_sg flag URB specific.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/musb/musb_host.c | 18 ++++++++----------
 drivers/usb/musb/musb_host.h |  1 +
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index e9f0fd9..c131eb6 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1212,7 +1212,6 @@ void musb_host_tx(struct musb *musb, u8 epnum)
 	void __iomem		*mbase = musb->mregs;
 	struct dma_channel	*dma;
 	bool			transfer_pending = false;
-	static bool use_sg;
 
 	musb_ep_select(mbase, epnum);
 	tx_csr = musb_readw(epio, MUSB_TXCSR);
@@ -1443,9 +1442,9 @@ done:
 	 * NULL.
 	 */
 	if (!urb->transfer_buffer)
-		use_sg = true;
+		qh->use_sg = true;
 
-	if (use_sg) {
+	if (qh->use_sg) {
 		/* sg_miter_start is already done in musb_ep_program */
 		if (!sg_miter_next(&qh->sg_miter)) {
 			dev_err(musb->controller, "error: sg list empty\n");
@@ -1464,9 +1463,9 @@ done:
 
 	qh->segsize = length;
 
-	if (use_sg) {
+	if (qh->use_sg) {
 		if (offset + length >= urb->transfer_buffer_length)
-			use_sg = false;
+			qh->use_sg = false;
 	}
 
 	musb_ep_select(mbase, epnum);
@@ -1532,7 +1531,6 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 	bool			done = false;
 	u32			status;
 	struct dma_channel	*dma;
-	static bool use_sg;
 	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITER_TO_SG;
 
 	musb_ep_select(mbase, epnum);
@@ -1858,12 +1856,12 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 			 * NULL.
 			 */
 			if (!urb->transfer_buffer) {
-				use_sg = true;
+				qh->use_sg = true;
 				sg_miter_start(&qh->sg_miter, urb->sg, 1,
 						sg_flags);
 			}
 
-			if (use_sg) {
+			if (qh->use_sg) {
 				if (!sg_miter_next(&qh->sg_miter)) {
 					dev_err(musb->controller, "error: sg list empty\n");
 					sg_miter_stop(&qh->sg_miter);
@@ -1893,8 +1891,8 @@ finish:
 	urb->actual_length += xfer_len;
 	qh->offset += xfer_len;
 	if (done) {
-		if (use_sg)
-			use_sg = false;
+		if (qh->use_sg)
+			qh->use_sg = false;
 
 		if (urb->status == -EINPROGRESS)
 			urb->status = status;
diff --git a/drivers/usb/musb/musb_host.h b/drivers/usb/musb/musb_host.h
index 5a9c8fe..738f7eb 100644
--- a/drivers/usb/musb/musb_host.h
+++ b/drivers/usb/musb/musb_host.h
@@ -74,6 +74,7 @@ struct musb_qh {
 	u16			frame;		/* for periodic schedule */
 	unsigned		iso_idx;	/* in urb->iso_frame_desc[] */
 	struct sg_mapping_iter sg_miter;	/* for highmem in PIO mode */
+	bool			use_sg;		/* to track urb using sglist */
 };
 
 /* map from control or bulk queue head to the first qh on that ring */
-- 
1.8.1.2

