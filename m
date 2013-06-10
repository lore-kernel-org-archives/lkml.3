Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3FJRwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:52:34 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36400 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3FJRwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:52:32 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Cc: <j-keerthy@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] PM / AVS: SmartReflex/class3: Fix order of initialization of SR class and SR driver
References: <1370339913-16135-1-git-send-email-andrii.tseglytskyi@ti.com>
	<1370339913-16135-3-git-send-email-andrii.tseglytskyi@ti.com>
Date: Mon, 10 Jun 2013 10:52:28 -0700
In-Reply-To: <1370339913-16135-3-git-send-email-andrii.tseglytskyi@ti.com>
	(Andrii Tseglytskyi's message of "Tue, 4 Jun 2013 12:58:33 +0300")
Message-ID: <87fvwpdfab.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:

> SmartReflex consists of three entities: SR device, SR class and
> SR driver. SmartReflex driver depends on SmartReflex class, but
> order of their initialization is not clear. They both use
> late_initcall(), and order depends on Makefile calls.
> Patch moves initialization of SR class to device_initcall(),
> and removes redundant call of sr_late_init().
>
> This provides predictable order of SmartReflex initcalls:
> 1. device_initcall() -> SmartReflex class init
> 2. late_initcall() -> SmartReflex driver init
>
> Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>

Tony will have to decide on whether he's OK with the initcall changes.

I can queue this with the rest of the AVS changes with Tony's ack.

Kevin

> ---
>  arch/arm/mach-omap2/smartreflex-class3.c |    2 +-
>  drivers/power/avs/smartreflex.c          |    9 ---------
>  2 files changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
> index aee3c89..50523b8 100644
> --- a/arch/arm/mach-omap2/smartreflex-class3.c
> +++ b/arch/arm/mach-omap2/smartreflex-class3.c
> @@ -59,4 +59,4 @@ static int __init sr_class3_init(void)
>  	pr_info("SmartReflex Class3 initialized\n");
>  	return sr_register_class(&class3_data);
>  }
> -omap_late_initcall(sr_class3_init);
> +omap_device_initcall(sr_class3_init);
> diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
> index fd71d5a..42eed34 100644
> --- a/drivers/power/avs/smartreflex.c
> +++ b/drivers/power/avs/smartreflex.c
> @@ -650,8 +650,6 @@ void sr_disable(struct voltagedomain *voltdm)
>   */
>  int sr_register_class(struct omap_sr_class_data *class_data)
>  {
> -	struct omap_sr *sr_info;
> -
>  	if (!class_data) {
>  		pr_warning("%s:, Smartreflex class data passed is NULL\n",
>  			__func__);
> @@ -666,13 +664,6 @@ int sr_register_class(struct omap_sr_class_data *class_data)
>  
>  	sr_class = class_data;
>  
> -	/*
> -	 * Call into late init to do intializations that require
> -	 * both sr driver and sr class driver to be initiallized.
> -	 */
> -	list_for_each_entry(sr_info, &sr_list, node)
> -		sr_late_init(sr_info);
> -
>  	return 0;
>  }
