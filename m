Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab3FRPSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:18:12 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.149]:28992 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932076Ab3FRPSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:18:08 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-11.tower-180.messagelabs.com!1371568686!21938096!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 18 Jun 2013 17:18:06 +0200
Date: Tue, 18 Jun 2013 17:21:29 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <wim@iguana.be>
CC: <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <guenter@roeck-us.net>, <johannes.thumshirn@men.de>
Subject: [PATCH RESEND v10 2/2] watchdog: Sysfs interface for MEN A21 watchdog
Message-ID: <20130618152119.GA23399@jtlinux>
References: <20130618151939.GA23296@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130618151939.GA23296@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 18 Jun 2013 15:18:05.0849 (UTC) FILETIME=[084B8090:01CE6C37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a sysfs interface for the watchdog
device found on MEN A21 Boards.

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

 Revision 2:
 * Re-worked sysfs patch to apply on re-worked base

 Revision 3:
 * Re-worked sysfs patch to apply on re-worked base

 drivers/watchdog/mena21_wdt.c |   89 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/drivers/watchdog/mena21_wdt.c b/drivers/watchdog/mena21_wdt.c
index 96dbba9..91cc90b 100644
--- a/drivers/watchdog/mena21_wdt.c
+++ b/drivers/watchdog/mena21_wdt.c
@@ -22,6 +22,17 @@

 #define NUM_GPIOS 6

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
 enum a21_wdt_gpios {
 	GPIO_WD_ENAB,
 	GPIO_WD_FAST,
@@ -53,6 +64,73 @@ static unsigned int a21_wdt_get_bootstatus(struct a21_wdt_drv *drv)
 	return reset;
 }

+static ssize_t rebootcause_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct a21_wdt_drv *drv = dev_get_drvdata(dev);
+	unsigned int reset = 0;
+
+	reset = a21_wdt_get_bootstatus(drv);
+
+	return sprintf(buf, "%s\n", reset_causes[reset]);
+}
+static DEVICE_ATTR(rebootcause, S_IRUGO, rebootcause_show, NULL);
+
+static ssize_t active_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct a21_wdt_drv *drv = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", !!gpio_get_value(drv->gpios[GPIO_WD_ENAB]));
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
+	struct a21_wdt_drv *drv = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", !!gpio_get_value(drv->gpios[GPIO_WD_FAST]));
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
@@ -215,11 +293,20 @@ static int a21_wdt_probe(struct platform_device *pdev)
 	}

 	dev_set_drvdata(&pdev->dev, drv);
+	dev_set_drvdata(a21_wdt.dev, drv);
+
+	ret = a21_wdt_create_files(&a21_wdt);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot create sysfs entries\n");
+		goto err_create_sysfs;
+	}

 	dev_info(&pdev->dev, "MEN A21 watchdog timer driver enabled\n");

 	return 0;

+err_create_sysfs:
+	watchdog_unregister_device(&drv->wdt);
 err_register_wd:
 	mutex_destroy(&drv->lock);

@@ -233,6 +320,8 @@ static int a21_wdt_remove(struct platform_device *pdev)
 	dev_warn(&pdev->dev,
 		"Unregistering A21 watchdog driver, board may reboot\n");

+	a21_wdt_remove_files(&drv->wdt);
+
 	watchdog_unregister_device(&drv->wdt);

 	mutex_destroy(&drv->lock);
--
1.7.9.5

