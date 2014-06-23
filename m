Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaFWHye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:54:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59899 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaFWHya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:54:30 -0400
X-AuditID: cbfee61a-f79e46d00000134f-dc-53a7dd34d48e
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 10/11] usb: dwc2/gadget: assign TX FIFO dynamically
Date: Mon, 23 Jun 2014 09:51:29 +0200
Message-id: <1403509890-14103-11-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t9jQV3Tu8uDDQ4zWsx62c5icfB+vUXz
	4vVsFpd3zWGzWLSsldli7ZG77Bbbp0xnsnhweCe7A4fH/rlr2D36tqxi9Niy/zOjx/Eb25k8
	Pm+SC2CN4rJJSc3JLEst0rdL4MqYdmUVc8EKqYotyy6zNjC2iXQxcnJICJhInH5+jxXCFpO4
	cG89WxcjF4eQwHRGiYcXbzKBJIQE2pkkJt9zALHZBHQktnyfwAhiiwgISKx/cYkdpIFZ4ASj
	RMf/C2wgCWEBZ4nPs66xg9gsAqoSs/5eARvEK+Am0bhuJgvENjmJk8cmg23mBIqvv7mQHWKZ
	q8Si09PYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHFzPpHYwrmywOMQowMGo
	xMOr4bY8WIg1say4MvcQowQHs5IIb2MDUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB
	9MSS1OzU1ILUIpgsEwenVAMjt/fjrOql+x45uB7atX3WwaftYRenL9vN2T+ps+7D/0xPpg3f
	yk4EHr1+VeNs1Heh1TIfMvb27X/7R2TtdMulIifme89yEp2W69vFPIOlQbA8h/X9y8cbj3xr
	/NipJXc5eqf3wnCG20KPFD6/+/TGTFHaP8aRjyeie+ux1ns5uRJh+1QOMC62UGIpzkg01GIu
	Kk4EAGL+3A8qAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we have not enough memory to have each TX FIFO of size at least 3072
bytes (the maximum single packet size), we create four FIFOs of lenght 1024,
and four of length 3072 bytes, and assing them to endpoints dynamically
according to maxpacket size value of given endpoint.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/core.h   |  1 +
 drivers/usb/dwc2/gadget.c | 48 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index 067390e..23f7e86 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -197,6 +197,7 @@ struct s3c_hsotg {
 	int			fifo_mem;
 	unsigned int            dedicated_fifos:1;
 	unsigned char           num_of_eps;
+	u32			fifo_map;
 
 	struct dentry           *debug_root;
 	struct dentry           *debug_file;
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 3435711..2a7c014 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -184,14 +184,26 @@ static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
 
 	/* start at the end of the GNPTXFSIZ, rounded up */
 	addr = 2048 + 1024;
-	size = 768;
 
 	/*
 	 * currently we allocate TX FIFOs for all possible endpoints,
 	 * and assume that they are all the same size.
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
@@ -2440,6 +2452,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	u32 epctrl;
 	u32 mps;
 	int dir_in;
+	int i, val, size;
 	int ret = 0;
 
 	dev_dbg(hsotg->dev,
@@ -2512,17 +2525,8 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
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
@@ -2536,8 +2540,24 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	 * if the hardware has dedicated fifos, we must give each IN EP
 	 * a unique tx-fifo even if it is non-periodic.
 	 */
-	if (dir_in && hsotg->dedicated_fifos)
-		epctrl |= DXEPCTL_TXFNUM(index);
+	if (dir_in && hsotg->dedicated_fifos) {
+		size = hs_ep->ep.maxpacket*hs_ep->mc;
+		for (i = 1; i < 8; ++i) {
+			if (hsotg->fifo_map & (1<<i))
+				continue;
+			val = readl(hsotg->regs + DPTXFSIZN(i));
+			val = (val >> FIFOSIZE_DEPTH_SHIFT)*4;
+			if (val < size)
+				continue;
+			hsotg->fifo_map |= 1<<i;
+			break;
+		}
+
+		if (i == 8)
+			return -ENOMEM;
+
+		epctrl |= DXEPCTL_TXFNUM(i);
+	}
 
 	/* for non control endpoints, set PID to D0 */
 	if (index)
-- 
1.9.1

