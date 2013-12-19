Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3LSOfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:35:48 -0500
Received: from 19.mo3.mail-out.ovh.net ([178.32.98.231]:49001 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753181Ab3LSOfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:35:46 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [RFC PATCH] gpio: add GPIO hogging mechanism
Date: Thu, 19 Dec 2013 15:34:31 +0100
Message-Id: <1387463671-1164-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com>
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 303711499895601251
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO hogging is a way to request and configure specific GPIO without
explicitly requesting it in the device driver.

The request and configuration procedure is handled in the core device
driver code before the driver probe function is called.

It allows specific GPIOs to be configured without any driver specific code.

Particularly usefull when a external device is connected to a bus and the
bus connections depends on an external switch controlled by a GPIO pin.
Or when some GPIOs have to be exported to sysfs without any userspace
intervention.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 Documentation/devicetree/bindings/gpio/gpio.txt |   47 ++++++++
 drivers/base/Makefile                           |    1 +
 drivers/base/dd.c                               |    5 +
 drivers/base/gpio.c                             |   59 ++++++++++
 drivers/gpio/devres.c                           |   39 +++++++
 drivers/gpio/gpiolib-of.c                       |  134 +++++++++++++++++++++++
 drivers/gpio/gpiolib.c                          |  103 +++++++++++++++++
 include/linux/device.h                          |    5 +
 include/linux/gpio/consumer.h                   |   25 +++++
 include/linux/gpio/devinfo.h                    |   38 +++++++
 include/linux/of_gpio.h                         |   19 ++++
 11 files changed, 475 insertions(+)
 create mode 100644 drivers/base/gpio.c
 create mode 100644 include/linux/gpio/devinfo.h

diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
index 0c85bb6..e2295e3 100644
--- a/Documentation/devicetree/bindings/gpio/gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio.txt
@@ -59,6 +59,35 @@ and empty GPIO flags as accepted by the "qe_pio_e" gpio-controller.
 Every GPIO controller node must both an empty "gpio-controller"
 property, and have #gpio-cells contain the size of the gpio-specifier.
 
+It might contain GPIO hog definitions. GPIO hogging is a mechanism providing
+automatic GPIO request and configuration before the device is passed to its
+driver probe function (the same mechanism is used for pinctrl pin config).
+
+Each GPIO hog definition is represented as a child node of the GPIO controller.
+Required properties:
+- gpio: store the gpio informations (id, flags, ...). Shall contain the
+  number of cells specified in its parent node (GPIO controller node).
+- hog-as-input or hog-as-output: a boolean property specifying the GPIO
+  direction.
+- hog-init-high or hog-init-low: a boolean property specifying the GPIO
+  value in case the GPIO is hogged as output.
+
+Optional properties:
+- open-drain-line: GPIO is configured as an open drain pin.
+- open-source-line: GPIO is configured as an open source pin.
+- export-line or export-line-fixed: the GPIO is exported to userspace via
+  sysfs.
+- line-name: the GPIO label name.
+
+A GPIO consumer can request GPIO hogs using the "gpio-hogs" property, which
+encodes a list of requested GPIO hogs.
+If the "gpio-hog-names" property is specified and the GPIO hog export the GPIO
+to sysfs, links to the GPIO directory are created in the consumer sysfs device
+directory.
+
+If you just want to export a GPIO to sysfs without assigning it to a specific
+device, you can specify a "gpio-hogs" property in the GPIO controller node.
+
 Example of two SOC GPIO banks defined as gpio-controller nodes:
 
 	qe_pio_a: gpio-controller@1400 {
@@ -66,6 +95,19 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
 		compatible = "fsl,qe-pario-bank-a", "fsl,qe-pario-bank";
 		reg = <0x1400 0x18>;
 		gpio-controller;
+		gpio-hogs = <&exported_gpio>;
+
+		line_a: line-a {
+			gpio = <5 0>;
+			hog-as-input;
+			line-name = "line-a";
+		};
+
+		exported_gpio: exported-gpio {
+			gpio = <6 0>;
+			hog-as-output;
+			line-name = "exported-gpio";
+		};
 	};
 
 	qe_pio_e: gpio-controller@1460 {
@@ -75,6 +117,11 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
 		gpio-controller;
 	};
 
+	pio_consumer {
+		gpio-hogs = <&line_a>;
+		gpio-hog-names = "my-line-a";
+	};
+
 2.1) gpio- and pin-controller interaction
 -----------------------------------------
 
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 94e8a80..17940c3 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 obj-$(CONFIG_REGMAP)	+= regmap/
 obj-$(CONFIG_SOC_BUS) += soc.o
 obj-$(CONFIG_PINCTRL) += pinctrl.o
