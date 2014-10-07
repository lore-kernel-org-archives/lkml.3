Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbaJGRaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:30:14 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64849 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbaJGRaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:30:10 -0400
Date: Tue, 7 Oct 2014 10:30:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 13/13] input: gpio_keys_polled - Make use of device
 property API
Message-ID: <20141007173006.GI16469@dtor-ws>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
 <1419257.qDvBAKDkoZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419257.qDvBAKDkoZ@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:19:20AM +0200, Rafael J. Wysocki wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> 
> Make use of device property API in this driver so that both OF based
> system and ACPI based system can use this driver.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
>  drivers/input/keyboard/gpio_keys_polled.c |   81 +++++++++++-------------------
>  1 file changed, 31 insertions(+), 50 deletions(-)
> 
> Index: linux-pm/drivers/input/keyboard/gpio_keys_polled.c
> ===================================================================
> --- linux-pm.orig/drivers/input/keyboard/gpio_keys_polled.c
> +++ linux-pm/drivers/input/keyboard/gpio_keys_polled.c
> @@ -25,9 +25,7 @@
>  #include <linux/gpio.h>
>  #include <linux/gpio/consumer.h>
>  #include <linux/gpio_keys.h>
> -#include <linux/of.h>
> -#include <linux/of_platform.h>
> -#include <linux/of_gpio.h>
> +#include <linux/property.h>
>  
>  #define DRV_NAME	"gpio-keys-polled"
>  
> @@ -102,21 +100,15 @@ static void gpio_keys_polled_close(struc
>  		pdata->disable(bdev->dev);
>  }
>  
> -#ifdef CONFIG_OF
>  static struct gpio_keys_platform_data *gpio_keys_polled_get_devtree_pdata(struct device *dev)
>  {
> -	struct device_node *node, *pp;
>  	struct gpio_keys_platform_data *pdata;
>  	struct gpio_keys_button *button;
> +	void *child;
>  	int error;
>  	int nbuttons;
> -	int i;
> -
> -	node = dev->of_node;
> -	if (!node)
> -		return NULL;
>  
> -	nbuttons = of_get_child_count(node);
> +	nbuttons = device_get_child_node_count(dev);
>  	if (nbuttons == 0)
>  		return NULL;
>  
> @@ -126,52 +118,50 @@ static struct gpio_keys_platform_data *g
>  		return ERR_PTR(-ENOMEM);
>  
>  	pdata->buttons = (struct gpio_keys_button *)(pdata + 1);
> -	pdata->nbuttons = nbuttons;
>  
> -	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
> -	of_property_read_u32(node, "poll-interval", &pdata->poll_interval);
> +	pdata->rep = !device_get_property(dev, "autorepeat", NULL);
> +	device_property_read_u32(dev, "poll-interval", &pdata->poll_interval);
>  
> -	i = 0;
> -	for_each_child_of_node(node, pp) {
> -		int gpio;
> -		enum of_gpio_flags flags;
> -
> -		if (!of_find_property(pp, "gpios", NULL)) {
> -			pdata->nbuttons--;
> -			dev_warn(dev, "Found button without gpios\n");
> -			continue;
> -		}
> +	device_for_each_child_node(dev, child) {
> +		struct gpio_desc *desc;
>  
> -		gpio = of_get_gpio_flags(pp, 0, &flags);
> -		if (gpio < 0) {
> -			error = gpio;
> +		desc = devm_get_named_gpiod_from_child(dev, child, "gpios", 0);
> +		if (IS_ERR(desc)) {
> +			error = PTR_ERR(desc);
>  			if (error != -EPROBE_DEFER)
>  				dev_err(dev,
>  					"Failed to get gpio flags, error: %d\n",
>  					error);
> +			device_put_child_node(dev, child);
>  			return ERR_PTR(error);
>  		}
>  
> -		button = &pdata->buttons[i++];
> -
> -		button->gpio = gpio;
> -		button->active_low = flags & OF_GPIO_ACTIVE_LOW;
> +		button = &pdata->buttons[pdata->nbuttons++];
> +		button->gpiod = desc;
>  
> -		if (of_property_read_u32(pp, "linux,code", &button->code)) {
> -			dev_err(dev, "Button without keycode: 0x%x\n",
> -				button->gpio);
> +		if (device_child_property_read_u32(dev, child, "linux,code",
> +						   &button->code)) {
> +			dev_err(dev, "Button without keycode: %d\n",
> +				pdata->nbuttons - 1);
> +			device_put_child_node(dev, child);
>  			return ERR_PTR(-EINVAL);
>  		}
>  
> -		button->desc = of_get_property(pp, "label", NULL);
> +		device_child_property_read_string(dev, child, "label",
> +						  &button->desc);
>  
> -		if (of_property_read_u32(pp, "linux,input-type", &button->type))
> +		if (device_child_property_read_u32(dev, child,
> +						   "linux,input-type",
> +						   &button->type))
>  			button->type = EV_KEY;
>  
> -		button->wakeup = !!of_get_property(pp, "gpio-key,wakeup", NULL);
> -
> -		if (of_property_read_u32(pp, "debounce-interval",
> -					 &button->debounce_interval))
> +		button->wakeup = !device_get_child_property(dev, child,
> +							    "gpio-key,wakeup",
> +							    NULL);
> +
> +		if (device_child_property_read_u32(dev, child,
> +						   "debounce-interval",
> +						   &button->debounce_interval))
>  			button->debounce_interval = 5;
>  	}
>  
> @@ -187,15 +177,6 @@ static const struct of_device_id gpio_ke
>  };
>  MODULE_DEVICE_TABLE(of, gpio_keys_polled_of_match);
>  
> -#else
> -
> -static inline struct gpio_keys_platform_data *
> -gpio_keys_polled_get_devtree_pdata(struct device *dev)
> -{
> -	return NULL;
> -}
> -#endif
> -
>  static int gpio_keys_polled_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -323,7 +304,7 @@ static struct platform_driver gpio_keys_
>  	.driver	= {
>  		.name	= DRV_NAME,
>  		.owner	= THIS_MODULE,
> -		.of_match_table = of_match_ptr(gpio_keys_polled_of_match),
> +		.of_match_table = gpio_keys_polled_of_match,
>  	},
>  };
>  module_platform_driver(gpio_keys_polled_driver);
> 

-- 
Dmitry
