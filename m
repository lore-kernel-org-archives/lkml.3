Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3HRVjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:39:12 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:59298 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3HRVjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:39:08 -0400
Date: Sun, 18 Aug 2013 23:38:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Stratos Karafotis <stratosk@semaphore.gr>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 1/4] nohz: Only update sleeptime stats locally
Message-ID: <20130818213857.GB22640@somewhere>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-2-git-send-email-fweisbec@gmail.com>
 <20130818164937.GA21310@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818164937.GA21310@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 06:49:37PM +0200, Oleg Nesterov wrote:
> On 08/16, Frederic Weisbecker wrote:
> >
> > To fix this, lets only update the sleeptime stats locally when the CPU
> > exits from idle.
> 
> I am in no position to ack the changes in this area, but I like this
> change very much. Because, as a code reader, I was totally confused by
> 
> 	if (last_update_time)
> 		update_ts_time_stats()
> 
> code and it looks "obviously wrong".
> 
> I added more cc's. It seems to me that 9366d840 "cpufreq: governors:
> Calculate iowait time only when necessary" doesn't realize what
> 
> 	-       u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
> 	+       u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);
> 
> actually means. OTOH, get_cpu_iowait_time_us() was called with
> last_update_time != NULL even before this patch...
> 
> In short. This looks like the clear fix to me, but I do not understand
> this code enough, and I think that cpufreq should know about this change.

Good point, and this time I'm really adding the Cc :)

> 
> >  static void tick_nohz_stop_idle(int cpu, ktime_t now)
> >  {
> >  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> > +	ktime_t delta;
> >  
> > -	update_ts_time_stats(cpu, ts, now, NULL);
> > +	/* Updates the per cpu time idle statistics counters */
> > +	delta = ktime_sub(now, ts->idle_entrytime);
> > +	if (nr_iowait_cpu(cpu) > 0)
> > +		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
> > +	else
> > +		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
> > +	ts->idle_entrytime = now;
> >  	ts->idle_active = 0;
> 
> With or without this change, why we update ->idle_entrytime in this case?
> Looks harmless, but a bit confusing.

Oh indeed I missed that. It's a leftover from the copy-paste of update_ts_time_stats()
content.

Well spotted, I'll fix.

> 
> While this doesn't really matter, we could probably even kill ->idle_active
> and use !!ts->idle_entrytime instead.

We could but it would be slightly more overhead in the irq entry path (cf: tick_check_nohz())
and it makes the code also a little bit harder to review IMHO.

> 
> > @@ -473,17 +458,14 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
> 
> And I think that we should kill this last_update_time argument later.

Agreed.

Thanks.
