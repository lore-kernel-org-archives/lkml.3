Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaIRXnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:43:37 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:31420 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224AbaIRXne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:43:34 -0400
X-IronPort-AV: E=Sophos;i="5.04,550,1406617200"; 
   d="scan'208";a="46442680"
Message-ID: <541B6E24.7020800@broadcom.com>
Date: Thu, 18 Sep 2014 16:43:32 -0700
From: Jonathan Richardson <jonathar@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, JD Zheng <jdzheng@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>
Subject: Re: [PATCH 2/6] clk: Clock driver support for Broadcom Cygnus SoC
References: <jonathar@broadcom.com> <1410897497-27527-1-git-send-email-jonathar@broadcom.com> <1410897497-27527-3-git-send-email-jonathar@broadcom.com> <20140917004753.GJ14191@leverpostej>
In-Reply-To: <20140917004753.GJ14191@leverpostej>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-09-16 05:47 PM, Mark Rutland wrote:
> On Tue, Sep 16, 2014 at 08:58:13PM +0100, Jonathan Richardson wrote:
>> The iProc clock driver controls PLL's common across iProc chips. The
> 
> Nit: s/PLL's/PLLs/ (we aren't greengrocers [1]).

Will fix.

> 
>> cygnus driver controls cygnus specific features and variations.
>>
>> Reviewed-by: Ray Jui <rjui@broadcom.com>
>> Tested-by: Jonathan Richardson <jonathar@broadcom.com>
>> Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
>> Signed-off-by: Jonathan Richardson <jonathar@broadcom.com>
>> ---
>>  drivers/clk/Makefile         |    1 +
>>  drivers/clk/bcm/Makefile     |    2 +
>>  drivers/clk/bcm/clk-cygnus.c | 1179 ++++++++++++++++++++++++++++++++++++++++++
>>  drivers/clk/bcm/clk-iproc.c  |  446 ++++++++++++++++
>>  4 files changed, 1628 insertions(+)
>>  create mode 100644 drivers/clk/bcm/clk-cygnus.c
>>  create mode 100644 drivers/clk/bcm/clk-iproc.c
>  
> [...]
> 
>> +/*
>> + * Enable clocks controlled through the top clock gating control.
>> + *
>> + * @param state true = enable clock, false = disable clock
>> + */
>> +static void cygnus_clkgate_enable(void __iomem *clkgate_reg,
>> +       enum cygnus_top_clk_gating_ctrl_offsets offset, bool state)
>> +{
>> +       u32 val = readl(clkgate_reg);
>> +
>> +       /* Enable or disable the clock. */
> 
> This function is misnamed if it does both, and 'state' is not a very
> descriptive name.

Will fix.

> 
>> +       if (state)
>> +               val |= 1 << offset;
>> +       else
>> +               val &= ~(1 << offset);
>> +
>> +       writel(val, clkgate_reg);
>> +}
>> +
>> +/*
>> + * Powers on/off the MIPI GENPLL using CRMU_PLL_AON_CTRL register.
>> + *
>> + * @param state true to power on PLL, false to power off
>> + */
>> +static void cygnus_mipi_genpll_poweron(void __iomem *pll_ctrl_reg,
>> +       bool state)
>> +{
>> +       u32 val;
>> +       u32 pll_ldo_on = ((1 << ASIU_MIPI_GENPLL_PWRON_SHIFT) |
>> +               (1 << ASIU_MIPI_GENPLL_PWRON_PLL_SHIFT) |
>> +               (1 << ASIU_MIPI_GENPLL_PWRON_BG_SHIFT)  |
>> +               (1 << ASIU_MIPI_GENPLL_PWRON_LDO_SHIFT));
>> +
>> +       val = readl(pll_ctrl_reg);
>> +
>> +       /*
>> +        * Set PLL on/off. Set input isolation mode to 1 when disabled, 0 when
>> +        * enabled.
>> +        */
> 
> As with cygnus_clkgate_enable, this function is misnamed and 'state' is
> a confusing parameter name.

Will fix.

> 
>> +       if (state) {
>> +               val |= pll_ldo_on;
>> +               val &= ~(1 << ASIU_MIPI_GENPLL_ISO_IN_SHIFT);
>> +       } else {
>> +               val &= ~pll_ldo_on;
>> +               val |= 1 << ASIU_MIPI_GENPLL_ISO_IN_SHIFT;
>> +       }
>> +
>> +       writel(val, pll_ctrl_reg);
>> +}
>> +
>> +/*
>> + * Powers on/off the audio PLL using CRMU_PLL_AON_CTRL register.
>> + *
>> + * @param state true to power on PLL, false to power off
>> + */
>> +static void cygnus_audio_genpll_poweron(void __iomem *pll_ctrl_reg,
>> +       bool state)
>> +{
>> +       u32 val;
>> +       u32 pll_ldo_on = ((1 << ASIU_AUDIO_GENPLL_PWRON_PLL_SHIFT) |
>> +               (1 << ASIU_AUDIO_GENPLL_PWRON_BG_SHIFT) |
>> +               (1 << ASIU_AUDIO_GENPLL_PWRON_LDO_SHIFT));
>> +
>> +       val = readl(pll_ctrl_reg);
>> +
>> +       /*
>> +        * Set PLL on/off. Set input isolation mode to 1 when disabled, 0 when
>> +        * enabled.
>> +        */
> 
> Misnamed function, confusing parameter name.

Will fix.

> 
>> +       if (state) {
>> +               val |= pll_ldo_on;
>> +               val &= ~(1 << ASIU_AUDIO_GENPLL_ISO_IN);
>> +       } else {
>> +               val &= ~pll_ldo_on;
>> +               val |= 1 << ASIU_AUDIO_GENPLL_ISO_IN;
>> +       }
>> +
>> +       writel(val, pll_ctrl_reg);
>> +}
> 
> [...]
> 
>> +static __init struct clk *cygnus_clock_init(struct device_node *node,
>> +       const struct clk_ops *ops)
>> +{
>> +       u32 channel = 0;
>> +       struct clk *clk;
>> +       struct cygnus_clk *cygnus_clk;
>> +       const char *clk_name = node->name;
>> +       const char *parent_name;
>> +       struct clk_init_data init;
>> +       int rc;
>> +
>> +       pr_debug("Clock name %s\n", node->name);
>> +
>> +       of_property_read_u32(node, "channel", &channel);
>> +       cygnus_clk = kzalloc(sizeof(*cygnus_clk), GFP_KERNEL);
>> +       if (WARN_ON(!cygnus_clk))
>> +               return NULL;
>> +
>> +       cygnus_clk->state = CLK_DISABLED;
>> +
>> +       /* Read base address from device tree and map to virtual address. */
>> +       cygnus_clk->regs_base = of_iomap(node, CYGNUS_CLK_BASE_REG);
>> +       if (WARN_ON(!cygnus_clk->regs_base))
>> +               goto err_alloc;
>> +
>> +       /* Read optional base addresses for PLL control and clock gating. */
>> +       cygnus_clk->clock_gate_ctrl_reg = of_iomap(node,
>> +               CYGNUS_CLK_GATE_CTRL_REG);
>> +       cygnus_clk->pll_ctrl_reg = of_iomap(node, CYGNUS_PLL_CTRL_REG);
>> +
>> +       of_property_read_u32(node, "channel", &channel);
> 
> Why do we read this twice?

Missed that one. Will fix.

> 
>> +       cygnus_clk->chan = channel;
>> +       of_property_read_string(node, "clock-output-names", &clk_name);
> 
> What happens if this is missing from the dt?

It will (and does) fail and uses the name of the DT node instead. Please
see default value at beginning of function:

const char *clk_name = node->name;

> 
>> +
>> +       /*
>> +        * Internal divider is optional and used for PLL derived clocks with
>> +        * hardcoded dividers.
>> +        */
>> +       cygnus_clk->internal_div = CLK_RATE_NO_DIV;
>> +       of_property_read_u32(node, "div", &cygnus_clk->internal_div);
>> +
>> +       init.name = clk_name;
>> +       init.ops = ops;
>> +       init.flags = CLK_GET_RATE_NOCACHE;
>> +       parent_name = of_clk_get_parent_name(node, 0);
>> +       init.parent_names = &parent_name;
>> +       init.num_parents = 1;
>> +
>> +       cygnus_clk->hw.init = &init;
>> +
>> +       clk = clk_register(NULL, &cygnus_clk->hw);
>> +       if (WARN_ON(IS_ERR(clk)))
>> +               goto err_unmap;
>> +
>> +       rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
>> +       if (WARN_ON(IS_ERR_VALUE(rc)))
>> +               goto err_unregister;
>> +
>> +       rc = clk_register_clkdev(clk, clk_name, NULL);
>> +       if (WARN_ON(IS_ERR_VALUE(rc)))
>> +               goto err_provider;
>> +
>> +       return clk;
>> +
>> +err_provider:
>> +       of_clk_del_provider(node);
>> +
>> +err_unregister:
>> +       clk_unregister(clk);
>> +
>> +err_unmap:
>> +       iounmap(cygnus_clk->regs_base);
>> +       iounmap(cygnus_clk->clock_gate_ctrl_reg);
>> +       iounmap(cygnus_clk->pll_ctrl_reg);
>> +
>> +err_alloc:
>> +       kfree(cygnus_clk);
>> +
>> +       return NULL;
>> +}
> 
> Thanks,
> Mark.
> 
> [1] http://en.wikipedia.org/wiki/Apostrophe#Superfluous_apostrophes_.28.22greengrocers.27_apostrophes.22.29
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Thanks for the feedback.

Jon

