Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab3EOSrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 14:47:35 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:51786 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759904Ab3EOSre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 14:47:34 -0400
From: johannes.thumshirn@men.de
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH v3] watchdog: New watchdog driver for MEN A21 watchdogs
Date: Wed, 15 May 2013 20:50:10 +0200
Message-Id: <1368643810-2789-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1368560034.24692.4.camel@joe-AO722>
References: <1368560034.24692.4.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@men.de>

This patch adds the driver for the watchdog devices found on MEN Mikro
Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
watchdog framework.

Revision 2:
* Removed unneeded open flag in struct a21_wdt_drv
* Corrected 3bit reason code from gpio
* Additional sysfs files are now part of watchdog sysfs
* Changed OFF/ON delay in ping from 400ms to 10ns
* Reworked timeout setting
* Removed a21_wdt_ioctl(...)

Revision 3:
* Changed pr_{err,info} to dev_{err,info}
* Removed out of memory error print
* Transition from "fast" to "slow" mode not allowed by chip

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 MAINTAINERS                   |    6 +
 drivers/watchdog/Kconfig      |    8 ++
 drivers/watchdog/Makefile     |    1 +
 drivers/watchdog/mena21_wdt.c |  309 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 324 insertions(+)
 create mode 100644 drivers/watchdog/mena21_wdt.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b..3e5b3f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5291,6 +5291,12 @@ F:	drivers/mtd/
 F:	include/linux/mtd/
 F:	include/uapi/mtd/
 
+MEN A21 WATCHDOG DRIVER
+M:	Johannes Thumshirn <johannes.thumshirn@men.de>
+L:	linux-watchdog@vger.kernel.org
+S:	Supported
+F:	drivers/watchdog/mena21_wdt.c
+
 METAG ARCHITECTURE
 M:	James Hogan <james.hogan@imgtec.com>
 S:	Supported
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index e89fc31..192b84d 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1172,6 +1172,14 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
 
 	  The value can be overridden by the wdt_period command-line parameter.
 
+config MEN_A21_WDT
+       tristate "MEN A21 VME CPU Carrier Board Watchdog Timer"
+       select WATCHDOG_CORE
+       help
+        Watchdog driver for MEN A21 VMEbus CPU Carrier Boards.
+
+	If unsure select N here.
+
 # PPC64 Architecture
 
 config WATCHDOG_RTAS
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index a300b94..bffdcb1 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -143,6 +143,7 @@ obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
 obj-$(CONFIG_PIKA_WDT) += pika_wdt.o
 obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
+obj-$(CONFIG_MEN_A21_WDT) += mena21_wdt.o
 
 # PPC64 Architecture
 obj-$(CONFIG_WATCHDOG_RTAS) += wdrtas.o
