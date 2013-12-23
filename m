Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3LWQ2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:28:41 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39520 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab3LWQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:07 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: [RFC 10/18] regulator: vexpress: Use regmap instead of custom interface
Date: Mon, 23 Dec 2013 16:23:42 +0000
Message-Id: <1387815830-8794-11-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:05.0509 (UTC) FILETIME=[6618AB50:01CEFFFB]
X-MC-Unique: 113122316240608601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGT1ex026675

This patch makes the Versatile Express regulator driver
use regmap interface, instead of custom vexpress config
one. It will request the regmap resource associated
with the device, which makes it pretty much hardware
agnostic.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
---
 drivers/regulator/Kconfig    |  3 ++-
 drivers/regulator/vexpress.c | 52 +++++++++++---------------------------------
 2 files changed, 15 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index ce785f4..19a3eea 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -544,7 +544,8 @@ config REGULATOR_TWL4030
 
 config REGULATOR_VEXPRESS
 	tristate "Versatile Express regulators"
-	depends on VEXPRESS_CONFIG
+	depends on ARM || ARM64
+	depends on REGMAP
 	help
 	  This driver provides support for voltage regulators available
 	  on the ARM Ltd's Versatile Express platform.
diff --git a/drivers/regulator/vexpress.c b/drivers/regulator/vexpress.c
index f3ae28a..d73857b 100644
--- a/drivers/regulator/vexpress.c
+++ b/drivers/regulator/vexpress.c
@@ -18,22 +18,22 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
+#include <linux/regmap.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
-#include <linux/vexpress.h>
 
 struct vexpress_regulator {
 	struct regulator_desc desc;
 	struct regulator_dev *regdev;
-	struct vexpress_config_func *func;
+	struct regmap *regmap;
 };
 
 static int vexpress_regulator_get_voltage(struct regulator_dev *regdev)
 {
 	struct vexpress_regulator *reg = rdev_get_drvdata(regdev);
 	u32 uV;
-	int err = vexpress_config_read(reg->func, 0, &uV);
+	int err = regmap_read(reg->regmap, 0, &uV);
 
 	return err ? err : uV;
 }
@@ -43,7 +43,7 @@ static int vexpress_regulator_set_voltage(struct regulator_dev *regdev,
 {
 	struct vexpress_regulator *reg = rdev_get_drvdata(regdev);
 
-	return vexpress_config_write(reg->func, 0, min_uV);
+	return regmap_write(reg->regmap, 0, min_uV);
 }
 
 static struct regulator_ops vexpress_regulator_ops_ro = {
@@ -57,22 +57,17 @@ static struct regulator_ops vexpress_regulator_ops = {
 
 static int vexpress_regulator_probe(struct platform_device *pdev)
 {
-	int err;
 	struct vexpress_regulator *reg;
 	struct regulator_init_data *init_data;
 	struct regulator_config config = { };
 
 	reg = devm_kzalloc(&pdev->dev, sizeof(*reg), GFP_KERNEL);
-	if (!reg) {
-		err = -ENOMEM;
-		goto error_kzalloc;
-	}
+	if (!reg)
+		return -ENOMEM;
 
-	reg->func = vexpress_config_func_get_by_dev(&pdev->dev);
-	if (!reg->func) {
-		err = -ENXIO;
-		goto error_get_func;
-	}
+	reg->regmap = dev_get_regmap(&pdev->dev, NULL);
+	if (!reg->regmap)
+		return -ENXIO;
 
 	reg->desc.name = dev_name(&pdev->dev);
 	reg->desc.type = REGULATOR_VOLTAGE;
@@ -80,10 +75,8 @@ static int vexpress_regulator_probe(struct platform_device *pdev)
 	reg->desc.continuous_voltage_range = true;
 
 	init_data = of_get_regulator_init_data(&pdev->dev, pdev->dev.of_node);
-	if (!init_data) {
-		err = -EINVAL;
-		goto error_get_regulator_init_data;
-	}
+	if (!init_data)
+		return -EINVAL;
 
 	init_data->constraints.apply_uV = 0;
 	if (init_data->constraints.min_uV && init_data->constraints.max_uV)
@@ -97,30 +90,12 @@ static int vexpress_regulator_probe(struct platform_device *pdev)
 	config.of_node = pdev->dev.of_node;
 
 	reg->regdev = devm_regulator_register(&pdev->dev, &reg->desc, &config);
-	if (IS_ERR(reg->regdev)) {
-		err = PTR_ERR(reg->regdev);
-		goto error_regulator_register;
-	}
+	if (IS_ERR(reg->regdev))
+		return PTR_ERR(reg->regdev);
 
 	platform_set_drvdata(pdev, reg);
 
 	return 0;
-
-error_regulator_register:
-error_get_regulator_init_data:
-	vexpress_config_func_put(reg->func);
-error_get_func:
-error_kzalloc:
-	return err;
-}
-
-static int vexpress_regulator_remove(struct platform_device *pdev)
-{
-	struct vexpress_regulator *reg = platform_get_drvdata(pdev);
-
-	vexpress_config_func_put(reg->func);
-
-	return 0;
 }
 
 static struct of_device_id vexpress_regulator_of_match[] = {
@@ -130,7 +105,6 @@ static struct of_device_id vexpress_regulator_of_match[] = {
 
 static struct platform_driver vexpress_regulator_driver = {
 	.probe = vexpress_regulator_probe,
-	.remove = vexpress_regulator_remove,
 	.driver	= {
 		.name = DRVNAME,
 		.owner = THIS_MODULE,
-- 
1.8.3.2


