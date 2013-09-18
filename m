Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3IRKXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:23:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16341 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3IRKWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:22:04 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-1d-52397ecb8ffc
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 3/6] USB: gadget: s3c-hsotg: fix endpoint interrupts handling
Date: Wed, 18 Sep 2013 12:21:32 +0200
Message-id: <1379499695-5279-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
References: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jAd3TdZZBBm+X8lhsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGY29n1gLNnFXzH59mLWBcRVnFyMnh4SAicTXhg9MELaYxIV769m6
	GLk4hAQWMUrs6t3HDuG0M0ks/djLBlLFJqAjseX7BEYQW0RAQGL9i0tgRcwCTxglph55xQ6S
	EBYIkLh5ZiFQAwcHi4CqxPrHbiBhXgEXiTl919lBwhICChJzJtmAhDkFXCV2/bnDCmILAZXM
	7J/HOoGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4JB6JrWDcWWDxSFGAQ5GJR7e
	C+UWQUKsiWXFlbmHGCU4mJVEeF3KLIOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhP
	LEnNTk0tSC2CyTJxcEo1MB5Y+USEp1+j79iRN8qvD4TUqc571/N5wQPGkrdnHwmVd++bmNnB
	L8+n/21W3n2rr5fX3z1fo36zKubELs2jE0T1D7b16Gvsv/533de4fc80/1Ztna7QoKs25wfL
	k9KVl9enMjjF3V2/IfDWHIafEVxP+uJ/bXTQCGLc+MWkvTdv8e0PU/Sf1MYqsRRnJBpqMRcV
	JwIAM9xDKSUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When s3c_hsotg_trytx is called for ep without enqueued request, interrupts
for this ep are disabled, to prevent interrupt flooding. Interrupts are
enabled when new request for this ep is starting.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 4fe2f9e..3024685d 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -823,6 +823,9 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
 
 	dev_dbg(hsotg->dev, "%s: DxEPCTL=0x%08x\n",
 		__func__, readl(hsotg->regs + epctrl_reg));
+
+	/* enable ep interrupts */
+	s3c_hsotg_ctrl_epint(hsotg, hs_ep->index, hs_ep->dir_in, 1);
 }
 
 /**
@@ -1791,8 +1794,16 @@ static int s3c_hsotg_trytx(struct s3c_hsotg *hsotg,
 {
 	struct s3c_hsotg_req *hs_req = hs_ep->req;
 
-	if (!hs_ep->dir_in || !hs_req)
+	if (!hs_ep->dir_in || !hs_req) {
+		/**
+		 * if request is not enqueued, we disable interrupts
+		 * for endpoints, excepting ep0
+		 */
+		if (hs_ep->index != 0)
+			s3c_hsotg_ctrl_epint(hsotg, hs_ep->index,
+					     hs_ep->dir_in, 0);
 		return 0;
+	}
 
 	if (hs_req->req.actual < hs_req->req.length) {
 		dev_dbg(hsotg->dev, "trying to write more for ep%d\n",
-- 
1.7.9.5

