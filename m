Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbbANG2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 01:28:39 -0500
Received: from atl4mhob18.myregisteredsite.com ([209.17.115.111]:55802 "EHLO
	atl4mhob18.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbbANG2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 01:28:38 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: linux@roeck-us.net
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH v4] gpio_wdt: Add "always_running" feature to GPIO watchdog
Date: Wed, 14 Jan 2015 07:28:29 +0100
Message-Id: <1421216909-3109-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20150113215212.GA12804@roeck-us.net>
References: <20150113215212.GA12804@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some chips, like the TPS386000, the trigger cannot be disabled
and the CPU must keep toggling the line at all times. Add a switch
"always_running" to keep toggling the GPIO line regardless of the
state of the soft part of the watchdog. The "armed" member keeps
track of whether a timeout must also cause a reset.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
v4: Fix 'return' with a value, in function returning void

 .../devicetree/bindings/watchdog/gpio-wdt.txt      |    5 +++
 drivers/watchdog/gpio_wdt.c                        |   37 +++++++++++++++-----
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
index 37afec1..1987949 100644
--- a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
@@ -13,6 +13,11 @@ Required Properties:
     by the GPIO flags.
 - hw_margin_ms: Maximum time to reset watchdog circuit (milliseconds).
 
+Optional Properties:
+- always-running: If the watchdog timer cannot be disabled, add this flag to
+  have the driver keep toggling the signal without a client. It will only cease
+  to toggle the signal when the device is open and the timeout elapsed.
+
 Example:
 	watchdog: watchdog {
 		/* ADM706 */
diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
index 220a9e0..51acda6 100644
--- a/drivers/watchdog/gpio_wdt.c
+++ b/drivers/watchdog/gpio_wdt.c
@@ -31,6 +31,8 @@ struct gpio_wdt_priv {
 	int			gpio;
 	bool			active_low;
 	bool			state;
+	bool			always_running;
+	bool			armed;
 	unsigned int		hw_algo;
 	unsigned int		hw_margin;
 	unsigned long		last_jiffies;
@@ -48,14 +50,20 @@ static void gpio_wdt_disable(struct gpio_wdt_priv *priv)
 		gpio_direction_input(priv->gpio);
 }
 
-static int gpio_wdt_start(struct watchdog_device *wdd)
+static void gpio_wdt_start_impl(struct gpio_wdt_priv *priv)
 {
-	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
-
 	priv->state = priv->active_low;
 	gpio_direction_output(priv->gpio, priv->state);
 	priv->last_jiffies = jiffies;
 	mod_timer(&priv->timer, priv->last_jiffies + priv->hw_margin);
+}
+
+static int gpio_wdt_start(struct watchdog_device *wdd)
+{
+	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
+
+	gpio_wdt_start_impl(priv);
+	priv->armed = true;
 
 	return 0;
 }
@@ -64,8 +72,11 @@ static int gpio_wdt_stop(struct watchdog_device *wdd)
 {
 	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
 
-	mod_timer(&priv->timer, 0);
-	gpio_wdt_disable(priv);
+	priv->armed = false;
+	if (!priv->always_running) {
+		mod_timer(&priv->timer, 0);
+		gpio_wdt_disable(priv);
+	}
 
 	return 0;
 }
@@ -91,8 +102,8 @@ static void gpio_wdt_hwping(unsigned long data)
 	struct watchdog_device *wdd = (struct watchdog_device *)data;
 	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
 
-	if (time_after(jiffies, priv->last_jiffies +
-		       msecs_to_jiffies(wdd->timeout * 1000))) {
+	if (priv->armed && time_after(jiffies, priv->last_jiffies +
+				      msecs_to_jiffies(wdd->timeout * 1000))) {
 		dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
 		return;
 	}
@@ -197,6 +208,9 @@ static int gpio_wdt_probe(struct platform_device *pdev)
 	/* Use safe value (1/2 of real timeout) */
 	priv->hw_margin = msecs_to_jiffies(hw_margin / 2);
 
+	priv->always_running = of_property_read_bool(pdev->dev.of_node,
+						     "always-running");
+
 	watchdog_set_drvdata(&priv->wdd, priv);
 
 	priv->wdd.info		= &gpio_wdt_ident;
@@ -216,8 +230,15 @@ static int gpio_wdt_probe(struct platform_device *pdev)
 	priv->notifier.notifier_call = gpio_wdt_notify_sys;
 	ret = register_reboot_notifier(&priv->notifier);
 	if (ret)
-		watchdog_unregister_device(&priv->wdd);
+		goto error_unregister;
 
+	if (priv->always_running)
+		gpio_wdt_start_impl(priv);
+
+	return 0;
+
+error_unregister:
+	watchdog_unregister_device(&priv->wdd);
 	return ret;
 }
 
-- 
1.7.9.5

