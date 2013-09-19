Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3ISJvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:51:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58016 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3ISJvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:51:00 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-28-523ac903d824
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3 6/7] USB: gadget: s3c-hsotg: fix clear feature ENDPOINT_HALT
Date: Thu, 19 Sep 2013 11:50:22 +0200
Message-id: <1379584223-15232-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
References: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jQV3mk1ZBBi2neSw2zljPanHwfr1F
	8+L1bBZnm96wW1zeNYfNYtGyVmaLtUfusls8OLyT3YHDY//cNewefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujCsLNrMXvOeuaNz/iK2BcQdnFyMnh4SAicT8RYtZIGwxiQv31rN1
	MXJxCAlMZ5T40/uLGcJpZ5K4vOkZE0gVm4COxJbvExhBbBEBAYn1Ly6xgxQxCzxhlJh65BU7
	SEJYwF/iQ+svIJuDg0VAVWLBAhGQMK+Aq8S/rSuYQcISAgoScybZgIQ5BdwkJp5/DXaEEFDJ
	401f2CYw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxSz6R3MK5qsDjEKMDBqMTD
	G3HBMkiINbGsuDL3EKMEB7OSCO+cQ1ZBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmk
	J5akZqemFqQWwWSZODilGhjtDf0XXkxj9XB3WH5qk2/h8lVBvEeOG6sEvpEs/WhoYPez6vRX
	dVHd1m7vLy4ec7L2PwnxNpj1ND99usg/lr1HU348X3hhu+OGzpVWUwNrVr1ufrJiSRffYnHJ
	t1++G299lB9/WEecN+TdN+1gtU82LxZ5PGsz5gywS5lz39RqleD2pRfm3c1SYinOSDTUYi4q
	TgQAIdRvcCUCAAA=
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
index 23eec8f..5c4c41282 100644
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
+			if (!set && halted) {
 				/*
 				 * If we have request in progress,
 				 * then complete it
-- 
1.7.9.5

