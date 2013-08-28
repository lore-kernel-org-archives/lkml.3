Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3H1IIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:08:20 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:18078 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab3H1IIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:08:17 -0400
Message-ID: <521DB007.5040405@atmel.com>
Date: Wed, 28 Aug 2013 10:08:39 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pinctrl: at91: add support for OUTPUT config
References: <1377615082-16808-1-git-send-email-b.brezillon@overkiz.com> <521DA744.1020807@atmel.com> <521DA82C.7020905@overkiz.com> <521DAA28.2070507@atmel.com>
In-Reply-To: <521DAA28.2070507@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/2013 09:43, Nicolas Ferre :
> On 28/08/2013 09:35, boris brezillon :
>> On 28/08/2013 09:31, Nicolas Ferre wrote:
>>> On 27/08/2013 16:51, Boris BREZILLON :
>>>> Add support for pin output control through the pinctrl config:
>>>>     - support enabling/disabling output on a given pin
>>>>     - support output level setting (high or low)
>>>>
>>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>>> ---
>>>>     .../bindings/pinctrl/atmel,at91-pinctrl.txt        |    2 ++
>>>>     drivers/pinctrl/pinctrl-at91.c                     |   22
>>>> ++++++++++++++++++++
>>>>     include/dt-bindings/pinctrl/at91.h                 |    2 ++
>>>>     3 files changed, 26 insertions(+)
>>>>
>>>> diff --git
>>>> a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>>>> b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>>>> index cf7c7bc..5a22e0d 100644
>>>> --- a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>>>> +++ b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>>>> @@ -90,6 +90,8 @@ MULTIDRIVE    (1 << 1): indicate this pin need to
>>>> be configured as multidrive.
>>>>     DEGLITCH    (1 << 2): indicate this pin need deglitch.
>>>>     PULL_DOWN    (1 << 3): indicate this pin need a pull down.
>>>>     DIS_SCHMIT    (1 << 4): indicate this pin need to disable schmit
>>>> trigger.
>>>> +OUTPUT        (1 << 5): indicate this pin need to be configured as
>>>> an output.
>>>> +OUTPUT_VAL    (0x1 << 6): output val (1 = high, 0 = low)
>>>>     DEBOUNCE    (1 << 16): indicate this pin need debounce.
>>>>     DEBOUNCE_VAL    (0x3fff << 17): debounce val.
>>>>
>>>> diff --git a/drivers/pinctrl/pinctrl-at91.c
>>>> b/drivers/pinctrl/pinctrl-at91.c
>>>> index 19afb9a..1578a0d 100644
>>>> --- a/drivers/pinctrl/pinctrl-at91.c
>>>> +++ b/drivers/pinctrl/pinctrl-at91.c
>>>> @@ -61,6 +61,9 @@ static int gpio_banks;
>>>>     #define DEGLITCH    (1 << 2)
>>>>     #define PULL_DOWN    (1 << 3)
>>>>     #define DIS_SCHMIT    (1 << 4)
>>>> +#define OUTPUT        (1 << 5)
>>>> +#define OUTPUT_VAL_SHIFT    6
>>>> +#define OUTPUT_VAL    (0x1 << OUTPUT_VAL_SHIFT)
>>>>     #define DEBOUNCE    (1 << 16)
>>>>     #define DEBOUNCE_VAL_SHIFT    17
>>>>     #define DEBOUNCE_VAL    (0x3fff << DEBOUNCE_VAL_SHIFT)
>>>> @@ -333,6 +336,19 @@ static void at91_mux_set_pullup(void __iomem
>>>> *pio, unsigned mask, bool on)
>>>>         writel_relaxed(mask, pio + (on ? PIO_PUER : PIO_PUDR));
>>>>     }
>>>>
>>>> +static bool at91_mux_get_output(void __iomem *pio, unsigned pin,
>>>> bool *val)
>>>> +{
>>>> +    *val = (readl_relaxed(pio + PIO_ODSR) >> pin) & 0x1;
>>>> +    return (readl_relaxed(pio + PIO_OSR) >> pin) & 0x1;
>>>> +}
>>>> +
>>>> +static void at91_mux_set_output(void __iomem *pio, unsigned mask,
>>>> bool is_on,
>>>> +                bool val)
>>>> +{
>>>> +    writel_relaxed(mask, pio + (val ? PIO_SODR : PIO_CODR));
>>>> +    writel_relaxed(mask, pio + (is_on ? PIO_OER : PIO_ODR));
>>>> +}
>>>> +
>>>>     static unsigned at91_mux_get_multidrive(void __iomem *pio, unsigned
>>>> pin)
>>>>     {
>>>>         return (readl_relaxed(pio + PIO_MDSR) >> pin) & 0x1;
>>>> @@ -712,6 +728,7 @@ static int at91_pinconf_get(struct pinctrl_dev
>>>> *pctldev,
>>>>         void __iomem *pio;
>>>>         unsigned pin;
>>>>         int div;
>>>> +    bool out;
>>>>
>>>>         dev_dbg(info->dev, "%s:%d, pin_id=%d, config=0x%lx", __func__,
>>>> __LINE__, pin_id, *config);
>>>>         pio = pin_to_controller(info, pin_to_bank(pin_id));
>>>> @@ -732,6 +749,9 @@ static int at91_pinconf_get(struct pinctrl_dev
>>>> *pctldev,
>>>>         if (info->ops->get_schmitt_trig &&
>>>> info->ops->get_schmitt_trig(pio, pin))
>>>>             *config |= DIS_SCHMIT;
>>>>
>>>> +    if (at91_mux_get_output(pio, pin, &out))
>>>> +        *config |= OUTPUT | (out << OUTPUT_VAL_SHIFT);
>>>> +
>>>>         return 0;
>>>>     }
>>>>
>>>> @@ -749,6 +769,8 @@ static int at91_pinconf_set(struct pinctrl_dev
>>>> *pctldev,
>>>>         if (config & PULL_UP && config & PULL_DOWN)
>>>>             return -EINVAL;
>>>>
>>>> +    at91_mux_set_output(pio, mask, config & OUTPUT,
>>>> +                (config & OUTPUT_VAL) >> OUTPUT_VAL_SHIFT);
>>>>         at91_mux_set_pullup(pio, mask, config & PULL_UP);
>>>>         at91_mux_set_multidrive(pio, mask, config & MULTI_DRIVE);
>>>>         if (info->ops->set_deglitch)
>>>> diff --git a/include/dt-bindings/pinctrl/at91.h
>>>> b/include/dt-bindings/pinctrl/at91.h
>>>> index d7988b4..9fd4d48 100644
>>>> --- a/include/dt-bindings/pinctrl/at91.h
>>>> +++ b/include/dt-bindings/pinctrl/at91.h
>>>> @@ -15,6 +15,8 @@
>>>>     #define AT91_PINCTRL_DEGLITCH        (1 << 2)
>>>>     #define AT91_PINCTRL_PULL_DOWN        (1 << 3)
>>>>     #define AT91_PINCTRL_DIS_SCHMIT        (1 << 4)
>>>> +#define AT91_PINCTRL_OUTPUT        (1 << 5)
>>>> +#define AT91_PINCTRL_OUTPUT_VAL(x)    ((x & 0x1) << 6)
>>>
>>> Can you add this change to the documentation as well:
>>> Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt

Oops! it is already in this patch: sorry for the noise!


>>>>     #define AT91_PINCTRL_DEBOUNCE        (1 << 16)
>>>>     #define AT91_PINCTRL_DEBOUNCE_VA(x)    (x << 17)
>>>
>>> Oh, we have a nice typo here! ---^^^^^^
>>> And moreover it would be good to add the mask as well.
>>
>> Do you want me to fix this typo and add mask for DEBOUNCE
>> in a separate patch ?
>
> Yep, if you want.
>
>>> Once the documentation added, you can stick my:

No condition anymore here then.

>>>
>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>>
>>> Thanks, bye,
>>
>>
>>
>
>


-- 
Nicolas Ferre
