Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3LCICO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:02:14 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:43870 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab3LCICG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:02:06 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: peter.chen@freescale.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 1/3 v4] usb: chipidea: Reallocate regmap only if lpm is detected
Date: Tue,  3 Dec 2013 16:01:48 +0800
Message-Id: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb: chipidea: Reallocate regmap only if lpm is detected

The regmap only needs to reallocate if the hw_read on the CAP register shows
lpm is used. Therefore the if() statement check the change.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Acked-by: Peter Chen <peter.chen@freescale.com>
---
 drivers/usb/chipidea/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 5d8981c..9a5ef20 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -208,7 +208,8 @@ static int hw_device_init(struct ci_hdrc *ci, void __iomem *base)
 	reg = hw_read(ci, CAP_HCCPARAMS, HCCPARAMS_LEN) >>
 		__ffs(HCCPARAMS_LEN);
 	ci->hw_bank.lpm  = reg;
-	hw_alloc_regmap(ci, !!reg);
+	if (reg)
+		hw_alloc_regmap(ci, !!reg);
 	ci->hw_bank.size = ci->hw_bank.op - ci->hw_bank.abs;
 	ci->hw_bank.size += OP_LAST;
 	ci->hw_bank.size /= sizeof(u32);
@@ -642,6 +643,10 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 			: CI_ROLE_GADGET;
 	}
 
+	/* only update vbus status for peripheral */
+	if (ci->role == CI_ROLE_GADGET)
+		ci_handle_vbus_change(ci);
+
 	ret = ci_role_start(ci, ci->role);
 	if (ret) {
 		dev_err(dev, "can't start %s role\n", ci_role(ci)->name);
-- 
1.7.10.4

