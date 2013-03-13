Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876Ab3CMPpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:45:05 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:47358 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932910Ab3CMPpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:45:01 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: move subsystem mutex to pinctrl_dev struct
Date: Wed, 13 Mar 2013 16:44:39 +0100
Message-ID: <1363189479-11240-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

This mutex avoids deadlock in case of use of multiple pin
controllers. Before this modification, by using a global
mutex, deadlock appeared when, for example, a call to
pinctrl_pins_show() locked the pinctrl_mutex, called the
ops->pin_dbg_show of a particular pin controller. If this
pin controller needs I2C access to retrieve configuration
information and I2C driver is using pinctrl to drive its
pins, a call to pinctrl_select_state() try to lock again
pinctrl_mutex which leads to a deadlock.

Notice that the mutex grab from the two direction functions
was moved into pinctrl_gpio_direction().

For two cases, we can't replace pinctrl_mutex by
pctldev->mutex, because at this stage, pctldev is
not accessible :
	- pinctrl_get()/pinctrl_put()
	- pinctrl_register_maps()

So add respectively pinctrl_list_mutex and
pinctrl_maps_mutex in order to protect
pinctrl_list and pinctrl_maps list instead.

Reported by : Seraphin Bonnaffe <seraphin.bonnaffe@stericsson.com>
Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c    | 199 +++++++++++++++++++++++++++++++---------------
 drivers/pinctrl/core.h    |   4 +-
 drivers/pinctrl/pinconf.c |  46 ++++++-----
 drivers/pinctrl/pinmux.c  |   8 +-
 4 files changed, 165 insertions(+), 92 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index f8a632d..dafbd20 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -36,8 +36,11 @@
 
 static bool pinctrl_dummy_state;
 
-/* Mutex taken by all entry points */
-DEFINE_MUTEX(pinctrl_mutex);
+/* Mutex taken to protect pinctrl_list */
+DEFINE_MUTEX(pinctrl_list_mutex);
+
+/* Mutex taken to protect pinctrl_maps */
+DEFINE_MUTEX(pinctrl_maps_mutex);
 
 /* Global list of pin control devices (struct pinctrl_dev) */
 LIST_HEAD(pinctrldev_list);
@@ -82,6 +85,45 @@ void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev)
 EXPORT_SYMBOL_GPL(pinctrl_dev_get_drvdata);
 
 /**
+ * get_pinctrl_dev_from_pinctrl() - look up pin controller device from pinctrl
+ * @pinctrl: pinctrl pointer from which pinctrl_dev is retrieved
+ *
+ * Looks up a pin controller device matching a pinctrl pointer if it exists,
+ * return the pin controller device or -EINVAL if it can not be found.
+ */
+struct pinctrl_dev *get_pinctrl_dev_from_pinctrl(struct pinctrl *p)
+{
+	struct pinctrl *pctl;
+	struct pinctrl_dev *pctldev = ERR_PTR(-EINVAL);
+	struct pinctrl_state *state;
+	struct pinctrl_setting *setting;
+	bool found = false;
+
+	list_for_each_entry(pctl, &pinctrl_list, node) {
+		if (p == pctl) {
+			/* Matched on pinctrl */
+			found = true;
+			break;
+		}
+	}
+
+	if (found) {
+		if (list_empty(&pctl->states))
+			return pctldev;
+
+		state = list_first_entry(&pctl->states, struct pinctrl_state,
+					 node);
+		if (list_empty(&state->settings))
+			return pctldev;
+
+		setting = list_first_entry(&state->settings,
+					   struct pinctrl_setting, node);
+		pctldev = setting->pctldev;
+	}
+	return pctldev;
+}
+
+/**
  * get_pinctrl_dev_from_devname() - look up pin controller device
  * @devname: the name of a device instance, as returned by dev_name()
  *
@@ -166,9 +208,9 @@ bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
 	if (pin < 0)
 		return false;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 	pindesc = pin_desc_get(pctldev, pin);
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return pindesc != NULL;
 }
@@ -353,9 +395,9 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
 void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 			    struct pinctrl_gpio_range *range)
 {
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 	list_add_tail(&range->node, &pctldev->gpio_ranges);
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_add_gpio_range);
 
@@ -420,9 +462,9 @@ EXPORT_SYMBOL_GPL(pinctrl_find_gpio_range_from_pin);
 void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
 			       struct pinctrl_gpio_range *range)
 {
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 	list_del(&range->node);
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_remove_gpio_range);
 
@@ -473,22 +515,20 @@ int pinctrl_request_gpio(unsigned gpio)
 	int ret;
 	int pin;
 
-	mutex_lock(&pinctrl_mutex);
-
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
 		if (pinctrl_ready_for_gpio_range(gpio))
 			ret = 0;
-		mutex_unlock(&pinctrl_mutex);
 		return ret;
 	}
+	mutex_lock(&pctldev->mutex);
 
 	/* Convert to the pin controllers number space */
 	pin = gpio - range->base + range->pin_base;
 
 	ret = pinmux_request_gpio(pctldev, range, pin, gpio);
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pinctrl_request_gpio);
@@ -508,20 +548,18 @@ void pinctrl_free_gpio(unsigned gpio)
 	int ret;
 	int pin;
 
