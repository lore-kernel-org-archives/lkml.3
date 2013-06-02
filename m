Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3FBGDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:03:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35300 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3FBGCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:02:39 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 2/2] mfd: ssbi: Use devm_* to simplify code
Date: Sat,  1 Jun 2013 23:02:35 -0700
Message-Id: <1370152955-14841-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370152955-14841-1-git-send-email-sboyd@codeaurora.org>
References: <1370152955-14841-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource and devm_kzalloc to simplify error
paths and reduce lines of code.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/mfd/ssbi.c | 69 +++++++++---------------------------------------------
 1 file changed, 11 insertions(+), 58 deletions(-)

diff --git a/drivers/mfd/ssbi.c b/drivers/mfd/ssbi.c
index e561d3b..102a2284 100644
--- a/drivers/mfd/ssbi.c
+++ b/drivers/mfd/ssbi.c
@@ -268,35 +268,23 @@ static int ssbi_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct resource *mem_res;
 	struct ssbi *ssbi;
-	int ret = 0;
 	const char *type;
 
-	ssbi = kzalloc(sizeof(struct ssbi), GFP_KERNEL);
-	if (!ssbi) {
-		pr_err("can not allocate ssbi_data\n");
+	ssbi = devm_kzalloc(&pdev->dev, sizeof(*ssbi), GFP_KERNEL);
+	if (!ssbi)
 		return -ENOMEM;
-	}
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem_res) {
-		pr_err("missing mem resource\n");
-		ret = -EINVAL;
-		goto err_get_mem_res;
-	}
+	ssbi->base = devm_ioremap_resource(&pdev->dev, mem_res);
+	if (IS_ERR(ssbi->base))
+		return PTR_ERR(ssbi->base);
 
-	ssbi->base = ioremap(mem_res->start, resource_size(mem_res));
-	if (!ssbi->base) {
-		pr_err("ioremap of 0x%p failed\n", (void *)mem_res->start);
-		ret = -EINVAL;
-		goto err_ioremap;
-	}
 	platform_set_drvdata(pdev, ssbi);
 
 	type = of_get_property(np, "qcom,controller-type", NULL);
 	if (type == NULL) {
-		pr_err("Missing qcom,controller-type property\n");
-		ret = -EINVAL;
-		goto err_ssbi_controller;
+		dev_err(&pdev->dev, "Missing qcom,controller-type property\n");
+		return -EINVAL;
 	}
 	dev_info(&pdev->dev, "SSBI controller type: '%s'\n", type);
 	if (strcmp(type, "ssbi") == 0)
@@ -306,9 +294,8 @@ static int ssbi_probe(struct platform_device *pdev)
 	else if (strcmp(type, "pmic-arbiter") == 0)
 		ssbi->controller_type = MSM_SBI_CTRL_PMIC_ARBITER;
 	else {
-		pr_err("Unknown qcom,controller-type\n");
-		ret = -EINVAL;
-		goto err_ssbi_controller;
+		dev_err(&pdev->dev, "Unknown qcom,controller-type\n");
+		return -EINVAL;
 	}
 
 	if (ssbi->controller_type == MSM_SBI_CTRL_PMIC_ARBITER) {
@@ -321,29 +308,7 @@ static int ssbi_probe(struct platform_device *pdev)
 
 	spin_lock_init(&ssbi->lock);
 
-	ret = of_platform_populate(np, NULL, NULL, &pdev->dev);
-	if (ret)
-		goto err_ssbi_controller;
-
-	return 0;
-
-err_ssbi_controller:
-	platform_set_drvdata(pdev, NULL);
-	iounmap(ssbi->base);
-err_ioremap:
-err_get_mem_res:
-	kfree(ssbi);
-	return ret;
-}
-
-static int ssbi_remove(struct platform_device *pdev)
-{
-	struct ssbi *ssbi = platform_get_drvdata(pdev);
-
-	platform_set_drvdata(pdev, NULL);
-	iounmap(ssbi->base);
-	kfree(ssbi);
-	return 0;
+	return of_platform_populate(np, NULL, NULL, &pdev->dev);
 }
 
 static struct of_device_id ssbi_match_table[] = {
@@ -354,25 +319,13 @@ MODULE_DEVICE_TABLE(of, ssbi_match_table);
 
 static struct platform_driver ssbi_driver = {
 	.probe		= ssbi_probe,
-	.remove		= ssbi_remove,
 	.driver		= {
 		.name	= "ssbi",
 		.owner	= THIS_MODULE,
 		.of_match_table = ssbi_match_table,
 	},
 };
-
-static int __init ssbi_init(void)
-{
-	return platform_driver_register(&ssbi_driver);
-}
-module_init(ssbi_init);
-
-static void __exit ssbi_exit(void)
-{
-	platform_driver_unregister(&ssbi_driver);
-}
-module_exit(ssbi_exit)
+module_platform_driver(ssbi_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION("1.0");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

