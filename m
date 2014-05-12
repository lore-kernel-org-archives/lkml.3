Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaELWUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:20:15 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53251 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaELWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:20:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/rrx3lafzd8vBZSW4/PINy
Date: Mon, 12 May 2014 15:20:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] bus/omap_l3: avoid sync initcall for modules
Message-ID: <20140512222006.GI5668@atomide.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399560990-1402858-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [140508 07:57]:
> The postcore_initcall_sync() macro is only defined for built-in
> code, but the omap_l3 bus code can be built as a module, which
> currently causes a build failure.
> 
> This works around the problem by using #ifdef MODULE to decide
> whether to use a regular module_init() function or not.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/bus/omap_l3_noc.c | 4 ++++
>  drivers/bus/omap_l3_smx.c | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
> index feeecae..648f158 100644
> --- a/drivers/bus/omap_l3_noc.c
> +++ b/drivers/bus/omap_l3_noc.c
> @@ -257,7 +257,11 @@ static int __init omap4_l3_init(void)
>  {
>  	return platform_driver_register(&omap4_l3_driver);
>  }
> +#ifdef MODULE
> +module_init(omap4_l3_init);
> +#else
>  postcore_initcall_sync(omap4_l3_init);
> +#endif
>  
>  static void __exit omap4_l3_exit(void)
>  {
> diff --git a/drivers/bus/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
> index acc2164..f752d1b 100644
> --- a/drivers/bus/omap_l3_smx.c
> +++ b/drivers/bus/omap_l3_smx.c
> @@ -288,7 +288,11 @@ static int __init omap3_l3_init(void)
>  {
>  	return platform_driver_probe(&omap3_l3_driver, omap3_l3_probe);
>  }
> +#ifdef MODULE
> +module_init(omap3_l3_init);
> +#else
>  postcore_initcall_sync(omap3_l3_init);
> +#endif
>  
>  static void __exit omap3_l3_exit(void)
>  {

How about instead let's add this into include/linux/module.h
like we have for other initcalls:

#define postcore_initcall(fn)		module_init(fn)

There may be others missing too from there. BTW, this driver
might be few of the drivers that actually might need to be
initialized early for debugging to catch bad access from
other drivers.

Regards,

Tony
