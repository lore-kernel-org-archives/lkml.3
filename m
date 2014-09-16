Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaIPLxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:53:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:4933 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbaIPLxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:53:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="573795146"
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
Subject: [RFC PATCH v2 06/16] gpio / ACPI: Add support for _DSD device properties
Date: Tue, 16 Sep 2014 14:52:37 +0300
Message-Id: <1410868367-11056-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With release of ACPI 5.1 and _DSD method we can finally name GPIOs (and
other things as well) returned by _CRS. Previously we were only able to
use integer index to find the corresponding GPIO, which is pretty error
prone if the order changes.

With _DSD we can now query GPIOs using name instead of an integer index,
like the below example shows:

  // Bluetooth device with reset and shutdown GPIOs
  Device (BTH)
  {
      Name (_HID, ...)

      Name (_CRS, ResourceTemplate ()
      {
          GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
                  "\\_SB.GPO0", 0, ResourceConsumer) {15}
          GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
                  "\\_SB.GPO0", 0, ResourceConsumer) {27, 31}
      })

      Name (_DSD, Package ()
      {
          ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
          Package ()
	  {
              Package () {"reset-gpio", Package() {^BTH, 1, 1, 0 }},
              Package () {"shutdown-gpio", Package() {^BTH, 0, 0, 0 }},
          }
      })
  }

The format of the supported GPIO property is:

  Package () { "name", Package () { ref, index, pin, active_low }}

  ref - The device that has _CRS containing GpioIo()/GpioInt() resources,
        typically this is the device itself (BTH in our case).
  index - Index of the GpioIo()/GpioInt() resource in _CRS starting from zero.
  pin - Pin in the GpioIo()/GpioInt() resource. Typically this is zero.
  active_low - If 1 the GPIO is marked as active_low.

Since ACPI GpioIo() resource does not have field saying whether it is
active low or high, the "active_low" argument can be used here. Setting
it to 1 marks the GPIO as active low.

In our Bluetooth example the "reset-gpio" refers to the second GpioIo()
resource, second pin in that resource with the GPIO number of 31.

This patch implements necessary support to gpiolib for extracting GPIOs
using _DSD device properties.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpiolib-acpi.c | 78 +++++++++++++++++++++++++++++++++++++--------
 drivers/gpio/gpiolib.c      | 30 ++++++++++++++---
 drivers/gpio/gpiolib.h      |  7 ++--
 3 files changed, 94 insertions(+), 21 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index d62eaaa75397..9212cde087b0 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -293,6 +293,7 @@ void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
 struct acpi_gpio_lookup {
 	struct acpi_gpio_info info;
 	int index;
+	int pin_index;
 	struct gpio_desc *desc;
 	int n;
 };
@@ -306,13 +307,24 @@ static int acpi_find_gpio(struct acpi_resource *ares, void *data)
 
 	if (lookup->n++ == lookup->index && !lookup->desc) {
 		const struct acpi_resource_gpio *agpio = &ares->data.gpio;
+		int pin_index = lookup->pin_index;
+
+		if (pin_index >= agpio->pin_table_length)
+			return 1;
 
 		lookup->desc = acpi_get_gpiod(agpio->resource_source.string_ptr,
-					      agpio->pin_table[0]);
+					      agpio->pin_table[pin_index]);
 		lookup->info.gpioint =
 			agpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT;
-		lookup->info.active_low =
-			agpio->polarity == ACPI_ACTIVE_LOW;
+
+		/*
+		 * ActiveLow is only specified for GpioInt resource. If
+		 * GpioIo is used then the only way to set the flag is
+		 * to use _DSD "gpios" property.
+		 */
+		if (lookup->info.gpioint)
+			lookup->info.active_low =
+				agpio->polarity == ACPI_ACTIVE_LOW;
 	}
 
 	return 1;
@@ -320,40 +332,75 @@ static int acpi_find_gpio(struct acpi_resource *ares, void *data)
 
 /**
  * acpi_get_gpiod_by_index() - get a GPIO descriptor from device resources
- * @dev: pointer to a device to get GPIO from
+ * @adev: pointer to a ACPI device to get GPIO from
+ * @propname: Property name of the GPIO (optional)
  * @index: index of GpioIo/GpioInt resource (starting from %0)
  * @info: info pointer to fill in (optional)
  *
- * Function goes through ACPI resources for @dev and based on @index looks
+ * Function goes through ACPI resources for @adev and based on @index looks
  * up a GpioIo/GpioInt resource, translates it to the Linux GPIO descriptor,
  * and returns it. @index matches GpioIo/GpioInt resources only so if there
  * are total %3 GPIO resources, the index goes from %0 to %2.
  *
+ * If @propname is specified the GPIO is looked using device property. In
+ * that case @index is used to select the GPIO entry in the property value
+ * (in case of multiple).
+ *
  * If the GPIO cannot be translated or there is an error an ERR_PTR is
  * returned.
  *
  * Note: if the GPIO resource has multiple entries in the pin list, this
  * function only returns the first.
  */
-struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
+struct gpio_desc *acpi_get_gpiod_by_index(struct acpi_device *adev,
+					  const char *propname, int index,
 					  struct acpi_gpio_info *info)
 {
 	struct acpi_gpio_lookup lookup;
 	struct list_head resource_list;
-	struct acpi_device *adev;
-	acpi_handle handle;
+	bool active_low = false;
 	int ret;
 
-	if (!dev)
-		return ERR_PTR(-EINVAL);
-
-	handle = ACPI_HANDLE(dev);
-	if (!handle || acpi_bus_get_device(handle, &adev))
+	if (!adev)
 		return ERR_PTR(-ENODEV);
 
 	memset(&lookup, 0, sizeof(lookup));
 	lookup.index = index;
 
+	if (propname) {
+		struct acpi_reference_args args;
+
+		dev_dbg(&adev->dev, "GPIO: looking up %s\n", propname);
+
+		memset(&args, 0, sizeof(args));
+		ret = acpi_dev_get_property_reference(adev, propname, NULL,
+						      index, &args);
+		if (ret)
+			return ERR_PTR(ret);
+
+		/*
+		 * The property was found and resolved so need to
+		 * lookup the GPIO based on returned args instead.
+		 */
+		adev = args.adev;
+		if (args.nargs >= 2) {
+			lookup.index = args.args[0];
+			lookup.pin_index = args.args[1];
+			/*
+			 * 3rd argument, if present is used to
+			 * specify active_low.
+			 */
+			if (args.nargs >= 3)
+				active_low = !!args.args[2];
+		}
+
+		dev_dbg(&adev->dev, "GPIO: _DSD returned %s %zd %llu %llu %llu\n",
+			dev_name(&adev->dev), args.nargs,
+			args.args[0], args.args[1], args.args[2]);
+	} else {
+		dev_dbg(&adev->dev, "GPIO: looking up %d in _CRS\n", index);
+	}
+
 	INIT_LIST_HEAD(&resource_list);
 	ret = acpi_dev_get_resources(adev, &resource_list, acpi_find_gpio,
 				     &lookup);
@@ -362,8 +409,11 @@ struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
 
 	acpi_dev_free_resource_list(&resource_list);
 
-	if (lookup.desc && info)
+	if (lookup.desc && info) {
 		*info = lookup.info;
+		if (active_low)
+			info->active_low = active_low;
+	}
 
 	return lookup.desc ? lookup.desc : ERR_PTR(-ENOENT);
 }
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 15cc0bb65dda..444d43c9fd3e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1487,14 +1487,36 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
 					unsigned int idx,
 					enum gpio_lookup_flags *flags)
 {
+	static const char * const suffixes[] = { "gpios", "gpio" };
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct acpi_gpio_info info;
 	struct gpio_desc *desc;
+	char propname[32];
+	int i;
 
-	desc = acpi_get_gpiod_by_index(dev, idx, &info);
-	if (IS_ERR(desc))
-		return desc;
+	/* Try first from _DSD */
+	for (i = 0; i < ARRAY_SIZE(suffixes); i++) {
+		if (con_id && strcmp(con_id, "gpios")) {
+			snprintf(propname, sizeof(propname), "%s-%s",
+				 con_id, suffixes[i]);
+		} else {
+			snprintf(propname, sizeof(propname), "%s",
+				 suffixes[i]);
+		}
+
+		desc = acpi_get_gpiod_by_index(adev, propname, 0, &info);
+		if (!IS_ERR(desc) || (PTR_ERR(desc) == -EPROBE_DEFER))
+			break;
+	}
+
+	/* Then from plain _CRS GPIOs */
+	if (IS_ERR(desc)) {
+		desc = acpi_get_gpiod_by_index(adev, NULL, idx, &info);
+		if (IS_ERR(desc))
+			return desc;
+	}
 
-	if (info.gpioint && info.active_low)
+	if (info.active_low)
 		*flags |= GPIO_ACTIVE_LOW;
 
 	return desc;
diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
index 9db2b6a71c5d..e3a52113a541 100644
--- a/drivers/gpio/gpiolib.h
+++ b/drivers/gpio/gpiolib.h
@@ -34,7 +34,8 @@ void acpi_gpiochip_remove(struct gpio_chip *chip);
 void acpi_gpiochip_request_interrupts(struct gpio_chip *chip);
 void acpi_gpiochip_free_interrupts(struct gpio_chip *chip);
 
-struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
+struct gpio_desc *acpi_get_gpiod_by_index(struct acpi_device *adev,
+					  const char *propname, int index,
 					  struct acpi_gpio_info *info);
 #else
 static inline void acpi_gpiochip_add(struct gpio_chip *chip) { }
@@ -47,8 +48,8 @@ static inline void
 acpi_gpiochip_free_interrupts(struct gpio_chip *chip) { }
 
 static inline struct gpio_desc *
-acpi_get_gpiod_by_index(struct device *dev, int index,
-			struct acpi_gpio_info *info)
+acpi_get_gpiod_by_index(struct acpi_device *adev, const char *propname,
+			int index, struct acpi_gpio_info *info)
 {
 	return ERR_PTR(-ENOSYS);
 }
-- 
2.1.0

