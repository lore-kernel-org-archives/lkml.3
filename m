Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3LSHyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:54:07 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54370 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3LSHyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:54:03 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Elliott@hp.com, samer.el-haj-mahmoud@hp.com,
        Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [RFC PATCH 05/14] rtc: Add RTC driver of ACPI Time and Alarm Device
Date: Thu, 19 Dec 2013 15:51:46 +0800
Message-Id: <1387439515-8926-6-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the RTC driver of ACPI TAD to provide userspace access
ACPI time through RTC interface.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/rtc/Kconfig       |   10 ++
 drivers/rtc/Makefile      |    1 +
 drivers/rtc/rtc-acpitad.c |  294 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-dev.c     |    4 +
 drivers/rtc/rtc-sysfs.c   |    8 ++
 include/linux/rtc.h       |    5 +
 include/uapi/linux/rtc.h  |    5 +
 7 files changed, 327 insertions(+), 0 deletions(-)
 create mode 100644 drivers/rtc/rtc-acpitad.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 0077302..349dbc4 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -878,6 +878,16 @@ config RTC_DRV_NUC900
 	  If you say yes here you get support for the RTC subsystem of the
 	  NUC910/NUC920 used in embedded systems.
 
+config RTC_ACPI_TAD
+	tristate "RTC ACPI Time and Alarm Device driver"
+	help
+	  This driver exposes ACPI 5.0 Time and Alarm Device as RTC device.
+	  Say Y (or M) if you have a computer with ACPI 5.0 firmware that
+	  implemented Time and Alarm Device.
+
+	  To compile this driver as a module, choose M here:
+	  the module will be called rtc_acpitad.
+
 comment "on-CPU RTC drivers"
 
 config RTC_DRV_DAVINCI
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 27b4bd8..bca5ab3 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_RTC_DRV_88PM860X)  += rtc-88pm860x.o
 obj-$(CONFIG_RTC_DRV_88PM80X)	+= rtc-88pm80x.o
 obj-$(CONFIG_RTC_DRV_AB3100)	+= rtc-ab3100.o
 obj-$(CONFIG_RTC_DRV_AB8500)	+= rtc-ab8500.o
+obj-$(CONFIG_RTC_ACPI_TAD)	+= rtc-acpitad.o
 obj-$(CONFIG_RTC_DRV_AS3722)	+= rtc-as3722.o
 obj-$(CONFIG_RTC_DRV_AT32AP700X)+= rtc-at32ap700x.o
 obj-$(CONFIG_RTC_DRV_AT91RM9200)+= rtc-at91rm9200.o
