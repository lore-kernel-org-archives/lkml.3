Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab3HTJDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:03:39 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:11400 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447Ab3HTJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:03:37 -0400
Message-ID: <521330DD.2080308@atmel.com>
Date: Tue, 20 Aug 2013 17:03:25 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: <linux-pwm@vger.kernel.org>, Thierry Reding <thierry.reding@gmail.com>,
        <plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH] pwm: atmel-pwm: add pwm controller driver
References: <1376881866-14214-1-git-send-email-voice.shen@atmel.com> <521329D0.1090104@atmel.com>
In-Reply-To: <521329D0.1090104@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 8/20/2013 16:33, Nicolas Ferre wrote:
> On 19/08/2013 05:11, Bo Shen :
>> add atmel pwm controller driver based on PWM framework
>>
>> this is basic function implementation of pwm controller
>> it can work with pwm based led and backlight
>>
>> Signed-off-by: Bo Shen <voice.shen@atmel.com>
>>
>> ---
>> This patch is based on Linux v3.11 rc6
>> Tested on sama5d31ek and at91sam9m10g45ek board
>> ---
>>   .../devicetree/bindings/pwm/atmel-pwm.txt          |   19 ++
>>   drivers/pwm/Kconfig                                |    9 +
>>   drivers/pwm/Makefile                               |    1 +
>>   drivers/pwm/pwm-atmel.c                            |  327
>> ++++++++++++++++++++
>>   4 files changed, 356 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/pwm/atmel-pwm.txt
>>   create mode 100644 drivers/pwm/pwm-atmel.c
>>
>> diff --git a/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
>> b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
>> new file mode 100644
>> index 0000000..127fcdb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
>> @@ -0,0 +1,19 @@
>> +Atmel PWM controller
>> +
>> +Required properties:
>> +  - compatible: should be one of:
>> +    - "atmel,at91sam9rl-pwm"
>> +    - "atmel,sama5-pwm"
>
> No, the compatibility string should be: "atmel,sama5d3-pwm"

OK, I will change it in next version.

>> +  - reg: physical base address and length of the controller's registers
>> +  - #pwm-cells: Should be 3.
>> +    - The first cell specifies the per-chip index of the PWM to use
>> +    - The second cell is the period in nanoseconds
>> +    - The third cell is used to encode the polarity of PWM output
>> +
>> +Example:
>> +
>> +    pwm0: pwm@f8034000 {
>> +        compatible = "atmel,at91sam9rl-pwm";
>> +        reg = <0xf8034000 0x400>;
>> +        #pwm-cells = <3>;
>> +    };
>
> Can you add an example of consumer: it would make the example much more
> understandable.

I will add an example of consumer.

[...]

>> diff --git a/drivers/pwm/pwm-atmel.c b/drivers/pwm/pwm-atmel.c
>> new file mode 100644
>> index 0000000..b83d68e
>> --- /dev/null
>> +++ b/drivers/pwm/pwm-atmel.c
>> @@ -0,0 +1,327 @@
>> +/*
>> + * Driver for Atmel Pulse Width Modulation Controller
>> + *
>> + * Copyright (C) 2013 Atmel Semiconductor Technology Ltd.
>
> use "Atmel Corporation" in copyright.
>
>> + *         Bo Shen <voice.shen@atmel.com>
>> + *
>> + * GPL v2 or later
>> + */
>
> A general remark also pointed out by Thierry: please use more defined
> constants in your code: it makes the code more readable and avoid this
> black magic feeling when we read it.

Please help review v2.

