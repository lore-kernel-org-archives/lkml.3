Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaHNSSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:18:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbaHNSSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:18:12 -0400
Date: Thu, 14 Aug 2014 20:15:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
	seqlock
Message-ID: <20140814181542.GB5091@redhat.com>
References: <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814142404.GA28211@redhat.com> <53ECD7C8.6040202@redhat.com> <20140814161247.GA32715@redhat.com> <53ECF390.40403@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ECF390.40403@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Rik van Riel wrote:
>
> On 08/14/2014 12:12 PM, Oleg Nesterov wrote:
> >
> > Or you can expand the scope of write_seqlock/write_sequnlock, so that
> > __unhash_process in called from inside the critical section. This looks
> > simpler at first glance.
>
> The problem with that is that wait_task_zombie() calls
> thread_group_cputime_adjusted() in that if() branch, and
> that code ends up taking the seqlock for read...

Not sure I understand... This modifies parent->signal->c* counters,
and obviously the exiting thread is not the member of parent's thread
group, so thread_group_cputime_adjusted(parent) can never account the
exiting child twice simply because it won't see it?

> However, in __exit_signal that approach should work.

Yes,

> > Hmm, wait, it seems there is yet another problem ;) Afaics, you also
> > need to modify __exit_signal() so that ->sum_sched_runtime/etc are
> > accounted unconditionally, even if the group leader exits.
> >
> > Probably this is not a big problem, and sys_times() or clock_gettime()
> > do not care at all because they use current.
> >
> > But without this change thread_group_cputime(reaped_zombie) won't look
> > at this task_struct at all, this can lead to non-monotonic result if
> > it was previously called when this task was alive (non-reaped).
>
> You mean this whole block needs to run regardless of whether
> the group is dead?
>
>                 task_cputime(tsk, &utime, &stime);
>                 write_seqlock(&sig->stats_lock);
>                 sig->utime += utime;
>                 sig->stime += stime;
>                 sig->gtime += task_gtime(tsk);
>                 sig->min_flt += tsk->min_flt;
>                 sig->maj_flt += tsk->maj_flt;
>                 sig->nvcsw += tsk->nvcsw;
>                 sig->nivcsw += tsk->nivcsw;
>                 sig->inblock += task_io_get_inblock(tsk);
>                 sig->oublock += task_io_get_oublock(tsk);
>                 task_io_accounting_add(&sig->ioac, &tsk->ioac);
>                 sig->sum_sched_runtime += tsk->se.sum_exec_runtime;

Yes.

> How does that square with wait_task_zombie reaping the
> statistics of the whole group with thread_group_cputime_adjusted()
> when the group leader is exiting?

Again, not sure I understand... thread_group_cputime_adjusted() in
wait_task_zombie() is fine in any case. Nobody but us can reap this
zombie.

It seems that we misunderstood each other, let me try again. Just to
simplify, suppose we have, say,

	sys_times_by_pid(pid, ...)
	{
		rcu_read_lock();
		task = find_task_by_vpid(pid);
		if (task)
			get_task_struct(task);
		rcu_read_unlock();

		if (!task)
			return -ESRCH;

		thread_group_cputime(task, ...);
		copy_to_user();
		return 0;
	}

Note that this task can exit right after rcu_read_unlock(), and it can
be also reaped (by its parent or by itself) and removed from the thread
list. In this case for_each_thread() will see no threads, and thus it
will only read task->signal->*time.

This means that sys_times_by_pid() can simply return the wrong result
instead of failure. Say, It can even return "all zeros" if this task was
single-threaded.

Oleg.

