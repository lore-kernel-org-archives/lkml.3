Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbaD1TdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:33:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52174 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932486AbaD1Tc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:32:57 -0400
Message-ID: <535E9BBE.8000609@free-electrons.com>
Date: Mon, 28 Apr 2014 20:19:42 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Chen-Yu Tsai <wens@csie.org>
CC: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin <kevin@allwinnertech.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dev <dev@linux-sunxi.org>
Subject: Re: [PATCH 5/7] clk: sunxi: add PRCM (Power/Reset/Clock Management)
 clks support
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com> <1398697130-8338-6-git-send-email-boris.brezillon@free-electrons.com> <CAGb2v65aTQozFRVWU5QekK623i4-mLReaAiWC=4pFqWWPcC_Pw@mail.gmail.com> <535E8C8A.6000702@free-electrons.com> <CAGb2v66iLhq58pwYGn-VV01vVXgynYrR0ivatWux1NM+z3Q+9Q@mail.gmail.com>
In-Reply-To: <CAGb2v66iLhq58pwYGn-VV01vVXgynYrR0ivatWux1NM+z3Q+9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28/04/2014 20:03, Chen-Yu Tsai wrote:
> On Tue, Apr 29, 2014 at 1:14 AM, Boris BREZILLON
> <boris.brezillon@free-electrons.com> wrote:
>> Hi Chen-Yu,
>>
>> On 28/04/2014 17:59, Chen-Yu Tsai wrote:
>>> Hi,
>>>
>>> On Mon, Apr 28, 2014 at 10:58 PM, Boris BREZILLON
>>> <boris.brezillon@free-electrons.com> wrote:
>>>> The PRCM (Power/Reset/Clock Management) unit provides several clock
>>>> devices:
>>>> - AR100 clk: used to clock the Power Management co-processor
>>>> - AHB0 clk: used to clock the AHB0 bus
>>>> - APB0 clk and gates: used to clk
>>>>
>>>> Add support for these clks in a separate driver so that they can be probed
>>>> as platform devices instead of registered during early init.
>>>> We need this to be able to probe PRCM MFD subdevices.
>>>>
>>>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>>>> ---
>>>>  drivers/clk/sunxi/Makefile         |   2 +
>>>>  drivers/clk/sunxi/clk-sun6i-prcm.c | 253 +++++++++++++++++++++++++++++++++++++
>>>>  2 files changed, 255 insertions(+)
>>>>  create mode 100644 drivers/clk/sunxi/clk-sun6i-prcm.c
>>>>
>>>> diff --git a/drivers/clk/sunxi/Makefile b/drivers/clk/sunxi/Makefile
>>>> index b5bac91..ef8cdc9 100644
>>>> --- a/drivers/clk/sunxi/Makefile
>>>> +++ b/drivers/clk/sunxi/Makefile
>>>> @@ -3,3 +3,5 @@
>>>>  #
>>>>
>>>>  obj-y += clk-sunxi.o clk-factors.o
>>>> +
>>>> +obj-$(CONFIG_MFD_SUN6I_PRCM) += clk-sun6i-prcm.o
>>>> diff --git a/drivers/clk/sunxi/clk-sun6i-prcm.c b/drivers/clk/sunxi/clk-sun6i-prcm.c
>>>> new file mode 100644
>>>> index 0000000..bb7b25a
>>>> --- /dev/null
>>>> +++ b/drivers/clk/sunxi/clk-sun6i-prcm.c
>>>> @@ -0,0 +1,253 @@
>>>> +/*
>>>> + * Copyright (C) 2014 Free Electrons
>>>> + *
>>>> + * License Terms: GNU General Public License v2
>>>> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
>>>> + *
>>>> + * Allwinner PRCM (Power/Reset/Clock Management) driver
>>>> + *
>>>> + */
>>>> +
>>>> +#include <linux/clk-provider.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/of.h>
>>>> +#include <linux/platform_device.h>
>>>> +
>>>> +#define SUN6I_APB0_GATES_MAX_SIZE      32
>>>> +#define SUN6I_AR100_MAX_PARENTS                4
>>>> +
>>>> +static int sun6i_a31_ar100_mux_clk_register(struct platform_device *pdev)
>>>> +{
>>>> +       const char *parents[SUN6I_AR100_MAX_PARENTS];
>>>> +       struct device_node *np = pdev->dev.of_node;
>>>> +       const char *clk_name = np->name;
>>>> +       struct resource *r;
>>>> +       void __iomem *reg;
>>>> +       struct clk *clk;
>>>> +       int nparents;
>>>> +       int i;
>>>> +
>>>> +       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +       reg = devm_ioremap(&pdev->dev, r->start, resource_size(r));
>>>> +       if (IS_ERR(reg))
>>>> +               return PTR_ERR(reg);
>>>> +
>>>> +       nparents = of_clk_get_parent_count(np);
>>>> +       if (nparents > SUN6I_AR100_MAX_PARENTS)
>>>> +               nparents = SUN6I_AR100_MAX_PARENTS;
>>>> +
>>>> +       for (i = 0; i < nparents; i++)
>>>> +               parents[i] = of_clk_get_parent_name(np, i);
>>>> +
>>>> +       of_property_read_string(np, "clock-output-names", &clk_name);
>>>> +
>>>> +       clk = clk_register_mux(&pdev->dev, clk_name, parents, nparents,
>>>> +                              CLK_SET_RATE_NO_REPARENT, reg,
>>>> +                              16, 2, 0, NULL);
>>>> +       if (IS_ERR(clk))
>>>> +               return PTR_ERR(clk);
>>>> +
>>>> +       return of_clk_add_provider(np, of_clk_src_simple_get, clk);
>>>> +}
>>>> +
>>>> +static int sun6i_a31_ar100_clk_register(struct platform_device *pdev)
>>>> +{
>>>> +       struct device_node *np = pdev->dev.of_node;
>>>> +       const char *clk_name = np->name;
>>>> +       const char *clk_parent;
>>>> +       struct resource *r;
>>>> +       void __iomem *reg;
>>>> +       struct clk *clk;
>>>> +
>>>> +       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +       reg = devm_ioremap(&pdev->dev, r->start, resource_size(r));
>>>> +       if (IS_ERR(reg))
>>>> +               return PTR_ERR(reg);
>>>> +
>>>> +       clk_parent = of_clk_get_parent_name(np, 0);
>>>> +       if (!clk_parent)
>>>> +               return -EINVAL;
>>>> +
>>>> +       of_property_read_string(np, "clock-output-names", &clk_name);
>>>> +
>>>> +       clk = clk_register_divider(&pdev->dev, clk_name, clk_parent,
>>>> +                                  0, reg, 4, 2, CLK_DIVIDER_POWER_OF_TWO,
>>>> +                                  NULL);
>>>> +       if (IS_ERR(clk))
>>>> +               return PTR_ERR(clk);
>>>> +
>>>> +       return of_clk_add_provider(np, of_clk_src_simple_get, clk);
>>>> +}
>>>> +
>>>> +static int sun6i_a31_ar100_div_clk_register(struct platform_device *pdev)
>>>> +{
>>>> +       struct device_node *np = pdev->dev.of_node;
>>>> +       const char *clk_name = np->name;
>>>> +       const char *clk_parent;
>>>> +       struct resource *r;
>>>> +       void __iomem *reg;
>>>> +       struct clk *clk;
>>>> +
>>>> +       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +       reg = devm_ioremap(&pdev->dev, r->start, resource_size(r));
>>>> +       if (IS_ERR(reg))
>>>> +               return PTR_ERR(reg);
>>>> +
>>>> +       clk_parent = of_clk_get_parent_name(np, 0);
>>>> +       if (!clk_parent)
>>>> +               return -EINVAL;
>>>> +
>>>> +       of_property_read_string(np, "clock-output-names", &clk_name);
>>>> +
>>>> +       clk = clk_register_divider(&pdev->dev, clk_name, clk_parent,
>>>> +                                  0, reg, 8, 5, 0, NULL);
>>>> +       if (IS_ERR(clk))
>>>> +               return PTR_ERR(clk);
>>>> +
>>>> +       return of_clk_add_provider(np, of_clk_src_simple_get, clk);
>>>> +}
>>> Would it be possible to merge the 3 ar100 clocks into 1 composite clock?
>>> They do share the same register, and are related to each other.
>> Okay, I'll take a look at composite clocks.
>>
>>> It might be possible to re-use some code from the sunxi clock driver
>>> for this, though I'm not sure if that's a good idea, sharing code
>>> between modules. Emilio?
>> Actually, this is what I tried in the first place, but then I realized
>> it would require exporting some functions declared as static in clk-sunxi.c.
>> Moreover, these functions do not make use of devm functions (because all
>> the clks declared in clk-sunxi.c are initiliazed during early), and I'd
>> like to uses devm function when clks are declared as platform devices.
> Yeah, that's why I was uncertain about it.
>
>> Anyway, I'll wait for Emilio's review ;-).
>>
>>>> +
>>>> +static int sun6i_a31_apb0_clk_register(struct platform_device *pdev)
>>>> +{
>>>> +       struct device_node *np = pdev->dev.of_node;
>>>> +       const char *clk_name = np->name;
>>>> +       const char *clk_parent;
>>>> +       struct resource *r;
>>>> +       void __iomem *reg;
>>>> +       struct clk *clk;
>>>> +
>>>> +       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +       reg = devm_ioremap_resource(&pdev->dev, r);
>>>> +       if (IS_ERR(reg))
>>>> +               return PTR_ERR(reg);
>>>> +
>>>> +       clk_parent = of_clk_get_parent_name(np, 0);
>>>> +       if (!clk_parent)
>>>> +               return -EINVAL;
>>>> +
>>>> +       of_property_read_string(np, "clock-output-names", &clk_name);
>>>> +
>>>> +       clk = clk_register_divider(&pdev->dev, clk_name, clk_parent,
>>>> +                                  0, reg, 0, 2, CLK_DIVIDER_POWER_OF_TWO,
>>>> +                                  NULL);
>>> I just looked at the sun6i kernel code again.
>>>
>>>   http://git.rhombus-tech.net/?p=linux.git;a=blob;f=arch/arm/mach-sun6i/clock/ccm_i.h;hb=refs/heads/allwinner-sunxi-a31#l376
>>>
>>> and
>>>
>>>   http://git.rhombus-tech.net/?p=linux.git;a=blob;f=arch/arm/mach-sun6i/clock/sys_clk.c;hb=refs/heads/allwinner-sunxi-a31#l882
>>>
>>> The divider on the A31 is /2, /2, /4, /8. You might need a table for that.
>> I saw that in the datasheet, but I just thought it was a mistake (that's
>> weird to have 2 times the same divisor).
> Oh, you have the datasheet?

No, I said datasheet, but I meant the code you point out last time
(otherwise I would have no problem to do the clk tree implementation) :-(

>
> We also have muxes with 2 PLL6's. And Allwinner's u-boot p2wi driver also
> assumes 12 MHz, instead of 24 MHz, as the source clock rate. Either they
> messed up twice, or they had some reason to do it like this. The p2wi
> driver in u-boot-sunxi also assumes 12 MHz, and I assume it works for
> everyone with A31 hardware.

Okay, I'll take a look at the output signal (on the P2WI clk pin) and
see if it matches your assumptions ;-).

>
>>> This is different from the A23 manual I used to document most of the PRCM.
>>> I apologize for not catching this earlier. I have updated the wiki.
>> No problem.
>>
>>>> +       if (IS_ERR(clk))
>>>> +               return PTR_ERR(clk);
>>>> +
>>>> +       return of_clk_add_provider(np, of_clk_src_simple_get, clk);
>>>> +}
>>>> +
>>>> +static int sun6i_a31_apb0_gates_clk_register(struct platform_device *pdev)
>>>> +{
>>>> +       struct device_node *np = pdev->dev.of_node;
>>>> +       struct clk_onecell_data *clk_data;
>>>> +       const char *clk_parent;
>>>> +       const char *clk_name;
>>>> +       struct resource *r;
>>>> +       void __iomem *reg;
>>>> +       int gate_id;
>>>> +       int ngates;
>>>> +       int i;
>>>> +
>>>> +       r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +       reg = devm_ioremap_resource(&pdev->dev, r);
>>>> +       if (!reg)
>>>> +               return PTR_ERR(reg);
>>>> +
>>>> +       clk_parent = of_clk_get_parent_name(np, 0);
>>>> +       if (!clk_parent)
>>>> +               return -EINVAL;
>>>> +
>>>> +       ngates = of_property_count_strings(np, "clock-output-names");
>>>> +       if (ngates < 0)
>>>> +               return ngates;
>>>> +
>>>> +       if (!ngates || ngates > SUN6I_APB0_GATES_MAX_SIZE)
>>>> +               return -EINVAL;
>>>> +
>>>> +       clk_data = devm_kzalloc(&pdev->dev, sizeof(struct clk_onecell_data),
>>>> +                               GFP_KERNEL);
>>>> +       if (!clk_data)
>>>> +               return -ENOMEM;
>>>> +
>>>> +       clk_data->clks = devm_kzalloc(&pdev->dev,
>>>> +                                     SUN6I_APB0_GATES_MAX_SIZE *
>>>> +                                     sizeof(struct clk *),
>>>> +                                     GFP_KERNEL);
>>>> +       if (!clk_data->clks)
>>>> +               return -ENOMEM;
>>>> +
>>>> +       for (i = 0; i < ngates; i++) {
>>>> +               of_property_read_string_index(np, "clock-output-names",
>>>> +                                             i, &clk_name);
>>>> +
>>>> +               gate_id = i;
>>>> +               of_property_read_u32_index(np, "clock-indices", i, &gate_id);
>>>> +
>>>> +               WARN_ON(gate_id >= SUN6I_APB0_GATES_MAX_SIZE);
>>>> +               if (gate_id >= SUN6I_APB0_GATES_MAX_SIZE)
>>>> +                       continue;
>>>> +
>>>> +               clk_data->clks[gate_id] = clk_register_gate(&pdev->dev,
>>>> +                                                           clk_name,
>>>> +                                                           clk_parent, 0,
>>>> +                                                           reg, gate_id,
>>>> +                                                           0, NULL);
>>>> +               WARN_ON(IS_ERR(clk_data->clks[gate_id]));
>>>> +       }
>>>> +
>>>> +       clk_data->clk_num = ngates;
>>>> +
>>>> +       return of_clk_add_provider(np, of_clk_src_onecell_get, clk_data);
>>>> +}
>>>> +
>>>> +const struct of_device_id sun6i_a31_prcm_clk_dt_ids[] = {
>>>> +       {
>>>> +               .compatible = "allwinner,sun6i-a31-ar100-mux-clk",
>>>> +               .data = sun6i_a31_ar100_mux_clk_register,
>>>> +       },
>>>> +       {
>>>> +               .compatible = "allwinner,sun6i-a31-ar100-clk",
>>>> +               .data = sun6i_a31_ar100_clk_register,
>>>> +       },
>>>> +       {
>>>> +               .compatible = "allwinner,sun6i-a31-ar100-div-clk",
>>>> +               .data = sun6i_a31_ar100_div_clk_register,
>>>> +       },
>>>> +       {
>>>> +               .compatible = "allwinner,sun6i-a31-apb0-clk",
>>>> +               .data = sun6i_a31_apb0_clk_register,
>>>> +       },
>>>> +       {
>>>> +               .compatible = "allwinner,sun6i-a31-apb0-gates-clk",
>>>> +               .data = sun6i_a31_apb0_gates_clk_register,
>>>> +       },
>>>> +       { /* sentinel */ }
>>>> +};
>>>> +
>>>> +static int sun6i_a31_prcm_clk_probe(struct platform_device *pdev)
>>>> +{
>>>> +       struct device_node *np = pdev->dev.of_node;
>>>> +       int (*register_func)(struct platform_device *pdev);
>>>> +       const struct of_device_id *match;
>>>> +
>>>> +       match = of_match_node(sun6i_a31_prcm_clk_dt_ids, np);
>>>> +       if (!match)
>>>> +               return -EINVAL;
>>>> +
>>>> +       register_func = match->data;
>>>> +       return register_func(pdev);
>>>> +}
>>>> +
>>>> +static struct platform_driver sun6i_a31_prcm_clk_driver = {
>>>> +       .driver = {
>>>> +               .name = "sun6i-a31-prcm-clk",
>>>> +               .owner = THIS_MODULE,
>>>> +               .of_match_table = sun6i_a31_prcm_clk_dt_ids,
>>>> +       },
>>>> +       .probe = sun6i_a31_prcm_clk_probe,
>>>> +};
>>>> +module_platform_driver(sun6i_a31_prcm_clk_driver);
>>>> +
>>>> +MODULE_AUTHOR("Boris BREZILLON <boris.brezillon@free-electrons.com");
>>>> +MODULE_DESCRIPTION("Allwinner Reset Controller Driver");
>>>> +MODULE_LICENSE("GPL v2");
>>> The rest looks good to me, but Emilio should be able to give you more feedback.
>>>
>>> Thanks for all the sun6i support you've done!
>> Thanks for your review.
>>
>> Best Regards,
>>
>> Boris
>>> Cheers
>>> ChenYu
>> --
>> Boris Brezillon, Free Electrons
>> Embedded Linux and Kernel engineering
>> http://free-electrons.com
>>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

