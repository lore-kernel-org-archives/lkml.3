Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab3JIGml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:42:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:20023 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3JIGmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:42:37 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-ff-5254fac42e9d
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3] USB: gadget: s3c-hsotg: add isochronous transfers support
Date: Wed, 09 Oct 2013 08:41:57 +0200
Message-id: <1381300917-7468-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAd0jv0KCDLouW1vMetnOYrFxxnpW
	i4P36y2aF69nszjb9Ibd4vKuOWwWi5a1MlusPXKX3eLB4Z3sDpwe++euYffo27KK0eP4je1M
	Hp83yQWwRHHZpKTmZJalFunbJXBlTFsgXHBUteLlmt+MDYw75boYOTkkBEwkdkw5zghhi0lc
	uLeerYuRi0NIYBGjxJ/+E0wQTjuTxO9N+9lBqtgEdCS2fJ8A1iEiICCx/sUldpAiZoG/jBK3
	H3aygSSEBXwlnty/ygxiswioSjx7eBLM5hVwkWjt6WPtYuQAWqcgMWeSzQRG7gWMDKsYRVML
	kguKk9JzjfSKE3OLS/PS9ZLzczcxgoPlmfQOxlUNFocYBTgYlXh4H/CHBAmxJpYVV+YeYpTg
	YFYS4c1bCBTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXA
	2P0ocr3D2nebPgYoBq05+LRT+fmzTZ+TLWXcTixcnXLoTeeOvxOXC3WcPnPst66AZHTDx/vs
	y4LuBqVtOXv5YwurgAtP70QV0QNiS22PpE04Ost9fkasc5zJorep/1nS8lf9ZTiW4hhzr1z/
	p8YcI91j7Mz3517N+rb9hZfO4idFvw79V5ohsEiJpTgj0VCLuag4EQCCX4PqEgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds isochronous transfer support. It adds few modifications:
- Modify s3c_hsotg_epint() function. Some interrupts are ignored for
  isochronous endpoints, (e.g. INTknTXFEmpMsk) becouse isochronous request is
  always transfered in single transaction, which ends with XferCompl interrupt.
- Add Odd/Even microframe toggle to allow data transfering in each microframe
  in s3c_hsotg_epint() function.
- Fix s3c_hsotg_ep_enable() function by supporting isochronous endpoint type.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Hello,
This is third version of patch adding isochronous transfers support in
s3c-hsotg driver. From last version I have separated one bugfix for
s3c_hsotg_set_ep_maxpacket() function into another patch. I also have splitted
modifications into two patches: this patch, adding isochronous support base, and
the second patch adding support for multiple transfers per microframe, which will
be sent soon.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:
v3:
- separated bugfix into another patch
- moved additional functionality into another patch

v2: https://lkml.org/lkml/2013/9/24/154
- moved bugfix affecting to the other features to separated patch
- changed conditions order in request length checking in s3c_hsotg_start_req
  function, as Bartlomiej Zolnierkiewicz suggested
- fixed typos

v1: https://lkml.org/lkml/2013/9/23/72
- initial proposal


 drivers/usb/gadget/s3c-hsotg.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 139122a..e3ffbc0 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -83,9 +83,11 @@ struct s3c_hsotg_req;
  * @dir_in: Set to true if this endpoint is of the IN direction, which
  *	    means that it is sending data to the Host.
  * @index: The index for the endpoint registers.
+ * @interval - Interval for periodic endpoints
  * @name: The name array passed to the USB core.
  * @halted: Set if the endpoint has been halted.
  * @periodic: Set if this is a periodic ep, such as Interrupt
+ * @isochronous: Set if this is a isochronous ep
  * @sent_zlp: Set if we've sent a zero-length packet.
  * @total_data: The total number of data bytes done.
  * @fifo_size: The size of the FIFO (for periodic IN endpoints)
@@ -121,9 +123,11 @@ struct s3c_hsotg_ep {
 
 	unsigned char		dir_in;
 	unsigned char		index;
+	unsigned char		interval;
 
 	unsigned int		halted:1;
 	unsigned int		periodic:1;
+	unsigned int		isochronous:1;
 	unsigned int		sent_zlp:1;
 
 	char			name[10];
@@ -1915,8 +1919,10 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 	u32 epctl_reg = dir_in ? DIEPCTL(idx) : DOEPCTL(idx);
 	u32 epsiz_reg = dir_in ? DIEPTSIZ(idx) : DOEPTSIZ(idx);
 	u32 ints;
+	u32 ctrl;
 
 	ints = readl(hsotg->regs + epint_reg);
+	ctrl = readl(hsotg->regs + epctl_reg);
 
 	/* Clear endpoint interrupts */
 	writel(ints, hsotg->regs + epint_reg);
@@ -1925,6 +1931,14 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
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
@@ -1991,7 +2005,7 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 	if (ints & DxEPINT_Back2BackSetup)
 		dev_dbg(hsotg->dev, "%s: B2BSetup/INEPNakEff\n", __func__);
 
-	if (dir_in) {
+	if (dir_in && !hs_ep->isochronous) {
 		/* not sure if this is important, but we'll clear it anyway */
 		if (ints & DIEPMSK_INTknTXFEmpMsk) {
 			dev_dbg(hsotg->dev, "%s: ep%d: INTknTXFEmpMsk\n",
@@ -2616,14 +2630,19 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	s3c_hsotg_set_ep_maxpacket(hsotg, hs_ep->index, mps);
 
 	/* default, set to non-periodic */
+	hs_ep->isochronous = 0;
 	hs_ep->periodic = 0;
 	hs_ep->halted = 0;
+	hs_ep->interval = desc->bInterval;
 
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

