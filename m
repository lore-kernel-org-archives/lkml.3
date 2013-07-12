Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab3GLXvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 19:51:51 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38857 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3GLXvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 19:51:49 -0400
To: arnd@arndb.de, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: [PATCH] misc: add driver for Renesas R-Car Gyro-ADC/speed-pulse interfaces
Cc: linux-sh@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Date: Sat, 13 Jul 2013 03:51:42 +0400
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307130351.42967.sergei.shtylyov@cogentembedded.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the driver for Gyro-ADC/speed-pulse interfaces found in Renesas R-Car SoCs.
Though  being two separate devices, they have to be driven together because of
the shared start/stop register (located in Gyro-ADC still). At this time, only
speed-pulse interface is fully supported, the Gyro-ADC is just initialized and
started/stopped synchronously with the speed-pulse interface.  A user interface
is implemented via several sysfs files which allow to read and reset the speed-
pulse interface's registers.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is againt the 'char-misc-next' barnch of Greg KH's 'char-misc.git'.

 drivers/misc/Kconfig                     |   10 +
 drivers/misc/Makefile                    |    1 
 drivers/misc/rcar-gyro-adc-speed-pulse.c |  231 +++++++++++++++++++++++++++++++
 3 files changed, 242 insertions(+)

Index: char-misc/drivers/misc/Kconfig
===================================================================
--- char-misc.orig/drivers/misc/Kconfig
+++ char-misc/drivers/misc/Kconfig
@@ -528,6 +528,16 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config RCAR_GYRO_ADC_SPEED_PULSE
+	tristate "Renesas R-Car Gyro-ADC and speed-pulse interfaces driver"
+	depends on HAS_IOMEM
+	help
+	  This driver allows you to read speed pulse signal characteristics via
+	  sysfs. The Gyro-ADC interface is not currently supported.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rcar_gyro_adc_speed_pulse.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
Index: char-misc/drivers/misc/Makefile
===================================================================
--- char-misc.orig/drivers/misc/Makefile
+++ char-misc/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
+obj-$(CONFIG_RCAR_GYRO_ADC_SPEED_PULSE)	+= rcar-gyro-adc-speed-pulse.o
Index: char-misc/drivers/misc/rcar-gyro-adc-speed-pulse.c
===================================================================
--- /dev/null
+++ char-misc/drivers/misc/rcar-gyro-adc-speed-pulse.c
@@ -0,0 +1,231 @@
+/*
+ * Renesas R-Car Gyro-ADC and speed-pulse interfaces driver
+ *
+ * Copyright (C) 2013  Renesas Solutions Corp.
+ * Copyright (C) 2013  Cogent Embedded, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation; of the License.
+ *
+ * NOTE: Gyro-ADC interface is not really supported yet, just initialized
+ * and started/stopped synchronously with the speed-pulse interface.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/stat.h>
+#include <linux/types.h>
+
+#include <asm/div64.h>
+
+/* Gyro-ADC interface registers */
+#define	ADC_MODE_SELECT			0x00
+#define	ADC_SPEED_START_STOP		0x04
+#define	ADC_CLOCK_LENGTH_COUNT		0x08
+#define	_1_25_MS_LENGTH_COUNT		0x0C
+#define	AD_CH_REAL_DATA(n)		(0x10 + (n) * 4)
+#define	AD_CH_ADD_DATA(n)		(0x30 + (n) * 4)
+#define	AD_CH_10MS_DATA_FIFO(n)		(0x50 + (n) * 4)
+#define	AD_FIFO_STATUS			0x70
+
+/* Speed-pulse interface registers */
+#define	SPEED_PULSE_COUNT_DATA		0x000
+#define	SPEED_PULSE_FILTER_SETTING	0x004
+#define	SPEED_PULSE_COUNT_CLEARING	0x008
+#define	SPEED_PULSE_100MS_LATCH_DATA	0x00C
+#define	_100_MS_INT_COUNT		0x010
+#define	INT_STATUS_AND_CLEAR		0x018
+#define	_500_KHZ_FREQ_COUNT_SETTING	0x01C
+#define	SPEED_PULSE_OFFSET_A		0x100
+#define	SPEED_PULSE_OFFSET_B		0x104
+#define	SPEED_PULSE_WIDTH		0x108
+#define	SPEED_PULSE_OBSERVE_A		0x10C
+#define	SPEED_PULSE_OBSERVE_B		0x110
+#define	SPEED_PULSE_WIDTH_CLEARING	0x114
+#define	SPEED_PULSE_WIDTH_TEST		0x118
+
+struct rcar_adc_sp_priv {
+	void __iomem *adc_base;
+	void __iomem *sp_base;
+	struct clk *adc_clk;
+	struct clk *sp_clk;
+};
+
+static u16 filter_time_const;
+module_param_named(filter, filter_time_const, ushort, S_IRUGO);
+MODULE_PARM_DESC(filter,
+		 "Low-pass filter time constant in microseconds (default=0)");
+
+static ssize_t rcar_adc_sp_show_pulse_count(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct rcar_adc_sp_priv *priv = dev_get_drvdata(dev);
+	u32 value = __raw_readl(priv->sp_base + SPEED_PULSE_COUNT_DATA);
+
+	return sprintf(buf, "%u\n", value);
+}
+
+#define BUILD_CLEAR(what, reg)						\
+static ssize_t rcar_adc_sp_clear_##what(struct device *dev,		\
+					struct device_attribute *attr,	\
+					const char *buf, size_t count)	\
+{									\
+	struct rcar_adc_sp_priv *priv = dev_get_drvdata(dev);		\
+	u32 value;							\
+									\
+	if (kstrtouint(buf, 10, &value) < 0)				\
+		return -EINVAL;						\
+	if (value > 1)							\
+		return -EINVAL;						\
+									\
+	__raw_writel(value, priv->sp_base + (reg));			\
+									\
+	return count;							\
+}
+
+#define BUILD_SHOW(what, reg)						\
+static ssize_t rcar_adc_sp_show_##what(struct device *dev,		\
+				       struct device_attribute *attr,	\
+				       char *buf)			\
+{									\
+	struct rcar_adc_sp_priv *priv = dev_get_drvdata(dev);		\
+	u32 value = __raw_readl(priv->sp_base + (reg));			\
+									\
+	return sprintf(buf, "%u\n", value * 2); /* in us */		\
+}
+
+BUILD_CLEAR(pulse_count, SPEED_PULSE_COUNT_CLEARING)
+BUILD_CLEAR(pulse_width, SPEED_PULSE_WIDTH_CLEARING)
+
+BUILD_SHOW(pulse_width, SPEED_PULSE_WIDTH)
+BUILD_SHOW(pulse_offset, SPEED_PULSE_OFFSET_A)
+BUILD_SHOW(pulse_observed, SPEED_PULSE_OBSERVE_A)
+
+static DEVICE_ATTR(pulse_count, S_IRUGO | S_IWUSR, rcar_adc_sp_show_pulse_count,
+		   rcar_adc_sp_clear_pulse_count);
+static DEVICE_ATTR(pulse_width, S_IRUGO | S_IWUSR, rcar_adc_sp_show_pulse_width,
+		   rcar_adc_sp_clear_pulse_width);
+static DEVICE_ATTR(pulse_offset, S_IRUGO, rcar_adc_sp_show_pulse_offset, NULL);
+static DEVICE_ATTR(pulse_observed, S_IRUGO, rcar_adc_sp_show_pulse_observed,
+		   NULL);
+
+static struct attribute *rcar_adc_sp_attributes[] = {
+	&dev_attr_pulse_count.attr,
+	&dev_attr_pulse_width.attr,
+	&dev_attr_pulse_offset.attr,
+	&dev_attr_pulse_observed.attr,
+	NULL
+};
+
+static const struct attribute_group rcar_adc_sp_attr_group = {
+	.attrs = rcar_adc_sp_attributes,
+};
+
+static __init int rcar_adc_sp_probe(struct platform_device *pdev)
+{
+	struct rcar_adc_sp_priv *priv;
+	struct resource *res;
+	unsigned long freq;
+	u32 value;
+	u64 temp;
+	int err;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, priv);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->adc_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->adc_base))
+		return PTR_ERR(priv->adc_base);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	priv->sp_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->sp_base))
+		return PTR_ERR(priv->sp_base);
+
+	priv->adc_clk = devm_clk_get(&pdev->dev, "gyro-adc");
+	if (IS_ERR(priv->adc_clk))
+		return PTR_ERR(priv->adc_clk);
+
+	priv->sp_clk = devm_clk_get(&pdev->dev, "speed-pulse");
+	if (IS_ERR(priv->sp_clk))
+		return PTR_ERR(priv->sp_clk);
+
+	err = sysfs_create_group(&pdev->dev.kobj, &rcar_adc_sp_attr_group);
+	if (err)
+		return err;
+
+	clk_enable(priv->adc_clk);
+	clk_enable(priv->sp_clk);
+
+	/* Select mode 1 by default */
+	__raw_writel(0, priv->sp_base + ADC_MODE_SELECT);
+
+	freq = clk_get_rate(priv->adc_clk);
+
+	/* Select 10 us period for mode 1 */
+	value = DIV_ROUND_UP(freq * 10, 1000000);
+	if (value & 1)
+		value++;
+	__raw_writel(value, priv->sp_base + ADC_CLOCK_LENGTH_COUNT);
+
+	/* 1.25 ms period */
+	temp = freq * 1250ULL + 999999;
+	do_div(temp, 1000000);
+	value = (u32)temp;
+	__raw_writel(value, priv->sp_base + _1_25_MS_LENGTH_COUNT);
+
+	temp = freq * (u64)filter_time_const / 8 + 999999;
+	do_div(temp, 1000000);
+	value = (u32)temp;
+	__raw_writel(value, priv->sp_base + SPEED_PULSE_FILTER_SETTING);
+
+	freq = clk_get_rate(priv->sp_clk);
+
+	/* 2 us period */
+	value = DIV_ROUND_UP(freq * 2, 1000000);
+	__raw_writel(value, priv->sp_base + _500_KHZ_FREQ_COUNT_SETTING);
+
+	/* Start Gyro-ADC and speed-pulse interfaces */
+	__raw_writel(1, priv->adc_base + ADC_SPEED_START_STOP);
+
+	return 0;
+}
+
+static __exit int rcar_adc_sp_remove(struct platform_device *pdev)
+{
+	struct rcar_adc_sp_priv *priv = platform_get_drvdata(pdev);
+
+	/* Stop Gyro-ADC and speed-pulse interfaces */
+	__raw_writel(0, priv->adc_base + ADC_SPEED_START_STOP);
+
+	clk_disable(priv->sp_clk);
+	clk_disable(priv->adc_clk);
+
+	sysfs_remove_group(&pdev->dev.kobj, &rcar_adc_sp_attr_group);
+	return 0;
+}
+
+static struct platform_driver rcar_adc_sp_driver = {
+	.driver = {
+		.name	= "rcar-gyro-adc-speed-pulse",
+		.owner	= THIS_MODULE,
+	},
+	.remove	= __exit_p(rcar_adc_sp__remove),
+};
+
+module_platform_driver_probe(rcar_adc_sp_driver, rcar_adc_sp_probe);
+
+MODULE_AUTHOR("Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>");
+MODULE_DESCRIPTION("Renesas R-Car Gyro-ADC and speed-pulse interfaces driver");
+MODULE_LICENSE("GPL v2");
