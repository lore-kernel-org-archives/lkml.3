Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3DPNpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:45:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44427 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694Ab3DPNpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:45:30 -0400
From: Mehar Bajwa <mehar.bajwa@ti.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
CC: <liam.r.girdwood@intel.com>, <navada@ti.com>,
        Mehar Bajwa <mehar.bajwa@ti.com>
Subject: [PATCH V2 4/4] mfd: SPI interface with AIC platform
Date: Tue, 16 Apr 2013 19:15:23 +0530
Message-ID: <1366119923-9828-1-git-send-email-mehar.bajwa@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1366119899-9789-1-git-send-email-mehar.bajwa@ti.com>
References: <1366119899-9789-1-git-send-email-mehar.bajwa@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Texas Instruments TLV320AIC family of audio SoC
core functionality controlled via SPI. This driver
provides common support for accessing the device.

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 drivers/mfd/Kconfig         |   11 +++++
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/tlv320aic-spi.c |   97 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tlv320aic-spi.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 40eb328..b1d6269 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -81,6 +81,17 @@ config MFD_AIC_I2C
 	  core functionality controlled via I2C. This driver provides common
 	  support for accessing the device, additional drivers must be enabled
 	  in order to use the functionality of the device.
+
+config MFD_AIC_SPI
+	bool "AIC SPI Interface"
+	select REGMAP_SPI
+	depends on MFD_AIC
+	depends on SPI_MASTER
+	help
+	  Support for the Texas Instruments TLV320AIC family of audio SoC
+	  core functionality controlled via SPI.  This driver provides common
+	  support for accessing the device, additional drivers must be enabled
+	  in order to use the functionality of the device.
 endmenu
 
 config MFD_SM501
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 1e2c96a..dfdcfa2 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_AIC)		+= tlv320aic-core.o
 obj-$(CONFIG_MFD_AIC_IRQ)	+= tlv320aic-irq.o
 obj-$(CONFIG_MFD_AIC_I2C)	+= tlv320aic-i2c.o
+obj-$(CONFIG_MFD_AIC_SPI)	+= tlv320aic-spi.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
diff --git a/drivers/mfd/tlv320aic-spi.c b/drivers/mfd/tlv320aic-spi.c
new file mode 100644
index 0000000..2faeb40
--- /dev/null
+++ b/drivers/mfd/tlv320aic-spi.c
@@ -0,0 +1,97 @@
+/*
+ * tlv320aic-spi.c  -- driver for TLV320AIC
+ *
+ * Author:      Mukund Navada <navada@ti.com>
+ *		Mehar Bajwa <mehar.bajwa@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+
+#include <linux/mfd/tlv320aic-core.h>
+
+struct regmap_config aic_spi_regmap = {
+	.reg_bits = 7,
+	.val_bits = 8,
+	.cache_type = REGCACHE_NONE,
+	.read_flag_mask = 0x1,
+	.pad_bits = 1,
+};
+
+static int tlv320aic_spi_probe(struct spi_device *spi)
+{
+	const struct spi_device_id *id = spi_get_device_id(spi);
+	struct aic *aic;
+	const struct regmap_config *regmap_config;
+	int ret;
+
+	regmap_config = &aic_spi_regmap;
+
+	aic = devm_kzalloc(&spi->dev, sizeof(struct aic), GFP_KERNEL);
+	if (aic == NULL)
+		return -ENOMEM;
+
+	aic->regmap = devm_regmap_init_spi(spi, regmap_config);
+	if (IS_ERR(aic->regmap)) {
+		ret = PTR_ERR(aic->regmap);
+		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	aic->type = id->driver_data;
+	aic->dev = &spi->dev;
+	aic->irq = spi->irq;
+
+	return aic_device_init(aic);
+}
+
+static int tlv320aic_spi_remove(struct spi_device *spi)
+{
+	struct aic *aic = dev_get_drvdata(&spi->dev);
+	aic_device_exit(aic);
+	return 0;
+}
+
+static const struct spi_device_id aic_spi_ids[] = {
+	{"tlv320aic3262", TLV320AIC3262},
+	{ }
+};
+MODULE_DEVICE_TABLE(spi, aic_spi_ids);
+
+static struct spi_driver tlv320aic_spi_driver = {
+	.driver = {
+		.name	= "tlv320aic",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tlv320aic_spi_probe,
+	.remove		= tlv320aic_spi_remove,
+	.id_table	= aic_spi_ids,
+};
+
+module_spi_driver(tlv320aic_spi_driver);
+
+MODULE_DESCRIPTION("TLV320AIC SPI bus interface");
+MODULE_AUTHOR("Mukund Navada <navada@ti.com>");
+MODULE_AUTHOR("Mehar Bajwa <mehar.bajwa@ti.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

