Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3JAH4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 03:56:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64963 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3JAH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 03:56:30 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-69-524a7f68db23
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH V3] USB: gadget: epautoconf: fix ep maxpacket check
Date: Tue, 01 Oct 2013 09:52:56 +0200
Message-id: <1380613976-19959-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t9jQd2Meq8ggz3f9CxmvWxnsdg4Yz2r
	xcH79RbNi9ezWVzeNYfNYtGyVmaLtUfusls8OLyT3YHDY//cNewefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujK6ntQWt6hV7OrkaGO/KdjFyckgImEhcftbKAmGLSVy4t56ti5GL
	Q0hgOqPEgYu9rBBOO5PErqu/wKrYBHQktnyfwAhiiwgISKx/cYkdpIhZ4AKjxPsF69hBEsIC
	zhLzm96ANbAIqEocmH4dLM4r4CpxYsk35i5GDqB1ChJzJtlMYORewMiwilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4QJ5J72Bc1WBxiFGAg1GJh9eg3jNIiDWxrLgy9xCjBAezkghvW4VX
	kBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQbGedLPd2hy
	q4Rnbhbt3+h5QCVa37Hom2d/lNPpZL2MD0vUo1OFdQMD7Zp7JkZIJFZtnsKprLnjUWLJX/v+
	M40Rt3t3b32+YdYKsbhtHA4+66wnz3qpEyJyfF5izu9bye+Mv9tPDqrxdt14wjiXWfDafxem
	WWlby6PuL1W6m+Mo7bOeL5P19i8lluKMREMt5qLiRAAE4z6jDAIAAA==
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

This is third version of my patch. Form last version I have fixed maxpacket
check for bulk transfers which has to have fixed size in each speed (except
for full speed devices, which allows to use one of four available values).
Also improved handling of descriptors which has not set wMaxPacketSize value.
In this case wMaxPacketSize field is set to maximum value, according to
endpoint type and device speed.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:

v3:
- fixed maxpacket check for bulk endpoints
- improved handling of ep descriptors which has not set wMaxPaketSize value

v2: https://lkml.org/lkml/2013/9/30/79
- arrange code for clearity
- fix support for super speed devices

v1: https://lkml.org/lkml/2013/9/27/127

 drivers/usb/gadget/epautoconf.c |   97 ++++++++++++++++++++++++++++++---------
 1 file changed, 75 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/gadget/epautoconf.c b/drivers/usb/gadget/epautoconf.c
index a777f7b..d62e4e9 100644
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
-- 
1.7.9.5

