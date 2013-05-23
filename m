Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab3EWMRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:17:35 -0400
Received: from mail1.ams.com ([212.166.112.31]:48049 "EHLO mail1.ams.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213Ab3EWMRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:17:33 -0400
X-IronPort-AV: E=Sophos;i="4.87,728,1363129200"; 
   d="scan'208";a="2797474"
From: Florian Lobmaier <Florian.Lobmaier@ams.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 May 2013 14:07:53 +0200
Subject: [PATCH 07/07] watchdog patch of ams AS3722 PMIC against linux_3.8.8
Thread-Topic: [PATCH 07/07] watchdog patch of ams AS3722 PMIC against
 linux_3.8.8
Thread-Index: Ac5XrY266laC/5OaSuW9FEs7R/aBhQ==
Message-ID: <EB31996D403C2C48A47628A08DCCFD290184057090@SUX2182.office.amsiag.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Lobmaier <florian.lobmaier@ams.com>

Added multi-function device driver support for ams AS3722 PMIC
Includes modules gpio, regulator, rtc, and watchdog

Signed-off-by: Florian Lobmaier <florian.lobmaier@ams.com>

---
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/watchdog/as3722_wdt.c ./drivers/watchdog/as3722_wdt.c
--- ../kernel_3.8.8/linux-kernel/drivers/watchdog/as3722_wdt.c	1970-01-01 01:00:00.000000000 +0100
+++ ./drivers/watchdog/as3722_wdt.c	2013-05-23 13:12:37.000000000 +0200
@@ -0,0 +1,161 @@
+/*
+ * as3722_wdt.c - Watchdog driver for ams AS3722 PMICs
+ *
+ * Copyright (C) 2013 ams AG
+ *
+ * Author: Florian Lobmaier <florian.lobmaier@ams.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+#include <linux/mfd/as3722-reg.h>
+#include <linux/mfd/as3722-plat.h>
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout,
+		 "Watchdog cannot be stopped once started (default="
+		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static DEFINE_MUTEX(wdt_mutex);
+
+static int as3722_wdt_set_timeout(struct watchdog_device *wdt_dev,
+				  unsigned int timeout)
+{
+	struct as3722 *as3722 = watchdog_get_drvdata(wdt_dev);
+	int ret;
+
+	if ((timeout-1 > AS3722_WATCHDOG_TIMER_MAX)
+		|| (timeout < 1))
+		return -EINVAL;
+
+	mutex_lock(&wdt_mutex);
+
+	ret = as3722_reg_write(as3722, AS3722_WATCHDOG_TIMER_REG, timeout-1);
+
+	mutex_unlock(&wdt_mutex);
+
+	wdt_dev->timeout = timeout;
+	return ret;
+}
+
+static int as3722_wdt_start(struct watchdog_device *wdt_dev)
+{
+	struct as3722 *as3722 = watchdog_get_drvdata(wdt_dev);
+	int ret;
+
+	mutex_lock(&wdt_mutex);
+
+	ret = as3722_set_bits(as3722,
+				AS3722_WATCHDOG_CONTROL_REG,
+				AS3722_WATCHDOG_ON_MASK,
+				AS3722_WATCHDOG_ON);
+
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static int as3722_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	int ret = 0;
+
+	return ret;
+}
+
+static int as3722_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct as3722 *as3722 = watchdog_get_drvdata(wdt_dev);
+	int ret;
+
+	mutex_lock(&wdt_mutex);
+
+	ret = as3722_set_bits(as3722,
+				AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG,
+				AS3722_WATCHDOG_SW_SIG_MASK,
+				AS3722_WATCHDOG_SW_SIG);
+
+	mutex_unlock(&wdt_mutex);
+
+	return ret;
+}
+
+static const struct watchdog_info as3722_wdt_info = {
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
+	.identity = "AS3722 Watchdog",
+};
+
+static const struct watchdog_ops as3722_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = as3722_wdt_start,
+	.stop = as3722_wdt_stop,
+	.ping = as3722_wdt_ping,
+	.set_timeout = as3722_wdt_set_timeout,
+};
+
+static struct watchdog_device as3722_wdt = {
+	.info = &as3722_wdt_info,
+	.ops = &as3722_wdt_ops,
+	.timeout = 15,
+	.min_timeout = 1,
+	.max_timeout = 128,
+};
+
+static int as3722_wdt_probe(struct platform_device *pdev)
+{
+	struct as3722 *as3722 = platform_get_drvdata(pdev);
+
+	if (!as3722) {
+		pr_err("No driver data supplied\n");
+		return -ENODEV;
+	}
+
+	watchdog_set_nowayout(&as3722_wdt, nowayout);
+	watchdog_set_drvdata(&as3722_wdt, as3722);
+
+	/* Default to 15s timeout */
+	as3722_wdt_set_timeout(&as3722_wdt, 15);
+
+	return watchdog_register_device(&as3722_wdt);
+}
+
+static int as3722_wdt_remove(struct platform_device *pdev)
+{
+	watchdog_unregister_device(&as3722_wdt);
+	return 0;
+}
+
+static struct platform_driver as3722_wdt_driver = {
+	.probe = as3722_wdt_probe,
+	.remove = as3722_wdt_remove,
+	.driver = {
+		.name = "as3722-wdt",
+	},
+};
+
+module_platform_driver(as3722_wdt_driver);
+
+MODULE_AUTHOR("Florian Lobmaier <florian.lobmaier@ams.com>");
+MODULE_DESCRIPTION("AS3722 Watchdog");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:as3722-wdt");
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/watchdog/Kconfig ./drivers/watchdog/Kconfig
--- ../kernel_3.8.8/linux-kernel/drivers/watchdog/Kconfig	2013-05-15 14:55:56.000000000 +0200
+++ ./drivers/watchdog/Kconfig	2013-05-23 13:12:37.000000000 +0200
@@ -64,6 +64,13 @@ config SOFT_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called softdog.
 
+config AS3722_WATCHDOG
+        tristate "AS3722 watchdog"
+        depends on MFD_AS3722
+        select WATCHDOG_CORE
+        help
+          Support for the watchdog in the AS3722 PMIC.
+
 config DA9052_WATCHDOG
         tristate "Dialog DA9052 Watchdog"
         depends on PMIC_DA9052
diff -uprN -X Documentation/dontdiff ../kernel_3.8.8/linux-kernel/drivers/watchdog/Makefile ./drivers/watchdog/Makefile
--- ../kernel_3.8.8/linux-kernel/drivers/watchdog/Makefile	2013-05-15 14:55:56.000000000 +0200
+++ ./drivers/watchdog/Makefile	2013-05-23 13:12:37.000000000 +0200
@@ -163,6 +163,7 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
 obj-$(CONFIG_XEN_WDT) += xen_wdt.o
 
 # Architecture Independent
+obj-$(CONFIG_AS3722_WATCHDOG) += as3722_wdt.o
 obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
 obj-$(CONFIG_DA9055_WATCHDOG) += da9055_wdt.o
 obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
