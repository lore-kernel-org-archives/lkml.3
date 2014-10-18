Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaJRIPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 04:15:14 -0400
Received: from forward5o.mail.yandex.net ([37.140.190.34]:44056 "EHLO
	forward5o.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaJRIPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 04:15:08 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <ktkhai@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
In-Reply-To: <20141017213641.GB32576@redhat.com>
References: <1413376300.24793.55.camel@tkhai> <20141017213641.GB32576@redhat.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
MIME-Version: 1.0
Message-Id: <4323181413620101@web21o.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 18 Oct 2014 12:15:01 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

18.10.2014, 01:40, "Oleg Nesterov" <oleg@redhat.com>:
> The lockless get_task_struct(tsk) is only safe if tsk == current
> and didn't pass exit_notify(), or if this tsk was found on a rcu
> protected list (say, for_each_process() or find_task_by_vpid()).
> IOW, it is only safe if release_task() was not called before we
> take rcu_read_lock(), in this case we can rely on the fact that
> delayed_put_pid() can not drop the (potentially) last reference
> until rcu_read_unlock().
>
> And as Kirill pointed out task_numa_compare()->task_numa_assign()
> path does get_task_struct(dst_rq->curr) and this is not safe. The
> task_struct itself can't go away, but rcu_read_lock() can't save
> us from the final put_task_struct() in finish_task_switch(); this
> reference goes away without rcu gp.
>
> Reported-by: Kirill Tkhai <ktkhai@parallels.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> škernel/sched/fair.c | ššš8 +++++++-
> š1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0090e8c..52049b9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1158,7 +1158,13 @@ static void task_numa_compare(struct task_numa_env *env,
>
> šššššššššrcu_read_lock();
> šššššššššcur = ACCESS_ONCE(dst_rq->curr);
> - if (cur->pid == 0) /* idle */
> + /*
> + * No need to move the exiting task, and this ensures that ->curr
> + * wasn't reaped and thus get_task_struct() in task_numa_assign()
> + * is safe; note that rcu_read_lock() can't protect from the final
> + * put_task_struct() after the last schedule().
> + */
> + if (is_idle_task(cur) || (cur->flags & PF_EXITING))
> šššššššššššššššššcur = NULL;
>
> ššššššššš/*

Oleg, I've looked once again, and now it's not good for me.
Where is the guarantee this memory hasn't been allocated again?
If so, PF_EXITING is not of the task we are interesting, but it's
not a task's even.

rcu_read_lock()                   ...                           ...
cur = ACCESS_ONCE(dst_rq->curr);  ...                           ...
<interrupt>                       rq->curr = next;              ...
<interrupt>                           put_prev_task()           ...
<interrupt>                               __put_prev_task       ...
<interrupt>                                  kmem_cache_free()  ...
<interrupt>                                  ...                <alocated again>
<interrupt>                                  ...                memset(, 0, )
<interrupt>                                  ...                ...
if (cur->flags & PF_EXITING)                 ...                ...
    <no>                                     ...                ...
get_task_struct()                            ...                ...

Kirill
