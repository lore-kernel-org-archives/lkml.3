Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab3JHIYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:24:41 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:45554 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3JHIYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:24:37 -0400
Message-ID: <5253C142.2080808@atmel.com>
Date: Tue, 8 Oct 2013 10:24:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, "Felipe Balbi" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 05/19] clk: at91: add PMC main clock
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375938369-4002-1-git-send-email-b.brezillon@overkiz.com> <5252E6AB.1000607@atmel.com> <52530744.60701@overkiz.com>
In-Reply-To: <52530744.60701@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 21:11, boris brezillon :
> On 07/10/2013 18:51, Nicolas Ferre wrote:
>> On 08/08/2013 07:06, Boris BREZILLON :
>>> This patch adds new at91 main oscillator clock implementation using
>>> common
>>> clk framework.
>>>
>>> If rate is not provided during clock registration it is calculated using
>>> the slow clock (main clk parent in this case) rate and MCFR register.
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>> ---
>>>    drivers/clk/at91/Makefile   |    1 +
>>>    drivers/clk/at91/clk-main.c |  171
>>> +++++++++++++++++++++++++++++++++++++++++++
>>>    drivers/clk/at91/pmc.c      |    5 ++
>>>    drivers/clk/at91/pmc.h      |    3 +
>>>    4 files changed, 180 insertions(+)
>>>    create mode 100644 drivers/clk/at91/clk-main.c
>>>
>>> diff --git a/drivers/clk/at91/Makefile b/drivers/clk/at91/Makefile
>>> index 1d4fb21..44105bd 100644
>>> --- a/drivers/clk/at91/Makefile
>>> +++ b/drivers/clk/at91/Makefile
>>> @@ -3,3 +3,4 @@
>>>    #
>>>
>>>    obj-y += pmc.o
>>> +obj-y += clk-main.o
>>> diff --git a/drivers/clk/at91/clk-main.c b/drivers/clk/at91/clk-main.c
>>> new file mode 100644
>>> index 0000000..68738dd
>>> --- /dev/null
>>> +++ b/drivers/clk/at91/clk-main.c
>>> @@ -0,0 +1,171 @@
>>> +/*
>>> + * drivers/clk/at91/clk-main.c
>>> + *
>>> + *  Copyright (C) 2013 Boris BREZILLON <b.brezillon@overkiz.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + */
>>> +
>>> +#include <linux/clk-provider.h>
>>> +#include <linux/clkdev.h>
>>> +#include <linux/clk/at91_pmc.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/of_irq.h>
>>> +#include <linux/io.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/irq.h>
>>> +#include <linux/sched.h>
>>> +#include <linux/wait.h>
>>> +
>>> +#include "pmc.h"
>>> +
>>> +#define to_clk_main(hw) container_of(hw, struct clk_main, hw)
>>> +struct clk_main {
>>> +    struct clk_hw hw;
>>> +    struct at91_pmc *pmc;
>>> +    unsigned long rate;
>>> +    unsigned int irq;
>>> +    wait_queue_head_t wait;
>>> +};
>>> +
>>> +static irqreturn_t clk_main_irq_handler(int irq, void *dev_id)
>>> +{
>>> +    struct clk_main *clkmain = (struct clk_main *)dev_id;
>>> +
>>> +    wake_up(&clkmain->wait);
>>> +    disable_irq_nosync(clkmain->irq);
>>> +
>>> +    return IRQ_HANDLED;
>>> +}
>>> +
>>> +static int clk_main_prepare(struct clk_hw *hw)
>>> +{
>>> +    struct clk_main *clkmain = to_clk_main(hw);
>>> +    struct at91_pmc *pmc = clkmain->pmc;
>>> +
>>> +    while (!(pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCS)) {
>>> +        enable_irq(clkmain->irq);
>>> +        wait_event(clkmain->wait,
>>> +               pmc_read(pmc, AT91_PMC_SR) & AT91_PMC_MOSCS);
>>> +    }
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int clk_main_is_prepared(struct clk_hw *hw)
>>> +{
>>> +    struct clk_main *clkmain = to_clk_main(hw);
>>> +
>>> +    return !!(pmc_read(clkmain->pmc, AT91_PMC_SR) & AT91_PMC_MOSCS);
>>> +}
>>> +
>>> +static unsigned long clk_main_recalc_rate(struct clk_hw *hw,
>>> +                      unsigned long parent_rate)
>>> +{
>>> +    u32 tmp;
>>> +    struct clk_main *clkmain = to_clk_main(hw);
>>> +    struct at91_pmc *pmc = clkmain->pmc;
>>> +
>>> +    if (clkmain->rate)
>>> +        return clkmain->rate;
>>> +
>>> +    while (!((tmp = pmc_read(pmc, AT91_CKGR_MCFR)) & AT91_PMC_MAINRDY))
>>> +        ;
>>
>> I must say that I do not like this while() loop. Please implement a
>> way out and a mean to release CPU when waiting...
>>
>> Maybe taking a timeout example like this one:
>> http://lxr.free-electrons.com/source/drivers/net/ethernet/cadence/macb.c#L391
>>
>>
>> Which is actually what I leart from Wolfram during his interesting
>> session @ ELC-E:
>> http://elinux.org/images/5/54/Elce11_sang.pdf
>>
>
> I'll take a closer look at these references.
> As I understand, this is about sleeping between each test/iteration of
> the while loop.
>
>> It is true though that we should keep this very quick to not alter
>> boot time too much.
>>
>> I also wonder if really checking that main clock is read makes sense.
>> If we are running Linux it probably mean that at least main clock is
>> already well configured by the bootloader.
>
> This is not exactly the status of the main clk (the main clk status is
> reflected by the MOSCXTS bit in the PMC_SR register).
> This field reflects the MAINF value reliability (MAINF value is used in
> case the main XTAL frequency was not provided in the dt definition,
> to calculate the main XTAL frequency).
> Anyway, MAINFRDY will probably be set at the time this code is executed.
>
>>
>> And this lead to a more general remark: couldn't we simply state that
>> this clock is fixed and only available for reading its status?
>>
> This is up to you, but IMHO the code to support this (unlikely) case is
> not so big (even with the sleeping version you suggested).

Fair enough, let's go for this version.

>>> +
>>> +    tmp &= AT91_PMC_MAINF;
>>> +    clkmain->rate = (tmp * parent_rate) / 16;
>>> +
>>> +    return clkmain->rate;
>>> +}
>>> +
>>> +static const struct clk_ops main_ops = {
>>> +    .prepare = clk_main_prepare,
>>> +    .is_prepared = clk_main_is_prepared,
>>> +    .recalc_rate = clk_main_recalc_rate,
>>> +};
>>> +
>>> +static struct clk * __init
>>> +at91_clk_register_main(struct at91_pmc *pmc,
>>> +               unsigned int irq,
>>> +               const char *name,
>>> +               const char *parent_name,
>>> +               unsigned long rate)
>>> +{
>>> +    int ret;
>>> +    struct clk_main *clkmain;
>>> +    struct clk *clk = NULL;
>>> +    struct clk_init_data init;
>>> +
>>> +    if (!pmc || !irq || !name)
>>> +        return ERR_PTR(-EINVAL);
>>> +
>>> +    if (!rate && !parent_name)
>>> +        return ERR_PTR(-EINVAL);
>>> +
>>> +    clkmain = kzalloc(sizeof(*clkmain), GFP_KERNEL);
>>> +    if (!clkmain)
>>> +        return ERR_PTR(-ENOMEM);
>>> +
>>> +    init.name = name;
>>> +    init.ops = &main_ops;
>>> +    init.parent_names = parent_name ? &parent_name : NULL;
>>> +    init.num_parents = parent_name ? 1 : 0;
>>> +    init.flags = parent_name ? 0 : CLK_IS_ROOT;
>>> +
>>> +    clkmain->hw.init = &init;
>>> +    clkmain->rate = rate;
>>> +    clkmain->pmc = pmc;
>>> +    clkmain->irq = irq;
>>> +    init_waitqueue_head(&clkmain->wait);
>>> +    irq_set_status_flags(clkmain->irq, IRQ_NOAUTOEN);
>>> +    ret = request_irq(clkmain->irq, clk_main_irq_handler,
>>> +              IRQF_TRIGGER_HIGH, "clk-main", clkmain);
>>> +    if (ret)
>>> +        return ERR_PTR(ret);
>>> +
>>> +    clk = clk_register(NULL, &clkmain->hw);
>>> +
>>> +    if (IS_ERR(clk)) {
>>> +        free_irq(clkmain->irq, clkmain);
>>> +        kfree(clkmain);
>>> +    }
>>> +
>>> +    return clk;
>>> +}
>>> +
>>> +
>>> +
>>> +static void __init
>>> +of_at91_clk_main_setup(struct device_node *np, struct at91_pmc *pmc)
>>> +{
>>> +    struct clk *clk;
>>> +    unsigned int irq;
>>> +    const char *parent_name;
>>> +    const char *name = np->name;
>>> +    u32 rate = 0;
>>> +
>>> +    parent_name = of_clk_get_parent_name(np, 0);
>>> +    of_property_read_string(np, "clock-output-names", &name);
>>> +    of_property_read_u32(np, "clock-frequency", &rate);
>>> +    irq = irq_of_parse_and_map(np, 0);
>>> +    if (!irq)
>>> +        return;
>>> +
>>> +    clk = at91_clk_register_main(pmc, irq, name, parent_name, rate);
>>> +
>>> +    if (!IS_ERR(clk))
>>> +        return;
>>> +
>>> +    of_clk_add_provider(np, of_clk_src_simple_get, clk);
>>
>> I do not understand this part: we add the provider if we have not
>> registered the clock correctly?
> This is a bug. :)
>
> I haven't noticed it, because we do not directly request this clk using
> of_clk_get or clk_get function.
> Instead this clk is used as a parent for several clks (plls, master,
> ...) and in this case the common clk framework only
> use parent clk names, not of clk provider to retrieve the appropriate clk.
>
> Anyway, thanks for catching this bug, I'll fix it.
>
>>
>>
>>> +}
>>> +
>>> +void __init of_at91rm9200_clk_main_setup(struct device_node *np,
>>> +                     struct at91_pmc *pmc)
>>> +{
>>> +    of_at91_clk_main_setup(np, pmc);
>>> +}
>>> diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
>>> index f6bd03d..42f0c19 100644
>>> --- a/drivers/clk/at91/pmc.c
>>> +++ b/drivers/clk/at91/pmc.c
>>> @@ -216,6 +216,11 @@ out_free_pmc:
>>>    }
>>>
>>>    static const struct of_device_id pmc_clk_ids[] __initdata = {
>>> +    /* Main clock */
>>> +    {
>>> +        .compatible = "atmel,at91rm9200-clk-main",
>>> +        .data = of_at91rm9200_clk_main_setup
>>> +    },
>>>        { /*sentinel*/ }
>>>    };
>>>
>>> diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
>>> index b7e8397..294e230 100644
>>> --- a/drivers/clk/at91/pmc.h
>>> +++ b/drivers/clk/at91/pmc.h
>>> @@ -55,4 +55,7 @@ static inline void pmc_write(struct at91_pmc *pmc,
>>> int offset, u32 value)
>>>        return writel_relaxed(value, pmc->regbase + offset);
>>>    }
>>>
>>> +extern void __init of_at91rm9200_clk_main_setup(struct device_node *np,
>>> +                        struct at91_pmc *pmc);
>>> +
>>>    #endif /* __PMC_H_ */
>>>
>>
>>
>
>


-- 
Nicolas Ferre
