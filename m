Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaDOIuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:50:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54124 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaDOIt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:49:59 -0400
Date: Tue, 15 Apr 2014 10:49:44 +0200
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
Subject: Re: [PATCH 1/2] nohz: stop updating sleep stats from
 get_cpu_{idle,iowait}_time_us()
Message-ID: <20140415084944.GK13658@twins.programming.kicks-ass.net>
References: <53465F54.708@jp.fujitsu.com>
 <53466027.3040705@jp.fujitsu.com>
 <20140415084854.GL11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415084854.GL11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:48:54AM +0200, Peter Zijlstra wrote:
> On Thu, Apr 10, 2014 at 06:11:03PM +0900, Hidetoshi Seto wrote:
> > -	if (ts->idle_active) {
> > -		delta = ktime_sub(now, ts->idle_entrytime);
> > -		if (nr_iowait_cpu(cpu) > 0)
> > -			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
> > -		else
> > -			ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
> > -		ts->idle_entrytime = now;
> > -	}
> > -
> > -	if (last_update_time)
> > -		*last_update_time = ktime_to_us(now);
> > -
> > -}
> > -
> > -static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
> > -{
> > -	update_ts_time_stats(smp_processor_id(), ts, now, NULL);
> > +	/* Updates the per cpu time idle statistics counters */
> > +	delta = ktime_sub(now, ts->idle_entrytime);
> > +	if (nr_iowait_cpu(smp_processor_id()) > 0)
> 
> Now I know the old code also uses nr_iowait_cpu(), but that function is
> crackbrained. This cannot possibly be right.
> 
> Anything using nr_iowait_cpu() is broken beyond repair.

Argh, still need to wake up.. so it uses the old rq to decrement
against.

never mind, I'll go stare at it more
