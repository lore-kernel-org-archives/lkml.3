Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbaESL2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:28:00 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.111]:60743 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbaESL15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:27:57 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-5.tower-193.messagelabs.com!1400498869!9506713!2
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 19 May 2014 13:27:52 +0200
Date: Mon, 19 May 2014 14:20:26 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Guenter Roeck <linux@roeck-us.net>
CC: Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <johannes.thumshirn@men.de>, <thomas.schnuerer@men.de>,
        <wernerandy@gmx.de>
Subject: Re: [PATCH 2/3] drivers/watchdog/menf21bmc_wd: introduce MEN
 14F021P00 BMC Watchdog driver
Message-ID: <20140519122025.GA398@awelinux>
References: <cover.1400258021.git.andreas.werner@men.de>
 <15d55a5ab077171a120d70ea83a05634ff06b2d0.1400258021.git.andreas.werner@men.de>
 <537786E7.3030502@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <537786E7.3030502@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aOn Sat, May 17, 2014 at 08:57:27AM -0700, Guenter Roeck wrote:
> On 05/16/2014 09:37 AM, Andreas Werner wrote:
> >Added driver to support the 14F021P00 BMC Watchdog.
> >The BMC is a Board Management Controller including watchdog functionality.
> >
> >This driver use the I2C interface to the BMC using the menf21bmc MFD Core driver.
> >
> >Signed-off-by: Andreas Werner <andreas.werner@men.de>
> >---
> >  drivers/watchdog/Kconfig        |   7 ++
> >  drivers/watchdog/Makefile       |   1 +
> >  drivers/watchdog/menf21bmc_wd.c | 263 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 271 insertions(+)
> >  create mode 100644 drivers/watchdog/menf21bmc_wd.c
> >
> >diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> >index 2b4c1fc..ede3201 100644
> >--- a/drivers/watchdog/Kconfig
> >+++ b/drivers/watchdog/Kconfig
> >@@ -95,6 +95,13 @@ config GPIO_WATCHDOG
> >  	  If you say yes here you get support for watchdog device
> >  	  controlled through GPIO-line.
> >
> >+config MENF21BMC_WATCHDOG
> >+	tristate "MEN 14F021P00 BMC Watchdog"
> >+	depends on MFD_MENF21BMC
> >+	select WATCHDOG_CORE
> >+	help
> >+	  Say Y here to include support for the MEN 14F021P00 BMC Watchdog.
> >+
> >  config WM831X_WATCHDOG
> >  	tristate "WM831x watchdog"
> >  	depends on MFD_WM831X
> >diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> >index 1b5f3d5..0a5465d 100644
> >--- a/drivers/watchdog/Makefile
> >+++ b/drivers/watchdog/Makefile
> >@@ -178,3 +178,4 @@ obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
> >  obj-$(CONFIG_WM8350_WATCHDOG) += wm8350_wdt.o
> >  obj-$(CONFIG_MAX63XX_WATCHDOG) += max63xx_wdt.o
> >  obj-$(CONFIG_SOFT_WATCHDOG) += softdog.o
> >+obj-$(CONFIG_MENF21BMC_WATCHDOG) += menf21bmc_wd.o
> >diff --git a/drivers/watchdog/menf21bmc_wd.c b/drivers/watchdog/menf21bmc_wd.c
> >new file mode 100644
> >index 0000000..31ccea8
> >--- /dev/null
> >+++ b/drivers/watchdog/menf21bmc_wd.c
> >@@ -0,0 +1,263 @@
> >+/*
> >+ *  MEN 14F021P00 Board Management Controller (BMC) Watchdog Driver.
> >+ *
> >+ *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
> >+ *  Author: Andreas Werner <andreas.werner@men.de>
> >+ *  All rights reserved.
> >+ *
> >+ *  This program is free software; you can redistribute  it and/or modify it
> >+ *  under  the terms of  the GNU General  Public License as published by the
> >+ *  Free Software Foundation;  either version 2 of the  License, or (at your
> >+ *  option) any later version.
> >+ *
> >+ */
> >+
> >+#include <linux/kernel.h>
> >+#include <linux/device.h>
> >+#include <linux/module.h>
> >+#include <linux/watchdog.h>
> >+#include <linux/platform_device.h>
> >+#include <linux/mfd/menf21bmc.h>
> >+
> >+#define DEVNAME "menf21bmc_wd"
> >+
> >+#define BMC_CMD_WD_ON		0x11
> >+#define BMC_CMD_WD_OFF		0x12
> >+#define BMC_CMD_WD_TRIG		0x13
> >+#define BMC_CMD_WD_TIME		0x14
> >+#define BMC_CMD_WD_STATE	0x17
> >+#define BMC_CMD_WD_ARM_SET	0x18
> >+#define BMC_CMD_WD_ARM_GET	0x19
> >+#define BMC_CMD_ARM_STATE	0x19
> >+#define BMC_WD_OFF_VAL		0x69
> >+#define BMC_CMD_RST_RSN		0x92
> >+
> >+#define BMC_WD_TIMEOUT_MIN	1	/*  in sec -> BMC min = 0.1 s */
> 
> I find the comment a bit confusing. The timeout is in seconds. The BMC minimum
> timeout may be 0.1s, but that is not reflected in the define. Maybe replace
> the comment with something like
> 					/* in sec (BMC min = 0.1 s) */

