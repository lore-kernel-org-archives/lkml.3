Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021Ab3CUQBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:01:23 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44752 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab3CUQBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:01:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 37/46] regulator: ab8500-ext: Adapt regulator registration for newly changed API
Date: Thu, 21 Mar 2013 15:59:34 +0000
Message-Id: <1363881583-15234-38-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
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
1.7.10.4

