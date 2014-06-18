Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaFRP4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:56:19 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:51561 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751125AbaFRP4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:56:16 -0400
Message-ID: <53A1B698.7090802@codethink.co.uk>
Date: Wed, 18 Jun 2014 16:56:08 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: linus.walleij@linaro.org, gnurou@gmail.com, lgirdwood@gmail.com,
        broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, ian.molton@codethink.co.uk,
        ben.dooks@codethink.co.uk
Subject: Re: [PATCH 1/3] drivers/gpio: devres.c: allow gpio array requests
 for managed devices
References: <1402411308-14182-1-git-send-email-rob.jones@codethink.co.uk> <1402411308-14182-2-git-send-email-rob.jones@codethink.co.uk> <4501550.PbI0gbPlXS@diego>
In-Reply-To: <4501550.PbI0gbPlXS@diego>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18/06/14 14:24, Heiko Stübner wrote:
> Am Dienstag, 10. Juni 2014, 15:41:46 schrieb Rob Jones:
>> Add functions devm_gpio_request_array() and devm_gpio_free_array()
>> which are exactly analogous to the equivalent non-managed device
>> functions gpio_request_array() and gpio_free_array(), which can be
>> found in module gpiolib.c.
>>
>> Note that if devm_gpio_request_array() fails, no gpios are obtained.
>> No indication is provided as to which particular request failed.
>>
>> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
>> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> apart from the doc issue below this looks ok to me
>
>
>> ---
>>   drivers/gpio/devres.c |   57
>> +++++++++++++++++++++++++++++++++++++++++++++++++ include/linux/gpio.h  |
>>   4 ++++
>>   2 files changed, 61 insertions(+)
>>
>> diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
>> index 307464f..fd95240d 100644
>> --- a/drivers/gpio/devres.c
>> +++ b/drivers/gpio/devres.c
>> @@ -186,6 +186,63 @@ int devm_gpio_request_one(struct device *dev, unsigned
>> gpio, EXPORT_SYMBOL(devm_gpio_request_one);
>>
>>   /**
>> + * devm_gpio_request_array - request multiple GPIOs in a single call
>> + *			     for a managed device
>> + * @dev:	device requesting the gpio
>> + * @array:      array of the 'struct gpio'
>> + * @num:        how many GPIOs in the array
> @dev uses a tab as spacing, while @array and @num use spaces, might be nice to
> have this consistent.

I'm not sure how that happened. I'll rework it before re-submitting the 
series.

>
>
>> + *
>> + * Except for the extra @dev argument, this function takes the
>> + * same arguments and performs the same function as
>> + * gpio_request().  GPIOs requested with this function will be
>> + * automatically freed on driver detach.
>> + *
>> + * If GPIOs allocated with this function need to be freed separately,
>> + * devm_gpio_free_array() or devm_gpio_free() must be used.
>> + */
>> +int devm_gpio_request_array(struct device *dev,
>> +			    const struct gpio *array,
>> +			    size_t num)
>> +{
>> +	int i, err = 0;
>> +
>> +	for (i = 0; i < num; i++, array++) {
>> +		err = devm_gpio_request_one(dev,
>> +					    array->gpio,
>> +					    array->flags,
>> +					    array->label);
>> +		if (err) {
>> +			while (i--)
>> +				devm_gpio_free(dev, (--array)->gpio);
>> +		}
>> +	}
>> +
>> +	return err;
>> +}
>> +EXPORT_SYMBOL(devm_gpio_request_array);
>> +
>> +/**
>> + * devm_gpio_free_array - release multiple GPIOs in a single call
>> + *			  for a managed device
>> + * @dev:	device requesting the gpio
>> + * @array:      array of the 'struct gpio'
>> + * @num:        how many GPIOs in the array
> same here
>
>> + *
>> + * Except for the extra @dev argument, this function takes the
>> + * same arguments and performs the same function as gpio_free_array().
>> + * This function instead of gpio_free_array() should be used to
>> + * manually free GPIOs allocated with devm_gpio_request().
>> + */
>> +void devm_gpio_free_array(struct device *dev,
>> +			  const struct gpio *array,
>> +			  size_t num)
>> +{
>> +	while (num--)
>> +		devm_gpio_free(dev, (array++)->gpio);
>> +}
>> +EXPORT_SYMBOL(devm_gpio_free_array);
>> +
>> +/**
>>    *      devm_gpio_free - free a GPIO
>>    *      @dev: device to free GPIO for
>>    *      @gpio: GPIO to free
>> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
>> index 85aa5d0..12d5648 100644
>> --- a/include/linux/gpio.h
>> +++ b/include/linux/gpio.h
>> @@ -84,6 +84,10 @@ struct device;
>>   int devm_gpio_request(struct device *dev, unsigned gpio, const char
>> *label); int devm_gpio_request_one(struct device *dev, unsigned gpio,
>>   			  unsigned long flags, const char *label);
>> +int devm_gpio_request_array(struct device *dev, const struct gpio *array,
>> +			    size_t num);
>> +void devm_gpio_free_array(struct device *dev, const struct gpio *array,
>> +			 size_t num);
>>   void devm_gpio_free(struct device *dev, unsigned int gpio);
>>
>>   #else /* ! CONFIG_GPIOLIB */
>
>

-- 
Rob Jones
Project Manager
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575

