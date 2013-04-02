Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab3DBAHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:07:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59417 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431Ab3DBAHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:07:42 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 1 Apr 2013 17:07:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tony Chung <tonychung00@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] watchdog: fix w83627hf_wdt  clear timeout expired
Message-ID: <20130402000741.GA4077@roeck-us.net>
References: <1364795972-8649-1-git-send-email-tonychung00@gmail.com>
 <1364795972-8649-2-git-send-email-tonychung00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364795972-8649-2-git-send-email-tonychung00@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 10:59:32PM -0700, Tony Chung wrote:
> Observed that the w83627hf watchdog timer start counting during reboot.
> If the system load the driver after 5  minutes, it rebooted immediately because of timer expired.
> For example, fsck took more than 5 minutes to run, then the computer reboot as soon as the driver was loaded.
> 
Thinking about it, I wonder if that really solves your problem.

If the watchdog driver is built into the kernel, and if the watchdog is already
running, you still may have the problem that it may time out again and trigger
(again) before the watchdog application can be loaded. Ultimately, in such a
situation, the watchdog application, or at least a primitive one, should really
be started from initramfs and possibly be replaced later on by the "real" watchdog
application. The watchdog package includes a small binary for that purpose,
though I have no idea if is is loaded in initramfs or only later.

Ultimately, that also applies to the original problem you tried to solve with
the longer timeout. It doesn't seem correct to have to set a long timeout to
address excessive boot times; in a way that defeats the purpose of a watchdog.
A cleaner solution for that problem would be to make sure that a small watchdog
application is started early in the boot process.

> Signed-off-by: Tony Chung <tonychung00@gmail.com>
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
Did I miss that earlier, or did yo add it in this version ?

Reading the counter register just returned 0, so what are the benefits
of writing 0 into it ?

Thanks,
Guenter

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
