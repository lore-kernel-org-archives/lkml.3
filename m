Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbbA2COP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:14:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46841 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbbA2CON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:14:13 -0500
Date: Wed, 28 Jan 2015 14:30:08 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3.14 02/77] gpio: sysfs: fix gpio device-attribute leak
Message-ID: <20150128143008.GC4685@charon>
References: <20150128012745.971137091@linuxfoundation.org>
 <20150128012746.043195070@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150128012746.043195070@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 05:26:40PM -0800, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Johan Hovold <johan@kernel.org>
> 
> commit 0915e6feb38de8d3601819992a5bd050201a56fa upstream.
> 
> The gpio device attributes were never destroyed when the gpio was
> unexported (or on export failures).
> 
> Use device_create_with_groups() to create the default device attributes
> of the gpio class device. Note that this also fixes the
> attribute-creation race with userspace for these attributes.
> 
> Remove contingent attributes in export error path and on unexport.
> 
> Fixes: d8f388d8dc8d ("gpio: sysfs interface")
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> ---
>  drivers/gpio/gpiolib.c |   27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -408,7 +408,7 @@ static ssize_t gpio_value_store(struct d
>  	return status;
>  }
>  
> -static const DEVICE_ATTR(value, 0644,
> +static DEVICE_ATTR(value, 0644,
>  		gpio_value_show, gpio_value_store);
>  
>  static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
> @@ -633,18 +633,16 @@ static ssize_t gpio_active_low_store(str
>  	return status ? : size;
>  }
>  
> -static const DEVICE_ATTR(active_low, 0644,
> +static DEVICE_ATTR(active_low, 0644,
>  		gpio_active_low_show, gpio_active_low_store);
>  
> -static const struct attribute *gpio_attrs[] = {
> +static struct attribute *gpio_attrs[] = {
>  	&dev_attr_value.attr,
>  	&dev_attr_active_low.attr,
>  	NULL,
>  };
>  
> -static const struct attribute_group gpio_attr_group = {
> -	.attrs = (struct attribute **) gpio_attrs,
> -};
> +ATTRIBUTE_GROUPS(gpio);
>  
>  /*
>   * /sys/class/gpio/gpiochipN/
> @@ -841,18 +839,15 @@ int gpiod_export(struct gpio_desc *desc,
>  	if (desc->chip->names && desc->chip->names[offset])
>  		ioname = desc->chip->names[offset];
>  
> -	dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
> -			    desc, ioname ? ioname : "gpio%u",
> -			    desc_to_gpio(desc));
> +	dev = device_create_with_groups(&gpio_class, desc->chip->dev,
> +					MKDEV(0, 0), desc, gpio_groups,
> +					ioname ? ioname : "gpio%u",
> +					desc_to_gpio(desc));
>  	if (IS_ERR(dev)) {
>  		status = PTR_ERR(dev);
>  		goto fail_unlock;
>  	}
>  
> -	status = sysfs_create_group(&dev->kobj, &gpio_attr_group);
> -	if (status)
> -		goto fail_unregister_device;
> -
>  	if (direction_may_change) {
>  		status = device_create_file(dev, &dev_attr_direction);
>  		if (status)
> @@ -863,13 +858,15 @@ int gpiod_export(struct gpio_desc *desc,
>  				       !test_bit(FLAG_IS_OUT, &desc->flags))) {
>  		status = device_create_file(dev, &dev_attr_edge);
>  		if (status)
> -			goto fail_unregister_device;
> +			goto fail_remove_attr_direction;
>  	}
>  
>  	set_bit(FLAG_EXPORT, &desc->flags);
>  	mutex_unlock(&sysfs_lock);
>  	return 0;
>  
> +fail_remove_attr_direction:
> +	device_remove_file(dev, &dev_attr_direction);
>  fail_unregister_device:
>  	device_unregister(dev);
>  fail_unlock:
> @@ -994,6 +991,8 @@ void gpiod_unexport(struct gpio_desc *de
>  
>  		dev = class_find_device(&gpio_class, NULL, desc, match_export);
>  		if (dev) {
> +			device_remove_file(dev, &dev_attr_edge);
> +			device_remove_file(dev, &dev_attr_direction);
>  			gpio_setup_irq(desc, dev, 0);
>  			clear_bit(FLAG_EXPORT, &desc->flags);
>  		} else
> 

I believe there's a mistake in this backport: the changes to the
gpiod_unexport() function are being applied to the wrong code block;
they should be in:

	if (dev) {
		device_unregister(dev);
		put_device(dev);
	}

The backport to the 3.10 kernel have the same problem.

Cheers,
--
Luís

> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
