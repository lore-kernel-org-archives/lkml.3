Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3K3OGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 09:06:40 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58933 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3K3OGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 09:06:37 -0500
Date: Sat, 30 Nov 2013 15:06:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/14] sched: add extended scheduling interface. (new ABI)
Message-ID: <20131130140633.GB19027@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
 <1383831828-15501-3-git-send-email-juri.lelli@gmail.com>
 <20131127132354.GA18422@gmail.com>
 <20131127133027.GE10022@twins.programming.kicks-ass.net>
 <20131127140143.GB24403@gmail.com>
 <20131127141334.GA13532@twins.programming.kicks-ass.net>
 <20131127141721.GA24979@gmail.com>
 <5297257B.7090200@gmail.com>
 <20131128112858.GK10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128112858.GK10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Nov 28, 2013 at 12:14:03PM +0100, Juri Lelli wrote:
> > +SYSCALL_DEFINE2(sched_getattr, pid_t, pid, struct sched_attr __user *, attr)
> >  {
> > -	struct sched_param2 lp;
> > +	struct sched_attr lp;
> >  	struct task_struct *p;
> >  	int retval;
> >  
> > -	if (!param2 || pid < 0)
> > +	if (!attr || pid < 0)
> >  		return -EINVAL;
> >  
> > +	memset(&lp, 0, sizeof(struct sched_attr));
> > +
> >  	rcu_read_lock();
> >  	p = find_process_by_pid(pid);
> >  	retval = -ESRCH;
> > @@ -3427,7 +3495,7 @@ SYSCALL_DEFINE2(sched_getparam2, pid_t, pid, struct sched_param2 __user *, param
> >  	lp.sched_priority = p->rt_priority;
> >  	rcu_read_unlock();
> >  
> > -	retval = copy_to_user(param2, &lp, sizeof(lp)) ? -EFAULT : 0;
> > +	retval = copy_to_user(attr, &lp, sizeof(lp)) ? -EFAULT : 0;
> >  	return retval;
> >  
> >  out_unlock:
> 
> 
> So this side needs a bit more care; suppose the kernel has a larger attr
> than userspace knows about.
> 
> What would make more sense; add another syscall argument with the
> userspace sizeof(struct sched_attr), or expect userspace to initialize
> attr->size to the right value before calling sched_getattr() ?
> 
> To me the extra argument makes more sense; that is:
> 
>   struct sched_attr attr;
> 
>   ret = sched_getattr(0, &attr, sizeof(attr));
> 
> seems like a saner thing than:
> 
>   struct sched_attr attr = { .size = sizeof(attr), };
> 
>   ret = sched_getattr(0, &attr);
> 
> Mostly because the former has a clear separation between input and 
> output arguments, whereas for the second form the attr argument is 
> both input and output.
> 
> Ingo?

I suppose so - in the sys_perf_event_open() case we ran out of 
arguments, so attr::size was the only sane way to do it.

[ Btw., perf events side note: for completeness and for debugging we 
  probably want to add a sys_perf_event_get() method as well, to 
  recover the attributes of an existing event. Unidirectional APIs are 
  not very nice. ]

Thanks,

	Ingo
