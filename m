Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab3FXNQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:16:03 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:37855 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab3FXNQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:16:01 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: rip out the direct pinconf API
Date: Mon, 24 Jun 2013 15:15:00 +0200
Message-ID: <1372079700-16580-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

>From the inception ot the pin config API there has been the
possibility to get a handle at a pin directly and configure
its electrical characteristics. For this reason we had:

int pin_config_get(const char *dev_name, const char *name,
               unsigned long *config);
int pin_config_set(const char *dev_name, const char *name,
               unsigned long config);
int pin_config_group_get(const char *dev_name,
               const char *pin_group,
               unsigned long *config);
int pin_config_group_set(const char *dev_name,
               const char *pin_group,
               unsigned long config);

After the intruction of the pin control states that will
control pins associated with devices, and its subsequent
introduction to the device core, as well as the
introduction of pin control hogs that can set up states on
boot and optionally also at sleep, this direct pin control
API is a thing of the past.

As could be expected, it has zero in-kernel users.
Let's delete this API and make our world simpler.

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt        |  11 +--
 drivers/pinctrl/pinconf.c        | 174 ---------------------------------------
 include/linux/pinctrl/consumer.h |  43 ----------
 3 files changed, 2 insertions(+), 226 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 3ee2475..c5948c7 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -203,15 +203,8 @@ using a certain resistor value - pull up and pull down - so that the pin has a
 stable value when nothing is driving the rail it is connected to, or when it's
 unconnected.
 
-Pin configuration can be programmed either using the explicit APIs described
-immediately below, or by adding configuration entries into the mapping table;
-see section "Board/machine configuration" below.
-
-For example, a platform may do the following to pull up a pin to VDD:
-
-#include <linux/pinctrl/consumer.h>
-
-ret = pin_config_set("foo-dev", "FOO_GPIO_PIN", PLATFORM_X_PULL_UP);
+Pin configuration can be programmed by adding configuration entries into the
+mapping table; see section "Board/machine configuration" below.
 
 The format and meaning of the configuration parameter, PLATFORM_X_PULL_UP
 above, is entirely defined by the pin controller driver.
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 694c3ac..e875f21 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -75,98 +75,6 @@ int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
 	return ops->pin_config_get(pctldev, pin, config);
 }
 
-/**
- * pin_config_get() - get the configuration of a single pin parameter
- * @dev_name: name of the pin controller device for this pin
- * @name: name of the pin to get the config for
- * @config: the config pointed to by this argument will be filled in with the
- *	current pin state, it can be used directly by drivers as a numeral, or
- *	it can be dereferenced to any struct.
- */
-int pin_config_get(const char *dev_name, const char *name,
-			  unsigned long *config)
-{
-	struct pinctrl_dev *pctldev;
-	int pin;
-
-	pctldev = get_pinctrl_dev_from_devname(dev_name);
-	if (!pctldev) {
-		pin = -EINVAL;
-		return pin;
-	}
-
-	mutex_lock(&pctldev->mutex);
-
-	pin = pin_get_from_name(pctldev, name);
-	if (pin < 0)
-		goto unlock;
-
-	pin = pin_config_get_for_pin(pctldev, pin, config);
-
-unlock:
-	mutex_unlock(&pctldev->mutex);
-	return pin;
-}
-EXPORT_SYMBOL(pin_config_get);
-
-static int pin_config_set_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
-			   unsigned long config)
-{
-	const struct pinconf_ops *ops = pctldev->desc->confops;
-	int ret;
-
-	if (!ops || !ops->pin_config_set) {
-		dev_err(pctldev->dev, "cannot configure pin, missing "
-			"config function in driver\n");
-		return -EINVAL;
-	}
-
-	ret = ops->pin_config_set(pctldev, pin, config);
-	if (ret) {
-		dev_err(pctldev->dev,
-			"unable to set pin configuration on pin %d\n", pin);
-		return ret;
-	}
-
-	return 0;
-}
-
-/**
- * pin_config_set() - set the configuration of a single pin parameter
- * @dev_name: name of pin controller device for this pin
- * @name: name of the pin to set the config for
- * @config: the config in this argument will contain the desired pin state, it
- *	can be used directly by drivers as a numeral, or it can be dereferenced
- *	to any struct.
- */
-int pin_config_set(const char *dev_name, const char *name,
-		   unsigned long config)
-{
-	struct pinctrl_dev *pctldev;
-	int pin, ret;
-
-	pctldev = get_pinctrl_dev_from_devname(dev_name);
-	if (!pctldev) {
-		ret = -EINVAL;
-		return ret;
-	}
-
-	mutex_lock(&pctldev->mutex);
-
-	pin = pin_get_from_name(pctldev, name);
-	if (pin < 0) {
-		ret = pin;
-		goto unlock;
-	}
-
-	ret = pin_config_set_for_pin(pctldev, pin, config);
-
-unlock:
-	mutex_unlock(&pctldev->mutex);
-	return ret;
-}
-EXPORT_SYMBOL(pin_config_set);
-
 int pin_config_group_get(const char *dev_name, const char *pin_group,
 			 unsigned long *config)
 {
@@ -204,88 +112,6 @@ unlock:
 	mutex_unlock(&pctldev->mutex);
 	return ret;
 }
