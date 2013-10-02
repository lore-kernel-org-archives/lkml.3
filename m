Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3JBKLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:11:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65184 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3JBKK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:10:59 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-40-524bf0e669f6
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v4] USB: gadget: epautoconf: fix ep maxpacket check
Date: Wed, 02 Oct 2013 12:09:23 +0200
Message-id: <1380708563-10622-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t9jAd1nH7yDDE4eMbOY9bKdxWLjjPWs
	Fgfv11s0L17PZnF51xw2i0XLWpkt1h65y27x4PBOdgcOj/1z17B79G1Zxehx/MZ2Jo/Pm+QC
	WKK4bFJSczLLUov07RK4Mu49vM9WcEGz4uAlgQbGG/JdjJwcEgImErcXN7NA2GISF+6tZ+ti
	5OIQEljEKDFh9m1GCKedSeL9g4OMIFVsAjoSW75PALNFBAQk1r+4xA5SxCxwgVHi/YJ17CAJ
	YQFnidU7F4IVsQioSpx4u4ENxOYVcJW4/X0mUJwDaJ2CxJxJNhMYuRcwMqxiFE0tSC4oTkrP
	NdQrTswtLs1L10vOz93ECA6RZ1I7GFc2WBxiFOBgVOLhlXjoFSTEmlhWXJl7iFGCg1lJhPfZ
	S+8gId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYy1alb7
	/yYUs9/rvuhe5PhD5aT/7ZD6Q9YXSsyW3Tq4+tBe+abNnf6W7v9eOd/r2qh56+qxJuMpV7ZH
	WYiy90nKrwnZfV0vVkRiu2RD4HP7ayZ+EbMvB7QaaJpaRRg2zd7TtHFv/bsdTC8mfDnK7LI/
	c3Zy/ttnn9q1/K732V9VLbHZrit/ulGJpTgj0VCLuag4EQDlOZRYDQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix validation of maxpacket value given in endpoint descriptor.
Add check of maxpacket for bulk endpoints. If maxpacket is not set in
descriptor, it's set to maximum value for given type on endpoint in used
speed.

Correct maxpacket value is:

             FULL-SPEED        HIGH-SPEED   SUPER-SPEED
BULK         8, 16, 32, 64     512          1024
INTERRUPT    1..64             1..1024      1..1024
ISOCHRONOUS  1..1023           1..1024      1..1024

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---

Hello,

This is fourth version of my patch. From last version I have removed
code reporting full speed bulk maxpacket because it's not needed since
maxpacket check for all speeds is performed before.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:

v4:
- removed unneded code reporting full speed bulk maxpacket

v3: https://lkml.org/lkml/2013/10/1/38
- fixed maxpacket check for bulk endpoints
- improved handling of ep descriptors which has not set wMaxPaketSize value

v2: https://lkml.org/lkml/2013/9/30/79
- arrange code for clearity
- fix support for super speed devices

v1: https://lkml.org/lkml/2013/9/27/127


 drivers/usb/gadget/epautoconf.c |  107 +++++++++++++++++++++++++++------------
 1 file changed, 75 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index a777f7b..7245e6d 100644
--- a/drivers/usb/gadget/epautoconf.c
+++ b/drivers/usb/gadget/epautoconf.c
@@ -124,37 +124,90 @@ ep_matches (
 
 	}
 
+	max = 0x7ff & usb_endpoint_maxp(desc);
+
 	/*
-	 * If the protocol driver hasn't yet decided on wMaxPacketSize
-	 * and wants to know the maximum possible, provide the info.
+	 * Test if maxpacket given in descriptor isn't greater than maximum
+	 * packet size for this endpoint
 	 */
-	if (desc->wMaxPacketSize == 0)
-		desc->wMaxPacketSize = cpu_to_le16(ep->maxpacket);
+	if (ep->maxpacket < max)
+		return 0;
 
-	/* endpoint maxpacket size is an input parameter, except for bulk
-	 * where it's an output parameter representing the full speed limit.
-	 * the usb spec fixes high speed bulk maxpacket at 512 bytes.
+	/*
+	 * Test if ep supports maxpacket size set in descriptor.
+	 * If the protocol driver hasn't yet decided on wMaxPacketSize
+	 * (when wMaxPacketSize == 0) and wants to know the maximum possible,
+	 * provide the info.
 	 */
