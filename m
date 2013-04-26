Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3DZPIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:08:45 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:46150 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755276Ab3DZPIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:08:43 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3] pinctrl: move subsystem mutex to pinctrl_dev struct
Date: Fri, 26 Apr 2013 17:08:27 +0200
Message-ID: <1366988907-13485-1-git-send-email-linus.walleij@stericsson.com>
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

For several cases, we can't replace pinctrl_mutex by
pctldev->mutex, because at this stage, pctldev is
not accessible :
	- pinctrl_get()/pinctrl_put()
	- pinctrl_register_maps()

So add respectively pinctrl_list_mutex and
pinctrl_maps_mutex in order to protect
pinctrl_list and pinctrl_maps list instead.

Reintroduce pinctrldev_list_mutex in
find_pinctrl_by_of_node(),
pinctrl_find_and_add_gpio_range()
pinctrl_request_gpio(), pinctrl_free_gpio(),
pinctrl_gpio_direction(), pinctrl_devices_show(),
pinctrl_register() and pinctrl_unregister() to
protect pinctrldev_list.

Changes v2->v3:
- Fix a missing EXPORT_SYMBOL_GPL() for pinctrl_select_state().

Changes v1->v2:
- pinctrl_select_state_locked() is removed, all lock mechanism
  is located inside pinctrl_select_state(). When parsing
  the state->setting list, take the per-pin-controller driver
  lock. (Patrice).
- Introduce pinctrldev_list_mutex to protect pinctrldev_list
  in all functions which parse or modify pictrldev_list.
  (Patrice).
- move find_pinctrl_by_of_node() from pinctrl/devicetree.c to
  pinctrl/core.c in order to protect pinctrldev_list.
  (Patrice).
- Sink mutex:es into some functions and remove some _locked
  variants down to where the lists are actually accessed to
  make things simpler. (Linus)
- Drop *all* mutexes completely from pinctrl_lookup_state()
  and pinctrl_select_state() - no relevant mutex was taken
  and it was unclear what this was protecting against. (Linus)

Reported by : Seraphin Bonnaffe <seraphin.bonnaffe@stericsson.com>
Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c       | 265 +++++++++++++++++++++++--------------------
 drivers/pinctrl/core.h       |   6 +-
 drivers/pinctrl/devicetree.c |  15 +--
 drivers/pinctrl/pinconf.c    |  46 ++++----
 drivers/pinctrl/pinmux.c     |   8 +-
 5 files changed, 176 insertions(+), 164 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 8b832ce..c3d222e 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -40,11 +40,17 @@
 
 static bool pinctrl_dummy_state;
 
-/* Mutex taken by all entry points */
-DEFINE_MUTEX(pinctrl_mutex);
+/* Mutex taken to protect pinctrl_list */
+DEFINE_MUTEX(pinctrl_list_mutex);
+
+/* Mutex taken to protect pinctrl_maps */
+DEFINE_MUTEX(pinctrl_maps_mutex);
+
+/* Mutex taken to protect pinctrldev_list */
+DEFINE_MUTEX(pinctrldev_list_mutex);
 
 /* Global list of pin control devices (struct pinctrl_dev) */
-LIST_HEAD(pinctrldev_list);
+static LIST_HEAD(pinctrldev_list);
 
 /* List of pin controller handles (struct pinctrl) */
 static LIST_HEAD(pinctrl_list);
@@ -111,6 +117,23 @@ struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *devname)
 	return found ? pctldev : NULL;
 }
 
