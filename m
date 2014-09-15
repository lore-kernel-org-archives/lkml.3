Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaIOPDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:03:13 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:47594 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbaIOPDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:03:10 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Collins <collinsd@codeaurora.org>
Subject: [PATCH RESEND] thermal: Add QPNP PMIC temperature alarm driver
Date: Mon, 15 Sep 2014 18:03:03 +0300
Message-Id: <1410793383-30097-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the temperature alarm peripheral found inside
Qualcomm plug-and-play (QPNP) PMIC chips.  The temperature alarm
peripheral outputs a pulse on an interrupt line whenever the
thermal over temperature stage value changes.  Implement an ISR
to manage this interrupt.

Register a thermal zone device in sysfs with mulitple trip points
corresponding to the physical threshold temperatures between over
temperature stages.  The temperature reported by this thermal
zone device should reflect the actual PMIC die temperature if an
ADC is present on the given PMIC.  If no ADC is present, then the
reported temperature should be estimated from the over
temperature stage value.

Send a notification to userspace via sysfs_notify() whenever the
over temperature stage value changes.

Cc: David Collins <collinsd@codeaurora.org>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../bindings/thermal/qpnp-temp-alarm.txt           |  27 ++
 drivers/thermal/Kconfig                            |  12 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/qpnp-temp-alarm.c                  | 519 +++++++++++++++++++++
 4 files changed, 559 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/qpnp-temp-alarm.txt
 create mode 100644 drivers/thermal/qpnp-temp-alarm.c

diff --git a/Documentation/devicetree/bindings/thermal/qpnp-temp-alarm.txt b/Documentation/devicetree/bindings/thermal/qpnp-temp-alarm.txt
new file mode 100644
index 0000000..7eecb74
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/qpnp-temp-alarm.txt
@@ -0,0 +1,27 @@
+Qualcomm QPNP PMIC Temperature Alarm
+
+QPNP temperature alarm peripherals are found inside of Qualcomm PMIC chips
+that utilize the Qualcomm SPMI implementation. These peripherals provide an
+interrupt signal and status register to identify high PMIC die temperature.
+
+Required properties:
+- compatible:      Should contain "qcom,qpnp-temp-alarm".
+- reg:             Specifies the SPMI address temperature alarm device.
+- interrupts:      PMIC temperature alarm interrupt
+
+Optional properties:
+- label:           A string used as a descriptive name for this thermal
+                   device. This name should be 19 characters or less.
+- io-channels:     Should contain IIO channel specifier
+- io-channel-names: "thermal". The ADC channel for temperature reading.
+
+Example:
+
+	thermal-alarm@2400 {
+		compatible = "qcom,qpnp-temp-alarm";
+		reg = <0x2400>;
+		interrupts = <0 0x24 0 IRQ_TYPE_EDGE_RISING>;
+		label = "pm8941_tz";
+		io-channels = <&pm8941_vadc VADC_DIE_TEMP>;
+		io-channel-names = "thermal";
+	};
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 693208e..7371cf9 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -248,4 +248,16 @@ depends on ARCH_STI && OF
 source "drivers/thermal/st/Kconfig"
 endmenu
 
+config QPNP_TEMP_ALARM
+	tristate "Qualcomm QPNP Temperature Alarm"
+	depends on OF && REGMAP_SPMI
+	help
+	  This enables a thermal sysfs driver for Qualcomm plug-and-play (QPNP)
+	  PMIC devices. It shows up in sysfs as a thermal zone with multiple
+	  trip points. The temperature reported by the thermal zone reflects the
+	  real time die temperature if an ADC is present or an estimate of the
+	  temperature based upon the over temperature stage value. Enabling the
+	  thermal zone device via the mode file results in shifting PMIC over
+	  temperature shutdown control from hardware to software.
+
 endif
diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index 31e232f..f54ba76 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -33,3 +33,4 @@ obj-$(CONFIG_INTEL_SOC_DTS_THERMAL)	+= intel_soc_dts_thermal.o
 obj-$(CONFIG_TI_SOC_THERMAL)	+= ti-soc-thermal/
 obj-$(CONFIG_ACPI_INT3403_THERMAL)	+= int3403_thermal.o
 obj-$(CONFIG_ST_THERMAL)	+= st/
