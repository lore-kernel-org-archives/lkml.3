Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaJGAAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:00:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50666 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751377AbaJFX7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 19:59:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 11/13] gpio: Support for unified device properties interface
Date: Tue, 07 Oct 2014 02:18:08 +0200
Message-ID: <2052507.JjE2hdgEYc@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2660541.BycO7TFnA2@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Some drivers need to deal with only firmware representation of its
GPIOs. An example would be a GPIO button array driver where each button
is described as a separate firmware node in device tree. Typically these
child nodes do not have physical representation in the Linux device
model.

In order to help device drivers to handle such firmware child nodes we
add dev[m]_get_named_gpiod_from_child() that takes a child firmware
node pointer as its second argument (the first one is the parent device
itself), finds the GPIO using whatever is the underlying firmware
method, and requests the GPIO properly.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/gpio/devres.c         | 34 ++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        | 56 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/consumer.h |  5 ++++
 3 files changed, 95 insertions(+)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 954b9f6..a1f7e55 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -109,6 +109,40 @@ struct gpio_desc *__must_check __devm_gpiod_get_index(struct device *dev,
 EXPORT_SYMBOL(__devm_gpiod_get_index);
 
 /**
+ * devm_get_named_gpiod_from_child - managed dev_get_named_gpiod_from_child()
+ * @dev:	GPIO consumer
+ * @child:	firmware node (child of @dev)
+ * @propname:	name of the firmware property
+ * @index:	index of the GPIO in the property value in case of many
+ *
+ * GPIO descriptors returned from this function are automatically disposed on
+ * driver detach.
+ */
+struct gpio_desc *devm_get_named_gpiod_from_child(struct device *dev, void *child,
+						  const char *propname, int index)
+{
+	struct gpio_desc **dr;
+	struct gpio_desc *desc;
+
+	dr = devres_alloc(devm_gpiod_release, sizeof(struct gpio_desc *),
+			  GFP_KERNEL);
+	if (!dr)
+		return ERR_PTR(-ENOMEM);
+
+	desc = dev_get_named_gpiod_from_child(dev, child, propname, index);
+	if (IS_ERR(desc)) {
+		devres_free(dr);
+		return desc;
+	}
+
+	*dr = desc;
+	devres_add(dev, dr);
+
+	return desc;
+}
+EXPORT_SYMBOL(devm_get_named_gpiod_from_child);
+
+/**
  * devm_gpiod_get_index_optional - Resource-managed gpiod_get_index_optional()
  * @dev: GPIO consumer
  * @con_id: function within the GPIO consumer
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 4c86601..344bc12 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1717,6 +1717,62 @@ struct gpio_desc *__must_check __gpiod_get_index(struct device *dev,
 EXPORT_SYMBOL_GPL(__gpiod_get_index);
 
 /**
+ * dev_get_named_gpiod_from_child - obtain a GPIO from firmware node
+ * @dev:	parent device
+ * @child:	firmware node (child of @dev)
+ * @propname:	name of the firmware property
+ * @idx:	index of the GPIO in the property value in case of many
+ *
+ * This function can be used for drivers that get their configuration
+ * from firmware in such a way that some properties are described as child
+ * nodes for the parent device in DT or ACPI.
+ *
+ * Function properly finds the corresponding GPIO using whatever is the
+ * underlying firmware interface and then makes sure that the GPIO
+ * descriptor is requested before it is returned to the caller.
+ *
+ * In case of error an ERR_PTR() is returned.
+ */
+struct gpio_desc *dev_get_named_gpiod_from_child(struct device *dev, void *child,
+						 const char *propname, int index)
+{
+	struct gpio_desc *desc = ERR_PTR(-ENODEV);
+	bool active_low = false;
+	int ret;
+
+	if (!child)
+		return ERR_PTR(-EINVAL);
+
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
+		enum of_gpio_flags flags;
+
+		desc = of_get_named_gpiod_flags(child, propname, index, &flags);
+		if (!IS_ERR(desc))
+			active_low = flags & OF_GPIO_ACTIVE_LOW;
+	} else if (ACPI_COMPANION(dev)) {
+		struct acpi_gpio_info info;
+
+		desc = acpi_get_gpiod_by_index(child, propname, index, &info);
+		if (!IS_ERR(desc))
+			active_low = info.active_low;
+	}
+
+	if (IS_ERR(desc))
+		return desc;
+
+	ret = gpiod_request(desc, NULL);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Only value flag can be set from both DT and ACPI is active_low */
+	if (active_low)
+		set_bit(FLAG_ACTIVE_LOW, &desc->flags);
+
+	return desc;
+}
+EXPORT_SYMBOL_GPL(dev_get_named_gpiod_from_child);
+
+/**
  * gpiod_get_index_optional - obtain an optional GPIO from a multi-index GPIO
  *                            function
  * @dev: GPIO consumer, can be NULL for system-global GPIOs
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 12f146f..033d2fd 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -94,6 +94,11 @@ int gpiod_to_irq(const struct gpio_desc *desc);
 struct gpio_desc *gpio_to_desc(unsigned gpio);
 int desc_to_gpio(const struct gpio_desc *desc);
 
+/* Child properties interface */
+struct gpio_desc *dev_get_named_gpiod_from_child(struct device *dev, void *child,
+						 const char *propname, int index);
+struct gpio_desc *devm_get_named_gpiod_from_child(struct device *dev, void *child,
+						  const char *propname, int index);
 #else /* CONFIG_GPIOLIB */
 
 static inline struct gpio_desc *__must_check __gpiod_get(struct device *dev,
-- 
1.9.3


