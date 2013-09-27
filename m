Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3I0Wjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 18:39:45 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1857 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab3I0Wjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 18:39:41 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Wendy Ng" <wendy.ng@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>
cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Wendy Ng" <wendy.ng@broadcom.com>
Subject: [PATCH v2 1/3] thermal: bcm281xx: Add thermal driver
Date: Fri, 27 Sep 2013 15:37:32 -0700
Message-ID: <1380321454-16216-2-git-send-email-wendy.ng@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com>
References: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E58D8151R095396588-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the support for reading out temperature from Broadcom bcm281xx
SoCs.

Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: Christian Daudt <csd@broadcom.com>
---
 .../bindings/thermal/bcm-kona-thermal.txt          |   18 +++
 drivers/thermal/Kconfig                            |   10 ++
 drivers/thermal/Makefile                           |    1 +
 drivers/thermal/bcm_thermal.c                      |  170 ++++++++++++++++++++
 4 files changed, 199 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
 create mode 100644 drivers/thermal/bcm_thermal.c

diff --git a/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
new file mode 100644
index 0000000..acca99e
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
@@ -0,0 +1,18 @@
+* Broadcom Kona Thermal Management Unit
+
+This version is for the BCM281xx family of SoCs.
+
+Required properties:
+- compatible : "brcm,bcm11351-thermal", "brcm,kona-thermal"
+- reg : Address range of the thermal register
+- thermal-name: this entry must be specified and it will be passed into
+thermal_zone_device_register().  This name will also be reported under Hwmon
+sysfs 'name' attribute.
+
+Example:
+	thermal@34008000 {
+		compatible = "brcm,bcm11351-thermal", "brcm,kona-thermal";
+		reg = <0x34008000 0x0024>;
+		thermal-name = "bcm_kona_therm";
+		status = "disabled";
+	};
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index dbfc390..6a5341c 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -134,6 +134,16 @@ config KIRKWOOD_THERMAL
 	  Support for the Kirkwood thermal sensor driver into the Linux thermal
 	  framework. Only kirkwood 88F6282 and 88F6283 have this sensor.
 
+config BCM_THERMAL
+	tristate "Temperature sensor on Broadcom BCM281xx family of SoCs"
+	depends on ARCH_BCM_MOBILE
+	default y
+	help
+	  If you say yes here you get support for TMU (Thermal Management
+	  Unit) on Broadcom BCM281xx family of SoCs. This provides thermal
+	  monitoring of CPU clusters, graphics, and SoC glue, but does not
+	  include monitoring of charger temperature.
+
 config DOVE_THERMAL
 	tristate "Temperature sensor on Marvell Dove SoCs"
 	depends on ARCH_DOVE
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 584b363..3ea8c1c 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
 obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
 obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
 obj-y				+= samsung/
+obj-$(CONFIG_BCM_THERMAL)       += bcm_thermal.o
 obj-$(CONFIG_DOVE_THERMAL)  	+= dove_thermal.o
 obj-$(CONFIG_DB8500_THERMAL)	+= db8500_thermal.o
 obj-$(CONFIG_ARMADA_THERMAL)	+= armada_thermal.o
