Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3BROmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 09:42:33 -0500
Received: from fallback5.mail.ru ([94.100.176.59]:56361 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3BROmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:42:32 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH v3] mfd: syscon: Add non-DT support
Date: Mon, 18 Feb 2013 18:42:02 +0400
Message-Id: <1361198522-23789-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.12.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allow using syscon driver from the platform data, i.e.
possibility using driver on systems without oftree support.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/Kconfig  |  1 -
 drivers/mfd/syscon.c | 76 +++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 671f5b1..8fdd87e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1070,7 +1070,6 @@ config MFD_STA2X11
 
 config MFD_SYSCON
 	bool "System Controller Register R/W Based on Regmap"
-	depends on OF
 	select REGMAP_MMIO
 	help
 	  Select this option to enable accessing system control registers
diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 4a7ed5a..3c0abcb 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -28,7 +28,7 @@ struct syscon {
 	struct regmap *regmap;
 };
 
-static int syscon_match(struct device *dev, void *data)
+static int syscon_match_node(struct device *dev, void *data)
 {
 	struct device_node *dn = data;
 
@@ -41,7 +41,7 @@ struct regmap *syscon_node_to_regmap(struct device_node *np)
 	struct device *dev;
 
 	dev = driver_find_device(&syscon_driver.driver, NULL, np,
-				 syscon_match);
+				 syscon_match_node);
 	if (!dev)
 		return ERR_PTR(-EPROBE_DEFER);
 
@@ -51,19 +51,41 @@ struct regmap *syscon_node_to_regmap(struct device_node *np)
 }
 EXPORT_SYMBOL_GPL(syscon_node_to_regmap);
 
+static int syscon_match_id(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct platform_device_id *id = platform_get_device_id(pdev);
+
+	if (id)
+		return !strcmp(id->name, (const char *)data);
+
+	return 0;
+}
+
 struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
 {
 	struct device_node *syscon_np;
 	struct regmap *regmap;
+	struct syscon *syscon;
+	struct device *dev;
 
 	syscon_np = of_find_compatible_node(NULL, NULL, s);
-	if (!syscon_np)
+	if (syscon_np) {
+		regmap = syscon_node_to_regmap(syscon_np);
+		of_node_put(syscon_np);
+
+		return regmap;
+	}
+
+	/* Fallback to search by id_entry.name string */
+	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
+				 syscon_match_id);
+	if (!dev)
 		return ERR_PTR(-ENODEV);
 
-	regmap = syscon_node_to_regmap(syscon_np);
-	of_node_put(syscon_np);
+	syscon = dev_get_drvdata(dev);
 
-	return regmap;
+	return syscon->regmap;
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
 
@@ -100,37 +122,53 @@ static int syscon_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct syscon *syscon;
-	struct resource res;
+	struct resource *res, res_of;
 	int ret;
 
-	if (!np)
-		return -ENOENT;
-
 	syscon = devm_kzalloc(dev, sizeof(struct syscon),
 			    GFP_KERNEL);
 	if (!syscon)
 		return -ENOMEM;
 
-	syscon->base = of_iomap(np, 0);
-	if (!syscon->base)
-		return -EADDRNOTAVAIL;
-
-	ret = of_address_to_resource(np, 0, &res);
-	if (ret)
-		return ret;
+	if (IS_ENABLED(CONFIG_OF) && np) {
+		syscon->base = of_iomap(np, 0);
+		if (!syscon->base)
+			return -EADDRNOTAVAIL;
+
+		res = &res_of;
+		ret = of_address_to_resource(np, 0, res);
+		if (ret) {
+			iounmap(syscon->base);
+			return ret;
+		}
+	} else {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (!res)
+			return -ENOENT;
+
+		if (!devm_request_mem_region(dev, res->start,
+					     resource_size(res),
+					     dev_name(&pdev->dev)))
+			return -EBUSY;
+
+		syscon->base = ioremap(res->start, resource_size(res));
+		if (!syscon->base)
+			return -EADDRNOTAVAIL;
+	}
 
-	syscon_regmap_config.max_register = res.end - res.start - 3;
+	syscon_regmap_config.max_register = res->end - res->start - 3;
 	syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
 					&syscon_regmap_config);
 	if (IS_ERR(syscon->regmap)) {
 		dev_err(dev, "regmap init failed\n");
+		iounmap(syscon->base);
 		return PTR_ERR(syscon->regmap);
 	}
 
 	platform_set_drvdata(pdev, syscon);
 
 	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
-		res.start, res.end);
+		res->start, res->end);
 
 	return 0;
 }
-- 
1.7.12.4

