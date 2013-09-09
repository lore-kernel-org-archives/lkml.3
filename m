Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3IINqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:46:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3IINqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:46:46 -0400
Date: Mon, 9 Sep 2013 15:46:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, ethan.kernel@gmail.com,
        rjw@sisk.pl, daniel.lezcano@linaro.org, linux-pm@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
Message-ID: <20130909134635.GB26785@twins.programming.kicks-ass.net>
References: <20130729115701.GD3008@twins.programming.kicks-ass.net>
 <24EECBCC-F655-404F-8946-73CC36095A5F@gmail.com>
 <1378362989.18435.2.camel@marge.simpson.net>
 <20130905111428.GB23362@gmail.com>
 <1378386697.6567.9.camel@marge.simpson.net>
 <20130905133750.GA26637@gmail.com>
 <1378445942.5434.31.camel@marge.simpson.net>
 <20130909122325.GX31370@twins.programming.kicks-ass.net>
 <1378730538.5586.30.camel@marge.simpson.net>
 <20130909133044.GB31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909133044.GB31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 03:30:44PM +0200, Peter Zijlstra wrote:
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index fa6964d..486c0ba 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -359,6 +359,14 @@ static int intel_idle(struct cpuidle_device *dev,
>  	if (!(lapic_timer_reliable_states & (1 << (cstate))))
>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
>  
> +	current_thread_into()->status |= TS_POLLING;
> +
> +	/*
> +	 * Order against setting of TS_POLLING against the reading of
> +	 * NEED_RESCHED, matched by resched_task().
> +	 */
> +	smp_mb();
> +
>  	if (!need_resched()) {
>  
>  		__monitor((void *)&current_thread_info()->flags, 0, 0);
> @@ -367,6 +375,8 @@ static int intel_idle(struct cpuidle_device *dev,
>  			__mwait(eax, ecx);
>  	}
>  
> +	current_thread_into()->status &= ~TS_POLLING;
> +
>  	if (!(lapic_timer_reliable_states & (1 << (cstate))))
>  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);

Hmm, arguably it would be better to set this from
intel_idle_cpuidle_driver_init() and clear it whenever this goes away.
Not sure how all that works, the cpuidle driver framework seems 'weird'.

