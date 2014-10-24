Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaJXHer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:34:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:47585 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753587AbaJXHep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:34:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="405257576"
Date: Fri, 24 Oct 2014 10:34:36 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
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
Subject: Re: GPIO bindings guidelines (Was: Re: [PATCH v5 10/12] gpio:
 Support for unified device properties interface)
Message-ID: <20141024073436.GN1484@lahna.fi.intel.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <13758254.acHP1NJN1b@vostro.rjw.lan>
 <20141023125655.GJ1484@lahna.fi.intel.com>
 <1581499.2RkCnyfbq6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581499.2RkCnyfbq6@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 11:51:59PM +0200, Rafael J. Wysocki wrote:
> OK, let's try to take that a bit farther. :-)
> 
> With the (untested) patch below applied (which is a replacement for the one
> sent previously), the driver can use static tables like these:
> 
> static struct acpi_gpio_params reset_gpios = { 0, 0, false };
> statuc struct acpi_gpio_params shutdown_gpios = { 1, 0, false };
> 
> static struct acpi_gpio_mapping my_gpio_mapping[] = {
> 	{ "reset-gpios", &reset_gpios, 1 },
> 	{ "shutdown-gpios", &shutdown_gpios, 1 },
> 	NULL,
> };
> 

This is even better :-)

I tried this with few changes:

 - constify the mapping parameter
 - check for NULL adev->driver_gpios in acpi_get_driver_gpio_data()
 - check for gm->name instead of gm in acpi_get_driver_gpio_data()

It works just fine. For reference here are my changes to rkill-gpio.c:

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 0f62326c0f5e..ec8f5ac53520 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -63,6 +63,15 @@ static const struct rfkill_ops rfkill_gpio_ops = {
 	.set_block = rfkill_gpio_set_power,
 };
 
+static const struct acpi_gpio_params reset_gpios = { 0, 0, false };
+static const struct acpi_gpio_params shutdown_gpios = { 1, 0, false };
+
+static const struct acpi_gpio_mapping acpi_rfkill_default_gpios[] = {
+	{ "reset-gpios", &reset_gpios, 1 },
+	{ "shutdown-gpios", &shutdown_gpios, 1 },
+	{ },
+};
+
 static int rfkill_gpio_acpi_probe(struct device *dev,
 				  struct rfkill_gpio_data *rfkill)
 {
@@ -75,7 +84,8 @@ static int rfkill_gpio_acpi_probe(struct device *dev,
 	rfkill->name = dev_name(dev);
 	rfkill->type = (unsigned)id->driver_data;
 
-	return 0;
+	return acpi_dev_add_driver_gpios(ACPI_COMPANION(dev),
+					 acpi_rfkill_default_gpios);
 }
 
 static int rfkill_gpio_probe(struct platform_device *pdev)
@@ -110,7 +120,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 		rfkill->reset_gpio = gpio;
 	}
 
-	gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 1);
+	gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 0);
 	if (!IS_ERR(gpio)) {
 		ret = gpiod_direction_output(gpio, 0);
 		if (ret)
@@ -150,6 +160,8 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
 	rfkill_unregister(rfkill->rfkill_dev);
 	rfkill_destroy(rfkill->rfkill_dev);
 
+	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&pdev->dev));
+
 	return 0;
 }
 
And here are the changes on top of your patch:

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 691501b53c5e..4151cd774f2f 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -288,7 +288,7 @@ void acpi_gpiochip_free_interrupts(struct gpio_chip *chip)
 }
 
 int acpi_dev_add_driver_gpios(struct acpi_device *adev,
-			      struct acpi_gpio_mapping *gpios)
+			      const struct acpi_gpio_mapping *gpios)
 {
 	if (adev && gpios) {
 		adev->driver_gpios = gpios;
@@ -302,11 +302,14 @@ static bool acpi_get_driver_gpio_data(struct acpi_device *adev,
 				      const char *name, int index,
 				      struct acpi_reference_args *args)
 {
-	struct acpi_gpio_mapping *gm;
+	const struct acpi_gpio_mapping *gm;
 
-	for (gm = adev->driver_gpios; gm; gm++)
+	if (!adev->driver_gpios)
+		return false;
+
+	for (gm = adev->driver_gpios; gm->name; gm++)
 		if (!strcmp(name, gm->name) && gm->data && index < gm->size) {
-			struct acpi_gpio_params *par = gm->data + index;
+			const struct acpi_gpio_params *par = gm->data + index;
 
 			args->adev = adev;
 			args->args[0] = par->crs_entry_index;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 2de7a2614c61..98d992062270 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -368,7 +368,7 @@ struct acpi_device {
 	struct acpi_scan_handler *handler;
 	struct acpi_hotplug_context *hp;
 	struct acpi_driver *driver;
-	struct acpi_gpio_mapping *driver_gpios;
+	const struct acpi_gpio_mapping *driver_gpios;
 	void *driver_data;
 	struct device dev;
 	unsigned int physical_node_count;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 26b7a639f4b9..23f9c55d0331 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -680,13 +680,13 @@ struct acpi_gpio_params {
 
 struct acpi_gpio_mapping {
 	const char *name;
-	struct acpi_gpio_params *data;
+	const struct acpi_gpio_params *data;
 	unsigned int size;
 };
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_GPIOLIB)
 int acpi_dev_add_driver_gpios(struct acpi_device *adev,
-			      struct acpi_gpio_mapping *gpios);
+			      const struct acpi_gpio_mapping *gpios);
 
 static inline void acpi_dev_remove_driver_gpios(struct acpi_device *adev)
 {
@@ -695,7 +695,7 @@ static inline void acpi_dev_remove_driver_gpios(struct acpi_device *adev)
 }
 #else
 static inline int acpi_dev_add_driver_gpios(struct acpi_device *adev,
-			      struct acpi_gpio_mapping *gpios)
+			      const struct acpi_gpio_mapping *gpios)
 {
 	return -ENXIO;
 }
