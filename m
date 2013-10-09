Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3JIHAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:00:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46550 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3JIHAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:00:22 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-1c-5254ff0453a0
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] USB: gadget: s3c-hsotg: add Multi Count support
Date: Wed, 09 Oct 2013 09:00:02 +0200
Message-id: <1381302002-8936-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jQV2W/yFBBlOOCVnMetnOYrFxxnpW
	i4P36y2aF69nszjb9Ibd4vKuOWwWi5a1MlusPXKX3eLB4Z3sDpwe++euYffo27KK0eP4je1M
	Hp83yQWwRHHZpKTmZJalFunbJXBlvNq7jb1gs1rFyT9PWBsYT8h1MXJwSAiYSFx8mtLFyAlk
	iklcuLeerYuRi0NIYDqjxKl1J5ghnHYmiYYXV1lAqtgEdCS2fJ/ACGKLCAhIrH9xiR2kiFng
	L6PE7YedbCAJYQEHiePbjoMVsQioSmzc0Q8W5xVwkfjwaw4zxGYFiTmTbCYwci9gZFjFKJpa
	kFxQnJSea6RXnJhbXJqXrpecn7uJERwsz6R3MK5qsDjEKMDBqMTD+4A/JEiINbGsuDL3EKME
	B7OSCG/eQqAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkG
	RrXqK6J2v18n7XnMLfT4lYzg/59H83z+KS75tmqfQnnWtsdzDk3TKGsqdNHKKGdpn+G67uz0
	e7OubUl+XfN+0Wpd/fCdFQU+jR6e/H9tVn85L/y4/sgR+9gfAkd9u9k3VRs4TnrjnVS1edLD
	xAf6T1L5ejI49vXN1em+f879+7LLeywnPLkUKaHEUpyRaKjFXFScCADE2+TsEgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Multi Count support. It adds few modifications:
- Fix s3c_hsotg_set_ep_maxpacket() function. Field wMaxPacketSize of endpoint
  descriptor is now splitted into maximum packet size value and number of
  additional transaction per microframe.
- Modify s3c_hsotg_write_fifo() function. It actually calculates transfer
  size, taking into account Multi Count value, which indicates number of
  transactions per microframe.
- Fix s3c_hsotg_start_req() function by setting number of packets to Multi
  Count field in DIEPTSIZ register for isochronous endpoints.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---

Hello,
This patch adds Multi Count support. It allows to perform multiple transactions
per microframe. This feature is used by isochronous endpoints, so this patch should
be applied after applying patch named USB: gadget: s3c-hsotg: add isochronous transfers
support.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

 drivers/usb/gadget/s3c-hsotg.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index e3ffbc0..1cacd46 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -83,6 +83,7 @@ struct s3c_hsotg_req;
  * @dir_in: Set to true if this endpoint is of the IN direction, which
  *	    means that it is sending data to the Host.
  * @index: The index for the endpoint registers.
+ * @mc: Multi Count - number of transactions per microframe
  * @interval - Interval for periodic endpoints
  * @name: The name array passed to the USB core.
  * @halted: Set if the endpoint has been halted.
@@ -123,6 +124,7 @@ struct s3c_hsotg_ep {
 
 	unsigned char		dir_in;
 	unsigned char		index;
+	unsigned char		mc;
 	unsigned char		interval;
 
 	unsigned int		halted:1;
@@ -472,6 +474,7 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 	void *data;
 	int can_write;
 	int pkt_round;
+	int max_transfer;
 
 	to_write -= (buf_pos - hs_ep->last_load);
 
@@ -539,8 +542,10 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
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
@@ -555,8 +560,8 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 	 * the transfer to return that it did not run out of fifo space
 	 * doing it.
 	 */
-	if (to_write > hs_ep->ep.maxpacket) {
-		to_write = hs_ep->ep.maxpacket;
+	if (to_write > max_transfer) {
+		to_write = max_transfer;
 
 		/* it's needed only when we do not use dedicated fifos */
 		if (!hsotg->dedicated_fifos)
@@ -569,7 +574,7 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 
 	if (to_write > can_write) {
 		to_write = can_write;
-		pkt_round = to_write % hs_ep->ep.maxpacket;
+		pkt_round = to_write % max_transfer;
 
 		/*
 		 * Round the write down to an
@@ -735,8 +740,16 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
 	else
 		packets = 1;	/* send one packet if length is zero. */
 
+	if (hs_ep->isochronous && length > (hs_ep->mc * hs_ep->ep.maxpacket)) {
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
 
@@ -1723,6 +1736,7 @@ static void s3c_hsotg_set_ep_maxpacket(struct s3c_hsotg *hsotg,
 	struct s3c_hsotg_ep *hs_ep = &hsotg->eps[ep];
 	void __iomem *regs = hsotg->regs;
 	u32 mpsval;
+	u32 mcval;
 	u32 reg;
 
 	if (ep == 0) {
@@ -1731,10 +1745,15 @@ static void s3c_hsotg_set_ep_maxpacket(struct s3c_hsotg *hsotg,
 		if (mpsval > 3)
 			goto bad_mps;
 		hs_ep->ep.maxpacket = mps;
+		hs_ep->mc = 1;
 	} else {
 		mpsval = mps & DxEPCTL_MPS_MASK;
 		if (mpsval > 1024)
 			goto bad_mps;
+		mcval = ((mps >> 11) & 0x3) + 1;
+		hs_ep->mc = mcval;
+		if (mcval > 3)
+			goto bad_mps;
 		hs_ep->ep.maxpacket = mpsval;
 	}
 
@@ -2635,6 +2654,9 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	hs_ep->halted = 0;
 	hs_ep->interval = desc->bInterval;
 
+	if (hs_ep->interval > 1 && hs_ep->mc > 1)
+		dev_err(hsotg->dev, "MC > 1 when interval is not 1\n");
+
 	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
 	case USB_ENDPOINT_XFER_ISOC:
 		epctrl |= DxEPCTL_EPType_Iso;
-- 
1.7.9.5

