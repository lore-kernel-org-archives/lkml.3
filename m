Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaI1CDE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 22:03:04 -0400
Received: from mail-bn1on0132.outbound.protection.outlook.com ([157.56.110.132]:6272
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752180AbaI1CDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 22:03:02 -0400
Date: Sun, 28 Sep 2014 10:02:18 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <linus.walleij@linaro.org>, <gnurou@gmail.com>,
        <linux@arm.linux.org.uk>, <jingchang.lu@freescale.com>,
        <b20788@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 8/9] ARM: imx: clk-gate2: allow custom gate configuration
Message-ID: <20140928020214.GB11238@dragon>
References: <cover.1411404079.git.stefan@agner.ch>
 <2ad051b257bae6249a48443a30d14b152407504e.1411404079.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2ad051b257bae6249a48443a30d14b152407504e.1411404079.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [121.227.51.193]
X-ClientProxiedBy: SIXPR01CA004.apcprd01.prod.exchangelabs.com (10.242.58.14)
 To DM2PR03MB349.namprd03.prod.outlook.com (10.141.54.11)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB349;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(24454002)(189002)(85306004)(50466002)(105586002)(110136001)(19580395003)(46102003)(83322001)(97736003)(19580405001)(81342003)(74662003)(95666004)(74502003)(97756001)(90102001)(77982003)(46406003)(80022003)(81542003)(77096002)(79102003)(83072002)(33716001)(85852003)(107046002)(4396001)(66066001)(92566001)(101416001)(20776003)(47776003)(106356001)(92726001)(64706001)(86362001)(21056001)(31966008)(102836001)(33656002)(83506001)(54356999)(76176999)(42186005)(99396003)(23726002)(87976001)(76482002)(10300001)(120916001)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB349;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 07:09:29PM +0200, Stefan Agner wrote:
> The 2-bit gates found i.MX and Vybrid SoC support different clock
> configuration:
> 
> 0b00: clk disabled
> 0b01: clk enabled in RUN mode but disabled in WAIT and STOP mode
> 0b10: clk enabled in RUN, WAIT and STOP mode (only Vybrid)
> 0b11: clk enabled in RUN and WAIT mode
> 
> For some clocks, we might want to configure different behaviour,
> e.g. a memory clock should be on even in STOP mode. Add a new
> function imx_clk_gate2_cgr which allow to configure specific
> gate values through the cgr_val parameter.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/mach-imx/clk-gate2.c           |  7 +++++--
>  arch/arm/mach-imx/clk-vf610.c           |  3 +++
>  arch/arm/mach-imx/clk.h                 | 13 ++++++++++---
>  include/dt-bindings/clock/vf610-clock.h |  3 ++-

The patch should be split into two, one for clk-gate2 and the other for
clk-vf610 driver change.  Other than that, the patch looks good to me.

Shawn

