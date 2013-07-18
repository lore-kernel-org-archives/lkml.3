Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab3GRPP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:15:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30978 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3GRPPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:15:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/kmuahBc96JWQZYAmv4D5I
Subject: [PATCH 3/4] pinctrl: Add support for additional dynamic states
To: linus.walleij@linaro.org
From: Tony Lindgren <tony@atomide.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 18 Jul 2013 08:15:11 -0700
Message-ID: <20130718151511.30990.8738.stgit@localhost>
In-Reply-To: <20130718151213.30990.45828.stgit@localhost>
References: <20130718151213.30990.45828.stgit@localhost>
User-Agent: StGit/0.16-1-ga54b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To toggle dynamic states, let's add the optional active state in
addition to the static default state. Then if the optional active
state is defined, we can require that idle and sleep states cover
the same pingroups as the active state.

Then let's add pinctrl_check_dynamic() and pinctrl_select_dynamic()
to use instead of pinctrl_select() to avoid breaking existing users.

With pinctrl_check_dynamic() we can check that idle and sleep states
match the active state for pingroups during init, and don't need to
do it during runtime.

Then with the states pre-validated, pinctrl_select_dynamic() can
just toggle between the dynamic states without extra checks.

Note that pinctr_select_state() still has valid use cases, such as
changing states when the pins can be shared between two drivers
and don't necessarily cover the same pingroups. For dynamic runtime
toggling of pin states, we should eventually always use just
pinctrl_select_dynamic().

Cc: Felipe Balbi <balbi@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 Documentation/pinctrl.txt             |   77 ++++++++++-
 drivers/pinctrl/core.c                |  226 ++++++++++++++++++++++++++++++---
 include/linux/pinctrl/consumer.h      |   46 +++++++
 include/linux/pinctrl/devinfo.h       |    4 +
 include/linux/pinctrl/pinctrl-state.h |   15 ++
 5 files changed, 342 insertions(+), 26 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 052e13a..0477ec5 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -1283,12 +1283,77 @@ This gives the exact same result as the above construction.
 Runtime pinmuxing
 =================
 