+struct pinctrl_dev *get_pinctrl_dev_from_of_node(struct device_node *np)
+{
+	struct pinctrl_dev *pctldev;
+
+	mutex_lock(&pinctrldev_list_mutex);
+
+	list_for_each_entry(pctldev, &pinctrldev_list, node)
+		if (pctldev->dev->of_node == np) {
+			mutex_unlock(&pinctrldev_list_mutex);
+			return pctldev;
+		}
+
+	mutex_lock(&pinctrldev_list_mutex);
+
+	return NULL;
+}
+
 /**
  * pin_get_from_name() - look up a pin number from a name
  * @pctldev: the pin control device to lookup the pin on
@@ -170,9 +193,9 @@ bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
 	if (pin < 0)
 		return false;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 	pindesc = pin_desc_get(pctldev, pin);
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return pindesc != NULL;
 }
@@ -269,15 +292,17 @@ pinctrl_match_gpio_range(struct pinctrl_dev *pctldev, unsigned gpio)
 {
 	struct pinctrl_gpio_range *range = NULL;
 
+	mutex_lock(&pctldev->mutex);
 	/* Loop over the ranges */
 	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
 		/* Check if we're in the valid range */
 		if (gpio >= range->base &&
 		    gpio < range->base + range->npins) {
+			mutex_unlock(&pctldev->mutex);
 			return range;
 		}
 	}
-
+	mutex_unlock(&pctldev->mutex);
 	return NULL;
 }
 
@@ -361,9 +386,9 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
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
 
@@ -381,17 +406,25 @@ EXPORT_SYMBOL_GPL(pinctrl_add_gpio_ranges);
 struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 		struct pinctrl_gpio_range *range)
 {
-	struct pinctrl_dev *pctldev = get_pinctrl_dev_from_devname(devname);
+	struct pinctrl_dev *pctldev;
+
+	mutex_lock(&pinctrldev_list_mutex);
+
+	pctldev = get_pinctrl_dev_from_devname(devname);
 
 	/*
 	 * If we can't find this device, let's assume that is because
 	 * it has not probed yet, so the driver trying to register this
 	 * range need to defer probing.
 	 */
-	if (!pctldev)
+	if (!pctldev) {
+		mutex_unlock(&pinctrldev_list_mutex);
 		return ERR_PTR(-EPROBE_DEFER);
-
+	}
 	pinctrl_add_gpio_range(pctldev, range);
+
+	mutex_unlock(&pinctrldev_list_mutex);
+
 	return pctldev;
 }
 EXPORT_SYMBOL_GPL(pinctrl_find_and_add_gpio_range);
@@ -407,14 +440,17 @@ pinctrl_find_gpio_range_from_pin(struct pinctrl_dev *pctldev,
 {
 	struct pinctrl_gpio_range *range = NULL;
 
+	mutex_lock(&pctldev->mutex);
 	/* Loop over the ranges */
 	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
 		/* Check if we're in the valid range */
 		if (pin >= range->pin_base &&
 		    pin < range->pin_base + range->npins) {
+			mutex_unlock(&pctldev->mutex);
 			return range;
 		}
 	}
+	mutex_unlock(&pctldev->mutex);
 
 	return NULL;
 }
@@ -428,9 +464,9 @@ EXPORT_SYMBOL_GPL(pinctrl_find_gpio_range_from_pin);
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
 
@@ -481,13 +517,13 @@ int pinctrl_request_gpio(unsigned gpio)
 	int ret;
 	int pin;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pinctrldev_list_mutex);
 
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
 		if (pinctrl_ready_for_gpio_range(gpio))
 			ret = 0;
-		mutex_unlock(&pinctrl_mutex);
+		mutex_unlock(&pinctrldev_list_mutex);
 		return ret;
 	}
 
@@ -496,7 +532,7 @@ int pinctrl_request_gpio(unsigned gpio)
 
 	ret = pinmux_request_gpio(pctldev, range, pin, gpio);
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrldev_list_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pinctrl_request_gpio);
@@ -516,20 +552,22 @@ void pinctrl_free_gpio(unsigned gpio)
 	int ret;
 	int pin;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pinctrldev_list_mutex);
 
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
-		mutex_unlock(&pinctrl_mutex);
+		mutex_unlock(&pinctrldev_list_mutex);
 		return;
 	}
+	mutex_lock(&pctldev->mutex);
 
 	/* Convert to the pin controllers number space */
 	pin = gpio - range->base + range->pin_base;
 
 	pinmux_free_gpio(pctldev, pin, range);
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
+	mutex_unlock(&pinctrldev_list_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_free_gpio);
 
