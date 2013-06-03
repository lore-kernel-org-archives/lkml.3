Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab3FCW4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:56:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab3FCW4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:56:30 -0400
Date: Mon, 3 Jun 2013 15:56:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Luebbe <jlu@pengutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Rodolfo Giometti <giometti@enneenne.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pps-gpio: add device-tree binding and support
Message-Id: <20130603155627.3f63cfd0ae1cec3c0e0a1444@linux-foundation.org>
In-Reply-To: <1370083449-11986-1-git-send-email-jlu@pengutronix.de>
References: <1588516.WvWWFWzAui@wuerfel>
	<1370083449-11986-1-git-send-email-jlu@pengutronix.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  1 Jun 2013 12:44:09 +0200 Jan Luebbe <jlu@pengutronix.de> wrote:

> Instead of allocating a struct pps_gpio_platform_data in the DT case, store
> the necessary information in struct pps_gpio_device_data itself. This avoids
> an additional allocation and the ifdef. It also gets rid of some indirection.
> 
> Also use dev_err instead of pr_err in the changed code.
> 
> ...
>
>  static int pps_gpio_probe(struct platform_device *pdev)
>  {
>  	struct pps_gpio_device_data *data;
> -	int irq;
> +	const char *gpio_label;
>  	int ret;
>  	int pps_default_params;
>  	const struct pps_gpio_platform_data *pdata = pdev->dev.platform_data;
> +	struct device_node *np = pdev->dev.of_node;
>  
> +	/* allocate space for device info */
> +	data = devm_kzalloc(&pdev->dev, sizeof(struct pps_gpio_device_data),
> +			GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	if (pdata) {
> +		data->gpio_pin = pdata->gpio_pin;
> +		gpio_label = pdata->gpio_label;
> +
> +		data->assert_falling_edge = pdata->assert_falling_edge;
> +		data->capture_clear = pdata->capture_clear;
> +	} else {
> +		ret = of_get_gpio(np, 0);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "failed to get GPIO from device tree\n");
> +			return ret;
> +		}
> +		data->gpio_pin = ret;
> +		gpio_label = PPS_GPIO_NAME;
> +
> +		if (of_get_property(np, "assert-falling-edge", NULL))
> +			data->assert_falling_edge = true;
> +	}
>  
>  	/* GPIO setup */
> -	ret = pps_gpio_setup(pdev);
> -	if (ret)
> -		return -EINVAL;
> +	ret = devm_gpio_request(&pdev->dev, data->gpio_pin, gpio_label);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to request GPIO %u\n",
> +			data->gpio_pin);
> +		return ret;
> +	}
>  
> -	/* IRQ setup */
> -	irq = gpio_to_irq(pdata->gpio_pin);
> -	if (irq < 0) {
> -		pr_err("failed to map GPIO to IRQ: %d\n", irq);
> +	ret = gpio_direction_input(data->gpio_pin);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to set pin direction\n");
>  		return -EINVAL;

Should we propagate the gpio_direction_input() return value?

>  	}
>  

