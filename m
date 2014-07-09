Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbaGILSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:18:50 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:46347 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932144AbaGILSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:18:47 -0400
Message-ID: <53BD2509.6070803@codethink.co.uk>
Date: Wed, 09 Jul 2014 12:18:33 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>
CC: julia.lawall@lip6.fr
Subject: Re: [PATCH 1/5] gpiolib: devres: Introduce the function devm_request_gpio_array
References: <cover.1404665589.git.himangi774@gmail.com> <1a1752ce7455bac8f2505a9790da891a830699f5.1404665589.git.himangi774@gmail.com>
In-Reply-To: <1a1752ce7455bac8f2505a9790da891a830699f5.1404665589.git.himangi774@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please note that I submitted a patch on 02/07/14 to create this
function which was acked by Linus Walleij on 05/07/14.

Great minds think alike, and all that.

However, I think that the version I submitted better replicates the
original (non devm) functionality, see below.

I didn't, however, add it to the documentation. +1 on that.

On 06/07/14 18:47, Himangi Saraogi wrote:
> This patch introduces the function devm_request_gpio_array that
> allocates multiple GPIOs in a single call in a managed manner. The
> function is also included in the documentation and a declaration is
> added in include/linux/gpio.h.
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
>   Documentation/driver-model/devres.txt |  1 +
>   drivers/gpio/devres.c                 | 21 +++++++++++++++++++++
>   include/linux/gpio.h                  |  2 ++
>   3 files changed, 24 insertions(+)
>
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> index 9e2098e..756f6cf 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -337,6 +337,7 @@ GPIO
>     devm_gpiod_put()
>     devm_gpio_request()
>     devm_gpio_request_one()
> +  devm_gpio_request_array()
>     devm_gpio_free()
>
>   SND
> diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
> index 65978cf..adae7fa 100644
> --- a/drivers/gpio/devres.c
> +++ b/drivers/gpio/devres.c
> @@ -229,6 +229,27 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
>   EXPORT_SYMBOL(devm_gpio_request_one);
>
>   /**
> + *	devm_gpio_request_array - request multiple GPIOs in a single call
> + *	@dev:   device to request for
> + *	@array:	array of the 'struct gpio'
> + *	@num:	how many GPIOs in the array
> + */
> +int devm_gpio_request_array(struct device *dev, const struct gpio *array,
> +			    size_t num)
> +{
> +	int i, err;
> +
> +	for (i = 0; i < num; i++, array++) {
> +		err = devm_gpio_request_one(dev, array->gpio, array->flags,
> +					    array->label);
> +		if (err)
> +			return err;

The failure path in the version I submitted frees up any already
allocated gpios on the first failure.

> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devm_gpio_request_array);
> +
> +/**
>    *      devm_gpio_free - free a GPIO
>    *      @dev: device to free GPIO for
>    *      @gpio: GPIO to free
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 85aa5d0..c85f243 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -84,6 +84,8 @@ struct device;
>   int devm_gpio_request(struct device *dev, unsigned gpio, const char *label);
>   int devm_gpio_request_one(struct device *dev, unsigned gpio,
>   			  unsigned long flags, const char *label);
> +int devm_gpio_request_array(struct device *dev, const struct gpio *array,
> +			    size_t num);
>   void devm_gpio_free(struct device *dev, unsigned int gpio);
>
>   #else /* ! CONFIG_GPIOLIB */
>

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