+obj-$(CONFIG_GPIOLIB) += gpio.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0605176..cfeceea 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
+#include <linux/gpio/devinfo.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -278,6 +279,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	if (ret)
 		goto probe_failed;
 
+	ret = gpio_get_hogs(dev);
+	if (ret)
+		goto probe_failed;
+
 	if (driver_sysfs_add(dev)) {
 		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
 			__func__, dev_name(dev));
diff --git a/drivers/base/gpio.c b/drivers/base/gpio.c
new file mode 100644
index 0000000..565c31c
--- /dev/null
+++ b/drivers/base/gpio.c
@@ -0,0 +1,59 @@
+/*
+ * Driver core interface to the GPIO subsystem.
+ *
+ * Copyright (C) Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Author: Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/device.h>
+#include <linux/gpio/devinfo.h>
+#include <linux/gpio/consumer.h>
+#include <linux/slab.h>
+
+/**
+ * gpio_get_hogs() - called by the device core before probe
+ * @dev: the device that is just about to probe
+ */
+int gpio_get_hogs(struct device *dev)
+{
+	struct gpio_desc *desc;
+	int ret;
+	int count;
+	int i = 0;
+
+	count = gpio_hog_count(dev);
+	if (!count)
+		return 0;
+
+	dev->gpios = devm_kzalloc(dev,
+				  sizeof(*(dev->gpios)) +
+				  (count * sizeof(struct gpio_desc *)),
+				  GFP_KERNEL);
+	if (!dev->gpios)
+		return -ENOMEM;
+
+	dev->gpios->ngpios = count;
+	for (i = 0; i < count; i++) {
+		desc = devm_gpiod_get_hog_index(dev, i);
+		if (IS_ERR(desc)) {
+			ret = PTR_ERR(desc);
+			if (ret == -EPROBE_DEFER)
+				goto cleanup;
+			desc = NULL;
+		}
+		dev->gpios->gpios[i] = desc;
+	}
+
+	return 0;
+
+cleanup:
+	for (; i > 0; i--)
+		devm_gpiod_put(dev, dev->gpios->gpios[i - 1]);
+	devm_kfree(dev, dev->gpios);
+	dev->gpios = NULL;
+
+	return ret;
+}
diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 307464f..ad0ebc5 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -87,6 +87,39 @@ struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 EXPORT_SYMBOL(devm_gpiod_get_index);
 
 /**
+ * devm_gpiod_get_hog_index - Resource-managed gpiod_get_hog_index()
+ * @dev:	GPIO consumer
+ * @idx:	index of the GPIO to obtain in the consumer
+ *
+ * Managed gpiod_get_hog_index(). GPIO descriptors returned from this function
+ * are automatically disposed on driver detach. See gpiod_get_index() for
+ * detailed information about behavior and return values.
+ */
+struct gpio_desc *__must_check devm_gpiod_get_hog_index(struct device *dev,
+							unsigned int idx)
+{
+	struct gpio_desc **dr;
+	struct gpio_desc *desc;
+
+	dr = devres_alloc(devm_gpiod_release, sizeof(struct gpiod_desc *),
+			  GFP_KERNEL);
+	if (!dr)
+		return ERR_PTR(-ENOMEM);
+
+	desc = gpiod_get_hog_index(dev, idx);
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
+EXPORT_SYMBOL(devm_gpiod_get_hog_index);
+
+/**
  * devm_gpiod_put - Resource-managed gpiod_put()
  * @desc:	GPIO descriptor to dispose of
  *
@@ -142,6 +175,9 @@ int devm_gpio_request(struct device *dev, unsigned gpio, const char *label)
 	if (!dr)
 		return -ENOMEM;
 
+	if (gpio_is_hogged(dev, gpio))
+		return 0;
+
 	rc = gpio_request(gpio, label);
 	if (rc) {
 		devres_free(dr);
@@ -172,6 +208,9 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
 	if (!dr)
 		return -ENOMEM;
 
+	if (gpio_is_hogged(dev, gpio))
+		return 0;
+
 	rc = gpio_request_one(gpio, flags, label);
 	if (rc) {
 		devres_free(dr);
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index e0a98f5..8e9fbef 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -96,6 +96,140 @@ struct gpio_desc *of_get_named_gpiod_flags(struct device_node *np,
 EXPORT_SYMBOL(of_get_named_gpiod_flags);
 
 /**
+ * of_gpio_hog_count() - Count a GPIO hogs on a specific device node
+ * @np:		device node to get GPIO from
+ *
+ * Returns the number of GPIO hogs requested by this device node.
+ */
+int of_gpio_hog_count(struct device_node *np)
+{
+	int size;
+
+	if (!of_get_property(np, "gpio-hogs", &size))
+		return 0;
+
+	return size / sizeof(phandle);
+}
+EXPORT_SYMBOL(of_gpio_hog_count);
+
+/**
+ * of_get_gpio_hog() - Get a GPIO hog descriptor, names and flags for GPIO API
+ * @np:		device node to get GPIO from
+ * @index:	index of the GPIO
+ * @name:	GPIO line name
+ * @lnk_name	GPIO link name (for sysfs link)
+ * @flags:	a flags pointer to fill in
+ *
+ * Returns GPIO descriptor to use with Linux GPIO API, or one of the errno
+ * value on the error condition.
+ */
+struct gpio_desc *of_get_gpio_hog(struct device_node *np, int index,
+				  const char **name, const char **lnk_name,
+				  unsigned long *flags)
+{
+	struct device_node *hog_np, *chip_np;
+	enum of_gpio_flags xlate_flags;
+	unsigned long req_flags = 0;
+	struct gpio_desc *desc;
+	struct gg_data gg_data = {
+		.flags = &xlate_flags,
+		.out_gpio = NULL,
+	};
+	u32 tmp;
+	int i;
+	int ret;
+
+	hog_np = of_parse_phandle(np, "gpio-hogs", index);
+	if (!hog_np)
+		return ERR_PTR(-EINVAL);
+
+	chip_np = hog_np->parent;
+	if (!chip_np) {
+		desc = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	ret = of_property_read_u32(chip_np, "#gpio-cells", &tmp);
+	if (ret) {
+		desc = ERR_PTR(ret);
+		goto out;
+	}
+
+	if (tmp > MAX_PHANDLE_ARGS) {
+		desc = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	gg_data.gpiospec.args_count = tmp;
+	gg_data.gpiospec.np = chip_np;
+	for (i = 0; i < tmp; i++) {
+		ret = of_property_read_u32(hog_np, "gpio",
+					   &gg_data.gpiospec.args[i]);
+		if (ret) {
+			desc = ERR_PTR(ret);
+			goto out;
+		}
+	}
+
+	gpiochip_find(&gg_data, of_gpiochip_find_and_xlate);
+	if (!gg_data.out_gpio) {
+		if (hog_np->parent == np)
+			desc = ERR_PTR(-ENXIO);
+		else
+			desc = ERR_PTR(-EPROBE_DEFER);
+
+		goto out;
+	}
+
+	if (xlate_flags & OF_GPIO_ACTIVE_LOW)
+		req_flags |= GPIOF_ACTIVE_LOW;
+
+	if (of_property_read_bool(hog_np, "hog-as-input")) {
+		req_flags |= GPIOF_DIR_IN;
+	} else if (of_property_read_bool(hog_np, "hog-as-output")) {
+		if (of_property_read_bool(hog_np, "hog-init-high")) {
+			req_flags |= GPIOF_INIT_HIGH;
+		} else if (!of_property_read_bool(hog_np, "hog-init-low")) {
+			desc = ERR_PTR(-EINVAL);
+			goto out;
+		}
+	} else {
+		desc = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	if (of_property_read_bool(hog_np, "open-drain-line"))
+		req_flags |= GPIOF_OPEN_DRAIN;
+
+	if (of_property_read_bool(hog_np, "open-source-line"))
+		req_flags |= GPIOF_OPEN_DRAIN;
+
+	if (of_property_read_bool(hog_np, "export-line"))
+		req_flags |= GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE;
+	else if (of_property_read_bool(hog_np, "export-line-fixed"))
+		req_flags |= GPIOF_EXPORT;
+
+	if (name && of_property_read_string(hog_np, "line-name", name))
+		*name = hog_np->name;
+
+	if (lnk_name) {
+		*lnk_name = NULL;
+		of_property_read_string_index(np, "gpio-hog-names", index, lnk_name);
+	}
+
+	if (flags)
+		*flags = req_flags;
+
+	desc = gg_data.out_gpio;
+
+out:
+	of_node_put(hog_np);
+
+	return desc;
+}
+EXPORT_SYMBOL(of_get_gpio_hog);
+
+/**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
  * @gc:		pointer to the gpio_chip structure
  * @np:		device node of the GPIO chip
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 85f772c..147b503 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1166,6 +1166,8 @@ int gpiochip_add(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 	int		base = chip->base;
+	struct gpio_desc	*desc;
+	int 		i;
 
 	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))
 			&& base >= 0) {
@@ -1214,6 +1216,17 @@ int gpiochip_add(struct gpio_chip *chip)
 
 	of_gpiochip_add(chip);
 
+	/* Instantiate missing GPIO hogs */
+	if (chip->dev->gpios) {
+		for (i = 0; i < chip->dev->gpios->ngpios; i++) {
+			if (chip->dev->gpios->gpios[i])
+				continue;
+			desc = devm_gpiod_get_hog_index(chip->dev, i);
+			if (!IS_ERR(desc))
+				chip->dev->gpios->gpios[i] = desc;
+		}
+	}
+
 	if (status)
 		goto fail;
 
@@ -2421,6 +2434,7 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 	struct gpio_desc *desc = NULL;
 	int status;
 	enum gpio_lookup_flags flags = 0;
+	int i;
 
 	dev_dbg(dev, "GPIO lookup for consumer %s\n", con_id);
 
@@ -2451,6 +2465,13 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 		return desc;
 	}
 
+	if (dev->gpios) {
+		for (i = 0; i < dev->gpios->ngpios; i++) {
+			if (dev->gpios->gpios[i] == desc)
+				return desc;
+		}
+	}
+
 	status = gpiod_request(desc, con_id);
 
 	if (status < 0)
@@ -2468,6 +2489,88 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 EXPORT_SYMBOL_GPL(gpiod_get_index);
 
 /**
+ * gpiod_get_hog_index - obtain a GPIO from a multi-index GPIO hog function
+ * @dev:	GPIO consumer
+ * @idx:	index of the GPIO to obtain in the consumer
+ *
+ * This should only be used by core device driver code to request GPIO hogs
+ * before probing a device.
+ *
+ * Return a valid GPIO descriptor, or an IS_ERR() condition in case of error.
+ */
+struct gpio_desc *__must_check gpiod_get_hog_index(struct device *dev,
+						   unsigned int idx)
+{
+	struct gpio_desc *desc = NULL;
+	int status;
+	unsigned long flags;
+	const char *name, *lnk_name;
+
+	/* Using device tree? */
+	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node) {
+		dev_dbg(dev, "using device tree for GPIO hog retrieval\n");
+		desc = of_get_gpio_hog(dev->of_node, idx, &name, &lnk_name,
+				       &flags);
+	}
+
+	if (!desc)
+		return ERR_PTR(-ENOTSUPP);
+	else if (IS_ERR(desc))
+		return desc;
+
+	status = gpio_request_one(desc_to_gpio(desc), flags, name);
+	if (status)
+		return ERR_PTR(status);
+
+	if (!lnk_name || !(flags & GPIOF_EXPORT))
+		return desc;
+
+	status = gpiod_export_link(dev, lnk_name, desc);
+	if (status) {
+		gpiod_free(desc);
+		return ERR_PTR(status);
+	}
+
+	return desc;
+}
+EXPORT_SYMBOL_GPL(gpiod_get_hog_index);
+
+static bool gpiod_is_hogged(struct device *dev, struct gpio_desc *desc)
+{
+	int i;
+
+	if (dev->gpios) {
+		for (i = 0; i < dev->gpios->ngpios; i++) {
+			if (dev->gpios->gpios[i] == desc)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+bool gpio_is_hogged(struct device *dev, unsigned gpio)
+{
+	return gpiod_is_hogged(dev, gpio_to_desc(gpio));
+}
+EXPORT_SYMBOL_GPL(gpio_is_hogged);
+
+/**
+ * gpio_hog_count - count number of GPIO hogs requested by a specific device
+ * @dev:	GPIO consumer
+ *
+ * Return the number of GPIO hogs.
+ */
+int gpio_hog_count(struct device *dev)
+{
+	/* Using device tree? */
+	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
+		return of_gpio_hog_count(dev->of_node);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gpio_hog_count);
+
+/**
  * gpiod_put - dispose of a GPIO descriptor
  * @desc:	GPIO descriptor to dispose of
  *
diff --git a/include/linux/device.h b/include/linux/device.h
index 952b010..df9ea62 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/pinctrl/devinfo.h>
+#include <linux/gpio/devinfo.h>
 #include <linux/pm.h>
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
@@ -744,6 +745,10 @@ struct device {
 	struct dev_pin_info	*pins;
 #endif
 
+#ifdef CONFIG_GPIOLIB
+	struct dev_gpio_info	*gpios;
+#endif
+
 #ifdef CONFIG_NUMA
 	int		numa_node;	/* NUMA node this device is close to */
 #endif
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index 4d34dbb..69d1e99 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -24,6 +24,10 @@ struct gpio_desc *__must_check gpiod_get(struct device *dev,
 struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 					       const char *con_id,
 					       unsigned int idx);
+struct gpio_desc *__must_check gpiod_get_hog_index(struct device *dev,
+						   unsigned int idx);
+int gpio_hog_count(struct device *dev);
+bool gpio_is_hogged(struct device *dev, unsigned gpio);
 void gpiod_put(struct gpio_desc *desc);
 
 struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
@@ -31,6 +35,8 @@ struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
 struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 						    const char *con_id,
 						    unsigned int idx);
+struct gpio_desc *__must_check devm_gpiod_get_hog_index(struct device *dev,
+							unsigned int idx);
 void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
 
 int gpiod_get_direction(const struct gpio_desc *desc);
@@ -74,6 +80,19 @@ static inline struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 {
 	return ERR_PTR(-ENOSYS);
 }
+static inline struct gpio_desc *__must_check
+gpiod_get_hog_index(struct device *dev, unsigned int idx)
+{
+	return ERR_PTR(-ENOSYS);
+}
+static inline int gpio_hog_count(struct device *dev)
+{
+	return 0;
+}
+static inline bool gpio_is_hogged(struct device *dev, unsigned gpio)
+{
+	return false;
+}
 static inline void gpiod_put(struct gpio_desc *desc)
 {
 	might_sleep();
@@ -94,6 +113,12 @@ struct gpio_desc *__must_check devm_gpiod_get_index(struct device *dev,
 {
 	return ERR_PTR(-ENOSYS);
 }
+static inline
+struct gpio_desc *__must_check devm_gpiod_get_hog_index(struct device *dev,
+							unsigned int idx)
+{
+	return ERR_PTR(-ENOSYS);
+}
 static inline void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
 {
 	might_sleep();
diff --git a/include/linux/gpio/devinfo.h b/include/linux/gpio/devinfo.h
new file mode 100644
index 0000000..010c59b
--- /dev/null
+++ b/include/linux/gpio/devinfo.h
@@ -0,0 +1,38 @@
+/*
+ * Per-device information from the GPIO system.
+ * This is the stuff that get included into the device
+ * core.
+ *
+ * Copyright (C) Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * Author: Boris BREZILLON <b.brezillon@overkiz.com>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef GPIO_DEVINFO_H
+#define GPIO_DEVINFO_H
+
+#ifdef CONFIG_GPIOLIB
+
+/* The device core acts as a consumer toward GPIO */
+#include <linux/gpio/consumer.h>
+
+struct dev_gpio_info {
+	int ngpios;
+	struct gpio_desc *gpios[0];
+};
+
+extern int gpio_get_hogs(struct device *dev);
+
+#else
+
+/* Stubs if we're not using GPIO hogs */
+
+static inline int gpio_get_hogs(struct device *dev)
+{
+	return 0;
+}
+
+#endif /* CONFIG_GPIOLIB */
+#endif /* GPIO_DEVINFO_H */
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index f14123a..43f7f86 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -60,6 +60,11 @@ extern int of_gpio_simple_xlate(struct gpio_chip *gc,
 				const struct of_phandle_args *gpiospec,
 				u32 *flags);
 
+extern int of_gpio_hog_count(struct device_node *np);
+extern struct gpio_desc *of_get_gpio_hog(struct device_node *np, int index,
+					 const char **name,
+					 const char **lnk_name,
+					 unsigned long *flags);
 #else /* CONFIG_OF_GPIO */
 
 /* Drivers may not strictly depend on the GPIO support, so let them link. */
@@ -79,6 +84,20 @@ static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
 static inline void of_gpiochip_add(struct gpio_chip *gc) { }
 static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 
+static inline int of_gpio_hog_count(struct device_node *np)
+{
+	return 0;
+}
+
+static inline struct gpio_desc *of_get_gpio_hog(struct device_node *np,
+						int index,
+						const char **name,
+						const char **lnk_name,
+						unsigned long *flags)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 #endif /* CONFIG_OF_GPIO */
 
 static inline int of_get_named_gpio_flags(struct device_node *np,
-- 
1.7.9.5

