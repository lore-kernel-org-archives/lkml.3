Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaKRSqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:46:04 -0500
Received: from smtp-out-252.synserver.de ([212.40.185.252]:1053 "EHLO
	smtp-out-252.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaKRSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:45:59 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13395
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 1/4] regmap: ac97: Add generic AC'97 callbacks
Date: Tue, 18 Nov 2014 19:45:51 +0100
Message-Id: <1416336354-32148-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1416336354-32148-1-git-send-email-lars@metafoo.de>
References: <1416336354-32148-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Use the recently added support for bus operations to provide a standard
mapping for AC'97 register I/O.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
Changes from the original version:
	* Add ac97_regmap_bus and made regmap_ac97_reg_{write,read} static
	* Use ac97->bus->ops instead of passing the ops separately
---
 drivers/base/regmap/Kconfig       |   5 +-
 drivers/base/regmap/Makefile      |   1 +
 drivers/base/regmap/regmap-ac97.c | 114 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h            |   7 +++
 4 files changed, 126 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/regmap/regmap-ac97.c

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 8a3f51f..db9d00c3 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -3,12 +3,15 @@
 # subsystems should select the appropriate symbols.
 
 config REGMAP
-	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_SPMI || REGMAP_MMIO || REGMAP_IRQ)
+	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_SPMI || REGMAP_AC97 || REGMAP_MMIO || REGMAP_IRQ)
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	select IRQ_DOMAIN if REGMAP_IRQ
 	bool
 
+config REGMAP_AC97
+	tristate
+
 config REGMAP_I2C
 	tristate
 	depends on I2C
diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
index a7c670b..0a53365 100644
--- a/drivers/base/regmap/Makefile
+++ b/drivers/base/regmap/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_REGMAP) += regmap.o regcache.o
 obj-$(CONFIG_REGMAP) += regcache-rbtree.o regcache-lzo.o regcache-flat.o
 obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
+obj-$(CONFIG_REGMAP_AC97) += regmap-ac97.o
 obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
 obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
 obj-$(CONFIG_REGMAP_SPMI) += regmap-spmi.o
diff --git a/drivers/base/regmap/regmap-ac97.c b/drivers/base/regmap/regmap-ac97.c
new file mode 100644
index 0000000..e4c45d2
--- /dev/null
+++ b/drivers/base/regmap/regmap-ac97.c
@@ -0,0 +1,114 @@
+/*
+ * Register map access API - AC'97 support
+ *
+ * Copyright 2013 Linaro Ltd.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+#include <sound/ac97_codec.h>
+
+bool regmap_ac97_default_volatile(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case AC97_RESET:
+	case AC97_POWERDOWN:
+	case AC97_INT_PAGING:
+	case AC97_EXTENDED_ID:
+	case AC97_EXTENDED_STATUS:
+	case AC97_EXTENDED_MID:
+	case AC97_EXTENDED_MSTATUS:
+	case AC97_GPIO_STATUS:
+	case AC97_MISC_AFE:
+	case AC97_VENDOR_ID1:
+	case AC97_VENDOR_ID2:
+	case AC97_CODEC_CLASS_REV:
+	case AC97_PCI_SVID:
+	case AC97_PCI_SID:
+	case AC97_FUNC_SELECT:
+	case AC97_FUNC_INFO:
+	case AC97_SENSE_INFO:
+		return true;
+	default:
+		return false;
+	}
+}
+EXPORT_SYMBOL_GPL(regmap_ac97_default_volatile);
+
+static int regmap_ac97_reg_read(void *context, unsigned int reg,
+	unsigned int *val)
+{
+	struct snd_ac97 *ac97 = context;
+
+	*val = ac97->bus->ops->read(ac97, reg);
+
+	return 0;
+}
+
+static int regmap_ac97_reg_write(void *context, unsigned int reg,
+	unsigned int val)
+{
+	struct snd_ac97 *ac97 = context;
+
+	ac97->bus->ops->write(ac97, reg, val);
+
+	return 0;
+}
+
+static const struct regmap_bus ac97_regmap_bus = {
+		.reg_write = regmap_ac97_reg_write,
+		.reg_read = regmap_ac97_reg_read,
+};
+
+/**
+ * regmap_init_ac97(): Initialise AC'97 register map
+ *
+ * @ac97: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer to
+ * a struct regmap.
+ */
+struct regmap *regmap_init_ac97(struct snd_ac97 *ac97,
+				const struct regmap_config *config)
+{
+	return regmap_init(&ac97->dev, &ac97_regmap_bus, ac97, config);
+}
+EXPORT_SYMBOL_GPL(regmap_init_ac97);
+
+/**
+ * devm_regmap_init_ac97(): Initialise AC'97 register map
+ *
+ * @ac97: Device that will be interacted with
+ * @config: Configuration for register map
+ *
+ * The return value will be an ERR_PTR() on error or a valid pointer
+ * to a struct regmap.  The regmap will be automatically freed by the
+ * device management code.
+ */
+struct regmap *devm_regmap_init_ac97(struct snd_ac97 *ac97,
+				     const struct regmap_config *config)
+{
+	return devm_regmap_init(&ac97->dev, &ac97_regmap_bus, ac97, config);
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init_ac97);
+
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index c5ed83f..4419b99 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -27,6 +27,7 @@ struct spmi_device;
 struct regmap;
 struct regmap_range_cfg;
 struct regmap_field;
+struct snd_ac97;
 
 /* An enum of all the supported cache types */
 enum regcache_type {
@@ -340,6 +341,8 @@ struct regmap *regmap_init_spmi_ext(struct spmi_device *dev,
 struct regmap *regmap_init_mmio_clk(struct device *dev, const char *clk_id,
 				    void __iomem *regs,
 				    const struct regmap_config *config);
+struct regmap *regmap_init_ac97(struct snd_ac97 *ac97,
+				const struct regmap_config *config);
 
 struct regmap *devm_regmap_init(struct device *dev,
 				const struct regmap_bus *bus,
@@ -356,6 +359,10 @@ struct regmap *devm_regmap_init_spmi_ext(struct spmi_device *dev,
 struct regmap *devm_regmap_init_mmio_clk(struct device *dev, const char *clk_id,
 					 void __iomem *regs,
 					 const struct regmap_config *config);
+struct regmap *devm_regmap_init_ac97(struct snd_ac97 *ac97,
+				     const struct regmap_config *config);
+
+bool regmap_ac97_default_volatile(struct device *dev, unsigned int reg);
 
 /**
  * regmap_init_mmio(): Initialise register map
-- 
1.8.0

