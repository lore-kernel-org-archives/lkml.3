Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbaJVXAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:00:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49327 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933269AbaJVXAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:00:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: GPIO bindings guidelines (Was: Re: [PATCH v5 10/12] gpio: Support for unified device properties interface)
Date: Thu, 23 Oct 2014 01:21:06 +0200
Message-ID: <13758254.acHP1NJN1b@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141022145651.GH1484@lahna.fi.intel.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com> <1971792.8pKYWlGxB9@vostro.rjw.lan> <20141022145651.GH1484@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 22, 2014 05:56:51 PM Mika Westerberg wrote:
> On Wed, Oct 22, 2014 at 04:07:08PM +0200, Rafael J. Wysocki wrote:
> > Moreover, we need to clarify what situation we're really talking about.
> > 
> > For one, drivers using the unified interface only will always use names for
> > GPIOs, because they have to assume that either a DT or ACPI w/ _DSD is present.
> > This is the cost of keeping those drivers firmware interface agnostic.
> > 
> > So it looks like we're not talking about this case here.
> 
> We are talking about the case of rfkill-gpio.c where it definitely wants
> to use properties for the GPIOs but it cannot be sure if the underlying
> firmware provides _DSD or not.
> 
> > Now, if there's no DT or no _DSD in the ACPI tables for the given device
> > *and* the driver wants to use its GPIOs anyway, it has to be ACPI-aware to
> > some extent, because in that case the device ID it has been matched against
> > tells it what the meaning of the GpioIo resources in the _CRS is.
> > 
> > Then, the driver needs to do something like:
> > 
> > 	if (!device_property_present(dev, "known_property_that_should_be_present")
> > 	    && ACPI_COMPANION(dev))
> > 		acpi_probe_gpios(dev);
> 
> Indeed we can use similar pattern to detect if we have _DSD present or
> not.
> 
> > and in the acpi_probe_gpios() routine there may be checks like:
> > 
> > 	if (device_has_id(dev, "MARY0001")) {
> > 		The first pin in the first GpioIo resource in _CRS is "fred" and
> > 		it is active-low.
> > 		The third pin in the second GpioIo resource in _CRS is "steve"
> > 		and it is not active-low.
> > 	} else if (device_has_id(dev, "JANE0002")) {
> > 		The first pin in the second GpioIo resource in _CRS is "fred" and
> > 		it is not active-low.
> > 		The second pin in the first GpioIo resource in _CRS is "steve"
> > 		and it is active-low.
> > 	}
> > 
> > and so on.  Of course, there may be drivers knowing that the meaning of the
> > GpioIo resources in _CRS is the same for all devices handled by them, in which
> > case they will not need to check device IDs, but the core has now way of
> > knowing that.  Only the drivers have that information and the core has now
> > way to figure out what to do for a given specific device.
> > 
> > So here's a radical idea: Why don't we introduce something like
> > 
> > 	acpi_enumerate_gpio(dev, name, GpioIo_index, pin_index, active_low)
> > 
> > such that after calling, say, acpi_enumerate_gpio(dev, "fred", 0, 0, true) the
> > driver can do something like:
> > 
> > 	desc = get_gpiod_by_name(dev, "fred");
> > 
> > and it'll all work.  Then, the only part of the driver that really needs to be
> > ACPI-specific will be the acpi_probe_gpios() function calling acpi_enumerate_gpio()
> > in accordance with what the device ID is.
> > 
> > Thoughts?
> 
> I think this is good idea. It solves the rfkill-gpio.c problem with just
> small amount of ACPI specific code.

OK, would the below make sense, then (completely untested, on top of the v6
of the device properties patchset)?

Rafael


