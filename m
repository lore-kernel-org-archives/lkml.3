Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3BRGus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:50:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56928 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab3BRGur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:50:47 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/4] regulator: core: support shared enable GPIO concept
Thread-Topic: [PATCH v3 1/4] regulator: core: support shared enable GPIO
 concept
Thread-Index: Ac4NpEMim+AxsiA+QWeQ2UibOpT9vA==
Date: Mon, 18 Feb 2013 06:50:39 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F792729F1@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 A Regulator can be enabled by external GPIO pin.
 This is configurable in the regulator_config.
 At this moment, the GPIO can be owned by only one regulator device.
 In some devices, multiple regulators are enabled by shared one GPIO pin.
 This patch extends this limitation, enabling shared enable GPIO of regulators.

 New list for enable GPIO: 'regulator_ena_gpio_list'
   This manages enable GPIO list.

 New structure for supporting shared enable GPIO: 'regulator_enable_gpio'
   The enable count is used for balancing GPIO control count.
   This count is incremented when GPIO is enabled.
   On the other hand, it's decremented when GPIO is disabled.

 Reference count: 'request_count'
   The reference count, 'request_count' is incremented/decremented on
   requesting/freeing the GPIO. This count makes sure only free the GPIO
   when it has no users.

 How it works
   If the GPIO is already used, skip requesting new GPIO usage.
   The GPIO is new one, request GPIO function and add it to the list of
   enable GPIO.
   This list is used for balancing enable GPIO count and pin control.

 Updating a GPIO and invert code moved
   'ena_gpio' and 'ena_gpio_invert' of the regulator_config were moved to
    new function, regulator_ena_gpio_request().
    Use regulator_enable_pin structure rather than regulator_dev.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c         |   86 +++++++++++++++++++++++++++++++++-----
 include/linux/regulator/driver.h |    2 +
 2 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index da9782b..71d6adc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -51,6 +51,7 @@
 static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
+static LIST_HEAD(regulator_ena_gpio_list);
 static bool has_full_constraints;
 static bool board_wants_dummy_regulator;
 
@@ -69,6 +70,19 @@ struct regulator_map {
 };
 
 /*
+ * struct regulator_enable_gpio
+ *
+ * Management for shared enable GPIO pin
+ */
+struct regulator_enable_gpio {
+	struct list_head list;
+	int gpio;
+	u32 enable_count;	/* a number of enabled shared GPIO */
+	u32 request_count;	/* a number of requested shared GPIO */
+	unsigned int ena_gpio_invert:1;
+};
+
+/*
  * struct regulator
  *
  * One for each consumer device.
@@ -1456,6 +1470,65 @@ void devm_regulator_put(struct regulator *regulator)
 }
 EXPORT_SYMBOL_GPL(devm_regulator_put);
 
+/* Manage enable GPIO list. Same GPIO pin can be shared among regulators */
+static int regulator_ena_gpio_request(struct regulator_dev *rdev,
+				const struct regulator_config *config)
+{
+	struct regulator_enable_gpio *pin;
+	int ret;
+
+	list_for_each_entry(pin, &regulator_ena_gpio_list, list) {
+		if (pin->gpio == config->ena_gpio) {
+			rdev_dbg(rdev, "GPIO %d is already used\n",
+				config->ena_gpio);
+			goto update_ena_gpio_to_rdev;
+		}
+	}
+
+	ret = gpio_request_one(config->ena_gpio,
+				GPIOF_DIR_OUT | config->ena_gpio_flags,
+				rdev_get_name(rdev));
+	if (ret)
+		return ret;
+
+	pin = kzalloc(sizeof(struct regulator_enable_gpio), GFP_KERNEL);
+	if (pin == NULL) {
+		gpio_free(config->ena_gpio);
+		return -ENOMEM;
+	}
+
+	pin->gpio = config->ena_gpio;
+	pin->ena_gpio_invert = config->ena_gpio_invert;
+	list_add(&pin->list, &regulator_ena_gpio_list);
+
+update_ena_gpio_to_rdev:
+	pin->request_count++;
+	rdev->ena_pin = pin;
+	return 0;
+}
+
+static void regulator_ena_gpio_free(struct regulator_dev *rdev)
+{
+	struct regulator_enable_gpio *pin, *n;
+
+	if (!rdev->ena_pin)
+		return;
+
+	/* Free the GPIO only in case of no use */
+	list_for_each_entry_safe(pin, n, &regulator_ena_gpio_list, list) {
+		if (pin->gpio == rdev->ena_pin->gpio) {
+			if (pin->request_count <= 1) {
+				pin->request_count = 0;
+				gpio_free(pin->gpio);
+				list_del(&pin->list);
+				kfree(pin);
+			} else {
+				pin->request_count--;
+			}
+		}
+	}
+}
+
 static int _regulator_do_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
@@ -3435,18 +3508,13 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	dev_set_drvdata(&rdev->dev, rdev);
 
 	if (config->ena_gpio && gpio_is_valid(config->ena_gpio)) {
-		ret = gpio_request_one(config->ena_gpio,
-				       GPIOF_DIR_OUT | config->ena_gpio_flags,
-				       rdev_get_name(rdev));
+		ret = regulator_ena_gpio_request(rdev, config);
 		if (ret != 0) {
 			rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
 				 config->ena_gpio, ret);
 			goto wash;
 		}
 
-		rdev->ena_gpio = config->ena_gpio;
-		rdev->ena_gpio_invert = config->ena_gpio_invert;
-
 		if (config->ena_gpio_flags & GPIOF_OUT_INIT_HIGH)
 			rdev->ena_gpio_state = 1;
 
@@ -3522,8 +3590,7 @@ unset_supplies:
 scrub:
 	if (rdev->supply)
 		_regulator_put(rdev->supply);
-	if (rdev->ena_gpio)
-		gpio_free(rdev->ena_gpio);
+	regulator_ena_gpio_free(rdev);
 	kfree(rdev->constraints);
 wash:
 	device_unregister(&rdev->dev);
@@ -3558,8 +3625,7 @@ void regulator_unregister(struct regulator_dev *rdev)
 	unset_regulator_supplies(rdev);
 	list_del(&rdev->list);
 	kfree(rdev->constraints);
-	if (rdev->ena_gpio)
-		gpio_free(rdev->ena_gpio);
+	regulator_ena_gpio_free(rdev);
 	device_unregister(&rdev->dev);
 	mutex_unlock(&regulator_list_mutex);
 }
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 23070fd..a467d11 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -22,6 +22,7 @@
 struct regmap;
 struct regulator_dev;
 struct regulator_init_data;
+struct regulator_enable_gpio;
 
 enum regulator_status {
 	REGULATOR_STATUS_OFF,
@@ -300,6 +301,7 @@ struct regulator_dev {
 
 	struct dentry *debugfs;
 
+	struct regulator_enable_gpio *ena_pin;
 	int ena_gpio;
 	unsigned int ena_gpio_invert:1;
 	unsigned int ena_gpio_state:1;
-- 
1.7.9.5


Best Regards,
Milo