diff --git a/drivers/thermal/bcm_thermal.c b/drivers/thermal/bcm_thermal.c
new file mode 100644
index 0000000..131d3c4
--- /dev/null
+++ b/drivers/thermal/bcm_thermal.c
@@ -0,0 +1,170 @@
+/*
+ * Copyright 2013 Broadcom Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2,
+ * as published by the Free Software Foundation (the "GPL").
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * A copy of the GPL is available at http://www.broadcom.com/licenses/GPLv2.php,
+ * or by writing to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+/**
+*  Broadcom Thermal Management Unit - bcm_tmu
+*/
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/thermal.h>
+#include <linux/of.h>
+
+/* From TMON Register Database */
+#define TMON_TEMP_VAL_OFFSET			0x0000001c
+#define TMON_TEMP_VAL_TEMP_VAL_SHIFT		0
+#define TMON_TEMP_VAL_TEMP_VAL_MASK		0x000003ff
+
+/* Broadcom Thermal Zone Device Structure */
+struct bcm_thermal_zone_priv {
+	char name[THERMAL_NAME_LENGTH];
+	void __iomem *base;
+};
+
+/* Temperature conversion function for TMON block */
+static long raw_to_mcelsius(u32 raw)
+{
+	/*
+	 * According to Broadcom internal Analog Module Specification
+	 * the formula for converting TMON block output to temperature in
+	 * degree Celsius is:
+	 *	T = 428 - (0.561 * raw)
+	 * Note: the valid operating range for the TMON block is -40C to 125C
+	 */
+	return 428000 - (561 * (long)raw);
+}
+
+/* Get temperature callback function for thermal zone */
+static int bcm_get_temp(struct thermal_zone_device *thermal,
+			unsigned long *temp)
+{
+	u32 raw;
+	long mcelsius;
+	struct bcm_thermal_zone_priv *priv = thermal->devdata;
+
+	if (!priv) {
+		pr_err("%s: thermal zone number %d devdata not initialized.\n",
+			__func__, thermal->id);
+		return -EINVAL;
+	}
+
+	raw = (readl(priv->base + TMON_TEMP_VAL_OFFSET)
+		& TMON_TEMP_VAL_TEMP_VAL_MASK) >> TMON_TEMP_VAL_TEMP_VAL_SHIFT;
+
+	pr_debug("%s: thermal zone number %d raw temp 0x%x\n", __func__,
+		thermal->id, raw);
+
+	mcelsius = raw_to_mcelsius(raw);
+
+	/*
+	 * Since 'mcelsius' might be negative, we need to limit it to smallest
+	 * unsigned value before returning it to thermal framework.
+	 */
+	if (mcelsius < 0)
+		*temp = 0;
+	else
+		*temp = mcelsius;
+
+	pr_debug("%s: thermal zone number %d final temp %d\n", __func__,
+		thermal->id, (int) *temp);
+
+	return 0;
+}
+
+/* Operation callback functions for thermal zone */
+static struct thermal_zone_device_ops bcm_dev_ops = {
+	.get_temp = bcm_get_temp,
+};
+
+static const struct of_device_id bcm_tmu_match_table[] = {
+	{ .compatible = "brcm,kona-thermal" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm_tmu_match_table);
+
+static int bcm_tmu_probe(struct platform_device *pdev)
+{
+	struct thermal_zone_device *thermal = NULL;
+	struct bcm_thermal_zone_priv *priv;
+	struct resource *res;
+	const char *str;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "Failed to malloc priv.\n");
+		return -ENOMEM;
+	}
+
+	/* Obtain the tmu name from device tree file */
+	if (of_property_read_string(pdev->dev.of_node, "thermal-name",
+			&str) == 0) {
+		strlcpy(priv->name, str, sizeof(priv->name));
+	} else {
+		dev_err(&pdev->dev, "Failed to get thermal-name from DT.\n");
+		return -EINVAL;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	thermal = thermal_zone_device_register(priv->name, 0, 0, priv,
+						&bcm_dev_ops, NULL, 0, 0);
+	if (IS_ERR(thermal)) {
+		dev_err(&pdev->dev,
+			"Failed to register Broadcom thermal zone device.\n");
+		return PTR_ERR(thermal);
+	}
+
+	platform_set_drvdata(pdev, thermal);
+
+	dev_info(&pdev->dev, "Broadcom Thermal Monitor Initialized.\n");
+
+	return 0;
+}
+
+static int bcm_tmu_remove(struct platform_device *pdev)
+{
+	struct thermal_zone_device *broadcom_thermal =
+		platform_get_drvdata(pdev);
+
+	thermal_zone_device_unregister(broadcom_thermal);
+
+	dev_info(&pdev->dev, "Broadcom Thermal Monitor Uninitialized.\n");
+
+	return 0;
+}
+
+static struct platform_driver bcm_tmu_driver = {
+	.driver = {
+		.name = "bcm-thermal",
+		.owner = THIS_MODULE,
+		.of_match_table = bcm_tmu_match_table,
+	},
+	.probe = bcm_tmu_probe,
+	.remove = bcm_tmu_remove,
+};
+
+module_platform_driver(bcm_tmu_driver);
+
+MODULE_DESCRIPTION("Broadcom Thermal Driver");
+MODULE_AUTHOR("Broadcom");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:bcm-thermal");
-- 
1.7.9.5


