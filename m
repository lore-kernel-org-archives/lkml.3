Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3I0Ka2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:30:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20497 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab3I0KaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:30:25 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-0b-52455e403a9e
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] USB: gadget: epautoconf: fix ep maxpacket check
Date: Fri, 27 Sep 2013 12:30:08 +0200
Message-id: <1380277808-17736-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t9jQV2HONcgg4kHjCxmvWxnsdg4Yz2r
	xcH79RbNi9ezWVzeNYfNYtGyVmaLtUfusls8OLyT3YHDY//cNewefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujFn3P7IWTOCpeNMyl7WBcQ5nFyMnh4SAicSG/wvYIWwxiQv31rN1
	MXJxCAlMZ5SYevo0WEJIoJ1JYuE+HhCbTUBHYsv3CYwgtoiAgMT6F5fYQRqYBS4wSrxfsA6s
	QVjAQWLZ1adMIDaLgKrEnjMzwBp4BVwlnjx4DhTnANqmIDFnks0ERu4FjAyrGEVTC5ILipPS
	cw31ihNzi0vz0vWS83M3MYJD5JnUDsaVDRaHGAU4GJV4eAUyXIKEWBPLiitzDzFKcDArifAu
	8HQNEuJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cDIqKls
	vl8z0NQjaIGi9KrcULaFWfKOXRzLT3n9u5eT1iXi4X5zzafYeacUVn9V2eC361bky2/1Cxfq
	121iTOo9Jn41b1mv4OdTurXTm+qOe/c2xTSdl5AM2SL0Nl7V5uAUnzf1B0pT5j53EfZ/lhhu
	dPJtiKhdaItpsU/f7aQ8AelIMwbTx0osxRmJhlrMRcWJANDGOCINAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes validation of maxpacket value given in endpoint descriptor.
Added check of maxpacket for bulk endpoints.
Correct maxpacket value is:

             FULL-SPEED  HIGH-SPEED
BULK         64          512
INTERRUPT    64          1024
ISOCHRONOUS  1023        1024

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/gadget/epautoconf.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index a777f7b..35bde34 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -136,16 +136,26 @@ ep_matches (
 	 * the usb spec fixes high speed bulk maxpacket at 512 bytes.
 	 */
 	max = 0x7ff & usb_endpoint_maxp(desc);
+	
+	if (ep->maxpacket < max)
+		return 0;
+	
 	switch (type) {
+	case USB_ENDPOINT_XFER_BULK:
+		/* BULK:  limit 512 high/super speed */
+		if (max > 512)
+			return 0;
+		/* FALLTHROUGH */
+		
 	case USB_ENDPOINT_XFER_INT:
-		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
+		/* BULK/INT:  limit 64 bytes full speed */
 		if (!gadget_is_dualspeed(gadget) && max > 64)
 			return 0;
 		/* FALLTHROUGH */
 
 	case USB_ENDPOINT_XFER_ISOC:
-		/* ISO:  limit 1023 bytes full speed, 1024 high/super speed */
-		if (ep->maxpacket < max)
+		/* INT/ISO:  limit 1023 bytes full speed, 1024 high/super speed */
+		if (max > 1024)
 			return 0;
 		if (!gadget_is_dualspeed(gadget) && max > 1023)
 			return 0;
-- 
1.7.9.5

