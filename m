Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbaGPKX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:23:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38682 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460AbaGPKXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:19 -0400
X-AuditID: cbfee61a-f79e46d00000134f-a2-53c6529529b2
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 10/12] usb: dwc2/gadget: assign TX FIFO dynamically
Date: Wed, 16 Jul 2014 12:22:28 +0200
Message-id: <1405506150-16185-11-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd2pQceCDRY/s7CY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9kttk+ZzmTx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CV0b+lh7HgvnnF2+MXGRsYe7S7GDk5JARMJLbMbmOGsMUk
	Ltxbz9bFyMUhJDCdUWJJ514WCKedSeLvqr9sIFVsAjoSW75PYASxRQQEJNa/uMQOUsQscIJR
	ouP/BbAiYQE3iZ/f24FsDg4WAVWJS/vCQMK8QOFNF2ZAbZOTOHlsMiuIzQkUX/O6mR3EFhJw
	lTi+bhnTBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCw+uZ1A7GlQ0WhxgFOBiV
	eHg3hBwNFmJNLCuuzD3EKMHBrCTC6+B/LFiINyWxsiq1KD++qDQntfgQozQHi5I474FW60Ah
	gfTEktTs1NSC1CKYLBMHp1QD40LjHUJL+pdP8pFqa3195e7xZ76qj4Kz3lzWyL0oHLctyzV8
	QvtFg6K8yZymHzWFXnuXvsj2MxIVuPWl89Ub6eN1T60i1+8VfS/8OWeqfJ3aKu4CG2m/W4ln
	T5gd7b1TOcWj6fXDXIfdYdbH74XN6pPSaw8Iza3oYmW/xKjVMGeuPkeunXutEktxRqKhFnNR
	cSIAeln5JisCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we have not enough memory to have each TX FIFO of size at least 3072
bytes (the maximum single packet size), we create four FIFOs of lenght 1024,
and four of length 3072 bytes, and assing them to endpoints dynamically
according to maxpacket size value of given endpoint.

