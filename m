Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab3LJXh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:37:27 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37869 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LJXf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:35:28 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3/8] regmap: Add support for using regmap over ssbi
Date: Tue, 10 Dec 2013 15:35:18 -0800
Message-Id: <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Ramana <sramana@codeaurora.org>

This patch will add support for using regmap API over SSBI.
Many of the Qualcomm PMIC chips(ex: PM8038, 8921) uses SSBI interface.
This patch adds only regmap-ssbi suport. Individual PMIC drivers will
need to register with their config to use the regmap API.
regmap-ssbi uses the SSBI driver interface.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Srinivas Ramana <sramana@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/base/regmap/Kconfig       |   5 +-
 drivers/base/regmap/Makefile      |   1 +
 drivers/base/regmap/regmap-ssbi.c | 103 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h            |   4 ++
 4 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/regmap/regmap-ssbi.c

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 4251570..fd0e264 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -3,7 +3,7 @@
 # subsystems should select the appropriate symbols.
 
 config REGMAP
-	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_SPMI || REGMAP_MMIO || REGMAP_IRQ)
+	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_SPMI || REGMAP_MMIO || REGMAP_IRQ || REGMAP_SSBI)
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	select IRQ_DOMAIN if REGMAP_IRQ
@@ -23,3 +23,6 @@ config REGMAP_MMIO
 
 config REGMAP_IRQ
 	bool
+
+config REGMAP_SSBI
+	tristate
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index a7c670b..3f53763 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
 obj-$(CONFIG_REGMAP_SPMI) += regmap-spmi.o
 obj-$(CONFIG_REGMAP_MMIO) += regmap-mmio.o
 obj-$(CONFIG_REGMAP_IRQ) += regmap-irq.o
+obj-$(CONFIG_REGMAP_SSBI) += regmap-ssbi.o
diff --git a/drivers/base/regmap/regmap-ssbi.c b/drivers/base/regmap/regmap-ssbi.c
new file mode 100644
index 0000000..71bce4d
--- /dev/null
+++ b/drivers/base/regmap/regmap-ssbi.c
@@ -0,0 +1,103 @@
+/*
+ * Register map access API - SSBI support
+ *
+ * Copyright (c) 2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/regmap.h>
+#include <linux/module.h>
+#include <linux/ssbi.h>
+
+static int regmap_ssbi_read(void *context,
+			    const void *reg, size_t reg_size,
+			    void *val, size_t val_size)
+{
+	int ret;
+
+	BUG_ON(reg_size != 2);
+
+	while (val_size) {
+		ret = ssbi_read(context, *(u16 *)reg, val, 1);
+		if (ret)
+			return ret;
+		reg += sizeof(u16);
+		val += sizeof(u8);
+		val_size -= sizeof(u8);
+	}
+
+	return 0;
+}
+
+static int regmap_ssbi_gather_write(void *context,
+				   const void *reg, size_t reg_size,
+				   const void *val, size_t val_size)
+{
+	int ret;
+
+	BUG_ON(reg_size != 2);
+
+	while (val_size) {
+		ret = ssbi_write(context, *(u16 *)reg, val, 1);
+		if (ret)
+			return ret;
+		reg += sizeof(u16);
+		val += sizeof(u8);
+		val_size -= sizeof(u8);
+	}
+
+	return 0;
+}
+
+static int regmap_ssbi_write(void *context, const void *data, size_t count)
+{
+	BUG_ON(count < 2);
+	return regmap_ssbi_gather_write(context, data, 2, data + 2, count - 2);
+}
+
+static const struct regmap_bus regmap_ssbi = {
+	.read				= regmap_ssbi_read,
+	.write				= regmap_ssbi_write,
+	.gather_write			= regmap_ssbi_gather_write,
+	.reg_format_endian_default	= REGMAP_ENDIAN_NATIVE,
+	.val_format_endian_default	= REGMAP_ENDIAN_NATIVE,
+};
+
+/**
+ * regmap_init_ssbi(): Initialise register map
+ *
+ * @dev: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+struct regmap *regmap_init_ssbi(struct device *dev,
+			       const struct regmap_config *config)
+{
+	return regmap_init(dev, &regmap_ssbi, dev->parent, config);
+}
+EXPORT_SYMBOL_GPL(regmap_init_ssbi);
+
+/**
+ * devm_regmap_init_ssbi(): Initialise managed register map
+ *
+ * @dev: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+struct regmap *devm_regmap_init_ssbi(struct device *dev,
+				    const struct regmap_config *config)
+{
+	return devm_regmap_init(dev, &regmap_ssbi, dev->parent, config);
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init_ssbi);
+
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e559078..528ee99 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -326,6 +326,8 @@ struct regmap *regmap_init_spmi(struct spmi_device *dev,
 struct regmap *regmap_init_mmio_clk(struct device *dev, const char *clk_id,
 				    void __iomem *regs,
 				    const struct regmap_config *config);
+struct regmap *regmap_init_ssbi(struct device *dev,
+				const struct regmap_config *config);
 
 struct regmap *devm_regmap_init(struct device *dev,
 				const struct regmap_bus *bus,
@@ -340,6 +342,8 @@ struct regmap *devm_regmap_init_spmi(struct spmi_device *dev,
 struct regmap *devm_regmap_init_mmio_clk(struct device *dev, const char *clk_id,
 					 void __iomem *regs,
 					 const struct regmap_config *config);
+struct regmap *devm_regmap_init_ssbi(struct device *dev,
+					const struct regmap_config *config);
 
 /**
  * regmap_init_mmio(): Initialise register map
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

