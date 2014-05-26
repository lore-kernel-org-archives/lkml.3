Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaEZV0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:26:10 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:56575 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751443AbaEZV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:26:08 -0400
Date: Mon, 26 May 2014 23:26:06 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] watchdog: w83627hf_wdt: Add early_disable module parameter
Message-ID: <20140526212606.GA23827@spo001.leaseweb.com>
References: <1396722457-8275-1-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396722457-8275-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> Add early_disable module parameter to match functionality previously
> available in the w83697hf_wdt driver.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/watchdog/w83627hf_wdt.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
> index b1da0c1..7165704 100644
> --- a/drivers/watchdog/w83627hf_wdt.c
> +++ b/drivers/watchdog/w83627hf_wdt.c
> @@ -64,6 +64,10 @@ MODULE_PARM_DESC(nowayout,
>  		"Watchdog cannot be stopped once started (default="
>  				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
>  
> +static int early_disable;
> +module_param(early_disable, int, 0);
> +MODULE_PARM_DESC(early_disable, "Disable watchdog at boot time (default=0)");
> +
>  /*
>   *	Kernel methods.
>   */
> @@ -208,9 +212,14 @@ static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
>  
>  	t = superio_inb(cr_wdt_timeout);
>  	if (t != 0) {
> -		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
> -			wdog->timeout);
> -		superio_outb(cr_wdt_timeout, wdog->timeout);
> +		if (early_disable) {
> +			pr_warn("Stopping previously enabled watchdog until userland kicks in\n");
> +			superio_outb(cr_wdt_timeout, 0);
> +		} else {
> +			pr_info("Watchdog already running. Resetting timeout to %d sec\n",
> +				wdog->timeout);
> +			superio_outb(cr_wdt_timeout, wdog->timeout);
> +		}
>  	}
>  
>  	/* set second mode & disable keyboard turning off watchdog */

Has been added to linux-watchdog-next.

Kind regards,
Wim.