>
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pwm.h>
>> +#include <linux/slab.h>
>> +
>> +#define PWM_MR        0x00
>> +#define PWM_ENA        0x04
>> +#define PWM_DIS        0x08
>> +#define PWM_SR        0x0C
>> +
>> +#define PWM_CMR        0x00
>> +
>> +/* The following register for PWM v1 */
>> +#define PWMv1_CDTY    0x04
>> +#define PWMv1_CPRD    0x08
>> +#define PWMv1_CUPD    0x10
>> +
>> +/* The following register for PWM v2 */
>> +#define PWMv2_CDTY    0x04
>> +#define PWMv2_CDTYUPD    0x08
>> +#define PWMv2_CPRD    0x0C
>> +#define PWMv2_CPRDUPD    0x10
>> +
>> +#define PWM_NUM        4
>> +
>> +struct atmel_pwm_chip {
>> +    struct pwm_chip chip;
>> +    struct clk *clk;
>> +    void __iomem *base;
>> +
>> +    void (*config)(struct atmel_pwm_chip *chip, struct pwm_device *pwm,
>> +            unsigned int dty, unsigned int prd);
>> +};
>> +
>> +#define to_atmel_pwm_chip(chip) container_of(chip, struct
>> atmel_pwm_chip, chip)
>> +
>> +static inline u32 atmel_pwm_readl(struct atmel_pwm_chip *chip, int
>> offset)
>> +{
>> +    return readl(chip->base + offset);
>> +}
>> +
>> +static inline void atmel_pwm_writel(struct atmel_pwm_chip *chip, int
>> offset,
>> +        u32 val)
>> +{
>> +    writel(val, chip->base + offset);
>> +}
>> +
>> +static inline u32 atmel_pwm_ch_readl(struct atmel_pwm_chip *chip, int
>> ch,
>> +        int offset)
>> +{
>> +    return readl(chip->base + 0x200 + ch * 0x20 + offset);
>
> Maybe a constant for this 0x200 value...

OK. I will fix it in net version.

>> +}
>> +
>> +static inline void atmel_pwm_ch_writel(struct atmel_pwm_chip *chip,
>> int ch,
>> +        int offset, u32 val)
>> +{
>> +    writel(val, chip->base + 0x200 + ch * 0x20 + offset);
>> +}
>> +
>> +static int atmel_pwm_config(struct pwm_chip *chip, struct pwm_device
>> *pwm,
>> +        int duty_ns, int period_ns)
>> +{
>> +    struct atmel_pwm_chip *atmel_pwm = to_atmel_pwm_chip(chip);
>> +    unsigned long long val, prd, dty;
>> +    unsigned long long div, clk_rate;
>> +    int ret, pres = 0;
>> +
>> +    clk_rate = clk_get_rate(atmel_pwm->clk);
>> +
>> +    while (1) {
>
> Why not use a proper loop condition here instead of a frightening
> while (true) loop? Is it really making the code less readable?

OK, I will try to use the proper loop condition here.

>> +        div = 1000000000;
>
> use a constant or at least a comment for this initialization.

I will add comment in next version.

>> +        div *= 1 << pres;
>> +        val = clk_rate * period_ns;
>> +        prd = div_u64(val, div);
>> +        val = clk_rate * duty_ns;
>> +        dty = div_u64(val, div);
>> +
>> +        if (prd < 0x0001 || dty < 0x0)
>> +            return -EINVAL;
>> +
>> +        if (prd > 0xffff || dty > 0xffff) {
>
> Yes, here define those constants please.

Please help review v2.

>> +            if (++pres > 0x10)
>> +                return -EINVAL;
>> +            continue;
>> +        }
>> +
>> +        break;
>> +    }
>> +
>> +    /* Enable clock */
>> +    ret = clk_prepare_enable(atmel_pwm->clk);
>> +    if (ret) {
>> +        pr_err("failed to enable pwm clock\n");
>> +        return ret;
>> +    }
>> +
>> +    atmel_pwm->config(atmel_pwm, pwm, dty, prd);
>> +
>> +    /* Check whether need to disable clock */
>> +    val = atmel_pwm_readl(atmel_pwm, PWM_SR);
>> +    if ((val & 0xf) == 0)
>
> Ditto.
>
>> +        clk_disable_unprepare(atmel_pwm->clk);
>> +
>> +    return 0;
>> +}
>> +

Best Regards,
Bo Shen

