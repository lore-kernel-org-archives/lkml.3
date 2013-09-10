Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3IJP0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:26:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49870 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3IJPZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:25:59 -0400
Date: Tue, 10 Sep 2013 17:25:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 6/7] sched, x86: Provide a per-cpu preempt_count
 implementation
Message-ID: <20130910152549.GH31370@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910132011.396291123@infradead.org>
 <1378821771.26319.82.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378821771.26319.82.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 07:02:51AM -0700, Eric Dumazet wrote:
> On Tue, 2013-09-10 at 15:08 +0200, Peter Zijlstra wrote:
> 
> > +static __always_inline int preempt_count(void)
> > +{
> > +	return __this_cpu_read_4(__preempt_count) & ~PREEMPT_NEED_RESCHED;
> > +}
> 
> Not sure why you used the _4 prefix on all accessors ?

Last time I tried using the proper this_cpu* stuff that all exploded in
my face due to header recursion hell, so I've limited myself to what's
available in arch/x86/include/asm/percpu.h.

It was a few weeks ago though and maybe I just didn't try hard enough.

> > +#ifdef CONFIG_PREEMPT_COUNT
> > +	/*
> > +	 * If it were not for PREEMPT_ACTIVE we could guarantee that the
> > +	 * preempt_count of all tasks was equal here and this would not be
> > +	 * needed.
> > +	 */
> > +	task_thread_info(prev_p)->saved_preempt_count = __raw_get_cpu_var(__preempt_count);
> 
> 	this_cpu_read(__preempt_count) ?
> 
> > +	__raw_get_cpu_var(__preempt_count) = task_thread_info(next_p)->saved_preempt_count;
> 
> 	this_cpu_write(__preempt_count,
>                        task_thread_info(next_p)->saved_preempt_count;

OK, that does indeed generate slightly better code.