-	mutex_lock(&pinctrl_mutex);
-
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
-		mutex_unlock(&pinctrl_mutex);
 		return;
 	}
+	mutex_lock(&pctldev->mutex);
 
 	/* Convert to the pin controllers number space */
 	pin = gpio - range->base + range->pin_base;
 
 	pinmux_free_gpio(pctldev, pin, range);
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_free_gpio);
 
@@ -536,10 +574,15 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
 	if (ret)
 		return ret;
 
+	mutex_lock(&pctldev->mutex);
+
 	/* Convert to the pin controllers number space */
 	pin = gpio - range->base + range->pin_base;
+	ret = pinmux_gpio_direction(pctldev, range, pin, input);
 
-	return pinmux_gpio_direction(pctldev, range, pin, input);
+	mutex_unlock(&pctldev->mutex);
+
+	return ret;
 }
 
 /**
@@ -552,11 +595,7 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
  */
 int pinctrl_gpio_direction_input(unsigned gpio)
 {
-	int ret;
-	mutex_lock(&pinctrl_mutex);
-	ret = pinctrl_gpio_direction(gpio, true);
-	mutex_unlock(&pinctrl_mutex);
-	return ret;
+	return pinctrl_gpio_direction(gpio, true);
 }
 EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_input);
 
@@ -570,11 +609,7 @@ EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_input);
  */
 int pinctrl_gpio_direction_output(unsigned gpio)
 {
-	int ret;
-	mutex_lock(&pinctrl_mutex);
-	ret = pinctrl_gpio_direction(gpio, false);
-	mutex_unlock(&pinctrl_mutex);
-	return ret;
+	return pinctrl_gpio_direction(gpio, false);
 }
 EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_output);
 
@@ -717,6 +752,7 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 
 	devname = dev_name(dev);
 
+	mutex_lock(&pinctrl_maps_mutex);
 	/* Iterate over the pin control maps to locate the right ones */
 	for_each_maps(maps_node, i, map) {
 		/* Map must be for this device */
@@ -739,9 +775,12 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 		 */
 		if (ret == -EPROBE_DEFER) {
 			pinctrl_put_locked(p, false);
+			mutex_unlock(&pinctrl_maps_mutex);
 			return ERR_PTR(ret);
 		}
 	}
+	mutex_unlock(&pinctrl_maps_mutex);
+
 	if (ret < 0) {
 		/* If some other error than deferral occured, return here */
 		pinctrl_put_locked(p, false);
@@ -786,9 +825,9 @@ struct pinctrl *pinctrl_get(struct device *dev)
 {
 	struct pinctrl *p;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pinctrl_list_mutex);
 	p = pinctrl_get_locked(dev);
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrl_list_mutex);
 
 	return p;
 }
