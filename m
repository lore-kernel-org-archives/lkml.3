Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3BFNs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:48:58 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57848 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3BFNs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:48:56 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-92-51125f451e37
Message-id: <51125F44.3050603@samsung.com>
Date: Wed, 06 Feb 2013 14:48:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Benoit Thebaudeau <benoit.thebaudeau@advansee.com>,
        David Hardeman <david@hardeman.nu>, Trilok Soni <tsoni@codeaurora.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RESEND] media: rc: gpio-ir-recv: add support for device
 tree parsing
References: <1359400023-25804-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1360137832-13086-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-reply-to: <1360137832-13086-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t/xa7qu8UKBBscP2FgsbFvCYnF51xw2
	i54NW1kdmD0+b5ILYIzisklJzcksSy3St0vgyph+8BZLQYtWxexP05gaGF8odjFyckgImEis
	b5/DCmGLSVy4t56ti5GLQ0hgKaPEhSNPoJxPjBIPFs5gA6niFdCSmHN1MjOIzSKgKrH800QW
	EJtNwFCi92gfI4gtKhAgsXjJOXaIekGJH5PvAdVwcIgIWEu8aCkBmckssJBZYsrXNrAaYYEo
	iak/9jBBLJvKKPFz5lywZZxAg5YuXQNWxCygLjFp3iJmCFteYvOat8wTGAVmIdkxC0nZLCRl
	CxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEBOaXHYyLj1kdYhTgYFTi4b2pJxgoxJpY
	VlyZe4hRgoNZSYQ3z0koUIg3JbGyKrUoP76oNCe1+BAjEwenVANjNser1KIP6ru1Ex683WjS
	7bik/eLZiPzpKXp8s52mb5I5E73lquzVXWcbHztnBiwwmRFSePoWo+1cF8023t6Tc/qbFfed
	XrM2u7dlif2Dc8d8ajk9ev58amH7INfKI+q6p3ZxZ5yjZYrhSwFVGc1NV4LaVx1/0LRq4dIX
	x478/2K97QWn+XMGJZbijERDLeai4kQAUjHKlCoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/06/2013 09:03 AM, Sebastian Hesselbarth wrote:
> This patch adds device tree parsing for gpio_ir_recv platform_data and
> the mandatory binding documentation. It basically follows what we already
> have for e.g. gpio_keys. All required device tree properties are OS
> independent but optional properties allow linux specific support for rc
> protocols and maps.
> 
> There was a similar patch sent by Matus Ujhelyi but that discussion
> died after the first reviews.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
...
> diff --git a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
> new file mode 100644
> index 0000000..937760c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
> @@ -0,0 +1,20 @@
> +Device-Tree bindings for GPIO IR receiver
> +
> +Required properties:
> +	- compatible = "gpio-ir-receiver";
> +	- gpios: OF device-tree gpio specification.
> +
> +Optional properties:
> +	- linux,allowed-rc-protocols: Linux specific u64 bitmask of allowed
> +	    rc protocols.

You likely need to specify in these bindings documentation which bit 
corresponds to which RC protocol.

I'm not very familiar with the RC internals, but why it has to be
specified statically in the device tree, when decoding seems to be
mostly software defined ? I might be missing something though..

Couldn't this be configured at run time, with all protocols allowed
as the default ?

> +	- linux,rc-map-name: Linux specific remote control map name.
> +
> +Example node:
> +
> +	ir: ir-receiver {
> +		compatible = "gpio-ir-receiver";
> +		gpios = <&gpio0 19 1>;
> +		/* allow rc protocols 1-4 */
> +		linux,allowed-rc-protocols = <0x00000000 0x0000001e>;
> +		linux,rc-map-name = "rc-rc6-mce";
> +	};
> diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
> index 4f71a7d..25e09fa 100644
> --- a/drivers/media/rc/gpio-ir-recv.c
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -16,6 +16,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/gpio.h>
>  #include <linux/slab.h>
> +#include <linux/of_gpio.h>
>  #include <linux/platform_device.h>
>  #include <linux/irq.h>
>  #include <media/rc-core.h>
> @@ -30,6 +31,63 @@ struct gpio_rc_dev {
>  	bool active_low;
>  };
>  
> +#ifdef CONFIG_OF
> +/*
> + * Translate OpenFirmware node properties into platform_data
> + */
> +static struct gpio_ir_recv_platform_data *
> +gpio_ir_recv_get_devtree_pdata(struct device *dev)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct gpio_ir_recv_platform_data *pdata;
> +	enum of_gpio_flags flags;
> +	int gpio;
> +
> +	if (!np)
> +		return ERR_PTR(-ENODEV);
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (!of_find_property(np, "gpios", NULL)) {

Why do you need this ? Isn't of_get_gpio_flags() sufficient ?

> +		dev_err(dev, "Found gpio-ir-receiver without gpios\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	gpio = of_get_gpio_flags(np, 0, &flags);
> +	if (gpio < 0) {
> +		if (gpio != -EPROBE_DEFER)
> +			dev_err(dev, "Failed to get gpio flags, error: %d\n",
> +				gpio);
> +		return ERR_PTR(gpio);
> +	}
> +
> +	pdata->gpio_nr = gpio;
> +	pdata->active_low = (flags & OF_GPIO_ACTIVE_LOW) ? true : false;
> +	pdata->map_name = of_get_property(np, "linux,rc-map-name", NULL);
> +	of_property_read_u64(np, "linux,allowed-rc-protocols",
> +			     &pdata->allowed_protos);
> +
> +	return pdata;
> +}
> +
> +static struct of_device_id gpio_ir_recv_of_match[] = {
> +	{ .compatible = "gpio-ir-receiver", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, gpio_ir_recv_of_match);
> +
> +#else /* !CONFIG_OF */
> +
> +static inline struct gpio_ir_recv_platform_data *
> +gpio_ir_recv_get_devtree_pdata(struct device *dev)
> +{
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +#endif
> +
>  static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
>  {
>  	struct gpio_rc_dev *gpio_dev = dev_id;
> @@ -66,8 +124,11 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
>  					pdev->dev.platform_data;
>  	int rc;
>  
> -	if (!pdata)
> -		return -EINVAL;
> +	if (!pdata) {
> +		pdata = gpio_ir_recv_get_devtree_pdata(&pdev->dev);

Could assigning to pdev->dev.platform_data be avoided here ?

platform_data is only referenced in probe(), so maybe something like
this would be better:

	const struct gpio_ir_recv_platform_data *pdata = NULL;

	if (pdev->dev.of_node) {
		ret = gpio_ir_recv_parse_dt(&pdev->dev, &pdata);
		if (ret < 0)
			return ret;
	} else {
		pdata = pdev->dev.platform_data;
	}
	if (!pdata)
		return -EINVAL;

> +		if (IS_ERR(pdata))
> +			return PTR_ERR(pdata);
> +	}
>  
>  	if (pdata->gpio_nr < 0)
>  		return -EINVAL;
> @@ -195,6 +256,9 @@ static struct platform_driver gpio_ir_recv_driver = {
>  #ifdef CONFIG_PM
>  		.pm	= &gpio_ir_recv_pm_ops,
>  #endif
> +#ifdef CONFIG_OF
> +		.of_match_table = of_match_ptr(gpio_ir_recv_of_match),
> +#endif

There is not need for #ifdef here, of_match_ptr() macro was introduced
just to allow to omit #ifdefs.

>  	},
>  };
>  module_platform_driver(gpio_ir_recv_driver);
> 

--

Thanks,
Sylwester
