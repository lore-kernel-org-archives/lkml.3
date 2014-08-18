Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaHRR57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:57:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:30224 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaHRR55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:57:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,887,1400050800"; 
   d="scan'208";a="578314373"
Date: Mon, 18 Aug 2014 10:55:12 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Al Stone <al.stone@linaro.org>, Olof Johansson <olof@lixom.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Triplett <josh@joshtriplett.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>,
        Robert Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Mark Brown <broonie@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 8/9] Input: gpio_keys_polled - Make use of device
 property API
Message-ID: <20140818105512.7889980b@ultegra>
In-Reply-To: <1408172039-32513-9-git-send-email-mika.westerberg@linux.intel.com>
References: <1408172039-32513-1-git-send-email-mika.westerberg@linux.intel.com>
	<1408172039-32513-9-git-send-email-mika.westerberg@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2014 09:53:58 +0300
Mika Westerberg <mika.westerberg@linux.intel.com> wrote:

> From: Aaron Lu <aaron.lu@intel.com>
> 
> Make use of device property API in this driver so that both OF based
> system and ACPI based system can use this driver.
> 
Do we always assume OF and ACPI _DSD will have the same property name
strings? i.e. in this patch "gpios"
> +	if (device_property_get(dev, "gpios", NULL)) {
> -		if (!of_find_property(pp, "gpios", NULL)) {

Maybe i missed something, but I don't think we can make that assumption
in BIOS. If not, what is the point of having unified interface?

> The driver isn't converted to descriptor based gpio API due to there
> are a lot of existing users of struct gpio_keys_button that expects
> the gpio integer field. Though this can be solved by adding a new
> field of type struct gpio_desc but then there is another problem: the
> devm_gpiod_get needs to operate on the button device instead of its
> parent device that has the driver binded, so when the driver is
> unloaded, the resources for the gpio will not get freed
> automatically. Alternatively, we can introduce a new API, something
> like gpiod_find_index that does almost the same thing as
> gpiod_get_index but doesn't do the gpiod_request call and use it
> during finding button resources in gpio_keys_polled_get_button
> function. But then this may seem too complicated and not desirable.
> So in the end, a simple dev_get_gpiod_flags which is introduced in
> the last patch gets used and the gpio field of the struct
> gpio_keys_button can be got from the desc_to_gpio.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Max Eliaser <max@meliaserlow.dyndns.tv>
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/input/keyboard/gpio_keys_polled.c | 139
> ++++++++++++++++++------------ 1 file changed, 84 insertions(+), 55
> deletions(-)
> 
> diff --git a/drivers/input/keyboard/gpio_keys_polled.c
> b/drivers/input/keyboard/gpio_keys_polled.c index
> 432d36395f35..49895d75aaff 100644 ---
> a/drivers/input/keyboard/gpio_keys_polled.c +++
> b/drivers/input/keyboard/gpio_keys_polled.c @@ -27,6 +27,7 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/of_gpio.h>
> +#include <linux/property.h>
>  
>  #define DRV_NAME	"gpio-keys-polled"
>  
> @@ -102,78 +103,95 @@ static void gpio_keys_polled_close(struct
> input_polled_dev *dev) pdata->disable(bdev->dev);
>  }
>  
> -#ifdef CONFIG_OF
> -static struct gpio_keys_platform_data
> *gpio_keys_polled_get_devtree_pdata(struct device *dev) -{
> -	struct device_node *node, *pp;
> +#if defined(CONFIG_OF) || defined(CONFIG_ACPI)
> +
> +struct button_proc_context {
>  	struct gpio_keys_platform_data *pdata;
> -	struct gpio_keys_button *button;
> -	int error;
> -	int nbuttons;
>  	int i;
> +};
>  
> -	node = dev->of_node;
> -	if (!node)
> -		return NULL;
> +static int gpio_keys_polled_get_button(struct device *dev, void
> *data) +{
> +	struct button_proc_context *c = data;
> +	struct gpio_keys_platform_data *pdata = c->pdata;
> +	struct gpio_keys_button *button = &pdata->buttons[c->i];
> +	struct gpio_desc *desc;
> +	enum gpio_lookup_flags flags;
> +	void *val;
> +
> +	if (device_property_get(dev, "gpios", NULL)) {
> +		pdata->nbuttons--;
> +		dev_warn(dev, "Found button without gpios\n");
> +		return 0;
> +	}
>  
> -	nbuttons = of_get_child_count(node);
> -	if (nbuttons == 0)
> -		return NULL;
> +	desc = dev_get_gpiod_flags(dev, 0, &flags);
> +	if (IS_ERR(desc)) {
> +		int error = PTR_ERR(desc);
>  
> -	pdata = devm_kzalloc(dev, sizeof(*pdata) + nbuttons *
> sizeof(*button),
> -			     GFP_KERNEL);
> -	if (!pdata)
> -		return ERR_PTR(-ENOMEM);
> +		if (error != -EPROBE_DEFER)
> +			dev_err(dev, "Failed to get gpio flags,
> error: %d\n",
> +				error);
> +		return error;
> +	}
>  
> -	pdata->buttons = (struct gpio_keys_button *)(pdata + 1);
> -	pdata->nbuttons = nbuttons;
> +	button->gpio = desc_to_gpio(desc);
> +	button->active_low = flags & GPIO_ACTIVE_LOW;
>  
> -	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
> -	of_property_read_u32(node, "poll-interval",
> &pdata->poll_interval);
> +	if (device_property_read(dev, "linux,code", DEV_PROP_U32,
> +				 &button->code)) {
> +		dev_err(dev, "Button without keycode: 0x%x\n",
> +				button->gpio);
> +		return -EINVAL;
> +	}
>  
> -	i = 0;
> -	for_each_child_of_node(node, pp) {
> -		int gpio;
> -		enum of_gpio_flags flags;
> +	if (!device_property_get(dev, "label", &val))
> +		button->desc = val;
>  
> -		if (!of_find_property(pp, "gpios", NULL)) {
> -			pdata->nbuttons--;
> -			dev_warn(dev, "Found button without
> gpios\n");
> -			continue;
> -		}
> +	if (device_property_read(dev, "linux,input-type",
> DEV_PROP_U32,
> +				 &button->type))
> +		button->type = EV_KEY;
>  
> -		gpio = of_get_gpio_flags(pp, 0, &flags);
> -		if (gpio < 0) {
> -			error = gpio;
> -			if (error != -EPROBE_DEFER)
> -				dev_err(dev,
> -					"Failed to get gpio flags,
> error: %d\n",
> -					error);
> -			return ERR_PTR(error);
> -		}
> +	button->wakeup = !device_property_get(dev,
> "gpio-key,wakeup", NULL); 
> -		button = &pdata->buttons[i++];
> +	if (device_property_read(dev, "debounce-interval",
> DEV_PROP_U32,
> +				 &button->debounce_interval))
> +		button->debounce_interval = 5;
>  
> -		button->gpio = gpio;
> -		button->active_low = flags & OF_GPIO_ACTIVE_LOW;
> +	c->i++;
> +	return 0;
> +}
>  
> -		if (of_property_read_u32(pp, "linux,code",
> &button->code)) {
> -			dev_err(dev, "Button without keycode:
> 0x%x\n",
> -				button->gpio);
> -			return ERR_PTR(-EINVAL);
> -		}
> +static struct gpio_keys_platform_data *
> +gpio_keys_polled_get_devtree_pdata(struct device *dev)
> +{
> +	struct gpio_keys_platform_data *pdata;
> +	int size;
> +	struct button_proc_context c;
> +	int error;
> +	int nbuttons;
>  
> -		button->desc = of_get_property(pp, "label", NULL);
> +	nbuttons = device_property_child_count(dev);
> +	if (nbuttons <= 0)
> +		return NULL;
>  
> -		if (of_property_read_u32(pp, "linux,input-type",
> &button->type))
> -			button->type = EV_KEY;
> +	size = sizeof(*pdata) + nbuttons * sizeof(struct
> gpio_keys_button);
> +	pdata = devm_kzalloc(dev, size, GFP_KERNEL);
> +	if (!pdata)
> +		return ERR_PTR(-ENOMEM);
>  
> -		button->wakeup = !!of_get_property(pp,
> "gpio-key,wakeup", NULL);
> +	pdata->buttons = (struct gpio_keys_button *)(pdata + 1);
> +	pdata->nbuttons = nbuttons;
>  
> -		if (of_property_read_u32(pp, "debounce-interval",
> -					 &button->debounce_interval))
> -			button->debounce_interval = 5;
> -	}
> +	pdata->rep = !device_property_get(dev, "autorepeat", NULL);
> +	device_property_read(dev, "poll-interval", DEV_PROP_U32,
> +			     &pdata->poll_interval);
> +
> +	c.pdata = pdata;
> +	c.i = 0;
> +	error = device_for_each_child(dev, &c,
> gpio_keys_polled_get_button);
> +	if (error)
> +		return ERR_PTR(error);
>  
>  	if (pdata->nbuttons == 0)
>  		return ERR_PTR(-EINVAL);
> @@ -181,11 +199,21 @@ static struct gpio_keys_platform_data
> *gpio_keys_polled_get_devtree_pdata(struct return pdata;
>  }
>  
> +#ifdef CONFIG_OF
>  static const struct of_device_id gpio_keys_polled_of_match[] = {
>  	{ .compatible = "gpio-keys-polled", },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, gpio_keys_polled_of_match);
> +#endif
> +
> +#ifdef CONFIG_ACPI
> +static struct acpi_device_id gpio_keys_polled_acpi_match[] = {
> +	{ "MNW0002" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(acpi, gpio_keys_polled_acpi_match);
> +#endif
>  
>  #else
>  
> @@ -309,6 +337,7 @@ static struct platform_driver
> gpio_keys_polled_driver = { .name	= DRV_NAME,
>  		.owner	= THIS_MODULE,
>  		.of_match_table =
> of_match_ptr(gpio_keys_polled_of_match),
> +		.acpi_match_table =
> ACPI_PTR(gpio_keys_polled_acpi_match), },
>  };
>  module_platform_driver(gpio_keys_polled_driver);

[Jacob Pan]
