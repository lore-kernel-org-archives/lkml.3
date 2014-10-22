Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaJVObm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:31:42 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49689 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaJVObh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:31:37 -0400
X-ASG-Debug-ID: 1413988294-0759e74a717a4f00002-xx1T2L
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
Subject: [PATCH 06/13] power: reset: ltc2952: remove global variable poweroff_panic
Date: Wed, 22 Oct 2014 16:31:03 +0200
X-ASG-Orig-Subj: [PATCH 06/13] power: reset: ltc2952: remove global variable poweroff_panic
Message-ID: <1413988270-28092-7-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413988295
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 2.90
X-Barracuda-Spam-Status: No, SCORE=2.90 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=TVD_SUBJ_WIPE_DEBT
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10827
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	2.90 TVD_SUBJ_WIPE_DEBT     TVD_SUBJ_WIPE_DEBT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Documentation/CodingStyle ch.4, we should keep global variables
to a mininum. Move the panic state into the driver data, regardless of
whether panic is a system state or not.

This removes the need for the custom _init and _exit functions, so
replace them with a call to the module_platform_driver() macro.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 57 +++++++++++++---------------------
 1 file changed, 22 insertions(+), 35 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 9d493b5..bc8d228 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -75,6 +75,9 @@ struct ltc2952_poweroff {
 	struct gpio_desc *gpio_trigger;
 	struct gpio_desc *gpio_watchdog;
 	struct gpio_desc *gpio_kill;
+
+	bool kernel_panic;
+	struct notifier_block panic_notifier;
 };
 
 #define to_ltc2952(p, m) container_of(p, struct ltc2952_poweroff, m)
@@ -84,7 +87,6 @@ struct ltc2952_poweroff {
  * remove it entirely once we don't need the global state anymore.
  */
 static struct ltc2952_poweroff *ltc2952_data;
-static int ltc2952_poweroff_panic;
 
 /**
  * ltc2952_poweroff_timer_wde - Timer callback
@@ -102,7 +104,7 @@ static enum hrtimer_restart ltc2952_poweroff_timer_wde(struct hrtimer *timer)
 	unsigned long overruns;
 	struct ltc2952_poweroff *data = to_ltc2952(timer, timer_wde);
 
-	if (ltc2952_poweroff_panic)
+	if (data->kernel_panic)
 		return HRTIMER_NORESTART;
 
 	state = gpiod_get_value(data->gpio_watchdog);
@@ -154,7 +156,7 @@ static irqreturn_t ltc2952_poweroff_handler(int irq, void *dev_id)
 	int ret;
 	struct ltc2952_poweroff *data = dev_id;
 
-	if (ltc2952_poweroff_panic)
+	if (data->kernel_panic)
 		goto irq_ok;
 
 	if (hrtimer_active(&data->timer_wde)) {
@@ -255,6 +257,15 @@ static int ltc2952_poweroff_init(struct platform_device *pdev)
 	return 0;
 }
 
+static int ltc2952_poweroff_notify_panic(struct notifier_block *nb,
+					 unsigned long code, void *unused)
+{
+	struct ltc2952_poweroff *data = to_ltc2952(nb, panic_notifier);
+
+	data->kernel_panic = true;
+	return NOTIFY_DONE;
+}
+
 static int ltc2952_poweroff_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -280,6 +291,9 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
 	ltc2952_data = data;
 	pm_power_off = &ltc2952_poweroff_kill;
 
+	data->panic_notifier.notifier_call = ltc2952_poweroff_notify_panic;
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &data->panic_notifier);
 	dev_info(&pdev->dev, "probe successful\n");
 
 	return 0;
@@ -287,8 +301,11 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
 
 static int ltc2952_poweroff_remove(struct platform_device *pdev)
 {
-	pm_power_off = NULL;
+	struct ltc2952_poweroff *data = platform_get_drvdata(pdev);
 
+	pm_power_off = NULL;
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &data->panic_notifier);
 	return 0;
 }
 
@@ -310,37 +327,7 @@ static struct platform_driver ltc2952_poweroff_driver = {
 	.resume = ltc2952_poweroff_resume,
 };
 
-static int ltc2952_poweroff_notify_panic(struct notifier_block *nb,
-	unsigned long code, void *unused)
-{
-	ltc2952_poweroff_panic = 1;
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block ltc2952_poweroff_panic_nb = {
-	.notifier_call = ltc2952_poweroff_notify_panic,
-};
-
-static int __init ltc2952_poweroff_platform_init(void)
-{
-	ltc2952_poweroff_panic = 0;
-
-	atomic_notifier_chain_register(&panic_notifier_list,
-		&ltc2952_poweroff_panic_nb);
-
-	return platform_driver_register(&ltc2952_poweroff_driver);
-}
-
-static void __exit ltc2952_poweroff_platform_exit(void)
-{
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-		&ltc2952_poweroff_panic_nb);
-
-	platform_driver_unregister(&ltc2952_poweroff_driver);
-}
-
-module_init(ltc2952_poweroff_platform_init);
-module_exit(ltc2952_poweroff_platform_exit);
+module_platform_driver(ltc2952_poweroff_driver);
 
 MODULE_AUTHOR("René Moll <rene.moll@xsens.com>");
 MODULE_DESCRIPTION("LTC PowerPath power-off driver");
-- 
2.1.0