@@ -540,14 +578,24 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
 	int ret;
 	int pin;
 
+	mutex_lock(&pinctrldev_list_mutex);
+
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&pinctrldev_list_mutex);
 		return ret;
+	}
+
+	mutex_lock(&pctldev->mutex);
 
 	/* Convert to the pin controllers number space */
 	pin = gpio - range->base + range->pin_base;
+	ret = pinmux_gpio_direction(pctldev, range, pin, input);
+
+	mutex_unlock(&pctldev->mutex);
+	mutex_unlock(&pinctrldev_list_mutex);
 
-	return pinmux_gpio_direction(pctldev, range, pin, input);
+	return ret;
 }
 
 /**
@@ -560,11 +608,7 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
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
 
@@ -578,11 +622,7 @@ EXPORT_SYMBOL_GPL(pinctrl_gpio_direction_input);
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
 
@@ -685,14 +725,18 @@ static struct pinctrl *find_pinctrl(struct device *dev)
 {
 	struct pinctrl *p;
 
+	mutex_lock(&pinctrl_list_mutex);
 	list_for_each_entry(p, &pinctrl_list, node)
-		if (p->dev == dev)
+		if (p->dev == dev) {
+			mutex_unlock(&pinctrl_list_mutex);
 			return p;
+		}
 
+	mutex_unlock(&pinctrl_list_mutex);
 	return NULL;
 }
 
-static void pinctrl_put_locked(struct pinctrl *p, bool inlist);
+static void pinctrl_free(struct pinctrl *p, bool inlist);
 
 static struct pinctrl *create_pinctrl(struct device *dev)
 {
@@ -725,6 +769,7 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 
 	devname = dev_name(dev);
 
+	mutex_lock(&pinctrl_maps_mutex);
 	/* Iterate over the pin control maps to locate the right ones */
 	for_each_maps(maps_node, i, map) {
 		/* Map must be for this device */
@@ -746,13 +791,16 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 		 * an -EPROBE_DEFER later, as that is the worst case.
 		 */
 		if (ret == -EPROBE_DEFER) {
-			pinctrl_put_locked(p, false);
+			pinctrl_free(p, false);
+			mutex_unlock(&pinctrl_maps_mutex);
 			return ERR_PTR(ret);
 		}
 	}
+	mutex_unlock(&pinctrl_maps_mutex);
+
 	if (ret < 0) {
 		/* If some other error than deferral occured, return here */
-		pinctrl_put_locked(p, false);
+		pinctrl_free(p, false);
 		return ERR_PTR(ret);
 	}
 
@@ -764,7 +812,11 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 	return p;
 }
 
-static struct pinctrl *pinctrl_get_locked(struct device *dev)
+/**
+ * pinctrl_get() - retrieves the pinctrl handle for a device
+ * @dev: the device to obtain the handle for
+ */
+struct pinctrl *pinctrl_get(struct device *dev)
 {
 	struct pinctrl *p;
 
@@ -785,21 +837,6 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev)
 
 	return create_pinctrl(dev);
 }
-
-/**
- * pinctrl_get() - retrieves the pinctrl handle for a device
- * @dev: the device to obtain the handle for
- */
-struct pinctrl *pinctrl_get(struct device *dev)
-{
-	struct pinctrl *p;
-
-	mutex_lock(&pinctrl_mutex);
-	p = pinctrl_get_locked(dev);
-	mutex_unlock(&pinctrl_mutex);
-
-	return p;
-}
 EXPORT_SYMBOL_GPL(pinctrl_get);
 
 static void pinctrl_free_setting(bool disable_setting,
@@ -820,11 +857,12 @@ static void pinctrl_free_setting(bool disable_setting,
 	}
 }
 
