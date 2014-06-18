Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965515AbaFRJWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:22:09 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:55764 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781AbaFRJWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:22:06 -0400
Message-ID: <53A15A34.10805@collabora.co.uk>
Date: Wed, 18 Jun 2014 11:21:56 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] mfd: max77686: Convert to use regmap_irq
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>	<1402941758-11216-2-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=VUPwr6GbR7O-t0q-GaCttZ5vGzLeFqHckzkk-dZYfCFw@mail.gmail.com>
In-Reply-To: <CAD=FV=VUPwr6GbR7O-t0q-GaCttZ5vGzLeFqHckzkk-dZYfCFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 06/17/2014 10:57 PM, Doug Anderson wrote:
> Javier,
> 
> On Mon, Jun 16, 2014 at 11:02 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> @@ -127,15 +175,48 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>>         }
>>         i2c_set_clientdata(max77686->rtc, max77686);
>>
>> -       max77686_irq_init(max77686);
>> +       max77686->rtc_regmap = devm_regmap_init_i2c(max77686->rtc,
>> +                                                   &max77686_rtc_regmap_config);
>> +       if (IS_ERR(max77686->rtc_regmap)) {
>> +               ret = PTR_ERR(max77686->rtc_regmap);
>> +               dev_err(max77686->dev, "failed to allocate RTC regmap: %d\n",
>> +                       ret);
>> +               goto err_unregister_i2c;
>> +       }
>> +
>> +       ret = regmap_add_irq_chip(max77686->regmap, max77686->irq,
>> +                                 IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
>> +                                 IRQF_SHARED, 0, &max77686_irq_chip,
>> +                                 &max77686->irq_data);
>> +       if (ret != 0) {
>> +               dev_err(&i2c->dev, "failed to add PMIC irq chip: %d\n", ret);
>> +               goto err_unregister_i2c;
>> +       }
>> +       ret = regmap_add_irq_chip(max77686->rtc_regmap, max77686->irq,
>> +                                 IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
>> +                                 IRQF_SHARED, 0, &max77686_rtc_irq_chip,
>> +                                 &max77686->rtc_irq_data);
>> +       if (ret != 0) {
>> +               dev_err(&i2c->dev, "failed to add RTC irq chip: %d\n", ret);
>> +               goto err_del_irqc;
>> +       }
>>
>>         ret = mfd_add_devices(max77686->dev, -1, max77686_devs,
>>                               ARRAY_SIZE(max77686_devs), NULL, 0, NULL);
>>         if (ret < 0) {
>> -               mfd_remove_devices(max77686->dev);
>> -               i2c_unregister_device(max77686->rtc);
>> +               dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
>> +               goto err_del_rtc_irqc;
>>         }
>>
>> +       return 0;
>> +
>> +err_del_rtc_irqc:
>> +       regmap_del_irq_chip(max77686->irq, max77686->rtc_irq_data);
>> +err_del_irqc:
>> +       regmap_del_irq_chip(max77686->irq, max77686->irq_data);
> 
> I would imagine you either don't need these regmap_del_irq_chip() here
> or that you _do_ need them in max77686_i2c_remove().
> 
> ...from looking at other drivers I think the answer is to add them to
> max77686_i2c_remove().
> 
>

Yes, I forgot to do the regmap irqchip cleanup in the driver .remove function.
The same issue is in the max77802 driver btw so I'll fix both on v3.

Thanks a lot for pointing this out.

>> diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
>> index 8c75a9c..3a810b1 100644
>> --- a/include/linux/mfd/max77686-private.h
>> +++ b/include/linux/mfd/max77686-private.h
>> @@ -205,7 +205,7 @@ enum max77686_irq {
>>         MAX77686_PMICIRQ_140C,
>>         MAX77686_PMICIRQ_120C,
>>
>> -       MAX77686_RTCIRQ_RTC60S,
>> +       MAX77686_RTCIRQ_RTC60S = 0,
>>         MAX77686_RTCIRQ_RTCA1,
>>         MAX77686_RTCIRQ_RTCA2,
>>         MAX77686_RTCIRQ_SMPL,
>> @@ -215,6 +215,25 @@ enum max77686_irq {
>>         MAX77686_IRQ_NR,
> 
> Maybe remove MAX77686_IRQ_NR which no longer makes any sense now that
> you start over at 0 partway through.
> 
> 

Right, it is not needed anymore. I'll remove it when re-spin.

> Overall this looks good to me, so once nits above are fixed feel to
> add my Reviewed-by.  I've also built and booted this patch on
> exynos5250-snow and tested that the RTC wakealarm fires and can even
> wake the system up (with some additional work that I'll email you
> about).
>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>
> 

Great! thanks a lot for testing.

Best regards,
Javier
