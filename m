Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3IRKWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:22:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27565 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3IRKWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:22:15 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-ec-52397ed5aea9
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 6/6] USB: gadget: s3c-hsotg: fix clear feature ENDPOINT_HALT
Date: Wed, 18 Sep 2013 12:21:35 +0200
Message-id: <1379499695-5279-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
References: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jAd2rdZZBBstviFlsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGQ/O7GYveMtd8fhfB1sD4zbOLkZODgkBE4kT52exQ9hiEhfurWfr
	YuTiEBJYxCix4uFDZginnUli+4xZLCBVbAI6Elu+T2AEsUUEBCTWv7jEDlLELPCEUWLqkVdg
	o4QF/CUW39nCCmKzCKhK/Hp3GKyZV8BF4ufeZiCbA2idgsScSTYgYU4BV4ldf+6AlQsBlczs
	n8c6gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgoHomvYNxVYPFIUYBDkYlHt4L
	5RZBQqyJZcWVuYcYJTiYlUR4Xcosg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8s
	Sc1OTS1ILYLJMnFwSjUwBjanqRtkbzCe7aPJ4fVR937nBEkXlTrxRGbDn6sTpz5cbm61bNvd
	2MpV9yuk/vkYV0tm7Uyf82iCS0fXlMb7F9v6tmgmOPeLiITLsQeu8Xo75/bx1EvLXOJMq5fP
	St+w+Sm3Y9RSfeElM3lOZBdXxf713bxxcjHzzIX7mEVv22VcF9nbPpVViaU4I9FQi7moOBEA
	/Ch09SYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All requests for endpoint are completed when it was halted and the halt was
cleared by CLEAR_FEATURE, but not when new state is same as previous.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 23eec8f..84c302a 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -1097,6 +1097,7 @@ static int s3c_hsotg_process_req_feature(struct s3c_hsotg *hsotg,
 	bool set = (ctrl->bRequest == USB_REQ_SET_FEATURE);
 	struct s3c_hsotg_ep *ep;
 	int ret;
+	bool halted;
 
 	dev_dbg(hsotg->dev, "%s: %s_FEATURE\n",
 		__func__, set ? "SET" : "CLEAR");
@@ -1111,6 +1112,8 @@ static int s3c_hsotg_process_req_feature(struct s3c_hsotg *hsotg,
 
 		switch (le16_to_cpu(ctrl->wValue)) {
 		case USB_ENDPOINT_HALT:
+			halted = ep->halted;
+
 			s3c_hsotg_ep_sethalt(&ep->ep, set);
 
 			ret = s3c_hsotg_send_reply(hsotg, ep0, NULL, 0);
@@ -1120,7 +1123,12 @@ static int s3c_hsotg_process_req_feature(struct s3c_hsotg *hsotg,
 				return ret;
 			}
 
-			if (!set) {
+			/*
+			 * we have to complete all requests for ep if it was
+			 * halted, and the halt was cleared by CLEAR_FEATURE
+			 */
+
+			if (!set || halted) {
 				/*
 				 * If we have request in progress,
 				 * then complete it
-- 
1.7.9.5

