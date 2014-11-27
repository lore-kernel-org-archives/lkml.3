Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaK0LXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:23:40 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44171 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbaK0LVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:15 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-16-54770928152b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 4/7] regulator: Use ena_gpio supplied with generic regulator
 bindings
Date: Thu, 27 Nov 2014 12:20:50 +0100
Message-id: <1417087253-12306-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xK7oanOUhBhP65S02zljPajH14RM2
	i/lHzrFavH5haNH/+DWzxdmmN+wW978eZbT4dqWDyWLT42usFpd3zWGzmHF+H5PF2iN32R14
	PHbOusvusWlVJ5vHnWt72Dw2L6n36NuyitHj8ya5ALYoLpuU1JzMstQifbsErow7C1awFyzQ
	r5i0ZCZzA2OjWhcjJ4eEgInErSld7BC2mMSFe+vZuhi5OIQEljJK9DQeY4dw+pgk1n17wwhS
	xSZgLLF5+RI2EFtEYAWjxPEbiiA2s8B6JokH25xAbGGBKInDJ+8ANXNwsAioSjx6nA4S5hVw
	l1jfMxVqmZzEyWOTWUFsTgEPib23brOA2EJANXte3WGZwMi7gJFhFaNoamlyQXFSeq6hXnFi
	bnFpXrpecn7uJkZIMH7Zwbj4mNUhRgEORiUe3oTHZSFCrIllxZW5hxglOJiVRHi5GMtDhHhT
	EiurUovy44tKc1KLDzEycXBKNTD6Ji7WfnmsZ3PgB3O/buOpPIeeV527UPB4/0aXoLvGNuFW
	Xh39ovrhMYefZhlEB+re375LqbbaJO2fOd9h/61cKlWBacX6T8q4/2qrBBm+XX547i6xxo+n
	nrnNzmK8fPDQs8f3DW6cOlLxO1px/o7ji83+fRbbOmfpGbMnD6Zbf7y7sLja8vxDJZbijERD
	Leai4kQA6gh57SQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ena_gpio from regulator constraints (filled by parsing generic
bindings) to initialize the GPIO enable control. Support also the old
way: ena_gpio supplied in regulator_config structure.

This also adds a new set_ena_gpio() callback in regulator_ops structure
which driver may provide to actually enable the GPIO control in
hardware.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/core.c         | 96 ++++++++++++++++++++++++++++++----------
 include/linux/regulator/driver.h |  5 +++
 2 files changed, 78 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index bbf93c9caca3..1760184cd8dc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -26,6 +26,7 @@
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
 #include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/regmap.h>
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/consumer.h>
@@ -1044,6 +1045,14 @@ static int set_machine_constraints(struct regulator_dev *rdev,
 		}
 	}
 
+	if (rdev->constraints->use_ena_gpio && ops->set_ena_gpio) {
+		ret = ops->set_ena_gpio(rdev);
+		if (ret < 0) {
+			rdev_err(rdev, "failed to set enable GPIO control\n");
+			goto out;
+		}
+	}
+
 	print_constraints(rdev);
 	return 0;
 out:
@@ -1660,36 +1669,36 @@ EXPORT_SYMBOL_GPL(regulator_bulk_unregister_supply_alias);
 
 /* Manage enable GPIO list. Same GPIO pin can be shared among regulators */
 static int regulator_ena_gpio_request(struct regulator_dev *rdev,
-				const struct regulator_config *config)
+					unsigned int gpio,
+					bool gpio_invert,
+					unsigned int gpio_flags)
 {
 	struct regulator_enable_gpio *pin;
 	struct gpio_desc *gpiod;
 	int ret;
 
-	gpiod = gpio_to_desc(config->ena_gpio);
+	gpiod = gpio_to_desc(gpio);
 
 	list_for_each_entry(pin, &regulator_ena_gpio_list, list) {
 		if (pin->gpiod == gpiod) {
-			rdev_dbg(rdev, "GPIO %d is already used\n",
-				config->ena_gpio);
+			rdev_dbg(rdev, "GPIO %d is already used\n", gpio);
 			goto update_ena_gpio_to_rdev;
 		}
 	}
 
-	ret = gpio_request_one(config->ena_gpio,
-				GPIOF_DIR_OUT | config->ena_gpio_flags,
+	ret = gpio_request_one(gpio, GPIOF_DIR_OUT | gpio_flags,
 				rdev_get_name(rdev));
 	if (ret)
 		return ret;
 
 	pin = kzalloc(sizeof(struct regulator_enable_gpio), GFP_KERNEL);
 	if (pin == NULL) {
-		gpio_free(config->ena_gpio);
+		gpio_free(gpio);
 		return -ENOMEM;
 	}
 
 	pin->gpiod = gpiod;
-	pin->ena_gpio_invert = config->ena_gpio_invert;
+	pin->ena_gpio_invert = gpio_invert;
 	list_add(&pin->list, &regulator_ena_gpio_list);
 
 update_ena_gpio_to_rdev:
@@ -1698,6 +1707,59 @@ update_ena_gpio_to_rdev:
 	return 0;
 }
 
+/*
+ * Request GPIO for enable control from regulator_config
+ * or init_data->constraints.
+ */
+static int regulator_ena_gpio_setup(struct regulator_dev *rdev,
+			const struct regulator_config *config,
+			const struct regulator_init_data *init_data)
+{
+	unsigned int gpio_flags;
+	bool gpio_invert;
+	int gpio, ret;
+
+	if (config->ena_gpio || config->ena_gpio_initialized) {
+		gpio = config->ena_gpio;
+		gpio_invert = config->ena_gpio_invert;
+		gpio_flags = config->ena_gpio_flags;
+	} else if (init_data && init_data->constraints.use_ena_gpio) {
+		const struct regulation_constraints *c = &init_data->constraints;
+
+		gpio = c->ena_gpio;
+		gpio_invert = false;
+		gpio_flags = GPIOF_OUT_INIT_HIGH;
+
+		if (c->ena_gpio_flags & OF_GPIO_ACTIVE_LOW) {
+			gpio_invert = true;
+			gpio_flags = GPIOF_OUT_INIT_LOW;
+		}
+
+		if (c->ena_gpio_open_drain)
+			gpio_flags |= GPIOF_OPEN_DRAIN;
+	} else {
+		return 0;
+	}
+
+	if (!gpio_is_valid(gpio))
+		return 0;
+
+	ret = regulator_ena_gpio_request(rdev, gpio, gpio_invert, gpio_flags);
+	if (ret != 0) {
+		rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
+				 gpio, ret);
+		return ret;
+	}
+
+	if (gpio_flags & GPIOF_OUT_INIT_HIGH)
+		rdev->ena_gpio_state = 1;
+
+	if (gpio_invert)
+		rdev->ena_gpio_state = !rdev->ena_gpio_state;
+
+	return 0;
+}
+
 static void regulator_ena_gpio_free(struct regulator_dev *rdev)
 {
 	struct regulator_enable_gpio *pin, *n;
@@ -3650,21 +3712,9 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
-	if ((config->ena_gpio || config->ena_gpio_initialized) &&
-	    gpio_is_valid(config->ena_gpio)) {
-		ret = regulator_ena_gpio_request(rdev, config);
-		if (ret != 0) {
-			rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
-				 config->ena_gpio, ret);
-			goto wash;
-		}
-
-		if (config->ena_gpio_flags & GPIOF_OUT_INIT_HIGH)
-			rdev->ena_gpio_state = 1;
-
-		if (config->ena_gpio_invert)
-			rdev->ena_gpio_state = !rdev->ena_gpio_state;
-	}
+	ret = regulator_ena_gpio_setup(rdev, config, init_data);
+	if (ret != 0)
+		goto wash;
 
 	/* set regulator constraints */
 	if (init_data)
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 28da08e4671f..fe967a0c6ce7 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -118,6 +118,9 @@ struct regulator_linear_range {
  *                       suspended.
  * @set_suspend_mode: Set the operating mode for the regulator when the
  *                    system is suspended.
+ * @set_ena_gpio: Turn on GPIO enable control for given regulator. Called
+ *                by core during registration of regulator when regulator
+ *                was configured for this mode by standard binding.
  *
  * This struct describes regulator operations which can be implemented by
  * regulator chip drivers.
@@ -183,6 +186,8 @@ struct regulator_ops {
 
 	/* set regulator suspend operating mode (defined in consumer.h) */
 	int (*set_suspend_mode) (struct regulator_dev *, unsigned int mode);
+
+	int (*set_ena_gpio)(struct regulator_dev *);
 };
 
 /*
-- 
1.9.1

