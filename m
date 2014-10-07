Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaJGU2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:28:32 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35246 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaJGU2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:28:31 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: thierry.reding@gmail.com, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Chris Zhong <zyw@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        Doug Anderson <dianders@chromium.org>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] drivers/pinctrl: Add the concept of an "init" state
Date: Tue,  7 Oct 2014 13:28:15 -0700
Message-Id: <1412713696-13343-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For pinctrl the "default" state is applied to pins before the driver's
probe function is called.  This is normally a sensible thing to do,
but in some cases can cause problems.  That's because the pins will
change state before the driver is given a chance to program how those
pins should behave.

As an example you might have a regulator that is controlled by a PWM
(output high = high voltage, output low = low voltage).  The firmware
might leave this pin as driven high.  If we allow the driver core to
reconfigure this pin as a PWM pin before the PWM's probe function runs
then you might end up running at too low of a voltage while we probe.

Let's introudce a new "init" state.  If this is defined we'll set
pinctrl to this state before probe and then "default" after probe
(unless the driver explicitly changed states already).

An alternative idea that was thought of was to use the pre-existing
"sleep" or "idle" states and add a boolean property that we should
start in that mode.  This was not done because the "init" state is
needed for correctness and those other states are only present (and
only transitioned in to and out of) when (optional) power management
is enabled.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
See <https://patchwork.kernel.org/patch/4960731/> for some extra
context here.  

Note that this patch has only been very lightly tested since it turns
out that I probably don't need this functionality urgently. The PWM
regulator example cited in the commit message was the original
motivation but it turns out that the newest firmware actually leaves
the PWM configured and enabled (and that is part of the contract
between the firmware and the kernel on this system).  I'm still
posting it because it seems like it could be useful to someone.

 drivers/base/dd.c                     |  2 ++
 drivers/base/pinctrl.c                | 15 +++++++++++++--
 drivers/pinctrl/core.c                | 28 ++++++++++++++++++++++++++++
 include/linux/pinctrl/consumer.h      |  6 ++++++
 include/linux/pinctrl/devinfo.h       |  4 ++++
 include/linux/pinctrl/pinctrl-state.h |  8 ++++++++
 6 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index cdc779c..e2a15b2 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -308,6 +308,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 			goto probe_failed;
 	}
 
+	pinctrl_init_done(dev);
+
 	driver_bound(dev);
 	ret = 1;
 	pr_debug("bus: '%s': %s: bound device %s to driver %s\n",
diff --git a/drivers/base/pinctrl.c b/drivers/base/pinctrl.c
index 5fb74b4..0762975 100644
--- a/drivers/base/pinctrl.c
+++ b/drivers/base/pinctrl.c
@@ -42,9 +42,20 @@ int pinctrl_bind_pins(struct device *dev)
 		goto cleanup_get;
 	}
 
-	ret = pinctrl_select_state(dev->pins->p, dev->pins->default_state);
+	dev->pins->init_state = pinctrl_lookup_state(dev->pins->p,
+					PINCTRL_STATE_INIT);
+	if (IS_ERR(dev->pins->init_state)) {
+		/* Not supplying this state is perfectly legal */
+		dev_dbg(dev, "no init pinctrl state\n");
+
+		ret = pinctrl_select_state(dev->pins->p,
+					   dev->pins->default_state);
+	} else {
+		ret = pinctrl_select_state(dev->pins->p, dev->pins->init_state);
+	}
+
 	if (ret) {
-		dev_dbg(dev, "failed to activate default pinctrl state\n");
+		dev_dbg(dev, "failed to activate initial pinctrl state\n");
 		goto cleanup_get;
 	}
 
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index e4f6551..d9c39e2 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1240,6 +1240,34 @@ int pinctrl_force_default(struct pinctrl_dev *pctldev)
 }
 EXPORT_SYMBOL_GPL(pinctrl_force_default);
 
