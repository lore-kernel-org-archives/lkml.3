Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaAZOiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 09:38:22 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46662 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaAZOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 09:38:20 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, badarkhe.manish@gmail.com
Subject: [PATCH V2] max8925_power: Use "IS_ENABLED(CONFIG_OF)" for DT code.
Date: Sun, 26 Jan 2014 20:08:07 +0530
Message-Id: <1390747087-5394-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of "#ifdef CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
option for DT code to avoid if-deffery in code.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
Changes since V1:
1. update code to retrieve platform/dt data in same function

:100644 100644 b4513f2... 20a7100... M	drivers/power/max8925_power.c
 drivers/power/max8925_power.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index b4513f2..20a7100 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -427,9 +427,8 @@ static int max8925_deinit_charger(struct max8925_power_info *info)
 	return 0;
 }
 
-#ifdef CONFIG_OF
 static struct max8925_power_pdata *
-max8925_power_dt_init(struct platform_device *pdev)
+max8925_get_data(struct platform_device *pdev)
 {
 	struct device_node *nproot = pdev->dev.parent->of_node;
 	struct device_node *np;
@@ -440,7 +439,7 @@ max8925_power_dt_init(struct platform_device *pdev)
 	int no_insert_detect;
 	struct max8925_power_pdata *pdata;
 
-	if (!nproot)
+	if (!IS_ENABLED(CONFIG_OF) || !nproot)
 		return pdev->dev.platform_data;
 
 	np = of_find_node_by_name(nproot, "charger");
@@ -468,13 +467,6 @@ max8925_power_dt_init(struct platform_device *pdev)
 
 	return pdata;
 }
-#else
-static struct max8925_power_pdata *
-max8925_power_dt_init(struct platform_device *pdev)
-{
-	return pdev->dev.platform_data;
-}
-#endif
 
 static int max8925_power_probe(struct platform_device *pdev)
 {
@@ -483,7 +475,8 @@ static int max8925_power_probe(struct platform_device *pdev)
 	struct max8925_power_info *info;
 	int ret;
 
-	pdata = max8925_power_dt_init(pdev);
+	pdata = max8925_get_data(pdev);
+
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform data isn't assigned to "
 			"power supply\n");
-- 
1.7.10.4

