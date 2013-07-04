Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab3GDKzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:55:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:40405 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3GDKzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:55:10 -0400
Date: Thu, 4 Jul 2013 12:55:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alex Shi <alex.shi@intel.com>
cc: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH 3/3] clocksource: fix can not set tsc as clocksource
 bug
In-Reply-To: <1372916056-24301-4-git-send-email-alex.shi@intel.com>
Message-ID: <alpine.DEB.2.02.1307041227470.11637@ionos.tec.linutronix.de>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-4-git-send-email-alex.shi@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jul 2013, Alex Shi wrote:
> commit 5d33b883aed81c6fbcd09c6f7c3619eee850a7e2
>     clocksource: Always verify highres capability
> 
> This commit will reject a clock to be system clocksource if it has no
> CLOCK_SOURCE_VALID_FOR_HRES flags. Then the tsc to be rejected as

No. It rejects the clocksource if the system is in oneshot mode and
the clocksource does not support HIGHRES.

So at boot time, the tick device mode is PERIODIC and the clocksource
is set to jiffies.

In clocksource_done_booting() we select the best clocksource from the
registered list. We are still in PERIODIC mode, so the selection in
clocksource_find_best() should grab TSC whether the HIGHRES_VALID flag
is set or not. The relevant check in find_best() is:

        if (oneshot && !(cs->flags & CLOCK_SOURCE_VALID_FOR_HRES))
                 continue;                                         

And oneshot should be definitely false at that point. So we don't care
about the HRES flag at all.

So if we select TSC from clocksource_done_booting() that prevents the
system from switching into highres mode as long as the VALID_FOR_HRES
flag is not set by the watchdog. If it gets set then
tick_clock_notify() tells the tick code to reevaluate.

So now the question is why you are observing that HPET is selected in
the first place.

Can you add instrumentation to the code and provide the data please? I
try to reproduce myself. What's the environment you're using?

> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 9d6c333..3ad9f29 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -308,6 +308,8 @@ static void clocksource_watchdog(unsigned long data)
>  			 * transition into high-res mode:
>  			 */
>  			tick_clock_notify();
> +			if (finished_booting)
> +				schedule_work(&watchdog_work);

This only makes sense, when the clocksource which gets the FLAG set
has the highest rating, but was not selected because the system was in
ONESHOT mode already.

And I can't see why that should suddenly happen.

>  static int clocksource_watchdog_kthread(void *data)
>  {
>  	struct clocksource *cs, *tmp;
> @@ -412,11 +415,14 @@ static int clocksource_watchdog_kthread(void *data)
>  
>  	mutex_lock(&clocksource_mutex);
>  	spin_lock_irqsave(&watchdog_lock, flags);
> -	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list)
> +	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
>  		if (cs->flags & CLOCK_SOURCE_UNSTABLE) {
>  			list_del_init(&cs->wd_list);
>  			list_add(&cs->wd_list, &unstable);
>  		}
> +		if (cs->flags & CLOCK_SOURCE_VALID_FOR_HRES)
> +			clocksource_select();

Unlikely, but if we have 3 watched clocksources which have the HRES
bit set, you'd call 3 times clocksource_select().

Thanks,

	tglx

