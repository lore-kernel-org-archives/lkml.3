Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaBSGMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:12:21 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63219 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaBSGMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:12:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Chen-Yu Tsai <wens@csie.org>,
        "Maxime Ripard" <maxime.ripard@free-electrons.com>,
        "Emilio Lopez" <emilio@elopez.com.ar>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1392028554-32545-2-git-send-email-wens@csie.org>
Cc: "Chen-Yu Tsai" <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1392028554-32545-1-git-send-email-wens@csie.org>
 <1392028554-32545-2-git-send-email-wens@csie.org>
Message-ID: <20140219060643.22529.44045@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v4 1/8] clk: sunxi: Add Allwinner A20/A31 GMAC clock unit
Date: Tue, 18 Feb 2014 22:06:43 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen-Yu Tsai (2014-02-10 02:35:47)
> The Allwinner A20/A31 clock module controls the transmit clock source
> and interface type of the GMAC ethernet controller. Model this as
> a single clock for GMAC drivers to use.
> 
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Looks good to me.

Regards,
Mike

> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt | 30 +++++++
>  drivers/clk/sunxi/clk-sunxi.c                     | 97 +++++++++++++++++++++++
>  2 files changed, 127 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
> index 0cf679b..28421d2 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -37,6 +37,7 @@ Required properties:
>         "allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
>         "allwinner,sun4i-mod0-clk" - for the module 0 family of clocks
>         "allwinner,sun7i-a20-out-clk" - for the external output clocks
> +       "allwinner,sun7i-a20-gmac-clk" - for the GMAC clock module on A20/A31
>  
>  Required properties for all clocks:
>  - reg : shall be the control register address for the clock.
> @@ -50,6 +51,9 @@ Required properties for all clocks:
>         If the clock module only has one output, the name shall be the
>         module name.
>  
> +For "allwinner,sun7i-a20-gmac-clk", the parent clocks shall be fixed rate
> +dummy clocks at 25 MHz and 125 MHz, respectively. See example.
> +
>  Clock consumers should specify the desired clocks they use with a
>  "clocks" phandle cell. Consumers that are using a gated clock should
>  provide an additional ID in their clock property. This ID is the
> @@ -96,3 +100,29 @@ mmc0_clk: clk@01c20088 {
>         clocks = <&osc24M>, <&pll6 1>, <&pll5 1>;
>         clock-output-names = "mmc0";
>  };
> +
> +mii_phy_tx_clk: clk@2 {
> +       #clock-cells = <0>;
> +       compatible = "fixed-clock";
> +       clock-frequency = <25000000>;
> +       clock-output-names = "mii_phy_tx";
> +};
> +
> +gmac_int_tx_clk: clk@3 {
> +       #clock-cells = <0>;
> +       compatible = "fixed-clock";
> +       clock-frequency = <125000000>;
> +       clock-output-names = "gmac_int_tx";
> +};
> +
> +gmac_clk: clk@01c20164 {
> +       #clock-cells = <0>;
> +       compatible = "allwinner,sun7i-a20-gmac-clk";
> +       reg = <0x01c20164 0x4>;
> +       /*
> +        * The first clock must be fixed at 25MHz;
> +        * the second clock must be fixed at 125MHz
> +        */
> +       clocks = <&mii_phy_tx_clk>, <&gmac_int_tx_clk>;
> +       clock-output-names = "gmac";
> +};
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 736fb60..da1d5cc 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -379,6 +379,103 @@ static void sun7i_a20_get_out_factors(u32 *freq, u32 parent_rate,
>  
>  
>  /**
> + * sun7i_a20_gmac_clk_setup - Setup function for A20/A31 GMAC clock module
> + *
> + * This clock looks something like this
> + *                               ________________________
> + *  MII TX clock from PHY >-----|___________    _________|----> to GMAC core
> + *  GMAC Int. RGMII TX clk >----|___________\__/__gate---|----> to PHY
> + *  Ext. 125MHz RGMII TX clk >--|__divider__/            |
> + *                              |________________________|
> + *
> + * The external 125 MHz reference is optional, i.e. GMAC can use its
> + * internal TX clock just fine. The A31 GMAC clock module does not have
> + * the divider controls for the external reference.
> + *
> + * To keep it simple, let the GMAC use either the MII TX clock for MII mode,
> + * and its internal TX clock for GMII and RGMII modes. The GMAC driver should
> + * select the appropriate source and gate/ungate the output to the PHY.
> + *
> + * Only the GMAC should use this clock. Altering the clock so that it doesn't
> + * match the GMAC's operation parameters will result in the GMAC not being
> + * able to send traffic out. The GMAC driver should set the clock rate and
> + * enable/disable this clock to configure the required state. The clock
> + * driver then responds by auto-reparenting the clock.
> + */
> +
> +#define SUN7I_A20_GMAC_GPIT    2
> +#define SUN7I_A20_GMAC_MASK    0x3
> +#define SUN7I_A20_GMAC_PARENTS 2
> +
> +static void __init sun7i_a20_gmac_clk_setup(struct device_node *node)
> +{
> +       struct clk *clk;
> +       struct clk_mux *mux;
> +       struct clk_gate *gate;
> +       const char *clk_name = node->name;
> +       const char *parents[SUN7I_A20_GMAC_PARENTS];
> +       void *reg;
> +       int i = 0;
> +
> +       if (of_property_read_string(node, "clock-output-names", &clk_name))
> +               return;
> +
> +       /* allocate mux and gate clock structs */
> +       mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
> +       if (!mux)
> +               return;
> +
> +       gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
> +       if (!gate)
> +               goto free_mux;
> +
> +       /* gmac clock requires exactly 2 parents */
> +       parents[0] = of_clk_get_parent_name(node, 0);
> +       parents[1] = of_clk_get_parent_name(node, 1);
> +       if (!parents[0] || !parents[1])
> +               goto free_gate;
> +
> +       reg = of_iomap(node, 0);
> +       if (!reg)
> +               goto free_gate;
> +
> +       /* set up gate and fixed rate properties */
> +       gate->reg = reg;
> +       gate->bit_idx = SUN7I_A20_GMAC_GPIT;
> +       gate->lock = &clk_lock;
> +       mux->reg = reg;
> +       mux->mask = SUN7I_A20_GMAC_MASK;
> +       mux->flags = CLK_MUX_INDEX_BIT;
> +       mux->lock = &clk_lock;
> +
> +       clk = clk_register_composite(NULL, clk_name,
> +                       parents, SUN7I_A20_GMAC_PARENTS,
> +                       &mux->hw, &clk_mux_ops,
> +                       NULL, NULL,
> +                       &gate->hw, &clk_gate_ops,
> +                       0);
> +
> +       if (IS_ERR(clk))
> +               goto iounmap_reg;
> +
> +       of_clk_add_provider(node, of_clk_src_simple_get, clk);
> +       clk_register_clkdev(clk, clk_name, NULL);
> +
> +       return;
> +
> +iounmap_reg:
> +       iounmap(reg);
> +free_gate:
> +       kfree(gate);
> +free_mux:
> +       kfree(mux);
> +}
> +CLK_OF_DECLARE(sun7i_a20_gmac, "allwinner,sun7i-a20-gmac-clk",
> +               sun7i_a20_gmac_clk_setup);
> +
> +
> +
> +/**
>   * sunxi_factors_clk_setup() - Setup function for factor clocks
>   */
>  
> -- 
> 1.9.rc1
> 
