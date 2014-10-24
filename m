Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaJXVo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:44:59 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59831 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752197AbaJXVo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:44:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
Date: Sat, 25 Oct 2014 00:05:26 +0200
Message-ID: <2758495.RYBbleVHkC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1971306.rIA5QAW7ve@vostro.rjw.lan>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com> <20141024073436.GN1484@lahna.fi.intel.com> <1971306.rIA5QAW7ve@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Provide a way for device drivers using GPIOs described by ACPI
GpioIo resources in _CRS to tell the GPIO subsystem what names
(connection IDs) to associate with specific GPIO pins defined
in there.

To do that, a driver needs to define a mapping table as a
NULL-terminated array of struct acpi_gpio_mapping objects
that each contain a name, a pointer to an array of pin data
(struct acpi_gpio_params) objects and the size of that array.

Each struct acpi_gpio_params object consists of three fields,
crs_entry_index, pin_index, active_low, representing the index of
the target GpioIo()/GpioInt() resource in _CRS starting from zero,
the index of the target pin in that resource starting from zero,
and the active-low flag for that pin, respectively.

Next, the mapping table needs to be passed as the second argument to
acpi_dev_add_driver_gpios() that will register it with the ACPI device
object pointed to by its first argument.  That object must represent
the ACPI namespace node containing the _CRS object referred to by the
GPIO mapping.  That should be done in the driver's .probe() routine.

On removal, the driver should unregister its GPIO mapping table
by calling acpi_dev_remove_driver_gpios() on the ACPI device
object where that table was previously registered.

Included are fixes from Mika Westerberg.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of the device-properties branch of the linux-pm.git tree at kernel.org.

---
 drivers/gpio/gpiolib-acpi.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 include/acpi/acpi_bus.h     |    3 +++
 include/linux/acpi.h        |   30 ++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+), 2 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -345,6 +345,8 @@ struct acpi_device_data {
 	const union acpi_object *of_compatible;
 };
 
+struct acpi_gpio_mapping;
+
 /* Device */
 struct acpi_device {
 	int device_type;
@@ -366,6 +368,7 @@ struct acpi_device {
 	struct acpi_scan_handler *handler;
 	struct acpi_hotplug_context *hp;
 	struct acpi_driver *driver;
+	const struct acpi_gpio_mapping *driver_gpios;
 	void *driver_data;
 	struct device dev;
 	unsigned int physical_node_count;
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -672,6 +672,36 @@ do {									\
 #endif
 #endif
 
+struct acpi_gpio_params {
+	unsigned int crs_entry_index;
+	unsigned int pin_index;
+	bool active_low;
+};
+
+struct acpi_gpio_mapping {
+	const char *name;
+	const struct acpi_gpio_params *data;
+	unsigned int size;
+};
+
+#if defined(CONFIG_ACPI) && defined(CONFIG_GPIOLIB)
+int acpi_dev_add_driver_gpios(struct acpi_device *adev,
+			      const struct acpi_gpio_mapping *gpios);
+
+static inline void acpi_dev_remove_driver_gpios(struct acpi_device *adev)
+{
+	if (adev)
+		adev->driver_gpios = NULL;
+}
+#else
+static inline int acpi_dev_add_driver_gpios(struct acpi_device *adev,
+			      const struct acpi_gpio_mapping *gpios)
+{
+	return -ENXIO;
+}
+static inline void acpi_dev_remove_driver_gpios(struct acpi_device *adev) {}
+#endif
+
 /* Device properties */
 
 #define MAX_ACPI_REFERENCE_ARGS	8
Index: linux-pm/drivers/gpio/gpiolib-acpi.c
===================================================================
--- linux-pm.orig/drivers/gpio/gpiolib-acpi.c
+++ linux-pm/drivers/gpio/gpiolib-acpi.c
@@ -287,6 +287,41 @@ void acpi_gpiochip_free_interrupts(struc
 	}
 }
 
+int acpi_dev_add_driver_gpios(struct acpi_device *adev,
+			      const struct acpi_gpio_mapping *gpios)
+{
+	if (adev && gpios) {
+		adev->driver_gpios = gpios;
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_add_driver_gpios);
+
+static bool acpi_get_driver_gpio_data(struct acpi_device *adev,
+				      const char *name, int index,
+				      struct acpi_reference_args *args)
+{
+	const struct acpi_gpio_mapping *gm;
+
+	if (!adev->driver_gpios)
+		return false;
+
+	for (gm = adev->driver_gpios; gm->name; gm++)
+		if (!strcmp(name, gm->name) && gm->data && index < gm->size) {
+			const struct acpi_gpio_params *par = gm->data + index;
+
+			args->adev = adev;
+			args->args[0] = par->crs_entry_index;
+			args->args[1] = par->pin_index;
+			args->args[2] = par->active_low;
+			args->nargs = 3;
+			return true;
+		}
+
+	return false;
+}
+
 struct acpi_gpio_lookup {
 	struct acpi_gpio_info info;
 	int index;
@@ -372,8 +407,12 @@ struct gpio_desc *acpi_get_gpiod_by_inde
 		memset(&args, 0, sizeof(args));
 		ret = acpi_dev_get_property_reference(adev, propname, NULL,
 						      index, &args);
-		if (ret)
-			return ERR_PTR(ret);
+		if (ret) {
+			bool found = acpi_get_driver_gpio_data(adev, propname,
+							       index, &args);
+			if (!found)
+				return ERR_PTR(ret);
+		}
 
 		/*
 		 * The property was found and resolved so need to

