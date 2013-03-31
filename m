Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3CaELO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 00:11:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59145 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab3CaELN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 00:11:13 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 30 Mar 2013 21:11:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Tony Chung <tonychung00@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] watchdog: fix w83627hf_wdt reboot due to timeout
 expired
Message-ID: <20130331041115.GA13304@roeck-us.net>
References: <1364695148-5605-1-git-send-email-tonychung00@gmail.com>
 <1364695148-5605-2-git-send-email-tonychung00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364695148-5605-2-git-send-email-tonychung00@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 06:59:08PM -0700, Tony Chung wrote:
> Observed that the w83627hf watchdog timer start counting during reboot.
> If the system load the driver after 5  minutes, it rebooted immediately because of timer expired.
> For example, fsck took more than 5 minutes to run, then reboot will occurred.
> 
> Signed-off-by: Tony Chung <tonychung00@gmail.com>
> ---
>  drivers/watchdog/w83627hf_wdt.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
> index 8f1111d..47eb233 100644
> --- a/drivers/watchdog/w83627hf_wdt.c
> +++ b/drivers/watchdog/w83627hf_wdt.c
> @@ -174,6 +174,11 @@ static void w83627hf_init(void)
>  
>  	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
>  	t = inb_p(WDT_EFDR);      /* read CRF7 */
> +	if (t & 0x10) {
> +		pr_info("Watchdog Timer timeout occurred!");
> +		t &= ~0x10; /* clear the event */
> +		pr_info("Event cleared\n");
> +	}
>  	t &= ~0xC0;               /* disable keyboard & mouse turning off
>  				    watchdog */

I would suggest to simply clear it silently. I don't think an extra message
provides any real value.

	t &= ~0xE0;	/* clear watchdog, disable keyboard & mouse
			   turning off watchdog */

Guenter

>  	outb_p(t, WDT_EFDR);    /* Write back to CRF7 */
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
