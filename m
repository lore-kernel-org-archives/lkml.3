Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaBDKSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:18:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:45298 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaBDKSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:18:16 -0500
Date: Tue, 4 Feb 2014 11:18:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        galak@kernel.crashing.org, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, mikey@neuling.org,
        shangw@linux.vnet.ibm.com, rafael.j.wysocki@intel.com, agraf@suse.de,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2 2/2] tick/cpuidle: Initialize hrtimer mode of
 broadcast
In-Reply-To: <20140124065820.17564.83076.stgit@preeti>
Message-ID: <alpine.DEB.2.02.1402041101330.24986@ionos.tec.linutronix.de>
References: <20140124065501.17564.39363.stgit@preeti.in.ibm.com> <20140124065820.17564.83076.stgit@preeti>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +++ b/kernel/time/tick-broadcast-hrtimer.c
> +/*
> + * This is called from the guts of the broadcast code when the cpu
> + * which is about to enter idle has the earliest broadcast timer event.
> + */
> +static int bc_set_next(ktime_t expires, struct clock_event_device *bc)
> +{
> +	ktime_t now, interval;
> +	/*
> +	 * We try to cancel the timer first. If the callback is on
> +	 * flight on some other cpu then we let it handle it. If we
> +	 * were able to cancel the timer nothing can rearm it as we
> +	 * own broadcast_lock.
> +	 *
> +	 * However if we are called from the hrtimer interrupt handler
> +	 * itself, reprogram it.
> +	 */
> +	if (hrtimer_try_to_cancel(&bctimer) >= 0) {
> +		hrtimer_start(&bctimer, expires, HRTIMER_MODE_ABS_PINNED);
> +		/* Bind the "device" to the cpu */
> +		bc->bound_on = smp_processor_id();
> +	} else if (bc->bound_on == smp_processor_id()) {

This part really wants a proper comment. It took me a while to figure
out why this is correct and what the call chain is.


> +		now = ktime_get();
> +		interval = ktime_sub(expires, now);
> +		hrtimer_forward_now(&bctimer, interval);

We are in the event handler called from bc_handler() and expires is
absolute time. So what's wrong with calling
hrtimer_set_expires(&bctimer, expires)?

> +static enum hrtimer_restart bc_handler(struct hrtimer *t)
> +{
> +	ce_broadcast_hrtimer.event_handler(&ce_broadcast_hrtimer);
> +	return HRTIMER_RESTART;

We probably want to check whether the timer needs to be restarted at
all.

	if (ce_broadcast_timer.next_event.tv64 == KTIME_MAX)
	   return HRTIMER_NORESTART;

	return HRTIMER_RESTART;

Hmm?

Thanks,

	tglx
