Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3IWIHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:07:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62038 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3IWIHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:07:39 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-f6-523ff6c95d41
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] USB: gadget: s3c-hsotg: add isochronous transfers support
Date: Mon, 23 Sep 2013 10:07:12 +0200
Message-id: <1379923632-11205-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379923632-11205-1-git-send-email-r.baldyga@samsung.com>
References: <1379923632-11205-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQd2T3+yDDNpXilhsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGXNfL2AsmGBTsfjLaZYGxqv6XYycHBICJhKfr/SzQdhiEhfurQey
	uTiEBKYzSrx9DuO0M0l0ndjEDFLFJqAjseX7BEYQW0RAQGL9i0vsIEXMAk8YJaYeecUOkhAW
	8JJYOWUhE4jNIqAq8XT9XxYQm1fAVeLz/wdANRxA6xQk5kyyAQlzCrhJfF16HOwKIaCSA9em
	ME5g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzionknvYFzVYHGIUYCDUYmHNzLR
	PkiINbGsuDL3EKMEB7OSCG9TJ1CINyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs
	1NSC1CKYLBMHp1QDI7PxBbukrTmKHUW81SU5ro3mtTvfndjdXfVa6nj+7HdcMjsS2m3LuppN
	Fz3/69xVqH/soVysyCfeslu5aocYXr6fprbvWJL4p7gj9TsObWacUyc/d0qbkeumn/w5kW0G
	WUKM4ee33TU7qPDeIPr6x/3zPv2xvznpwR+xHSe2B7QHNJz/PGfDMSWW4oxEQy3mouJEAJEP
	16MmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds isochronous transfer support. It adds few modifications:
- Modify s3c_hsotg_write_fifo() function. It actually calculates transfer
  size, taking into account Multi Count value, which indicates number of
  transactions per microframe.
- Fix s3c_hsotg_start_req() function by setting number of packets to Multi
  Count field in DIEPTSIZ register for isochronous endpoints.
- Fix s3c_hsotg_set_ep_maxpacket() function. Field wMaxPacketSize of endpoint
  descriptor is now splitted into maximum packet size value and number of
  additional transaction per microframe.
- Modify s3c_hsotg_epint() function. Some interrupts are ignored for
  isochronous endpoints, (e.g. INTknTXFEmpMsk) becouse isochronous request is
  always transfered in single transaction, which ends with XferCompl interrupt.
  Add Odd/Even microframe toggle to allow data transfering in each microframe.
- Fix s3c_hsotg_ep_enable() function by supporting isochronous endpoint type.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   74 +++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index d5d951d..d737452 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -82,9 +82,12 @@ struct s3c_hsotg_req;
  * @dir_in: Set to true if this endpoint is of the IN direction, which
  *	    means that it is sending data to the Host.
  * @index: The index for the endpoint registers.
+ * @mc: Multi Count - number of transactions per microframe
+ * @interval - Interval for periodic endpoints
  * @name: The name array passed to the USB core.
  * @halted: Set if the endpoint has been halted.
  * @periodic: Set if this is a periodic ep, such as Interrupt
+ * @insochronous: Set if this is a isochronous ep
  * @sent_zlp: Set if we've sent a zero-length packet.
  * @total_data: The total number of data bytes done.
  * @fifo_size: The size of the FIFO (for periodic IN endpoints)
@@ -120,9 +123,12 @@ struct s3c_hsotg_ep {
 
 	unsigned char		dir_in;
 	unsigned char		index;
+	unsigned char		mc;
+	unsigned char		interval;
 
 	unsigned int		halted:1;
 	unsigned int		periodic:1;
+	unsigned int		isochronous:1;
 	unsigned int		sent_zlp:1;
 
 	char			name[10];
@@ -467,6 +473,7 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 	void *data;
 	int can_write;
 	int pkt_round;
+	int max_transfer;
 
 	to_write -= (buf_pos - hs_ep->last_load);
 
@@ -534,15 +541,17 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 		can_write *= 4;	/* fifo size is in 32bit quantities. */
 	}
 
-	dev_dbg(hsotg->dev, "%s: GNPTXSTS=%08x, can=%d, to=%d, mps %d\n",
-		 __func__, gnptxsts, can_write, to_write, hs_ep->ep.maxpacket);
+	max_transfer = hs_ep->ep.maxpacket * hs_ep->mc;
+
+	dev_dbg(hsotg->dev, "%s: GNPTXSTS=%08x, can=%d, to=%d, max_transfer %d\n",
+		 __func__, gnptxsts, can_write, to_write, max_transfer);
 
 	/*
 	 * limit to 512 bytes of data, it seems at least on the non-periodic
 	 * FIFO, requests of >512 cause the endpoint to get stuck with a
 	 * fragment of the end of the transfer in it.
 	 */
-	if (can_write > 512)
+	if (can_write > 512 && !periodic)
 		can_write = 512;
 
 	/*
@@ -550,8 +559,8 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 	 * the transfer to return that it did not run out of fifo space
 	 * doing it.
 	 */
