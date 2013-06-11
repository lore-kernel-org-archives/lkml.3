Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3FKUZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:25:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab3FKUD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 10/79] usb: musb: make use_sg flag URB specific
Date: Tue, 11 Jun 2013 13:02:36 -0700
Message-Id: <20130611195313.757278878@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_host.c |   18 ++++++++----------
 drivers/usb/musb/musb_host.h |    1 +
 2 files changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1232,7 +1232,6 @@ void musb_host_tx(struct musb *musb, u8
 	void __iomem		*mbase = musb->mregs;
 	struct dma_channel	*dma;
 	bool			transfer_pending = false;
-	static bool use_sg;
 
 	musb_ep_select(mbase, epnum);
 	tx_csr = musb_readw(epio, MUSB_TXCSR);
@@ -1463,9 +1462,9 @@ done:
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
@@ -1484,9 +1483,9 @@ done:
 
 	qh->segsize = length;
 
-	if (use_sg) {
+	if (qh->use_sg) {
 		if (offset + length >= urb->transfer_buffer_length)
-			use_sg = false;
+			qh->use_sg = false;
 	}
 
 	musb_ep_select(mbase, epnum);
@@ -1552,7 +1551,6 @@ void musb_host_rx(struct musb *musb, u8
 	bool			done = false;
 	u32			status;
 	struct dma_channel	*dma;
-	static bool use_sg;
 	unsigned int sg_flags = SG_MITER_ATOMIC | SG_MITER_TO_SG;
 
 	musb_ep_select(mbase, epnum);
@@ -1878,12 +1876,12 @@ void musb_host_rx(struct musb *musb, u8
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
@@ -1913,8 +1911,8 @@ finish:
 	urb->actual_length += xfer_len;
 	qh->offset += xfer_len;
 	if (done) {
-		if (use_sg)
-			use_sg = false;
+		if (qh->use_sg)
+			qh->use_sg = false;
 
 		if (urb->status == -EINPROGRESS)
 			urb->status = status;
--- a/drivers/usb/musb/musb_host.h
+++ b/drivers/usb/musb/musb_host.h
@@ -74,6 +74,7 @@ struct musb_qh {
 	u16			frame;		/* for periodic schedule */
 	unsigned		iso_idx;	/* in urb->iso_frame_desc[] */
 	struct sg_mapping_iter sg_miter;	/* for highmem in PIO mode */
+	bool			use_sg;		/* to track urb using sglist */
 };
 
 /* map from control or bulk queue head to the first qh on that ring */


