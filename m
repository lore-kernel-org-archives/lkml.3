Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaHOQjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaHOQjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:39:21 -0400
Date: Fri, 15 Aug 2014 18:36:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
	seqlock
Message-ID: <20140815163651.GA19331@redhat.com>
References: <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814132239.GA24465@redhat.com> <20140814174849.GA5091@redhat.com> <1408079971.5536.37.camel@marge.simpson.net> <20140815062819.GY19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815062819.GY19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, Peter Zijlstra wrote:
>
> Also; why do we care about PROCESS_CPUTIME? People should really not use
> it. What are the 'valid' usecases you guys care about?

I do not really know. IIUC, the problematic usecase is sys_times().

I agree with Mike, "don't do this if you have a lot of threads". But
perhaps the kernel can help to applications which already abuse times().

However, if we only want to make sys_times() more scalable(), then
perhaps the "lockless" version of thread_group_cputime() makes more
sense. And given that do_sys_times() uses current we can simplify it;
is_dead is not possible and we do not need to take ->siglock twice:

	void current_group_cputime(struct task_cputime *times)
	{
		struct task_struct *tsk = current, *t;
		struct spinlock_t *siglock = &tsk->sighand->siglock;
		struct signal_struct *sig = tsk->signal;
		bool lockless = true;
		u64 exec;

	 retry:
		spin_lock_irq(siglock);
		times->utime = sig->utime;
		times->stime = sig->stime;
		times->sum_exec_runtime = exec = sig->sum_sched_runtime;

		if (lockless)
			spin_unlock_irq(siglock);

		rcu_read_lock();
		for_each_thread(tsk, t) {
			cputime_t utime, stime;
			task_cputime(t, &utime, &stime);
			times->utime += utime;
			times->stime += stime;
			times->sum_exec_runtime += task_sched_runtime(t);
		}
		rcu_read_unlock();

		if (lockless) {
			lockless = false;
			spin_unlock_wait(siglock);
			smp_rmb();
			if (exec != sig->sum_sched_runtime)
				goto retry;
		} else {
			spin_unlock_irq(siglock);
		}
	}

Oleg.

