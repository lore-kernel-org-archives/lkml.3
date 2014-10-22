Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaJVObg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:31:36 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49604 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaJVObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:31:31 -0400
X-ASG-Debug-ID: 1413988289-0759e74a717a4e90002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?q?Ren=C3=A9=20Moll?= <linux@r-moll.nl>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 03/13] power: reset: ltc2952: unroll gpio_desc array
Date: Wed, 22 Oct 2014 16:31:00 +0200
X-ASG-Orig-Subj: [PATCH 03/13] power: reset: ltc2952: unroll gpio_desc array
Message-ID: <1413988270-28092-4-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413988289
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10827
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three gpio's used by this driver are stored in an array of pointers.
This doesn't add much besides cleanups in a loop. In fact, it makes most
of the usage sites harder to read. Unroll the loop, and live with the
fact that cleanups become slightly larger.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 86 +++++++++++++++-------------------
 1 file changed, 38 insertions(+), 48 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 2c11316..fc583e0 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -72,21 +72,14 @@ struct ltc2952_poweroff_data {
 
 	struct device *dev;
 
-	/**
-	 * 0: trigger
-	 * 1: watchdog
-	 * 2: kill
-	 */
-	struct gpio_desc *gpio[3];
+	struct gpio_desc *gpio_trigger;
+	struct gpio_desc *gpio_watchdog;
+	struct gpio_desc *gpio_kill;
 };
 
 static int ltc2952_poweroff_panic;
 static struct ltc2952_poweroff_data *ltc2952_data;
 
