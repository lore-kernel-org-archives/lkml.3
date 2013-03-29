Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3C2Lqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:46:30 -0400
Received: from mail1.vodafone.ie ([213.233.128.43]:57179 "EHLO
	mail1.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3C2Lq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:46:28 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Mar 2013 07:46:28 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcDAOV7VVFtTan2/2dsb2JhbAANNsJXAwGBHoMTAQEBAwEyAUYFCwsNCwkWDwkDAgECAQ82Bg0BBQIBAYd+AwmsNIlTDYlbjEiBcV8Hg0ADlQcBiAKDToF9iCY
Message-ID: <51557CC7.1090108@draigBrady.com>
Date: Fri, 29 Mar 2013 11:36:39 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Chung <tonychung00@gmail.com>
CC: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] watchdog:improve w83627hf_wdt to timeout in minutes
References: <1364184957-32386-1-git-send-email-tonychung00@gmail.com>
In-Reply-To: <1364184957-32386-1-git-send-email-tonychung00@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 04:15 AM, Tony Chung wrote:
> The current maximum of 255 seconds is insufficient.
> For example, crash dump could take 5+ minutes.
> 
> Signed-off-by: Tony Chung <tonychung00@gmail.com>
> ---
>  drivers/watchdog/w83627hf_wdt.c |   73 ++++++++++++++++++++++++++++++--------
>  1 files changed, 57 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
> index 92f1326..d26adfb 100644
> --- a/drivers/watchdog/w83627hf_wdt.c
> +++ b/drivers/watchdog/w83627hf_wdt.c
> @@ -58,7 +58,7 @@ MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
>  static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
>  module_param(timeout, int, 0);
>  MODULE_PARM_DESC(timeout,
> -		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
> +		"Watchdog timeout in seconds. 1 <= timeout <= 15300, default="
>  				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
>  
>  static bool nowayout = WATCHDOG_NOWAYOUT;
> @@ -67,6 +67,29 @@ MODULE_PARM_DESC(nowayout,
>  		"Watchdog cannot be stopped once started (default="
>  				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
>  
> +/* timeout unit in minute */
> +static bool use_minute;
> +static char *unit;
> +static int max_timeout = 15300; /* 255*60 seconds */
> +
> +static inline int wdt_round_secs_to_minute(int t)
> +{
> +	return (t + 59) / 60;
> +}
> +
> +static inline int wdt_use_minute(int t)
> +{
> +	if (t > 255) {
> +		t = wdt_round_secs_to_minute(t);
> +		use_minute = 1;
> +		unit = "minutes";
> +	} else {
> +		use_minute = 0;
> +		unit = "secs";
> +	}
> +	return t;
> +}
> +
>  /*
>   *	Kernel methods.
>   */
> @@ -107,6 +130,23 @@ static void w83627hf_unselect_wd_register(void)
>  	outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
>  }
>  
> +/* set CRF5 register */
> +static void w83627hf_set_crf5(void)
> +{
> +	unsigned char t;
> +
> +	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
> +	t = inb_p(WDT_EFDR);      /* read CRF5 */
> +	t &= ~0x0C;               /* set second mode & disable keyboard
> +				    turning off watchdog */
> +	t |= 0x02;		  /* enable the WDTO# output low pulse
> +				    to the KBRST# pin (PIN60) */
> +	if (use_minute)
> +		t |= 0x80;        /* set timeout in minute */
> +
> +	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
> +}
> +
>  /* tyan motherboards seem to set F5 to 0x4C ?
>   * So explicitly init to appropriate value. */
>  
> @@ -116,21 +156,16 @@ static void w83627hf_init(void)
>  
>  	w83627hf_select_wd_register();
>  
> +	w83627hf_set_crf5();
> +
>  	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
>  	t = inb_p(WDT_EFDR);      /* read CRF6 */
>  	if (t != 0) {
> -		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
> -			timeout);
> +		pr_info("Watchdog already running.  Reset timeout to %d %s\n",
> +			timeout, unit);

"Resetting" is better as otherwise it might read as an instruction to the user.
Alternatively you could have: "Timeout was reset to ..."

>  		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
>  	}
>  
> -	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
> -	t = inb_p(WDT_EFDR);      /* read CRF5 */
> -	t &= ~0x0C;               /* set second mode & disable keyboard
> -				    turning off watchdog */
> -	t |= 0x02;		  /* enable the WDTO# output low pulse
> -				    to the KBRST# pin (PIN60) */
> -	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
>  
>  	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
>  	t = inb_p(WDT_EFDR);      /* read CRF7 */
> @@ -147,6 +182,9 @@ static void wdt_set_time(int timeout)
>  
>  	w83627hf_select_wd_register();
>  
> +	if (use_minute)
> +		w83627hf_set_crf5();

Why is this bit needed in set_time()?

On a general note, one has to be careful when changing
between second and minute modes, if the watchdog is already running
(from the BIOS for example).

thanks,
Pádraig.
