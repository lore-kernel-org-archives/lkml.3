Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3INRYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:24:35 -0400
Received: from 6.mo5.mail-out.ovh.net ([178.32.119.138]:39602 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932223Ab3INRYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:24:32 -0400
Date: Sat, 14 Sep 2013 18:49:08 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [RFC PATCH 2/4] pinctrl: at91: fix sam9x5 debounce/deglitch
 functions
Message-ID: <20130914164908.GD11420@ns203013.ovh.net>
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
 <1379058442-3321-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379058442-3321-1-git-send-email-b.brezillon@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 10613858422378179449
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:47 Fri 13 Sep     , Boris BREZILLON wrote:
> Replace at91_mux_get_deglitch with at91_mux_pio3_get_deglitch when using
> sam9x5 (pio3) IP.
> at91_mux_get_deglitch only test the activation of the "Input Filter" which
> may be overloaded by the activation of the "Input Filter Slow Clock" to use
> the input filter as a debounce filter instead of a deglitch filter.
> 
> Fix at91_mux_pio3_get_debounce to test the activation of the Input Filter
> before testing the activation of the debounce filter (Input Filter Slow
> Clock depends on Input Filter).
> 
> Fix at91_mux_pio3_set_debounce function to avoid disabling the deglitch
> filter ("Input Filter") when debounce filter is disabled.
> 
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  drivers/pinctrl/pinctrl-at91.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 50b555a..6624bce 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -417,6 +417,14 @@ static void at91_mux_set_deglitch(void __iomem *pio, unsigned mask, bool is_on)
>  	__raw_writel(mask, pio + (is_on ? PIO_IFER : PIO_IFDR));
>  }
>  
> +static bool at91_mux_pio3_get_deglitch(void __iomem *pio, unsigned pin)
> +{
> +	if ((__raw_readl(pio + PIO_IFSR) >> pin) & 0x1)
> +		return !((__raw_readl(pio + PIO_IFSCSR) >> pin) & 0x1);
> +
> +	return false;
> +}
> +
>  static void at91_mux_pio3_set_deglitch(void __iomem *pio, unsigned mask, bool is_on)
>  {
>  	if (is_on)
> @@ -428,7 +436,8 @@ static bool at91_mux_pio3_get_debounce(void __iomem *pio, unsigned pin, u32 *div
>  {
>  	*div = __raw_readl(pio + PIO_SCDR);
>  
> -	return (__raw_readl(pio + PIO_IFSCSR) >> pin) & 0x1;
> +	return ((__raw_readl(pio + PIO_IFSR) >> pin) & 0x1) &&
> +	       ((__raw_readl(pio + PIO_IFSCSR) >> pin) & 0x1);
>  }
>  
>  static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
> @@ -438,9 +447,8 @@ static void at91_mux_pio3_set_debounce(void __iomem *pio, unsigned mask,
>  		__raw_writel(mask, pio + PIO_IFSCER);
>  		__raw_writel(div & PIO_SCDR_DIV, pio + PIO_SCDR);
>  		__raw_writel(mask, pio + PIO_IFER);
> -	} else {
> -		__raw_writel(mask, pio + PIO_IFDR);
> -	}
> +	} else
> +		__raw_writel(mask, pio + PIO_IFSCDR);
>  }
>  
>  static bool at91_mux_pio3_get_pulldown(void __iomem *pio, unsigned pin)
> @@ -478,7 +486,7 @@ static struct at91_pinctrl_mux_ops at91sam9x5_ops = {
>  	.mux_B_periph	= at91_mux_pio3_set_B_periph,
>  	.mux_C_periph	= at91_mux_pio3_set_C_periph,
>  	.mux_D_periph	= at91_mux_pio3_set_D_periph,
> -	.get_deglitch	= at91_mux_get_deglitch,
> +	.get_deglitch	= at91_mux_pio3_get_deglitch,
>  	.set_deglitch	= at91_mux_pio3_set_deglitch,
>  	.get_debounce	= at91_mux_pio3_get_debounce,
>  	.set_debounce	= at91_mux_pio3_set_debounce,
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
