Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab3E0SMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 14:12:03 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:56885 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3E0SMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 14:12:00 -0400
From: johannes.thumshirn@men.de
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH v4 2/2] watchdog: Add sysfs interface for MEN A21 watchdog
Date: Mon, 27 May 2013 20:13:54 +0200
Message-Id: <1369678434-13515-2-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de>
References: <20130527090756.GA14258@spo001.leaseweb.com>
 <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@men.de>

This patch adds a sysfs interface for the watchdog device found on MEN A21
Boards.

The newly generated files are:
* rebootcause:
Can be one of:
Power on Reset,
CPU Reset Request,
Push Button,
FPGA Reset Request,
Watchdog,
Local Power Bad,
Invalid or
BDI
and shows the reason of the boards last reboot.

* active:
Shows if the watchdog CPLD is actually running

* allow_disable:
Shows if the watchdog is allowed to be disabled (NOWAYOUT disabled)

* fastmode:
Shows if the CPLD is running in fast mode (1s timeout), once it is in
fastmode it can't be switched back to slow mode (30s timeout) until the
next reboot.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/watchdog/mena21_wdt.c |   88 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/watchdog/mena21_wdt.c b/drivers/watchdog/mena21_wdt.c
index 4fe65ec..c97c5f4 100644
--- a/drivers/watchdog/mena21_wdt.c
+++ b/drivers/watchdog/mena21_wdt.c
@@ -19,6 +19,17 @@
 #include <linux/delay.h>
 #include <linux/bitops.h>
 
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
 #define GPIO_WD_ENAB	169
 #define GPIO_WD_FAST	170
 #define GPIO_WD_TRIG	171
@@ -35,6 +46,74 @@ module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 			    __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
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
 static int a21_wdt_start(struct watchdog_device *wdt)
 {
 	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
@@ -151,10 +230,18 @@ static int a21_wdt_probe(struct platform_device *pdev)
 		goto err_register_wd;
 	}
 
+	ret = a21_wdt_create_files(&a21_wdt);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot create sysfs entries\n");
+		goto err_create_sysfs;
+	}
+
 	dev_set_drvdata(&pdev->dev, drv);
 
 	return 0;
 
+err_create_sysfs:
+	watchdog_unregister_device(&drv->wdt);
 err_register_wd:
 	mutex_destroy(&drv->lock);
 
@@ -168,6 +255,7 @@ static int a21_wdt_remove(struct platform_device *pdev)
 	dev_warn(&pdev->dev,
 		"Unregistering A21 watchdog driver, board may reboot\n");
 
+	a21_wdt_remove_files(&drv->wdt);
 
 	watchdog_unregister_device(&drv->wdt);
 
-- 
1.7.9.5

