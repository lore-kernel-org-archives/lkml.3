Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609Ab3CMRfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:35:15 -0400
Received: from fallback7.mail.ru ([94.100.176.135]:57204 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881Ab3CMRfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:35:13 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH v7 2/2] mfd: syscon: Add non-DT support
Date: Wed, 13 Mar 2013 21:34:20 +0400
Message-Id: <1363196060-1149-2-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1363196060-1149-1-git-send-email-shc_work@mail.ru>
References: <1363196060-1149-1-git-send-email-shc_work@mail.ru>
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
 drivers/mfd/syscon.c       | 75 +++++++++++++++++++++++++++-------------------
 include/linux/mfd/syscon.h |  1 +
 3 files changed, 46 insertions(+), 31 deletions(-)

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
index 674af14..d1e5eb9 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -29,7 +29,7 @@ struct syscon {
 	struct regmap *regmap;
 };
 
-static int syscon_match(struct device *dev, void *data)
+static int syscon_match_node(struct device *dev, void *data)
 {
 	struct device_node *dn = data;
 
@@ -42,7 +42,7 @@ struct regmap *syscon_node_to_regmap(struct device_node *np)
 	struct device *dev;
 
 	dev = driver_find_device(&syscon_driver.driver, NULL, np,
-				 syscon_match);
+				 syscon_match_node);
 	if (!dev)
 		return ERR_PTR(-EPROBE_DEFER);
 
@@ -68,6 +68,34 @@ struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
 }
 EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
 
+static int syscon_match_pdevname(struct device *dev, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct platform_device_id *id = platform_get_device_id(pdev);
+
+	if (id)
+		if (!strcmp(id->name, (const char *)data))
+			return 1;
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
+		return ERR_PTR(-EPROBE_DEFER);
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
@@ -99,28 +127,22 @@ static struct regmap_config syscon_regmap_config = {
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
 
-	syscon = devm_kzalloc(dev, sizeof(struct syscon),
-			    GFP_KERNEL);
+	syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
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
+	syscon->base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!syscon->base)
+		return -ENOMEM;
 
-	syscon_regmap_config.max_register = res.end - res.start - 3;
+	syscon_regmap_config.max_register = res->end - res->start - 3;
 	syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
 					&syscon_regmap_config);
 	if (IS_ERR(syscon->regmap)) {
@@ -130,22 +152,15 @@ static int syscon_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, syscon);
 
-	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
-		res.start, res.end);
+	dev_info(dev, "regmap 0x%x-0x%x registered\n", res->start, res->end);
 
 	return 0;
 }
 
-static int syscon_remove(struct platform_device *pdev)
-{
-	struct syscon *syscon;
-
-	syscon = platform_get_drvdata(pdev);
-	iounmap(syscon->base);
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
+static const struct platform_device_id syscon_ids[] = {
+	{ "syscon", },
+	{ }
+};
 
 static struct platform_driver syscon_driver = {
 	.driver = {
@@ -154,7 +169,7 @@ static struct platform_driver syscon_driver = {
 		.of_match_table = of_syscon_match,
 	},
 	.probe		= syscon_probe,
-	.remove		= syscon_remove,
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

