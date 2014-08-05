Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaHERKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 13:10:21 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41105 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbaHERKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 13:10:19 -0400
Date: Tue, 5 Aug 2014 10:10:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2] gpiolib: Provide and export gpiod_export_name
Message-ID: <20140805171015.GA10236@roeck-us.net>
References: <1406308367-28758-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406308367-28758-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 10:12:47AM -0700, Guenter Roeck wrote:
> gpiod_export_name is similar to gpiod_export, but lets the user
> determine the name used to export a gpio pin.
> 
> Currently, the pin name is determined by the chip driver with
> the 'names' array in the gpio_chip data structure, or it is set
> to gpioX, where X is the pin number, if no name is provided by
> the chip driver.
> 
> It is, however, desirable to be able to provide the pin name when
> exporting the pin, for example from platform code. In other words,
> it would be useful to move the naming decision from the pin provider
> to the pin consumer. The gpio-pca953x driver provides this capability
> as part of its platform data. Other drivers could be enhanced in a
> similar way; however, this is not always possible or easy to accomplish.
> For example, mfd client drivers such as gpio-ich already use platform
> data to pass information from the mfd master driver to the client driver.
> Overloading this platform data to also provide an array of gpio pin names
> would be a challenge if not impossible.
> 
> The alternative to use gpiod_export_link is also not always desirable,
> since it only creates a named link to a different directory, meaning
> the named gpio pin is not available in /sys/class/gpio but only
> in some platform specific directory and thus not as generic as possible
> and/or useful.
> 
> A specific example for a use case is a gpio pin which reports AC power
> loss to user space. Depending on the platform and platform variant,
> the pin can be provided by various gpio chip drivers and pin numbers.
> It would be very desirable to have a well defined location such as
> /sys/class/gpio/ac_power_loss for this pin, so user space knows where
> to find the attribute without knowledge of the underlying platform
> variant or oher hardware details.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Any comments / feedback ?

Thanks,
Guenter

> ---
> v2: Move name creation completely into gpiod_export().
>     Do not accept NULL name in gpiod_export_name().
> 
>  Documentation/gpio/sysfs.txt  | 12 ++++++++----
>  drivers/gpio/gpiolib-sysfs.c  | 37 ++++++++++++++++++++++++++++---------
>  include/linux/gpio/consumer.h |  9 +++++++++
>  3 files changed, 45 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/gpio/sysfs.txt b/Documentation/gpio/sysfs.txt
> index c2c3a97..e59653a 100644
> --- a/Documentation/gpio/sysfs.txt
> +++ b/Documentation/gpio/sysfs.txt
> @@ -125,7 +125,11 @@ requested using gpio_request():
>  	/* export the GPIO to userspace */
>  	int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
>  
> -	/* reverse gpio_export() */
> +	/* export named GPIO to userspace */
> +	int gpiod_export_name(struct gpio_desc *desc, const char *ioname,
> +			bool direction_may_change);
> +
> +	/* reverse gpiod_export() / gpiod_export_name() */
>  	void gpiod_unexport(struct gpio_desc *desc);
>  
>  	/* create a sysfs link to an exported GPIO node */
> @@ -136,9 +140,9 @@ requested using gpio_request():
>  	int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
>  
>  After a kernel driver requests a GPIO, it may only be made available in
> -the sysfs interface by gpiod_export(). The driver can control whether the
> -signal direction may change. This helps drivers prevent userspace code
> -from accidentally clobbering important system state.
> +the sysfs interface by gpiod_export() or gpiod_export_name(). The driver
> +can control whether the signal direction may change. This helps drivers
> +prevent userspace code from accidentally clobbering important system state.
>  
>  This explicit exporting can help with debugging (by making some kinds
>  of experiments easier), or can provide an always-there interface that's
> diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
> index 5f2150b..0c86a0c 100644
> --- a/drivers/gpio/gpiolib-sysfs.c
> +++ b/drivers/gpio/gpiolib-sysfs.c
> @@ -523,13 +523,12 @@ static struct class gpio_class = {
>   *
>   * Returns zero on success, else an error.
>   */
> -int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
> +int gpiod_export_name(struct gpio_desc *desc, const char *ioname,
> +		      bool direction_may_change)
>  {
>  	unsigned long		flags;
>  	int			status;
> -	const char		*ioname = NULL;
>  	struct device		*dev;
> -	int			offset;
>  
>  	/* can't export until sysfs is available ... */
>  	if (!gpio_class.p) {
> @@ -542,6 +541,11 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>  		return -EINVAL;
>  	}
>  
> +	if (!ioname) {
> +		pr_debug("%s: invalid ioname\n", __func__);
> +		return -EINVAL;
> +	}
> +
>  	mutex_lock(&sysfs_lock);
>  
>  	spin_lock_irqsave(&gpio_lock, flags);
> @@ -560,13 +564,8 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
>  		direction_may_change = false;
>  	spin_unlock_irqrestore(&gpio_lock, flags);
>  
> -	offset = gpio_chip_hwgpio(desc);
> -	if (desc->chip->names && desc->chip->names[offset])
> -		ioname = desc->chip->names[offset];
> -
>  	dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
> -			    desc, ioname ? ioname : "gpio%u",
> -			    desc_to_gpio(desc));
> +			    desc, ioname, desc_to_gpio(desc));
>  	if (IS_ERR(dev)) {
>  		status = PTR_ERR(dev);
>  		goto fail_unlock;
> @@ -600,6 +599,26 @@ fail_unlock:
>  	gpiod_dbg(desc, "%s: status %d\n", __func__, status);
>  	return status;
>  }
> +EXPORT_SYMBOL_GPL(gpiod_export_name);
> +
> +int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
> +{
> +	const char *ioname;
> +	int offset;
> +
> +	if (!desc) {
> +		pr_debug("%s: invalid gpio descriptor\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	offset = gpio_chip_hwgpio(desc);
> +	if (desc->chip->names && desc->chip->names[offset])
> +		ioname = desc->chip->names[offset];
> +	else
> +		ioname = "gpio%u";
> +
> +	return gpiod_export_name(desc, ioname, direction_may_change);
> +}
>  EXPORT_SYMBOL_GPL(gpiod_export);
>  
>  static int match_export(struct device *dev, const void *data)
> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
> index 05e53cc..986da3e 100644
> --- a/include/linux/gpio/consumer.h
> +++ b/include/linux/gpio/consumer.h
> @@ -260,6 +260,8 @@ static inline int desc_to_gpio(const struct gpio_desc *desc)
>  #if IS_ENABLED(CONFIG_GPIOLIB) && IS_ENABLED(CONFIG_GPIO_SYSFS)
>  
>  int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
> +int gpiod_export_name(struct gpio_desc *desc, const char *ioname,
> +		      bool direction_may_change);
>  int gpiod_export_link(struct device *dev, const char *name,
>  		      struct gpio_desc *desc);
>  int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
> @@ -273,6 +275,13 @@ static inline int gpiod_export(struct gpio_desc *desc,
>  	return -ENOSYS;
>  }
>  
> +static inline int gpiod_export_name(struct gpio_desc *desc,
> +				    const char *ioname,
> +				    bool direction_may_change)
> +{
> +	return -ENOSYS;
> +}
> +
>  static inline int gpiod_export_link(struct device *dev, const char *name,
>  				    struct gpio_desc *desc)
>  {
> -- 
> 1.9.1
> 
> 
