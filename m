Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947Ab3DCK4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 06:56:52 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50662 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760222Ab3DCK4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 06:56:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
Date: Wed, 03 Apr 2013 13:04:26 +0200
Message-ID: <15166969.9Sfs2U7qQb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 03, 2013 01:56:54 PM Mika Westerberg wrote:
> Instead of open-coding ACPI GPIO resource lookup in each driver, we provide
> a helper function analogous to Device Tree version that allows drivers to
> specify which GPIO resource they are interested (using an index to the GPIO
> resources). The function then finds out the correct resource, translates
> the ACPI GPIO number to the corresponding Linux GPIO number and returns
> that.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  Documentation/acpi/enumeration.txt |   32 ++++++++++++++-
>  drivers/gpio/gpiolib-acpi.c        |   77 ++++++++++++++++++++++++++++++++++++
>  include/linux/acpi_gpio.h          |   17 ++++++++
>  3 files changed, 125 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
> index 94a6561..b0d5410 100644
> --- a/Documentation/acpi/enumeration.txt
> +++ b/Documentation/acpi/enumeration.txt
> @@ -199,6 +199,8 @@ the device to the driver. For example:
>  	{
>  		Name (SBUF, ResourceTemplate()
>  		{
> +			...
> +			// Used to power on/off the device
>  			GpioIo (Exclusive, PullDefault, 0x0000, 0x0000,
>  				IoRestrictionOutputOnly, "\\_SB.PCI0.GPI0",
>  				0x00, ResourceConsumer,,)
> @@ -206,10 +208,20 @@ the device to the driver. For example:
>  				// Pin List
>  				0x0055
>  			}
> +
> +			// Interrupt for the device
> +			GpioInt (Edge, ActiveHigh, ExclusiveAndWake, PullNone,
> +				 0x0000, "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer,,)
> +			{
> +				// Pin list
> +				0x0058
> +			}
> +
>  			...
>  
> -			Return (SBUF)
>  		}
> +
> +		Return (SBUF)
>  	}
>  
>  These GPIO numbers are controller relative and path "\\_SB.PCI0.GPI0"
> @@ -220,6 +232,24 @@ The driver can do this by including <linux/acpi_gpio.h> and then calling
>  acpi_get_gpio(path, gpio). This will return the Linux GPIO number or
>  negative errno if there was no translation found.
>  
> +In a simple case of just getting the Linux GPIO number from device
> +resources one can use acpi_get_gpio_by_index() helper function. It takes
> +pointer to the device and index of the GpioIo/GpioInt descriptor in the
> +device resources list. For example:
> +
> +	int gpio_irq, gpio_power;
> +	int ret;
> +
> +	gpio_irq = acpi_get_gpio_by_index(dev, 1, NULL);
> +	if (gpio_irq < 0)
> +		/* handle error */
> +
> +	gpio_power = acpi_get_gpio_by_index(dev, 0, NULL);
> +	if (gpio_power < 0)
> +		/* handle error */
> +
> +	/* Now we can use the GPIO numbers */
> +
>  Other GpioIo parameters must be converted first by the driver to be
>  suitable to the gpiolib before passing them.
>  
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index a063eb0..b66df3b 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -54,6 +54,83 @@ int acpi_get_gpio(char *path, int pin)
>  }
>  EXPORT_SYMBOL_GPL(acpi_get_gpio);
>  
> +struct acpi_gpio_lookup {
> +	struct acpi_gpio_info info;
> +	int index;
> +	int gpio;
> +	int n;
> +};
> +
> +static int acpi_find_gpio(struct acpi_resource *ares, void *data)
> +{
> +	struct acpi_gpio_lookup *lookup = data;
> +
> +	if (ares->type != ACPI_RESOURCE_TYPE_GPIO)
> +		return 1;
> +
> +	if (lookup->n++ == lookup->index && lookup->gpio < 0) {
> +		const struct acpi_resource_gpio *agpio = &ares->data.gpio;
> +
> +		lookup->gpio = acpi_get_gpio(agpio->resource_source.string_ptr,
> +					     agpio->pin_table[0]);
> +		lookup->info.gpioint =
> +			agpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT;
> +	}
> +
> +	return 1;
> +}
> +
> +/**
> + * acpi_get_gpio_by_index() - get a GPIO number from device resources
> + * @dev: pointer to a device to get GPIO from
> + * @index: index of GpioIo/GpioInt resource (starting from %0)
> + * @info: info pointer to fill in (optional)
> + *
> + * Function goes through ACPI resources for @dev and based on @index looks
> + * up a GpioIo/GpioInt resource, translates it to the Linux GPIO number,
> + * and returns it. @index matches GpioIo/GpioInt resources only so if there
> + * are total %3 GPIO resources, the index goes from %0 to %2.
> + *
> + * If the GPIO cannot be translated or there is an error, negative errno is
> + * returned.
> + *
> + * Note: if the GPIO resource has multiple entries in the pin list, this
> + * function only returns the first.
> + */
> +int acpi_get_gpio_by_index(struct device *dev, int index,
> +			   struct acpi_gpio_info *info)
> +{
> +	struct acpi_gpio_lookup lookup;
> +	struct list_head resource_list;
> +	struct acpi_device *adev;
> +	acpi_handle handle;
> +	int ret;
> +
> +	if (!dev)
> +		return -EINVAL;
> +
> +	handle = ACPI_HANDLE(dev);
> +	if (!handle || acpi_bus_get_device(handle, &adev))
> +		return -ENODEV;
> +
> +	memset(&lookup, 0, sizeof(lookup));
> +	lookup.index = index;
> +	lookup.gpio = -ENODEV;
> +
> +	INIT_LIST_HEAD(&resource_list);
> +	ret = acpi_dev_get_resources(adev, &resource_list, acpi_find_gpio,
> +				     &lookup);
> +	if (ret < 0)
> +		return ret;
> +
> +	acpi_dev_free_resource_list(&resource_list);
> +
> +	if (lookup.gpio >= 0 && info)
> +		*info = lookup.info;
> +
> +	return lookup.gpio;
> +}
> +EXPORT_SYMBOL_GPL(acpi_get_gpio_by_index);
>  
>  static irqreturn_t acpi_gpio_irq_handler(int irq, void *data)
>  {
> diff --git a/include/linux/acpi_gpio.h b/include/linux/acpi_gpio.h
> index b76ebd0..598ea41 100644
> --- a/include/linux/acpi_gpio.h
> +++ b/include/linux/acpi_gpio.h
> @@ -1,12 +1,23 @@
>  #ifndef _LINUX_ACPI_GPIO_H_
>  #define _LINUX_ACPI_GPIO_H_
>  
> +#include <linux/device.h>
>  #include <linux/errno.h>
>  #include <linux/gpio.h>
>  
> +/**
> + * struct acpi_gpio_info - ACPI GPIO specific information
> + * @gpioint: if %true this GPIO is of type GpioInt otherwise type is GpioIo
> + */
> +struct acpi_gpio_info {
> +	bool gpioint;
> +};
> +
>  #ifdef CONFIG_GPIO_ACPI
>  
>  int acpi_get_gpio(char *path, int pin);
> +int acpi_get_gpio_by_index(struct device *dev, int index,
> +			   struct acpi_gpio_info *info);
>  void acpi_gpiochip_request_interrupts(struct gpio_chip *chip);
>  
>  #else /* CONFIG_GPIO_ACPI */
> @@ -16,6 +27,12 @@ static inline int acpi_get_gpio(char *path, int pin)
>  	return -ENODEV;
>  }
>  
> +static inline int acpi_get_gpio_by_index(struct device *dev, int index,
> +					 struct acpi_gpio_info *info)
> +{
> +	return -ENODEV;
> +}
> +
>  static inline void acpi_gpiochip_request_interrupts(struct gpio_chip *chip) { }
>  
>  #endif /* CONFIG_GPIO_ACPI */
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
