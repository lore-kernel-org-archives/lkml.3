Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3JAOFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:05:32 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:52966 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3JAOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:05:31 -0400
Date: Tue, 1 Oct 2013 16:05:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20131001140525.GE24825@localhost.localdomain>
References: <52138BE9.5090005@linux.intel.com>
 <20130820160146.GG3258@twins.programming.kicks-ass.net>
 <20130820163312.GA17957@redhat.com>
 <20130820175429.GI3258@twins.programming.kicks-ass.net>
 <20130820182553.GB22287@redhat.com>
 <20130821083130.GM3258@twins.programming.kicks-ass.net>
 <20130821113551.GA1472@redhat.com>
 <20130821123311.GA31370@twins.programming.kicks-ass.net>
 <20130821142356.GC31370@twins.programming.kicks-ass.net>
 <20130821164146.GA15194@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821164146.GA15194@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 06:41:46PM +0200, Oleg Nesterov wrote:
> On 08/21, Peter Zijlstra wrote:
> >
> > The other consideration is that this adds two branches to the normal
> > schedule path. I really don't know what the regular ratio between
> > schedule() and io_schedule() is -- and I suspect it can very much depend
> > on workload -- but it might be a net loss due to that, even if it makes
> > io_schedule() 'lots' cheaper.
> 
> Yes, agreed. Please ignore it for now, I didn't try to actually suggest
> this change. And even if this is fine perfomance wise, this needs some
> benchmarking.
> 
> Well. actually I have a vague feeling that _perhaps_ this change can
> help to solve other problems we are discussing, but I am not sure and
> right now I can't even explain the idea to me.
> 
> In short: please ignore ;)
> 
> Oleg.
> 

Ok, the discussion is hard to synthesize but I think I now have more
clues to send a better new iteration.

So we have the choice between keeping atomics or using rq->lock. It seems
that using rq->lock is going to be worrisome for several reasons. So let's
stick to atomics (but tell me if you prefer the other way).

So the idea for the next try is to do something along the lines of:

struct cpu_idletime {
       nr_iowait,
       seqlock,
       idle_start,
       idle_time,
       iowait_time,
} __cacheline_aligned_in_smp;

DEFINE_PER_CPU(struct cpu_idletime, cpu_idletime);
       
io_schedule()
{
        int prev_cpu;
	
        preempt_disable();
        prev_cpu_idletime = __this_cpu_ptr(&cpu_idletime);
        atomic_inc(prev_cpu_idletime->nr_iowait);
        WARN_ON_ONCE(is_idle_task(current));
        preempt_enable_no_resched();

        schedule();

        write_seqlock(prev_cpu_idletime->seqlock)
	if (!atomic_dec_return(prev_cpu_idletime->nr_iowait))
           flush_cpu_idle_time(prev_cpu_idletime, 1)
        write_sequnlock(prev_cpu_idletime->seqlock)

}

flush_cpu_idle_time(cpu_idletime, iowait)
{
       if (!cpu_idletime->idle_start)
            return;

       if (nr_iowait)
            cpu_idletime->iowait_time = NOW() - cpu_idletime->idle_start;
       else
            cpu_idletime->idle_time = NOW() - cpu_idletime->idle_start;
}

idle_entry()
{
        write_seqlock(this_cpu_idletime->seqlock)
        this_cpu_idletime->idle_start = NOW();
        write_sequnlock(iowait(cpu)->seqlock)
}

idle_exit()
{
        write_seqlock(this_cpu_idletime->seqlock)
        flush_cpu_idle_time(this_cpu_idletime, atomic_read(&this_cpu_idletime->nr_iowait));
	this_cpu_idletime->idle_start = 0;
        write_sequnlock(this_cpu_idletime->seqlock)
}


Now this all realy on the fact that atomic_inc(cpu_idletime->nr_iowait) can't happen
in a CPU that is already idle. So it can't happen between idle_entry() and idle_exit().
Hence the WARN_ON(is_idle_task(current)) below after the inc.

Hmm?