+/**
+ * pinctrl_init_done() - tell pinctrl probe is done
+ * @dev: device to that's done probing
+ */
+int pinctrl_init_done(struct device *dev)
+{
+	struct dev_pin_info *pins = dev->pins;
+	int ret;
+
+	if (!pins)
+		return 0;
+
+	if (IS_ERR(pins->init_state))
+		return 0; /* No such state */
+
+	if (pins->p->state != pins->init_state)
+		return 0; /* Not at init anyway */
+
+	if (IS_ERR(pins->default_state))
+		return 0; /* No default state */
+
+	ret = pinctrl_select_state(pins->p, pins->default_state);
+	if (ret)
+		dev_err(dev, "failed to activate default pinctrl state\n");
+
+	return ret;
+}
+
 #ifdef CONFIG_PM
 
 /**
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 18eccef..b3bf5785 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -39,6 +39,7 @@ extern int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *s);
 
 extern struct pinctrl * __must_check devm_pinctrl_get(struct device *dev);
 extern void devm_pinctrl_put(struct pinctrl *p);
+extern int pinctrl_init_done(struct device *dev);
 
 #ifdef CONFIG_PM
 extern int pinctrl_pm_select_default_state(struct device *dev);
@@ -111,6 +112,11 @@ static inline void devm_pinctrl_put(struct pinctrl *p)
 {
 }
 
+static inline int pinctrl_init_done(struct device *dev)
+{
+	return 0;
+}
+
 static inline int pinctrl_pm_select_default_state(struct device *dev)
 {
 	return 0;
diff --git a/include/linux/pinctrl/devinfo.h b/include/linux/pinctrl/devinfo.h
index 281cb91..200c9d1 100644
--- a/include/linux/pinctrl/devinfo.h
+++ b/include/linux/pinctrl/devinfo.h
@@ -24,10 +24,14 @@
  * struct dev_pin_info - pin state container for devices
  * @p: pinctrl handle for the containing device
  * @default_state: the default state for the handle, if found
+ * @init_state: the state at probe time, if found
+ * @sleep_state: the state at suspend time, if found
+ * @idle_state: the state at idle (runtime suspend) time, if found
  */
 struct dev_pin_info {
 	struct pinctrl *p;
 	struct pinctrl_state *default_state;
+	struct pinctrl_state *init_state;
 #ifdef CONFIG_PM
 	struct pinctrl_state *sleep_state;
 	struct pinctrl_state *idle_state;
diff --git a/include/linux/pinctrl/pinctrl-state.h b/include/linux/pinctrl/pinctrl-state.h
index b5919f8..2307351 100644
--- a/include/linux/pinctrl/pinctrl-state.h
+++ b/include/linux/pinctrl/pinctrl-state.h
@@ -9,6 +9,13 @@
  *	hogs to configure muxing and pins at boot, and also as a state
  *	to go into when returning from sleep and idle in
  *	.pm_runtime_resume() or ordinary .resume() for example.
+ * @PINCTRL_STATE_INIT: normally the pinctrl will be set to "default"
+ *	before the driver's probe() function is called.  There are some
+ *	drivers where that is not appropriate becausing doing so would
+ *	glitch the pins.  In those cases you can add an "init" pinctrl
+ *	which is the state of the pins before drive probe.  After probe
+ *	if the pins are still in "init" state they'll be moved to
+ *	"default".
  * @PINCTRL_STATE_IDLE: the state the pinctrl handle shall be put into
  *	when the pins are idle. This is a state where the system is relaxed
  *	but not fully sleeping - some power may be on but clocks gated for
@@ -20,5 +27,6 @@
  *	ordinary .suspend() function.
  */
 #define PINCTRL_STATE_DEFAULT "default"
+#define PINCTRL_STATE_INIT "init"
 #define PINCTRL_STATE_IDLE "idle"
 #define PINCTRL_STATE_SLEEP "sleep"
-- 
2.1.0.rc2.206.gedb03e5