---
 drivers/acpi/scan.c         |    2 +
 drivers/gpio/gpiolib-acpi.c |   80 ++++++++++++++++++++++++++++++++++++++++++--
 include/acpi/acpi_bus.h     |    1 
 include/linux/acpi.h        |   15 ++++++++
 4 files changed, 96 insertions(+), 2 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -355,6 +355,7 @@ struct acpi_device {
 	struct list_head node;
 	struct list_head wakeup_list;
 	struct list_head del_list;
+	struct list_head driver_gpios;
 	struct acpi_device_status status;
 	struct acpi_device_flags flags;
 	struct acpi_device_pnp pnp;
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -672,6 +672,21 @@ do {									\
 #endif
 #endif
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_GPIOLIB)
+int acpi_dev_add_driver_gpio(struct acpi_device *adev, const char *propname,
+			     int entry_index, int pin_index, bool active_low);
+void acpi_dev_remove_driver_gpios(struct acpi_device *adev);
+#else
+static inline int acpi_dev_add_driver_gpio(struct acpi_device *adev,
+					   const char *propname,
+					   int entry_index, int pin_index,
+					   bool active_low)
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
@@ -47,6 +47,16 @@ struct acpi_gpio_chip {
 	struct list_head events;
 };
 
+struct acpi_gpio_data {
+	struct list_head item;
+	char *name;
+	int entry_index;
+	int pin_index;
+	bool active_low;
+};
+
+static DEFINE_MUTEX(driver_gpio_data_lock);
+
 static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
 {
 	if (!gc->dev)
@@ -287,6 +297,70 @@ void acpi_gpiochip_free_interrupts(struc
 	}
 }
 
+int acpi_dev_add_driver_gpio(struct acpi_device *adev, const char *propname,
+			     int entry_index, int pin_index, bool active_low)
+{
+	struct acpi_gpio_data *gd;
+
+	if (!propname)
+		return -EINVAL;
+
+	gd = kzalloc(sizeof(*gd), GFP_KERNEL);
+	if (!gd)
+		return -ENOMEM;
+
+	gd->name = kstrdup(propname, GFP_KERNEL);
+	if (!gd->name) {
+		kfree(gd);
+		return -ENOMEM;
+	}
+	gd->entry_index = entry_index;
+	gd->pin_index = pin_index;
+	gd->active_low = active_low;
+
+	mutex_lock(&driver_gpio_data_lock);
+	list_add_tail(&gd->item, &adev->driver_gpios);
+	mutex_unlock(&driver_gpio_data_lock);
+
+	return 0;
+}
+
+void acpi_dev_remove_driver_gpios(struct acpi_device *adev)
+{
+	struct acpi_gpio_data *gd, *next;
+
+	mutex_lock(&driver_gpio_data_lock);
+	list_for_each_entry_safe(gd, next, &adev->driver_gpios, item) {
+		list_del(&gd->item);
+		kfree(gd->name);
+		kfree(gd);
+	}
+	mutex_unlock(&driver_gpio_data_lock);
+}
+
+static bool acpi_get_driver_gpio_data(struct acpi_device *adev,
+				      const char *name,
+				      struct acpi_reference_args *args)
+{
+	struct acpi_gpio_data *gd;
+
+	mutex_lock(&driver_gpio_data_lock);
+
+	list_for_each_entry(gd, &adev->driver_gpios, item)
+		if (!strcmp(name, gd->name)) {
+			args->adev = adev;
+			args->args[0] = gd->entry_index;
+			args->args[1] = gd->pin_index;
+			args->args[2] = gd->active_low;
+			args->nargs = 3;
+			return true;
+		}
+
+	mutex_unlock(&driver_gpio_data_lock);
+
+	return false;
+}
+
 struct acpi_gpio_lookup {
 	struct acpi_gpio_info info;
 	int index;
@@ -372,8 +446,10 @@ struct gpio_desc *acpi_get_gpiod_by_inde
 		memset(&args, 0, sizeof(args));
 		ret = acpi_dev_get_property_reference(adev, propname, NULL,
 						      index, &args);
-		if (ret)
-			return ERR_PTR(ret);
+		if (ret) {
+			if (!acpi_get_driver_gpio_data(adev, propname, &args))
+				return ERR_PTR(ret);
+		}
 
 		/*
 		 * The property was found and resolved so need to
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1284,6 +1284,7 @@ int acpi_device_add(struct acpi_device *
 	INIT_LIST_HEAD(&device->wakeup_list);
 	INIT_LIST_HEAD(&device->physical_node_list);
 	INIT_LIST_HEAD(&device->del_list);
+	INIT_LIST_HEAD(&device->driver_gpios);
 	mutex_init(&device->physical_node_lock);
 
 	new_bus_id = kzalloc(sizeof(struct acpi_device_bus_id), GFP_KERNEL);
@@ -2354,6 +2355,7 @@ void acpi_bus_trim(struct acpi_device *a
 	} else {
 		device_release_driver(&adev->dev);
 	}
+	acpi_dev_remove_driver_gpios(adev);
 	/*
 	 * Most likely, the device is going away, so put it into D3cold before
 	 * that.

