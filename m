Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaHEHaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:30:25 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:32754
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932260AbaHEHaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:30:24 -0400
Date: Tue, 5 Aug 2014 15:30:01 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <Guangyu.Chen@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 3/3] ARM: imx6q: Add the clock route from external OSC
 to ESAI clock
Message-ID: <20140805073000.GI2167@dragon>
References: <cover.1407148853.git.shengjiu.wang@freescale.com>
 <f680e189741811194a8096c933b63a8b5ad83fae.1407148853.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f680e189741811194a8096c933b63a8b5ad83fae.1407148853.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(51704005)(189002)(199002)(24454002)(23726002)(4396001)(79102001)(46406003)(50466002)(76482001)(77982001)(46102001)(33716001)(83506001)(47776003)(20776003)(64706001)(80022001)(81342001)(84676001)(81542001)(83322001)(19580395003)(19580405001)(86362001)(21056001)(99396002)(74502001)(50986999)(54356999)(97756001)(97736001)(76176999)(68736004)(69596002)(74662001)(31966008)(105606002)(110136001)(107046002)(83072002)(92566001)(81156004)(106466001)(85852003)(85306004)(104016003)(92726001)(95666004)(26826002)(102836001)(6806004)(44976005)(87936001)(33656002)(57986006)(32563001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB433;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 07:11:15PM +0800, Shengjiu Wang wrote:
> This patch mainly adds the clock route from external 24.576MHz OSC to internal
> ESAI clock via analog clock2 PADs on the SoC and pll4 so that ESAI can get an
> entirely synchronous clock source against CS42888.
> 
> [ 1, We found if using pll4 to generate a 24.576MHz from inernal 24.0MHz OSC,
>   we would get noise during the audio playback via ESAI->CS42888 even though
>   this generated clock's rate is equal to the external one statistically. It
>   might be resulted from the tiny difference between two clock source, which
>   might be crucial to the sensitive CODEC we use -- CS42888. So we here apply
>   the old 3.0.35 way to feed ESAI the same clock source as CS42888.
> 
>   2, Ideally, we should use bypass mode for pll4 since we only need to get
>   the raw rate (24.576MHz) while currently bypass mode in clk-pllv3.c isn't
>   entirely supported: The clock rate would be fixed to 24.0MHz if setting to
>   bypass, which would cause child clock get an incorrect rate and the driver
>   who uses the child clock fail to derive a needed clock rate, and it might
>   be dangerous to involve the clk-pllv3.c driver to this fix. Thus we here
>   apply 3.0.35 way provisionally. ]

Instead of hacking it around, I consider it's time to properly implement
PLL bypass mode.  It's essentially just another multiplexer.

Shawn

> 
>   Expected result:
> 
>   anaclk2                 0           1            24576000
>    lvds2_in               0           1            24576000
>     pll4_sel              0           1            24576000
>      pll4_audio           0           1            786432000
>       pll4_post_div       0           1            786432000
>        pll4_audio_div     0           1            786432000
>         esai_sel          0           1            786432000
>          esai_pred        0           1            98304000
>           esai_podf       0           1            24576000
>            esai           0           1            24576000
> 
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> ---
>  arch/arm/mach-imx/clk-imx6q.c  |    5 +++++
>  arch/arm/mach-imx/mach-imx6q.c |   28 ++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
> index 927a062..2d3634f 100644
> --- a/arch/arm/mach-imx/clk-imx6q.c
> +++ b/arch/arm/mach-imx/clk-imx6q.c
> @@ -413,6 +413,10 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
>  
>  	clk_register_clkdev(clk[IMX6QDL_CLK_ENET_REF], "enet_ref", NULL);
> +	clk_register_clkdev(clk[IMX6QDL_CLK_PLL4_AUDIO_DIV], "pll4_audio_div", NULL);
> +	clk_register_clkdev(clk[IMX6QDL_CLK_PLL4_SEL], "pll4_sel", NULL);
> +	clk_register_clkdev(clk[IMX6QDL_CLK_LVDS2_IN], "lvds2_in", NULL);
> +	clk_register_clkdev(clk[IMX6QDL_CLK_ESAI_EXTAL], "esai_extal", NULL);
>  
>  	if ((imx_get_soc_revision() != IMX_CHIP_REVISION_1_0) ||
>  	    cpu_is_imx6dl()) {
> @@ -456,6 +460,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  
>  	/* Audio-related clocks configuration */
>  	clk_set_parent(clk[IMX6QDL_CLK_SPDIF_SEL], clk[IMX6QDL_CLK_PLL3_PFD3_454M]);
> +	clk_set_parent(clk[IMX6QDL_CLK_ESAI_SEL], clk[IMX6QDL_CLK_PLL4_AUDIO_DIV]);
>  
>  	/* All existing boards with PCIe use LVDS1 */
>  	if (IS_ENABLED(CONFIG_PCI_IMX6))
> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
> index d51c6e9..ea24a96 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -362,6 +362,28 @@ put_node:
>  	of_node_put(np);
>  }
>  
> +#define ESAI_AUDIO_MCLK 24576000
> +
> +static void __init imx6q_audio_lvds2_init(void)
> +{
> +        struct clk *pll4_sel, *lvds2_in, *pll4_audio_div, *esai_extal;
> +
> +        pll4_audio_div = clk_get_sys(NULL, "pll4_audio_div");
> +        pll4_sel = clk_get_sys(NULL, "pll4_sel");
> +        lvds2_in = clk_get_sys(NULL, "lvds2_in");
> +        esai_extal = clk_get_sys(NULL, "esai_extal");
> +        if (IS_ERR(pll4_audio_div) || IS_ERR(pll4_sel) ||
> +            IS_ERR(lvds2_in) || IS_ERR(esai_extal))
> +                return;
> +
> +        if (clk_get_rate(lvds2_in) != ESAI_AUDIO_MCLK)
> +                return;
> +
> +        clk_set_parent(pll4_sel, lvds2_in);
> +        clk_set_rate(pll4_audio_div, 786432000);
> +        clk_set_rate(esai_extal, ESAI_AUDIO_MCLK);
> +}
> +
>  static struct platform_device imx6q_cpufreq_pdev = {
>  	.name = "imx6q-cpufreq",
>  };
> @@ -379,6 +401,12 @@ static void __init imx6q_init_late(void)
>  		imx6q_opp_init();
>  		platform_device_register(&imx6q_cpufreq_pdev);
>  	}
> +
> +	if (of_machine_is_compatible("fsl,imx6q-sabreauto")
> +		|| of_machine_is_compatible("fsl,imx6dl-sabreauto")) {
> +		imx6q_audio_lvds2_init();
> +	}
> +
>  }
>  
>  static void __init imx6q_map_io(void)
> -- 
> 1.7.9.5
> 
