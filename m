Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaBKRqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:46:43 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:41155 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaBKRql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:46:41 -0500
Message-ID: <52FA61F4.90905@atmel.com>
Date: Tue, 11 Feb 2014 18:46:28 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/8] ARM: at91: make use of of_find_matching_node_and_match
References: <1392135847-30791-1-git-send-email-joshc@codeaurora.org> <1392135847-30791-4-git-send-email-joshc@codeaurora.org>
In-Reply-To: <1392135847-30791-4-git-send-email-joshc@codeaurora.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2014 17:24, Josh Cartwright :
> Instead of the of_find_matching_node()/of_match_node() pair, which requires two
> iterations through the match table, make use of of_find_matching_node_and_match(),
> which only iterates through the table once.
> 
> While we're here, mark the rtsc id table const.

Well, I might remove this one, just because other id tables are not
marked as "const" in the same file... So it can be good to change all of
them in a raw.


> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  arch/arm/mach-at91/setup.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index f7ca97b..e884de8 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -352,7 +352,7 @@ void __init at91_ioremap_matrix(u32 base_addr)
>  }
>  
>  #if defined(CONFIG_OF)
> -static struct of_device_id rstc_ids[] = {
> +static const struct of_device_id rstc_ids[] = {
>  	{ .compatible = "atmel,at91sam9260-rstc", .data = at91sam9_alt_restart },
>  	{ .compatible = "atmel,at91sam9g45-rstc", .data = at91sam9g45_restart },
>  	{ /*sentinel*/ }
> @@ -363,7 +363,7 @@ static void at91_dt_rstc(void)
>  	struct device_node *np;
>  	const struct of_device_id *of_id;
>  
> -	np = of_find_matching_node(NULL, rstc_ids);
> +	np = of_find_matching_node_and_match(NULL, rstc_ids, &of_id);
>  	if (!np)
>  		panic("unable to find compatible rstc node in dtb\n");
>  
> @@ -371,10 +371,6 @@ static void at91_dt_rstc(void)
>  	if (!at91_rstc_base)
>  		panic("unable to map rstc cpu registers\n");
>  
> -	of_id = of_match_node(rstc_ids, np);
> -	if (!of_id)
> -		panic("AT91: rtsc no restart function available\n");
> -
>  	arm_pm_restart = of_id->data;
>  
>  	of_node_put(np);
> @@ -392,7 +388,7 @@ static void at91_dt_ramc(void)
>  	struct device_node *np;
>  	const struct of_device_id *of_id;
>  
> -	np = of_find_matching_node(NULL, ramc_ids);
> +	np = of_find_matching_node_and_match(NULL, ramc_ids, &of_id);
>  	if (!np)
>  		panic("unable to find compatible ram controller node in dtb\n");
>  
> @@ -402,11 +398,7 @@ static void at91_dt_ramc(void)
>  	/* the controller may have 2 banks */
>  	at91_ramc_base[1] = of_iomap(np, 1);
>  
> -	of_id = of_match_node(ramc_ids, np);
> -	if (!of_id)
> -		pr_warn("AT91: ramc no standby function available\n");
> -	else
> -		at91_pm_set_standby(of_id->data);
> +	at91_pm_set_standby(of_id->data);

Even if it changes the strict behavior of the function, I do not see any
advantage in keeping the pr_warn() path instead of a simple panic()
protecting the "find" and "match" together...

So, without the "const" modification, it ends up with a:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

=> if you want, I can take the patch with me through arm-soc with at91
material for 3.15 and complete your "const" modification. What do you
think about that?

>  
>  	of_node_put(np);
>  }
> 

Thanks for having taking care of this file, bye,
-- 
Nicolas Ferre
