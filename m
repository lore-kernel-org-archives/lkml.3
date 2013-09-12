Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3ILOTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:19:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12751 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3ILOTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:19:50 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-de-5231cd851bba
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 6/6] USB: gadget: s3c-hsotg: fix clear feature ENDPOINT_HALT
Date: Thu, 12 Sep 2013 16:18:52 +0200
Message-id: <1378995532-32142-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
References: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQd3Ws4ZBBguuiVpsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGTdX3GAvWChQ0XhvBWsD4xeeLkZODgkBE4nOQ/fZIGwxiQv31gPZ
	XBxCAtMZJXpWrIZyupgkPp3ewwhSxSagI7Hl+wQwW0RAQGL9i0vsIEXMAk8YJaYeecUOkhAW
	8JH4/uA7mM0ioCqx8dxzZhCbV8BV4vGub6wQ6+Qlnt7vA1vNKeAm0bcbZDUH0DZXiYlbUyYw
	8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxUz6R2MK5ssDjEKMDBqMTD2zHLIEiI
	NbGsuDL3EKMEB7OSCO/niYZBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqem
	FqQWwWSZODilGhhL1i1zO8H0ruX3MmMOPRedOSv+crOtKKvn3fR/ouObvNnWxSbrm56v5fVK
	D+noPnrT++iZhW4X3RZMUW0Wip7WxH9r8bHyUgXeKSpaXoETjyRHtfEoHGVNPrJpvjTbCd3Z
	7T4+vs6nxfcoRbwv2POC94NieUJl5JHmnOaXr/pntAZvf2vzu0+JpTgj0VCLuag4EQB4aEze
	JgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two fixes:
- Property halted of s3c_hsotg_ep structure is actually changed when halt is
  set/cleared.
- All requests for endpoint are completed when it was halted, and the halt was
  cleared by CLEAR_FEATURE, but not when new state is same as previous.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 4fb2199..db4da58 100644
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
+			 * we have to complete all requests for ep if it was halted,
+			 * and the halt was cleared by CLEAR_FEATURE
+			 */
+
+			if (!set || halted) {
 				/*
 				 * If we have request in progress,
 				 * then complete it
@@ -2603,6 +2611,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 
 	/* default, set to non-periodic */
 	hs_ep->periodic = 0;
+	hs_ep->halted = 0;
 
 	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
 	case USB_ENDPOINT_XFER_ISOC:
@@ -2798,6 +2807,8 @@ static int s3c_hsotg_ep_sethalt(struct usb_ep *ep, int value)
 
 	writel(epctl, hs->regs + epreg);
 
+	hs_ep->halted = value;
+
 	return 0;
 }
 
-- 
1.7.9.5