-static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
+static void pinctrl_free(struct pinctrl *p, bool inlist)
 {
 	struct pinctrl_state *state, *n1;
 	struct pinctrl_setting *setting, *n2;
 
+	mutex_lock(&pinctrl_list_mutex);
 	list_for_each_entry_safe(state, n1, &p->states, node) {
 		list_for_each_entry_safe(setting, n2, &state->settings, node) {
 			pinctrl_free_setting(state == p->state, setting);
@@ -840,6 +878,7 @@ static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
 	if (inlist)
 		list_del(&p->node);
 	kfree(p);
+	mutex_unlock(&pinctrl_list_mutex);
 }
 
 /**
@@ -850,7 +889,7 @@ static void pinctrl_release(struct kref *kref)
 {
 	struct pinctrl *p = container_of(kref, struct pinctrl, users);
 
-	pinctrl_put_locked(p, true);
+	pinctrl_free(p, true);
 }
 
 /**
@@ -859,14 +898,17 @@ static void pinctrl_release(struct kref *kref)
  */
 void pinctrl_put(struct pinctrl *p)
 {
-	mutex_lock(&pinctrl_mutex);
 	kref_put(&p->users, pinctrl_release);
-	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_put);
 
-static struct pinctrl_state *pinctrl_lookup_state_locked(struct pinctrl *p,
-							 const char *name)
+/**
+ * pinctrl_lookup_state() - retrieves a state handle from a pinctrl handle
+ * @p: the pinctrl handle to retrieve the state from
+ * @name: the state name to retrieve
+ */
+struct pinctrl_state *pinctrl_lookup_state(struct pinctrl *p,
+						 const char *name)
 {
 	struct pinctrl_state *state;
 
@@ -883,26 +925,14 @@ static struct pinctrl_state *pinctrl_lookup_state_locked(struct pinctrl *p,
 
 	return state;
 }
+EXPORT_SYMBOL_GPL(pinctrl_lookup_state);
 
 /**
- * pinctrl_lookup_state() - retrieves a state handle from a pinctrl handle
- * @p: the pinctrl handle to retrieve the state from
- * @name: the state name to retrieve
+ * pinctrl_select_state() - select/activate/program a pinctrl state to HW
+ * @p: the pinctrl handle for the device that requests configuration
+ * @state: the state handle to select/activate/program
  */
-struct pinctrl_state *pinctrl_lookup_state(struct pinctrl *p, const char *name)
-{
-	struct pinctrl_state *s;
-
-	mutex_lock(&pinctrl_mutex);
-	s = pinctrl_lookup_state_locked(p, name);
-	mutex_unlock(&pinctrl_mutex);
-
-	return s;
-}
-EXPORT_SYMBOL_GPL(pinctrl_lookup_state);
-
-static int pinctrl_select_state_locked(struct pinctrl *p,
-				       struct pinctrl_state *state)
+int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
 {
 	struct pinctrl_setting *setting, *setting2;
 	struct pinctrl_state *old_state = p->state;
@@ -956,8 +986,9 @@ static int pinctrl_select_state_locked(struct pinctrl *p,
 			break;
 		}
 
-		if (ret < 0)
+		if (ret < 0) {
 			goto unapply_new_state;
+		}
 	}
 
 	p->state = state;
@@ -983,23 +1014,7 @@ unapply_new_state:
 
 	/* There's no infinite recursive loop here because p->state is NULL */
 	if (old_state)
-		pinctrl_select_state_locked(p, old_state);
-
-	return ret;
-}
-
-/**
- * pinctrl_select() - select/activate/program a pinctrl state to HW
- * @p: the pinctrl handle for the device that requests configuratio
- * @state: the state handle to select/activate/program
- */
-int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
-{
-	int ret;
-
-	mutex_lock(&pinctrl_mutex);
-	ret = pinctrl_select_state_locked(p, state);
-	mutex_unlock(&pinctrl_mutex);
+		pinctrl_select_state(p, old_state);
 
 	return ret;
 }
@@ -1129,10 +1144,10 @@ int pinctrl_register_map(struct pinctrl_map const *maps, unsigned num_maps,
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
@@ -1154,12 +1169,15 @@ void pinctrl_unregister_map(struct pinctrl_map const *map)
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
@@ -1196,7 +1214,7 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 
 	seq_printf(s, "registered pins: %d\n", pctldev->desc->npins);
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
@@ -1218,7 +1236,7 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 		seq_puts(s, "\n");
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -1229,8 +1247,9 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 	const struct pinctrl_ops *ops = pctldev->desc->pctlops;
 	unsigned ngroups, selector = 0;
 
+	mutex_lock(&pctldev->mutex);
+
 	ngroups = ops->get_groups_count(pctldev);
-	mutex_lock(&pinctrl_mutex);
 
 	seq_puts(s, "registered pin groups:\n");
 	while (selector < ngroups) {
@@ -1251,7 +1270,7 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 			for (i = 0; i < num_pins; i++) {
 				pname = pin_get_name(pctldev, pins[i]);
 				if (WARN_ON(!pname)) {
-					mutex_unlock(&pinctrl_mutex);
+					mutex_unlock(&pctldev->mutex);
 					return -EINVAL;
 				}
 				seq_printf(s, "pin %d (%s)\n", pins[i], pname);
@@ -1261,7 +1280,7 @@ static int pinctrl_groups_show(struct seq_file *s, void *what)
 		selector++;
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -1273,7 +1292,7 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "GPIO ranges handled:\n");
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	/* Loop over the ranges */
 	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
@@ -1284,7 +1303,7 @@ static int pinctrl_gpioranges_show(struct seq_file *s, void *what)
 			   (range->pin_base + range->npins - 1));
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -1295,7 +1314,7 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "name [pinmux] [pinconf]\n");
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pinctrldev_list_mutex);
 
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
 		seq_printf(s, "%s ", pctldev->desc->name);
@@ -1310,7 +1329,7 @@ static int pinctrl_devices_show(struct seq_file *s, void *what)
 		seq_puts(s, "\n");
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrldev_list_mutex);
 
 	return 0;
 }
