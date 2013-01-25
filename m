Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab3AYNHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:07:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60054 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab3AYNHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:07:35 -0500
Message-ID: <51028388.3050903@ti.com>
Date: Fri, 25 Jan 2013 14:07:20 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: <florian.vaussard@epfl.ch>
CC: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-leds@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can sleep
References: <1359108114-16998-1-git-send-email-florian.vaussard@epfl.ch> <1359108114-16998-4-git-send-email-florian.vaussard@epfl.ch> <51028041.2060504@ti.com> <510282C9.5020509@epfl.ch>
In-Reply-To: <510282C9.5020509@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 02:04 PM, Florian Vaussard wrote:

>>> @@ -153,6 +182,8 @@ static int led_pwm_probe(struct platform_device *pdev)
>>>               led_dat->cdev.max_brightness = cur_led->max_brightness;
>>>               led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
>>>
>>> +            INIT_WORK(&led_dat->work, led_pwm_work);
>>
>> If we query the can_sleep before we can skip the INIT_WORK() when it is not
>> set.
>>
> 
> I will do like this.

On the other hand you should also check at remove time that you are not going
to cancel a work on a non initialized one.

> 
>>> +
>>>               ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
>>>               if (ret < 0)
>>>                   goto err;
>>> @@ -180,8 +211,10 @@ static int led_pwm_remove(struct platform_device *pdev)
>>>       struct led_pwm_priv *priv = platform_get_drvdata(pdev);
>>>       int i;
>>>
>>> -    for (i = 0; i < priv->num_leds; i++)
>>> +    for (i = 0; i < priv->num_leds; i++) {
>>>           led_classdev_unregister(&priv->leds[i].cdev);
>>> +        cancel_work_sync(&priv->leds[i].work);
>>> +    }
>>>
>>>       return 0;
>>>   }
>>>
>>
>>
> 
> Thank you,
> 
> Florian


-- 
Péter
