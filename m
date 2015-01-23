Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbbAWXjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:39:25 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:52898 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbAWXjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:39:23 -0500
Message-ID: <1422056361.2436.31.camel@j-VirtualBox>
Subject: Re: [RFC PATCH] sched, timer: Use atomics for thread_group_cputimer
 stats
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org,
        jason.low2@hp.com
Date: Fri, 23 Jan 2015 15:39:21 -0800
In-Reply-To: <20150123200828.GE23123@twins.programming.kicks-ass.net>
References: <1421983913.4432.22.camel@j-VirtualBox>
	 <20150123092508.GJ2896@worktop.programming.kicks-ass.net>
	 <1422041016.2436.19.camel@j-VirtualBox>
	 <20150123200828.GE23123@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-23 at 21:08 +0100, Peter Zijlstra wrote:
> On Fri, Jan 23, 2015 at 11:23:36AM -0800, Jason Low wrote:
> > On Fri, 2015-01-23 at 10:25 +0100, Peter Zijlstra wrote:
> > > On Thu, Jan 22, 2015 at 07:31:53PM -0800, Jason Low wrote:
> > > > +static void update_gt_cputime(struct thread_group_cputimer *a, struct task_cputime *b)
> > > >  {
> > > > +	if (b->utime > atomic64_read(&a->utime))
> > > > +		atomic64_set(&a->utime, b->utime);
> > > >  
> > > > +	if (b->stime > atomic64_read(&a->stime))
> > > > +		atomic64_set(&a->stime, b->stime);
> > > >  
> > > > +	if (b->sum_exec_runtime > atomic64_read(&a->sum_exec_runtime))
> > > > +		atomic64_set(&a->sum_exec_runtime, b->sum_exec_runtime);
> > > >  }
> > > 
> > > See something like this is not safe against concurrent adds.
> > 
> > How about something like:
> > 
> > u64 a_utime, a_stime, a_sum_exec_runtime;
> > 
> > retry_utime:
> > 	a_utime = atomic64_read(&a->utime);
> > 	if (b->utime > a_utime) {
> > 		if (atomic64_cmpxchg(&a->utime, a_utime, b->utime) != a_utime)
> > 			goto retry_utime;
> > 	}
> > 
> > retry_stime:
> > 	a_stime = atomic64_read(&a->stime);
> > 	if (b->stime > a_stime) {
> > 		if (atomic64_cmpxchg(&a->stime, a_stime, b->stime) != a_stime)
> > 			goto retry_stime;
> > 	}
> > 
> > retry_sum_exec_runtime:
> > 	a_sum_exec_runtime = atomic64_read(&a->sum_exec_runtime);
> > 	if (b->sum_exec_runtime > a_sum_exec_runtime) {
> > 		if (atomic64_cmpxchg(&a->sum_exec_runtime, a_sum_exec_runtime,
> > 				     b->sum_exec_runtime) != a_sum_exec_runtime)
> > 			goto retry_sum_exec_runtime;
> > 	}
> 
> Disgusting, at least use an inline or macro to avoid repeating it :-)
> 
> Also, does anyone care about performance on 32bit systems? There's a few
> where atomic64 is abysmal.

Yeah, though we're also avoiding spin lock/unlock calls each time, so
not sure if we're really adding anything of significance to the "overall
cost" on 32 bit systems. And update_gt_cputime wouldn't get called too
frequently.

