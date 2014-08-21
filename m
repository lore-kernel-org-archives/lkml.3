Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaHUGpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:45:46 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61323 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaHUGpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:45:44 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        srinivas.kandagatla@linaro.org
Subject: [PATCH v3] usb: phy: msm: Make phy_reset clk and reset line optional.
Date: Thu, 21 Aug 2014 07:45:10 +0100
Message-Id: <1408603510-16780-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405628200-21776-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1405628200-21776-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the phy reset clk and reset line optional as this clk
is not available on boards like IFC6410 with APQ8064.

phy-reset clk is only used as argument to the mach level callbacks, so
this patch adds condition before clk_get calls so that the driver
wouldn't fail on SOCs which do not have this support.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
Hi Felipe,

With this new patch now the error message is only printed if the SOC actually supports
the phy reset clk, for SOCs like APQ8064 where there is no phy reset clock or
the callback which takes it there is no point in doing a clk_get call in the first place.

Changes since v2:
	- rebased patch on top of v3.17-rc1


Thanks,
srini

 drivers/usb/phy/phy-msm-usb.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index e4108ee..7f6aa32 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -281,7 +281,7 @@ static int msm_otg_phy_clk_reset(struct msm_otg *motg)
 {
 	int ret = 0;
 
-	if (motg->pdata->phy_clk_reset && motg->phy_reset_clk)
+	if (motg->pdata->phy_clk_reset)
 		ret = motg->pdata->phy_clk_reset(motg->phy_reset_clk);
 	else if (motg->phy_rst)
 		ret = reset_control_reset(motg->phy_rst);
@@ -1554,11 +1554,14 @@ static int msm_otg_probe(struct platform_device *pdev)
 	phy = &motg->phy;
 	phy->dev = &pdev->dev;
 
-	motg->phy_reset_clk = devm_clk_get(&pdev->dev,
+	if (motg->pdata->phy_clk_reset) {
+		motg->phy_reset_clk = devm_clk_get(&pdev->dev,
 					   np ? "phy" : "usb_phy_clk");
-	if (IS_ERR(motg->phy_reset_clk)) {
-		dev_err(&pdev->dev, "failed to get usb_phy_clk\n");
-		motg->phy_reset_clk = NULL;
+
+		if (IS_ERR(motg->phy_reset_clk)) {
+			dev_err(&pdev->dev, "failed to get usb_phy_clk\n");
+			return PTR_ERR(motg->phy_reset_clk);
+		}
 	}
 
 	motg->clk = devm_clk_get(&pdev->dev, np ? "core" : "usb_hs_clk");
-- 
1.9.1

