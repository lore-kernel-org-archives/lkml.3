Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3JNV7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:59:15 -0400
Received: from dukecmmtar04.coxmail.com ([68.99.120.47]:38754 "EHLO
	dukecmmtar04.coxmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab3JNV7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:59:13 -0400
X-Greylist: delayed 1357 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Oct 2013 17:59:13 EDT
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: linux-pwm@vger.kernel.org
Subject: [PATCH] pwm: add ep93xx PWM support
Date: Mon, 14 Oct 2013 14:57:48 -0700
User-Agent: KMail/1.9.9
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, thierry.reding@gmail.com,
        arnd@arndb.de, gregkh@linuxfoundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201310141457.49208.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the non-standard EP93xx pwm driver in drivers/misc and add
a new driver for the PWM chips on the EP93xx platforms based on the
PWM framework.

These PWM chips each support 1 PWM channel with programmable duty
cycle, frequency, and polarity inversion.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/Kconfig      |  13 ---
 drivers/misc/Makefile     |   1 -
 drivers/misc/ep93xx_pwm.c | 286 ----------------------------------------------
 drivers/pwm/Kconfig       |   9 ++
 drivers/pwm/Makefile      |   1 +
 drivers/pwm/pwm-ep93xx.c  | 218 +++++++++++++++++++++++++++++++++++
 6 files changed, 228 insertions(+), 300 deletions(-)
 delete mode 100644 drivers/misc/ep93xx_pwm.c
 create mode 100644 drivers/pwm/pwm-ep93xx.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 8dacd4c..c43c66a 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -381,19 +381,6 @@ config HMC6352
 	  This driver provides support for the Honeywell HMC6352 compass,
 	  providing configuration and heading data via sysfs.
 
-config EP93XX_PWM
-	tristate "EP93xx PWM support"
-	depends on ARCH_EP93XX
-	help
-	  This option enables device driver support for the PWM channels
-	  on the Cirrus EP93xx processors.  The EP9307 chip only has one
-	  PWM channel all the others have two, the second channel is an
-	  alternate function of the EGPIO14 pin.  A sysfs interface is
-	  provided to control the PWM channels.
-
-	  To compile this driver as a module, choose M here: the module will
-	  be called ep93xx_pwm.
-
 config DS1682
 	tristate "Dallas DS1682 Total Elapsed Time Recorder with Alarm"
 	depends on I2C
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c235d5b..ecccd00 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -33,7 +33,6 @@ obj-$(CONFIG_APDS9802ALS)	+= apds9802als.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
 obj-$(CONFIG_ISL29020)		+= isl29020.o
 obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
-obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
 obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
 obj-$(CONFIG_C2PORT)		+= c2port/
diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
deleted file mode 100644
index cdb67a9..0000000
--- a/drivers/misc/ep93xx_pwm.c
+++ /dev/null
@@ -1,286 +0,0 @@
-/*
- *  Simple PWM driver for EP93XX
- *
- *	(c) Copyright 2009  Matthieu Crapet <mcrapet@gmail.com>
- *	(c) Copyright 2009  H Hartley Sweeten <hsweeten@visionengravers.com>
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- *  EP9307 has only one channel:
- *    - PWMOUT
- *
- *  EP9301/02/12/15 have two channels:
- *    - PWMOUT
- *    - PWMOUT1 (alternate function for EGPIO14)
- */
-
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/io.h>
-
-#include <mach/platform.h>
-
-#define EP93XX_PWMx_TERM_COUNT	0x00
-#define EP93XX_PWMx_DUTY_CYCLE	0x04
-#define EP93XX_PWMx_ENABLE	0x08
-#define EP93XX_PWMx_INVERT	0x0C
-
-#define EP93XX_PWM_MAX_COUNT	0xFFFF
-
-struct ep93xx_pwm {
-	void __iomem	*mmio_base;
-	struct clk	*clk;
-	u32		duty_percent;
-};
-
-/*
- * /sys/devices/platform/ep93xx-pwm.N
- *   /min_freq      read-only   minimum pwm output frequency
- *   /max_req       read-only   maximum pwm output frequency
- *   /freq          read-write  pwm output frequency (0 = disable output)
- *   /duty_percent  read-write  pwm duty cycle percent (1..99)
- *   /invert        read-write  invert pwm output
- */
-
-static ssize_t ep93xx_pwm_get_min_freq(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-	unsigned long rate = clk_get_rate(pwm->clk);
-
-	return sprintf(buf, "%ld\n", rate / (EP93XX_PWM_MAX_COUNT + 1));
-}
-
-static ssize_t ep93xx_pwm_get_max_freq(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-	unsigned long rate = clk_get_rate(pwm->clk);
-
-	return sprintf(buf, "%ld\n", rate / 2);
-}
-
-static ssize_t ep93xx_pwm_get_freq(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-
-	if (readl(pwm->mmio_base + EP93XX_PWMx_ENABLE) & 0x1) {
-		unsigned long rate = clk_get_rate(pwm->clk);
-		u16 term = readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-
-		return sprintf(buf, "%ld\n", rate / (term + 1));
-	} else {
-		return sprintf(buf, "disabled\n");
-	}
-}
-
-static ssize_t ep93xx_pwm_set_freq(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-	long val;
-	int err;
-
-	err = kstrtol(buf, 10, &val);
-	if (err)
-		return -EINVAL;
-
-	if (val == 0) {
-		writel(0x0, pwm->mmio_base + EP93XX_PWMx_ENABLE);
-	} else if (val <= (clk_get_rate(pwm->clk) / 2)) {
-		u32 term, duty;
-
-		val = (clk_get_rate(pwm->clk) / val) - 1;
-		if (val > EP93XX_PWM_MAX_COUNT)
-			val = EP93XX_PWM_MAX_COUNT;
-		if (val < 1)
-			val = 1;
-
-		term = readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-		duty = ((val + 1) * pwm->duty_percent / 100) - 1;
-
-		/* If pwm is running, order is important */
-		if (val > term) {
-			writel(val, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-			writel(duty, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
-		} else {
-			writel(duty, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
-			writel(val, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-		}
-
-		if (!readl(pwm->mmio_base + EP93XX_PWMx_ENABLE) & 0x1)
-			writel(0x1, pwm->mmio_base + EP93XX_PWMx_ENABLE);
-	} else {
-		return -EINVAL;
-	}
-
-	return count;
-}
-
-static ssize_t ep93xx_pwm_get_duty_percent(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-
-	return sprintf(buf, "%d\n", pwm->duty_percent);
-}
-
-static ssize_t ep93xx_pwm_set_duty_percent(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-	long val;
-	int err;
-
-	err = kstrtol(buf, 10, &val);
-	if (err)
-		return -EINVAL;
-
-	if (val > 0 && val < 100) {
-		u32 term = readl(pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-		u32 duty = ((term + 1) * val / 100) - 1;
-
-		writel(duty, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
-		pwm->duty_percent = val;
-		return count;
-	}
-
-	return -EINVAL;
-}
-
-static ssize_t ep93xx_pwm_get_invert(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-	int inverted = readl(pwm->mmio_base + EP93XX_PWMx_INVERT) & 0x1;
-
-	return sprintf(buf, "%d\n", inverted);
-}
-
-static ssize_t ep93xx_pwm_set_invert(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-	long val;
-	int err;
-
-	err = kstrtol(buf, 10, &val);
-	if (err)
-		return -EINVAL;
-
-	if (val == 0)
-		writel(0x0, pwm->mmio_base + EP93XX_PWMx_INVERT);
-	else if (val == 1)
-		writel(0x1, pwm->mmio_base + EP93XX_PWMx_INVERT);
-	else
-		return -EINVAL;
-
-	return count;
-}
-
-static DEVICE_ATTR(min_freq, S_IRUGO, ep93xx_pwm_get_min_freq, NULL);
-static DEVICE_ATTR(max_freq, S_IRUGO, ep93xx_pwm_get_max_freq, NULL);
-static DEVICE_ATTR(freq, S_IWUSR | S_IRUGO,
-		   ep93xx_pwm_get_freq, ep93xx_pwm_set_freq);
-static DEVICE_ATTR(duty_percent, S_IWUSR | S_IRUGO,
-		   ep93xx_pwm_get_duty_percent, ep93xx_pwm_set_duty_percent);
-static DEVICE_ATTR(invert, S_IWUSR | S_IRUGO,
-		   ep93xx_pwm_get_invert, ep93xx_pwm_set_invert);
-
-static struct attribute *ep93xx_pwm_attrs[] = {
-	&dev_attr_min_freq.attr,
-	&dev_attr_max_freq.attr,
-	&dev_attr_freq.attr,
-	&dev_attr_duty_percent.attr,
-	&dev_attr_invert.attr,
-	NULL
-};
-
-static const struct attribute_group ep93xx_pwm_sysfs_files = {
-	.attrs	= ep93xx_pwm_attrs,
-};
-
-static int ep93xx_pwm_probe(struct platform_device *pdev)
-{
-	struct ep93xx_pwm *pwm;
-	struct resource *res;
-	int ret;
-
-	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
-	if (!pwm)
-		return -ENOMEM;
-
-	pwm->clk = devm_clk_get(&pdev->dev, "pwm_clk");
-	if (IS_ERR(pwm->clk))
-		return PTR_ERR(pwm->clk);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	pwm->mmio_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(pwm->mmio_base))
-		return PTR_ERR(pwm->mmio_base);
-
-	ret = ep93xx_pwm_acquire_gpio(pdev);
-	if (ret)
-		return ret;
-
-	ret = sysfs_create_group(&pdev->dev.kobj, &ep93xx_pwm_sysfs_files);
-	if (ret) {
-		ep93xx_pwm_release_gpio(pdev);
-		return ret;
-	}
-
-	pwm->duty_percent = 50;
-
-	/* disable pwm at startup. Avoids zero value. */
-	writel(0x0, pwm->mmio_base + EP93XX_PWMx_ENABLE);
-	writel(EP93XX_PWM_MAX_COUNT, pwm->mmio_base + EP93XX_PWMx_TERM_COUNT);
-	writel(EP93XX_PWM_MAX_COUNT/2, pwm->mmio_base + EP93XX_PWMx_DUTY_CYCLE);
-
-	clk_enable(pwm->clk);
-
-	platform_set_drvdata(pdev, pwm);
-	return 0;
-}
-
-static int ep93xx_pwm_remove(struct platform_device *pdev)
-{
-	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-
-	writel(0x0, pwm->mmio_base + EP93XX_PWMx_ENABLE);
-	clk_disable(pwm->clk);
-	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_pwm_sysfs_files);
-	ep93xx_pwm_release_gpio(pdev);
-
-	return 0;
-}
-
-static struct platform_driver ep93xx_pwm_driver = {
-	.driver		= {
-		.name	= "ep93xx-pwm",
-		.owner	= THIS_MODULE,
-	},
-	.probe		= ep93xx_pwm_probe,
-	.remove		= ep93xx_pwm_remove,
-};
-module_platform_driver(ep93xx_pwm_driver);
-
-MODULE_AUTHOR("Matthieu Crapet <mcrapet@gmail.com>, "
-	      "H Hartley Sweeten <hsweeten@visionengravers.com>");
-MODULE_DESCRIPTION("EP93xx PWM driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:ep93xx-pwm");
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 75840b5..eece329 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -62,6 +62,15 @@ config PWM_BFIN
 	  To compile this driver as a module, choose M here: the module
 	  will be called pwm-bfin.
 
+config PWM_EP93XX
+	tristate "Cirrus Logic EP93xx PWM support"
+	depends on ARCH_EP93XX
+	help
+	  Generic PWM framework driver for Cirrus Logic EP93xx.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pwm-ep93xx.
+
 config PWM_IMX
 	tristate "i.MX PWM support"
 	depends on ARCH_MXC
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 77a8c18..8b754e4 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_PWM_SYSFS)		+= sysfs.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
 obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
+obj-$(CONFIG_PWM_EP93XX)	+= pwm-ep93xx.o
 obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
 obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
 obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
diff --git a/drivers/pwm/pwm-ep93xx.c b/drivers/pwm/pwm-ep93xx.c
new file mode 100644
index 0000000..43e9b60
--- /dev/null
+++ b/drivers/pwm/pwm-ep93xx.c
@@ -0,0 +1,218 @@
+/*
+ * PWM framework driver for Cirrus Logic EP93xx
+ *
+ * Copyright (C) 2013 H Hartley Sweeten <hsweeten@visionengravers.com>
+ *
+ * EP9301/02 have only one channel:
+ *   platform device ep93xx-pwm.1 - PWMOUT1 (EGPIO14)
+ *
+ * EP9307 has only one channel:
+ *   platform device ep93xx-pwm.0 - PWMOUT
+ *
+ * EP9312/15 have two channels:
+ *   platform device ep93xx-pwm.0 - PWMOUT
+ *   platform device ep93xx-pwm.1 - PWMOUT1 (EGPIO14)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/pwm.h>
+
+#include <asm/div64.h>
+
+#include <mach/platform.h>	/* for ep93xx_pwm_{acquire,release}_gpio() */
+
+#define EP93XX_PWMx_TERM_COUNT	0x00
+#define EP93XX_PWMx_DUTY_CYCLE	0x04
+#define EP93XX_PWMx_ENABLE	0x08
+#define EP93XX_PWMx_INVERT	0x0c
+
+struct ep93xx_pwm {
+	void __iomem *base;
+	struct clk *clk;
+	struct pwm_chip chip;
+};
+
+static inline struct ep93xx_pwm *to_ep93xx_pwm(struct pwm_chip *chip)
+{
+	return container_of(chip, struct ep93xx_pwm, chip);
+}
+
+static int ep93xx_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct platform_device *pdev = to_platform_device(chip->dev);
+
+	return ep93xx_pwm_acquire_gpio(pdev);
+}
+
+static void ep93xx_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct platform_device *pdev = to_platform_device(chip->dev);
+
+	ep93xx_pwm_release_gpio(pdev);
+}
+
+static int ep93xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
+			     int duty_ns, int period_ns)
+{
+	struct ep93xx_pwm *ep93xx_pwm = to_ep93xx_pwm(chip);
+	void __iomem *base = ep93xx_pwm->base;
+	unsigned long long c;
+	unsigned long period_cycles;
+	unsigned long duty_cycles;
+	unsigned long term;
+	int ret = 0;
+
+	/*
+	 * The clock needs to be enabled to access the PWM registers.
+	 * Configuration can be changed at any time.
+	 */
+	if (!test_bit(PWMF_ENABLED, &pwm->flags))
+		clk_enable(ep93xx_pwm->clk);
+
+	c = clk_get_rate(ep93xx_pwm->clk);
+	c *= period_ns;
+	do_div(c, 1000000000);
+	period_cycles = c;
+
+	c = period_cycles;
+	c *= duty_ns;
+	do_div(c, period_ns);
+	duty_cycles = c;
+
+	if (period_cycles < 0x10000 && duty_cycles < 0x10000) {
+		term = readw(base + EP93XX_PWMx_TERM_COUNT);
+
+		/* Order is important if PWM is running */
+		if (period_cycles > term) {
+			writew(period_cycles, base + EP93XX_PWMx_TERM_COUNT);
+			writew(duty_cycles, base + EP93XX_PWMx_DUTY_CYCLE);
+		} else {
+			writew(duty_cycles, base + EP93XX_PWMx_DUTY_CYCLE);
+			writew(period_cycles, base + EP93XX_PWMx_TERM_COUNT);
+		}
+	} else {
+		ret = -EINVAL;
+	}
+
+	if (!test_bit(PWMF_ENABLED, &pwm->flags))
+		clk_disable(ep93xx_pwm->clk);
+
+	return ret;
+}
+
+static int ep93xx_pwm_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
+			       enum pwm_polarity polarity)
+{
+	struct ep93xx_pwm *ep93xx_pwm = to_ep93xx_pwm(chip);
+
+	/*
+	 * The clock needs to be enabled to access the PWM registers.
+	 * Polarity can only be changed when the PWM is disabled.
+	  */
+	clk_enable(ep93xx_pwm->clk);
+	writew(polarity, ep93xx_pwm->base + EP93XX_PWMx_INVERT);
+	clk_disable(ep93xx_pwm->clk);
+
+	return 0;
+}
+
+static int ep93xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct ep93xx_pwm *ep93xx_pwm = to_ep93xx_pwm(chip);
+
+	clk_enable(ep93xx_pwm->clk);
+	writew(0x1, ep93xx_pwm->base + EP93XX_PWMx_ENABLE);
+
+	return 0;
+}
+
+static void ep93xx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+{
+	struct ep93xx_pwm *ep93xx_pwm = to_ep93xx_pwm(chip);
+
+	writew(0x0, ep93xx_pwm->base + EP93XX_PWMx_ENABLE);
+	clk_disable(ep93xx_pwm->clk);
+}
+
+static struct pwm_ops ep93xx_pwm_ops = {
+	.request	= ep93xx_pwm_request,
+	.free		= ep93xx_pwm_free,
+	.config		= ep93xx_pwm_config,
+	.set_polarity	= ep93xx_pwm_polarity,
+	.enable		= ep93xx_pwm_enable,
+	.disable	= ep93xx_pwm_disable,
+	.owner		= THIS_MODULE,
+};
+
+static int ep93xx_pwm_probe(struct platform_device *pdev)
+{
+	struct ep93xx_pwm *ep93xx_pwm;
+	struct resource *res;
+	int ret;
+
+	ep93xx_pwm = devm_kzalloc(&pdev->dev, sizeof(*ep93xx_pwm), GFP_KERNEL);
+	if (!ep93xx_pwm)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ep93xx_pwm->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ep93xx_pwm->base))
+		return PTR_ERR(ep93xx_pwm->base);
+
+	ep93xx_pwm->clk = devm_clk_get(&pdev->dev, "pwm_clk");
+	if (IS_ERR(ep93xx_pwm->clk))
+		return PTR_ERR(ep93xx_pwm->clk);
+
+	ep93xx_pwm->chip.dev = &pdev->dev;
+	ep93xx_pwm->chip.ops = &ep93xx_pwm_ops;
+	ep93xx_pwm->chip.base = -1;
+	ep93xx_pwm->chip.npwm = 1;
+
+	ret = pwmchip_add(&ep93xx_pwm->chip);
+	if (ret < 0)
+		return ret;
+
+	platform_set_drvdata(pdev, ep93xx_pwm);
+	return 0;
+}
+
+static int ep93xx_pwm_remove(struct platform_device *pdev)
+{
+	struct ep93xx_pwm *ep93xx_pwm;
+
+	ep93xx_pwm = platform_get_drvdata(pdev);
+	if (!ep93xx_pwm)
+		return -ENODEV;
+
+	return pwmchip_remove(&ep93xx_pwm->chip);
+}
+
+static struct platform_driver ep93xx_pwm_driver = {
+	.driver		= {
+		.name	= "ep93xx-pwm",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ep93xx_pwm_probe,
+	.remove		= ep93xx_pwm_remove,
+};
+module_platform_driver(ep93xx_pwm_driver);
+
+MODULE_DESCRIPTION("Cirrus Logic EP93xx PWM driver");
+MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");
+MODULE_ALIAS("platform:ep93xx-pwm");
+MODULE_LICENSE("GPL");
-- 
1.8.3.2

