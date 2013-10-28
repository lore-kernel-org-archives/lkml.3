Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3J1TP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:15:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45261 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab3J1TOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:14:12 -0400
Message-Id: <cc2f82e353885734fe61bb8d8ec8c9f7b35e0d5a.1382985169.git.joshc@codeaurora.org>
In-Reply-To: <cover.1382985169.git.joshc@codeaurora.org>
References: <cover.1382985169.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Mon, 28 Oct 2013 13:12:35 -0500
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v3 07/10] regmap: add SPMI support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic support for the System Power Management Interface (SPMI) bus.
This is a simple implementation which only implements register accesses
via the Extended Register Read/Write Long commands.

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/base/regmap/Kconfig       |  5 ++-
 drivers/base/regmap/Makefile      |  1 +
 drivers/base/regmap/regmap-spmi.c | 90 +++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h            |  5 +++
 4 files changed, 100 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/regmap/regmap-spmi.c

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index f0d3054..4251570 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -3,7 +3,7 @@
 # subsystems should select the appropriate symbols.
 
 config REGMAP
-	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_MMIO || REGMAP_IRQ)
+	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_SPMI || REGMAP_MMIO || REGMAP_IRQ)
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	select IRQ_DOMAIN if REGMAP_IRQ
@@ -15,6 +15,9 @@ config REGMAP_I2C
 config REGMAP_SPI
 	tristate
 
+config REGMAP_SPMI
+	tristate
+
 config REGMAP_MMIO
 	tristate
 
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index cf12998..a7c670b 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -3,5 +3,6 @@ obj-$(CONFIG_REGMAP) += regcache-rbtree.o regcache-lzo.o regcache-flat.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
+obj-$(CONFIG_REGMAP_SPMI) += regmap-spmi.o
 obj-$(CONFIG_REGMAP_MMIO) += regmap-mmio.o
 obj-$(CONFIG_REGMAP_IRQ) += regmap-irq.o
diff --git a/drivers/base/regmap/regmap-spmi.c b/drivers/base/regmap/regmap-spmi.c
new file mode 100644
index 0000000..ac23910
--- /dev/null
+++ b/drivers/base/regmap/regmap-spmi.c
@@ -0,0 +1,90 @@
+/*
+ * Register map access API - SPMI support
+ *
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * Based on regmap-i2c.c:
+ * Copyright 2011 Wolfson Microelectronics plc
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/regmap.h>
+#include <linux/spmi.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+static int regmap_spmi_read(void *context,
+			    const void *reg, size_t reg_size,
+			    void *val, size_t val_size)
+{
+	BUG_ON(reg_size != 2);
+	return spmi_ext_register_readl(context, *(u16 *)reg,
+				       val, val_size);
+}
+
+static int regmap_spmi_gather_write(void *context,
+				    const void *reg, size_t reg_size,
+				    const void *val, size_t val_size)
+{
+	BUG_ON(reg_size != 2);
+	return spmi_ext_register_writel(context, *(u16 *)reg, val, val_size);
+}
+
+static int regmap_spmi_write(void *context, const void *data,
+			     size_t count)
+{
+	BUG_ON(count < 2);
+	return regmap_spmi_gather_write(context, data, 2, data + 2, count - 2);
+}
+
+static struct regmap_bus regmap_spmi = {
+	.read				= regmap_spmi_read,
+	.write				= regmap_spmi_write,
+	.gather_write			= regmap_spmi_gather_write,
+	.reg_format_endian_default	= REGMAP_ENDIAN_NATIVE,
+	.val_format_endian_default	= REGMAP_ENDIAN_NATIVE,
+};
+
+/**
+ * regmap_init_spmi(): Initialize register map
+ *
+ * @sdev: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+struct regmap *regmap_init_spmi(struct spmi_device *sdev,
+				const struct regmap_config *config)
+{
+	return regmap_init(&sdev->dev, &regmap_spmi, sdev, config);
+}
+EXPORT_SYMBOL_GPL(regmap_init_spmi);
+
+/**
+ * devm_regmap_init_spmi(): Initialise managed register map
+ *
+ * @sdev: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+struct regmap *devm_regmap_init_spmi(struct spmi_device *sdev,
+				     const struct regmap_config *config)
+{
+	return devm_regmap_init(&sdev->dev, &regmap_spmi, sdev, config);
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init_spmi);
+
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a10380b..3f5abc8 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -23,6 +23,7 @@ struct device;
 struct i2c_client;
 struct irq_domain;
 struct spi_device;
+struct spmi_device;
 struct regmap;
 struct regmap_range_cfg;
 struct regmap_field;
@@ -318,6 +319,8 @@ struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config);
 struct regmap *regmap_init_spi(struct spi_device *dev,
 			       const struct regmap_config *config);
+struct regmap *regmap_init_spmi(struct spmi_device *dev,
+			       const struct regmap_config *config);
 struct regmap *regmap_init_mmio_clk(struct device *dev, const char *clk_id,
 				    void __iomem *regs,
 				    const struct regmap_config *config);
@@ -330,6 +333,8 @@ struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
 				    const struct regmap_config *config);
 struct regmap *devm_regmap_init_spi(struct spi_device *dev,
 				    const struct regmap_config *config);
+struct regmap *devm_regmap_init_spmi(struct spmi_device *dev,
+				     const struct regmap_config *config);
 struct regmap *devm_regmap_init_mmio_clk(struct device *dev, const char *clk_id,
 					 void __iomem *regs,
 					 const struct regmap_config *config);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


