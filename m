Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3EaI7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:59:12 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.168]:31652 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331Ab3EaI7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:59:05 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-6.tower-38.messagelabs.com!1369990742!12197709!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 31 May 2013 10:59:02 +0200
Date: Fri, 31 May 2013 11:01:05 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <wim@iguana.be>
CC: <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <johannes.thumshirn@men.de>
Subject: [PATCH v2 2/2] This patch adds a sysfs interface for the watchdog
 device found on MEN A21 Boards.
Message-ID: <20130531090100.GA8676@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130531085842.GA8572@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 31 May 2013 08:59:01.0908 (UTC) FILETIME=[186A0540:01CE5DDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Revision 2:
* Re-worked sysfs patch to apply on re-worked base

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/watchdog/mena21_wdt.c |   88 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/watchdog/mena21_wdt.c b/drivers/watchdog/mena21_wdt.c
index e586c2e..e11d869 100644
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
@@ -49,6 +60,74 @@ static int a21_wdt_get_bootstatus(unsigned int *reset)
 	return 0;
 }

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
@@ -181,10 +260,18 @@ static int a21_wdt_probe(struct platform_device *pdev)
 			a21_wdt.bootstatus |= WDIOF_EXTERN2;
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

@@ -198,6 +285,7 @@ static int a21_wdt_remove(struct platform_device *pdev)
 	dev_warn(&pdev->dev,
 		"Unregistering A21 watchdog driver, board may reboot\n");

+	a21_wdt_remove_files(&drv->wdt);

 	watchdog_unregister_device(&drv->wdt);

--
1.7.9.5