@@ -1339,8 +1358,7 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "Pinctrl maps:\n");
 
-	mutex_lock(&pinctrl_mutex);
-
+	mutex_lock(&pinctrl_maps_mutex);
 	for_each_maps(maps_node, i, map) {
 		seq_printf(s, "device %s\nstate %s\ntype %s (%d)\n",
 			   map->dev_name, map->name, map_type(map->type),
@@ -1364,8 +1382,7 @@ static int pinctrl_maps_show(struct seq_file *s, void *what)
 
 		seq_printf(s, "\n");
 	}
-
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrl_maps_mutex);
 
 	return 0;
 }
@@ -1378,7 +1395,7 @@ static int pinctrl_show(struct seq_file *s, void *what)
 
 	seq_puts(s, "Requested pin control handlers their pinmux maps:\n");
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pinctrl_list_mutex);
 
 	list_for_each_entry(p, &pinctrl_list, node) {
 		seq_printf(s, "device: %s current state: %s\n",
@@ -1410,7 +1427,7 @@ static int pinctrl_show(struct seq_file *s, void *what)
 		}
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrl_list_mutex);
 
 	return 0;
 }
@@ -1596,6 +1613,7 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	INIT_RADIX_TREE(&pctldev->pin_desc_tree, GFP_KERNEL);
 	INIT_LIST_HEAD(&pctldev->gpio_ranges);
 	pctldev->dev = dev;
+	mutex_init(&pctldev->mutex);
 
 	/* check core ops for sanity */
 	if (pinctrl_check_ops(pctldev)) {
@@ -1625,38 +1643,37 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 		goto out_err;
 	}
 
-	mutex_lock(&pinctrl_mutex);
-
+	mutex_lock(&pinctrldev_list_mutex);
 	list_add_tail(&pctldev->node, &pinctrldev_list);
+	mutex_unlock(&pinctrldev_list_mutex);
+
+	pctldev->p = pinctrl_get(pctldev->dev);
 
