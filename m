Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3JAP4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:56:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53217 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3JAP4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:56:45 -0400
Date: Tue, 1 Oct 2013 17:56:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20131001155633.GR3657@laptop.programming.kicks-ass.net>
References: <20130820160146.GG3258@twins.programming.kicks-ass.net>
 <20130820163312.GA17957@redhat.com>
 <20130820175429.GI3258@twins.programming.kicks-ass.net>
 <20130820182553.GB22287@redhat.com>
 <20130821083130.GM3258@twins.programming.kicks-ass.net>
 <20130821113551.GA1472@redhat.com>
 <20130821123311.GA31370@twins.programming.kicks-ass.net>
 <20130821142356.GC31370@twins.programming.kicks-ass.net>
 <20130821164146.GA15194@redhat.com>
 <20131001140525.GE24825@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001140525.GE24825@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So what's wrong with something like:

struct cpu_idletime {
       seqlock_t seqlock;
       unsigned long nr_iowait;
       u64 start;
       u64 idle_time,
       u64 iowait_time,
} __cacheline_aligned_in_smp;

DEFINE_PER_CPU(struct cpu_idletime, cpu_idletime);

void io_schedule(void)
{
	struct cpu_idletime *it = __raw_get_cpu_var(cpu_idletime);

	write_seqlock(&it->seqlock);
	if (!it->nr_iowait++)
		it->start = local_clock();
	write_sequnlock(&it->seqlock);

	current->in_iowait = 1;
	schedule();
	current->in_iowait = 0;

	write_seqlock(&it->seqlock);
	if (!--it->nr_iowait)
		it->iowait_time += local_clock() - it->start;
	write_sequnlock(&it->seqlock);
}

Afaict you don't need the preempt disable and atomic muck at all.

It will all get a little more complicated to deal with overlapping idle
and iowait times, but the idea is the same.
