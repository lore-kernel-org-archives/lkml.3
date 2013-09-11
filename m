Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3IKB5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:57:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51197 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3IKB5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:57:36 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522FCE08.5000704@roeck-us.net>
Date: Tue, 10 Sep 2013 18:57:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 2/6] extcon-gpio: If the gpio driver/chip supports debounce,
 use it
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net> <1377836978-24082-3-git-send-email-linux@roeck-us.net> <522FC476.7060100@samsung.com>
In-Reply-To: <522FC476.7060100@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 06:16 PM, Chanwoo Choi wrote:
> Hi Guenter
>
> I agree to use gpio_set_debounce() API but, I suggest following patch to code clean.
> and I'd like you to use declarative sentence on patch name instead of 'If ...'.
>
> On 08/30/2013 01:29 PM, Guenter Roeck wrote:
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/extcon/extcon-gpio.c |    5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>> index 77d35a7..973600e 100644
>> --- a/drivers/extcon/extcon-gpio.c
>> +++ b/drivers/extcon/extcon-gpio.c
>> @@ -111,6 +111,11 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>   	if (ret < 0)
>>   		goto err;
>>
>> +	/* Use gpio debounce if available. If so, don't debounce in software. */
>> +	if (pdata->debounce &&
>> +	    !gpio_set_debounce(extcon_data->gpio, pdata->debounce * 1000))
>> +		extcon_data->debounce_jiffies = 0;
>> +
>>   	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
>>
>>   	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
>>
>
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 3943ce2..0777e72 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -56,8 +56,10 @@ static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
>   {
>          struct gpio_extcon_data *extcon_data = dev_id;
>
> -       queue_delayed_work(system_power_efficient_wq, &extcon_data->work,
> -                             extcon_data->debounce_jiffies);
> +       if (extcon_data->debounce_jiffies)
> +               queue_delayed_work(system_power_efficient_wq,
> +                                  &extcon_data->work,
> +                                  extcon_data->debounce_jiffies);

I am a bit lost about this one. The above means that the workqueue would not be executed
at all if debounce_jiffies is 0 (and if pdata->debounce is 0), meaning an event would
never be generated. With the original code, the workqueue will be executed immediately
if debounce_jiffies is 0, which I think is exactly what we need.

>          return IRQ_HANDLED;
>   }
>
> @@ -100,7 +102,14 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>          extcon_data->state_off = pdata->state_off;
>          if (pdata->state_on && pdata->state_off)
>                  extcon_data->edev.print_state = extcon_gpio_print_state;
> -       extcon_data->debounce_jiffies = msecs_to_jiffies(pdata->debounce);
> +       extcon_data->debounce_jiffies = 0;
> +       if (pdata->debounce) {
> +               ret = gpio_set_debounce(extcon_data->gpio,
> +                                       pdata->debounce * 1000);
> +               if (ret < 0)
> +                       extcon_data->debounce_jiffies =
> +                               msecs_to_jiffies(pdata->debounce);
> +       }
>
Ok, though it is unnecessary to initialize debounce_jiffies (it is pre-initialized
from the allocation), so I'll drop that line.

>          ret = extcon_dev_register(&extcon_data->edev, &pdev->dev);
>          if (ret < 0)
> @@ -111,11 +120,6 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>          if (ret < 0)
>                  goto err;
>
> -       /* Use gpio debounce if available. If so, don't debounce in software. */
> -       if (pdata->debounce &&
> -           !gpio_set_debounce(extcon_data->gpio, pdata->debounce * 1000))
> -               extcon_data->debounce_jiffies = 0;
> -
>          INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
>
>          extcon_data->irq = gpio_to_irq(extcon_data->gpio);
> @@ -146,7 +150,8 @@ static int gpio_extcon_remove(struct platform_device *pdev)
>   {
>          struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
>
> -       cancel_delayed_work_sync(&extcon_data->work);
> +       if (extcon_data->debounce_jiffies)
> +               cancel_delayed_work_sync(&extcon_data->work);

I think we would have to call cancel_work_sync() in the else case to make sure
that no work is in the process of being executed - which just turns out to execute
the same code as cancel_delayed_work_sync(). So the if/else would just add complexity
with no real gain.

Thanks,
Guenter

>          free_irq(extcon_data->irq, extcon_data);
>          extcon_dev_unregister(&extcon_data->edev);
>
>
> Thanks,
> Chanwoo Choi
>
>

