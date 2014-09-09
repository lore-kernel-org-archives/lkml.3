Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaIIIpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:45:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11179 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbaIIIpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:45:25 -0400
X-AuditID: cbfee61b-f79f86d00000144c-77-540ebe23b3c0
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 5/6] usb: dwc2/gadget: assign TX FIFO dynamically
Date: Tue, 09 Sep 2014 10:44:56 +0200
Message-id: <1410252297-13738-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xoK7yPr4Qg6Z1AhYH79dbNC9ez2Zx
	edccNotFy1qZLR493Mpq8eDwTnYHNo/9c9ewe/RtWcXosWX/Z0aP4ze2M3l83iQXwBrFZZOS
	mpNZllqkb5fAldGz+wJbwXnjivW77rE2MJ5X72Lk5JAQMJHYP+8VE4QtJnHh3nq2LkYuDiGB
	6YwSDVdaGSGcdiaJXb+uMYNUsQnoSGz5PoERxBYRkJe4vvEmC0gRs0A/o8TK2YtZQBLCAo4S
	V2+fYQexWQRUJb49/Aa2glfAVeLt7RZmiHVyEiePTWYFsTkF3CT+HPsCVi8EVPNvzjSWCYy8
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB9Mz6R2MqxosDjEKcDAq8fBmBPOFCLEm
	lhVX5h5ilOBgVhLhvbIbKMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFq
	EUyWiYNTqoExb1KDqOK+aIe1DReTI45cfnN+SlDLz+wpvtq6K721WjaZJogyNW1xU5wQxG6k
	fk5VZOGL15Fxnoc7lvZE+BneFL77K5BPbCpf76zpQnM5jnDZ/lN/u3PTtQuX3vPOUmXPUYub
	99r8WtRcLcc3rFOO26/tN182N8l6q1opX+C2DwaHmcIMdyYqsRRnJBpqMRcVJwIAA93OTCIC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we have not enough memory to have each TX FIFO of size at least
3072 bytes (the maximum single packet size with 3 transactions per
microframe), we create four FIFOs of lenght 1024, and four of length
3072 bytes, and assing them to endpoints dynamically according to
maxpacket size value of given endpoint.

Up to now there were initialized 16 TX FIFOs, but we use only 8 IN
endpoints, so we can split available memory for 8 FIFOs to have more
memory for each one.

It needed to do some small modifications in few places in code, because
there was assumption that TX FIFO numbers assigned to endpoints are the
same as the endpoint numbers, which is not true since we have dynamic
FIFO assigning.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/core.h   |  2 ++
 drivers/usb/dwc2/gadget.c | 80 +++++++++++++++++++++++++++++------------------
 2 files changed, 52 insertions(+), 30 deletions(-)

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
index bd58756..29d7561 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -182,14 +182,29 @@ static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
 
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
@@ -1834,7 +1849,7 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 		if (dir_in) {
 			int epctl = readl(hsotg->regs + epctl_reg);
 
-			s3c_hsotg_txfifo_flush(hsotg, idx);
+			s3c_hsotg_txfifo_flush(hsotg, hs_ep->fifo_index);
 
 			if ((epctl & DXEPCTL_STALL) &&
 				(epctl & DXEPCTL_EPTYPE_BULK)) {
@@ -1983,6 +1998,7 @@ static void kill_all_requests(struct s3c_hsotg *hsotg,
 			      int result, bool force)
 {
 	struct s3c_hsotg_req *req, *treq;
+	unsigned size;
 
 	list_for_each_entry_safe(req, treq, &ep->queue, queue) {
 		/*
@@ -1996,9 +2012,11 @@ static void kill_all_requests(struct s3c_hsotg *hsotg,
 		s3c_hsotg_complete_request(hsotg, ep, req,
 					   result);
 	}
-	if (hsotg->dedicated_fifos)
-		if ((readl(hsotg->regs + DTXFSTS(ep->index)) & 0xffff) * 4 < 3072)
-			s3c_hsotg_txfifo_flush(hsotg, ep->index);
+	if (!hsotg->dedicated_fifos)
+		return;
+	size = (readl(hsotg->regs + DTXFSTS(ep->index)) & 0xffff) * 4;
+	if (size < ep->fifo_size)
+		s3c_hsotg_txfifo_flush(hsotg, ep->fifo_index);
 }
 
 /**
@@ -2439,6 +2457,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	u32 epctrl;
 	u32 mps;
 	int dir_in;
+	int i, val, size;
 	int ret = 0;
 
 	dev_dbg(hsotg->dev,
@@ -2511,17 +2530,8 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
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
@@ -2535,8 +2545,25 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
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
@@ -2583,6 +2610,9 @@ static int s3c_hsotg_ep_disable(struct usb_ep *ep)
 	/* terminate all requests with shutdown */
 	kill_all_requests(hsotg, hs_ep, -ESHUTDOWN, false);
 
+	hsotg->fifo_map &= ~(1<<hs_ep->fifo_index);
+	hs_ep->fifo_index = 0;
+	hs_ep->fifo_size = 0;
 
 	ctrl = readl(hsotg->regs + epctrl_reg);
 	ctrl &= ~DXEPCTL_EPENA;
@@ -2974,7 +3004,6 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
 				       struct s3c_hsotg_ep *hs_ep,
 				       int epnum)
 {
-	u32 ptxfifo;
 	char *dir;
 
 	if (epnum == 0)
@@ -3003,15 +3032,6 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
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

