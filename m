Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab3KNBd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 20:33:29 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:52989 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab3KNBdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 20:33:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131113131328.GF878@sirena.org.uk>
References: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
	<1384328457-5147-2-git-send-email-k.kozlowski@samsung.com>
	<20131113131328.GF878@sirena.org.uk>
Date: Thu, 14 Nov 2013 10:33:22 +0900
X-Google-Sender-Auth: 4-XgszsC0UI4AJdtXVz3sxA54uw
Message-ID: <CAH9JG2U9VDnRW9JZ7j7OyRmVhSXWJ5Yp_gNqUPK=xCST7SY=xg@mail.gmail.com>
Subject: Re: [PATCH 1/4] mfd: max14577: Add max14577 MFD driver core
From: Kyungmin Park <kmpark@infradead.org>
To: Mark Brown <broonie@kernel.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 10:13 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Nov 13, 2013 at 08:40:54AM +0100, Krzysztof Kozlowski wrote:
>
>> +/**
>> + * After resuming from suspend it may happen that IRQ is signalled but
>> + * IRQ GPIO is not high. Also the interrupt registers won't have any data
>> + * (all of them equal to 0x00).
>> + *
>> + * In such case retry few times reading the interrupt registers.
>> + */
>> +#define IRQ_READ_REG_RETRY_CNT               5
>
> What is the cause here?  This smells like an unreliable workaround for
> some other behaviour.  In general this all looks very like standard
> regmap code.
>
>> +     for (i = 0; i < MAX14577_IRQ_REGS_NUM; i++) {
>> +             u8 mask_reg = max14577_mask_reg[i];
>> +
>> +             if (mask_reg == MAX14577_REG_INVALID ||
>> +                             IS_ERR_OR_NULL(max14577->regmap))
>> +                     continue;
>
> Why would this code even be running if you don't have a register map?
>
>> +             dev_info(max14577->dev, "Got interrupts [1:0x%02x, 2:0x%02x, 3:0x%02x]\n",
>> +                     irq_reg[MAX14577_IRQ_INT1], irq_reg[MAX14577_IRQ_INT2],
>> +                     irq_reg[MAX14577_IRQ_INT3]);
>
> This is far too noisy, dev_dbg() at most.
>
>> +             gpio_val = gpio_get_value(pdata->irq_gpio);
>> +
>> +             if (gpio_get_value(pdata->irq_gpio) == 0)
>> +                     dev_warn(max14577->dev, "IRQ GPIO is not high, retry reading interrupt registers\n");
>> +     } while (gpio_val == 0 && --retry > 0);
>
> This looks very strange...
>
>> +     max14577->irq = gpio_to_irq(pdata->irq_gpio);
>> +     ret = gpio_request(pdata->irq_gpio, "max14577_irq");
>> +     if (ret) {
>> +             dev_err(max14577->dev, "Failed requesting GPIO %d: %d\n",
>> +                             pdata->irq_gpio, ret);
>> +             goto err;
>> +     }
>> +     gpio_direction_input(pdata->irq_gpio);
>> +     gpio_free(pdata->irq_gpio);
>
> This means the GPIO handling code that was present in the handling is
> broken, it's trying to use the GPIO after it was freed.
>
>> +     ret = request_threaded_irq(max14577->irq, NULL, max14577_irq_thread,
>> +                                IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>> +                                "max14577-irq", max14577);
>
> Are you *positive* this is a falling triggered IRQ?  All the code to do
> with spinning reading the GPIO state during handling makes it look like
> this is in fact an active low interrupt and a lot of the code in here is
> working around trying to handle that as the wrong kind of IRQ.

It's not work with level triggering. as wm8994, it requires edge
triggering. previous time I send RFC patch to handle edge triggering
at regmap.

>
>> +int max14577_bulk_write(struct regmap *map, u8 reg, u8 *buf, int count)
>> +{
>> +     return regmap_bulk_write(map, reg, buf, count);
>> +}
>> +EXPORT_SYMBOL_GPL(max14577_bulk_write);
>
> Given that these are basically all trivial wrappers around regmap they
> probably ought to be static inlines in the header.
>
>> +static struct max14577_platform_data *max14577_i2c_parse_dt(struct device *dev)
>> +{
>
> There's no DT binding document?
>
>> +const struct dev_pm_ops max14577_pm = {
>> +     .suspend = max14577_suspend,
>> +     .resume = max14577_resume,
>> +};
>
> SET_SYSTEM_SLEEP_PM_OPS().
>
>> +static int __init max14577_i2c_init(void)
>> +{
>> +     return i2c_add_driver(&max14577_i2c_driver);
>> +}
>> +subsys_initcall(max14577_i2c_init);
>
> Why not module_i2c_driver?

there's ordering issue, it should provide regulator which is used
others before USB probe. if not, it failed to use USB.
Other PMICs use also subsys_initcall for this reason.

Thank you,
Kyungmin Park
