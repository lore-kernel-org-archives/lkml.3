Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3KKPhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:37:37 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49016 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3KKPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:37:28 -0500
MIME-Version: 1.0
In-Reply-To: <5280F545.3040406@ti.com>
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
 <1383905510-31760-6-git-send-email-prabhakar.csengg@gmail.com> <5280F545.3040406@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 11 Nov 2013 21:07:04 +0530
Message-ID: <CA+V-a8tW9dKsE+Ps_MSsr_BsDR2HVE7uEE9GN7yNga3YWoCGow@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] gpio: davinci: add OF support
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

Thanks for the review.

On Mon, Nov 11, 2013 at 8:48 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 11/08/2013 12:11 PM, Prabhakar Lad wrote:
[Snip]
>> @@ -134,6 +137,40 @@ davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>>       writel((1 << offset), value ? &g->set_data : &g->clr_data);
>>   }
>>
>> +static struct davinci_gpio_platform_data *
>> +davinci_gpio_get_pdata(struct platform_device *pdev)
>
> Minor: usually such functions have "_of" in their names:
>  davinci_gpio_of_get_pdata()
>
Ahh but actual this function is intended to get pdata in both the
cases DT and NON-DT, so kept it generic :)

>> +{
>> +     struct device_node *dn = pdev->dev.of_node;
>> +     struct davinci_gpio_platform_data *pdata;
>> +     int ret;
>> +     u32 val;
>> +
>> +     if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
>> +             return pdev->dev.platform_data;
>> +
>> +     pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
>> +     if (!pdata)
>> +             return NULL;
>> +
>> +     ret = of_property_read_u32(dn, "ti,ngpio", &val);
>> +     if (ret)
>> +             goto of_err;
>> +
>> +     pdata->ngpio = val;
>> +
>> +     ret = of_property_read_u32(dn, "ti,davinci-gpio-unbanked", &val);
>> +     if (ret)
>> +             goto of_err;
>> +
>> +     pdata->gpio_unbanked = val;
>> +
>> +     return pdata;
>> +
>> +of_err:
>> +     dev_err(&pdev->dev, "Populating pdata from DT failed: err %d\n", ret);
>> +     return NULL;
>> +}
>> +
>>   static int davinci_gpio_probe(struct platform_device *pdev)
>>   {
>>       int i, base;
>> @@ -144,12 +181,14 @@ static int davinci_gpio_probe(struct platform_device *pdev)
>>       struct device *dev = &pdev->dev;
>>       struct resource *res;
>>
>> -     pdata = dev->platform_data;
>> +     pdata = davinci_gpio_get_pdata(pdev);
>>       if (!pdata) {
>>               dev_err(dev, "No platform data found\n");
>>               return -EINVAL;
>>       }
>>
>> +     dev->platform_data = pdata;
>> +
>
> Pls, add following code to GPIO chip initialization:
>
> @@ -233,6 +245,9 @@ static int davinci_gpio_probe(struct platform_device *pdev)
>                 chips[i].chip.ngpio = ngpio - base;
>                 if (chips[i].chip.ngpio > 32)
>                         chips[i].chip.ngpio = 32;
> +#ifdef CONFIG_OF_GPIO
> +               chips[i].chip.of_node = dev->of_node;
> +#endif
>
>
OK

Regards,
--Prabhakar Lad
