Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaHQAps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 20:45:48 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:35112 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaHQApq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 20:45:46 -0400
From: Evgeny Boger <boger@contactless.ru>
X-Google-Original-From: Evgeny Boger <boger@contactless.ru
To: linux-watchdog@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>,
        linux-kernel@vger.kernel.org
Cc: Evgeny Boger <boger@contactless.ru>
Subject: [PATCH] Add support for always enabled watchdog timers
Date: Sun, 17 Aug 2014 04:45:38 +0400
Message-Id: <1408236338-12555-1-git-send-email-boger@contactless.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Boger <boger@contactless.ru>

Add option to use with watchdog timers which are always enabled 
in hardware, i.e. there is no way to enable/disable it via GPIO pin.
The driver will start pinging WDT immediately upon loading
and will continue to do so even after stopping the watchdog.

Signed-off-by: Evgeny Boger <boger@contactless.ru>
---
 .../devicetree/bindings/watchdog/gpio-wdt.txt      | 14 ++++++-
 drivers/watchdog/gpio_wdt.c                        | 45 +++++++++++++++++-----
 2 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
index 37afec1..1f8ca46 100644
--- a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
@@ -12,8 +12,11 @@ Required Properties:
     the opposite level disables the WDT. Active level is determined
     by the GPIO flags.
 - hw_margin_ms: Maximum time to reset watchdog circuit (milliseconds).
+- always-enabled: Use with wathdog timer which is always enabled
+  in hardware, i.e. there is no way to enable/disable it via GPIO pin.
+  Driver will start pinging WDT immediately upon loading.
 
-Example:
+Examples:
 	watchdog: watchdog {
 		/* ADM706 */
 		compatible = "linux,wdt-gpio";
@@ -21,3 +24,12 @@ Example:
 		hw_algo = "toggle";
 		hw_margin_ms = <1600>;
 	};
+
+	watchdog: watchdog {
+		/* TPS3813 */
+		compatible = "linux,wdt-gpio";
+		gpios = <&gpio3 9 GPIO_ACTIVE_LOW>;
+		hw_algo = "toggle";
+		hw_margin_ms = <10000>;
+		always-enabled;
+	};
diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
index 220a9e0..29f9bff 100644
--- a/drivers/watchdog/gpio_wdt.c
+++ b/drivers/watchdog/gpio_wdt.c
@@ -37,6 +37,8 @@ struct gpio_wdt_priv {
 	struct notifier_block	notifier;
 	struct timer_list	timer;
 	struct watchdog_device	wdd;
+	bool		always_enabled;
+	bool		started;
 };
 
 static void gpio_wdt_disable(struct gpio_wdt_priv *priv)
@@ -48,10 +50,8 @@ static void gpio_wdt_disable(struct gpio_wdt_priv *priv)
 		gpio_direction_input(priv->gpio);
 }
 
-static int gpio_wdt_start(struct watchdog_device *wdd)
+static int gpio_wdt_start_timer(struct gpio_wdt_priv *priv)
 {
-	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
-
 	priv->state = priv->active_low;
 	gpio_direction_output(priv->gpio, priv->state);
 	priv->last_jiffies = jiffies;
@@ -60,12 +60,28 @@ static int gpio_wdt_start(struct watchdog_device *wdd)
 	return 0;
 }
 
-static int gpio_wdt_stop(struct watchdog_device *wdd)
+static int gpio_wdt_start(struct watchdog_device *wdd)
 {
 	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
+	priv->started = true;
+	if (priv->always_enabled) {
+		/* harware ping timer is already enabled */
+		priv->last_jiffies = jiffies;
+	} else {
+		gpio_wdt_start_timer(priv);
+	}
 
-	mod_timer(&priv->timer, 0);
-	gpio_wdt_disable(priv);
+	return 0;
+}
+
+static int gpio_wdt_stop(struct watchdog_device *wdd)
+{
+	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
+	priv->started = false;
+	if (!priv->always_enabled) {
+		mod_timer(&priv->timer, 0);
+		gpio_wdt_disable(priv);
+	}
 
 	return 0;
 }
@@ -91,10 +107,12 @@ static void gpio_wdt_hwping(unsigned long data)
 	struct watchdog_device *wdd = (struct watchdog_device *)data;
 	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
 
-	if (time_after(jiffies, priv->last_jiffies +
-		       msecs_to_jiffies(wdd->timeout * 1000))) {
-		dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
-		return;
+	if (priv->started) {
+		if (time_after(jiffies, priv->last_jiffies +
+			       msecs_to_jiffies(wdd->timeout * 1000))) {
+			dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
+			return;
+		}
 	}
 
 	/* Restart timer */
@@ -197,6 +215,9 @@ static int gpio_wdt_probe(struct platform_device *pdev)
 	/* Use safe value (1/2 of real timeout) */
 	priv->hw_margin = msecs_to_jiffies(hw_margin / 2);
 
+	priv->always_enabled = of_property_read_bool(pdev->dev.of_node,
+						"always-enabled");
+
 	watchdog_set_drvdata(&priv->wdd, priv);
 
 	priv->wdd.info		= &gpio_wdt_ident;
@@ -207,6 +228,7 @@ static int gpio_wdt_probe(struct platform_device *pdev)
 	if (watchdog_init_timeout(&priv->wdd, 0, &pdev->dev) < 0)
 		priv->wdd.timeout = SOFT_TIMEOUT_DEF;
 
+	priv->started = false;
 	setup_timer(&priv->timer, gpio_wdt_hwping, (unsigned long)&priv->wdd);
 
 	ret = watchdog_register_device(&priv->wdd);
@@ -218,6 +240,9 @@ static int gpio_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		watchdog_unregister_device(&priv->wdd);
 
+	if (priv->always_enabled)
+		gpio_wdt_start_timer(priv);
+
 	return ret;
 }
 
-- 
1.9.1

