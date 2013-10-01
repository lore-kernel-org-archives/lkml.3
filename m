Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3JAPVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:21:25 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45439 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3JAPVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:21:17 -0400
Date: Tue, 1 Oct 2013 17:21:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20131001152112.GF24825@localhost.localdomain>
References: <20130820163312.GA17957@redhat.com>
 <20130820175429.GI3258@twins.programming.kicks-ass.net>
 <20130820182553.GB22287@redhat.com>
 <20130821083130.GM3258@twins.programming.kicks-ass.net>
 <20130821113551.GA1472@redhat.com>
 <20130821123311.GA31370@twins.programming.kicks-ass.net>
 <20130821142356.GC31370@twins.programming.kicks-ass.net>
 <20130821164146.GA15194@redhat.com>
 <20131001140525.GE24825@localhost.localdomain>
 <20131001150037.GQ3657@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001150037.GQ3657@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 05:00:37PM +0200, Peter Zijlstra wrote:
> On Tue, Oct 01, 2013 at 04:05:27PM +0200, Frederic Weisbecker wrote:
>  
> > struct cpu_idletime {
> >        nr_iowait,
> >        seqlock,
> >        idle_start,
> >        idle_time,
> >        iowait_time,
> > } __cacheline_aligned_in_smp;
> > 
> > DEFINE_PER_CPU(struct cpu_idletime, cpu_idletime);
> >        
> > io_schedule()
> > {
> >         int prev_cpu;
> > 	
> >         preempt_disable();
> >         prev_cpu_idletime = __this_cpu_ptr(&cpu_idletime);
> >         atomic_inc(prev_cpu_idletime->nr_iowait);
> >         WARN_ON_ONCE(is_idle_task(current));
> >         preempt_enable_no_resched();
> > 
> >         schedule();
> > 
> >         write_seqlock(prev_cpu_idletime->seqlock)
> > 	if (!atomic_dec_return(prev_cpu_idletime->nr_iowait))
> >            flush_cpu_idle_time(prev_cpu_idletime, 1)
> >         write_sequnlock(prev_cpu_idletime->seqlock)
> > 
> > }
> 
> This is at least 3 atomic ops and a whole bunch of branches extra. It
> used to be 2 atomics and no branches.

Yeah. If somebody has a better proposition, I'm all for it.
Of course the best would be to remove these stats if we can. I think we
already concluded that the idea of per CPU iowait stats is broken since
sleeping tasks aren't assigned a particular CPU.

> 
> What again are we solving any why?

Fernando summerized it better than I could
	 * https://lkml.org/lkml/2013/3/18/962
	 * and http://marc.info/?l=linux-kernel&m=137273800916899&w=2