-EXPORT_SYMBOL(pin_config_group_get);
-
-int pin_config_group_set(const char *dev_name, const char *pin_group,
-			 unsigned long config)
-{
-	struct pinctrl_dev *pctldev;
-	const struct pinconf_ops *ops;
-	const struct pinctrl_ops *pctlops;
-	int selector;
-	const unsigned *pins;
-	unsigned num_pins;
-	int ret;
-	int i;
-
-	pctldev = get_pinctrl_dev_from_devname(dev_name);
-	if (!pctldev) {
-		ret = -EINVAL;
-		return ret;
-	}
-
-	mutex_lock(&pctldev->mutex);
-
-	ops = pctldev->desc->confops;
-	pctlops = pctldev->desc->pctlops;
-
-	if (!ops || (!ops->pin_config_group_set && !ops->pin_config_set)) {
-		dev_err(pctldev->dev, "cannot configure pin group, missing "
-			"config function in driver\n");
-		ret = -EINVAL;
-		goto unlock;
-	}
-
-	selector = pinctrl_get_group_selector(pctldev, pin_group);
-	if (selector < 0) {
-		ret = selector;
-		goto unlock;
-	}
-
-	ret = pctlops->get_group_pins(pctldev, selector, &pins, &num_pins);
-	if (ret) {
-		dev_err(pctldev->dev, "cannot configure pin group, error "
-			"getting pins\n");
-		goto unlock;
-	}
-
-	/*
-	 * If the pin controller supports handling entire groups we use that
-	 * capability.
-	 */
-	if (ops->pin_config_group_set) {
-		ret = ops->pin_config_group_set(pctldev, selector, config);
-		/*
-		 * If the pin controller prefer that a certain group be handled
-		 * pin-by-pin as well, it returns -EAGAIN.
-		 */
-		if (ret != -EAGAIN)
-			goto unlock;
-	}
-
-	/*
-	 * If the controller cannot handle entire groups, we configure each pin
-	 * individually.
-	 */
-	if (!ops->pin_config_set) {
-		ret = 0;
-		goto unlock;
-	}
-
-	for (i = 0; i < num_pins; i++) {
-		ret = ops->pin_config_set(pctldev, pins[i], config);
-		if (ret < 0)
-			goto unlock;
-	}
-
-	ret = 0;
-
-unlock:
-	mutex_unlock(&pctldev->mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL(pin_config_group_set);
 
 int pinconf_map_to_setting(struct pinctrl_map const *map,
 			  struct pinctrl_setting *setting)
diff --git a/include/linux/pinctrl/consumer.h b/include/linux/pinctrl/consumer.h
index d071d85..18eccef 100644
--- a/include/linux/pinctrl/consumer.h
+++ b/include/linux/pinctrl/consumer.h
@@ -192,47 +192,4 @@ static inline struct pinctrl * __must_check devm_pinctrl_get_select_default(
 	return devm_pinctrl_get_select(dev, PINCTRL_STATE_DEFAULT);
 }
 
-#ifdef CONFIG_PINCONF
-
-extern int pin_config_get(const char *dev_name, const char *name,
-			  unsigned long *config);
-extern int pin_config_set(const char *dev_name, const char *name,
-			  unsigned long config);
-extern int pin_config_group_get(const char *dev_name,
-				const char *pin_group,
-				unsigned long *config);
-extern int pin_config_group_set(const char *dev_name,
-				const char *pin_group,
-				unsigned long config);
-
-#else
-
-static inline int pin_config_get(const char *dev_name, const char *name,
-				 unsigned long *config)
-{
-	return 0;
-}
-
-static inline int pin_config_set(const char *dev_name, const char *name,
-				 unsigned long config)
-{
-	return 0;
-}
-
-static inline int pin_config_group_get(const char *dev_name,
-				       const char *pin_group,
-				       unsigned long *config)
-{
-	return 0;
-}
-
-static inline int pin_config_group_set(const char *dev_name,
-				       const char *pin_group,
-				       unsigned long config)
-{
-	return 0;
-}
-
-#endif
-
 #endif /* __LINUX_PINCTRL_CONSUMER_H */
-- 
1.7.11.3

