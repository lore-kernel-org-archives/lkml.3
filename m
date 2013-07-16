Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3GPJFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:05:41 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41648 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754225Ab3GPJFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:05:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Z2IUkpbps8eb5k6u/8VVj
Subject: [PATCH 3/4] pinctrl: Add support for additional dynamic states
To: linus.walleij@linaro.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Date: Tue, 16 Jul 2013 02:05:36 -0700
Message-ID: <20130716090536.5541.36289.stgit@localhost>
In-Reply-To: <20130716090310.5541.36777.stgit@localhost>
References: <20130716090310.5541.36777.stgit@localhost>
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

Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/pinctrl/core.c                |  189 ++++++++++++++++++++++++++++++++-
 include/linux/pinctrl/consumer.h      |   46 ++++++++
 include/linux/pinctrl/devinfo.h       |    4 +
 include/linux/pinctrl/pinctrl-state.h |   15 ++-
 4 files changed, 249 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 8da11d5..4f58a97 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -887,6 +887,8 @@ static void pinctrl_free(struct pinctrl *p, bool inlist)
 		list_for_each_entry_safe(setting, n2, &state->settings, node) {
 			pinctrl_free_setting(state == p->state[PINCTRL_STATIC],
 					     setting);
+			pinctrl_free_setting(state == p->state[PINCTRL_DYNAMIC],
+					     setting);
 			list_del(&setting->node);
 			kfree(setting);
 		}
@@ -1041,6 +1043,134 @@ unapply_new_state:
 }
 EXPORT_SYMBOL_GPL(pinctrl_select_state);
 