@@ -836,7 +875,9 @@ static void pinctrl_release(struct kref *kref)
 {
 	struct pinctrl *p = container_of(kref, struct pinctrl, users);
 
+	mutex_lock(&pinctrl_list_mutex);
 	pinctrl_put_locked(p, true);
+	mutex_unlock(&pinctrl_list_mutex);
 }
 
 /**
@@ -845,9 +886,7 @@ static void pinctrl_release(struct kref *kref)
  */
 void pinctrl_put(struct pinctrl *p)
 {
-	mutex_lock(&pinctrl_mutex);
 	kref_put(&p->users, pinctrl_release);
-	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_put);
 
@@ -878,10 +917,20 @@ static struct pinctrl_state *pinctrl_lookup_state_locked(struct pinctrl *p,
 struct pinctrl_state *pinctrl_lookup_state(struct pinctrl *p, const char *name)
 {
 	struct pinctrl_state *s;
+	struct pinctrl_dev *pctldev = get_pinctrl_dev_from_pinctrl(p);
 
-	mutex_lock(&pinctrl_mutex);
-	s = pinctrl_lookup_state_locked(p, name);
-	mutex_unlock(&pinctrl_mutex);
+	/*
+	 * if no pincontroller device is linked to this particular pinctrl,
+	 * that means that the device is not present in any pinmaps, so no
+	 * need to lookup a state.
+	 *
+	 */
+	if (!IS_ERR(pctldev)) {
+		mutex_lock(&pctldev->mutex);
+		s = pinctrl_lookup_state_locked(p, name);
+		mutex_unlock(&pctldev->mutex);
+	} else
+		s = ERR_PTR(-ENODEV);
 
 	return s;
 }
@@ -957,10 +1006,20 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 {
 	int ret;
+	struct pinctrl_dev *pctldev = get_pinctrl_dev_from_pinctrl(p);
 
-	mutex_lock(&pinctrl_mutex);
-	ret = pinctrl_select_state_locked(p, state);
-	mutex_unlock(&pinctrl_mutex);
+	/*
+	 * if no pincontroller device is linked to this particular pinctrl,
+	 * that means that the device is not present in any pinmaps, so no
+	 * need to select a state.
+	 *
+	 */
+	if (!IS_ERR(pctldev)) {
+		mutex_lock(&pctldev->mutex);
+		ret = pinctrl_select_state_locked(p, state);
+		mutex_unlock(&pctldev->mutex);
+	} else
+		ret = -EINVAL;
 
 	return ret;
 }
@@ -1090,10 +1149,10 @@ int pinctrl_register_map(struct pinctrl_map const *maps, unsigned num_maps,
 	}
 
 	if (!locked)
-		mutex_lock(&pinctrl_mutex);
+		mutex_lock(&pinctrl_maps_mutex);
 	list_add_tail(&maps_node->node, &pinctrl_maps);
 	if (!locked)
-		mutex_unlock(&pinctrl_mutex);
+		mutex_unlock(&pinctrl_maps_mutex);
 
 	return 0;
 }
