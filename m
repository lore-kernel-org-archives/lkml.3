Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018AbbA1Ulw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:41:52 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42575 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955AbbA1Ult (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:41:49 -0500
Message-ID: <54C90EE9.3040708@linaro.org>
Date: Wed, 28 Jan 2015 16:31:37 +0000
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>
CC: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mmc@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] mmc: pwrseq_simple: Extend to support more pins
References: <1422439819-29854-1-git-send-email-javier.martinez@collabora.co.uk> <1422439819-29854-3-git-send-email-javier.martinez@collabora.co.uk> <54C8EBB2.10101@linaro.org> <54C90AAC.3010907@collabora.co.uk>
In-Reply-To: <54C90AAC.3010907@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 28/01/15 16:13, Javier Martinez Canillas wrote:
> Hello Srinivas,
>
> Thanks a lot for your feedback.
>
> On 01/28/2015 03:01 PM, Srinivas Kandagatla wrote:
>> Hi Javier,
>>
>> You are in a lead of 3 hrs from me..
>> Surprisingly I send very much same patch just few Mins ago :-)
>
> :-)
>
> I didn't find the posted patch you are referring too though, did you cc
> linux-mmc?
>
>> May be we can merge goods in both :-)
>>
>
> Sure, I want $subject to be generic enough to be useful for other platforms.
>
>> On 28/01/15 10:10, Javier Martinez Canillas wrote:
>>> Many WLAN attached to a SDIO/MMC interface, needs more than one pin for
>>> their reset sequence. For example, is very common for chips to have two
>>> pins: one for reset and one for power enable.
>>>
>>> This patch adds support for more reset pins to the pwrseq_simple driver
>>> and instead hardcoding a fixed number, it uses the of_gpio_named_count()
>>> since the MMC power sequence is only built when CONFIG_OF is enabled.
>>>
>>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>>> ---
>>>    drivers/mmc/core/pwrseq_simple.c | 54 ++++++++++++++++++++++++++++++----------
>>>    1 file changed, 41 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/mmc/core/pwrseq_simple.c b/drivers/mmc/core/pwrseq_simple.c
>>> index 0958c696137f..9e51fe1051c5 100644
>>> --- a/drivers/mmc/core/pwrseq_simple.c
>>> +++ b/drivers/mmc/core/pwrseq_simple.c
>>> @@ -11,6 +11,7 @@
>>>    #include <linux/slab.h>
>>>    #include <linux/device.h>
>>>    #include <linux/err.h>
>>> +#include <linux/of_gpio.h>
>>>    #include <linux/gpio/consumer.h>
>>>
>>>    #include <linux/mmc/host.h>
>>> @@ -19,34 +20,44 @@
>>>
>>>    struct mmc_pwrseq_simple {
>>>    	struct mmc_pwrseq pwrseq;
>>> -	struct gpio_desc *reset_gpio;
>>> +	struct gpio_desc **reset_gpio;
>>
>> May be renaming it to reset_gpios makes more sense..
>>
>
> Ok
>
>> If you make this struct gpio_desc *reset_gpios[0]; You can aviod an
>> extra kmalloc and free ..
>>
>>
>
> That's a very good idea, thanks.
>
>>> +	int nr_gpios;
>>>    };
>>>
>>>    static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
>>>    {
>>
>> [...
>>>    	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
>>>    					struct mmc_pwrseq_simple, pwrseq);
>>> +	int i;
>>>
>>> -	if (!IS_ERR(pwrseq->reset_gpio))
>>> -		gpiod_set_value_cansleep(pwrseq->reset_gpio, 1);
>>> +	for (i = 0; i < pwrseq->nr_gpios; i++)
>>> +		if (!IS_ERR(pwrseq->reset_gpio[i]))
>>> +			gpiod_set_value_cansleep(pwrseq->reset_gpio[i], 1);
>>
>> ...]
>>
>>>    }
>>>
>>>    static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
>>>    {
>>
>> [...
>>
>>>    	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
>>>    					struct mmc_pwrseq_simple, pwrseq);
>>> +	int i;
>>>
>>> -	if (!IS_ERR(pwrseq->reset_gpio))
>>> -		gpiod_set_value_cansleep(pwrseq->reset_gpio, 0);
>>> +	for (i = 0; i < pwrseq->nr_gpios; i++)
>>> +		if (!IS_ERR(pwrseq->reset_gpio[i]))
>>> +			gpiod_set_value_cansleep(pwrseq->reset_gpio[i], 0);
>> ...]
>>
>> Now that we have more code in mmc_pwrseq_simple_post_power_on() and
>> mmc_pwrseq_simple_pre_power_on(), Just move most of them into a common
>> function like:
>>
>> static void __mmc_pwrseq_simple_power_on_off(struct mmc_host *host,
>> 						      bool on)
>> {
>> 	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
>> 					struct mmc_pwrseq_simple, pwrseq);
>> 	int i;
>>
>> 	if (!IS_ERR(pwrseq->reset_gpios)) {
>> 		for (i = 0; i < pwrseq->ngpios; i++)
>> 			gpiod_set_value_cansleep(pwrseq->reset_gpios[i],
>> 						 on ? : 0);
>> 	}
>> }
>>
>> static void mmc_pwrseq_simple_pre_power_on(struct mmc_host *host)
>> {
>> 	__mmc_pwrseq_simple_power_on_off(host, true);
>> }
>>
>> static void mmc_pwrseq_simple_post_power_on(struct mmc_host *host)
>> {
>> 	__mmc_pwrseq_simple_power_on_off(host, false);
>> }
>>
>>
>
> Sure, will do.
>
>>>    }
>>>
>>>    static void mmc_pwrseq_simple_free(struct mmc_host *host)
>>>    {
>>>    	struct mmc_pwrseq_simple *pwrseq = container_of(host->pwrseq,
>>>    					struct mmc_pwrseq_simple, pwrseq);
>>> +	int i;
>>>
>>> -	if (!IS_ERR(pwrseq->reset_gpio))
>>> -		gpiod_put(pwrseq->reset_gpio);
>>> +	if (pwrseq->nr_gpios > 0) {
>>> +		for (i = 0; i < pwrseq->nr_gpios; i++)
>>> +			if (!IS_ERR(pwrseq->reset_gpio[i]))
>>> +				gpiod_put(pwrseq->reset_gpio[i]);
>>> +		kfree(pwrseq->reset_gpio);
>>> +	}
>>>
>>>    	kfree(pwrseq);
>>>    	host->pwrseq = NULL;
>>> @@ -63,17 +74,27 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
>>>    {
>>>    	struct mmc_pwrseq_simple *pwrseq;
>>>    	int ret = 0;
>>> +	int i;
>>>
>>>    	pwrseq = kzalloc(sizeof(struct mmc_pwrseq_simple), GFP_KERNEL);
>>>    	if (!pwrseq)
>>>    		return -ENOMEM;
>>>
>>> -	pwrseq->reset_gpio = gpiod_get_index(dev, "reset", 0, GPIOD_OUT_HIGH);
>>> -	if (IS_ERR(pwrseq->reset_gpio) &&
>>> -		PTR_ERR(pwrseq->reset_gpio) != -ENOENT &&
>>> -		PTR_ERR(pwrseq->reset_gpio) != -ENOSYS) {
>>> -		ret = PTR_ERR(pwrseq->reset_gpio);
>>> -		goto free;
>>> +	pwrseq->nr_gpios = of_gpio_named_count(dev->of_node, "reset-gpios");
>>> +	if (pwrseq->nr_gpios > 0) {
>>
>> What happens if there are no gpios? This fuction should return -ENOENT
>> and should not even try to allocate pwrseq?
>
> Not quite, the DT binding states that the GPIOs are optional so it should
> not fail if no GPIOs are defined.
>
>> Probably you should do of_gpio_named_count before allocating memory.
>>
>
> I didn't do that because patch #4 "mmc: pwrseq_simple: Add optional reference
> clock support" will need the struct mmc_pwrseq_simple even if no GPIOs are
> defined.
>
> A SDIO attached chip could require only an external clock or someone could
> extend the pwrseq_simple driver to support an external regulator for example.

That makes sense.

>
>>> +		pwrseq->reset_gpio = kzalloc(sizeof(struct gpio_desc *) *
>>> +					     pwrseq->nr_gpios, GFP_KERNEL);
>>> +
>>> +		for (i = 0; i < pwrseq->nr_gpios; i++) {
>>> +			pwrseq->reset_gpio[i] = gpiod_get_index(dev, "reset", i,
>>> +								GPIOD_OUT_HIGH);
>>> +			if (IS_ERR(pwrseq->reset_gpio[i]) &&
>>> +			    PTR_ERR(pwrseq->reset_gpio[i]) != -ENOENT &&
>>> +			    PTR_ERR(pwrseq->reset_gpio[i]) != -ENOSYS) {
>>> +				ret = PTR_ERR(pwrseq->reset_gpio[i]);
>>
>> is simple to add:
>> 	while(--i)
>> 		gpiod_put(pwrseq->reset_gpio[i])
>>
>>
>>
>
> That's true, will change.
>
>>> +				goto free;
>>> +			}
>>> +		}
>>
>>
>>>    	}
>>>
>>>    	pwrseq->pwrseq.ops = &mmc_pwrseq_simple_ops;
>>> @@ -81,6 +102,13 @@ int mmc_pwrseq_simple_alloc(struct mmc_host *host, struct device *dev)
>>>
>>>    	return 0;
>>>    free:
>>> +	if (pwrseq->nr_gpios > 0) {
>>> +		for (i = 0; i < pwrseq->nr_gpios; i++)
>>> +			if (!IS_ERR_OR_NULL(pwrseq->reset_gpio[i]))
>>> +				gpiod_put(pwrseq->reset_gpio[i]);
>>> +		kfree(pwrseq->reset_gpio);
>>> +	}
>>> +
>>>    	kfree(pwrseq);
>>>    	return ret;
>>>    }
>>>
>>
>> I get a feeling that am just dumping my patch here.. If possible could
>> you have look at it too.
>>
>
> Of course, do you have a link archive since I can't find it on my inbox.
I did send to linux-mmc@vger.kernel.org, Anyway i did forward you the patch.

thanks,
--srini
