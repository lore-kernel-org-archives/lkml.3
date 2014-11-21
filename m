Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbaKUHvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 02:51:41 -0500
Received: from smtp102.mer-nm.internl.net ([217.149.192.138]:34565 "EHLO
	smtp102.mer-nm.internl.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098AbaKUHvk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 02:51:40 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.899
X-Spam-Languages: en
Message-ID: <546EEF06.5090300@topic.nl>
Date: Fri, 21 Nov 2014 08:51:34 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, <wim@iguana.be>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] gpio_wdt: Add "always_running" feature to GPIO watchdog
References: <20141120172329.GA10673@roeck-us.net> <1416552828-3589-1-git-send-email-mike.looijmans@topic.nl> <546EE991.1080704@roeck-us.net>
In-Reply-To: <546EE991.1080704@roeck-us.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [192.168.80.45]
X-EXCLAIMER-MD-CONFIG: 9833cda7-5b21-4d34-9a38-8d025ddc3664
X-EXCLAIMER-MD-BIFURCATION-INSTANCE: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿On 11/21/2014 08:28 AM, Guenter Roeck wrote:
> On 11/20/2014 10:53 PM, Mike Looijmans wrote:
>> On some chips, like the TPS386000, the trigger cannot be disabled
>> and the CPU must keep toggling the line at all times. Add a switch
>> "always_running" to keep toggling the GPIO line regardless of the
>> state of the soft part of the watchdog. The "armed" member keeps
>> track of whether a timeout must also cause a reset.
>>
>> Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
>> ---
>>
>> v2: Rename property "always_running" to "always-running" and add devicetree
>> documentation
>>
>>   .../devicetree/bindings/watchdog/gpio-wdt.txt      |    5 +++++
>>   drivers/watchdog/gpio_wdt.c                        |   20
>> +++++++++++++++++---
>>   2 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
>> b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
>> index 37afec1..1987949 100644
>> --- a/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
>> +++ b/Documentation/devicetree/bindings/watchdog/gpio-wdt.txt
>> @@ -13,6 +13,11 @@ Required Properties:
>>       by the GPIO flags.
>>   - hw_margin_ms: Maximum time to reset watchdog circuit (milliseconds).
>>
>> +Optional Properties:
>> +- always-running: If the watchdog timer cannot be disabled, add this flag to
>> +  have the driver keep toggling the signal without a client. It will only
>> cease
>> +  to toggle the signal when the device is open and the timeout elapsed.
>> +
>>   Example:
>>       watchdog: watchdog {
>>           /* ADM706 */
>> diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
>> index 220a9e0..3266215 100644
>> --- a/drivers/watchdog/gpio_wdt.c
>> +++ b/drivers/watchdog/gpio_wdt.c
>> @@ -31,6 +31,8 @@ struct gpio_wdt_priv {
>>       int            gpio;
>>       bool            active_low;
>>       bool            state;
>> +    bool        always_running;
>> +    bool        armed;
>
> Please align columns with the other variables.
>
>>       unsigned int        hw_algo;
>>       unsigned int        hw_margin;
>>       unsigned long        last_jiffies;
>> @@ -56,6 +58,7 @@ static int gpio_wdt_start(struct watchdog_device *wdd)
>>       gpio_direction_output(priv->gpio, priv->state);
>>       priv->last_jiffies = jiffies;
>>       mod_timer(&priv->timer, priv->last_jiffies + priv->hw_margin);
>> +    priv->armed = true;
>>
>>       return 0;
>>   }
>> @@ -64,8 +67,11 @@ static int gpio_wdt_stop(struct watchdog_device *wdd)
>>   {
>>       struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
>>
>> -    mod_timer(&priv->timer, 0);
>> -    gpio_wdt_disable(priv);
>> +    priv->armed = false;
>> +    if (!priv->always_running) {
>> +        mod_timer(&priv->timer, 0);
>> +        gpio_wdt_disable(priv);
>> +    }
>>
>>       return 0;
>>   }
>> @@ -91,7 +97,7 @@ static void gpio_wdt_hwping(unsigned long data)
>>       struct watchdog_device *wdd = (struct watchdog_device *)data;
>>       struct gpio_wdt_priv *priv = watchdog_get_drvdata(wdd);
>>
>> -    if (time_after(jiffies, priv->last_jiffies +
>> +    if (priv->armed && time_after(jiffies, priv->last_jiffies +
>>                  msecs_to_jiffies(wdd->timeout * 1000))) {
>
> Please align continuation lines.

I'm unsure as to how you want them aligned. I thought I adhered to the kernel 
coding guidelines, but please correct me if I did that wrong.

>
>>           dev_crit(wdd->dev, "Timer expired. System will reboot soon!\n");
>>           return;
>> @@ -197,6 +203,9 @@ static int gpio_wdt_probe(struct platform_device *pdev)
>>       /* Use safe value (1/2 of real timeout) */
>>       priv->hw_margin = msecs_to_jiffies(hw_margin / 2);
>>
>> +    priv->always_running = of_property_read_bool(pdev->dev.of_node,
>> +                "always-running");
>> +
> Please align continuation line with '('.
>
>>       watchdog_set_drvdata(&priv->wdd, priv);
>>
>>       priv->wdd.info        = &gpio_wdt_ident;
>> @@ -218,6 +227,11 @@ static int gpio_wdt_probe(struct platform_device *pdev)
>>       if (ret)
>>           watchdog_unregister_device(&priv->wdd);
>>
>> +    if (priv->always_running) {
>> +        gpio_wdt_start(&priv->wdd);
>> +        priv->armed = false;
>> +    }
>> +
>
> This won't work if there is an error. The driver won't load but the timer
> is started, which will likely cause a crash when the timer fires. You'll
> have to fix the error handling.

If you have an "always-running" gpio watchdog and this fails, the error 
handling is going to be the least of your problems (the board I use this patch 
on will power down if you don't toggle the pin every 400ms after POR).

But you're absolutely right, I missed the error handling path here.

An alternative approach would be to make failure to register the notifier a
warning only. It seems harsh to me to let the system commit suicide just 
because the shutdown notification didn't register. On the other hand, the 
notification registration should never fail anyway (out-of-memory will result 
in system failure soon enough).

> I also dislike that you first set priv->armed in the start function and
> then reset it, but I don't have a better idea right now.

I just relied on the compiler's optimizer to remove the first assignment.

Alternative would be to split the start function into two parts, where the 
"armed" assignment is omitted from the upper part and call the upper part from 
probe only.

>
> Guenter
>
>>       return ret;
>>   }
>>
>>
>



Met vriendelijke groet / kind regards,

Mike Looijmans
System Expert


TOPIC Embedded Systems
Eindhovenseweg 32-C, NL-5683 KH Best
Postbus 440, NL-5680 AK Best
Telefoon: (+31) (0) 499 33 69 79
Telefax:  (+31) (0) 499 33 69 70
E-mail: mike.looijmans@topic.nl
Website: www.topic.nl

Please consider the environment before printing this e-mail

Visit us at Bits & Chips Smart Systems 20th November, 1931 Congrescentum Brabanthallen 's-Hertogenbosch, stand number 34
http://bc-smartsystems.nl