+obj-$(CONFIG_QPNP_TEMP_ALARM)	+= qpnp-temp-alarm.o
diff --git a/drivers/thermal/qpnp-temp-alarm.c b/drivers/thermal/qpnp-temp-alarm.c
new file mode 100644
index 0000000..9974059
--- /dev/null
+++ b/drivers/thermal/qpnp-temp-alarm.c
@@ -0,0 +1,519 @@
+/*
+ * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/iio/consumer.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/thermal.h>
+
+#define QPNP_TM_REG_TYPE		0x04
+#define QPNP_TM_REG_SUBTYPE		0x05
+#define QPNP_TM_REG_STATUS		0x08
+#define QPNP_TM_REG_SHUTDOWN_CTRL1	0x40
+#define QPNP_TM_REG_SHUTDOWN_CTRL2	0x42
+#define QPNP_TM_REG_ALARM_CTRL		0x46
+
+#define QPNP_TM_TYPE			0x09
+#define QPNP_TM_SUBTYPE			0x08
+
+#define STATUS_STAGE_MASK		0x03
+
+#define SHUTDOWN_CTRL1_OVERRIDE_STAGE3	0x80
+#define SHUTDOWN_CTRL1_OVERRIDE_STAGE2	0x40
+#define SHUTDOWN_CTRL1_THRESHOLD_MASK	0x03
+
+#define SHUTDOWN_CTRL2_CLEAR_STAGE3	0x80
+#define SHUTDOWN_CTRL2_CLEAR_STAGE2	0x40
+
+#define ALARM_CTRL_FORCE_ENABLE		0x80
+#define ALARM_CTRL_FOLLOW_HW_ENABLE	0x01
+
+/*
+ * Trip point values based on threshold control
+ * 0 = {105 C, 125 C, 145 C}
+ * 1 = {110 C, 130 C, 150 C}
+ * 2 = {115 C, 135 C, 155 C}
+ * 3 = {120 C, 140 C, 160 C}
+*/
+#define TEMP_STAGE_STEP			20000	/* Stage step: 20.000 C */
+#define TEMP_STAGE_HYSTERESIS		2000
+
+#define TEMP_THRESH_MIN			105000	/* Threshold Min: 105 C */
+#define TEMP_THRESH_STEP		5000	/* Threshold step: 5 C */
+
+#define THRESH_MIN			0
+#define THRESH_MAX			3
+
+/* Trip points from most critical to least critical */
+#define TRIP_STAGE3			0
+#define TRIP_STAGE2			1
+#define TRIP_STAGE1			2
+#define TRIP_NUM			3
+
+/* Delay between TEMP_STAT IRQ going high and status value changing in ms */
+#define READ_DELAY_MS			40
+
+/* 2000 uV/K */
+#define MICRO_VOLTS_TO_MILI_CELSIUS(x)	((x) / 2 - 273150)
+
+/* Temperature in Milli Celsius reported during stage 0 if no ADC is present */
+#define DEFAULT_TEMP			37000
+
+struct qpnp_tm_chip {
+	struct delayed_work		work;
+	struct regmap			*map;
+	struct device			*dev;
+	struct thermal_zone_device	*tz_dev;
+	enum thermal_device_mode	mode;
+	const char			*tm_name;
+	int				irq;
+	long				temp;
+	unsigned int			thresh;
+	unsigned int			stage;
+	unsigned int			prev_stage;
+	unsigned int			base;
+	struct iio_channel		*adc;
+};
+
+static inline int qpnp_tm_read(struct qpnp_tm_chip *chip, u16 addr, u8 *buf)
+{
+	return regmap_bulk_read(chip->map, chip->base + addr, buf, 1);
+}
+
+static inline int qpnp_tm_write(struct qpnp_tm_chip *chip, u16 addr, u8 *buf)
+{
+	return regmap_bulk_write(chip->map, chip->base + addr, buf, 1);
+}
+
+static int qpnp_tm_shutdown_override(struct qpnp_tm_chip *chip, bool enable)
+{
+	u8 reg;
+
+	reg = chip->thresh & SHUTDOWN_CTRL1_THRESHOLD_MASK;
+
+	if (enable) {
+		reg |= SHUTDOWN_CTRL1_OVERRIDE_STAGE2;
+		reg |= SHUTDOWN_CTRL1_OVERRIDE_STAGE3;
+	}
+
+	return qpnp_tm_write(chip, QPNP_TM_REG_SHUTDOWN_CTRL1, &reg);
+}
+
+/*
+ * This function updates the internal temp value based on the
+ * current thermal stage and threshold as well as the previous stage
+ */
+static int qpnp_tm_update_temp_no_adc(struct qpnp_tm_chip *chip)
+{
+	unsigned int stage;
+	int rc;
+	u8 reg;
+
+	rc = qpnp_tm_read(chip, QPNP_TM_REG_STATUS, &reg);
+	if (rc < 0)
+		return rc;
+
+	stage = reg & STATUS_STAGE_MASK;
+
+	if (stage > chip->stage) {
+		/* increasing stage, use lower bound */
+		chip->temp = (stage - 1) * TEMP_STAGE_STEP +
+			     chip->thresh * TEMP_THRESH_STEP +
+			     TEMP_STAGE_HYSTERESIS + TEMP_THRESH_MIN;
+	} else if (stage < chip->stage) {
+		/* decreasing stage, use upper bound */
+		chip->temp = stage * TEMP_STAGE_STEP +
+			     chip->thresh * TEMP_THRESH_STEP -
+			     TEMP_STAGE_HYSTERESIS + TEMP_THRESH_MIN;
+	}
+
+	chip->stage = stage;
+
+	return 0;
+}
+
+static int qpnp_tz_get_temp(struct thermal_zone_device *thermal,
+			   unsigned long *temp)
+{
+	struct qpnp_tm_chip *chip = thermal->devdata;
+	int rc, uv;
+
+	if (!temp)
+		return -EINVAL;
+
+	if (IS_ERR(chip->adc)) {
+		rc = qpnp_tm_update_temp_no_adc(chip);
+		if (rc < 0)
+			return rc;
+	} else {
+		rc = iio_read_channel_processed(chip->adc, &uv);
+		if (rc < 0)
+			return rc;
+
+		chip->temp = MICRO_VOLTS_TO_MILI_CELSIUS(uv);
+	}
+
+	*temp = chip->temp < 0 ? 0 : chip->temp;
+
+	return 0;
+}
+
+static int qpnp_tz_get_mode(struct thermal_zone_device *thermal,
+			    enum thermal_device_mode *mode)
+{
+	struct qpnp_tm_chip *chip = thermal->devdata;
+
+	if (!mode)
+		return -EINVAL;
+
+	*mode = chip->mode;
+
+	return 0;
+}
+
+static int qpnp_tz_set_mode(struct thermal_zone_device *thermal,
+			    enum thermal_device_mode mode)
+{
+	struct qpnp_tm_chip *chip = thermal->devdata;
+	int rc;
+
+	if (mode == chip->mode)
+		return 0;
+
+	if (mode == THERMAL_DEVICE_ENABLED)
+		rc = qpnp_tm_shutdown_override(chip, true);
+	else
+		rc = qpnp_tm_shutdown_override(chip, false);
+
+	chip->mode = mode;
+
+	return rc;
+}
+
+static int qpnp_tz_get_trip_type(struct thermal_zone_device *thermal, int trip,
+			       enum thermal_trip_type *type)
+{
+	if (trip < 0 || !type)
+		return -EINVAL;
+
+	switch (trip) {
+	case TRIP_STAGE3:
+		*type = THERMAL_TRIP_CRITICAL;
+		break;
+	case TRIP_STAGE2:
+		*type = THERMAL_TRIP_HOT;
+		break;
+	case TRIP_STAGE1:
+		*type = THERMAL_TRIP_HOT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int qpnp_tz_get_trip_temp(struct thermal_zone_device *thermal, int trip,
+				unsigned long *temp)
+{
+	struct qpnp_tm_chip *chip = thermal->devdata;
+	int thresh_temp;
+
+	if (trip < 0 || !temp)
+		return -EINVAL;
+
+	thresh_temp = chip->thresh * TEMP_THRESH_STEP + TEMP_THRESH_MIN;
+
+	switch (trip) {
+	case TRIP_STAGE3:
+		thresh_temp += 2 * TEMP_STAGE_STEP;
+		break;
+	case TRIP_STAGE2:
+		thresh_temp += TEMP_STAGE_STEP;
+		break;
+	case TRIP_STAGE1:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*temp = thresh_temp;
+
+	return 0;
+}
+
+static int qpnp_tz_get_crit_temp(struct thermal_zone_device *thermal,
+				 unsigned long *temp)
+{
+	struct qpnp_tm_chip *chip = thermal->devdata;
+
+	if (!temp)
+		return -EINVAL;
+
+	*temp = chip->thresh * TEMP_THRESH_STEP + TEMP_THRESH_MIN +
+		2 * TEMP_STAGE_STEP;
+
+	return 0;
+}
+
+static irqreturn_t qpnp_tm_isr(int irq, void *data)
+{
+	struct qpnp_tm_chip *chip = data;
+
+	schedule_delayed_work(&chip->work, msecs_to_jiffies(READ_DELAY_MS) + 1);
+
+	return IRQ_HANDLED;
+}
+
+static void qpnp_tm_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct qpnp_tm_chip *chip;
+	int rc, uv;
+	u8 reg;
+
+	dwork = container_of(work, struct delayed_work, work);
+	chip = container_of(dwork, struct qpnp_tm_chip, work);
+
+	if (IS_ERR(chip->adc)) {
+		rc = qpnp_tm_update_temp_no_adc(chip);
+		if (rc < 0)
+			return;
+	} else {
+		rc = qpnp_tm_read(chip, QPNP_TM_REG_STATUS, &reg);
+		if (rc < 0)
+			return;
+
+		chip->stage = reg & STATUS_STAGE_MASK;
+
+		rc = iio_read_channel_processed(chip->adc, &uv);
+		if (rc < 0)
+			return;
+
+		chip->temp = MICRO_VOLTS_TO_MILI_CELSIUS(uv);
+	}
+
+	if (chip->stage != chip->prev_stage) {
+		chip->prev_stage = chip->stage;
+
+		dev_warn(chip->dev, "Thermal alarm stage %u, threshold %u, temp %ld mC\n",
+			 chip->stage, chip->thresh, chip->temp);
+
+		thermal_zone_device_update(chip->tz_dev);
+
+		/* Notify user space */
+		sysfs_notify(&chip->tz_dev->device.kobj, NULL, "type");
+	}
+}
+
+/*
+ * This function initializes the internal temp value based on only the
+ * current thermal stage and threshold. Setup threshold control and
+ * disable shutdown override.
+ */
+static int qpnp_tm_init(struct qpnp_tm_chip *chip)
+{
+	int rc;
+	u8 reg;
+
+	chip->thresh = THRESH_MIN;
+	chip->temp = DEFAULT_TEMP;
+
+	rc = qpnp_tm_read(chip, QPNP_TM_REG_STATUS, &reg);
+	if (rc < 0)
+		return rc;
+
+	chip->stage = reg & STATUS_STAGE_MASK;
+
+	if (chip->stage)
+		chip->temp = chip->thresh * TEMP_THRESH_STEP +
+			     (chip->stage - 1) * TEMP_STAGE_STEP +
+			     TEMP_THRESH_MIN;
+
+	/*
+	 * Set threshold and disable software override of stage 2 and 3
+	 * shutdowns.
+	 */
+	reg = chip->thresh & SHUTDOWN_CTRL1_THRESHOLD_MASK;
+	rc = qpnp_tm_write(chip, QPNP_TM_REG_SHUTDOWN_CTRL1, &reg);
+	if (rc < 0)
+		return rc;
+
+	/* Enable the thermal alarm PMIC module in always-on mode. */
+	reg = ALARM_CTRL_FORCE_ENABLE;
+	rc = qpnp_tm_write(chip, QPNP_TM_REG_ALARM_CTRL, &reg);
+
+	return rc;
+}
+
+static struct thermal_zone_device_ops qpnp_tz_ops = {
+	.get_temp = qpnp_tz_get_temp,
+	.get_mode = qpnp_tz_get_mode,
+	.set_mode = qpnp_tz_set_mode,
+	.get_trip_type = qpnp_tz_get_trip_type,
+	.get_trip_temp = qpnp_tz_get_trip_temp,
+	.get_crit_temp = qpnp_tz_get_crit_temp,
+};
+
+static int qpnp_tm_probe(struct platform_device *pdev)
+{
+	struct qpnp_tm_chip *chip;
+	struct device_node *node;
+	struct resource *res;
+	u8 type, subtype;
+	int rc = 0;
+
+	node = pdev->dev.of_node;
+
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	dev_set_drvdata(&pdev->dev, chip);
+
+	chip->dev = &pdev->dev;
+	INIT_DELAYED_WORK(&chip->work, qpnp_tm_work);
+
+	chip->map = dev_get_regmap(chip->dev->parent, NULL);
+	if (!chip->map)
+		return -ENXIO;
+
+	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+	if (!res)
+		return -ENXIO;
+
+	chip->base = res->start;
+
+	rc = qpnp_tm_read(chip, QPNP_TM_REG_TYPE, &type);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "could not read type\n");
+		return rc;
+	}
+
+	rc = qpnp_tm_read(chip, QPNP_TM_REG_SUBTYPE, &subtype);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "could not read subtype\n");
+		return rc;
+	}
+
+	if (type != QPNP_TM_TYPE || subtype != QPNP_TM_SUBTYPE) {
+		dev_err(&pdev->dev, "invalid type %02x or subtype %02x\n",
+			type, subtype);
+		return -ENODEV;
+	}
+
+	chip->irq = platform_get_irq(pdev, 0);
+	if (chip->irq < 0)
+		return chip->irq;
+
+	chip->tm_name = of_get_property(node, "label", NULL);
+	if (!chip->tm_name)
+		chip->tm_name = dev_name(chip->dev);
+
+	chip->adc = iio_channel_get(chip->dev, "thermal");
+	if (PTR_ERR(chip->adc) == -EPROBE_DEFER)
+		return PTR_ERR(chip->adc);
+
+	rc = qpnp_tm_init(chip);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "init failed\n");
+		return rc;
+	}
+
+	/* Start in HW control. Switch to SW control when user changes mode. */
+	chip->mode = THERMAL_DEVICE_DISABLED;
+
+	chip->tz_dev = thermal_zone_device_register(chip->tm_name, TRIP_NUM, 0,
+						    chip, &qpnp_tz_ops, NULL,
+						    0, 0);
+	if (IS_ERR(chip->tz_dev)) {
+		dev_err(&pdev->dev, "TZ registration failed\n");
+		return PTR_ERR(chip->tz_dev);
+	}
+
+	rc = devm_request_irq(chip->dev, chip->irq, qpnp_tm_isr,
+			      IRQF_TRIGGER_RISING, chip->tm_name, chip);
+	if (rc < 0)
+		thermal_zone_device_unregister(chip->tz_dev);
+
+	return rc;
+}
+
+static int qpnp_tm_remove(struct platform_device *pdev)
+{
+	struct qpnp_tm_chip *chip = dev_get_drvdata(&pdev->dev);
+
+	cancel_delayed_work_sync(&chip->work);
+	thermal_zone_device_unregister(chip->tz_dev);
+	qpnp_tm_shutdown_override(chip, false);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int qpnp_tm_suspend(struct device *dev)
+{
+	struct qpnp_tm_chip *chip = dev_get_drvdata(dev);
+
+	/* Clear override bits in suspend to allow hardware control */
+	qpnp_tm_shutdown_override(chip, false);
+
+	return 0;
+}
+
+static int qpnp_tm_resume(struct device *dev)
+{
+	struct qpnp_tm_chip *chip = dev_get_drvdata(dev);
+
+	/* Override hardware actions so software can control */
+	if (chip->mode == THERMAL_DEVICE_ENABLED)
+		qpnp_tm_shutdown_override(chip, true);
+
+	return 0;
+}
+
+static const struct dev_pm_ops qpnp_tm_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(qpnp_tm_suspend, qpnp_tm_resume)
+};
+
+#define QPNP_TM_PM_OPS	(&qpnp_tm_pm_ops)
+#else
+#define QPNP_TM_PM_OPS	NULL
+#endif
+
+static struct of_device_id qpnp_tm_match_table[] = {
+	{ .compatible = "qcom,qpnp-temp-alarm" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, qpnp_tm_match_table);
+
+static struct platform_driver qpnp_tm_driver = {
+	.driver = {
+		.name = "qpnp-temp-alarm",
+		.of_match_table = qpnp_tm_match_table,
+		.owner = THIS_MODULE,
+		.pm = QPNP_TM_PM_OPS,
+	},
+	.probe  = qpnp_tm_probe,
+	.remove = qpnp_tm_remove,
+};
+module_platform_driver(qpnp_tm_driver);
+
+MODULE_DESCRIPTION("QPNP PMIC Temperature Alarm driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

