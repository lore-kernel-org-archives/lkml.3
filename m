Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3KETzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:55:42 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4517 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433Ab3KETzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:55:39 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Wendy Ng" <wendy.ng@broadcom.com>
To: "Rob Herring" <rob.herring@calxeda.com>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Eduardo Valentin" <eduardo.valentin@ti.com>,
        "Kumar Gala" <galak@codeaurora.org>
cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Christian Daudt" <bcm@fixthebug.org>,
        "Markus Mayer" <mmayer@broadcom.com>,
        "Tim Kryger" <tim.kryger@linaro.org>,
        "Matt Porter" <matt.porter@linaro.org>,
        "Wendy Ng" <wendy.ng@broadcom.com>
Subject: [PATCH V2 1/3] thermal: bcm281xx: Add Temperature Monitor
 driver
Date: Tue, 5 Nov 2013 11:54:42 -0800
Message-ID: <1383681284-17643-2-git-send-email-wendy.ng@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383681284-17643-1-git-send-email-wendy.ng@broadcom.com>
References: <1383681284-17643-1-git-send-email-wendy.ng@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E6792AE1505061208-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the support for Temperature Monitor (TMON) driver for
Broadcom bcm281xx SoCs. This driver plugs into the Thermal Framework.

Note that this version of the TMON driver does support interrupt-driven
mode -- only polling-mode of the thermal framework can be used.

Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
Reviewed-by: Markus Mayer <mmayer@broadcom.com>
Reviewed-by: Christian Daudt <csd@broadcom.com>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Acked-by: Kumar Gala <galak@codeaurora.org>
---
 .../bindings/thermal/bcm-kona-thermal.txt          |   27 +++
 drivers/thermal/Kconfig                            |   11 ++
 drivers/thermal/Makefile                           |    1 +
 drivers/thermal/bcm_kona_tmon.c                    |  173 ++++++++++++++++++++
 4 files changed, 212 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
 create mode 100644 drivers/thermal/bcm_kona_tmon.c

diff --git a/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
new file mode 100644
index 0000000..f1059e5
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/bcm-kona-thermal.txt
@@ -0,0 +1,27 @@
+* Broadcom Kona TMON bindings
+
+This version is for the Kona family of SoCs.  The TMON (Temperature Monitor)
+block in a Kona SoC device is used to measure the chip temperature at constant
+intervals.
+The TMON block asserts an interrupt if temperature exceeds a user programmed
+threshold value.  The TMON block would reset the entire device once it
+reaches a critical temperature which is also a programmable setting.
+
+Required properties:
+- compatible: "brcm,bcm11351-tmon", "brcm,kona-tmon"
+- reg: Address range of the thermal register
+- clocks: clock specifier of clock that drives the TMON block
+- interrupts: the interrupt signal associated with the TMON block
+- #thermal-sensor-cells: shall be 0. only one sensor is supported.
+Refer to clock/clock-bindings.txt for the generic clock consumer binding
+Refer to thermal/thermal.txt for the generic thermal sensor binding
+
+
+Example:
+	tmon@34008000 {
+		compatible = "brcm,bcm11351-tmon", "brcm,kona-tmon";
+		reg = <0x34008000 0x0024>;
+		clocks = <&tmon_1m_clk>;
+		interrupts = <GIC_SPI 183 IRQ_TYPE_LEVEL_HIGH>;
+		#thermal-sensor-cells = <0>;
+	};
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 9e7cc3f..02200ad 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -166,6 +166,17 @@ config DB8500_THERMAL
 	  created. Cooling devices can be bound to the trip points to cool this
 	  thermal zone if trip points reached.
 
+config BCM_KONA_TMON_THERMAL
+	tristate "Temperature Monitor driver on Broadcom Kona family of SoCs"
+	depends on ARCH_BCM_MOBILE
+	depends on THERMAL_OF
+	default y
+	help
+	  If you say yes here you get support for the TMON
+	  (Temperature Monitor) in Broadcom Kona family of SoCs.
+	  This also provides the generic support of the Thermal Framework
+	  for Broadcom Kona family of SoCs.
+
 config ARMADA_THERMAL
 	tristate "Armada 370/XP thermal management"
 	depends on ARCH_MVEBU
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 4b03956..5e85354 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_SPEAR_THERMAL)	+= spear_thermal.o
 obj-$(CONFIG_RCAR_THERMAL)	+= rcar_thermal.o
 obj-$(CONFIG_KIRKWOOD_THERMAL)  += kirkwood_thermal.o
 obj-y				+= samsung/