@@ -1115,12 +1174,15 @@ void pinctrl_unregister_map(struct pinctrl_map const *map)
 {
 	struct pinctrl_maps *maps_node;
 
+	mutex_lock(&pinctrl_maps_mutex);
 	list_for_each_entry(maps_node, &pinctrl_maps, node) {
 		if (maps_node->maps == map) {
 			list_del(&maps_node->node);
+			mutex_unlock(&pinctrl_maps_mutex);
 			return;
 		}
 	}
+	mutex_unlock(&pinctrl_maps_mutex);
 }
 
 /**
@@ -1157,7 +1219,7 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 
 	seq_printf(s, "registered pins: %d\n", pctldev->desc->npins);
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
@@ -1179,7 +1241,7 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 		seq_puts(s, "\n");
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -1191,7 +1253,7 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 	unsigned ngroups, selector = 0;
 
 	ngroups = ops->get_groups_count(pctldev);
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	seq_puts(s, "registered pin groups:\n");
 	while (selector < ngroups) {
@@ -1212,7 +1274,7 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 			for (i = 0; i < num_pins; i++) {
 				pname = pin_get_name(pctldev, pins[i]);
 				if (WARN_ON(!pname)) {
-					mutex_unlock(&pinctrl_mutex);
+					mutex_unlock(&pctldev->mutex);
 					return -EINVAL;
 				}
 				seq_printf(s, "pin %d (%s)\n", pins[i], pname);
@@ -1222,7 +1284,7 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 		selector++;
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -1234,7 +1296,7 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "GPIO ranges handled:\n");
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	/* Loop over the ranges */
 	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
@@ -1245,7 +1307,7 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 			   (range->pin_base + range->npins - 1));
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -1256,9 +1318,8 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "name [pinmux] [pinconf]\n");
 
-	mutex_lock(&pinctrl_mutex);
-
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
+		mutex_lock(&pctldev->mutex);
 		seq_printf(s, "%s ", pctldev->desc->name);
 		if (pctldev->desc->pmxops)
 			seq_puts(s, "yes ");
@@ -1269,10 +1330,9 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 		else
 			seq_puts(s, "no");
 		seq_puts(s, "\n");
+		mutex_unlock(&pctldev->mutex);
 	}
 
-	mutex_unlock(&pinctrl_mutex);
-
 	return 0;
 }
 
@@ -1300,8 +1360,7 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "Pinctrl maps:\n");
 
-	mutex_lock(&pinctrl_mutex);
-
+	mutex_lock(&pinctrl_maps_mutex);
 	for_each_maps(maps_node, i, map) {
 		seq_printf(s, "device %s\nstate %s\ntype %s (%d)\n",
 			   map->dev_name, map->name, map_type(map->type),
@@ -1325,8 +1384,7 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 
 		seq_printf(s, "\n");
 	}
-
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrl_maps_mutex);
 
 	return 0;
 }
@@ -1336,22 +1394,32 @@ static int pinctrl_show(struct seq_file *s, void *what)
 	struct pinctrl *p;
 	struct pinctrl_state *state;
 	struct pinctrl_setting *setting;
+	struct pinctrl_dev *pctldev;
 
 	seq_puts(s, "Requested pin control handlers their pinmux maps:\n");
 
-	mutex_lock(&pinctrl_mutex);
-
 	list_for_each_entry(p, &pinctrl_list, node) {
 		seq_printf(s, "device: %s current state: %s\n",
 			   dev_name(p->dev),
 			   p->state ? p->state->name : "none");
 
+		pctldev = get_pinctrl_dev_from_pinctrl(p);
+
+		/*
+		 * if no pincontroller device is linked to this pinctrl, that
+		 * means that the device is not present in any pinmaps, so no
+		 * need to parse the state list.
+		 *
+		 */
+		if (IS_ERR(pctldev))
+			continue;
+
+		mutex_lock(&pctldev->mutex);
+
 		list_for_each_entry(state, &p->states, node) {
 			seq_printf(s, "  state: %s\n", state->name);
 
 			list_for_each_entry(setting, &state->settings, node) {
-				struct pinctrl_dev *pctldev = setting->pctldev;
-
 				seq_printf(s, "    type: %s controller %s ",
 					   map_type(setting->type),
 					   pinctrl_dev_get_name(pctldev));
@@ -1369,10 +1437,9 @@ static int pinctrl_show(struct seq_file *s, void *what)
 				}
 			}
 		}
+		mutex_unlock(&pctldev->mutex);
 	}
 
