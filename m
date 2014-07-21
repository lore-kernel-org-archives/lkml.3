Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaGULHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:07:22 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14944 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaGULHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:07:21 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18ag1zpoHXN1CGJVeYXS5tb
Date: Mon, 21 Jul 2014 04:05:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] ARM: OMAP2+: timer: Simplify clock event/source name
 setting
Message-ID: <20140721110556.GW18374@atomide.com>
References: <1398216429-4681-1-git-send-email-joelf@ti.com>
 <1398216429-4681-3-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398216429-4681-3-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [140422 18:27]:
> For the OMAPs, we're setting up only one clockevent and clocksource. Further,
> for DT boot there's no easy way to get the timer name and currently this is
> done in an ugly way by reading a hwmod entry. So let's just set it to a simpler
> name like timer_clkev and timer_clksrc.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/mach-omap2/timer.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> index ec427e6..f192a41 100644
> --- a/arch/arm/mach-omap2/timer.c
> +++ b/arch/arm/mach-omap2/timer.c
> @@ -251,7 +251,6 @@ static u32 __init omap_dm_timer_get_errata(void)
>  static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
>  					 const char *fck_source,
>  					 const char *property,
> -					 const char **timer_name,
>  					 int posted)
>  {
>  	char name[10]; /* 10 = sizeof("gptXX_Xck0") */
> @@ -290,8 +289,6 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
>  	if (!oh)
>  		return -ENODEV;
>  
> -	*timer_name = oh->name;
> -
>  	if (!of_have_populated_dt()) {
>  		r = omap_hwmod_get_resource_byname(oh, IORESOURCE_IRQ, NULL,
>  						   &irq);
> @@ -365,8 +362,10 @@ static void __init omap2_gp_clockevent_init(int gptimer_id,
>  	 */
>  	__omap_dm_timer_override_errata(&clkev, OMAP_TIMER_ERRATA_I103_I767);
>  
> +	clockevent_gpt.name = "timer_clkev";
> +
>  	res = omap_dm_timer_init_one(&clkev, fck_source, property,
> -				     &clockevent_gpt.name, OMAP_TIMER_POSTED);
> +				     OMAP_TIMER_POSTED);
>  	BUG_ON(res);
>  
>  	omap2_gp_timer_irq.dev_id = &clkev;
> @@ -489,10 +488,11 @@ static void __init omap2_gptimer_clocksource_init(int gptimer_id,
>  	clksrc.errata = omap_dm_timer_get_errata();
>  
>  	res = omap_dm_timer_init_one(&clksrc, fck_source, property,
> -				     &clocksource_gpt.name,
>  				     OMAP_TIMER_NONPOSTED);
>  	BUG_ON(res);
>  
> +	clocksource_gpt.name = "timer_clksrc";
> +
>  	__omap_dm_timer_load_start(&clksrc,
>  				   OMAP_TIMER_CTRL_AR, 0,
>  				   OMAP_TIMER_NONPOSTED);

Hmm aren't we losing information now about which timer we are using?

Might be worth checking if these new names are getting copied somewhere
or what happens after init?

Regards,

Tony