-It is possible to mux a certain function in and out at runtime, say to move
-an SPI port from one set of pins to another set of pins. Say for example for
-spi0 in the example above, we expose two different groups of pins for the same
-function, but with different named in the mapping as described under
-"Advanced mapping" above. So that for an SPI device, we have two states named
-"pos-A" and "pos-B".
+Typically runtime pinmuxing is done for runtime PM to mux a device RX pin
+to GPIO for wake-up events. And In some cases a shared RX/TX pin may need to
+be toggled. Sometimes pins can be also shared between two device drivers.
+
+In most cases runtime pinmuxing only is needed for some pins on a device, and
+most pins can be static. To avoid continuously having to check for all the
+pins of a device, pinctrl framework supports grouping device pin states to
+static and dynamic states.
+
+Most devices only need to use the static default state. If a devices has a
+need for runtime pinmuxing, the device must define the static default state,
+and then the optional dynamic states using the following rules:
+
+1. The default dynamic states are in addition to the static default state.
+
+2. The default dynamic states are active, sleep and idle, or active and idle.
+
+3. At least active and idle, or active and sleep states must be defined.
+
+4. Out of the dynamic pin states, only one of the active, sleep or idle states
+   can be active at a time.
+
+5. The dynamic pin states must all toggle the same pins to avoid unnecessary
+   checks during runtime.
+
+6. The pinctrl consumer driver must use pinctrl_select_dynamic() instead of
+   pinctrl_select_state() to toggle between the dynamic states.
+
+For example, to mux a serial driver RX pin to GPIO for runtime PM wake-up
+events, something like the following can be done. Most of the work is done
+by the pinctrl framework as long as the default, active and idle states are
+properly defined.
+
+#include <linux/pinctrl/consumer.h>
+
+serial_foo_probe()
+{
+	...
+	if (!pinctrl_pm_is_idle_state_error())
+		/* Set driver specific flags for runtime PM */
+	...
+}
+
+static int serial_foo_runtime_suspend(struct device *dev)
+{
+	...
+	res = pinctrl_pm_select_idle_state(dev);
+	if (ret < 0)
+		return ret;
+	...
+}
+
+static int serial_foo_runtime_resume(struct device *dev)
+{
+	...
+	res = pinctrl_pm_select_active_state(dev);
+	if (ret < 0)
+		return ret;
+	...
+}
+
+Currently only runtime muxing for runtime PM has been optimized as that can
+happen at high rate every time when idling and unidling devices. For less
+latency critical runtime remuxing it is possible to use pinctrl_select_state()
+as described below.
+
+For example, it is possible to move an SPI port from one set of pins to another
+set of pins. Say for example for spi0 in the example above, we expose two
+different groups of pins for the same function, but with different named in
+the mapping as described under "Advanced mapping" above. So that for an SPI
+device, we have two states named "pos-A" and "pos-B".
 
 This snippet first muxes the function in the pins defined by group A, enables
 it, disables and releases it, and muxes it in on the pins defined by group B:
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index c9b709b..af399cc 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -885,8 +885,13 @@ static void pinctrl_free(struct pinctrl *p, bool inlist)
 	mutex_lock(&pinctrl_list_mutex);
 	list_for_each_entry_safe(state, n1, &p->states, node) {
 		list_for_each_entry_safe(setting, n2, &state->settings, node) {
-			pinctrl_free_setting(state == p->state[PINCTRL_STATIC],
-					     setting);
+			bool disable_setting = false;
+
+			if ((state == p->state[PINCTRL_STATIC]) ||
+			    (state == p->state[PINCTRL_DYNAMIC]))
+				disable_setting = true;
+
+			pinctrl_free_setting(disable_setting, setting);
 			list_del(&setting->node);
 			kfree(setting);
 		}
@@ -949,6 +954,25 @@ struct pinctrl_state *pinctrl_lookup_state(struct pinctrl *p,
 EXPORT_SYMBOL_GPL(pinctrl_lookup_state);
 
 /**
+ * pinctrl_apply_setting() - apply a setting
+ * @setting: pinctrl setting to apply
+ */
+static int pinctrl_apply_setting(struct pinctrl_setting *setting)
+{
+	switch (setting->type) {
+	case PIN_MAP_TYPE_MUX_GROUP:
+		return pinmux_enable_setting(setting);
+	case PIN_MAP_TYPE_CONFIGS_PIN:
+	case PIN_MAP_TYPE_CONFIGS_GROUP:
+		return pinconf_apply_setting(setting);
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+/**
  * pinctrl_select_state() - select/activate/program a pinctrl state to HW
  * @p: the pinctrl handle for the device that requests configuration
  * @state: the state handle to select/activate/program
@@ -994,19 +1018,7 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 
 	/* Apply all the settings for the new state */
 	list_for_each_entry(setting, &state->settings, node) {
-		switch (setting->type) {
-		case PIN_MAP_TYPE_MUX_GROUP:
-			ret = pinmux_enable_setting(setting);
-			break;
-		case PIN_MAP_TYPE_CONFIGS_PIN:
-		case PIN_MAP_TYPE_CONFIGS_GROUP:
-			ret = pinconf_apply_setting(setting);
-			break;
-		default:
-			ret = -EINVAL;
-			break;
-		}
-
+		ret = pinctrl_apply_setting(setting);
 		if (ret < 0) {
 			goto unapply_new_state;
 		}
@@ -1041,6 +1053,122 @@ unapply_new_state:
 }
 EXPORT_SYMBOL_GPL(pinctrl_select_state);
 
+/**
+ * pinctrl_setting_get_group_pins() - get group pins for a pinctrl setting
+ * @s: pinctrl setting pointer
+ * @pins: pins
+ * @num_pins: number of pins
+ */
+static int pinctrl_setting_get_group_pins(struct pinctrl_setting *s,
+				const unsigned **pins, unsigned *num_pins)
+{
+	struct pinctrl_dev *pctldev;
+	const struct pinctrl_ops *pctlops;
+
+	if (s->type != PIN_MAP_TYPE_MUX_GROUP)
+		return -EINVAL;
+
+	pctldev = s->pctldev;
+	pctlops = pctldev->desc->pctlops;
+
+	return pctlops->get_group_pins(pctldev, s->data.mux.group,
+					pins, num_pins);
+}
+
+/**
+ * pinctrl_state_get_pin_count() - get a pin count for a state
+ * @st: pinctrl state pointer
+ */
+static int pinctrl_state_get_pin_count(struct pinctrl_state *st)
+{
+	struct pinctrl_setting *s;
+	int found = 0;
+
+	list_for_each_entry(s, &st->settings, node) {
+		const unsigned *pins;
+		unsigned num_pins;
+		int res;
+
+		res = pinctrl_setting_get_group_pins(s, &pins, &num_pins);
+		if (res)
+			continue;
+
+		found += num_pins;
+	}
+
+	return found;
+}
+
+/**
+ * pinctrl_check_dynamic() - compare two states for the pins
+ * @dev: pinctrl consumer device pointer
+ * @st1: state handle
+ * @st2: state handle
+ *
+ * This function checks that the group pins match between the two
+ * states to avoid runtime checking. Note that currently the checking
+ * is very minimal, but can be enhanced as needed. Even this minimal
+ * check should be enough to avoid trying to use the default pins state
+ * with pinctrl_select_dynamic().
+ *
+ * Call this during pinctrl consumer driver probe time to check
+ * dynamic pin states used by the device for runtime PM etc.
+
+ * REVISIT: We can improve this further by adding device_get_pins()
+ * and adding a sorted state arrays for pins at device probe time.
+ * The comparing two states can be done just by comparing the two
+ * arrays.
+ */
+int pinctrl_check_dynamic(struct device *dev, struct pinctrl_state *st1,
+			  struct pinctrl_state *st2)
+{
+	int num_pins1, num_pins2;
+
+	num_pins1 = pinctrl_state_get_pin_count(st1);
+	num_pins2 = pinctrl_state_get_pin_count(st2);
+
+	if (num_pins1 != num_pins2) {
+		dev_err(dev, "device pins do not match for PM states\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinctrl_check_dynamic);
+
+/**
+ * pinctrl_select_dynamic() - fast path for toggling pre-validated sets of pins
+ * @p: the pinctrl handle for the device that requests configuration
+ * @state: the state handle to select/activate/program
+ *
+ * Note that as we've already checked that the PINCTRL_DYNAMIC pins always
+ * cover the same sets for active/idle, or rx/tx, there's no need to call
+ * pinux_disable_settings() on these pins. Calling it could also cause
+ * issues for the connected peripheral as it potentially could change the
+ * values of data lines for example.
+ */
+int pinctrl_select_dynamic(struct pinctrl *p, struct pinctrl_state *state)
+{
+	struct pinctrl_setting *setting;
+	int ret;
+
+	if (p->state[PINCTRL_DYNAMIC] == state)
+		return 0;
+
+	list_for_each_entry(setting, &state->settings, node) {
+		ret = pinctrl_apply_setting(setting);
+		if (ret < 0) {
+			dev_err(p->dev, "Error applying dynamic settings\n");
+			return ret;
+		}
+	}
+
+	p->state[PINCTRL_DYNAMIC] = state;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pinctrl_select_dynamic);
+
 static void devm_pinctrl_release(struct device *dev, void *res)
 {
 	pinctrl_put(*(struct pinctrl **)res);
@@ -1240,7 +1368,13 @@ static int pinctrl_pm_select_state(struct device *dev,
 
 	if (IS_ERR(state))
 		return 0; /* No such state */
-	ret = pinctrl_select_state(pins->p, state);
+
+	/* Configured for dynamic muxing? */
+	if (!IS_ERR(dev->pins->active_state))
+		ret = pinctrl_select_dynamic(pins->p, state);
+	else
+		ret = pinctrl_select_state(pins->p, state);
+
 	if (ret)
 		dev_err(dev, "failed to activate pinctrl state %s\n",
 			state->name);
@@ -1261,6 +1395,19 @@ int pinctrl_pm_select_default_state(struct device *dev)
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_default_state);
 
 /**
+ * pinctrl_pm_select_active_state() - select active pinctrl state for PM
+ * @dev: device to select default state for
+ */
+int pinctrl_pm_select_active_state(struct device *dev)
+{
+	if (!dev->pins)
+		return 0;
+
+	return pinctrl_pm_select_state(dev, dev->pins->active_state);
+}
+EXPORT_SYMBOL_GPL(pinctrl_pm_select_active_state);
+
+/**
  * pinctrl_pm_select_sleep_state() - select sleep pinctrl state for PM
  * @dev: device to select sleep state for
  */
@@ -1285,6 +1432,47 @@ int pinctrl_pm_select_idle_state(struct device *dev)
 	return pinctrl_pm_select_state(dev, dev->pins->idle_state);
 }
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_idle_state);
+
+static int pinctrl_pm_is_state_error(struct device *dev,
+				  struct pinctrl_state *state)
+{
+	if (!dev)
+		return -EINVAL;
+
+	return IS_ERR(state);
+}
+
+/**
+ * pinctrl_pm_is_sleep_state_error() - check if sleep state is configured
+ * @dev: consumer device
+ *
+ * Call this from consumer driver to check if the sleep state
+ * has been properly configured on the device.
+ */
+int pinctrl_pm_is_sleep_state_error(struct device *dev)
+{
+	if (!dev->pins)
+		return 0;
+
+	return pinctrl_pm_is_state_error(dev, dev->pins->sleep_state);
+}
+EXPORT_SYMBOL_GPL(pinctrl_pm_is_sleep_state_error);
+
+/**
+ * pinctrl_pm_is_idle_state_error() - check if idle state is configured
+ * @dev: consumer device
+ *
+ * Call this from consumer driver to check if the idle state
+ * has been properly configured on the device.
+ */
+int pinctrl_pm_is_idle_state_error(struct device *dev)
+{
+	if (!dev->pins)
+		return 0;
+
+	return pinctrl_pm_is_state_error(dev, dev->pins->idle_state);
+}
+EXPORT_SYMBOL_GPL(pinctrl_pm_is_idle_state_error);
 #endif
 
 #ifdef CONFIG_DEBUG_FS
@@ -1491,10 +1679,12 @@ static int pinctrl_show(struct seq_file *s, void *what)
 	mutex_lock(&pinctrl_list_mutex);
 
 	list_for_each_entry(p, &pinctrl_list, node) {
-		seq_printf(s, "device: %s current state: %s\n",
+		seq_printf(s, "device: %s current states: %s %s\n",
 			   dev_name(p->dev),
 			   p->state[PINCTRL_STATIC] ?
-			   p->state[PINCTRL_STATIC]->name : "none");
+			   p->state[PINCTRL_STATIC]->name : "none",
+			   p->state[PINCTRL_DYNAMIC] ?
+			   p->state[PINCTRL_DYNAMIC]->name : "none");
 
 		list_for_each_entry(state, &p->states, node) {
 			seq_printf(s, "  state: %s\n", state->name);
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index 18eccef..333885b 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -36,19 +36,29 @@ extern struct pinctrl_state * __must_check pinctrl_lookup_state(
 							struct pinctrl *p,
 							const char *name);
 extern int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *s);
+extern int pinctrl_check_dynamic(struct device *dev, struct pinctrl_state *s1,
+				 struct pinctrl_state *s2);
+extern int pinctrl_select_dynamic(struct pinctrl *p, struct pinctrl_state *s);
 
 extern struct pinctrl * __must_check devm_pinctrl_get(struct device *dev);
 extern void devm_pinctrl_put(struct pinctrl *p);
 
 #ifdef CONFIG_PM
 extern int pinctrl_pm_select_default_state(struct device *dev);
+extern int pinctrl_pm_select_active_state(struct device *dev);
 extern int pinctrl_pm_select_sleep_state(struct device *dev);
 extern int pinctrl_pm_select_idle_state(struct device *dev);
+extern int pinctrl_pm_is_sleep_state_error(struct device *dev);
+extern int pinctrl_pm_is_idle_state_error(struct device *dev);
 #else
 static inline int pinctrl_pm_select_default_state(struct device *dev)
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
@@ -57,6 +67,14 @@ static inline int pinctrl_pm_select_idle_state(struct device *dev)
 {
 	return 0;
 }
+static inline int pinctrl_pm_is_sleep_state_error(struct device *dev)
+{
+	return -ENODEV;
+}
+static inline int pinctrl_pm_is_idle_state_error(struct device *dev)
+{
+	return -ENODEV;
+}
 #endif
 
 #else /* !CONFIG_PINCTRL */
@@ -102,6 +120,19 @@ static inline int pinctrl_select_state(struct pinctrl *p,
 	return 0;
 }
 
+static inline int pinctrl_check_dynamic(struct device *dev,
+					struct pinctrl_state *s1,
+					struct pinctrl_state *s2)
+{
+	return 0;
+}
+
+static inline int pinctrl_select_dynamic(struct pinctrl *p,
+				       struct pinctrl_state *s)
+{
+	return 0;
+}
+
 static inline struct pinctrl * __must_check devm_pinctrl_get(struct device *dev)
 {
 	return NULL;
@@ -116,6 +147,11 @@ static inline int pinctrl_pm_select_default_state(struct device *dev)
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
@@ -126,6 +162,16 @@ static inline int pinctrl_pm_select_idle_state(struct device *dev)
 	return 0;
 }
 
+static inline int pinctrl_pm_is_sleep_state_error(struct device *dev)
+{
+	return -ENODEV;
+}
+
+static inline int pinctrl_pm_is_idle_state_error(struct device *dev)
+{
+	return -ENODEV;
+}
+
 #endif /* CONFIG_PINCTRL */
 
 static inline struct pinctrl * __must_check pinctrl_get_select(
diff --git a/include/linux/pinctrl/devinfo.h b/include/linux/pinctrl/devinfo.h
index 281cb91..2857a7b 100644
--- a/include/linux/pinctrl/devinfo.h
+++ b/include/linux/pinctrl/devinfo.h
@@ -24,10 +24,14 @@
  * struct dev_pin_info - pin state container for devices
  * @p: pinctrl handle for the containing device
  * @default_state: the default state for the handle, if found
+ * @active_state: the default state for the handle, if found
+ * @sleep_state: the default state for the handle, if found
+ * @idle_state: the default state for the handle, if found
  */
 struct dev_pin_info {
 	struct pinctrl *p;
 	struct pinctrl_state *default_state;
+	struct pinctrl_state *active_state;
 #ifdef CONFIG_PM
 	struct pinctrl_state *sleep_state;
 	struct pinctrl_state *idle_state;
diff --git a/include/linux/pinctrl/pinctrl-state.h b/include/linux/pinctrl/pinctrl-state.h
index b5919f8..c136e82 100644
--- a/include/linux/pinctrl/pinctrl-state.h
+++ b/include/linux/pinctrl/pinctrl-state.h
@@ -9,16 +9,27 @@
  *	hogs to configure muxing and pins at boot, and also as a state
  *	to go into when returning from sleep and idle in
  *	.pm_runtime_resume() or ordinary .resume() for example.
+ * @PINCTRL_STATE_ACTIVE: optional state of dynamic pins in addition to
+ *	PINCTRL_STATE_DEFAULT that are needed during runtime.
  * @PINCTRL_STATE_IDLE: the state the pinctrl handle shall be put into
  *	when the pins are idle. This is a state where the system is relaxed
  *	but not fully sleeping - some power may be on but clocks gated for
  *	example. Could typically be set from a pm_runtime_suspend() or
- *	pm_runtime_idle() operation.
+ *	pm_runtime_idle() operation. If PINCTRL_STATE_ACTIVE pins are
+ *	defined, PINCTRL_STATE_IDLE pin groups must cover the same pin
+ *	groups as PINCTRL_STATE_ACTIVE and selecting PINCTRL_STATE_IDLE
+ *	must be done using pinctrl_select_state_dynamic() instead of
+ *	pinctrl_select_state().
  * @PINCTRL_STATE_SLEEP: the state the pinctrl handle shall be put into
  *	when the pins are sleeping. This is a state where the system is in
  *	its lowest sleep state. Could typically be set from an
- *	ordinary .suspend() function.
+ *	ordinary .suspend() function. If PINCTRL_STATE_ACTIVE pins are
+ *	defined, PINCTRL_STATE_SLEEP pin groups must cover the same pin
+ *	groups as PINCTRL_STATE_ACTIVE and selecting PINCTRL_STATE_SLEEP
+ *	must be done using pinctrl_select_state_dynamic() instead of
+ *	pinctrl_select_state().
  */
 #define PINCTRL_STATE_DEFAULT "default"
+#define PINCTRL_STATE_ACTIVE "active"
 #define PINCTRL_STATE_IDLE "idle"
 #define PINCTRL_STATE_SLEEP "sleep"