-#define POWERPATH_IO_TRIGGER	0
-#define POWERPATH_IO_WATCHDOG	1
-#define POWERPATH_IO_KILL	2
-
 /**
  * ltc2952_poweroff_timer_wde - Timer callback
  * Toggles the watchdog reset signal each wde_interval
@@ -105,8 +98,8 @@ static enum hrtimer_restart ltc2952_poweroff_timer_wde(struct hrtimer *timer)
 	if (ltc2952_poweroff_panic)
 		return HRTIMER_NORESTART;
 
-	state = gpiod_get_value(ltc2952_data->gpio[POWERPATH_IO_WATCHDOG]);
-	gpiod_set_value(ltc2952_data->gpio[POWERPATH_IO_WATCHDOG], !state);
+	state = gpiod_get_value(ltc2952_data->gpio_watchdog);
+	gpiod_set_value(ltc2952_data->gpio_watchdog, !state);
 
 	now = hrtimer_cb_get_time(timer);
 	overruns = hrtimer_forward(timer, now, ltc2952_data->wde_interval);
@@ -120,7 +113,7 @@ static enum hrtimer_restart ltc2952_poweroff_timer_trigger(
 	int ret;
 
 	ret = hrtimer_start(&ltc2952_data->timer_wde,
-		ltc2952_data->wde_interval, HRTIMER_MODE_REL);
+			    ltc2952_data->wde_interval, HRTIMER_MODE_REL);
 
 	if (ret) {
 		dev_err(ltc2952_data->dev, "unable to start the timer\n");
@@ -180,7 +173,7 @@ irq_ok:
 
 static void ltc2952_poweroff_kill(void)
 {
-	gpiod_set_value(ltc2952_data->gpio[POWERPATH_IO_KILL], 1);
+	gpiod_set_value(ltc2952_data->gpio_kill, 1);
 }
 
 static int ltc2952_poweroff_suspend(struct platform_device *pdev,
@@ -196,11 +189,6 @@ static int ltc2952_poweroff_resume(struct platform_device *pdev)
 
 static void ltc2952_poweroff_default(struct ltc2952_poweroff_data *data)
 {
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(data->gpio); i++)
-		data->gpio[i] = NULL;
-
 	data->wde_interval = ktime_set(0, 300L*1E6L);
 	data->trigger_delay = ktime_set(2, 500L*1E6L);
 
@@ -214,45 +202,46 @@ static void ltc2952_poweroff_default(struct ltc2952_poweroff_data *data)
 static int ltc2952_poweroff_init(struct platform_device *pdev)
 {
 	int ret, virq;
-	unsigned int i;
 	struct ltc2952_poweroff_data *data;
 
-	static char *name[] = {
-		"trigger",
-		"watchdog",
-		"kill",
-		NULL
-	};
-
 	data = ltc2952_data;
 	ltc2952_poweroff_default(ltc2952_data);
 
-	for (i = 0; i < ARRAY_SIZE(ltc2952_data->gpio); i++) {
-		ltc2952_data->gpio[i] = gpiod_get(&pdev->dev, name[i]);
+	ltc2952_data->gpio_watchdog = gpiod_get(&pdev->dev, "watchdog");
+	if (IS_ERR(ltc2952_data->gpio_watchdog)) {
+		ret = PTR_ERR(ltc2952_data->gpio_watchdog);
+		dev_err(&pdev->dev, "unable to claim gpio \"watchdog\"\n");
+		return ret;
+	}
 
-		if (IS_ERR(ltc2952_data->gpio[i])) {
-			ret = PTR_ERR(ltc2952_data->gpio[i]);
-			dev_err(&pdev->dev,
-				"unable to claim the following gpio: %s\n",
-				name[i]);
-			goto err_io;
-		}
+	ltc2952_data->gpio_kill = gpiod_get(&pdev->dev, "kill");
+	if (IS_ERR(ltc2952_data->gpio_kill)) {
+		ret = PTR_ERR(ltc2952_data->gpio_kill);
+		dev_err(&pdev->dev, "unable to claim gpio \"kill\"\n");
+		goto err_kill;
+	}
+
+	ltc2952_data->gpio_trigger = gpiod_get(&pdev->dev, "trigger");
+	if (IS_ERR(ltc2952_data->gpio_trigger)) {
+		ret = PTR_ERR(ltc2952_data->gpio_trigger);
+		dev_err(&pdev->dev, "unable to claim gpio \"trigger\"\n");
+		goto err_trigger;
 	}
 
 	ret = gpiod_direction_output(
-		ltc2952_data->gpio[POWERPATH_IO_WATCHDOG], 0);
+		ltc2952_data->gpio_watchdog, 0);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to use watchdog-gpio as output\n");
 		goto err_io;
 	}
 
-	ret = gpiod_direction_output(ltc2952_data->gpio[POWERPATH_IO_KILL], 0);
+	ret = gpiod_direction_output(ltc2952_data->gpio_kill, 0);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to use kill-gpio as output\n");
 		goto err_io;
 	}
 
-	virq = gpiod_to_irq(ltc2952_data->gpio[POWERPATH_IO_TRIGGER]);
+	virq = gpiod_to_irq(ltc2952_data->gpio_trigger);
 	if (virq < 0) {
 		dev_err(&pdev->dev, "cannot map GPIO as interrupt");
 		goto err_io;
@@ -272,9 +261,11 @@ static int ltc2952_poweroff_init(struct platform_device *pdev)
 	return 0;
 
 err_io:
-	for (i = 0; i < ARRAY_SIZE(ltc2952_data->gpio); i++)
-		if (ltc2952_data->gpio[i])
-			gpiod_put(ltc2952_data->gpio[i]);
+	gpiod_put(ltc2952_data->gpio_trigger);
+err_trigger:
+	gpiod_put(ltc2952_data->gpio_kill);
+err_kill:
+	gpiod_put(ltc2952_data->gpio_watchdog);
 
 	return ret;
 }
@@ -308,14 +299,13 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
 
 static int ltc2952_poweroff_remove(struct platform_device *pdev)
 {
-	unsigned int i;
-
 	pm_power_off = NULL;
 
-	if (ltc2952_data)
-		for (i = 0; i < ARRAY_SIZE(ltc2952_data->gpio); i++)
-			gpiod_put(ltc2952_data->gpio[i]);
-
+	if (ltc2952_data) {
+		gpiod_put(ltc2952_data->gpio_trigger);
+		gpiod_put(ltc2952_data->gpio_watchdog);
+		gpiod_put(ltc2952_data->gpio_kill);
+	}
 	return 0;
 }
 
-- 
2.1.0