-	mutex_unlock(&pinctrl_mutex);
-
 	return 0;
 }
 
@@ -1557,6 +1624,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	INIT_RADIX_TREE(&pctldev->pin_desc_tree, GFP_KERNEL);
 	INIT_LIST_HEAD(&pctldev->gpio_ranges);
 	pctldev->dev = dev;
+	mutex_init(&pctldev->mutex);
 
 	/* check core ops for sanity */
 	if (pinctrl_check_ops(pctldev)) {
@@ -1586,7 +1654,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		goto out_err;
 	}
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	list_add_tail(&pctldev->node, &pinctrldev_list);
 
@@ -1611,13 +1679,14 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 			dev_dbg(dev, "failed to lookup the sleep state\n");
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	pinctrl_init_device_debugfs(pctldev);
 
 	return pctldev;
 
 out_err:
+	mutex_destroy(&pctldev->mutex);
 	kfree(pctldev);
 	return NULL;
 }
@@ -1637,7 +1706,7 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 
 	pinctrl_remove_device_debugfs(pctldev);
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	if (!IS_ERR(pctldev->p))
 		pinctrl_put_locked(pctldev->p, true);
@@ -1651,9 +1720,9 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 	list_for_each_entry_safe(range, n, &pctldev->gpio_ranges, node)
 		list_del(&range->node);
 
+	mutex_unlock(&pctldev->mutex);
+	mutex_destroy(&pctldev->mutex);
 	kfree(pctldev);
-
-	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_unregister);
 
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index ee72f1f..80a7bda 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -33,6 +33,7 @@ struct pinctrl_gpio_range;
  * @p: result of pinctrl_get() for this device
  * @hog_default: default state for pins hogged by this device
  * @hog_sleep: sleep state for pins hogged by this device
