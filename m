Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3FKIl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:41:58 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:59412 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab3FKIl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:41:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH] drivers: pinctrl: add active state to core
Date: Tue, 11 Jun 2013 10:16:56 +0200
Message-ID: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

In addition to the recently introduced pinctrl core
control, the PM runtime pin control for the OMAP platforms
require a fourth state in addtition to the default, idle and
sleep states already handled by the core: an explicit "active"
state. Let's introduce this to the core in addition to the
other states already defined.

Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Suggested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Greg: need your ACK on this to merge it through the pinctrl
tree.
---
 drivers/base/pinctrl.c                |  8 +++++++-
 drivers/pinctrl/core.c                | 15 +++++++++++++++
 include/linux/pinctrl/consumer.h      | 10 ++++++++++
 include/linux/pinctrl/devinfo.h       |  4 ++++
 include/linux/pinctrl/pinctrl-state.h |  5 +++++
 5 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/base/pinctrl.c b/drivers/base/pinctrl.c
index 5fb74b4..833d7cd 100644
--- a/drivers/base/pinctrl.c
+++ b/drivers/base/pinctrl.c
@@ -51,9 +51,15 @@ int pinctrl_bind_pins(struct device *dev)
 #ifdef CONFIG_PM
 	/*
 	 * If power management is enabled, we also look for the optional
-	 * sleep and idle pin states, with semantics as defined in
+	 * active, sleep and idle pin states, with semantics as defined in
 	 * <linux/pinctrl/pinctrl-state.h>
 	 */
+	dev->pins->active_state = pinctrl_lookup_state(dev->pins->p,
+					PINCTRL_STATE_ACTIVE);
+	if (IS_ERR(dev->pins->active_state))
+		/* Not supplying this state is perfectly legal */
+		dev_dbg(dev, "no active pinctrl state\n");
+
 	dev->pins->sleep_state = pinctrl_lookup_state(dev->pins->p,
 					PINCTRL_STATE_SLEEP);
 	if (IS_ERR(dev->pins->sleep_state))
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index dca9208..ff01b8f 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1217,6 +1217,21 @@ int pinctrl_pm_select_default_state(struct device *dev)
 	return ret;
 }
 
+int pinctrl_pm_select_active_state(struct device *dev)
+{
+	struct dev_pin_info *pins = dev->pins;
+	int ret;
+
+	if (!pins)
+		return 0;
+	if (IS_ERR(pins->active_state))
+		return 0; /* No active state */
+	ret = pinctrl_select_state(pins->p, pins->active_state);
+	if (ret)
+		dev_err(dev, "failed to activate pinctrl active state\n");
+	return ret;
+}
+
 /**
  * pinctrl_pm_select_sleep_state() - select sleep pinctrl state for PM
  * @dev: device to select sleep state for
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 0f32f10..18cdbb1 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -42,6 +42,7 @@ extern void devm_pinctrl_put(struct pinctrl *p);
 
 #ifdef CONFIG_PM
 extern int pinctrl_pm_select_default_state(struct device *dev);
+extern int pinctrl_pm_select_active_state(struct device *dev);
 extern int pinctrl_pm_select_sleep_state(struct device *dev);
 extern int pinctrl_pm_select_idle_state(struct device *dev);
 #else
@@ -49,6 +50,10 @@ static inline int pinctrl_pm_select_default_state(struct device *dev)
 {
 	return 0;
 }
+static inline int pinctrl_pm_select_active_state(struct device *dev)
+{
+	return 0;
+}
 static inline int pinctrl_pm_select_sleep_state(struct device *dev)
 {
 	return 0;
@@ -223,6 +228,11 @@ static inline int pinctrl_pm_select_default_state(struct device *dev)
 	return 0;
 }
 
+static inline int pinctrl_pm_select_active_state(struct device *dev)
+{
+	return 0;
+}
+
 static inline int pinctrl_pm_select_sleep_state(struct device *dev)
 {
 	return 0;
diff --git a/include/linux/pinctrl/devinfo.h b/include/linux/pinctrl/devinfo.h
index 281cb91..a61e6a5 100644
--- a/include/linux/pinctrl/devinfo.h
+++ b/include/linux/pinctrl/devinfo.h
@@ -24,11 +24,15 @@
  * struct dev_pin_info - pin state container for devices
  * @p: pinctrl handle for the containing device
  * @default_state: the default state for the handle, if found
+ * @active_state: the active state for the handle, if found
+ * @sleep_state: the sleep state for the handle, if found
+ * @idle_state: the idle state for the handle, if found
  */
 struct dev_pin_info {
 	struct pinctrl *p;
 	struct pinctrl_state *default_state;
 #ifdef CONFIG_PM
+	struct pinctrl_state *active_state;
 	struct pinctrl_state *sleep_state;
 	struct pinctrl_state *idle_state;
 #endif
diff --git a/include/linux/pinctrl/pinctrl-state.h b/include/linux/pinctrl/pinctrl-state.h
index b5919f8..37d0cd1 100644
--- a/include/linux/pinctrl/pinctrl-state.h
+++ b/include/linux/pinctrl/pinctrl-state.h
@@ -9,6 +9,10 @@
  *	hogs to configure muxing and pins at boot, and also as a state
  *	to go into when returning from sleep and idle in
  *	.pm_runtime_resume() or ordinary .resume() for example.
+ * @PINCTRL_STATE_ACTIVE: the state the pinctrl handle shall be put
+ *	into for explicitly active mode, typically in .pm_runtime_resume()
+ *	and other occasions where we want to be sure that the pins are
+ *	ready to roll.
  * @PINCTRL_STATE_IDLE: the state the pinctrl handle shall be put into
  *	when the pins are idle. This is a state where the system is relaxed
  *	but not fully sleeping - some power may be on but clocks gated for
@@ -20,5 +24,6 @@
  *	ordinary .suspend() function.
  */
 #define PINCTRL_STATE_DEFAULT "default"
+#define PINCTRL_STATE_ACTIVE "active"
 #define PINCTRL_STATE_IDLE "idle"
 #define PINCTRL_STATE_SLEEP "sleep"
-- 
1.7.11.3