OK. I think I just write /* in sec */ as the comment because
it is explained in menf21bmc_wd_settimout() function.

> 
> >+#define BMC_WD_TIMEOUT_MAX	6553	/*  in sec -> BMC max = 6553,5 s */
> >+
> >+static bool nowayout = WATCHDOG_NOWAYOUT;
> >+module_param(nowayout, bool, 0);
> >+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
> >+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> >+
> >+struct menf21bmc_wd_data {
> >+	struct watchdog_device wdt;
> >+	struct menf21bmc *menf21bmc;
> >+};
> >+
> >+static int menf21bmc_wd_set_bootstatus(struct menf21bmc_wd_data *data)
> >+{
> >+	u8 rst_rsn;
> >+	int ret;
> >+	struct menf21bmc *menf21bmc = data->menf21bmc;
> >+
> >+	ret = menf21bmc->read_byte_data(menf21bmc->client,
> >+						BMC_CMD_RST_RSN, &rst_rsn);
> >+	if (ret < 0)
> >+		return -EIO;
> >+
> Please return the original error.
I agree, will be changed.
> 
> >+	if (rst_rsn == 0x02)
> >+		data->wdt.bootstatus |= WDIOF_CARDRESET;
> >+	else if (rst_rsn == 0x05)
> >+		data->wdt.bootstatus |= WDIOF_EXTERN1;
> >+	else if (rst_rsn == 0x06)
> >+		data->wdt.bootstatus |= WDIOF_EXTERN2;
> >+	else if (rst_rsn == 0x0A)
> >+		data->wdt.bootstatus |= WDIOF_POWERUNDER;
> >+
> >+	return 0;
> >+}
> >+
> >+static int menf21bmc_wd_leave_prod_mode(struct platform_device *pdev)
> >+{
> >+	int ret;
> >+	uint8_t val;
> >+	struct menf21bmc_wd_data *data = platform_get_drvdata(pdev);
> >+	struct menf21bmc *menf21bmc = data->menf21bmc;
> >+
> >+	ret = menf21bmc->read_byte_data(menf21bmc->client,
> >+						BMC_CMD_WD_ARM_GET, &val);
> >+	if (ret < 0)
> >+		return -EIO;
> >+
> Please return the original error.

I agree, will be changed.

> 
> >+	/*
> >+	 * Production mode should be not active after delivery of the Board.
> >+	 * To be sure we check it, inform the user and leave the mode
> >+	 * if active.
> >+	 */
> >+	if (val == 0x00) {
> >+		dev_info(&pdev->dev,
> >+			"BMC in production mode. Leave production mode\n");
> >+
> >+		ret = menf21bmc->write_byte(menf21bmc->client,
> >+							BMC_CMD_WD_ARM_SET);
> >+		if (ret < 0)
> >+			return -EIO;
> 
> Please return the original error.

I agree, will be changed.

> 
> >+	}
> >+
> >+	return 0;
> >+}
> >+
> >+static int menf21bmc_wd_start(struct watchdog_device *wdt)
> >+{
> >+	struct menf21bmc_wd_data *data = watchdog_get_drvdata(wdt);
> >+	struct menf21bmc *menf21bmc = data->menf21bmc;
> >+
> >+	return menf21bmc->write_byte(menf21bmc->client, BMC_CMD_WD_ON);
> >+}
> >+
> >+static int menf21bmc_wd_stop(struct watchdog_device *wdt)
> >+{
> >+	struct menf21bmc_wd_data *data = watchdog_get_drvdata(wdt);
> >+	struct menf21bmc *menf21bmc = data->menf21bmc;
> >+
> >+	return menf21bmc->write_byte_data(menf21bmc->client,
> >+					BMC_CMD_WD_OFF, BMC_WD_OFF_VAL);
> >+}
> >+
> >+static int
> >+menf21bmc_wd_settimeout(struct watchdog_device *wdt, unsigned int timeout)
> >+{
> >+	int ret;
> >+	struct menf21bmc_wd_data *data = watchdog_get_drvdata(wdt);
> >+	struct menf21bmc *menf21bmc = data->menf21bmc;
> >+
> >+	/*
> >+	 *  BMC Watchdog does have a resolution of 100ms.
> >+	 *  Watchdog API defines the timeout in seconds, so we have to
> >+	 *  multiply the value.
> >+	 */
> >+	ret = menf21bmc->write_word_data(menf21bmc->client,
> >+						BMC_CMD_WD_TIME, timeout * 10);
> >+	if (ret < 0)
> >+		return -EIO;
> >+
> Please return the original error.

I agree, will be changed.

> 
> >+	wdt->timeout = timeout;
> >+
> >+	return 0;
> >+}
> >+
> >+static int menf21bmc_wd_ping(struct watchdog_device *wdt)
> >+{
> >+	struct menf21bmc_wd_data *data = watchdog_get_drvdata(wdt);
> >+	struct menf21bmc *menf21bmc = data->menf21bmc;
> >+
> >+	return menf21bmc->write_byte(menf21bmc->client, BMC_CMD_WD_TRIG);
> >+}
> >+
> >+static const struct watchdog_info menf21bmc_wd_info = {
> >+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
> >+	.identity = DEVNAME,
> >+};
> >+
> >+static const struct watchdog_ops menf21bmc_wd_ops = {
> >+	.owner		= THIS_MODULE,
> >+	.start		= menf21bmc_wd_start,
> >+	.stop		= menf21bmc_wd_stop,
> >+	.ping		= menf21bmc_wd_ping,
> >+	.set_timeout	= menf21bmc_wd_settimeout,
> >+};
> >+
> >+static int menf21bmc_wd_probe(struct platform_device *pdev)
> >+{
> >+	int ret;
> >+	uint16_t bmc_timeout;
> >+	struct menf21bmc_wd_data *driver_data;
> >+	struct watchdog_device *menf21bmc_wd;
> >+	struct menf21bmc *menf21bmc = dev_get_drvdata(pdev->dev.parent);
> >+
> >+	driver_data = devm_kzalloc(&pdev->dev,
> >+				sizeof(struct menf21bmc_wd_data), GFP_KERNEL);
> >+	if (!driver_data)
> >+		return -ENOMEM;
> >+
> >+	driver_data->menf21bmc = menf21bmc;
> >+
> >+	menf21bmc_wd = &driver_data->wdt;
> >+	menf21bmc_wd->ops = &menf21bmc_wd_ops;
> >+	menf21bmc_wd->info = &menf21bmc_wd_info;
> >+	menf21bmc_wd->min_timeout = BMC_WD_TIMEOUT_MIN;
> >+	menf21bmc_wd->max_timeout = BMC_WD_TIMEOUT_MAX;
> >+
> >+
> Please no more than one empty line.

arg, i thought I've catched them all but missed one.

> 
> >+	/*
> >+	 * Get the current wdt timeout value from the BMC because
> >+	 * the BMC will save the value set before if the system restarts.
> >+	 */
> >+	ret = menf21bmc->read_word_data(menf21bmc->client,
> >+					 BMC_CMD_WD_TIME, &bmc_timeout);
> >+	if (ret < 0) {
> >+		dev_err(&pdev->dev, "failed to get current WDT timeout\n");
> >+		return ret;
> >+	}
> >+
> >+	watchdog_init_timeout(menf21bmc_wd, bmc_timeout / 10, &pdev->dev);
> >+
> >+	watchdog_set_nowayout(menf21bmc_wd, nowayout);
> >+	watchdog_set_drvdata(menf21bmc_wd, driver_data);
> >+	platform_set_drvdata(pdev, driver_data);
> >+
> >+	/*
> >+	 * We have to leave the Production Mode of the BMC to activate the
> >+	 * Watchdog functionality.
> >+	 */
> >+	ret = menf21bmc_wd_leave_prod_mode(pdev);
> >+	if (ret < 0) {
> >+		dev_err(&pdev->dev, "failed to leave production mode\n");
> >+		return ret;
> >+	}
> >+
> Shouldn't this be in the mfd code ?

Yes and no :-)
The Production mode needs to be left just to activate the watchdog. That is the
reason why I've put these code inside of the watchdog driver.