-	if (to_write > hs_ep->ep.maxpacket) {
-		to_write = hs_ep->ep.maxpacket;
+	if (to_write > max_transfer) {
+		to_write = max_transfer;
 
 		/* it's needed only when we do not use dedicated fifos */
 		if (!hsotg->dedicated_fifos)
@@ -564,7 +573,7 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 
 	if (to_write > can_write) {
 		to_write = can_write;
-		pkt_round = to_write % hs_ep->ep.maxpacket;
+		pkt_round = to_write % max_transfer;
 
 		/*
 		 * Round the write down to an
@@ -730,8 +739,16 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
 	else
 		packets = 1;	/* send one packet if length is zero. */
 
+	if (length > (hs_ep->mc * hs_ep->ep.maxpacket) && hs_ep->isochronous) {
+		dev_err(hsotg->dev, "req length > maxpacket*mc\n");
+		return;
+	}
+
 	if (dir_in && index != 0)
-		epsize = DxEPTSIZ_MC(1);
+		if (hs_ep->isochronous)
+			epsize = DxEPTSIZ_MC(packets);
+		else
+			epsize = DxEPTSIZ_MC(1);
 	else
 		epsize = 0;
 
@@ -1718,6 +1735,7 @@ static void s3c_hsotg_set_ep_maxpacket(struct s3c_hsotg *hsotg,
 	struct s3c_hsotg_ep *hs_ep = &hsotg->eps[ep];
 	void __iomem *regs = hsotg->regs;
 	u32 mpsval;
+	u32 mcval;
 	u32 reg;
 
 	if (ep == 0) {
@@ -1725,15 +1743,19 @@ static void s3c_hsotg_set_ep_maxpacket(struct s3c_hsotg *hsotg,
 		mpsval = s3c_hsotg_ep0_mps(mps);
 		if (mpsval > 3)
 			goto bad_mps;
+		hs_ep->ep.maxpacket = mps;
+		hs_ep->mc = 1;
 	} else {
-		if (mps >= DxEPCTL_MPS_LIMIT+1)
+		mpsval = mps & 0x7ff;
+		mcval = ((mps >> 11) & 0x3) + 1;
+		hs_ep->mc = mcval;
+		if (mcval > 3) {
+			hs_ep->mc = 1;
 			goto bad_mps;
-
-		mpsval = mps;
+		}
+		hs_ep->ep.maxpacket = mpsval;
 	}
 
-	hs_ep->ep.maxpacket = mps;
-
 	/*
 	 * update both the in and out endpoint controldir_ registers, even
 	 * if one of the directions may not be in use.
@@ -1915,8 +1937,10 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 	u32 epctl_reg = dir_in ? DIEPCTL(idx) : DOEPCTL(idx);
 	u32 epsiz_reg = dir_in ? DIEPTSIZ(idx) : DOEPTSIZ(idx);
 	u32 ints;
+	u32 ctrl;
 
 	ints = readl(hsotg->regs + epint_reg);
+	ctrl = readl(hsotg->regs + epctl_reg);
 
 	/* Clear endpoint interrupts */
 	writel(ints, hsotg->regs + epint_reg);
@@ -1925,6 +1949,14 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 		__func__, idx, dir_in ? "in" : "out", ints);
 
 	if (ints & DxEPINT_XferCompl) {
+		if (hs_ep->isochronous && hs_ep->interval == 1) {
+			if (ctrl & DxEPCTL_EOFrNum)
+				ctrl |= DxEPCTL_SetEvenFr;
+			else
+				ctrl |= DxEPCTL_SetOddFr;
+			writel(ctrl, hsotg->regs + epctl_reg);
+		}
+
 		dev_dbg(hsotg->dev,
 			"%s: XferCompl: DxEPCTL=0x%08x, DxEPTSIZ=%08x\n",
 			__func__, readl(hsotg->regs + epctl_reg),
@@ -1991,7 +2023,7 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 	if (ints & DxEPINT_Back2BackSetup)
 		dev_dbg(hsotg->dev, "%s: B2BSetup/INEPNakEff\n", __func__);
 
-	if (dir_in) {
+	if (dir_in && !hs_ep->isochronous) {
 		/* not sure if this is important, but we'll clear it anyway */
 		if (ints & DIEPMSK_INTknTXFEmpMsk) {
 			dev_dbg(hsotg->dev, "%s: ep%d: INTknTXFEmpMsk\n",
@@ -2613,17 +2645,25 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	epctrl |= DxEPCTL_SNAK;
 
 	/* update the endpoint state */
-	hs_ep->ep.maxpacket = mps;
+	s3c_hsotg_set_ep_maxpacket(hsotg, hs_ep->index, mps);
 
 	/* default, set to non-periodic */
+	hs_ep->isochronous = 0;
 	hs_ep->periodic = 0;
 	hs_ep->halted = 0;
+	hs_ep->interval = desc->bInterval;
+
+	if (hs_ep->interval > 1 && hs_ep->mc > 1)
+		dev_err(hsotg->dev, "MC > 1 when interval is not 1\n");
 
 	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
 	case USB_ENDPOINT_XFER_ISOC:
-		dev_err(hsotg->dev, "no current ISOC support\n");
-		ret = -EINVAL;
-		goto out;
+		epctrl |= DxEPCTL_EPType_Iso;
+		epctrl |= DxEPCTL_SetEvenFr;
+		hs_ep->isochronous = 1;
+		if (dir_in)
+			hs_ep->periodic = 1;
+		break;
 
 	case USB_ENDPOINT_XFER_BULK:
 		epctrl |= DxEPCTL_EPType_Bulk;
-- 
1.7.9.5

