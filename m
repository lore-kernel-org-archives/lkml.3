Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaHOFTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 01:19:38 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:51871 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaHOFTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 01:19:36 -0400
Message-ID: <1408079971.5536.37.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
 seqlock
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Date: Fri, 15 Aug 2014 07:19:31 +0200
In-Reply-To: <20140814174849.GA5091@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com>
	 <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com>
	 <20140813172230.GA6296@redhat.com>
	 <20140813133526.1eb5526f@cuia.bos.redhat.com>
	 <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com>
	 <20140813184511.GA9663@redhat.com>
	 <20140813170324.544aaf2d@cuia.bos.redhat.com>
	 <20140814132239.GA24465@redhat.com> <20140814174849.GA5091@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-14 at 19:48 +0200, Oleg Nesterov wrote: 
> On 08/14, Oleg Nesterov wrote:
> >
> > OK, lets forget about alternative approach for now. We can reconsider
> > it later. At least I have to admit that seqlock is more straighforward.
> 
> Yes.
> 
> But just for record, the "lockless" version doesn't look that bad to me,
> 
> 	void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> 	{
> 		struct signal_struct *sig = tsk->signal;
> 		bool lockless, is_dead;
> 		struct task_struct *t;
> 		unsigned long flags;
> 		u64 exec;
> 
> 		lockless = true;
> 		is_dead = !lock_task_sighand(p, &flags);
> 	 retry:
> 		times->utime = sig->utime;
> 		times->stime = sig->stime;
> 		times->sum_exec_runtime = exec = sig->sum_sched_runtime;
> 		if (is_dead)
> 			return;
> 
> 		if (lockless)
> 			unlock_task_sighand(p, &flags);
> 
> 		rcu_read_lock();
> 		for_each_thread(tsk, t) {
> 			cputime_t utime, stime;
> 			task_cputime(t, &utime, &stime);
> 			times->utime += utime;
> 			times->stime += stime;
> 			times->sum_exec_runtime += task_sched_runtime(t);
> 		}
> 		rcu_read_unlock();
> 
> 		if (lockless) {
> 			lockless = false;
> 			is_dead = !lock_task_sighand(p, &flags);
> 			if (is_dead || exec != sig->sum_sched_runtime)
> 				goto retry;
> 		}
> 		unlock_task_sighand(p, &flags);
> 	}
> 
> The obvious problem is that we should shift lock_task_sighand() from the
> callers to thread_group_cputime() first, or add thread_group_cputime_lockless()
> and change the current users one by one.
> 
> And of course, stats_lock is more generic.

Yours looks nice to me, particularly in that it doesn't munge structure
layout, could perhaps be backported to fix up production kernels.

For the N threads doing this on N cores case, seems rq->lock hammering
will still be a source of major box wide pain.  Is there any correctness
reason to add up unaccounted ->on_cpu beans, or is that just value
added?  Seems to me it can't matter, as you traverse, what you added up
on previous threads becomes ever more stale as you proceed, so big boxen
would be better off not doing that.

-Mike

