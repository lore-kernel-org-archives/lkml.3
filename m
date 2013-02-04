Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab3BDMMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:12:19 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53102 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3BDL4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:24 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 19/73] regulator: ab8500-ext: Add regulator_set_mode/get_mode
Date: Mon,  4 Feb 2013 11:53:34 +0000
Message-Id: <1359978868-28736-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Operations regulator_set_mode and regulator_get_mode are added.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias NILSSON <mattias.i.nilsson@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/regulator/ab8500-ext.c |   64 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 29d5cd4..2bf940d 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/err.h>
-#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
@@ -197,6 +196,67 @@ static int ab8500_ext_regulator_is_enabled(struct regulator_dev *rdev)
 	return info->is_enabled;
 }
 
+static int ab8500_ext_regulator_set_mode(struct regulator_dev *rdev,
+					 unsigned int mode)
+{
+	int ret = 0;
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	switch (mode) {
+	case REGULATOR_MODE_NORMAL:
+		info->update_val = info->update_val_hp;
+		break;
+	case REGULATOR_MODE_IDLE:
+		info->update_val = info->update_val_lp;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (info->is_enabled) {
+		u8 regval;
+
+		ret = enable(info, &regval);
+		if (ret < 0)
+			dev_err(rdev_get_dev(rdev),
+				"Could not set regulator mode.\n");
+
+		dev_dbg(rdev_get_dev(rdev),
+			"%s-set_mode (bank, reg, mask, value): "
+			"0x%x, 0x%x, 0x%x, 0x%x\n",
+			info->desc.name, info->update_bank, info->update_reg,
+			info->update_mask, regval);
+	}
+
+	return ret;
+}
+
+static unsigned int ab8500_ext_regulator_get_mode(struct regulator_dev *rdev)
+{
+	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (info == NULL) {
+		dev_err(rdev_get_dev(rdev), "regulator info null pointer\n");
+		return -EINVAL;
+	}
+
+	if (info->update_val == info->update_val_hp)
+		ret = REGULATOR_MODE_NORMAL;
+	else if (info->update_val == info->update_val_lp)
+		ret = REGULATOR_MODE_IDLE;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
 static int ab8500_ext_fixed_get_voltage(struct regulator_dev *rdev)
 {
 	struct ab8500_ext_regulator_info *info = rdev_get_drvdata(rdev);
@@ -232,6 +292,8 @@ static struct regulator_ops ab8500_ext_regulator_ops = {
 	.disable		= ab8500_ext_regulator_disable,
 	.set_suspend_disable	= ab8500_ext_regulator_set_suspend_disable,
 	.is_enabled		= ab8500_ext_regulator_is_enabled,
+	.set_mode		= ab8500_ext_regulator_set_mode,
+	.get_mode		= ab8500_ext_regulator_get_mode,
 	.get_voltage		= ab8500_ext_fixed_get_voltage,
 	.list_voltage		= ab8500_ext_list_voltage,
 };
-- 
1.7.9.5

