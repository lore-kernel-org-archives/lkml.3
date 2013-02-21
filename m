Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3BUP3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:29:12 -0500
Received: from smtp5.mail.ru ([94.100.176.132]:49405 "EHLO smtp5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab3BUP3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:29:11 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH v4] mfd: syscon: Add non-DT support
Date: Thu, 21 Feb 2013 19:29:02 +0400
Message-Id: <1361460542-2872-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.12.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allow using syscon driver from the platform data, i.e.
possibility using driver on systems without oftree support.
For search syscon device from the client drivers,
"syscon_regmap_lookup_by_pdevname" function was added.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/Kconfig        |  1 -
 drivers/mfd/syscon.c       | 64 +++++++++++++++++++++++++++++++++-------------
 include/linux/mfd/syscon.h |  1 +
 3 files changed, 47 insertions(+), 19 deletions(-)

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
index 4a7ed5a..0773484 100644
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
 
@@ -67,6 +67,33 @@ struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
 
+static int syscon_match_pdevname(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct platform_device_id *id = platform_get_device_id(pdev);
+
+	if (id)
+		return !strcmp(id->name, (const char *)data);
+
+	return !strcmp(dev_name(dev), (const char *)data);
+}
+
+struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
+{
+	struct device *dev;
+	struct syscon *syscon;
+
+	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
+				 syscon_match_pdevname);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	syscon = dev_get_drvdata(dev);
+
+	return syscon->regmap;
+}
+EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
+
 struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
 					const char *property)
 {
@@ -98,30 +125,25 @@ static struct regmap_config syscon_regmap_config = {
 static int syscon_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
 	struct syscon *syscon;
-	struct resource res;
-	int ret;
-
-	if (!np)
-		return -ENOENT;
+	struct resource *res;
 
 	syscon = devm_kzalloc(dev, sizeof(struct syscon),
-			    GFP_KERNEL);
+			      GFP_KERNEL);
 	if (!syscon)
 		return -ENOMEM;
 
-	syscon->base = of_iomap(np, 0);
-	if (!syscon->base)
-		return -EADDRNOTAVAIL;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOENT;
 
-	ret = of_address_to_resource(np, 0, &res);
-	if (ret)
-		return ret;
+	syscon->base = devm_ioremap_resource(dev, res);
+	if (!syscon->base)
+		return -EBUSY;
 
-	syscon_regmap_config.max_register = res.end - res.start - 3;
+	syscon_regmap_config.max_register = res->end - res->start - 3;
 	syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
-					&syscon_regmap_config);
+					       &syscon_regmap_config);
 	if (IS_ERR(syscon->regmap)) {
 		dev_err(dev, "regmap init failed\n");
 		return PTR_ERR(syscon->regmap);
@@ -130,11 +152,16 @@ static int syscon_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, syscon);
 
 	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
-		res.start, res.end);
+		 res->start, res->end);
 
 	return 0;
 }
 
+static const struct platform_device_id syscon_ids[] = {
+	{ "syscon", },
+	{ }
+};
+
 static struct platform_driver syscon_driver = {
 	.driver = {
 		.name = "syscon",
@@ -142,6 +169,7 @@ static struct platform_driver syscon_driver = {
 		.of_match_table = of_syscon_match,
 	},
 	.probe		= syscon_probe,
+	.id_table	= syscon_ids,
 };
 
 static int __init syscon_init(void)
diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index 6aeb6b8..5c9ee6e 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -17,6 +17,7 @@
 
 extern struct regmap *syscon_node_to_regmap(struct device_node *np);
 extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
+extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_phandle(
 					struct device_node *np,
 					const char *property);
-- 
1.7.12.4

