Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaHQNxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 09:53:09 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:49257 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaHQNxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 09:53:02 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH 6/9] gpiolib: add API to get gpio desc and flags
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1408255459-17625-7-git-send-email-mika.westerberg@linux.intel.com>
References: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
	<1408255459-17625-7-git-send-email-mika.westerberg@linux.intel.com>
Date: Sun, 17 Aug 2014 14:00:04 +0100
Message-Id: <20140817130004.4B9FDC4137F@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2014 09:04:16 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> 
> Add a new API to get the GPIO's description pointer and its flags for
> both OF based system and ACPI based system. This is useful in drivers
> that do not need to care about the underlying firmware interface.

Hi Mika,

I've only looked at this one briefly, and noticed one problem below...

g.

> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Max Eliaser <max.eliaser@intel.com>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/gpio/gpiolib-acpi.c   | 81 ++++++++++++++++++++++++++++++++-----------
>  drivers/gpio/gpiolib.c        | 18 ++++++++++
>  drivers/gpio/gpiolib.h        |  8 +++++
>  include/linux/gpio/consumer.h | 11 ++++++
>  4 files changed, 97 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index 4a987917c186..f35e88d29a47 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -293,11 +293,38 @@ static int acpi_find_gpio(struct acpi_resource *ares, void *data)
>  			agpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT;
>  		lookup->info.active_low =
>  			agpio->polarity == ACPI_ACTIVE_LOW;
> +		lookup->info.pin_config = agpio->pin_config;
>  	}
>  
>  	return 1;
>  }
>  
> +static struct gpio_desc *
> +__acpi_get_gpiod_by_index(struct acpi_device *adev, int index,
> +			  struct acpi_gpio_info *info)
> +{
> +	struct acpi_gpio_lookup lookup;
> +	struct list_head resource_list;
> +	int ret;
> +
> +	memset(&lookup, 0, sizeof(lookup));
> +	lookup.index = index;
> +
> +	INIT_LIST_HEAD(&resource_list);
> +	ret = acpi_dev_get_resources(adev, &resource_list, acpi_find_gpio,
> +				     &lookup);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	acpi_dev_free_resource_list(&resource_list);
> +
> +	if (lookup.desc && info)
> +		*info = lookup.info;
> +
> +	return lookup.desc ? lookup.desc : ERR_PTR(-ENOENT);
> +}
> +
> +
>  /**
>   * acpi_get_gpiod_by_index() - get a GPIO descriptor from device resources
>   * @dev: pointer to a device to get GPIO from
> @@ -318,34 +345,46 @@ static int acpi_find_gpio(struct acpi_resource *ares, void *data)
>  struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
>  					  struct acpi_gpio_info *info)
>  {
> -	struct acpi_gpio_lookup lookup;
> -	struct list_head resource_list;
> -	struct acpi_device *adev;
> -	acpi_handle handle;
> -	int ret;
> -
> -	if (!dev)
> +	if (!dev || !ACPI_COMPANION(dev))
>  		return ERR_PTR(-EINVAL);
> +	return __acpi_get_gpiod_by_index(ACPI_COMPANION(dev), index, info);
> +}
>  
> -	handle = ACPI_HANDLE(dev);
> -	if (!handle || acpi_bus_get_device(handle, &adev))
> -		return ERR_PTR(-ENODEV);
> -
> -	memset(&lookup, 0, sizeof(lookup));
> -	lookup.index = index;
> +struct gpio_desc *acpi_get_gpiod_flags(struct device *dev, int idx,
> +				       enum gpio_lookup_flags *flags)
> +{
> +	struct acpi_device *adev = ACPI_COMPANION(dev);
> +	struct acpi_reference_args args;
> +	struct acpi_gpio_info info;
> +	struct gpio_desc *desc;
> +	bool active_low;
> +	int ret;
>  
> -	INIT_LIST_HEAD(&resource_list);
> -	ret = acpi_dev_get_resources(adev, &resource_list, acpi_find_gpio,
> -				     &lookup);
> -	if (ret < 0)
> +	ret = acpi_dev_get_property_reference(adev, "gpios", NULL, idx, &args);
> +	if (ret)
>  		return ERR_PTR(ret);
>  
> -	acpi_dev_free_resource_list(&resource_list);
> +	desc = __acpi_get_gpiod_by_index(args.adev, args.args[0], &info);
> +	if (IS_ERR(desc))
> +		return desc;
>  
> -	if (lookup.desc && info)
> -		*info = lookup.info;
> +	/*
> +	 * The 3rd argument optionally specifies the pin polarity. We
> +	 * use that if it exists, otherwise we resort to the pin config.
> +	 * (Note that the first element of the "gpios" package goes into
> +	 * arg.adev, not args.args.)
> +	 */
> +	if (args.nargs >= 3)
> +		active_low = !!args.args[2];
> +	else if (info.gpioint)
> +		active_low = !!info.active_low;
> +	else
> +		active_low = !!(info.pin_config & ACPI_PIN_CONFIG_PULLUP);
>  
> -	return lookup.desc ? lookup.desc : ERR_PTR(-ENOENT);
> +	if (active_low)
> +		*flags |= GPIO_ACTIVE_LOW;
> +
> +	return desc;
>  }
>  
>  static acpi_status
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 2ebc9071e354..e6c2413a6fbf 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -2644,6 +2644,24 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
>  	return desc;
>  }
>  
> +struct gpio_desc *dev_get_gpiod_flags(struct device *dev, unsigned int idx,
> +				      enum gpio_lookup_flags *flags)
> +{
> +	struct gpio_desc *desc = ERR_PTR(-ENOENT);
> +
> +	if (!dev || !flags)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Using device tree? */
> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> +		desc = of_find_gpio(dev, NULL, idx, flags);

of_find_gpio() doesn't exist.

> +	else if (IS_ENABLED(CONFIG_ACPI) && ACPI_COMPANION(dev))
> +		desc = acpi_get_gpiod_flags(dev, idx, flags);
> +
> +	return desc;
> +}
> +EXPORT_SYMBOL(dev_get_gpiod_flags);
> +
>  static struct gpiod_lookup_table *gpiod_find_lookup_table(struct device *dev)
>  {
>  	const char *dev_id = dev ? dev_name(dev) : NULL;
> diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
> index 1a4103dd38df..a759db968e51 100644
> --- a/drivers/gpio/gpiolib.h
> +++ b/drivers/gpio/gpiolib.h
> @@ -25,6 +25,7 @@ enum of_gpio_flags;
>  struct acpi_gpio_info {
>  	bool gpioint;
>  	bool active_low;
> +	u8 pin_config;
>  };
>  
>  #ifdef CONFIG_ACPI
> @@ -33,6 +34,8 @@ void acpi_gpiochip_remove(struct gpio_chip *chip);
>  
>  struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
>  					  struct acpi_gpio_info *info);
> +struct gpio_desc *acpi_get_gpiod_flags(struct device *dev, int index,
> +				       enum gpio_lookup_flags *flags);
>  #else
>  static inline void acpi_gpiochip_add(struct gpio_chip *chip) { }
>  static inline void acpi_gpiochip_remove(struct gpio_chip *chip) { }
> @@ -43,6 +46,11 @@ acpi_get_gpiod_by_index(struct device *dev, int index,
>  {
>  	return ERR_PTR(-ENOSYS);
>  }
> +static struct gpio_desc *acpi_get_gpiod_flags(struct device *dev, int index,
> +					      enum gpio_lookup_flags *flags)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
>  #endif
>  
>  int gpiochip_request_own_desc(struct gpio_desc *desc, const char *label);
> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
> index 05e53ccb708b..53f422e4f0c9 100644
> --- a/include/linux/gpio/consumer.h
> +++ b/include/linux/gpio/consumer.h
> @@ -7,6 +7,8 @@
>  
>  struct device;
>  
> +enum gpio_lookup_flags;
> +
>  /**
>   * Opaque descriptor for a GPIO. These are obtained using gpiod_get() and are
>   * preferable to the old integer-based handles.
> @@ -73,6 +75,9 @@ int gpiod_to_irq(const struct gpio_desc *desc);
>  struct gpio_desc *gpio_to_desc(unsigned gpio);
>  int desc_to_gpio(const struct gpio_desc *desc);
>  
> +struct gpio_desc *dev_get_gpiod_flags(struct device *dev, unsigned int idx,
> +				      enum gpio_lookup_flags *flags);
> +
>  #else /* CONFIG_GPIOLIB */
>  
>  static inline struct gpio_desc *__must_check gpiod_get(struct device *dev,
> @@ -254,6 +259,12 @@ static inline int desc_to_gpio(const struct gpio_desc *desc)
>  	return -EINVAL;
>  }
>  
> +static inline struct gpio_desc *dev_get_gpiod_flags(struct device *dev,
> +			unsigned int idx, enum gpio_lookup_flags *flags)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
> +
>  
>  #endif /* CONFIG_GPIOLIB */
>  
> -- 
> 2.1.0.rc1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

