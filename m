Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab3LUKtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:49:35 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:59488 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3LUKtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:49:32 -0500
Date: Sat, 21 Dec 2013 16:19:20 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>, linux-gpio@vger.kernel.org,
        linux-pwm@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH] drivers: Remove unused devm_*_put functions
Message-ID: <20131221104920.GA3626@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused devm_*_put functions because none of them are
used anywhere in the kernel and devm does automatic cleanup
of resources and requires no manual cleanup.

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpio/devres.c         |   25 -------------------------
 drivers/phy/phy-core.c        |   17 -----------------
 drivers/pwm/core.c            |   15 ---------------
 include/linux/gpio/consumer.h |    9 ---------
 include/linux/phy/phy.h       |    5 -----
 include/linux/pwm.h           |    5 -----
 6 files changed, 76 deletions(-)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 307464f..07ecca3 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -28,13 +28,6 @@ static void devm_gpiod_release(struct device *dev, void *res)
 	gpiod_put(*desc);
 }
 
-static int devm_gpiod_match(struct device *dev, void *res, void *data)
-{
-	struct gpio_desc **this = res, **gpio = data;
-
-	return *this == *gpio;
-}
-
 /**
  * devm_gpiod_get - Resource-managed gpiod_get()
  * @dev:	GPIO consumer
@@ -86,24 +79,6 @@ struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 }
 EXPORT_SYMBOL(devm_gpiod_get_index);
 
-/**
- * devm_gpiod_put - Resource-managed gpiod_put()
- * @desc:	GPIO descriptor to dispose of
- *
- * Dispose of a GPIO descriptor obtained with devm_gpiod_get() or
- * devm_gpiod_get_index(). Normally this function will not be called as the GPIO
- * will be disposed of by the resource management code.
- */
-void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
-{
-	WARN_ON(devres_release(dev, devm_gpiod_release, devm_gpiod_match,
-		&desc));
-}
-EXPORT_SYMBOL(devm_gpiod_put);
-
-
-
-
 static void devm_gpio_release(struct device *dev, void *res)
 {
 	unsigned *gpio = res;
diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..913643f 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -299,23 +299,6 @@ void phy_put(struct phy *phy)
 EXPORT_SYMBOL_GPL(phy_put);
 
 /**
- * devm_phy_put() - release the PHY
- * @dev: device that wants to release this phy
- * @phy: the phy returned by devm_phy_get()
- *
- * destroys the devres associated with this phy and invokes phy_put
- * to release the phy.
- */
-void devm_phy_put(struct device *dev, struct phy *phy)
-{
-	int r;
-
-	r = devres_destroy(dev, devm_phy_release, devm_phy_match, phy);
-	dev_WARN_ONCE(dev, r, "couldn't find PHY resource\n");
-}
-EXPORT_SYMBOL_GPL(devm_phy_put);
-
-/**
  * of_phy_simple_xlate() - returns the phy instance from phy provider
  * @dev: the PHY provider device
  * @args: of_phandle_args (not used here)
diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 2ca9504..c503b88e 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -771,21 +771,6 @@ static int devm_pwm_match(struct device *dev, void *res, void *data)
 }
 
 /**
- * devm_pwm_put() - resource managed pwm_put()
- * @dev: device for PWM consumer
- * @pwm: PWM device
- *
- * Release a PWM previously allocated using devm_pwm_get(). Calling this
- * function is usually not needed because devm-allocated resources are
- * automatically released on driver detach.
- */
-void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
-{
-	WARN_ON(devres_release(dev, devm_pwm_release, devm_pwm_match, pwm));
-}
-EXPORT_SYMBOL_GPL(devm_pwm_put);
-
-/**
   * pwm_can_sleep() - report whether PWM access will sleep
   * @pwm: PWM device
   *
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 4d34dbb..70862f7 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -31,7 +31,6 @@ struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
 struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 						    const char *con_id,
 						    unsigned int idx);
-void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
 
 int gpiod_get_direction(const struct gpio_desc *desc);
 int gpiod_direction_input(struct gpio_desc *desc);
@@ -94,14 +93,6 @@ struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 {
 	return ERR_PTR(-ENOSYS);
 }
-static inline void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
-{
-	might_sleep();
-
-	/* GPIO can never have been requested */
-	WARN_ON(1);
-}
-
 
 static inline int gpiod_get_direction(const struct gpio_desc *desc)
 {
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index 6d72269..129bac7 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -130,7 +130,6 @@ int phy_power_off(struct phy *phy);
 struct phy *phy_get(struct device *dev, const char *string);
 struct phy *devm_phy_get(struct device *dev, const char *string);
 void phy_put(struct phy *phy);
-void devm_phy_put(struct device *dev, struct phy *phy);
 struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args);
 struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
@@ -213,10 +212,6 @@ static inline void phy_put(struct phy *phy)
 {
 }
 
-static inline void devm_phy_put(struct device *dev, struct phy *phy)
-{
-}
-
 static inline struct phy *of_phy_simple_xlate(struct device *dev,
 	struct of_phandle_args *args)
 {
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index f0feafd..10ec30a 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -198,7 +198,6 @@ void pwm_put(struct pwm_device *pwm);
 struct pwm_device *devm_pwm_get(struct device *dev, const char *con_id);
 struct pwm_device *devm_of_pwm_get(struct device *dev, struct device_node *np,
 				   const char *con_id);
-void devm_pwm_put(struct device *dev, struct pwm_device *pwm);
 
 bool pwm_can_sleep(struct pwm_device *pwm);
 #else
@@ -258,10 +257,6 @@ static inline struct pwm_device *devm_of_pwm_get(struct device *dev,
 	return ERR_PTR(-ENODEV);
 }
 
-static inline void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
-{
-}
-
 static inline bool pwm_can_sleep(struct pwm_device *pwm)
 {
 	return false;
-- 
1.7.9.5

