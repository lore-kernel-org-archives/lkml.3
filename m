Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaGGO75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:59:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58019 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753773AbaGGO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:59:54 -0400
Date: Mon, 7 Jul 2014 16:59:51 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com,
        Boris Brezillon <boris@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 04/18] AT91: Rework ramc mapping code
Message-ID: <20140707145951.GD3113@piout.net>
References: <1404743131-24569-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404743131-24569-5-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404743131-24569-5-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 at 16:25:17 +0200, Maxime Ripard wrote :
> Adapt the ramc mapping code to handle multiple ram controllers in the DT.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-at91/setup.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 

I believe you also need to update the documentation in
Documentation/devicetree/bindings/arm/atmel-at91.txt

> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 9c4c7fb323fb..cc520596f23b 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -393,24 +393,26 @@ static void at91_dt_ramc(void)
>  {
>  	struct device_node *np;
>  	const struct of_device_id *of_id;
> +	int idx = 0;
>  
> -	np = of_find_matching_node(NULL, ramc_ids);
> -	if (!np)
> -		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
> +	for_each_matching_node(np, ramc_ids) {
> +		at91_ramc_base[idx] = of_iomap(np, 0);
> +		if (!at91_ramc_base[idx])
> +			panic(pr_fmt("unable to map ramc[%d] cpu registers\n"), idx);
>  
> -	at91_ramc_base[0] = of_iomap(np, 0);
> -	if (!at91_ramc_base[0])
> -		panic(pr_fmt("unable to map ramc[0] cpu registers\n"));
> -	/* the controller may have 2 banks */
> -	at91_ramc_base[1] = of_iomap(np, 1);
> +		idx++;
> +	}
> +
> +	if (!idx)
> +		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
>  
>  	of_id = of_match_node(ramc_ids, np);
> -	if (!of_id)
> +	if (!of_id) {
>  		pr_warn("ramc no standby function available\n");
> -	else
> -		at91_pm_set_standby(of_id->data);
> +		return;
> +	}
>  
> -	of_node_put(np);
> +	at91_pm_set_standby(of_id->data);
>  }
>  
>  static struct of_device_id shdwc_ids[] = {
> -- 
> 2.0.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