-	pctldev->p = pinctrl_get_locked(pctldev->dev);
 	if (!IS_ERR(pctldev->p)) {
 		pctldev->hog_default =
-			pinctrl_lookup_state_locked(pctldev->p,
-						    PINCTRL_STATE_DEFAULT);
+			pinctrl_lookup_state(pctldev->p, PINCTRL_STATE_DEFAULT);
 		if (IS_ERR(pctldev->hog_default)) {
 			dev_dbg(dev, "failed to lookup the default state\n");
 		} else {
-			if (pinctrl_select_state_locked(pctldev->p,
+			if (pinctrl_select_state(pctldev->p,
 						pctldev->hog_default))
 				dev_err(dev,
 					"failed to select default state\n");
 		}
 
 		pctldev->hog_sleep =
-			pinctrl_lookup_state_locked(pctldev->p,
+			pinctrl_lookup_state(pctldev->p,
 						    PINCTRL_STATE_SLEEP);
 		if (IS_ERR(pctldev->hog_sleep))
 			dev_dbg(dev, "failed to lookup the sleep state\n");
 	}
 
-	mutex_unlock(&pinctrl_mutex);
-
 	pinctrl_init_device_debugfs(pctldev);
 
 	return pctldev;
 
 out_err:
+	mutex_destroy(&pctldev->mutex);
 	kfree(pctldev);
 	return NULL;
 }
@@ -1674,12 +1691,13 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 	if (pctldev == NULL)
 		return;
 
-	pinctrl_remove_device_debugfs(pctldev);
+	mutex_lock(&pinctrldev_list_mutex);
+	mutex_lock(&pctldev->mutex);
 
-	mutex_lock(&pinctrl_mutex);
+	pinctrl_remove_device_debugfs(pctldev);
 
 	if (!IS_ERR(pctldev->p))
-		pinctrl_put_locked(pctldev->p, true);
+		pinctrl_put(pctldev->p);
 
 	/* TODO: check that no pinmuxes are still active? */
 	list_del(&pctldev->node);
@@ -1690,9 +1708,10 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 	list_for_each_entry_safe(range, n, &pctldev->gpio_ranges, node)
 		list_del(&range->node);
 
+	mutex_unlock(&pctldev->mutex);
+	mutex_destroy(&pctldev->mutex);
 	kfree(pctldev);
-
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrldev_list_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_unregister);
 
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 6d3d400..75476b3 100644
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
@@ -168,6 +170,7 @@ struct pinctrl_maps {
 };
 
 struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *dev_name);
+struct pinctrl_dev *get_pinctrl_dev_from_of_node(struct device_node *np);
 int pin_get_from_name(struct pinctrl_dev *pctldev, const char *name);
 const char *pin_get_name(struct pinctrl_dev *pctldev, const unsigned pin);
 int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
@@ -186,8 +189,7 @@ void pinctrl_unregister_map(struct pinctrl_map const *map);
 extern int pinctrl_force_sleep(struct pinctrl_dev *pctldev);
 extern int pinctrl_force_default(struct pinctrl_dev *pctldev);
 
-extern struct mutex pinctrl_mutex;
-extern struct list_head pinctrldev_list;
+extern struct mutex pinctrl_maps_mutex;
 extern struct list_head pinctrl_maps;
 
 #define for_each_maps(_maps_node_, _i_, _map_) \
diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index c7b7cb4..340fb4e 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -95,22 +95,11 @@ static int dt_remember_or_free_map(struct pinctrl *p, const char *statename,
 	return pinctrl_register_map(map, num_maps, false, true);
 }
 
