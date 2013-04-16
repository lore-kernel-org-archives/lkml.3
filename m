Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3DPNpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:45:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35917 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab3DPNpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:45:09 -0400
From: Mehar Bajwa <mehar.bajwa@ti.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
CC: <liam.r.girdwood@intel.com>, <navada@ti.com>,
        Mehar Bajwa <mehar.bajwa@ti.com>
Subject: [PATCH V2 3/4] mfd: I2C interface with AIC platform
Date: Tue, 16 Apr 2013 19:14:59 +0530
Message-ID: <1366119899-9789-1-git-send-email-mehar.bajwa@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1366119860-9754-1-git-send-email-mehar.bajwa@ti.com>
References: <1366119860-9754-1-git-send-email-mehar.bajwa@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Texas Instruments TLV320AIC family of audio SoC
core functionality controlled via I2C. This driver
provides common support for accessing the device.

Signed-off-by: Mehar Bajwa <mehar.bajwa@ti.com>
---
 drivers/mfd/Kconfig         |   12 +++++
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/tlv320aic-i2c.c |   98 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tlv320aic-i2c.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3019897..40eb328 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -64,11 +64,23 @@ menu "AIC Interface Drivers"
 config MFD_AIC_IRQ
 	bool "Support of IRQ for AIC"
 	depends on MFD_AIC
+	default y
 	help
 	  Say yes here if you want support of IRQ for Texas Instruments
 	  AIC codec family.
 	  You have to select individual components like codec device
 	  under the corresponding menus.
+
+config MFD_AIC_I2C
+	bool "AIC I2C Interface"
+	select REGMAP_I2C
+	depends on MFD_AIC
+	depends on I2C
+	help
+	  Support for the Texas Instruments TLV320AIC family of audio SoC
+	  core functionality controlled via I2C. This driver provides common
+	  support for accessing the device, additional drivers must be enabled
+	  in order to use the functionality of the device.
 endmenu
 
 config MFD_SM501
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 3b39454..1e2c96a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MFD_88PM800)	+= 88pm800.o 88pm80x.o
 obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_AIC)		+= tlv320aic-core.o
 obj-$(CONFIG_MFD_AIC_IRQ)	+= tlv320aic-irq.o
+obj-$(CONFIG_MFD_AIC_I2C)	+= tlv320aic-i2c.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 
diff --git a/drivers/mfd/tlv320aic-i2c.c b/drivers/mfd/tlv320aic-i2c.c
new file mode 100644
index 0000000..18987b1
--- /dev/null
+++ b/drivers/mfd/tlv320aic-i2c.c
@@ -0,0 +1,98 @@
+/*
+ * tlv320aic-i2c.c  -- driver for TLV320AIC Codecs Family
+ *
+ * Author:	Mukund Navada <navada@ti.com>
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
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/tlv320aic-core.h>
+
+struct regmap_config aic_i2c_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.cache_type = REGCACHE_NONE,
+};
+
+static int aic_i2c_probe(struct i2c_client *i2c,
+					  const struct i2c_device_id *id)
+{
+	struct aic *aic;
+	const struct regmap_config *regmap_config;
+	int ret;
+
+	regmap_config = &aic_i2c_regmap;
+
+	aic = devm_kzalloc(&i2c->dev, sizeof(*aic), GFP_KERNEL);
+	if (aic == NULL)
+		return -ENOMEM;
+
+	aic->regmap = devm_regmap_init_i2c(i2c, regmap_config);
+
+	if (IS_ERR(aic->regmap)) {
+		ret = PTR_ERR(aic->regmap);
+		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	aic->type = id->driver_data;
+	aic->dev = &i2c->dev;
+	aic->irq = i2c->irq;
+
+	return aic_device_init(aic);
+}
+
+static int aic_i2c_remove(struct i2c_client *i2c)
+{
+	struct aic *aic = dev_get_drvdata(&i2c->dev);
+
+	aic_device_exit(aic);
+	return 0;
+}
+
+static const struct i2c_device_id aic_i2c_id[] = {
+	{"tlv320aic3262", TLV320AIC3262},
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, aic_i2c_id);
+
+static struct i2c_driver aic_i2c_driver = {
+	.driver = {
+		.name	= "tlv320aic",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= aic_i2c_probe,
+	.remove		= aic_i2c_remove,
+	.id_table	= aic_i2c_id,
+};
+
+module_i2c_driver(aic_i2c_driver);
+
+MODULE_DESCRIPTION("TLV320AIC I2C bus interface");
+MODULE_AUTHOR("Mukund Navada <navada@ti.com>");
+MODULE_AUTHOR("Mehar Bajwa <mehar.bajwa@ti.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

