Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaDYPLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:11:40 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39325 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaDYPLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:11:33 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] gpio: Add helpers for optional GPIOs
Date: Fri, 25 Apr 2014 17:10:06 +0200
Message-Id: <1398438606-19718-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398438606-19718-1-git-send-email-thierry.reding@gmail.com>
References: <1398438606-19718-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Introduce gpiod_get_optional() and gpiod_get_index_optional() helpers
that make it easier for drivers to handle optional GPIOs.

Currently in order to handle optional GPIOs, a driver needs to special
case error handling for -ENOENT, such as this:

	gpio = gpiod_get(dev, "foo");
	if (IS_ERR(gpio)) {
		if (PTR_ERR(gpio) != -ENOENT)
			return PTR_ERR(gpio);

		gpio = NULL;
	}

	if (gpio) {
		/* set up GPIO */
	}

With these new helpers the above is reduced to:

	gpio = gpiod_get_optional(dev, "foo");
	if (IS_ERR(gpio))
		return PTR_ERR(gpio);

	if (gpio) {
		/* set up GPIO */
	}

While at it, device-managed variants of these functions are also
provided.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 Documentation/driver-model/devres.txt |  2 ++
 drivers/gpio/devres.c                 | 43 +++++++++++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c                | 43 +++++++++++++++++++++++++++++++++++
 include/linux/gpio/consumer.h         | 40 ++++++++++++++++++++++++++++++++
 4 files changed, 128 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 7b7d1c4d06bf..4796e2ab3349 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -314,4 +314,6 @@ SPI
 GPIO
   devm_gpiod_get()
   devm_gpiod_get_index()
+  devm_gpiod_get_optional()
+  devm_gpiod_get_index_optional()
   devm_gpiod_put()
diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 307464fd015f..65978cf85f79 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -52,6 +52,22 @@ struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
 EXPORT_SYMBOL(devm_gpiod_get);
 
 /**
+ * devm_gpiod_get_optional - Resource-managed gpiod_get_optional()
+ * @dev: GPIO consumer
+ * @con_id: function within the GPIO consumer
+ *
+ * Managed gpiod_get_optional(). GPIO descriptors returned from this function
+ * are automatically disposed on driver detach. See gpiod_get_optional() for
+ * detailed information about behavior and return values.
+ */
+struct gpio_desc *__must_check devm_gpiod_get_optional(struct device *dev,
+						       const char *con_id)
+{
+	return devm_gpiod_get_index_optional(dev, con_id, 0);
+}
+EXPORT_SYMBOL(devm_gpiod_get_optional);
+
+/**
  * devm_gpiod_get_index - Resource-managed gpiod_get_index()
  * @dev:	GPIO consumer
  * @con_id:	function within the GPIO consumer
@@ -87,6 +103,33 @@ struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 EXPORT_SYMBOL(devm_gpiod_get_index);
 
 /**
+ * devm_gpiod_get_index_optional - Resource-managed gpiod_get_index_optional()
+ * @dev: GPIO consumer
+ * @con_id: function within the GPIO consumer
+ * @index: index of the GPIO to obtain in the consumer
+ *
+ * Managed gpiod_get_index_optional(). GPIO descriptors returned from this
+ * function are automatically disposed on driver detach. See
+ * gpiod_get_index_optional() for detailed information about behavior and
+ * return values.
+ */
+struct gpio_desc *__must_check devm_gpiod_get_index_optional(struct device *dev,
+							     const char *con_id,
+							     unsigned int index)
+{
+	struct gpio_desc *desc;
+
+	desc = devm_gpiod_get_index(dev, con_id, index);
+	if (IS_ERR(desc)) {
+		if (PTR_ERR(desc) == -ENOENT)
+			return NULL;
+	}
+
+	return desc;
+}
+EXPORT_SYMBOL(devm_gpiod_get_index_optional);
+
+/**
  * devm_gpiod_put - Resource-managed gpiod_put()
  * @desc:	GPIO descriptor to dispose of
  *
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f284e23c78ef..431fddb0dfec 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2732,6 +2732,22 @@ struct gpio_desc *__must_check gpiod_get(struct device *dev, const char *con_id)
 EXPORT_SYMBOL_GPL(gpiod_get);
 
 /**
+ * gpiod_get_optional - obtain an optional GPIO for a given GPIO function
+ * @dev: GPIO consumer, can be NULL for system-global GPIOs
+ * @con_id: function within the GPIO consumer
+ *
+ * This is equivalent to gpiod_get(), except that when no GPIO was assigned to
+ * the requested function it will return NULL. This is convenient for drivers
+ * that need to handle optional GPIOs.
+ */
+struct gpio_desc *__must_check gpiod_get_optional(struct device *dev,
+						  const char *con_id)
+{
+	return gpiod_get_index_optional(dev, con_id, 0);
+}
+EXPORT_SYMBOL_GPL(gpiod_get_optional);
+
+/**
  * gpiod_get_index - obtain a GPIO from a multi-index GPIO function
  * @dev:	GPIO consumer, can be NULL for system-global GPIOs
  * @con_id:	function within the GPIO consumer
@@ -2794,6 +2810,33 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 EXPORT_SYMBOL_GPL(gpiod_get_index);
 
 /**
+ * gpiod_get_index_optional - obtain an optional GPIO from a multi-index GPIO
+ *                            function
+ * @dev: GPIO consumer, can be NULL for system-global GPIOs
+ * @con_id: function within the GPIO consumer
+ * @index: index of the GPIO to obtain in the consumer
+ *
+ * This is equivalent to gpiod_get_index(), except that when no GPIO with the
+ * specified index was assigned to the requested function it will return NULL.
+ * This is convenient for drivers that need to handle optional GPIOs.
+ */
+struct gpio_desc *__must_check gpiod_get_index_optional(struct device *dev,
+							const char *con_id,
+							unsigned int index)
+{
+	struct gpio_desc *desc;
+
+	desc = gpiod_get_index(dev, con_id, index);
+	if (IS_ERR(desc)) {
+		if (PTR_ERR(desc) == -ENOENT)
+			return NULL;
+	}
+
+	return desc;
+}
+EXPORT_SYMBOL_GPL(gpiod_get_index_optional);
+
+/**
  * gpiod_put - dispose of a GPIO descriptor
  * @desc:	GPIO descriptor to dispose of
  *
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index bed128e8f4b1..6a37ef0dc59c 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -23,6 +23,12 @@ struct gpio_desc *__must_check gpiod_get(struct device *dev,
 struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 					       const char *con_id,
 					       unsigned int idx);
+struct gpio_desc *__must_check gpiod_get_optional(struct device *dev,
+						  const char *con_id);
+struct gpio_desc *__must_check gpiod_get_index_optional(struct device *dev,
+							const char *con_id,
+							unsigned int index);
+
 void gpiod_put(struct gpio_desc *desc);
 
 struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
@@ -30,6 +36,12 @@ struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
 struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 						    const char *con_id,
 						    unsigned int idx);
+struct gpio_desc *__must_check devm_gpiod_get_optional(struct device *dev,
+						       const char *con_id);
+struct gpio_desc *__must_check
+devm_gpiod_get_index_optional(struct device *dev, const char *con_id,
+			      unsigned int index);
+
 void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
 
 int gpiod_get_direction(const struct gpio_desc *desc);
@@ -73,6 +85,20 @@ static inline struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 {
 	return ERR_PTR(-ENOSYS);
 }
+
+static inline struct gpio_desc *__must_check
+gpiod_get_optional(struct device *dev, const char *con_id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct gpio_desc *__must_check
+gpiod_get_index_optional(struct device *dev, const char *con_id,
+			 unsigned int index)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline void gpiod_put(struct gpio_desc *desc)
 {
 	might_sleep();
@@ -93,6 +119,20 @@ struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 {
 	return ERR_PTR(-ENOSYS);
 }
+
+static inline struct gpio_desc *__must_check
+devm_gpiod_get_optional(struct device *dev, const char *con_id)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
+static inline struct gpio_desc *__must_check
+devm_gpiod_get_index_optional(struct device *dev, const char *con_id,
+			      unsigned int index)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
 {
 	might_sleep();
-- 
1.9.2