-static struct pinctrl_dev *find_pinctrl_by_of_node(struct device_node *np)
-{
-	struct pinctrl_dev *pctldev;
-
-	list_for_each_entry(pctldev, &pinctrldev_list, node)
-		if (pctldev->dev->of_node == np)
-			return pctldev;
-
-	return NULL;
-}
-
 struct pinctrl_dev *of_pinctrl_get(struct device_node *np)
 {
 	struct pinctrl_dev *pctldev;
 
-	pctldev = find_pinctrl_by_of_node(np);
+	pctldev = get_pinctrl_dev_from_of_node(np);
 	if (!pctldev)
 		return NULL;
 
@@ -138,7 +127,7 @@ static int dt_to_map_one_config(struct pinctrl *p, const char *statename,
 			/* OK let's just assume this will appear later then */
 			return -EPROBE_DEFER;
 		}
-		pctldev = find_pinctrl_by_of_node(np_pctldev);
+		pctldev = get_pinctrl_dev_from_of_node(np_pctldev);
 		if (pctldev)
 			break;
 		/* Do not defer probing of hogs (circular loop) */
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 32f9680..c67c37e 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -89,14 +89,14 @@ int pin_config_get(const char *dev_name, const char *name,
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
@@ -104,7 +104,7 @@ int pin_config_get(const char *dev_name, const char *name,
 	pin = pin_config_get_for_pin(pctldev, pin, config);
 
 unlock:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 	return pin;
 }
 EXPORT_SYMBOL(pin_config_get);
@@ -145,14 +145,14 @@ int pin_config_set(const char *dev_name, const char *name,
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
@@ -162,7 +162,7 @@ int pin_config_set(const char *dev_name, const char *name,
 	ret = pin_config_set_for_pin(pctldev, pin, config);
 
 unlock:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL(pin_config_set);
@@ -174,13 +174,14 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
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
@@ -200,7 +201,7 @@ int pin_config_group_get(const char *dev_name, const char *pin_group,
 	ret = ops->pin_config_group_get(pctldev, selector, config);
 
 unlock:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL(pin_config_group_get);
@@ -217,13 +218,14 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
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
 
@@ -279,7 +281,7 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 	ret = 0;
 
 unlock:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return ret;
 }
@@ -487,7 +489,7 @@ static int pinconf_pins_show(struct seq_file *s, void *what)
 	seq_puts(s, "Pin config settings per pin\n");
 	seq_puts(s, "Format: pin (name): configs\n");
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
@@ -507,7 +509,7 @@ static int pinconf_pins_show(struct seq_file *s, void *what)
 		seq_printf(s, "\n");
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -608,7 +610,7 @@ static int pinconf_dbg_config_print(struct seq_file *s, void *d)
 	bool found = false;
 	unsigned long config;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	/* Parse the pinctrl map and look for the elected pin/state */
 	for_each_maps(maps_node, i, map) {
@@ -657,7 +659,7 @@ static int pinconf_dbg_config_print(struct seq_file *s, void *d)
 		confops->pin_config_config_dbg_show(pctldev, s, config);
 
 exit:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -747,7 +749,7 @@ static int pinconf_dbg_config_write(struct file *file,
 		return -EINVAL;
 	strncpy(config, token, MAX_NAME_LEN);
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pinctrl_maps_mutex);
 
 	/* Parse the pinctrl map and look for the selected dev/state/pin */
 	for_each_maps(maps_node, i, map) {
@@ -785,7 +787,7 @@ static int pinconf_dbg_config_write(struct file *file,
 	}
 
 exit:
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pinctrl_maps_mutex);
 
 	return count;
 }
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index bd83c8b..88cc509 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -506,7 +506,7 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 	if (!pmxops)
 		return 0;
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 	nfuncs = pmxops->get_functions_count(pctldev);
 	while (func_selector < nfuncs) {
 		const char *func = pmxops->get_function_name(pctldev,
@@ -530,7 +530,7 @@ static int pinmux_functions_show(struct seq_file *s, void *what)
 		func_selector++;
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
@@ -548,7 +548,7 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 	seq_puts(s, "Pinmux settings per pin\n");
 	seq_puts(s, "Format: pin (name): mux_owner gpio_owner hog?\n");
 
-	mutex_lock(&pinctrl_mutex);
+	mutex_lock(&pctldev->mutex);
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
@@ -583,7 +583,7 @@ static int pinmux_pins_show(struct seq_file *s, void *what)
 			seq_printf(s, "\n");
 	}
 
-	mutex_unlock(&pinctrl_mutex);
+	mutex_unlock(&pctldev->mutex);
 
 	return 0;
 }
-- 
1.7.11.3