diff --git a/drivers/watchdog/mena21_wdt.c b/drivers/watchdog/mena21_wdt.c
new file mode 100644
index 0000000..389bd59
--- /dev/null
+++ b/drivers/watchdog/mena21_wdt.c
@@ -0,0 +1,309 @@
+/*
+ * Watchdog driver for the A21 VME CPU Boards
+ *
+ * Copyright (C) 2013 MEN Mikro Elektronik Nuernberg GmbH
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation
+ */
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/reboot.h>
+#include <linux/bitops.h>
+
+static char *reset_causes[] = {
+	"Power On Reset",
+	"CPU Reset Request",
+	"Push Button",
+	"FPGA Reset Request",
+	"Watchdog",
+	"Local Power Bad",
+	"Invalid",
+	"BDI",
+};
+
+#define GPIO_WD_ENAB	169
+#define GPIO_WD_FAST	170
+#define GPIO_WD_TRIG	171
+
+#define GPIO_RST_CAUSE_BASE 166
+
+struct a21_wdt_drv {
+	struct watchdog_device wdt;
+	struct mutex lock;
+};
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+			    __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static ssize_t rebootcause_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned int reset = 0;
+	int i;
+
+	for (i = 0; i < 3; i++)
+		reset |= gpio_get_value(GPIO_RST_CAUSE_BASE + i)
+			 ? (1 << i) : 0;
+
+	if (reset >= 8)
+		return -EIO;
+
+	return sprintf(buf, "%s\n", reset_causes[reset]);
+}
+static DEVICE_ATTR(rebootcause, S_IRUGO, rebootcause_show, NULL);
+
+static ssize_t active_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	return sprintf(buf, "%d\n", !!gpio_get_value(GPIO_WD_ENAB));
+}
+static DEVICE_ATTR(active, S_IRUGO, active_show, NULL);
+
+static ssize_t allow_disable_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	return sprintf(buf, "%d\n", !nowayout);
+}
+static DEVICE_ATTR(allow_disable, S_IRUGO, allow_disable_show, NULL);
+
+static ssize_t fastmode_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	return sprintf(buf, "%d\n", !!gpio_get_value(GPIO_WD_FAST));
+}
+static DEVICE_ATTR(fastmode, S_IRUGO, fastmode_show, NULL);
+
+static int a21_wdt_create_files(struct watchdog_device *wdev)
+{
+	int ret;
+
+	ret = device_create_file(wdev->dev, &dev_attr_rebootcause);
+	if (ret)
+		return ret;
+	ret = device_create_file(wdev->dev, &dev_attr_active);
+	if (ret)
+		return ret;
+	ret = device_create_file(wdev->dev, &dev_attr_allow_disable);
+	if (ret)
+		return ret;
+	ret = device_create_file(wdev->dev, &dev_attr_fastmode);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void a21_wdt_remove_files(struct watchdog_device *wdev)
+{
+	device_remove_file(wdev->dev, &dev_attr_rebootcause);
+	device_remove_file(wdev->dev, &dev_attr_active);
+	device_remove_file(wdev->dev, &dev_attr_allow_disable);
+	device_remove_file(wdev->dev, &dev_attr_fastmode);
+}
+
+static int a21_wdt_start(struct watchdog_device *wdt)
+{
+	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
+
+	mutex_lock(&drv->lock);
+
+	gpio_set_value(GPIO_WD_ENAB, 1);
+
+	mutex_unlock(&drv->lock);
+
+	return 0;
+}
+
+static int a21_wdt_stop(struct watchdog_device *wdt)
+{
+	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
+
+	/* We don't stop if WDOG_NO_WAY_OUT is set */
+	if (test_bit(WDOG_NO_WAY_OUT, &wdt->status))
+		return -EINVAL;
+
+	mutex_lock(&drv->lock);
+
+	gpio_set_value(GPIO_WD_ENAB, 0);
+
+	mutex_unlock(&drv->lock);
+
+	return 0;
+}
+
+static int a21_wdt_ping(struct watchdog_device *wdt)
+{
+	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
+
+	mutex_lock(&drv->lock);
+
+	gpio_set_value(GPIO_WD_TRIG, 0);
+	ndelay(10);
+	gpio_set_value(GPIO_WD_TRIG, 1);
+
+	mutex_unlock(&drv->lock);
+
+	return 0;
+}
+
+static int a21_wdt_set_timeout(struct watchdog_device *wdt,
+			       unsigned int timeout)
+{
+	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
+
+	if (timeout != 1 && timeout != 30) {
+		dev_err(wdt->dev, "Only 1 and 30 allowed as timeout\n");
+		return -EINVAL;
+	}
+
+	if (timeout == 30 && wdt->timeout == 1) {
+		dev_err(wdt->dev,
+			"Transition from fast to slow mode not allowed\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&drv->lock);
+
+	if (timeout == 1)
+		gpio_set_value(GPIO_WD_FAST, 1);
+	else
+		gpio_set_value(GPIO_WD_FAST, 0);
+
+	wdt->timeout = timeout;
+
+	mutex_unlock(&drv->lock);
+
+	return 0;
+}
+
+static int a21_wdt_notify_sys(struct notifier_block *notify, unsigned long code,
+			void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		gpio_set_value(GPIO_WD_ENAB, 0);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block a21_wdt_notifier = {
+	.notifier_call = a21_wdt_notify_sys,
+};
+
+static const struct watchdog_info a21_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "MEN A21 Watchdog",
+};
+
+static const struct watchdog_ops a21_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = a21_wdt_start,
+	.stop = a21_wdt_stop,
+	.ping = a21_wdt_ping,
+	.set_timeout = a21_wdt_set_timeout,
+};
+
+static struct watchdog_device a21_wdt = {
+	.info = &a21_wdt_info,
+	.ops = &a21_wdt_ops,
+	.min_timeout = 1,
+	.max_timeout = 30,
+};
+
+static int a21_wdt_probe(struct platform_device *pdev)
+{
+	struct a21_wdt_drv *drv;
+	int ret;
+
+	dev_info(&pdev->dev, "MEN A21 watchdog timer driver enabled\n");
+
+	drv = devm_kzalloc(&pdev->dev, sizeof(struct a21_wdt_drv), GFP_KERNEL);
+	if (!drv)
+		return -ENOMEM;
+
+	mutex_init(&drv->lock);
+	watchdog_set_nowayout(&a21_wdt, nowayout);
+	watchdog_set_drvdata(&a21_wdt, drv);
+
+	ret = watchdog_register_device(&a21_wdt);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot register watchdog device\n");
+		goto err_register_wd;
+	}
+
+	ret = register_reboot_notifier(&a21_wdt_notifier);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot register reboot notifier\n");
+		goto err_register_notif;
+	}
+
+	ret = a21_wdt_create_files(&a21_wdt);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot create sysfs entries\n");
+		goto err_create_sysfs;
+	}
+
+	dev_set_drvdata(&pdev->dev, drv);
+
+	return 0;
+
+err_create_sysfs:
+	unregister_reboot_notifier(&a21_wdt_notifier);
+err_register_notif:
+	watchdog_unregister_device(&drv->wdt);
+err_register_wd:
+	mutex_destroy(&drv->lock);
+
+	return ret;
+}
+
+static int a21_wdt_remove(struct platform_device *pdev)
+{
+	struct a21_wdt_drv *drv = dev_get_drvdata(&pdev->dev);
+
+	dev_warn(&pdev->dev,
+		"Unregistering A21 watchdog driver, board may reboot\n");
+
+	a21_wdt_remove_files(&drv->wdt);
+
+	watchdog_unregister_device(&drv->wdt);
+	unregister_reboot_notifier(&a21_wdt_notifier);
+
+	mutex_destroy(&drv->lock);
+
+	return 0;
+}
+
+static const struct of_device_id a21_wdt_ids[] = {
+	{ .compatible = "men,a021-wdt" },
+	{ },
+};
+
+static struct platform_driver a21_wdt_driver = {
+	.probe = a21_wdt_probe,
+	.remove = a21_wdt_remove,
+	.driver = {
+		.name = "a21-watchdog",
+		.of_match_table = a21_wdt_ids,
+	},
+};
+
+module_platform_driver(a21_wdt_driver);
+
+MODULE_AUTHOR("MEN Mikro Elektronik");
+MODULE_DESCRIPTION("MEN A21 Watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:a21-watchdog");
-- 
1.7.9.5

