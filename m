Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaHMRY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:24:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbaHMRYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:24:54 -0400
Date: Wed, 13 Aug 2014 19:22:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
Message-ID: <20140813172230.GA6296@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EA94DD.5040900@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12, Rik van Riel wrote:
>
> Any other ideas?

To simplify, lets suppose that we only need sum_exec_runtime.

Perhaps we can do something like this

	u64 thread_group_sched_runtime(void)
	{
		struct task_struct *tsk = current;
		spinlock_t *siglock = &tsk->sighand->siglock; /* stable */
		struct task_struct *t;
		u64 x1, x2;

	retry:
		x1 = tsk->signal->sum_sched_runtime;
		rmb();
		spin_unlock_wait(siglock);
		rmb();

		x2 = 0;
		rcu_read_lock();
		for_each_thread(tsk, t)
			x2 += task_sched_runtime(t);
		rcu_read_unlock();

		rmb();
		spin_unlock_wait(siglock);
		rmb();

		if (x1 != tsk->signal->sum_sched_runtime)
			goto retry;

		return x1 + x2;
	}

?

We do not care if for_each_thread() misses the new thread, we can pretend
thread_group_sched_runtime() was called before clone.

We do not care if a thread with sum_sched_runtime == 0 exits, obviously.

Otherwise "x1 != tsk->signal->sum_sched_runtime" should tell us that we
raced with __exit_signal().

Oleg.

