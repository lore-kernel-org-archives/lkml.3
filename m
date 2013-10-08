Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3JHPi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:38:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40987 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755574Ab3JHPi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:38:57 -0400
Date: Tue, 8 Oct 2013 16:38:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2] clk/zynq/clkc: Add 'fclk-enable' feature
Message-ID: <20131008153816.GB4981@e106331-lin.cambridge.arm.com>
References: <1381242972-14752-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381242972-14752-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 03:36:11PM +0100, Soren Brinkmann wrote:
> In some use cases Zynq's FPGA clocks are used as static clock
> generators for IP in the FPGA part of the SOC for which no Linux driver
> exists and would control those clocks. To avoid automatic
> gating of these clocks in such cases a new property - fclk-enable - is
> added to the clock controller's DT description to accomodate such use
> cases. It's value is a bitmask, where a set bit results in enabling
> the corresponding FCLK through the clkc.
> 
> FPGA clocks are handled following the rules below:
> 
> If an FCLK is not enabled by bootloaders, that FCLK will be disabled in
> Linux. Drivers can enable and control it through the CCF as usual.
> 
> If an FCLK is enabled by bootloaders AND the corresponding bit in the
> 'fclk-enable' DT property is set, that FCLK will be enabled by the clkc,
> resulting in an off by one reference count for that clock. Ensuring it
> will always be running.
> 
> The default value for 'fclk-enable' is '0xf' (all FCLK's enabled by the
> bootloader are enabled through the clkc.

Why? Juding by the diff that's not what the code currently does, so why
not leave it as 0, and only set it where required as a work-around?

Thans,
Mark.

> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  .../devicetree/bindings/clock/zynq-7000.txt          |  4 ++++
>  drivers/clk/zynq/clkc.c                              | 20 +++++++++++++++++---
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/zynq-7000.txt b/Documentation/devicetree/bindings/clock/zynq-7000.txt
> index d99af878f5d7..11fdd146ec83 100644
> --- a/Documentation/devicetree/bindings/clock/zynq-7000.txt
> +++ b/Documentation/devicetree/bindings/clock/zynq-7000.txt
> @@ -22,6 +22,10 @@ Required properties:
>  Optional properties:
>   - clocks : as described in the clock bindings
>   - clock-names : as described in the clock bindings
> + - fclk-enable : Bit mask to enable FCLKs in cases no proper CCF compatible
> +		 driver is available. Bit [0..3] correspond to FCLK0..FCLK3. The
> +		 corresponding FCLK will only be enabled if it is actually
> +		 running at boot time. (default = 0xf)
>  
>  Clock inputs:
>  The following strings are optional parameters to the 'clock-names' property in
> diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
> index 10772aa72e4e..a36fc0f47634 100644
> --- a/drivers/clk/zynq/clkc.c
> +++ b/drivers/clk/zynq/clkc.c
> @@ -102,9 +102,10 @@ static const char *swdt_ext_clk_input_names[] __initdata = {"swdt_ext_clk"};
>  
>  static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
>  		const char *clk_name, void __iomem *fclk_ctrl_reg,
> -		const char **parents)
> +		const char **parents, int enable)
>  {
>  	struct clk *clk;
> +	u32 enable_reg;
>  	char *mux_name;
>  	char *div0_name;
>  	char *div1_name;
> @@ -147,6 +148,12 @@ static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
>  	clks[fclk] = clk_register_gate(NULL, clk_name,
>  			div1_name, CLK_SET_RATE_PARENT, fclk_gate_reg,
>  			0, CLK_GATE_SET_TO_DISABLE, fclk_gate_lock);
> +	enable_reg = readl(fclk_gate_reg) & 1;
> +	if (enable & !enable_reg) {
> +		if (clk_prepare_enable(clks[fclk]))
> +			pr_warn("%s: FCLK%u enable failed\n", __func__,
> +					fclk - fclk0);
> +	}
>  	kfree(mux_name);
>  	kfree(div0_name);
>  	kfree(div1_name);
> @@ -213,6 +220,7 @@ static void __init zynq_clk_setup(struct device_node *np)
>  	int ret;
>  	struct clk *clk;
>  	char *clk_name;
> +	unsigned int fclk_enable;
>  	const char *clk_output_name[clk_max];
>  	const char *cpu_parents[4];
>  	const char *periph_parents[4];
> @@ -247,6 +255,10 @@ static void __init zynq_clk_setup(struct device_node *np)
>  	ps_clk = clk_register_fixed_rate(NULL, "ps_clk", NULL, CLK_IS_ROOT,
>  			tmp);
>  
> +	ret = of_property_read_u32(np, "fclk-enable", &fclk_enable);
> +	if (ret)
> +		fclk_enable = 0xf;
> +
>  	/* PLLs */
>  	clk = clk_register_zynq_pll("armpll_int", "ps_clk", SLCR_ARMPLL_CTRL,
>  			SLCR_PLL_STATUS, 0, &armpll_lock);
> @@ -340,10 +352,12 @@ static void __init zynq_clk_setup(struct device_node *np)
>  	clk_prepare_enable(clks[dci]);
>  
>  	/* Peripheral clocks */
> -	for (i = fclk0; i <= fclk3; i++)
> +	for (i = fclk0; i <= fclk3; i++) {
> +		int enable = !!(fclk_enable & BIT(i - fclk0));
>  		zynq_clk_register_fclk(i, clk_output_name[i],
>  				SLCR_FPGA0_CLK_CTRL + 0x10 * (i - fclk0),
> -				periph_parents);
> +				periph_parents, enable);
> +	}
>  
>  	zynq_clk_register_periph_clk(lqspi, 0, clk_output_name[lqspi], NULL,
>  			SLCR_LQSPI_CLK_CTRL, periph_parents, 0);
> -- 
> 1.8.4
> 
> 
