Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaIVJyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:54:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58316 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaIVJyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:54:20 -0400
Message-ID: <541FF138.7040908@ti.com>
Date: Mon, 22 Sep 2014 15:21:52 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <myungjoo.ham@samsung.com>, <grant.likely@linaro.org>,
        <rongjun.ying@csr.com>, <linux@roeck-us.net>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] extcon: gpio: Convert the driver to use gpio desc
 API's
References: <1410236078-11713-1-git-send-email-george.cherian@ti.com> <1410236078-11713-3-git-send-email-george.cherian@ti.com> <541FD8CD.1060400@samsung.com>
In-Reply-To: <541FD8CD.1060400@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/22/2014 01:37 PM, Chanwoo Choi wrote:
> Hi George,
>
> This patch removes 'gpio_active_low' field of struct gpio_extcon_data.
> But, include/linux/extcon-gpio.h has the description of 'gpio_active_low' field.
Yes didn't want the platform data users to break.
Actually I couldn't find any platform users for this driver. Could you 
please point me to
one if in case I missed it. If non present then why cant we get rid of 
platform data altogether.
>
> Also,
> This patch has not included the any description/comment of removing 'gpio_active_low'.
>
> Also,
> How to set 'FLAG_ACTIVE_LOW' bit for gpio when using platform data?
Now that we are using gpiod_* API's  we need not check for 
gpio_active_low from this driver.

> This patch don't call 'set_bit()' function to set FLAG_ACTIVE_LOW flag.
>
> Thanks,
> Chanwoo Choi
>
> On 09/09/2014 01:14 PM, George Cherian wrote:
>> Convert the driver to use gpiod_* API's.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   drivers/extcon/extcon-gpio.c | 18 +++++++-----------
>>   1 file changed, 7 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
>> index 72f19a3..25269f6 100644
>> --- a/drivers/extcon/extcon-gpio.c
>> +++ b/drivers/extcon/extcon-gpio.c
>> @@ -33,8 +33,7 @@
>>   
>>   struct gpio_extcon_data {
>>   	struct extcon_dev *edev;
>> -	unsigned gpio;
>> -	bool gpio_active_low;
>> +	struct gpio_desc *gpiod;
>>   	const char *state_on;
>>   	const char *state_off;
>>   	int irq;
>> @@ -50,9 +49,7 @@ static void gpio_extcon_work(struct work_struct *work)
>>   		container_of(to_delayed_work(work), struct gpio_extcon_data,
>>   			     work);
>>   
>> -	state = gpio_get_value(data->gpio);
>> -	if (data->gpio_active_low)
>> -		state = !state;
>> +	state = gpiod_get_value(data->gpiod);
>>   	extcon_set_state(data->edev, state);
>>   }
>>   
>> @@ -106,22 +103,21 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>   	}
>>   	extcon_data->edev->name = pdata->name;
>>   
>> -	extcon_data->gpio = pdata->gpio;
>> -	extcon_data->gpio_active_low = pdata->gpio_active_low;
>> +	extcon_data->gpiod = gpio_to_desc(pdata->gpio);
>>   	extcon_data->state_on = pdata->state_on;
>>   	extcon_data->state_off = pdata->state_off;
>>   	extcon_data->check_on_resume = pdata->check_on_resume;
>>   	if (pdata->state_on && pdata->state_off)
>>   		extcon_data->edev->print_state = extcon_gpio_print_state;
>>   
>> -	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
>> +	ret = devm_gpio_request_one(&pdev->dev, pdata->gpio, GPIOF_DIR_IN,
>>   				    pdev->name);
>>   	if (ret < 0)
>>   		return ret;
>>   
>>   	if (pdata->debounce) {
>> -		ret = gpio_set_debounce(extcon_data->gpio,
>> -					pdata->debounce * 1000);
>> +		ret = gpiod_set_debounce(extcon_data->gpiod,
>> +					 pdata->debounce * 1000);
>>   		if (ret < 0)
>>   			extcon_data->debounce_jiffies =
>>   				msecs_to_jiffies(pdata->debounce);
>> @@ -133,7 +129,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>>   
>>   	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
>>   
>> -	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
>> +	extcon_data->irq = gpiod_to_irq(extcon_data->gpiod);
>>   	if (extcon_data->irq < 0)
>>   		return extcon_data->irq;
>>   
>>