+/**
+ * pinctrl_check_dynamic() - compare two states for the pins
+ * @dev: pinctrl consumer device pointer
+ * @st1: state handle
+ * @st2: state handle
+ *
+ * This function checks that the group pins match between the two
+ * states to avoid runtime checking. Use this to check dynamic pin
+ * states during init.
+ */
+int pinctrl_check_dynamic(struct device *dev, struct pinctrl_state *st1,
+			  struct pinctrl_state *st2)
+{
+	struct pinctrl_setting *s1, *s2;
+
+	list_for_each_entry(s1, &st1->settings, node) {
+		struct pinctrl_dev *pctldev1;
+		const struct pinctrl_ops *pctlops1;
+		const unsigned *pins1;
+		unsigned num_pins1;
+		int res;
+
+		if (s1->type != PIN_MAP_TYPE_MUX_GROUP)
+			continue;
+
+		pctldev1 = s1->pctldev;
+		pctlops1 = pctldev1->desc->pctlops;
+		res = pctlops1->get_group_pins(pctldev1, s1->data.mux.group,
+					       &pins1, &num_pins1);
+		if (res) {
+			dev_dbg(dev, "could not get state1 group pins\n");
+			return -EINVAL;
+		}
+
+		list_for_each_entry(s2, &st2->settings, node) {
+			struct pinctrl_dev *pctldev2;
+			const struct pinctrl_ops *pctlops2;
+			const unsigned *pins2;
+			unsigned num_pins2;
+			int i, j, found = 0;
+
+			if (s2->type != PIN_MAP_TYPE_MUX_GROUP)
+				continue;
+
+			pctldev2 = s2->pctldev;
+			if (pctldev1 != pctldev2) {
+				dev_dbg(dev, "pctldev must be the same for states\n");
+				return -EINVAL;
+			}
+			pctlops2 = pctldev2->desc->pctlops;
+			res = pctlops2->get_group_pins(pctldev2,
+						       s2->data.mux.group,
+						       &pins2, &num_pins2);
+			if (res) {
+				dev_dbg(dev, "could not get state2 group pins\n");
+				return -EINVAL;
+			}
+
+			for (i = 0; i < num_pins1; i++) {
+				int pin1 = pins1[i];
+
+				for (j = 0; j < num_pins2; j++) {
+					int pin2 = pins2[j];
+
+					if (pin1 == pin2) {
+						found++;
+						break;
+					}
+				}
+			}
+
+			if (found != num_pins1) {
+				dev_dbg(dev, "found only %i of %i pins\n",
+					found, num_pins1);
+				return -EINVAL;
+			}
+		}
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
+		switch (setting->type) {
+		case PIN_MAP_TYPE_MUX_GROUP:
+			ret = pinmux_enable_setting(setting);
+			break;
+		case PIN_MAP_TYPE_CONFIGS_PIN:
+		case PIN_MAP_TYPE_CONFIGS_GROUP:
+			ret = pinconf_apply_setting(setting);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+
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
@@ -1241,7 +1371,13 @@ static int pinctrl_pm_select_state(struct device *dev, struct pinctrl_state *sta
 		return 0;
 	if (IS_ERR(state))
 		return 0; /* No such state */
-	ret = pinctrl_select_state(pins->p, state);
+
+	/* Configured for proper dynamic muxing? */
+	if (!IS_ERR(dev->pins->active_state))
+		ret = pinctrl_select_dynamic(pins->p, state);
+	else
+		ret = pinctrl_select_state(pins->p, state);
+
 	if (ret)
 		dev_err(dev, "failed to activate pinctrl state %s\n",
 			state->name);
@@ -1259,6 +1395,16 @@ int pinctrl_pm_select_default_state(struct device *dev)
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_default_state);
 
 /**
+ * pinctrl_pm_select_active_state() - select active pinctrl state for PM
+ * @dev: device to select default state for
+ */
+int pinctrl_pm_select_active_state(struct device *dev)
+{
+	return pinctrl_pm_select_state(dev, dev->pins->active_state);
+}
+EXPORT_SYMBOL_GPL(pinctrl_pm_select_active_state);
+
+/**
  * pinctrl_pm_select_sleep_state() - select sleep pinctrl state for PM
  * @dev: device to select sleep state for
  */
@@ -1277,6 +1423,41 @@ int pinctrl_pm_select_idle_state(struct device *dev)
 	return pinctrl_pm_select_state(dev, dev->pins->idle_state);
 }
 EXPORT_SYMBOL_GPL(pinctrl_pm_select_idle_state);
+
+static int pinctrl_pm_check_state(struct device *dev,
+				  struct pinctrl_state *state)
+{
+	if (!dev)
+		return -EINVAL;
+
+	return IS_ERR(state);
+}
+
+/**
+ * pinctrl_pm_check_sleep_state() - check if sleep state is configured
+ * @dev: consumer device
+ *
+ * Call this from consumer driver to check if the sleep state
+ * has been properly configured on the device.
+ */
+int pinctrl_pm_check_sleep_state(struct device *dev)
+{
+	return pinctrl_pm_check_state(dev, dev->pins->sleep_state);
+}
+EXPORT_SYMBOL_GPL(pinctrl_pm_check_sleep_state);
+
+/**
+ * pinctrl_pm_check_idle_state() - check if idle state is configured
+ * @dev: consumer device
+ *
+ * Call this from consumer driver to check if the idle state
+ * has been properly configured on the device.
+ */
+int pinctrl_pm_check_idle_state(struct device *dev)
+{
+	return pinctrl_pm_check_state(dev, dev->pins->idle_state);
+}
+EXPORT_SYMBOL_GPL(pinctrl_pm_check_idle_state);
 #endif
 
 #ifdef CONFIG_DEBUG_FS
@@ -1483,10 +1664,12 @@ static int pinctrl_show(struct seq_file *s, void *what)
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
index 18eccef..73a82f1 100644
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
+extern int pinctrl_pm_check_sleep_state(struct device *dev);
+extern int pinctrl_pm_check_idle_state(struct device *dev);
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
+static inline int pinctrl_pm_check_sleep_state(struct device *dev)
+{
+	return -ENODEV;
+}
+static inline int pinctrl_pm_check_idle_state(struct device *dev)
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
 
+static inline int pinctrl_pm_check_sleep_state(struct device *dev)
+{
+	return -ENODEV;
+}
+
+static inline int pinctrl_pm_check_idle_state(struct device *dev)
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

