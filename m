Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaJVOex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:34:53 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49666 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaJVObg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:31:36 -0400
X-ASG-Debug-ID: 1413988293-0759e74a717a4ee0002-xx1T2L
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
Subject: [PATCH 05/13] power: reset: ltc2952: reduce dependency on global variables
Date: Wed, 22 Oct 2014 16:31:02 +0200
X-ASG-Orig-Subj: [PATCH 05/13] power: reset: ltc2952: reduce dependency on global variables
Message-ID: <1413988270-28092-6-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413988293
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

Documentation/CodingStyle ch.4 mentions in a side node that global
variables should only be used if you really need them. Reduce the use of
the global instance of ltc2952_poweroff so we may eventually remove it
entirely.

While at it, rename ltc2952_poweroff_data to ltc2952_poweroff, just to
save that little bit of typing.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 75 +++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 1e96b5b..9d493b5 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -63,7 +63,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/reboot.h>
 
-struct ltc2952_poweroff_data {
+struct ltc2952_poweroff {
 	struct hrtimer timer_trigger;
 	struct hrtimer timer_wde;
 
@@ -77,8 +77,14 @@ struct ltc2952_poweroff_data {
 	struct gpio_desc *gpio_kill;
 };
 
+#define to_ltc2952(p, m) container_of(p, struct ltc2952_poweroff, m)
+
+/*
+ * This global variable is only needed for pm_power_off. We should
+ * remove it entirely once we don't need the global state anymore.
+ */
+static struct ltc2952_poweroff *ltc2952_data;
 static int ltc2952_poweroff_panic;
-static struct ltc2952_poweroff_data *ltc2952_data;
 
 /**
  * ltc2952_poweroff_timer_wde - Timer callback
@@ -94,29 +100,29 @@ static enum hrtimer_restart ltc2952_poweroff_timer_wde(struct hrtimer *timer)
 	ktime_t now;
 	int state;
 	unsigned long overruns;
+	struct ltc2952_poweroff *data = to_ltc2952(timer, timer_wde);
 
 	if (ltc2952_poweroff_panic)
 		return HRTIMER_NORESTART;
 
-	state = gpiod_get_value(ltc2952_data->gpio_watchdog);
-	gpiod_set_value(ltc2952_data->gpio_watchdog, !state);
+	state = gpiod_get_value(data->gpio_watchdog);
+	gpiod_set_value(data->gpio_watchdog, !state);
 
 	now = hrtimer_cb_get_time(timer);
-	overruns = hrtimer_forward(timer, now, ltc2952_data->wde_interval);
+	overruns = hrtimer_forward(timer, now, data->wde_interval);
 
 	return HRTIMER_RESTART;
 }
 
-static enum hrtimer_restart ltc2952_poweroff_timer_trigger(
-	struct hrtimer *timer)
+static enum hrtimer_restart
+ltc2952_poweroff_timer_trigger(struct hrtimer *timer)
 {
-	int ret;
-
-	ret = hrtimer_start(&ltc2952_data->timer_wde,
-			    ltc2952_data->wde_interval, HRTIMER_MODE_REL);
+	struct ltc2952_poweroff *data = to_ltc2952(timer, timer_trigger);
+	int ret = hrtimer_start(&data->timer_wde,
+				data->wde_interval, HRTIMER_MODE_REL);
 
 	if (ret) {
-		dev_err(ltc2952_data->dev, "unable to start the timer\n");
+		dev_err(data->dev, "unable to start the timer\n");
 		/*
 		 * The device will not toggle the watchdog reset,
 		 * thus shut down is only safe if the PowerPath controller
@@ -127,7 +133,7 @@ static enum hrtimer_restart ltc2952_poweroff_timer_trigger(
 		 */
 	}
 
-	dev_info(ltc2952_data->dev, "executing shutdown\n");
+	dev_info(data->dev, "executing shutdown\n");
 
 	orderly_poweroff(true);
 
@@ -146,7 +152,7 @@ static enum hrtimer_restart ltc2952_poweroff_timer_trigger(
 static irqreturn_t ltc2952_poweroff_handler(int irq, void *dev_id)
 {
 	int ret;
-	struct ltc2952_poweroff_data *data = dev_id;
+	struct ltc2952_poweroff *data = dev_id;
 
 	if (ltc2952_poweroff_panic)
 		goto irq_ok;
@@ -187,7 +193,7 @@ static int ltc2952_poweroff_resume(struct platform_device *pdev)
 	return -ENOSYS;
 }
 
-static void ltc2952_poweroff_default(struct ltc2952_poweroff_data *data)
+static void ltc2952_poweroff_default(struct ltc2952_poweroff *data)
 {
 	data->wde_interval = ktime_set(0, 300L*1E6L);
 	data->trigger_delay = ktime_set(2, 500L*1E6L);
@@ -202,36 +208,34 @@ static void ltc2952_poweroff_default(struct ltc2952_poweroff_data *data)
 static int ltc2952_poweroff_init(struct platform_device *pdev)
 {
 	int ret, virq;
-	struct ltc2952_poweroff_data *data;
+	struct ltc2952_poweroff *data = platform_get_drvdata(pdev);
 
-	data = ltc2952_data;
-	ltc2952_poweroff_default(ltc2952_data);
+	ltc2952_poweroff_default(data);
 
-	ltc2952_data->gpio_watchdog = devm_gpiod_get(&pdev->dev, "watchdog",
-						     GPIOD_OUT_LOW);
-	if (IS_ERR(ltc2952_data->gpio_watchdog)) {
-		ret = PTR_ERR(ltc2952_data->gpio_watchdog);
+	data->gpio_watchdog = devm_gpiod_get(&pdev->dev, "watchdog",
+					     GPIOD_OUT_LOW);
+	if (IS_ERR(data->gpio_watchdog)) {
+		ret = PTR_ERR(data->gpio_watchdog);
 		dev_err(&pdev->dev, "unable to claim gpio \"watchdog\"\n");
 		return ret;
 	}
 
-	ltc2952_data->gpio_kill = devm_gpiod_get(&pdev->dev, "kill",
-						 GPIOD_OUT_LOW);
-	if (IS_ERR(ltc2952_data->gpio_kill)) {
-		ret = PTR_ERR(ltc2952_data->gpio_kill);
+	data->gpio_kill = devm_gpiod_get(&pdev->dev, "kill", GPIOD_OUT_LOW);
+	if (IS_ERR(data->gpio_kill)) {
+		ret = PTR_ERR(data->gpio_kill);
 		dev_err(&pdev->dev, "unable to claim gpio \"kill\"\n");
 		return ret;
 	}
 
-	ltc2952_data->gpio_trigger = devm_gpiod_get(&pdev->dev, "trigger",
-						    GPIOD_IN);
+	data->gpio_trigger = devm_gpiod_get(&pdev->dev, "trigger",
+					    GPIOD_IN);
 	if (IS_ERR(ltc2952_data->gpio_trigger)) {
 		ret = PTR_ERR(ltc2952_data->gpio_trigger);
 		dev_err(&pdev->dev, "unable to claim gpio \"trigger\"\n");
 		return ret;
 	}
 
-	virq = gpiod_to_irq(ltc2952_data->gpio_trigger);
+	virq = gpiod_to_irq(data->gpio_trigger);
 	if (virq < 0) {
 		dev_err(&pdev->dev, "cannot map GPIO as interrupt");
 		return ret;
@@ -241,7 +245,7 @@ static int ltc2952_poweroff_init(struct platform_device *pdev)
 			       ltc2952_poweroff_handler,
 			       (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING),
 			       "ltc2952-poweroff",
-			       ltc2952_data);
+			       data);
 
 	if (ret) {
 		dev_err(&pdev->dev, "cannot configure an interrupt handler\n");
@@ -254,23 +258,26 @@ static int ltc2952_poweroff_init(struct platform_device *pdev)
 static int ltc2952_poweroff_probe(struct platform_device *pdev)
 {
 	int ret;
+	struct ltc2952_poweroff *data;
 
 	if (pm_power_off) {
 		dev_err(&pdev->dev, "pm_power_off already registered");
 		return -EBUSY;
 	}
 
-	ltc2952_data = devm_kzalloc(&pdev->dev, sizeof(*ltc2952_data),
-				    GFP_KERNEL);
-	if (!ltc2952_data)
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
 		return -ENOMEM;
 
-	ltc2952_data->dev = &pdev->dev;
+	data->dev = &pdev->dev;
+	platform_set_drvdata(pdev, data);
 
 	ret = ltc2952_poweroff_init(pdev);
 	if (ret)
 		return ret;
 
+	/* TODO: remove ltc2952_data */
+	ltc2952_data = data;
 	pm_power_off = &ltc2952_poweroff_kill;
 
 	dev_info(&pdev->dev, "probe successful\n");
-- 
2.1.0