>  4 files changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
> index 84acdfd..8c22a84 100644
> --- a/arch/arm/mach-imx/clk-gate2.c
> +++ b/arch/arm/mach-imx/clk-gate2.c
> @@ -31,6 +31,7 @@ struct clk_gate2 {
>  	struct clk_hw hw;
>  	void __iomem	*reg;
>  	u8		bit_idx;
> +	u8		cgr_val;
>  	u8		flags;
>  	spinlock_t	*lock;
>  	unsigned int	*share_count;
> @@ -50,7 +51,8 @@ static int clk_gate2_enable(struct clk_hw *hw)
>  		goto out;
>  
>  	reg = readl(gate->reg);
> -	reg |= 3 << gate->bit_idx;
> +	reg &= ~(3 << gate->bit_idx);
> +	reg |= gate->cgr_val << gate->bit_idx;
>  	writel(reg, gate->reg);
>  
>  out:
> @@ -110,7 +112,7 @@ static struct clk_ops clk_gate2_ops = {
>  
>  struct clk *clk_register_gate2(struct device *dev, const char *name,
>  		const char *parent_name, unsigned long flags,
> -		void __iomem *reg, u8 bit_idx,
> +		void __iomem *reg, u8 bit_idx, u8 cgr_val,
>  		u8 clk_gate2_flags, spinlock_t *lock,
>  		unsigned int *share_count)
>  {
> @@ -125,6 +127,7 @@ struct clk *clk_register_gate2(struct device *dev, const char *name,
>  	/* struct clk_gate2 assignments */
>  	gate->reg = reg;
>  	gate->bit_idx = bit_idx;
> +	gate->cgr_val = cgr_val;
>  	gate->flags = clk_gate2_flags;
>  	gate->lock = lock;
>  
> diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
> index a178184..1034e78 100644
> --- a/arch/arm/mach-imx/clk-vf610.c
> +++ b/arch/arm/mach-imx/clk-vf610.c
> @@ -103,6 +103,7 @@ static struct clk_onecell_data clk_data;
>  static unsigned int const clks_init_on[] __initconst = {
>  	VF610_CLK_SYS_BUS,
>  	VF610_CLK_DDR_SEL,
> +	VF610_CLK_DDRMC,
>  };
>  
>  static void __init vf610_clocks_init(struct device_node *ccm_node)
> @@ -171,6 +172,8 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
>  	clk[VF610_CLK_PLL4_MAIN_DIV] = clk_register_divider_table(NULL, "pll4_main_div", "pll4_main", 0, CCM_CACRR, 6, 3, 0, pll4_main_div_table, &imx_ccm_lock);
>  	clk[VF610_CLK_PLL6_MAIN_DIV] = imx_clk_divider("pll6_main_div", "pll6_main", CCM_CACRR, 21, 1);
>  
> +	clk[VF610_CLK_DDRMC] = imx_clk_gate2_cgr("ddrmc", "ddr_sel", CCM_CCGR6, CCM_CCGRx_CGn(14), 0x2);
> +
>  	clk[VF610_CLK_USBPHY0] = imx_clk_gate("usbphy0", "pll3_main", PLL3_CTRL, 6);
>  	clk[VF610_CLK_USBPHY1] = imx_clk_gate("usbphy1", "pll7_main", PLL7_CTRL, 6);
>  
> diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
> index 4cdf8b6..d22e339 100644
> --- a/arch/arm/mach-imx/clk.h
> +++ b/arch/arm/mach-imx/clk.h
> @@ -29,7 +29,7 @@ struct clk *imx_clk_pllv3(enum imx_pllv3_type type, const char *name,
>  
>  struct clk *clk_register_gate2(struct device *dev, const char *name,
>  		const char *parent_name, unsigned long flags,
> -		void __iomem *reg, u8 bit_idx,
> +		void __iomem *reg, u8 bit_idx, u8 cgr_val,
>  		u8 clk_gate_flags, spinlock_t *lock,
>  		unsigned int *share_count);
>  
> @@ -43,7 +43,7 @@ static inline struct clk *imx_clk_gate2(const char *name, const char *parent,
>  		void __iomem *reg, u8 shift)
>  {
>  	return clk_register_gate2(NULL, name, parent, CLK_SET_RATE_PARENT, reg,
> -			shift, 0, &imx_ccm_lock, NULL);
> +			shift, 0x3, 0, &imx_ccm_lock, NULL);
>  }
>  
>  static inline struct clk *imx_clk_gate2_shared(const char *name,
> @@ -51,7 +51,14 @@ static inline struct clk *imx_clk_gate2_shared(const char *name,
>  		unsigned int *share_count)
>  {
>  	return clk_register_gate2(NULL, name, parent, CLK_SET_RATE_PARENT, reg,
> -			shift, 0, &imx_ccm_lock, share_count);
> +			shift, 0x3, 0, &imx_ccm_lock, share_count);
> +}
> +
> +static inline struct clk *imx_clk_gate2_cgr(const char *name,
> +		const char *parent, void __iomem *reg, u8 shift, u8 cgr_val)
> +{
> +	return clk_register_gate2(NULL, name, parent, CLK_SET_RATE_PARENT, reg,
> +			shift, cgr_val, 0, &imx_ccm_lock, NULL);
>  }
>  
>  struct clk *imx_clk_pfd(const char *name, const char *parent_name,
> diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
> index d6b56b2..84c4809 100644
> --- a/include/dt-bindings/clock/vf610-clock.h
> +++ b/include/dt-bindings/clock/vf610-clock.h
> @@ -169,6 +169,7 @@
>  #define VF610_CLK_PLL7_MAIN		156
>  #define VF610_CLK_USBPHY0		157
>  #define VF610_CLK_USBPHY1		158
> -#define VF610_CLK_END			159
> +#define VF610_CLK_DDRMC			159
> +#define VF610_CLK_END			160
>  
>  #endif /* __DT_BINDINGS_CLOCK_VF610_H */
> -- 
> 2.1.0
> 