+obj-$(CONFIG_BCM_KONA_TMON_THERMAL)	+= bcm_kona_tmon.o
 obj-$(CONFIG_DOVE_THERMAL)  	+= dove_thermal.o
 obj-$(CONFIG_DB8500_THERMAL)	+= db8500_thermal.o
 obj-$(CONFIG_ARMADA_THERMAL)	+= armada_thermal.o
diff --git a/drivers/thermal/bcm_kona_tmon.c b/drivers/thermal/bcm_kona_tmon.c
new file mode 100644
index 0000000..69ae0b2
--- /dev/null
+++ b/drivers/thermal/bcm_kona_tmon.c
@@ -0,0 +1,173 @@
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
+*  Broadcom Kona Temperature Monitor (TMON) driver
+*
+*  Note: The TMON hardware monitors a single sensor.
+*/
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/thermal.h>
+
+
+/* From TMON Register Database */
+#define TMON_TEMP_VAL_OFFSET			0x0000001c
+#define TMON_TEMP_VAL_TEMP_VAL_SHIFT		0
+#define TMON_TEMP_VAL_TEMP_VAL_MASK		0x000003ff
+
+/* Broadcom TMON Private Data Structure */
+struct bcm_tmon_data_priv {
+	void __iomem *base;
+	struct clk *external_clk;
+	struct thermal_zone_device *therm_dev;
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
+static int bcm_get_temp(void *sensor_data, long *temp)
+{
+	u32 raw;
+	long mcelsius;
+	struct bcm_tmon_data_priv *priv = sensor_data;
+
+	if (!priv) {
+		pr_err("%s: input sensor_data not initialized.\n", __func__);
+		return -EINVAL;
+	}
+
+	raw = (readl(priv->base + TMON_TEMP_VAL_OFFSET)
+		& TMON_TEMP_VAL_TEMP_VAL_MASK) >> TMON_TEMP_VAL_TEMP_VAL_SHIFT;
+
+	pr_debug("%s: raw temp 0x%x\n", __func__, raw);
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
+	pr_debug("%s: final temp %d\n", __func__, (int) *temp);
+
+	return 0;
+}
+
+static const struct of_device_id bcm_kona_tmon_match_table[] = {
+	{ .compatible = "brcm,kona-tmon" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, bcm_kona_tmon_match_table);
+
+static int bcm_kona_tmon_probe(struct platform_device *pdev)
+{
+	struct thermal_zone_device *thermal = NULL;
+	struct bcm_tmon_data_priv *priv;
+	struct resource *res;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "Failed to malloc priv.\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	priv->external_clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(priv->external_clk))
+		return -ENODEV;
+
+	if (clk_prepare_enable(priv->external_clk) != 0)
+		return -EINVAL;
+
+	/*
+	 * Note that get_trend() function is NULL.  This is OK for now as
+	 * we can rely on the get_tz_trend() from the Thermal Framework until
+	 * we come up with a better way to determine the trend.
+	 */
+	thermal = thermal_zone_of_sensor_register(&pdev->dev, 0, priv,
+						bcm_get_temp, NULL);
+
+	if (IS_ERR(thermal)) {
+		dev_err(&pdev->dev, "Failed to register BCM Kona TMON.\n");
+		clk_disable_unprepare(priv->external_clk);
+		return PTR_ERR(thermal);
+	}
+
+	priv->therm_dev = thermal;
+
+	platform_set_drvdata(pdev, priv);
+
+	dev_info(&pdev->dev, "BCM Kona TMON Initialized.\n");
+
+	return 0;
+}
+
+static int bcm_kona_tmon_remove(struct platform_device *pdev)
+{
+	struct bcm_tmon_data_priv *priv = platform_get_drvdata(pdev);
+
+	thermal_zone_of_sensor_unregister(&pdev->dev, priv->therm_dev);
+
+	clk_disable_unprepare(priv->external_clk);
+
+	dev_info(&pdev->dev, "BCM Kona TMON Uninitialized.\n");
+
+	return 0;
+}
+
+static struct platform_driver bcm_kona_tmon_driver = {
+	.driver = {
+		.name = "bcm-kona-tmon",
+		.owner = THIS_MODULE,
+		.of_match_table = bcm_kona_tmon_match_table,
+	},
+	.probe = bcm_kona_tmon_probe,
+	.remove = bcm_kona_tmon_remove,
+};
+
+module_platform_driver(bcm_kona_tmon_driver);
+
+MODULE_DESCRIPTION("Broadcom Kona Temperature Monitor Driver");
+MODULE_AUTHOR("Broadcom Corporation");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:bcm-kona-tmon");
-- 
1.7.9.5