+ * @mutex: mutex taken on each pin controller specific action
  * @device_root: debugfs root for this device
  */
 struct pinctrl_dev {
@@ -46,6 +47,7 @@ struct pinctrl_dev {
 	struct pinctrl *p;
 	struct pinctrl_state *hog_default;
 	struct pinctrl_state *hog_sleep;
+	struct mutex mutex;
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *device_root;
 #endif
@@ -186,9 +188,9 @@ void pinctrl_unregister_map(struct pinctrl_map const *map);
 extern int pinctrl_force_sleep(struct pinctrl_dev *pctldev);
 extern int pinctrl_force_default(struct pinctrl_dev *pctldev);
 
-extern struct mutex pinctrl_mutex;
 extern struct list_head pinctrldev_list;
 extern struct list_head pinctrl_maps;
+extern struct mutex pinctrl_maps_mutex;
 
 #define for_each_maps(_maps_node_, _i_, _map_) \
 	list_for_each_entry(_maps_node_, &pinctrl_maps, node) \
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 8aefd28..07b7e7b 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -88,14 +88,14 @@ int pin_config_get(const char *dev_name, const char *name,
 	struct pinctrl_dev *pctldev;
 	int pin;
 
-	mutex_lock(&pinctrl_mutex);
-
 	pctldev = get_pinctrl_dev_from_devname(dev_name);
 	if (!pctldev) {
 		pin = -EINVAL;
-		goto unlock;
+		return pin;
 	}
 
+	mutex_lock(&pctldev->mutex);
+
 	pin = pin_get_from_name(pctldev, name);
 	if (pin < 0)
 		goto unlock;
@@ -103,7 +103,7 @@ int pin_config_get(const char *dev_name, const char *name,
 	pin = pin_config_get_for_pin(pctldev, pin, config);
 
 unlock:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 	return pin;
 }
 EXPORT_SYMBOL(pin_config_get);
@@ -144,14 +144,14 @@ int pin_config_set(const char *dev_name, const char *name,
 	struct pinctrl_dev *pctldev;
 	int pin, ret;
 
-	mutex_lock(&pinctrl_mutex);
-
 	pctldev = get_pinctrl_dev_from_devname(dev_name);
 	if (!pctldev) {
 		ret = -EINVAL;
-		goto unlock;
+		return ret;
 	}
 
+	mutex_lock(&pctldev->mutex);
+
 	pin = pin_get_from_name(pctldev, name);
 	if (pin < 0) {
 		ret = pin;
@@ -161,7 +161,7 @@ int pin_config_set(const char *dev_name, const char *name,
 	ret = pin_config_set_for_pin(pctldev, pin, config);
 
 unlock:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL(pin_config_set);
@@ -173,13 +173,14 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
 	const struct pinconf_ops *ops;
 	int selector, ret;
 
-	mutex_lock(&pinctrl_mutex);
-
 	pctldev = get_pinctrl_dev_from_devname(dev_name);
 	if (!pctldev) {
 		ret = -EINVAL;
-		goto unlock;
+		return ret;
 	}
+
+	mutex_lock(&pctldev->mutex);
+
 	ops = pctldev->desc->confops;
 
 	if (!ops || !ops->pin_config_group_get) {
@@ -199,7 +200,7 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
 	ret = ops->pin_config_group_get(pctldev, selector, config);
 
 unlock:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL(pin_config_group_get);
@@ -216,13 +217,14 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 	int ret;
 	int i;
 
-	mutex_lock(&pinctrl_mutex);
-
 	pctldev = get_pinctrl_dev_from_devname(dev_name);
 	if (!pctldev) {
 		ret = -EINVAL;
-		goto unlock;
+		return ret;
 	}
+
+	mutex_lock(&pctldev->mutex);
+
 	ops = pctldev->desc->confops;
 	pctlops = pctldev->desc->pctlops;
 
@@ -278,7 +280,7 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 	ret = 0;
 
 unlock:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return ret;
 }
@@ -486,7 +488,7 @@ static int pinconf_pins_show(struct seq_file *s, void *what)
 	seq_puts(s, "Pin config settings per pin\n");
 	seq_puts(s, "Format: pin (name): configs\n");
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
@@ -506,7 +508,7 @@ static int pinconf_pins_show(struct seq_file *s, void *what)
 		seq_printf(s, "\n");
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -674,7 +676,7 @@ static int pinconf_dbg_config_print(struct seq_file *s, void *d)
 	int i, j;
 	bool found = false;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pinctrl_maps_mutex);
 
 	/* Parse the pinctrl map and look for the elected pin/state */
 	for_each_maps(maps_node, i, map) {
@@ -698,7 +700,7 @@ static int pinconf_dbg_config_print(struct seq_file *s, void *d)
 		}
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrl_maps_mutex);
 
 	if (found) {
 		seq_printf(s, "Config of %s in state %s: 0x%08X\n", dbg_pinname,
@@ -743,7 +745,7 @@ static int pinconf_dbg_config_write(struct file *file,
 
 	dbg_config = config;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pinctrl_maps_mutex);
 
 	/* Parse the pinctrl map and look for the selected pin/state */
 	for_each_maps(maps_node, i, map) {
@@ -761,7 +763,7 @@ static int pinconf_dbg_config_write(struct file *file,
 		}
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrl_maps_mutex);
 
 	return count;
 }
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 1a00658..2319b6d 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -501,7 +501,7 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 	if (!pmxops)
 		return 0;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 	nfuncs = pmxops->get_functions_count(pctldev);
 	while (func_selector < nfuncs) {
 		const char *func = pmxops->get_function_name(pctldev,
@@ -525,7 +525,7 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 		func_selector++;
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -543,7 +543,7 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 	seq_puts(s, "Pinmux settings per pin\n");
 	seq_puts(s, "Format: pin (name): mux_owner gpio_owner hog?\n");
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
@@ -578,7 +578,7 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 			seq_printf(s, "\n");
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
-- 
1.7.11.3

