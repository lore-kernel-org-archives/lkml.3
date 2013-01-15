Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3AOEfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:35:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34044 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab3AOEfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:35:51 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/4] regulator-core: support shared enable GPIO concept
Thread-Topic: [PATCH v2 1/4] regulator-core: support shared enable GPIO
 concept
Thread-Index: Ac3y2cUUKwjUuOI8QDORp2JK0YpzJQ==
Date: Tue, 15 Jan 2013 04:35:41 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E12B2D@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 A Regulator can be enabled by external GPIO pin.
 This is configurable in the regulator_config.
 At this moment, this enable GPIO is owned by only one regulator device.
 In some devices, multiple regulators are enabled by shared one GPIO pin.
 This patch extends this limitation, enabling shared enable GPIO of regulators.

 New list for enable GPIO: 'regulator_ena_gpio_list'
   This manages enable GPIO list.

 New structure for supporting shared enable GPIO: 'regulator_enable_gpio'
   The enable count is used for balancing GPIO control count.
   The count is incremented when GPIO is enabled.
   On the other hand, it's decremented when GPIO is disabled.

 How it works
   If the GPIO is already used, skip requesting new GPIO usage.
   The GPIO is new one, request GPIO function and add it to the list of
   enable GPIO.
   This list is used for balancing enable GPIO count and pin control.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c |   49 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index de47880..1273090 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -51,6 +51,7 @@
 static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
+static LIST_HEAD(regulator_ena_gpio_list);
 static bool has_full_constraints;
 static bool board_wants_dummy_regulator;
 
@@ -69,6 +70,18 @@ struct regulator_map {
 };
 
 /*
+ * struct regulator_enable_gpio
+ *
+ * Management for shared enable GPIO pin
+ */
+struct regulator_enable_gpio {
+	struct list_head list;
+	int gpio;
+	u32 enable_count;
+	struct regulator_dev *regulator;
+};
+
+/*
  * struct regulator
  *
  * One for each consumer device.
@@ -1456,6 +1469,38 @@ void devm_regulator_put(struct regulator *regulator)
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
+			rdev_info(rdev, "GPIO %d is already used\n",
+				config->ena_gpio);
+			return 0;
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
+	if (pin == NULL)
+		return -ENOMEM;
+
+	pin->gpio = config->ena_gpio;
+	pin->regulator = rdev;
+	list_add(&pin->list, &regulator_ena_gpio_list);
+
+	return 0;
+}
+
 static int _regulator_do_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
@@ -3420,9 +3465,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	dev_set_drvdata(&rdev->dev, rdev);
 
 	if (config->ena_gpio && gpio_is_valid(config->ena_gpio)) {
-		ret = gpio_request_one(config->ena_gpio,
-				       GPIOF_DIR_OUT | config->ena_gpio_flags,
-				       rdev_get_name(rdev));
+		ret = regulator_ena_gpio_request(rdev, config);
 		if (ret != 0) {
 			rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
 				 config->ena_gpio, ret);
-- 
1.7.9.5


Best Regards,
Milo

