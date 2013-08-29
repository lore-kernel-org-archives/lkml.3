Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3H2LJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:09:33 -0400
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:40424
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab3H2LJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:09:32 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(z37d4l551biz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 29 Aug 2013 19:08:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 08/16] ARM: mxs: remove custom .init_time hook
Message-ID: <20130829110849.GB18729@S2101-09.ap.freescale.net>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1377638890-371-9-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1377638890-371-9-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:28:02PM +0200, Sebastian Hesselbarth wrote:
> @@ -100,19 +101,17 @@ static enum imx23_clk clks_init_on[] __initdata = {
>  	cpu, hbus, xbus, emi, uart,
>  };
>  
> -int __init mx23_clocks_init(void)
> +static void __init mx23_clocks_init(struct device_node *np)
>  {
> -	struct device_node *np;
>  	u32 i;
>  
> +	clkctrl = of_iomap(np, 0);
> +	WARN_ON(!clkctrl);
> +
>  	np = of_find_compatible_node(NULL, NULL, "fsl,imx23-digctl");
>  	digctrl = of_iomap(np, 0);
>  	WARN_ON(!digctrl);
>  
> -	np = of_find_compatible_node(NULL, NULL, "fsl,imx23-clkctrl");
> -	clkctrl = of_iomap(np, 0);
> -	WARN_ON(!clkctrl);
> -

With the changes, 'np' becomes a pointer to digctl node instead of
clkctrl as the original.  This will cause problem for
of_clk_add_provider(np, ...) later in this function.

Same problem with mx28_clocks_init() changes.

Shawn

>  	clk_misc_init();
>  
>  	clks[ref_xtal] = mxs_clk_fixed("ref_xtal", 24000000);
> @@ -162,7 +161,7 @@ int __init mx23_clocks_init(void)
>  		if (IS_ERR(clks[i])) {
>  			pr_err("i.MX23 clk %d: register failed with %ld\n",
>  				i, PTR_ERR(clks[i]));
> -			return PTR_ERR(clks[i]);
> +			return;
>  		}
>  
>  	clk_data.clks = clks;
> @@ -171,6 +170,5 @@ int __init mx23_clocks_init(void)
>  
>  	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
>  		clk_prepare_enable(clks[clks_init_on[i]]);
> -
> -	return 0;
>  }
> +CLK_OF_DECLARE(imx23_clkctrl, "fsl,imx23-clkctrl", mx23_clocks_init);
> diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
> index 4faf0af..12d3f3d 100644
> --- a/drivers/clk/mxs/clk-imx28.c
> +++ b/drivers/clk/mxs/clk-imx28.c
> @@ -12,6 +12,7 @@
>  #include <linux/clk.h>
>  #include <linux/clk/mxs.h>
>  #include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/io.h>
> @@ -154,19 +155,17 @@ static enum imx28_clk clks_init_on[] __initdata = {
>  	cpu, hbus, xbus, emi, uart,
>  };
>  
> -int __init mx28_clocks_init(void)
> +static void __init mx28_clocks_init(struct device_node *np)
>  {
> -	struct device_node *np;
>  	u32 i;
>  
> +	clkctrl = of_iomap(np, 0);
> +	WARN_ON(!clkctrl);
> +
>  	np = of_find_compatible_node(NULL, NULL, "fsl,imx28-digctl");
>  	digctrl = of_iomap(np, 0);
>  	WARN_ON(!digctrl);
>  
> -	np = of_find_compatible_node(NULL, NULL, "fsl,imx28-clkctrl");
> -	clkctrl = of_iomap(np, 0);
> -	WARN_ON(!clkctrl);
> -
>  	clk_misc_init();
>  
>  	clks[ref_xtal] = mxs_clk_fixed("ref_xtal", 24000000);
> @@ -239,7 +238,7 @@ int __init mx28_clocks_init(void)
>  		if (IS_ERR(clks[i])) {
>  			pr_err("i.MX28 clk %d: register failed with %ld\n",
>  				i, PTR_ERR(clks[i]));
> -			return PTR_ERR(clks[i]);
> +			return;
>  		}
>  
>  	clk_data.clks = clks;
> @@ -250,6 +249,5 @@ int __init mx28_clocks_init(void)
>  
>  	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
>  		clk_prepare_enable(clks[clks_init_on[i]]);
> -
> -	return 0;
>  }
> +CLK_OF_DECLARE(imx28_clkctrl, "fsl,imx28-clkctrl", mx28_clocks_init);
> diff --git a/include/linux/clk/mxs.h b/include/linux/clk/mxs.h
> index 90c30dc..5138a90 100644
> --- a/include/linux/clk/mxs.h
> +++ b/include/linux/clk/mxs.h
> @@ -9,8 +9,6 @@
>  #ifndef __LINUX_CLK_MXS_H
>  #define __LINUX_CLK_MXS_H
>  
> -int mx23_clocks_init(void);
> -int mx28_clocks_init(void);
>  int mxs_saif_clkmux_select(unsigned int clkmux);
>  
>  #endif
> -- 
> 1.7.2.5
> 

