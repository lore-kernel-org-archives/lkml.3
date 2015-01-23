Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbbAWUIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:08:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:48947 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbbAWUIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:08:32 -0500
Date: Fri, 23 Jan 2015 21:08:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched, timer: Use atomics for thread_group_cputimer
 stats
Message-ID: <20150123200828.GE23123@twins.programming.kicks-ass.net>
References: <1421983913.4432.22.camel@j-VirtualBox>
 <20150123092508.GJ2896@worktop.programming.kicks-ass.net>
 <1422041016.2436.19.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422041016.2436.19.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 11:23:36AM -0800, Jason Low wrote:
> On Fri, 2015-01-23 at 10:25 +0100, Peter Zijlstra wrote:
> > On Thu, Jan 22, 2015 at 07:31:53PM -0800, Jason Low wrote:
> > > +static void update_gt_cputime(struct thread_group_cputimer *a, struct task_cputime *b)
> > >  {
> > > +	if (b->utime > atomic64_read(&a->utime))
> > > +		atomic64_set(&a->utime, b->utime);
> > >  
> > > +	if (b->stime > atomic64_read(&a->stime))
> > > +		atomic64_set(&a->stime, b->stime);
> > >  
> > > +	if (b->sum_exec_runtime > atomic64_read(&a->sum_exec_runtime))
> > > +		atomic64_set(&a->sum_exec_runtime, b->sum_exec_runtime);
> > >  }
> > 
> > See something like this is not safe against concurrent adds.
> 
> How about something like:
> 
> u64 a_utime, a_stime, a_sum_exec_runtime;
> 
> retry_utime:
> 	a_utime = atomic64_read(&a->utime);
> 	if (b->utime > a_utime) {
> 		if (atomic64_cmpxchg(&a->utime, a_utime, b->utime) != a_utime)
> 			goto retry_utime;
> 	}
> 
> retry_stime:
> 	a_stime = atomic64_read(&a->stime);
> 	if (b->stime > a_stime) {
> 		if (atomic64_cmpxchg(&a->stime, a_stime, b->stime) != a_stime)
> 			goto retry_stime;
> 	}
> 
> retry_sum_exec_runtime:
> 	a_sum_exec_runtime = atomic64_read(&a->sum_exec_runtime);
> 	if (b->sum_exec_runtime > a_sum_exec_runtime) {
> 		if (atomic64_cmpxchg(&a->sum_exec_runtime, a_sum_exec_runtime,
> 				     b->sum_exec_runtime) != a_sum_exec_runtime)
> 			goto retry_sum_exec_runtime;
> 	}

Disgusting, at least use an inline or macro to avoid repeating it :-)

Also, does anyone care about performance on 32bit systems? There's a few
where atomic64 is abysmal.