-	max = 0x7ff & usb_endpoint_maxp(desc);
 	switch (type) {
+	case USB_ENDPOINT_XFER_BULK:
+		/*
+		 * LIMITS:
+		 * full speed:    64 bytes
+		 * high speed:   512 bytes
+		 * super speed: 1024 bytes
+		 */
+		if (max == 0) {
+			if (gadget_is_superspeed(gadget))
+				desc->wMaxPacketSize = cpu_to_le16(1024);
+			else if (gadget_is_dualspeed(gadget))
+				desc->wMaxPacketSize = cpu_to_le16(512);
+			else
+				desc->wMaxPacketSize = cpu_to_le16(64);
+		} else {
+			if (max > 1024)
+				return 0;
+			if (!gadget_is_superspeed(gadget) && max > 512)
+				return 0;
+			if (!gadget_is_dualspeed(gadget) && max > 64)
+				return 0;
+		}
+		break;
+
 	case USB_ENDPOINT_XFER_INT:
-		/* INT:  limit 64 bytes full speed, 1024 high/super speed */
-		if (!gadget_is_dualspeed(gadget) && max > 64)
-			return 0;
-		/* FALLTHROUGH */
+		/*
+		 * LIMITS:
+		 * full speed:		64 bytes
+		 * high/super speed:  1024 bytes
+		 * multiple transactions per microframe only for super speed
+		 */
+		if (max == 0) {
+			if (gadget_is_dualspeed(gadget))
+				desc->wMaxPacketSize = cpu_to_le16(1024);
+			else
+				desc->wMaxPacketSize = cpu_to_le16(64);
+		} else {
+			if (max > 1024)
+				return 0;
+			if (!gadget_is_superspeed(gadget))
+				if ((desc->wMaxPacketSize & cpu_to_le16(3<<11)))
+					return 0;
+			if (!gadget_is_dualspeed(gadget) && max > 64)
+				return 0;
+		}
+		break;
 
 	case USB_ENDPOINT_XFER_ISOC:
-		/* ISO:  limit 1023 bytes full speed, 1024 high/super speed */
-		if (ep->maxpacket < max)
-			return 0;
-		if (!gadget_is_dualspeed(gadget) && max > 1023)
-			return 0;
-
-		/* BOTH:  "high bandwidth" works only at high speed */
-		if ((desc->wMaxPacketSize & cpu_to_le16(3<<11))) {
-			if (!gadget_is_dualspeed(gadget))
+		/*
+		 * LIMITS:
+		 * full speed:	     1023 bytes
+		 * high/super speed: 1024 bytes
+		 * multiple transactions per microframe for high/super speed
+		 */
+		if (max == 0) {
+			if (gadget_is_dualspeed(gadget))
+				desc->wMaxPacketSize = cpu_to_le16(1024);
+			else
+				desc->wMaxPacketSize = cpu_to_le16(1023);
+		} else {
+			if (max > 1024)
 				return 0;
-			/* configure your hardware with enough buffering!! */
+			if (!gadget_is_dualspeed(gadget)) {
+				if (max > 1023)
+					return 0;
+				if ((desc->wMaxPacketSize & cpu_to_le16(3<<11)))
+					return 0;
+			}
 		}
 		break;
 	}
@@ -175,16 +228,6 @@ ep_matches (
 			return 0;
 		desc->bEndpointAddress |= gadget->out_epnum;
 	}
-
-	/* report (variable) full speed bulk maxpacket */
-	if ((USB_ENDPOINT_XFER_BULK == type) && !ep_comp) {
-		int size = ep->maxpacket;
-
-		/* min() doesn't work on bitfields with gcc-3.5 */
-		if (size > 64)
-			size = 64;
-		desc->wMaxPacketSize = cpu_to_le16(size);
-	}
 	ep->address = desc->bEndpointAddress;
 	return 1;
 }
-- 
1.7.9.5

