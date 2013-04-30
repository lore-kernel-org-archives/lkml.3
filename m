Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615Ab3D3Avv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:51:51 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40764 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758839Ab3D3Avt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:51:49 -0400
Message-ID: <517F15A2.3010300@linaro.org>
Date: Mon, 29 Apr 2013 17:51:46 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 04/15] clocksource: Add module refcount
References: <20130425142452.908423538@linutronix.de> <20130425143435.762417789@linutronix.de>
In-Reply-To: <20130425143435.762417789@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 01:31 PM, Thomas Gleixner wrote:
> Add a module refcount, so the current clocksource cannot be removed
> unconditionally.
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> ---
>   include/linux/clocksource.h |    3 +++
>   kernel/time/timekeeping.c   |   15 ++++++++++-----
>   2 files changed, 13 insertions(+), 5 deletions(-)
>
> Index: tip/include/linux/clocksource.h
> ===================================================================
> --- tip.orig/include/linux/clocksource.h
> +++ tip/include/linux/clocksource.h
> @@ -21,6 +21,7 @@
>   /* clocksource cycle base type */
>   typedef u64 cycle_t;
>   struct clocksource;
> +struct module;
>   
>   #ifdef CONFIG_ARCH_CLOCKSOURCE_DATA
>   #include <asm/clocksource.h>
> @@ -162,6 +163,7 @@ extern u64 timecounter_cyc2time(struct t
>    * @suspend:		suspend function for the clocksource, if necessary
>    * @resume:		resume function for the clocksource, if necessary
>    * @cycle_last:		most recent cycle counter value seen by ::read()
> + * @owner:		module reference
>    */
>   struct clocksource {
>   	/*
> @@ -195,6 +197,7 @@ struct clocksource {
>   	cycle_t cs_last;
>   	cycle_t wd_last;
>   #endif
> +	struct module *owner;

Maybe could you add a comment about who is expected to set the owner ptr?



>   } ____cacheline_aligned;
>   
>   /*
> Index: tip/kernel/time/timekeeping.c
> ===================================================================
> --- tip.orig/kernel/time/timekeeping.c
> +++ tip/kernel/time/timekeeping.c
> @@ -627,11 +627,16 @@ static int change_clocksource(void *data
>   	write_seqcount_begin(&timekeeper_seq);
>   
>   	timekeeping_forward_now(tk);
> -	if (!new->enable || new->enable(new) == 0) {
> -		old = tk->clock;
> -		tk_setup_internals(tk, new);
> -		if (old->disable)
> -			old->disable(old);
> +	if (try_module_get(new->owner)) {

Hrm..  So this works, but the interface is a bit non-intuitive, since 
without looking up try_module_get() I'd be surprised that this would 
succeed if the owner ptr is null. Maybe deserves a comment?

> +		if (!new->enable || new->enable(new) == 0) {
> +			old = tk->clock;
> +			tk_setup_internals(tk, new);
> +			if (old->disable)
> +				old->disable(old);
> +			module_put(old->owner);
> +		} else {
> +			module_put(new->owner);
> +		}
>   	}
>   	timekeeping_update(tk, true, true);
>   

thanks
-john

