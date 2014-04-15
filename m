Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaDOKT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:19:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54357 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaDOKT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:19:26 -0400
Date: Tue, 15 Apr 2014 12:19:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race on
 idle time stats
Message-ID: <20140415101910.GN11096@twins.programming.kicks-ass.net>
References: <53465F54.708@jp.fujitsu.com>
 <534660D2.1080505@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534660D2.1080505@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 06:13:54PM +0900, Hidetoshi Seto wrote:
> [WHAT THIS PATCH PROPOSED]:
> 
> To fix problem 1, this patch adds seqcount for NO_HZ idle
> accounting to avoid possible races between reader/writer.
> 
> And to cope with problem 2, I introduced delayed iowait
> accounting to get approximate value without making observers
> to writers. Refer comment in patch for the detail.

> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -407,15 +407,42 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
>  {
>  	ktime_t delta;
>  
> +	write_seqcount_begin(&ts->idle_sleeptime_seq);
> +
>  	/* Updates the per cpu time idle statistics counters */
>  	delta = ktime_sub(now, ts->idle_entrytime);
> +
> +	/*
> +	 * Perform delayed iowait accounting:
> +	 *
> +	 * We account sleep time as iowait when nr_iowait of cpu indicates
> +	 * there are taskes blocked by io, at the end of idle (=here).
> +	 * It means we can not determine whether the sleep time will be idle
> +	 * or iowait on the fly.
> +	 * Therefore introduce a new rule:
> +	 * - basically observers assign delta to idle
> +	 * - if cpu find nr_iowait>0 at idle exit, accumulate delta as missed
> +	 *   iowait, and account it in next turn of sleep instead.
> +	 * - if observer find accumulated iowait while cpu is in sleep, it
> +	 *   can calculate proper value to be accounted.
> +	 */
> +	if (ktime_compare(ts->iowait_pending, delta) > 0) {
>  		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
> +		ts->iowait_pending = ktime_sub(ts->iowait_pending, delta);
> +	} else {
> +		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime,
> +					ktime_sub(delta, ts->iowait_pending));
> +		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime,
> +						 ts->iowait_pending);
> +		ts->iowait_pending = ktime_set(0, 0);
> +	}
> +	if (nr_iowait_cpu(smp_processor_id()) > 0)
> +		ts->iowait_pending = ktime_add(ts->iowait_pending, delta);
> +
>  	ts->idle_active = 0;
>  
> +	write_seqcount_end(&ts->idle_sleeptime_seq);
> +
>  	sched_clock_idle_wakeup_event(0);
>  }

Why!? Both changelog and comment are silent on this. This doesn't appear
to make any sense nor really solve anything.

