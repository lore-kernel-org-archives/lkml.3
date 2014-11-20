Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbaKTNQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:16:32 -0500
Received: from atl4mhob11.myregisteredsite.com ([209.17.115.49]:54519 "EHLO
	atl4mhob11.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319AbaKTNQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:16:31 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH] gpio_wdt: Add "always_running" feature to GPIO watchdog
Date: Thu, 20 Nov 2014 14:16:17 +0100
Message-Id: <1416489377-13633-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
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
 drivers/watchdog/gpio_wdt.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
index 220a9e0..921ee67 100644
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
+				"always_running");
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

