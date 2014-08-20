Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaHTMyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:54:35 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:36347 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaHTMyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:54:33 -0400
Date: Wed, 20 Aug 2014 14:54:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v5 0/5] sched: Add on_rq states and remove several double
 rq locks
Message-ID: <20140820125428.GA6667@gmail.com>
References: <1408528040.23412.86.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408528040.23412.86.camel@tkhai>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kirill Tkhai <ktkhai@parallels.com> wrote:

> v5: New names: TASK_ON_RQ_QUEUED, TASK_ON_RQ_MIGRATING, task_on_rq_migrating()
> and task_on_rq_queued().
> 
>     I've pulled the latest version from peterz/queue.git, and Peter's changes
>     are included.
> 
> This series aims to get rid of some places where locks of two RQs are held
> at the same time.
> 
> Patch [1/5] is a preparation/cleanup. It replaces old (task_struct::on_rq == 1)
> with new (task_struct::on_rq == TASK_ON_RQ_QUEUED) everywhere. No functional changes.
> 
> Patch [2/5] is main in the series. It introduces new TASK_ON_RQ_MIGRATING state and
> teaches scheduler to understand it (we need little changes in try_to_wake_up()
> and task_rq_lock() family). This will be used in the following way:
> 
>         (we are changing task's rq)
> 
>         raw_spin_lock(&src_rq->lock);
> 
>         p = ...; /* Some src_rq task */
> 
>         dequeue_task(src_rq, p, 0);
>         p->on_rq = TASK_ON_RQ_MIGRATING;
>         set_task_cpu(p, dst_cpu);
>         raw_spin_unlock(&src_rq->lock);
> 
>         /*
>          * Now p is dequeued, and both
>          * RQ locks are unlocked, but
>          * its on_rq is not zero.
>          * Nobody can manipulate p
>          * while it's migrating,
>          * even when spinlocks are
>          * unlocked.
>          */
> 
>         raw_spin_lock(&dst_rq->lock);
>         p->on_rq = TASK_ON_RQ_QUEUED;
>         enqueue_task(dst_rq, p, 0);
>         raw_spin_unlock(&dst_rq->lock);
> 
> Patches [3,4,5/5] remove double locks and use new TASK_ON_RQ_MIGRATING state.
> They allow unlocked using of 3-4 function, which looks safe for me.
> 
> The profit is that double_rq_lock() is not need in several places. We reduce
> the total time when RQs are locked.
> 
> ---
> 
> Kirill Tkhai (5):
>       sched: Wrapper for checking task_struct::on_rq
>       sched: Teach scheduler to understand TASK_ON_RQ_MIGRATING state
>       sched: Remove double_rq_lock() from __migrate_task()
>       sched/fair: Remove double_lock_balance() from active_load_balance_cpu_stop()
>       sched/fair: Remove double_lock_balance() from load_balance()
> 
> 
>  kernel/sched/core.c      |  113 +++++++++++++++------------
>  kernel/sched/deadline.c  |   15 ++--
>  kernel/sched/fair.c      |  195 ++++++++++++++++++++++++++++++++--------------
>  kernel/sched/rt.c        |   16 ++--
>  kernel/sched/sched.h     |   13 +++
>  kernel/sched/stop_task.c |    2 
>  6 files changed, 228 insertions(+), 126 deletions(-)
> 
> --
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>

Ok, looks good. I picked up this version, with a few minor 
tweaks and fixes to the changelogs.

Thanks,

	Ingo
