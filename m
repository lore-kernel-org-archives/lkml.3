Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3A2L2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:28:35 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:30718 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752814Ab3A2L2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:28:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 29 Jan 2013 19:28:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Gary Zhang <b13634@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: imx: set CKO1 parent clock source in imx6q
 sabresd
Message-ID: <20130129112846.GG21504@S2101-09.ap.freescale.net>
References: <1359445779-2038-1-git-send-email-b13634@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359445779-2038-1-git-send-email-b13634@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary,

For arch/arm/ patches, list linux-arm-kernel@lists.infradead.org rather
than linux-kernel@vger.kernel.org should be copied.

One comment blow.

On Tue, Jan 29, 2013 at 03:49:39PM +0800, Gary Zhang wrote:
> in imx6q sabresd board, wm8962 uses CKO1 as MCLK. set ahb as CKO1
> parent clock source
> 
> Signed-off-by: Gary Zhang <b13634@freescale.com>
> ---
>  arch/arm/mach-imx/mach-imx6q.c |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
> index 4eb1b3a..ee3f357 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -151,6 +151,36 @@ static void __init imx6q_sabrelite_init(void)
>  	imx6q_sabrelite_cko1_setup();
>  }
>  
> +static void __init imx6q_sabresd_cko1_setup(void)
> +{
> +	struct clk *cko1_sel, *ahb, *cko1;
> +	unsigned long rate;
> +
> +	cko1_sel = clk_get_sys(NULL, "cko1_sel");
> +	ahb = clk_get_sys(NULL, "ahb");
> +	cko1 = clk_get_sys(NULL, "cko1");
> +	if (IS_ERR(cko1_sel) || IS_ERR(ahb) || IS_ERR(cko1)) {
> +		pr_err("cko1 setup failed!\n");
> +		goto put_clk;
> +	}
> +	clk_set_parent(cko1_sel, ahb);
> +	rate = clk_round_rate(cko1, 24000000);
> +	clk_set_rate(cko1, rate);
> +
> +	return;
> +put_clk:
> +	if (!IS_ERR(cko1_sel))
> +		clk_put(cko1_sel);
> +	if (!IS_ERR(ahb))
> +		clk_put(ahb);
> +	if (!IS_ERR(cko1))
> +		clk_put(cko1);
> +}

So the only difference between this function and imx6q_sabrelite_cko1_setup()
is the frequency set on cko1?  If so, we should consolidate them with
frequency passed in as a parameter.

Shawn

> +static void __init imx6q_sabresd_init(void)
> +{
> +	imx6q_sabresd_cko1_setup();
> +}
> +
>  static void __init imx6q_1588_init(void)
>  {
>  	struct regmap *gpr;
> @@ -193,6 +223,8 @@ static void __init imx6q_init_machine(void)
>  {
>  	if (of_machine_is_compatible("fsl,imx6q-sabrelite"))
>  		imx6q_sabrelite_init();
> +	else if (of_machine_is_compatible("fsl,imx6q-sabresd"))
> +		imx6q_sabresd_init();
>  
>  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>  
> -- 
> 1.7.0.4
> 
> 

