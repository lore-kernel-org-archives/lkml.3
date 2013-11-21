Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3KUMuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:50:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59447 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3KUMuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:50:04 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-52-528e017793a4
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] USB: gadget: s3c-hsotg: fix disconnect handling
Date: Thu, 21 Nov 2013 13:49:18 +0100
Message-id: <1385038158-20151-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385038158-20151-1-git-send-email-r.baldyga@samsung.com>
References: <1385038158-20151-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jQd0Kxr4ggwPt7BazXrazWGycsZ7V
	4uD9eovmxevZLM42vWG3uLxrDpvFomWtzBZrj9xlt3hweCe7A6fH/rlr2D36tqxi9Dh+YzuT
	x+dNcgEsUVw2Kak5mWWpRfp2CVwZtz5vYCm4yV+x6NBh5gbG6bxdjJwcEgImEjtXNDBC2GIS
	F+6tZ+ti5OIQEpjOKDF9wnQmCKedSeLU403sIFVsAjoSW75PAOsQERCQWP/iEjtIEbPAX0aJ
	2w872UASwgIuEi//rgEq4uBgEVCVuPsxDMTkFXCV2LZBCMSUEFCQmDPJBqSYU8BNYuqpp2DT
	hYAqtp5+zDKBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODQeia9g3FVg8UhRgEO
	RiUe3gdPe4KEWBPLiitzDzFKcDArifBGfuwNEuJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6
	UEggPbEkNTs1tSC1CCbLxMEp1cDIyd23Oix3VjKra/ylCYv38HR8TNE75Jzm9engjSWCB4X6
	JePaz3+d/HTFBq+MyZyiR74ufPrhkKr62cDYf8K9BQk34iXPiZgwO21tC181yX7bBZvs2hV5
	kWaX2t/NU3vicpeJZacNr9GUjgid8oy285vqWWKCY+xlL2ycw6Mk/+v+BZWUsAYlluKMREMt
	5qLiRAAx2d/6KQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves s3c_hsotg_disconnect function call from USBSusp interrupt
handler to SET_ADDRESS request handler.

It's because disconnected state can't be detected directly, because this
hardware doesn't support Disconnected interrupt for device mode. For both
Suspend and Disconnect events there is one interrupt USBSusp, but calling
s3c_hsotg_disconnect from this interrupt handler causes config reset in
composite layer, which is not undesirable for Suspended state.

For this reason s3c_hsotg_disconnect is called from SET_ADDRESS request
handler, which occurs always after disconnection, so we do disconnect
immediately before we are connected again. It's probably only way we
can do handle disconnection correctly.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index f709b13..1a74a3d 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -1180,6 +1180,7 @@ static int s3c_hsotg_process_req_feature(struct s3c_hsotg *hsotg,
 }
 
 static void s3c_hsotg_enqueue_setup(struct s3c_hsotg *hsotg);
+static void s3c_hsotg_disconnect(struct s3c_hsotg *hsotg);
 
 /**
  * s3c_hsotg_process_control - process a control request
@@ -1221,6 +1222,7 @@ static void s3c_hsotg_process_control(struct s3c_hsotg *hsotg,
 	if ((ctrl->bRequestType & USB_TYPE_MASK) == USB_TYPE_STANDARD) {
 		switch (ctrl->bRequest) {
 		case USB_REQ_SET_ADDRESS:
+			s3c_hsotg_disconnect(hsotg);
 			dcfg = readl(hsotg->regs + DCFG);
 			dcfg &= ~DCFG_DevAddr_MASK;
 			dcfg |= ctrl->wValue << DCFG_DevAddr_SHIFT;
@@ -2535,7 +2537,6 @@ irq_retry:
 		writel(GINTSTS_USBSusp, hsotg->regs + GINTSTS);
 
 		call_gadget(hsotg, suspend);
-		s3c_hsotg_disconnect(hsotg);
 	}
 
 	if (gintsts & GINTSTS_WkUpInt) {
-- 
1.7.9.5

