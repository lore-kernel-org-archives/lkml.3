Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3BDPCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:02:52 -0500
Received: from fallback8.mail.ru ([94.100.176.136]:56927 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3BDPCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:02:50 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] mfd: syscon: Added support for using platform driver resources
Date: Mon,  4 Feb 2013 19:00:40 +0400
Message-Id: <1359990040-5339-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.12.4
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support usage platform driver resources, i.e.
possibility works without oftree support. Additionally patch
removes CONFIG_OF dependency and adds helper for accessing
regmap by searching device by its name.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/Kconfig        |  1 -
 drivers/mfd/syscon.c       | 62 +++++++++++++++++++++++++++++++++++-----------
 include/linux/mfd/syscon.h |  1 +
 3 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 47ad4e2..389f5e2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1065,7 +1065,6 @@ config MFD_STA2X11
 
 config MFD_SYSCON
 	bool "System Controller Register R/W Based on Regmap"
-	depends on OF
 	select REGMAP_MMIO
 	help
 	  Select this option to enable accessing system control registers
diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 3f10591..27d0a08 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -29,7 +29,27 @@ struct syscon {
 	struct regmap *regmap;
 };
 
-static int syscon_match(struct device *dev, void *data)
+static int syscon_match_name(struct device *dev, void *data)
+{
+	return !strcmp(dev_name(dev), (const char *)data);
+}
+
+struct regmap *syscon_regmap_lookup_by_name(const char *name)
+{
+	struct syscon *syscon;
+	struct device *dev;
+
+	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)name,
+				 syscon_match_name);
+	if (!dev)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	syscon = dev_get_drvdata(dev);
+
+	return syscon->regmap;
+}
+
+static int syscon_match_of(struct device *dev, void *data)
 {
 	struct syscon *syscon = dev_get_drvdata(dev);
 	struct device_node *dn = data;
@@ -43,7 +63,7 @@ struct regmap *syscon_node_to_regmap(struct device_node *np)
 	struct device *dev;
 
 	dev = driver_find_device(&syscon_driver.driver, NULL, np,
-				 syscon_match);
+				 syscon_match_of);
 	if (!dev)
 		return ERR_PTR(-EPROBE_DEFER);
 
@@ -102,26 +122,38 @@ static int syscon_probe(struct platform_device *pdev)
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
+		if (ret)
+			return ret;
+	} else {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		if (!res)
+			return -ENXIO;
+
+		if (!request_mem_region(res->start, resource_size(res),
+					dev_name(&pdev->dev)))
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
@@ -133,7 +165,7 @@ static int syscon_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, syscon);
 
 	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
-		res.start, res.end);
+		res->start, res->end);
 
 	return 0;
 }
diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index 6aeb6b8..e14f7fd 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -15,6 +15,7 @@
 #ifndef __LINUX_MFD_SYSCON_H__
 #define __LINUX_MFD_SYSCON_H__
 
+extern struct regmap *syscon_regmap_lookup_by_name(const char *name);
 extern struct regmap *syscon_node_to_regmap(struct device_node *np);
 extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
 extern struct regmap *syscon_regmap_lookup_by_phandle(
-- 
1.7.12.4

