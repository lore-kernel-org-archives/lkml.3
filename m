Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3KKNpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:45:09 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54330 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab3KKNnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:43:43 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: alexander.shishkin@linux.intel.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 2/4] usb: chipidea: msm: Add device tree support
Date: Mon, 11 Nov 2013 15:35:35 +0200
Message-Id: <1384176937-1658-3-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Allows controller to be specified via device tree.
Pass PHY phandle specified in DT to core driver.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: devicetree@vger.kernel.org
---
 drivers/usb/chipidea/ci_hdrc_msm.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index 2d51d85..747d6c1 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -57,9 +57,21 @@ static struct ci_hdrc_platform_data ci_hdrc_msm_platdata = {
 static int ci_hdrc_msm_probe(struct platform_device *pdev)
 {
 	struct platform_device *plat_ci;
+	struct usb_phy *phy;
 
 	dev_dbg(&pdev->dev, "ci_hdrc_msm_probe\n");
 
+	/*
+	 * OTG(PHY) driver takes care of PHY initialization, clock management,
+	 * powering up VBUS, mapping of registers address space and power
+	 * management.
+	 */
+	phy = devm_usb_get_phy_by_phandle(&pdev->dev, "usb-phy", 0);
+	if (IS_ERR(phy))
+		return PTR_ERR(phy);
+	else
+		ci_hdrc_msm_platdata.phy = phy;
+
 	plat_ci = ci_hdrc_add_device(&pdev->dev,
 				pdev->resource, pdev->num_resources,
 				&ci_hdrc_msm_platdata);
@@ -86,10 +98,19 @@ static int ci_hdrc_msm_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct of_device_id msm_ci_dt_match[] = {
+	{ .compatible = "qcom,ci-hdrc", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, msm_ci_dt_match);
+
 static struct platform_driver ci_hdrc_msm_driver = {
 	.probe = ci_hdrc_msm_probe,
 	.remove = ci_hdrc_msm_remove,
-	.driver = { .name = "msm_hsusb", },
+	.driver = {
+		.name = "msm_hsusb",
+		.of_match_table = msm_ci_dt_match,
+	},
 };
 
 module_platform_driver(ci_hdrc_msm_driver);
-- 
1.7.9.5

