Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaJWVbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:31:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63842 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751718AbaJWVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:31:32 -0400
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
Date: Thu, 23 Oct 2014 23:51:59 +0200
Message-ID: <1581499.2RkCnyfbq6@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141023125655.GJ1484@lahna.fi.intel.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com> <13758254.acHP1NJN1b@vostro.rjw.lan> <20141023125655.GJ1484@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 23, 2014 03:56:55 PM Mika Westerberg wrote:
> On Thu, Oct 23, 2014 at 01:21:06AM +0200, Rafael J. Wysocki wrote:
> > OK, would the below make sense, then (completely untested, on top of the v6
> > of the device properties patchset)?
> 
> Yes it does :-)
> 
> With the the below fix it works nicely with the modified rfkill-gpio.c
> driver.
> 
> > +static bool acpi_get_driver_gpio_data(struct acpi_device *adev,
> > +				      const char *name,
> > +				      struct acpi_reference_args *args)
> > +{
> > +	struct acpi_gpio_data *gd;
> > +
> > +	mutex_lock(&driver_gpio_data_lock);
> > +
> > +	list_for_each_entry(gd, &adev->driver_gpios, item)
> > +		if (!strcmp(name, gd->name)) {
> > +			args->adev = adev;
> > +			args->args[0] = gd->entry_index;
> > +			args->args[1] = gd->pin_index;
> > +			args->args[2] = gd->active_low;
> > +			args->nargs = 3;
> 
> 			mutex_unlock(&driver_gpio_data_lock);
> 
> > +			return true;
> > +		}
> > +
> > +	mutex_unlock(&driver_gpio_data_lock);
> > +
> > +	return false;
> > +}
> 
> Also I think the two functions should be exported to modules as well.
> 
> Here are the modifications needed for rfkill-gpio.c driver. I think it
> is not that bad considering that now the driver supports both ACPI _DSD
> and non-_DSD at the same time.

OK, let's try to take that a bit farther. :-)

With the (untested) patch below applied (which is a replacement for the one
sent previously), the driver can use static tables like these:

static struct acpi_gpio_params reset_gpios = { 0, 0, false };
statuc struct acpi_gpio_params shutdown_gpios = { 1, 0, false };

static struct acpi_gpio_mapping my_gpio_mapping[] = {
	{ "reset-gpios", &reset_gpios, 1 },
	{ "shutdown-gpios", &shutdown_gpios, 1 },
	NULL,
};

->

> 
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index 0f62326c0f5e..f8754e7d81ea 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -67,6 +67,8 @@ static int rfkill_gpio_acpi_probe(struct device *dev,
>  				  struct rfkill_gpio_data *rfkill)
>  {
>  	const struct acpi_device_id *id;
> +	struct acpi_device *adev = ACPI_COMPANION(dev);
> +	int ret;
>  
>  	id = acpi_match_device(dev->driver->acpi_match_table, dev);
>  	if (!id)
> @@ -75,6 +77,20 @@ static int rfkill_gpio_acpi_probe(struct device *dev,
>  	rfkill->name = dev_name(dev);
>  	rfkill->type = (unsigned)id->driver_data;
>  
> +	/*
> +	 * Add default mapping for ACPI _DSD properties now just in case
> +	 * there is no _DSD for this device.
> +	 */
> +	ret = acpi_dev_add_driver_gpio(adev, "reset-gpios", 0, 0, false);
> +	if (ret)
> +		return ret;
> +
> +	ret = acpi_dev_add_driver_gpio(adev, "shutdown-gpios", 1, 0, false);
> +	if (ret) {
> +		acpi_dev_remove_driver_gpios(adev);
> +		return ret;
> +	}

-> and then simply do

	ret = acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), &my_gpio_mapping);

instead of the above.

>  	return 0;
>  }
>  
> @@ -110,7 +126,7 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
>  		rfkill->reset_gpio = gpio;
>  	}
>  
> -	gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 1);
> +	gpio = devm_gpiod_get_index(&pdev->dev, "shutdown", 0);
>  	if (!IS_ERR(gpio)) {
>  		ret = gpiod_direction_output(gpio, 0);
>  		if (ret)
> @@ -150,6 +166,9 @@ static int rfkill_gpio_remove(struct platform_device *pdev)
>  	rfkill_unregister(rfkill->rfkill_dev);
>  	rfkill_destroy(rfkill->rfkill_dev);
>  
> +	if (ACPI_COMPANION(&pdev->dev))
> +		acpi_dev_remove_driver_gpios(ACPI_COMPANION(&pdev->dev));
> +

And here simply 

	acpi_dev_remove_driver_gpios(ACPI_COMPANION(&pdev->dev));

>  	return 0;
>  }

and then we can even cover situations in which there is one name for a list of
GPIOs.

Rafael


---
 drivers/gpio/gpiolib-acpi.c |   40 ++++++++++++++++++++++++++++++++++++++--
 include/acpi/acpi_bus.h     |    3 +++
 include/linux/acpi.h        |   30 ++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+), 2 deletions(-)

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
+	struct acpi_gpio_mapping *driver_gpios;
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
+	struct acpi_gpio_params *data;
+	unsigned int size;
+};
+
+#if defined(CONFIG_ACPI) && defined(CONFIG_GPIOLIB)
+int acpi_dev_add_driver_gpios(struct acpi_device *adev,
+			      struct acpi_gpio_mapping *gpios);
+
+static inline void acpi_dev_remove_driver_gpios(struct acpi_device *adev)
+{
+	if (adev)
+		adev->driver_gpios = NULL;
+}
+#else
+static inline int acpi_dev_add_driver_gpios(struct acpi_device *adev,
+			      struct acpi_gpio_mapping *gpios)
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
@@ -287,6 +287,38 @@ void acpi_gpiochip_free_interrupts(struc
 	}
 }
 
+int acpi_dev_add_driver_gpios(struct acpi_device *adev,
+			      struct acpi_gpio_mapping *gpios)
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
+	struct acpi_gpio_mapping *gm;
+
+	for (gm = adev->driver_gpios; gm; gm++)
+		if (!strcmp(name, gm->name) && gm->data && index < gm->size) {
+			struct acpi_gpio_params *par = gm->data + index;
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
@@ -372,8 +404,12 @@ struct gpio_desc *acpi_get_gpiod_by_inde
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

