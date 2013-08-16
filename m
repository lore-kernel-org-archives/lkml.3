Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3HPQqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:46:35 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:49535 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3HPQqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:46:31 -0400
Date: Fri, 16 Aug 2013 18:46:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130816164626.GH24210@somewhere>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
 <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816162654.GA453@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 06:26:54PM +0200, Oleg Nesterov wrote:
> On 08/16, Frederic Weisbecker wrote:
> >
> > On Fri, Aug 16, 2013 at 06:02:01PM +0200, Oleg Nesterov wrote:
> > > > +	do {
> > > > +		seq = read_seqcount_begin(&ts->sleeptime_seq);
> > > > +		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
> > > > +			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> > > > +			iowait = ktime_add(ts->iowait_sleeptime, delta);
> > > > +		} else {
> > > > +			iowait = ts->iowait_sleeptime;
> > > > +		}
> > > > +	} while (read_seqcount_retry(&ts->sleeptime_seq, seq));
> > >
> > > Unless I missread this patch, this is still racy a bit.
> > >
> > > Suppose it is called on CPU_0 and cpu == 1. Suppose that
> > > ts->idle_active == T and nr_iowait_cpu(cpu) == 1.
> > >
> > > So we return iowait_sleeptime + delta.
> > >
> > > Suppose that we call get_cpu_iowait_time_us() again. By this time
> > > the task which incremented ->nr_iowait can be woken up on another
> > > CPU, and it can do atomic_dec(rq->nr_iowait). So the next time
> > > we return iowait_sleeptime, and this is not monotonic again.
> >
> > Hmm, by the time it decrements nr_iowait, it returned from schedule() and
> > so idle had flushed the pending iowait sleeptime.
> 
> Suppose a task does io_schedule() on CPU_0, and increments the counter.
> This CPU becomes idle and nr_iowait_cpu(0) == 1.
> 
> Then this task is woken up, but try_to_wake_up() selects another CPU != 0.
> 
> It returns from schedule() and decrements the same counter, it doesn't
> do raw_rq/etc again. nr_iowait_cpu(0) becomes 0.
> 
> In fact the task can even migrate to another CPU right after raw_rq().

Ah I see now. So that indeed yet another race.

Should we flush that iowait to the src CPU? But then it means we must handle
concurrent updates to iowait_sleeptime, idle_sleeptime from the migration
code and from idle enter / exit.

So I fear we need a seqlock.

Or we can live with that and still account the whole idle time slept until
tick_nohz_stop_idle() to iowait if we called tick_nohz_start_idle() with nr_iowait > 0.
All we need is just a new field in ts-> that records on which state we entered
idle.

What do you think?

Ingo, Thomas?
