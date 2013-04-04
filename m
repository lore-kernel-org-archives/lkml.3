Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465Ab3DDF3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:29:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54738 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3DDF3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:29:41 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 3 Apr 2013 22:29:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tony Chung <tonychung00@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] watchdog: fix w83627hf_wdt  clear timeout expired
Message-ID: <20130404052945.GA21371@roeck-us.net>
References: <1365050384-9130-1-git-send-email-tonychung00@gmail.com>
 <1365050384-9130-2-git-send-email-tonychung00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365050384-9130-2-git-send-email-tonychung00@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 09:39:44PM -0700, Tony Chung wrote:
> 
> Observed that the Watchdog Timer Status bit can be set when the driver is
> loaded. Reset it during initialization. The time-out value must be set to 0
> explicitly in this case to prevent an immediate reset.
> 
> Depending on the motherboard and with watchdog disabled in the BIOS, this reset problem can easily be reproduced by the following steps:
> 1.  reboot the system 
> 2.  wait for 5+ minutes 
> 3.  don't start any watchdog server.
> 4.  just run "modprobe w83627hf_wdt"
> 
> If the system load the driver after 5  minutes, it rebooted immediately because of timer expired.  For example, fsck could take more than 5 minutes to run, 
> then the computer reboot as soon as the driver was loaded.
> 
[ the above aplies to your system, so I would not add that to the commit log,
but that it up to Wim to decide ]

> Signed-off-by: Tony Chung <tonychung00@gmail.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  drivers/watchdog/w83627hf_wdt.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
> index 8f1111d..7eaa226 100644
> --- a/drivers/watchdog/w83627hf_wdt.c
> +++ b/drivers/watchdog/w83627hf_wdt.c
> @@ -168,14 +168,16 @@ static void w83627hf_init(void)
>  		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
>  			wdt_get_timeout_secs(timeout));
>  		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
> +	} else {
> +		outb_p(0, WDT_EFDR);    /* disable to prevent reboot */
>  	}
>  
>  	w83627hf_setup_crf5();
>  
>  	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
>  	t = inb_p(WDT_EFDR);      /* read CRF7 */
> -	t &= ~0xC0;               /* disable keyboard & mouse turning off
> -				    watchdog */
> +	t &= ~0xD0;               /* clear timeout occurred and disable keyboard
> +				     & mouse turning off watchdog */
>  	outb_p(t, WDT_EFDR);    /* Write back to CRF7 */
>  
>  	w83627hf_unselect_wd_register();
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
