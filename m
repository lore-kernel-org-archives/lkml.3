Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077Ab3CEC4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:56:45 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7256 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891Ab3CEC4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:56:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 04 Mar 2013 18:50:50 -0800
Message-ID: <51355FA4.1090909@nvidia.com>
Date: Tue, 5 Mar 2013 11:59:48 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Andrew Chew <AChew@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] pwm_bl: Add support for backlight enable GPIO
References: <1362433790-22560-1-git-send-email-achew@nvidia.com> <20130304224611.GB17149@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130304224611.GB17149@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 07:46 AM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Mon, Mar 04, 2013 at 01:49:49PM -0800, Andrew Chew wrote:
>> The backlight enable GPIO is specified in the device tree node for
>> backlight.
>>
>> Signed-off-by: Andrew Chew <achew@nvidia.com>
>> ---
>>   .../bindings/video/backlight/pwm-backlight.txt     |    2 ++
>>   drivers/video/backlight/pwm_bl.c                   |   32 +++++++++++++++++---
>>   include/linux/pwm_backlight.h                      |    2 ++
>>   3 files changed, 32 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>> index 1e4fc72..1ed4f0f 100644
>> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
>> @@ -14,6 +14,8 @@ Required properties:
>>   Optional properties:
>>     - pwm-names: a list of names for the PWM devices specified in the
>>                  "pwms" property (see PWM binding[0])
>> +  - enable-gpio: a GPIO that needs to be used to enable the backlight
>> +  - enable-gpio-active-high: polarity of GPIO is active high (default is low)
>>
>>   [0]: Documentation/devicetree/bindings/pwm/pwm.txt
>>
>> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
>> index 069983c..f29f9c7 100644
>> --- a/drivers/video/backlight/pwm_bl.c
>> +++ b/drivers/video/backlight/pwm_bl.c
>> @@ -20,10 +20,13 @@
>>   #include <linux/pwm.h>
>>   #include <linux/pwm_backlight.h>
>>   #include <linux/slab.h>
>> +#include <linux/of_gpio.h>
>>
>>   struct pwm_bl_data {
>>   	struct pwm_device	*pwm;
>>   	struct device		*dev;
>> +	int			enable_gpio;
>> +	unsigned int		enable_gpio_flags;
>>   	unsigned int		period;
>>   	unsigned int		lth_brightness;
>>   	unsigned int		*levels;
>> @@ -146,10 +149,15 @@ static int pwm_backlight_parse_dt(struct device *dev,
>>   	}
>>
>>   	/*
>> -	 * TODO: Most users of this driver use a number of GPIOs to control
>> -	 *       backlight power. Support for specifying these needs to be
>> -	 *       added.
>> +	 * If "enable-gpio" is present, use that GPIO to enable the backlight.
>> +	 * The presence (or not) of "enable-gpio-active-high" will determine
>> +	 * the value of the GPIO.
>>   	 */
>> +	data->enable_gpio = of_get_named_gpio(node, "enable-gpio", 0);
>> +	if (of_property_read_bool(node, "enable-gpio-active-high"))
>> +		data->enable_gpio_flags = GPIOF_OUT_INIT_HIGH;
>> +	else
>> +		data->enable_gpio_flags = GPIOF_OUT_INIT_LOW;
>>
>>   	return 0;
>>   }
>> @@ -207,12 +215,23 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>>   	} else
>>   		max = data->max_brightness;
>>
>> +	pb->enable_gpio = data->enable_gpio;
>> +	pb->enable_gpio_flags = data->enable_gpio_flags;
>>   	pb->notify = data->notify;
>>   	pb->notify_after = data->notify_after;
>>   	pb->check_fb = data->check_fb;
>>   	pb->exit = data->exit;
>>   	pb->dev = &pdev->dev;
>>
>> +	if (gpio_is_valid(pb->enable_gpio)) {
>> +		ret = gpio_request_one(pb->enable_gpio,
>> +			GPIOF_DIR_OUT | pb->enable_gpio_flags, "bl_en");
>> +		if (ret) {
>> +			dev_err(&pdev->dev, "failed to allocate bl_en gpio");
>> +			goto err_alloc;
>> +		}
>> +	}
>> +
>>   	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
>>   	if (IS_ERR(pb->pwm)) {
>>   		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
>> @@ -221,7 +240,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>>   		if (IS_ERR(pb->pwm)) {
>>   			dev_err(&pdev->dev, "unable to request legacy PWM\n");
>>   			ret = PTR_ERR(pb->pwm);
>> -			goto err_alloc;
>> +			goto err_gpio;
>>   		}
>>   	}
>>
>> @@ -255,6 +274,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>>   	platform_set_drvdata(pdev, bl);
>>   	return 0;
>>
>> +err_gpio:
>> +	if (gpio_is_valid(data->enable_gpio))
>> +		gpio_free(data->enable_gpio);
>>   err_alloc:
>>   	if (data->exit)
>>   		data->exit(&pdev->dev);
>> @@ -269,6 +291,8 @@ static int pwm_backlight_remove(struct platform_device *pdev)
>>   	backlight_device_unregister(bl);
>>   	pwm_config(pb->pwm, 0, pb->period);
>>   	pwm_disable(pb->pwm);
>> +	if (gpio_is_valid(pb->enable_gpio))
>> +		gpio_free(pb->enable_gpio);
>>   	if (pb->exit)
>>   		pb->exit(&pdev->dev);
>>   	return 0;
>> diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
>> index 56f4a86..2706805 100644
>> --- a/include/linux/pwm_backlight.h
>> +++ b/include/linux/pwm_backlight.h
>> @@ -8,6 +8,8 @@
>>
>>   struct platform_pwm_backlight_data {
>>   	int pwm_id;
>> +	int enable_gpio;
>> +	unsigned int enable_gpio_flags;
>>   	unsigned int max_brightness;
>>   	unsigned int dft_brightness;
>>   	unsigned int lth_brightness;
>
> Hi Andrew,
>
> I'm Cc'ing Alexandre Courbot, who has been working on supporting this in
> a more generic way using power sequences. Generally this kind of support
> really belongs in the common display framework, but I guess we could add
> this one GPIO since it really is related only to the backlight. Usually
> more than just an enable for the backlight is required so I'm not sure
> how useful this really is.
>
> Alex, any thought?

It is very common for a GPIO to be involved in powering the backlight 
on, indeed. However it seems that in this patch the GPIO is set once and 
for all during probe and never touched afterwards. This means the 
backlight is still enabled (and consuming power) even when its value is 
zero - I'd at least like to see the GPIO disabled when this is the case 
to save power. Otherwise you can achieve the same result with a 
gpio-regulator defined to be always on in the DT, without touching the 
pwm-backlight driver.

Another issue is that if the GPIO is not explicitly set to -1 in the 
platform data, probe will try to acquire GPIO 0 and will fail. This 
would break compatibility with all existing users of pwm-backlight that 
rely on platform data.

And there is also the fact that the powering of backlights is often 
slightly more complicated than just an enabling GPIO - for Ventana we 
have at least one more regulator/GPIO involved. Maybe this regulator 
could be turned on forever in the DT - then pwm-backlight could use the 
enable GPIO to save power, but I suspect we would save even more power 
if we could turn the regulator off as well.

But overall I'm not against having enable GPIO support in this driver if 
this helps getting the job done while I finish proper power-sequence 
support. Andrew, does this single patch allow you to enable the 
backlight on some boards?

Alex.
