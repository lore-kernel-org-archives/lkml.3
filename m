Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaKUGx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:53:57 -0500
Received: from atl4mhob17.myregisteredsite.com ([209.17.115.110]:43896 "EHLO
	atl4mhob17.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbaKUGx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:53:56 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH v2] gpio_wdt: Add "always_running" feature to GPIO watchdog
Date: Fri, 21 Nov 2014 07:53:48 +0100
Message-Id: <1416552828-3589-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20141120172329.GA10673@roeck-us.net>
References: <20141120172329.GA10673@roeck-us.net>
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

v2: Rename property "always_running" to "always-running" and add devicetree
documentation

 .../devicetree/bindings/watchdog/gpio-wdt.txt      |    5 +++++
 drivers/watchdog/gpio_wdt.c                        |   20 +++++++++++++++++---
 2 files changed, 22 insertions(+), 3 deletions(-)

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
index 220a9e0..3266215 100644
--- a/drivers/watchdog/gpio_wdt.c
+++ b/drivers/watchdog/gpio_wdt.c
@@ -31,6 +31,8 @@ struct gpio_wdt_priv {
 	int			gpio;
 	bool			active_low;
 	bool			state;
+	bool		always_running;
+	bool		armed;
 	unsigned int		hw_algo;
 	unsigned int		hw_margin;
 	unsigned long		last_jiffies;
@@ -56,6 +58,7 @@ static int gpio_wdt_start(struct watchdog_device *wdd)
 	gpio_direction_output(priv->gpio, priv->state);
 	priv->last_jiffies = jiffies;
 	mod_timer(&priv->timer, priv->last_jiffies + priv->hw_margin);
+	priv->armed = true;
 
 	return 0;
 }
@@ -64,8 +67,11 @@ static int gpio_wdt_stop(struct watchdog_device *wdd)
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
@@ -91,7 +97,7 @@ static void gpio_wdt_hwping(unsigned long data)
 	struct watchdog_device *wdd = (struct watchdog_device *)data;
 	struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
 
-	if (time_after(jiffies, priv->last_jiffies +
+	if (priv->armed && time_after(jiffies, priv->last_jiffies +
 		       msecs_to_jiffies(wdd->timeout * 1000))) {
 		dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
 		return;
@@ -197,6 +203,9 @@ static int gpio_wdt_probe(struct platform_device *pdev)
 	/* Use safe value (1/2 of real timeout) */
 	priv->hw_margin = msecs_to_jiffies(hw_margin / 2);
 
+	priv->always_running = of_property_read_bool(pdev->dev.of_node,
+				"always-running");
+
 	watchdog_set_drvdata(&priv->wdd, priv);
 
 	priv->wdd.info		= &gpio_wdt_ident;
@@ -218,6 +227,11 @@ static int gpio_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		watchdog_unregister_device(&priv->wdd);
 
+	if (priv->always_running) {
+		gpio_wdt_start(&priv->wdd);
+		priv->armed = false;
+	}
+
 	return ret;
 }
 
-- 
1.7.9.5

