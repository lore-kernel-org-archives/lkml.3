Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaIPL5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:57:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:34254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbaIPLxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:53:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="600313938"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC PATCH v2 07/16] gpio: Add support for unified device properties interface
Date: Tue, 16 Sep 2014 14:52:38 +0300
Message-Id: <1410868367-11056-8-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some drivers need to deal with only firmware representation of its
GPIOs. An example would be a GPIO button array driver where each button
is described as a separate firmware node in device tree. Typically these
child nodes do not have physical representation in the Linux device
model.

In order to help device drivers to handle such firmware child nodes we
add dev[m]_node_get_named_gpiod() that takes a firmware node pointer as
parameter, finds the GPIO using whatever is the underlying firmware
method, and requests the GPIO properly.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/devres.c         | 35 +++++++++++++++++++++++++++
 drivers/gpio/gpiolib.c        | 55 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio/consumer.h |  7 ++++++
 3 files changed, 97 insertions(+)

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 954b9f6b0ef8..1556a251fc8e 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -109,6 +109,41 @@ struct gpio_desc *__must_check __devm_gpiod_get_index(struct device *dev,
 EXPORT_SYMBOL(__devm_gpiod_get_index);
 
 /**
+ * devm_node_get_named_gpiod - resource-managed dev_node_get_named_gpiod()
+ * @dev:	GPIO consumer
+ * @fdn:	firmware device node
+ * @propname:	name of the firmware property
+ * @idx:	index of the GPIO in the property value in case of many
+ *
+ * Managed dev_node_get_named_gpiod(). GPIO descriptors returned from
+ * this function are automatically disposed on driver detach.
+ */
+struct gpio_desc *devm_node_get_named_gpiod(struct device *dev,
+					    struct fw_dev_node *fdn,
+					    const char *propname, int index)
+{
+	struct gpio_desc **dr;
+	struct gpio_desc *desc;
+
+	dr = devres_alloc(devm_gpiod_release, sizeof(struct gpio_desc *),
+			  GFP_KERNEL);
+	if (!dr)
+		return ERR_PTR(-ENOMEM);
+
+	desc = dev_node_get_named_gpiod(fdn, propname, index);
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
+EXPORT_SYMBOL(devm_node_get_named_gpiod);
+
+/**
  * devm_gpiod_get_index_optional - Resource-managed gpiod_get_index_optional()
  * @dev: GPIO consumer
  * @con_id: function within the GPIO consumer
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 444d43c9fd3e..d364214d2946 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1717,6 +1717,61 @@ struct gpio_desc *__must_check __gpiod_get_index(struct device *dev,
 EXPORT_SYMBOL_GPL(__gpiod_get_index);
 
 /**
+ * dev_node_get_named_gpiod - obtain a GPIO from firmware device node
+ * @fdn:	firmware device node
+ * @propname:	name of the firmware property
+ * @idx:	index of the GPIO in the property value in case of many
+ *
+ * This function can be used for drivers that get their configuration
+ * from firmware in such way that there is not always corresponding
+ * physical device pointer available. For example some properties are
+ * described as a child nodes for the parent device in DT or ACPI.
+ *
+ * Function properly finds the corresponding GPIO using whatever is the
+ * underlying firmware interface and then makes sure that the GPIO
+ * descriptor is requested before it is returned to the caller.
+ *
+ * In case of error an ERR_PTR() is returned.
+ */
+struct gpio_desc *dev_node_get_named_gpiod(struct fw_dev_node *fdn,
+					   const char *propname, int index)
+{
+	struct gpio_desc *desc = ERR_PTR(-ENODEV);
+	struct acpi_device *adev = fdn->acpi_node;
+	struct device_node *np = fdn->of_node;
+	bool active_low = false;
+	int ret;
+
+	if (IS_ENABLED(CONFIG_OF) && np) {
+		enum of_gpio_flags flags;
+
+		desc = of_get_named_gpiod_flags(np, propname, index, &flags);
+		if (!IS_ERR(desc))
+			active_low = flags & OF_GPIO_ACTIVE_LOW;
+	} else if (IS_ENABLED(CONFIG_ACPI) && adev) {
+		struct acpi_gpio_info info;
+
+		desc = acpi_get_gpiod_by_index(adev, propname, index, &info);
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
+EXPORT_SYMBOL_GPL(dev_node_get_named_gpiod);
+
+/**
  * gpiod_get_index_optional - obtain an optional GPIO from a multi-index GPIO
  *                            function
  * @dev: GPIO consumer, can be NULL for system-global GPIOs
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 12f146fa6604..aa1b273f0e38 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 
 struct device;
+struct fw_dev_node;
 
 /**
  * Opaque descriptor for a GPIO. These are obtained using gpiod_get() and are
@@ -94,6 +95,12 @@ int gpiod_to_irq(const struct gpio_desc *desc);
 struct gpio_desc *gpio_to_desc(unsigned gpio);
 int desc_to_gpio(const struct gpio_desc *desc);
 
+/* Firmware node interface */
+struct gpio_desc *dev_node_get_named_gpiod(struct fw_dev_node *fdn,
+					   const char *propname, int index);
+struct gpio_desc *devm_node_get_named_gpiod(struct device *dev,
+					    struct fw_dev_node *fdn,
+					    const char *propname, int index);
 #else /* CONFIG_GPIOLIB */
 
 static inline struct gpio_desc *__must_check __gpiod_get(struct device *dev,
-- 
2.1.0

