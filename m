Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab3GRPPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:15:11 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18246 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752845Ab3GRPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:15:08 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18O5oy+Om4ofU1CRQdgVieS
Subject: [PATCH 1/4] pinctrl: Remove duplicate code in
 pinctrl_pm_select_state functions
To: linus.walleij@linaro.org
From: Tony Lindgren <tony@atomide.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 18 Jul 2013 08:15:04 -0700
Message-ID: <20130718151504.30990.96819.stgit@localhost>
In-Reply-To: <20130718151213.30990.45828.stgit@localhost>
References: <20130718151213.30990.45828.stgit@localhost>
User-Agent: StGit/0.16-1-ga54b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to duplicate essentially the same functions. Let's
introduce static int pinctrl_pm_select_state() and make the other
related functions call that.

This allows us to add support later on for multiple active states,
and more optimized dynamic remuxing.

Note that we still need to export the various pinctrl_pm_select
functions as we want to keep struct pinctrl_state private to the
pinctrl code, and cannot replace those with inline functions.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/pinctrl/core.c |   55 ++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5b272bf..a97b717 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1227,23 +1227,36 @@ EXPORT_SYMBOL_GPL(pinctrl_force_default);
 #ifdef CONFIG_PM
 
 /**
- * pinctrl_pm_select_default_state() - select default pinctrl state for PM
+ * pinctrl_pm_select_state() - select pinctrl state for PM
  * @dev: device to select default state for
+ * @state: state to set
  */
-int pinctrl_pm_select_default_state(struct device *dev)
+static int pinctrl_pm_select_state(struct device *dev,
+				   struct pinctrl_state *state)
 {
 	struct dev_pin_info *pins = dev->pins;
 	int ret;
 
-	if (!pins)
-		return 0;
-	if (IS_ERR(pins->default_state))
-		return 0; /* No default state */
-	ret = pinctrl_select_state(pins->p, pins->default_state);
+	if (IS_ERR(state))
+		return 0; /* No such state */
+	ret = pinctrl_select_state(pins->p, state);
 	if (ret)
-		dev_err(dev, "failed to activate default pinctrl state\n");
+		dev_err(dev, "failed to activate pinctrl state %s\n",
+			state->name);
 	return ret;
 }
+
+/**
+ * pinctrl_pm_select_default_state() - select default pinctrl state for PM
+ * @dev: device to select default state for
+ */
+int pinctrl_pm_select_default_state(struct device *dev)
+{
+	if (!dev->pins)
+		return 0;
+
+	return pinctrl_pm_select_state(dev, dev->pins->default_state);
+}
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_default_state);
 
 /**
@@ -1252,17 +1265,10 @@ EXPORT_SYMBOL_GPL(pinctrl_pm_select_default_state);
  */
 int pinctrl_pm_select_sleep_state(struct device *dev)
 {
-	struct dev_pin_info *pins = dev->pins;
-	int ret;
-
-	if (!pins)
+	if (!dev->pins)
 		return 0;
-	if (IS_ERR(pins->sleep_state))
-		return 0; /* No sleep state */
-	ret = pinctrl_select_state(pins->p, pins->sleep_state);
-	if (ret)
-		dev_err(dev, "failed to activate pinctrl sleep state\n");
-	return ret;
+
+	return pinctrl_pm_select_state(dev, dev->pins->sleep_state);
 }
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_sleep_state);
 
@@ -1272,17 +1278,10 @@ EXPORT_SYMBOL_GPL(pinctrl_pm_select_sleep_state);
  */
 int pinctrl_pm_select_idle_state(struct device *dev)
 {
-	struct dev_pin_info *pins = dev->pins;
-	int ret;
-
-	if (!pins)
+	if (!dev->pins)
 		return 0;
-	if (IS_ERR(pins->idle_state))
-		return 0; /* No idle state */
-	ret = pinctrl_select_state(pins->p, pins->idle_state);
-	if (ret)
-		dev_err(dev, "failed to activate pinctrl idle state\n");
-	return ret;
+
+	return pinctrl_pm_select_state(dev, dev->pins->idle_state);
 }
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_idle_state);
 #endif