diff --git a/drivers/rtc/rtc-acpitad.c b/drivers/rtc/rtc-acpitad.c
new file mode 100644
index 0000000..065a033
--- /dev/null
+++ b/drivers/rtc/rtc-acpitad.c
@@ -0,0 +1,294 @@
+/* A RTC driver for ACPI 5.0 Time and Alarm Device
+ *
+ * Copyright (C) 2013 SUSE Linux Products GmbH. All rights reserved.
+ * Written by Lee, Chun-Yi (jlee@suse.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/rtc.h>
+#include <linux/platform_device.h>
+#include <linux/acpi.h>
+
+/*
+ * returns day of the year [0-365]
+ */
+static inline int
+compute_yday(struct acpi_time *acpit)
+{
+	/* acpi_time.month is in the [1-12] so, we need -1 */
+	return rtc_year_days(acpit->day, acpit->month - 1, acpit->year);
+}
+
+/*
+ * returns day of the week [0-6] 0=Sunday
+ */
+static int
+compute_wday(struct acpi_time *acpit)
+{
+	int y;
+	int ndays = 0;
+
+	if (acpit->year < 1900) {
+		pr_err("ACPI year < 1900, invalid date\n");
+		return -1;
+	}
+
+	for (y = 1900; y < acpit->year; y++)
+		ndays += 365 + (is_leap_year(y) ? 1 : 0);
+
+	ndays += compute_yday(acpit);
+
+	/*
+	 * 1=1/1/1900 was a Monday
+	 */
+	return (ndays + 1) % 7;
+}
+
+static void
+convert_to_acpi_time(struct rtc_time *tm, struct acpi_time *acpit)
+{
+	acpit->year	    = tm->tm_year + 1900;
+	acpit->month        = tm->tm_mon + 1;
+	acpit->day          = tm->tm_mday;
+	acpit->hour         = tm->tm_hour;
+	acpit->minute       = tm->tm_min;
+	acpit->second       = tm->tm_sec;
+	acpit->milliseconds = 0;
+	acpit->daylight	    = tm->tm_isdst ? ACPI_ISDST : 0;
+}
+
+static void
+convert_from_acpi_time(struct acpi_time *acpit, struct rtc_time *tm)
+{
+	memset(tm, 0, sizeof(*tm));
+	tm->tm_sec	= acpit->second;
+	tm->tm_min	= acpit->minute;
+	tm->tm_hour	= acpit->hour;
+	tm->tm_mday	= acpit->day;
+	tm->tm_mon	= acpit->month - 1;
+	tm->tm_year	= acpit->year - 1900;
+
+	/* day of the week [0-6], Sunday=0 */
+	tm->tm_wday = compute_wday(acpit);
+
+	/* day in the year [1-365]*/
+	tm->tm_yday = compute_yday(acpit);
+
+	switch (acpit->daylight & ACPI_ISDST) {
+	case ACPI_ISDST:
+		tm->tm_isdst = 1;
+		break;
+	case ACPI_TIME_AFFECTED_BY_DAYLIGHT:
+		tm->tm_isdst = 0;
+		break;
+	default:
+		tm->tm_isdst = -1;
+	}
+}
+
+static int acpitad_read_gmtoff(struct device *dev, long int *arg)
+{
+	struct acpi_time *acpit;
+	s16 timezone;
+	int ret;
+
+	acpit = kzalloc(sizeof(struct acpi_time), GFP_KERNEL);
+	if (!acpit)
+		return -ENOMEM;
+
+	ret = acpi_read_time(acpit);
+	if (ret)
+		goto error_read;
+
+	/* transfer minutes to seconds east of UTC for userspace */
+	timezone = (s16)le16_to_cpu(acpit->timezone);
+	*arg = ACPI_UNSPECIFIED_TIMEZONE * 60;
+	if (abs(timezone) != ACPI_UNSPECIFIED_TIMEZONE &&
+	    abs(timezone) <= 1440)
+		*arg = timezone * 60 * -1;
+
+error_read:
+	kfree(acpit);
+
+	return ret;
+}
+
+
+static int acpitad_set_gmtoff(struct device *dev, long int arg)
+{
+	struct acpi_time *acpit;
+	s16 timezone;
+	int ret;
+
+	/* transfer seconds east of UTC to minutes for ACPI */
+	timezone = arg / 60 * -1;
+	if (abs(timezone) > 1440 &&
+	    abs(timezone) != ACPI_UNSPECIFIED_TIMEZONE)
+		return -EINVAL;
+
+	/* can not use -2047 */
+	if (timezone == ACPI_UNSPECIFIED_TIMEZONE * -1)
+		timezone = ACPI_UNSPECIFIED_TIMEZONE;
+
+	acpit = kzalloc(sizeof(struct acpi_time), GFP_KERNEL);
+	if (!acpit)
+		return -ENOMEM;
+
+	ret = acpi_read_time(acpit);
+	if (ret)
+		goto error_read;
+
+	acpit->timezone = (s16)cpu_to_le16(timezone);
+	ret = acpi_set_time(acpit);
+
+error_read:
+	kfree(acpit);
+
+	return ret;
+}
+
+static int acpitad_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	long int gmtoff;
+	int err;
+
+	switch (cmd) {
+	case RTC_RD_GMTOFF:
+		err = acpitad_read_gmtoff(dev, &gmtoff);
+		if (err)
+			return err;
+		return put_user(gmtoff, (unsigned long __user *)arg);
+	case RTC_SET_GMTOFF:
+		return acpitad_set_gmtoff(dev, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return 0;
+}
+
+static int acpitad_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct acpi_time *acpit;
+	int ret;
+
+	acpit = kzalloc(sizeof(struct acpi_time), GFP_KERNEL);
+	if (!acpit)
+		return -ENOMEM;
+
+	ret = acpi_read_time(acpit);
+	if (ret)
+		return ret;
+
+	convert_from_acpi_time(acpit, tm);
+
+	return rtc_valid_tm(tm);
+}
+
+static int acpitad_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct acpi_time *acpit;
+	int ret;
+
+	acpit = kzalloc(sizeof(struct acpi_time), GFP_KERNEL);
+	if (!acpit)
+		return -ENOMEM;
+
+	/* read current timzone to avoid overwrite it by set time */
+	ret = acpi_read_time(acpit);
+	if (ret)
+		goto error_read;
+
+	convert_to_acpi_time(tm, acpit);
+
+	ret = acpi_set_time(acpit);
+
+error_read:
+	kfree(acpit);
+	return ret;
+}
+
+static struct rtc_class_ops acpi_rtc_ops = {
+	.ioctl          = acpitad_rtc_ioctl,
+	.read_time      = acpitad_read_time,
+	.set_time       = acpitad_set_time,
+};
+
+static int acpitad_rtc_probe(struct platform_device *dev)
+{
+	unsigned long cap;
+	struct rtc_device *rtc;
+	int ret;
+
+	ret = acpi_tad_get_capability(&cap);
+	if (ret)
+		return ret;
+
+	if (!(cap & TAD_CAP_GETSETTIME)) {
+		acpi_rtc_ops.read_time = NULL;
+		acpi_rtc_ops.set_time = NULL;
+		pr_warn("No get/set time support\n");
+	}
+
+	/* ACPI Alarm at least need AC wake capability */
+	if (!(cap & TAD_CAP_ACWAKE)) {
+		acpi_rtc_ops.read_alarm = NULL;
+		acpi_rtc_ops.set_alarm = NULL;
+		pr_warn("No AC wake support\n");
+	}
+
+	/* register rtc device */
+	rtc = rtc_device_register("rtc-acpitad", &dev->dev, &acpi_rtc_ops,
+					THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	rtc->uie_unsupported = 1;
+	rtc->caps = (RTC_TZ_CAP | RTC_DST_CAP);
+	platform_set_drvdata(dev, rtc);
+
+	return 0;
+}
+
+static int acpitad_rtc_remove(struct platform_device *dev)
+{
+	struct rtc_device *rtc = platform_get_drvdata(dev);
+
+	rtc_device_unregister(rtc);
+
+	return 0;
+}
+
+static struct platform_driver acpitad_rtc_driver = {
+	.driver = {
+		.name = "rtc-acpitad",
+		.owner = THIS_MODULE,
+	},
+	.probe = acpitad_rtc_probe,
+	.remove = acpitad_rtc_remove,
+};
+
+static int __init acpitad_rtc_init(void)
+{
+	return platform_driver_register(&acpitad_rtc_driver);
+}
+
+static void __exit acpitad_rtc_exit(void)
+{
+	platform_driver_unregister(&acpitad_rtc_driver);
+}
+
+module_init(acpitad_rtc_init);
+module_exit(acpitad_rtc_exit);
+
+MODULE_AUTHOR("Lee, Chun-Yi <jlee@suse.com>");
+MODULE_DESCRIPTION("RTC ACPI Time and Alarm Device driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rtc-acpitad");
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index d049393..aab70e7 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -398,6 +398,10 @@ static long rtc_dev_ioctl(struct file *file,
 			err = -EFAULT;
 		return err;
 
+	case RTC_CAPS_READ:
+		err = put_user(rtc->caps, (unsigned int __user *)uarg);
+		break;
+
 	default:
 		/* Finally try the driver's ioctl interface */
 		if (ops->ioctl) {
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index babd43b..bdffb8f 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -122,6 +122,13 @@ hctosys_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR_RO(hctosys);
 
+static ssize_t
+caps_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+       return sprintf(buf, "%d\n", to_rtc_device(dev)->caps);
+}
+static DEVICE_ATTR_RO(caps);
+
 static struct attribute *rtc_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_date.attr,
@@ -129,6 +136,7 @@ static struct attribute *rtc_attrs[] = {
 	&dev_attr_since_epoch.attr,
 	&dev_attr_max_user_freq.attr,
 	&dev_attr_hctosys.attr,
+	&dev_attr_caps.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(rtc);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index c2c2897..e6380ec 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -116,6 +116,11 @@ struct rtc_device
 	/* Some hardware can't support UIE mode */
 	int uie_unsupported;
 
+	/* Time Zone and Daylight capabilities */
+#define        RTC_TZ_CAP      (1 << 0)
+#define        RTC_DST_CAP     (1 << 1)
+	int caps;
+
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	struct work_struct uie_task;
 	struct timer_list uie_timer;
diff --git a/include/uapi/linux/rtc.h b/include/uapi/linux/rtc.h
index f8c82e6..5533914 100644
--- a/include/uapi/linux/rtc.h
+++ b/include/uapi/linux/rtc.h
@@ -94,6 +94,11 @@ struct rtc_pll_info {
 #define RTC_VL_READ	_IOR('p', 0x13, int)	/* Voltage low detector */
 #define RTC_VL_CLR	_IO('p', 0x14)		/* Clear voltage low information */
 
+#define RTC_RD_GMTOFF  _IOR('p', 0x15, long int)       /* Read time zone return seconds east of UTC */
+#define RTC_SET_GMTOFF _IOW('p', 0x16, long int)       /* Set time zone input seconds east of UTC */
+
+#define RTC_CAPS_READ  _IOR('p', 0x17, unsigned int)   /* Get capabilities, e.g. TZ, DST */
+
 /* interrupt flags */
 #define RTC_IRQF 0x80	/* Any of the following is active */
 #define RTC_PF 0x40	/* Periodic interrupt */
-- 
1.6.4.2