The other thing is, that we leave the prodcution which is related to the whole BMC,
so may be it is really better to put this in the mfd core.

I think I will put it in the mfd core.

> 
> 
> >+	ret = menf21bmc_wd_set_bootstatus(driver_data);
> >+	if (ret < 0) {
> >+		dev_err(&pdev->dev, "failed to set Watchdog bootstatus\n");
> >+		return ret;
> >+	}
> >+
> >+	ret = watchdog_register_device(&driver_data->wdt);
> >+	if (ret) {
> >+		dev_err(&pdev->dev, "failed to register Watchdog device\n");
> >+		return ret;
> >+	}
> >+
> >+	dev_info(&pdev->dev, "MEN 14F021P00 BMC Watchdog device enabled\n");
> >+
> >+	return 0;
> >+}
> >+
> >+static int menf21bmc_wd_remove(struct platform_device *pdev)
> >+{
> >+	struct menf21bmc_wd_data *data = platform_get_drvdata(pdev);
> >+
> >+	dev_warn(&pdev->dev,
> >+		"Untregister MEN 14F021P00 BMC Watchdog device, board may reset\n");
> >+
> >+	watchdog_unregister_device(&data->wdt);
> >+
> >+	return 0;
> >+}
> >+
> >+static void menf21bmc_wd_shutdown(struct platform_device *pdev)
> >+{
> >+	struct menf21bmc_wd_data *data = platform_get_drvdata(pdev);
> >+	struct menf21bmc *menf21bmc = data->menf21bmc;
> >+
> >+	menf21bmc->write_word_data(menf21bmc->client,
> >+					BMC_CMD_WD_OFF, BMC_WD_OFF_VAL);
> >+}
> >+
> >+static struct  platform_driver menf21bmc_wd = {
> >+	.driver		= {
> >+		.owner = THIS_MODULE,
> >+		.name	= DEVNAME,
> >+	},
> >+	.probe		= menf21bmc_wd_probe,
> >+	.remove		= menf21bmc_wd_remove,
> >+	.shutdown	= menf21bmc_wd_shutdown,
> >+};
> >+
> >+module_platform_driver(menf21bmc_wd);
> >+
> >+MODULE_DESCRIPTION("MEN 14F021P00 BMC Watchdog driver");
> >+MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
> >+MODULE_LICENSE("GPL");
> >+MODULE_ALIAS("platform:menf21bmc_wd");
> >
> 
