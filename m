Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3BFK5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:57:08 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43534 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab3BFKzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:20 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 43/49] regulator: ab8500-ext: Adapt regulator registration for newly changed API
Date: Wed,  6 Feb 2013 10:54:05 +0000
Message-Id: <1360148051-7560-44-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>

Instead of using a long list of arguments for registering a new
regulator, the API has changed to accommodate a new structure
which is to contain the necessary runtime configuration. This
patch allows the external regulator to follow suit and continue
to successfully register itself with the Regulator subsystem.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Reviewed-by: Linus WALLEIJ <linus.walleij@stericsson.com>
---
 drivers/regulator/ab8500-ext.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index ce1830f..836b5de 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -369,6 +369,7 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_platform_data *ppdata;
 	struct ab8500_regulator_platform_data *pdata;
+	struct regulator_config config = { };
 	int i, err;
 
 	if (!ab8500) {
@@ -414,6 +415,10 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		info->cfg = (struct ab8500_ext_regulator_cfg *)
 			pdata->ext_regulator[i].driver_data;
 
+		config.dev = &pdev->dev;
+		config.init_data = &pdata->ext_regulator[i];
+		config.driver_data = info;
+
 		if ((is_ab9540(ab8500)) || (is_ab8540(ab8500))) {
 			if (info->desc.id == AB8500_EXT_SUPPLY1)
 				info->desc.ops = &ab9540_ext_regulator_ops;
@@ -426,8 +431,8 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
 		}
 
 		/* register regulator with framework */
-		info->rdev = regulator_register(&info->desc, &pdev->dev,
-				&pdata->ext_regulator[i], info, NULL);
+		info->rdev = regulator_register(&info->desc, &config);
+
 		if (IS_ERR(info->rdev)) {
 			err = PTR_ERR(info->rdev);
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
-- 
1.7.9.5

