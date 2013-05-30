Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740Ab3E3TbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:31:06 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.204]:55435 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759558Ab3E3Ta7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:30:59 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1369942251!22124240!8
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] pwm: add sysfs interface
Date: Thu, 30 May 2013 12:30:11 -0700
User-Agent: KMail/1.9.9
CC: <linux-pwm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <thierry.reding@gmail.com>, <poeschel@lemonage.de>, <rmallon@gmai.com>,
        <rob@landley.net>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305301230.11569.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple sysfs interface to the generic PWM framework.

  /sys/class/pwm/
  `-- pwmchipN/          for each PWM chip
      |-- export         (w/o) ask the kernel to export a PWM channel
      |-- npwn           (r/o) number of PWM channels in this PWM chip
      |-- pwmX/          for each exported PWM channel (per PWM chip)
      |   |-- duty_ns    (r/w) duty cycle (in nanoseconds)
      |   |-- enable     (r/w) enable/disable PWM
      |   |-- period_ns  (r/w) period (in nanoseconds)
      |   `-- polarity   (r/w) polarity of PWM
      `-- unexport       (w/o) return a PWM channel to the kernel

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Lars Poeschel <poeschel@lemonage.de>
Cc: Ryan Mallon <rmallon@gmai.com>
Cc: Rob Landley <rob@landley.net>
---
v2: * add API documentation and update Documentation/pwm.txt
    * fix some issues pointed out by Ryan Mallon
    * add the pwm attributes to dev.groups so they are created
      when the device is registered for the exported PWM.

 Documentation/ABI/testing/sysfs-class-pwm |  80 +++++++
 Documentation/pwm.txt                     |  39 ++++
 drivers/pwm/Kconfig                       |  12 +
 drivers/pwm/Makefile                      |   1 +
 drivers/pwm/core.c                        |  25 ++-
 drivers/pwm/pwm-sysfs.c                   | 350 ++++++++++++++++++++++++++++++
 include/linux/pwm.h                       |  28 +++
 7 files changed, 533 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-pwm
 create mode 100644 drivers/pwm/pwm-sysfs.c

diff --git a/Documentation/ABI/testing/sysfs-class-pwm b/Documentation/ABI/testing/sysfs-class-pwm
new file mode 100644
index 0000000..eaa4e1f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-pwm
@@ -0,0 +1,80 @@
+What:		/sys/class/pwm/
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		The pwm/ class sub-directory belongs to the Generic PWM
+		Framework and provides a sysfs interface for using PWM
+		channels.
+
+What:		/sys/class/pwm/pwmchipN/
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		A /sys/class/pwm/pwmchipN directory is created for each
+		probed PWM controller/chip where N is the base of the
+		PWM chip.
+
+What:		/sys/class/pwm/pwmchipN/npwm
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		The number of PWM channels supported by the PWM chip.
+
+What:		/sys/class/pwm/pwmchipN/export
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		Exports a PWM channel from the PWM chip for sysfs control.
+		Value is between 0 and /sys/class/pwm/pwmchipN/npwm - 1.
+
+What:		/sys/class/pwm/pwmchipN/unexport
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		Unexports a PWM channel.
+
+What:		/sys/class/pwm/pwmchipN/pwmX
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		A /sys/class/pwm/pwmchipN/pwmX directory is created for
+		each exported PWM channel where X is the PWM channel number.
+
+What:		/sys/class/pwm/pwmchipN/pwmX/period_ns
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		Sets the PWM period in nanoseconds.
+
+What:		/sys/class/pwm/pwmchipN/pwmX/duty_ns
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		Sets the PWM duty cycle in nanoseconds, default is half the
+		/sys/class/pwm/pwmchipN/pwmX/period_ns.
+
+What:		/sys/class/pwm/pwmchipN/pwmX/polarity
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		Sets the output polarity of the PWM.
+		0 is normal polarity
+		1 is inversed polarity
+
+What:		/sys/class/pwm/pwmchipN/pwmX/enable
+Date:		May 2013
+KernelVersion:	3.11
+Contact:	H Hartley Sweeten <hsweeten@visionengravers.com>
+Description:
+		Enables/disables the PWM.
+		0 is disabled
+		1 is enabled
diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
index 7d2b4c9..b58526d 100644
--- a/Documentation/pwm.txt
+++ b/Documentation/pwm.txt
@@ -45,6 +45,45 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
 
 To start/stop toggling the PWM output use pwm_enable()/pwm_disable().
 
+Using PWMs with the sysfs interface
+-----------------------------------
+
+You have to enable CONFIG_PWM_SYSFS in your kernel configuration to use
+the sysfs interface. It is exposed at /sys/class/pwm/. Each probed PWM
+controller/chip will be exported as pwmchipN, where N is the base of the
+PWM chip. Inside the directory you will find:
+
+npwm - The number of PWM channels this chip supports (read-only).
+
+export - Exports a PWM channel for use with sysfs (write-only).
+
+unexport - Unexports a PWM channel from sysfs (write-only).
+
+The PWM channels are PWM chip specific from 0 to npwn-1.
+
+When a PWM channel is exported a pwmX directory will be created in the
+pwmchipN directory it is associated with, where X is the channel number
+that was exported. The following properties will then be available:
+
+period_ns - The total period of the PWM (read/write).
+	Value is in nanoseconds and is the sum of the active and inactive
+	time of the PWM. If duty_ns is zero when this property is written
+	it will be automatically set to half the period_ns.
+
+duty_ns - The active time of the PWM (read/write).
+	Value is in nanoseconds and must be less than the period_ns.
+
+polarity - Changes the polarity of the PWM (read/write).
+	Writes to this property only work if the PWM chip supports changing
+	the polarity. The polarity can only be changed if the PWM is not
+	enabled.
+	0 - normal polarity
+	1 - inversed polarity
+
+enable - Enables/disables the PWM (read/write).
+	0 - disabled
+	1 - enabled
+
 Implementing a PWM driver
 -------------------------
 
diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 115b644..e77405d 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -28,6 +28,18 @@ menuconfig PWM
 
 if PWM
 
+config PWM_SYSFS
+	bool "/sys/class/pwm/... (sysfs interface)"
+	depends on SYSFS
+	help
+	  Say Y here to provide a sysfs interface to control PWMs.
+
+	  For every instance of a PWM device there is a pwmchipN directory
+	  created in /sys/class/pwm. Use the export attribute to request
+	  a PWM to be accessible from userspace and the unexport attribute
+	  to return the PWM to the kernel. Each exported PWM will have a
+	  pwmX directory in the pwmchipN it is associated with.
+
 config PWM_AB8500
 	tristate "AB8500 PWM support"
 	depends on AB8500_CORE && ARCH_U8500
diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
index 94ba21e..fb92e1d 100644
--- a/drivers/pwm/Makefile
+++ b/drivers/pwm/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_PWM)		+= core.o
+obj-$(CONFIG_PWM_SYSFS)		+= pwm-sysfs.o
 obj-$(CONFIG_PWM_AB8500)	+= pwm-ab8500.o
 obj-$(CONFIG_PWM_ATMEL_TCB)	+= pwm-atmel-tcb.o
 obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 32221cb..f67465c 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -274,6 +274,8 @@ int pwmchip_add(struct pwm_chip *chip)
 	if (IS_ENABLED(CONFIG_OF))
 		of_pwmchip_add(chip);
 
+	pwmchip_sysfs_export(chip);
+
 out:
 	mutex_unlock(&pwm_lock);
 	return ret;
@@ -310,6 +312,8 @@ int pwmchip_remove(struct pwm_chip *chip)
 
 	free_pwms(chip);
 
+	pwmchip_sysfs_unexport(chip);
+
 out:
 	mutex_unlock(&pwm_lock);
 	return ret;
@@ -402,10 +406,19 @@ EXPORT_SYMBOL_GPL(pwm_free);
  */
 int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
 {
+	int err;
+
 	if (!pwm || duty_ns < 0 || period_ns <= 0 || duty_ns > period_ns)
 		return -EINVAL;
 
-	return pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
+	err = pwm->chip->ops->config(pwm->chip, pwm, duty_ns, period_ns);
+	if (err)
+		return err;
+
+	pwm->duty = duty_ns;
+	pwm->period = period_ns;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(pwm_config);
 
@@ -418,6 +431,8 @@ EXPORT_SYMBOL_GPL(pwm_config);
  */
 int pwm_set_polarity(struct pwm_device *pwm, enum pwm_polarity polarity)
 {
+	int err;
+
 	if (!pwm || !pwm->chip->ops)
 		return -EINVAL;
 
@@ -427,7 +442,13 @@ int pwm_set_polarity(struct pwm_device *pwm, enum pwm_polarity polarity)
 	if (test_bit(PWMF_ENABLED, &pwm->flags))
 		return -EBUSY;
 
-	return pwm->chip->ops->set_polarity(pwm->chip, pwm, polarity);
+	err = pwm->chip->ops->set_polarity(pwm->chip, pwm, polarity);
+	if (err)
+		return err;
+
+	pwm->polarity = polarity;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(pwm_set_polarity);
 
diff --git a/drivers/pwm/pwm-sysfs.c b/drivers/pwm/pwm-sysfs.c
new file mode 100644
index 0000000..a6ceacb
--- /dev/null
+++ b/drivers/pwm/pwm-sysfs.c
@@ -0,0 +1,350 @@
+/*
+ * A simple sysfs interface for the generic PWM framework
+ *
+ * Copyright (C) 2013 H Hartley Sweeten <hsweeten@visionengravers.com>
+ *
+ * Based on previous work by Lars Poeschel <poeschel@lemonage.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/kdev_t.h>
+#include <linux/pwm.h>
+
+struct pwm_export {
+	struct device dev;
+	struct pwm_device *pwm;
+};
+
+static struct pwm_export *dev_to_pwm_export(struct device *dev)
+{
+	return container_of(dev, struct pwm_export, dev);
+}
+
+static struct pwm_device *dev_to_pwm_device(struct device *dev)
+{
+	struct pwm_export *pwm_export = dev_to_pwm_export(dev);
+
+	return pwm_export->pwm;
+}
+
+static ssize_t pwm_period_ns_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	const struct pwm_device *pwm = dev_to_pwm_device(dev);
+
+	return sprintf(buf, "%u\n", pwm->period);
+}
+
+static ssize_t pwm_period_ns_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t size)
+{
+	struct pwm_device *pwm = dev_to_pwm_device(dev);
+	unsigned int duty = pwm->duty;
+	unsigned int val;
+	int ret;
+
+	ret = kstrtouint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	/* if not set, default to 50% duty cycle */
+	if (duty == 0)
+		duty = val / 2;
+
+	ret = pwm_config(pwm, duty, val);
+
+	return ret ? : size;
+}
+
+static ssize_t pwm_duty_ns_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	const struct pwm_device *pwm = dev_to_pwm_device(dev);
+
+	return sprintf(buf, "%u\n", pwm->duty);
+}
+
+static ssize_t pwm_duty_ns_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t size)
+{
+	struct pwm_device *pwm = dev_to_pwm_device(dev);
+	unsigned int val;
+	int ret;
+
+	ret = kstrtouint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	ret = pwm_config(pwm, val, pwm->period);
+
+	return ret ? : size;
+}
+
+static ssize_t pwm_enable_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	const struct pwm_device *pwm = dev_to_pwm_device(dev);
+	int enabled = test_bit(PWMF_ENABLED, &pwm->flags);
+
+	return sprintf(buf, "%d\n", enabled);
+}
+
+static ssize_t pwm_enable_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t size)
+{
+	struct pwm_device *pwm = dev_to_pwm_device(dev);
+	int val;
+	int ret;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	switch (val) {
+	case 0:
+		pwm_disable(pwm);
+		ret = 0;
+		break;
+	case 1:
+		ret = pwm_enable(pwm);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret ? : size;
+}
+
+static ssize_t pwm_polarity_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	const struct pwm_device *pwm = dev_to_pwm_device(dev);
+
+	return sprintf(buf, "%d\n", pwm->polarity);
+}
+
+static ssize_t pwm_polarity_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t size)
+{
+	struct pwm_device *pwm = dev_to_pwm_device(dev);
+	enum pwm_polarity polarity;
+	int val;
+	int ret;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	switch (val) {
+	case 0:
+		polarity = PWM_POLARITY_NORMAL;
+		break;
+	case 1:
+		polarity = PWM_POLARITY_INVERSED;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = pwm_set_polarity(pwm, polarity);
+
+	return ret ? : size;
+}
+
+static DEVICE_ATTR(period_ns, 0644, pwm_period_ns_show, pwm_period_ns_store);
+static DEVICE_ATTR(duty_ns, 0644, pwm_duty_ns_show, pwm_duty_ns_store);
+static DEVICE_ATTR(enable, 0644, pwm_enable_show, pwm_enable_store);
+static DEVICE_ATTR(polarity, 0644, pwm_polarity_show, pwm_polarity_store);
+
+static struct attribute *pwm_attrs[] = {
+	&dev_attr_period_ns.attr,
+	&dev_attr_duty_ns.attr,
+	&dev_attr_enable.attr,
+	&dev_attr_polarity.attr,
+	NULL
+};
+
+static struct attribute_group pwm_attr_group = {
+	.attrs		= pwm_attrs,
+};
+
+static const struct attribute_group *pwm_attr_groups[] = {
+	&pwm_attr_group,
+	NULL,
+};
+
+static void pwm_export_release(struct device *dev)
+{
+	struct pwm_export *pwm_export = dev_to_pwm_export(dev);
+
+	kfree(pwm_export);
+}
+
+static int pwm_export(struct device *dev, struct pwm_device *pwm)
+{
+	struct pwm_export *pwm_export;
+	int ret;
+
+	if (test_and_set_bit(PWMF_EXPORTED, &pwm->flags))
+		return -EBUSY;
+
+	pwm_export = kzalloc(sizeof(*pwm_export), GFP_KERNEL);
+	if (!pwm_export) {
+		clear_bit(PWMF_EXPORTED, &pwm->flags);
+		return -ENOMEM;
+	}
+
+	pwm_export->pwm = pwm;
+
+	pwm_export->dev.release = pwm_export_release;
+	pwm_export->dev.parent = dev;
+	pwm_export->dev.devt = MKDEV(0, 0);
+	pwm_export->dev.groups = pwm_attr_groups;
+	dev_set_name(&pwm_export->dev, "pwm%u", pwm->hwpwm);
+
+	ret = device_register(&pwm_export->dev);
+	if (ret) {
+		clear_bit(PWMF_EXPORTED, &pwm->flags);
+		kfree(pwm_export);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int pwm_unexport_match(struct device *dev, void *data)
+{
+	return dev_to_pwm_device(dev) == data;
+}
+
+static int pwm_unexport(struct device *dev, struct pwm_device *pwm)
+{
+	struct device *export_dev;
+	struct pwm_export *pwm_export;
+
+	if (!test_and_clear_bit(PWMF_EXPORTED, &pwm->flags))
+		return -ENODEV;
+
+	export_dev = device_find_child(dev, pwm, pwm_unexport_match);
+	pwm_export = dev_to_pwm_export(export_dev);
+	put_device(&pwm_export->dev);
+	device_unregister(&pwm_export->dev);
+	pwm_put(pwm);
+
+	return 0;
+}
+
+static ssize_t pwm_export_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t len)
+{
+	struct pwm_chip *chip = dev_get_drvdata(dev);
+	struct pwm_device *pwm;
+	unsigned int hwpwm;
+	int ret;
+
+	ret = kstrtouint(buf, 0, &hwpwm);
+	if (ret < 0)
+		return ret;
+
+	if (hwpwm >= chip->npwm)
+		return -ENODEV;
+
+	pwm = pwm_request_from_chip(chip, hwpwm, "sysfs");
+	if (IS_ERR(pwm))
+		return PTR_ERR(pwm);
+
+	ret = pwm_export(dev, pwm);
+	if (ret < 0)
+		pwm_put(pwm);
+
+	return ret ? : len;
+}
+
+static ssize_t pwm_unexport_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct pwm_chip *chip = dev_get_drvdata(dev);
+	unsigned int hwpwm;
+	int ret;
+
+	ret = kstrtouint(buf, 0, &hwpwm);
+	if (ret < 0)
+		return ret;
+
+	if (hwpwm >= chip->npwm)
+		return -ENODEV;
+
+	ret = pwm_unexport(dev, &chip->pwms[hwpwm]);
+
+	return ret ? : len;
+}
+
+static ssize_t pwm_npwm_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	const struct pwm_chip *chip = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", chip->npwm);
+}
+
+static struct device_attribute pwm_chip_attrs[] = {
+	__ATTR(export, 0200, NULL, pwm_export_store),
+	__ATTR(unexport, 0200, NULL, pwm_unexport_store),
+	__ATTR(npwm, 0444, pwm_npwm_show, NULL),
+	__ATTR_NULL,
+};
+
+static struct class pwm_class = {
+	.name		= "pwm",
+	.owner		= THIS_MODULE,
+	.dev_attrs	= pwm_chip_attrs,
+};
+
+void pwmchip_sysfs_export(struct pwm_chip *chip)
+{
+	/*
+	 * If device_create() fails the pwm_chip is still usable by
+	 * the kernel its just not exported.
+	 */
+	chip->dev = device_create(&pwm_class, chip->dev, MKDEV(0, 0), chip,
+				  "pwmchip%d", chip->base);
+}
+
+void pwmchip_sysfs_unexport(struct pwm_chip *chip)
+{
+	if (chip->dev) {
+		put_device(chip->dev);
+		device_unregister(chip->dev);
+	}
+}
+
+static int __init pwm_sysfs_init(void)
+{
+	return class_register(&pwm_class);
+}
+subsys_initcall(pwm_sysfs_init);
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index a4df204..6a43484 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -76,6 +76,7 @@ enum pwm_polarity {
 enum {
 	PWMF_REQUESTED = 1 << 0,
 	PWMF_ENABLED = 1 << 1,
+	PWMF_EXPORTED = 1 << 2,
 };
 
 struct pwm_device {
@@ -86,7 +87,10 @@ struct pwm_device {
 	struct pwm_chip		*chip;
 	void			*chip_data;
 
+	struct device		*dev;	/* for sysfs export */
 	unsigned int		period; /* in nanoseconds */
+	unsigned int		duty;	/* in nanoseconds */
+	enum pwm_polarity	polarity;
 };
 
 static inline void pwm_set_period(struct pwm_device *pwm, unsigned int period)
@@ -100,6 +104,17 @@ static inline unsigned int pwm_get_period(struct pwm_device *pwm)
 	return pwm ? pwm->period : 0;
 }
 
+static inline void pwm_set_duty_cycle(struct pwm_device *pwm, unsigned int duty)
+{
+	if (pwm)
+		pwm->duty = duty;
+}
+
+static inline unsigned int pwm_get_duty_cycle(struct pwm_device *pwm)
+{
+	return pwm ? pwm->duty : 0;
+}
+
 /*
  * pwm_set_polarity - configure the polarity of a PWM signal
  */
@@ -278,4 +293,17 @@ static inline void pwm_add_table(struct pwm_lookup *table, size_t num)
 }
 #endif
 
+#ifdef CONFIG_PWM_SYSFS
+void pwmchip_sysfs_export(struct pwm_chip *chip);
+void pwmchip_sysfs_unexport(struct pwm_chip *chip);
+#else
+static inline void pwmchip_sysfs_export(struct pwm_chip *chip)
+{
+}
+
+static inline void pwmchip_sysfs_unexport(struct pwm_chip *chip)
+{
+}
+#endif /* CONFIG_PWM_SYSFS */
+
 #endif /* __LINUX_PWM_H */
-- 
1.8.1.4

