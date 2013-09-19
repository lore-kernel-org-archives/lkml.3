Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3ISJux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:50:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57997 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3ISJut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:50:49 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-14-523ac8f8012a
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3 3/7] USB: gadget: s3c-hsotg: fix endpoint interrupts handling
Date: Thu, 19 Sep 2013 11:50:19 +0200
Message-id: <1379584223-15232-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
References: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t9jQd2fJ6yCDPbqW2ycsZ7V4uD9eovm
	xevZLM42vWG3uLxrDpvFomWtzBZrj9xlt3hweCe7A4fH/rlr2D36tqxi9Dh+YzuTx+dNcgEs
	UVw2Kak5mWWpRfp2CVwZjb2fWAs2cVfMfn2YtYFxFWcXIyeHhICJxNaDN1ggbDGJC/fWs3Ux
	cnEICUxnlPh/YScThNPOJNF/exkzSBWbgI7Elu8TGEFsEQEBifUvLrGDFDELPGGUmHrkFZDD
	wSEsECDxpFsEpIZFQFXiyblPrCBhXgFXiaXr60BMCQEFiTmTbEAqOAXcJCaefw12gxBQxeNN
	X9gmMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcTs+kdzCuarA4xCjAwajEwxtx
	wTJIiDWxrLgy9xCjBAezkgjvnENWQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeW
	pGanphakFsFkmTg4pRoYNa9JHWYq7M3NbF3Uxtr/kEPr98PvGZO5atv1d6h0FxoL++1dkuOz
	yu3dr7fR0Qx5j28UfzYV8xEof2ltMo17joSh4Nvp73eERznWnPZ8KeHz8POxw2YHrG6w+60t
	PZVeJn1bK8BCQC/wQE/gJMHpSxtyLxpn+TYmzQp+H75U9k2L+I9Ve24osRRnJBpqMRcVJwIA
	oK0XByMCAAA=
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

