Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab3I3Joq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:44:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33446 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3I3Jom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:44:42 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-3a-52494808a207
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2] USB: gadget: epautoconf: fix ep maxpacket check
Date: Mon, 30 Sep 2013 11:44:20 +0200
Message-id: <1380534260-24162-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t9jQV0OD88gg9v3LSxmvWxnsdg4Yz2r
	xcH79RbNi9ezWVzeNYfNYtGyVmaLtUfusls8OLyT3YHDY//cNewefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujL3vjrIVtIlXLLzTz9TAuFawi5GTQ0LARGLKqyesELaYxIV769m6
	GLk4hASmM0r8P3WCFcJpZ5J4faoVrIpNQEdiy/cJjCC2iICAxPoXl9hBipgFLjBKvF+wjh0k
	ISzgLLF8yR5mEJtFQFVi39H9bCA2r4CrxLJJn4EGcQCtU5CYM8lmAiP3AkaGVYyiqQXJBcVJ
	6blGesWJucWleel6yfm5mxjBQfJMegfjqgaLQ4wCHIxKPLwWSz2ChFgTy4orcw8xSnAwK4nw
	TnDzDBLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAuIVD
	6Xhv3/2PB10SRKf1fmaYwBbb4eQZltd2rvbBZNlVLa8usC8tvbb59V2dngnPdOpuirzVl5av
	WRbi92X9sqkHy65fWX1l/ct9Uxd8id75g+NObF9H+/ww8cu+q1uf/FDc5Jy77FVt8X1b5zVS
	8jqLj7/1s1l2aJ1qR8e6w8Uf/rzNdc/y+KPEUpyRaKjFXFScCAAlbGZSDgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
This is update for my patch fixing maxpacket check in epautoconfig. Now code
is better arranged for clearity and take into account super speed devices,
as Alan Stern suggested.

This patch fixes validation of maxpacket value given in endpoint descriptor.
Added check of maxpacket for bulk endpoints.

Correct maxpacket value is:

             FULL-SPEED  HIGH-SPEED  SUPER-SPEED
BULK         64          512         1024
INTERRUPT    64          1024        1024
ISOCHRONOUS  1023        1024        1024

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Changelog:

v2:
- arrange code for clearity
- fix support for super speed devices

v1: https://lkml.org/lkml/2013/9/27/127
---
 drivers/usb/gadget/epautoconf.c |   54 +++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index a777f7b..2daf3ba 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -136,25 +136,57 @@ ep_matches (
 	 * the usb spec fixes high speed bulk maxpacket at 512 bytes.
 	 */
 	max = 0x7ff & usb_endpoint_maxp(desc);
+
+	if (ep->maxpacket < max)
+		return 0;
+
 	switch (type) {
-	case USB_ENDPOINT_XFER_INT:
-		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
+	case USB_ENDPOINT_XFER_BULK:
+		/*
+		 * LIMITS:
+		 * full speed:    64 bytes
+		 * high speed:   512 bytes
+		 * super speed: 1024 bytes
+		 */
+		if (max > 1024)
+			return 0;
+		if (!gadget_is_superspeed(gadget) && max > 512)
+			return 0;
 		if (!gadget_is_dualspeed(gadget) && max > 64)
 			return 0;
-		/* FALLTHROUGH */
+		break;
 
-	case USB_ENDPOINT_XFER_ISOC:
-		/* ISO:  limit 1023 bytes full speed, 1024 high/super speed */
-		if (ep->maxpacket < max)
+	case USB_ENDPOINT_XFER_INT:
+		/*
+		 * LIMITS:
+		 * full speed:		64 bytes
+		 * high/super speed:  1024 bytes
+		 * multiple transactions per microframe only for super speed
+		 */
+		 if (max > 1024)
 			return 0;
-		if (!gadget_is_dualspeed(gadget) && max > 1023)
+		 if (!gadget_is_superspeed(gadget)) {
+			if ((desc->wMaxPacketSize & cpu_to_le16(3<<11)))
+				return 0;
+		}
+		if (!gadget_is_dualspeed(gadget) && max > 64)
 			return 0;
+		break;
 
-		/* BOTH:  "high bandwidth" works only at high speed */
-		if ((desc->wMaxPacketSize & cpu_to_le16(3<<11))) {
-			if (!gadget_is_dualspeed(gadget))
+	case USB_ENDPOINT_XFER_ISOC:
+		/*
+		 * LIMITS:
+		 * full speed:	     1023 bytes
+		 * high/super speed: 1024 bytes
+		 * multiple transactions per microframe for high/super speed
+		 */
+		if (max > 1024)
+			return 0;
+		if (!gadget_is_dualspeed(gadget)) {
+			if (max > 1023)
+				return 0;
+			if ((desc->wMaxPacketSize & cpu_to_le16(3<<11)))
 				return 0;
-			/* configure your hardware with enough buffering!! */
 		}
 		break;
 	}
-- 
1.7.9.5

