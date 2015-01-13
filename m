Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbbAMNYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:24:43 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62793 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbAMNYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:24:41 -0500
MIME-Version: 1.0
In-Reply-To: <1420535817.17567.10.camel@mtksdaap41>
References: <1418772873-19747-1-git-send-email-hongzhou.yang@mediatek.com>
	<1418772873-19747-5-git-send-email-hongzhou.yang@mediatek.com>
	<1418807365.6443.17.camel@mtksdaap41>
	<1420535817.17567.10.camel@mtksdaap41>
Date: Tue, 13 Jan 2015 14:24:40 +0100
Message-ID: <CACRpkdb2KJbjzFgTmDvHSw7jNAExxVtU3y4_fgyn6J8hcW5OrQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] ARM: mediatek: Add EINT support to MTK pinctrl driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Mark Rutland <mark.rutland@arm.com>, maoguang.meng@mediatek.com,
        Catalin Marinas <catalin.marinas@arm.com>, alan.cheng@mediatek.com,
        Russell King <linux@arm.linux.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>, toby.liu@mediatek.com,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, dandan.he@mediatek.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srv_heupstream@mediatek.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 10:16 AM, Yingjoe Chen <yingjoe.chen@mediatek.com> wrote:
> On Wed, 2014-12-17 at 17:09 +0800, Yingjoe Chen wrote:
>> On Wed, 2014-12-17 at 07:34 +0800, Hongzhou Yang wrote:
>> > From: Maoguang Meng <maoguang.meng@mediatek.com>
>> >
>> > MTK SoC support external interrupt(EINT) from most SoC pins.
>> > Add EINT support to pinctrl driver.
>> >
>> > Signed-off-by: Maoguang Meng <maoguang.meng@mediatek.com>
>> > Signed-off-by: Hongzhou Yang <hongzhou.yang@mediatek.com>
>>
>> Hi Linus,
>>
>> This patch add EINT support to the pinctrl driver. We've surveyed
>> GPIOLIB_IRQCHIP, but we didn't use it because:
>>
>> - Not every GPIO pin support interrupt.
>> - EINT use a different numbering to GPIO. eg, from the mt8135 table,
>> GPIO29 is EINT158. It is more nature & efficient to use EINT number as
>> hwirq.
>>
>> +               MTK_EINT_FUNCTION(2, 158),
>> +               MTK_FUNCTION(0, "GPIO29"),
>
> After further looking into this, we could use GPIOLIB_IRQCHIP if we add
> an extension gpiochip_irqchip_add() to accept interrupt numbers and
> custom .to_irq function for our SoC. We could still reuse other code
> GPIOLIB_IRQCHIP provide.

I see, and I still want to see all possibilities to centralize code
surveyed.

If I understand correctly what you actually need is a linear
irqdomain with "holes" (invalid offsets) in it.
So this is what we should design for.

The .to_irq() function should not really perform anything but a
simple lookup in the domain.

What you do here:

+static int mtk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+       const struct mtk_desc_pin *pin;
+       struct mtk_pinctrl *pctl = dev_get_drvdata(chip->dev);
+       int irq;
+
+       pin = pctl->devdata->pins + offset;
+       if (pin->eint.eintnum == NO_EINT_SUPPORT)
+               return -EINVAL;
+
+       irq = irq_find_mapping(pctl->domain, pin->eint.eintnum);
+       if (!irq)
+               return -EINVAL;
+
+       return irq;
+}

Is *avoiding* to translate some IRQs from a certain offset using
the domain, I think that is the wrong way to go.

Instead, we would need to handle these "holes" in
drivers/pinctrl/nomadik/pinctrl-abx500.c also need the same
thing.

Maybe we can add a gpiochip_irqchip_add_sparse() in
gpiolib that will take an array of bools in, indicating of
a certain line is elegible for IRQ or not, e.g.:

bool valid = { false, true, false, true };

foo = gpiochip_irqchip_add_sparse(&chip,
                         &irqchip,
                         0,
                         handler,
                         IRQ_TYPE_NONE,
                         &valid);

So the loop inside the lib will avoid calling
irq_create_mapping() on the invalid lines, and any calls
to irq_find_mapping() will fail if you try to use one of
them for IRQs.

If you're up to do this and test on your driver I'm all in for it.

Yours,
Linus Walleij
