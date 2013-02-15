Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161812Ab3BONHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:07:48 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:61504 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161302Ab3BOM5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:25 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: [PATCH 02/35] mfd: ab8500-gpadc: Allow tvout regulator to be missing
Date: Fri, 15 Feb 2013 12:56:33 +0000
Message-Id: <1360933026-30325-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org
---
 drivers/mfd/ab8500-gpadc.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 9ed3afc..34c1d04 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -140,6 +140,9 @@ struct ab8500_gpadc *ab8500_gpadc_get(char *name)
 {
 	struct ab8500_gpadc *gpadc;
 
+	if (list_empty(&ab8500_gpadc_list))
+		return NULL;
+
 	list_for_each_entry(gpadc, &ab8500_gpadc_list, node) {
 		if (!strcmp(name, dev_name(gpadc->dev)))
 		    return gpadc;
@@ -587,7 +590,8 @@ static int ab8500_gpadc_runtime_suspend(struct device *dev)
 {
 	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
 
-	regulator_disable(gpadc->regu);
+	if (gpadc->regu)
+		regulator_disable(gpadc->regu);
 	return 0;
 }
 
@@ -595,7 +599,8 @@ static int ab8500_gpadc_runtime_resume(struct device *dev)
 {
 	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
 
-	regulator_enable(gpadc->regu);
+	if (gpadc->regu)
+		regulator_enable(gpadc->regu);
 	return 0;
 }
 
@@ -670,9 +675,8 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 	/* VTVout LDO used to power up ab8500-GPADC */
 	gpadc->regu = regulator_get(&pdev->dev, "vddadc");
 	if (IS_ERR(gpadc->regu)) {
-		ret = PTR_ERR(gpadc->regu);
-		dev_err(gpadc->dev, "failed to get vtvout LDO\n");
-		goto fail_irq;
+		dev_warn(gpadc->dev, "failed to get vtvout LDO\n");
+		gpadc->regu = NULL;
 	}
 
 	platform_set_drvdata(pdev, gpadc);
@@ -688,8 +692,6 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 	list_add_tail(&gpadc->node, &ab8500_gpadc_list);
 	dev_dbg(gpadc->dev, "probe success\n");
 	return 0;
-fail_irq:
-	free_irq(gpadc->irq, gpadc);
 fail:
 	kfree(gpadc);
 	gpadc = NULL;
@@ -708,7 +710,8 @@ static int ab8500_gpadc_remove(struct platform_device *pdev)
 	pm_runtime_get_sync(gpadc->dev);
 	pm_runtime_disable(gpadc->dev);
 
-	regulator_disable(gpadc->regu);
+	if (gpadc->regu)
+		regulator_disable(gpadc->regu);
 
 	pm_runtime_set_suspended(gpadc->dev);
 
-- 
1.7.10.4