It needed to do some small modifications in few places in code, because there
was assumption that TX FIFO numbers assigned to endpoints are the same as
the endpoint numbers, which is not true since we have dynamic FIFO assigning.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/core.h   |  2 ++
 drivers/usb/dwc2/gadget.c | 84 +++++++++++++++++++++++++++++------------------
 2 files changed, 54 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index 067390e..3b4bd4c 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -139,6 +139,7 @@ struct s3c_hsotg_ep {
 	unsigned int            last_load;
 	unsigned int            fifo_load;
 	unsigned short          fifo_size;
+	unsigned short		fifo_index;
 
 	unsigned char           dir_in;
 	unsigned char           index;
@@ -197,6 +198,7 @@ struct s3c_hsotg {
 	int			fifo_mem;
 	unsigned int            dedicated_fifos:1;
 	unsigned char           num_of_eps;
+	u32			fifo_map;
 
 	struct dentry           *debug_root;
 	struct dentry           *debug_file;
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 3435711..1b5e9ff 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -184,14 +184,29 @@ static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
 
 	/* start at the end of the GNPTXFSIZ, rounded up */
 	addr = 2048 + 1024;
-	size = 768;
 
 	/*
-	 * currently we allocate TX FIFOs for all possible endpoints,
-	 * and assume that they are all the same size.
+	 * Because we have not enough memory to have each TX FIFO of size at
+	 * least 3072 bytes (the maximum single packet size), we create four
+	 * FIFOs of lenght 1024, and four of length 3072 bytes, and assing
+	 * them to endpoints dynamically according to maxpacket size value of
+	 * given endpoint.
 	 */
 
-	for (ep = 1; ep <= 15; ep++) {
+	/* 256*4=1024 bytes FIFO length */
+	size = 256;
+	for (ep = 1; ep <= 4; ep++) {
+		val = addr;
+		val |= size << FIFOSIZE_DEPTH_SHIFT;
+		WARN_ONCE(addr + size > hsotg->fifo_mem,
+			  "insufficient fifo memory");
+		addr += size;
+
+		writel(val, hsotg->regs + DPTXFSIZN(ep));
+	}
+	/* 768*4=3072 bytes FIFO length */
+	size = 768;
+	for (ep = 5; ep <= 8; ep++) {
 		val = addr;
 		val |= size << FIFOSIZE_DEPTH_SHIFT;
 		WARN_ONCE(addr + size > hsotg->fifo_mem,
@@ -450,7 +465,7 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 	to_write = DIV_ROUND_UP(to_write, 4);
 	data = hs_req->req.buf + buf_pos;
 
-	iowrite32_rep(hsotg->regs + EPFIFO(hs_ep->index), data, to_write);
+	iowrite32_rep(hsotg->regs + EPFIFO(hs_ep->fifo_index), data, to_write);
 
 	return (to_write >= can_write) ? -ENOSPC : 0;
 }
@@ -1281,7 +1296,7 @@ static void s3c_hsotg_rx_data(struct s3c_hsotg *hsotg, int ep_idx, int size)
 {
 	struct s3c_hsotg_ep *hs_ep = &hsotg->eps[ep_idx];
 	struct s3c_hsotg_req *hs_req = hs_ep->req;
-	void __iomem *fifo = hsotg->regs + EPFIFO(ep_idx);
+	void __iomem *fifo = hsotg->regs + EPFIFO(hs_ep->fifo_index);
 	int to_read;
 	int max_req;
 	int read_ptr;
@@ -1835,7 +1850,7 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 		if (dir_in) {
 			int epctl = readl(hsotg->regs + epctl_reg);
 
-			s3c_hsotg_txfifo_flush(hsotg, idx);
+			s3c_hsotg_txfifo_flush(hsotg, hs_ep->fifo_index);
 
 			if ((epctl & DXEPCTL_STALL) &&
 				(epctl & DXEPCTL_EPTYPE_BULK)) {
@@ -1984,6 +1999,7 @@ static void kill_all_requests(struct s3c_hsotg *hsotg,
 			      int result, bool force)
 {
 	struct s3c_hsotg_req *req, *treq;
+	unsigned size;
 
 	list_for_each_entry_safe(req, treq, &ep->queue, queue) {
 		/*
@@ -1997,9 +2013,11 @@ static void kill_all_requests(struct s3c_hsotg *hsotg,
 		s3c_hsotg_complete_request(hsotg, ep, req,
 					   result);
 	}
-	if(hsotg->dedicated_fifos)
-		if ((readl(hsotg->regs + DTXFSTS(ep->index)) & 0xffff) * 4 < 3072)
-			s3c_hsotg_txfifo_flush(hsotg, ep->index);
+	if (hsotg->dedicated_fifos) {
+		size = (readl(hsotg->regs + DTXFSTS(ep->index)) & 0xffff) * 4;
+		if (size < ep->fifo_size)
+			s3c_hsotg_txfifo_flush(hsotg, ep->fifo_index);
+	}
 }
 
 /**
@@ -2440,6 +2458,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	u32 epctrl;
 	u32 mps;
 	int dir_in;
+	int i, val, size;
 	int ret = 0;
 
 	dev_dbg(hsotg->dev,
@@ -2512,17 +2531,8 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 		break;
 
 	case USB_ENDPOINT_XFER_INT:
-		if (dir_in) {
-			/*
-			 * Allocate our TxFNum by simply using the index
-			 * of the endpoint for the moment. We could do
-			 * something better if the host indicates how
-			 * many FIFOs we are expecting to use.
-			 */
-
+		if (dir_in)
 			hs_ep->periodic = 1;
-			epctrl |= DXEPCTL_TXFNUM(index);
-		}
 
 		epctrl |= DXEPCTL_EPTYPE_INTERRUPT;
 		break;
@@ -2536,8 +2546,25 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	 * if the hardware has dedicated fifos, we must give each IN EP
 	 * a unique tx-fifo even if it is non-periodic.
 	 */
-	if (dir_in && hsotg->dedicated_fifos)
-		epctrl |= DXEPCTL_TXFNUM(index);
+	if (dir_in && hsotg->dedicated_fifos) {
+		size = hs_ep->ep.maxpacket*hs_ep->mc;
+		for (i = 1; i <= 8; ++i) {
+			if (hsotg->fifo_map & (1<<i))
+				continue;
+			val = readl(hsotg->regs + DPTXFSIZN(i));
+			val = (val >> FIFOSIZE_DEPTH_SHIFT)*4;
+			if (val < size)
+				continue;
+			hsotg->fifo_map |= 1<<i;
+
+			epctrl |= DXEPCTL_TXFNUM(i);
+			hs_ep->fifo_index = i;
+			hs_ep->fifo_size = val;
+			break;
+		}
+		if (i == 8)
+			return -ENOMEM;
+	}
 
 	/* for non control endpoints, set PID to D0 */
 	if (index)
@@ -2584,6 +2611,9 @@ static int s3c_hsotg_ep_disable(struct usb_ep *ep)
 	/* terminate all requests with shutdown */
 	kill_all_requests(hsotg, hs_ep, -ESHUTDOWN, false);
 
+	hsotg->fifo_map &= ~(1<<hs_ep->fifo_index);
+	hs_ep->fifo_index = 0;
+	hs_ep->fifo_size = 0;
 
 	ctrl = readl(hsotg->regs + epctrl_reg);
 	ctrl &= ~DXEPCTL_EPENA;
@@ -2975,7 +3005,6 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
 				       struct s3c_hsotg_ep *hs_ep,
 				       int epnum)
 {
-	u32 ptxfifo;
 	char *dir;
 
 	if (epnum == 0)
@@ -3004,15 +3033,6 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
 	hs_ep->ep.ops = &s3c_hsotg_ep_ops;
 
 	/*
-	 * Read the FIFO size for the Periodic TX FIFO, even if we're
-	 * an OUT endpoint, we may as well do this if in future the
-	 * code is changed to make each endpoint's direction changeable.
-	 */
-
-	ptxfifo = readl(hsotg->regs + DPTXFSIZN(epnum));
-	hs_ep->fifo_size = FIFOSIZE_DEPTH_GET(ptxfifo) * 4;
-
-	/*
 	 * if we're using dma, we need to set the next-endpoint pointer
 	 * to be something valid.
 	 */
-- 
1.9.1

