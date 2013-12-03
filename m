Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3LCTZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:25:07 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:37746 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3LCTZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:25:03 -0500
MIME-Version: 1.0
In-Reply-To: <20131202152437.GA10896@redhat.com>
References: <20131202152423.GA10878@redhat.com> <20131202152437.GA10896@redhat.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Tue, 3 Dec 2013 11:24:41 -0800
X-Google-Sender-Auth: k6b9HJtJmehPJ_g3Cf36yfq_9yY
Message-ID: <CANMivWY_DQOeiJzt-Rs9G7zgfOj5BefZriKs__nfYf3ZuiCdrA@mail.gmail.com>
Subject: Re: [PATCH 1/2] introduce for_each_thread() to replace the buggy while_each_thread()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 7:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> while_each_thread() and next_thread() should die, almost every
> lockless usage is wrong.
>
> 1. Unless g == current, the lockless while_each_thread() is not safe.
>
>    while_each_thread(g, t) can loop forever if g exits, next_thread()
>    can't reach the unhashed thread in this case. Note that this can
>    happen even if g is the group leader, it can exec.
>
> 2. Even if while_each_thread() itself was correct, people often use
>    it wrongly.
>
>    It was never safe to just take rcu_read_lock() and loop unless
>    you verify that pid_alive(g) == T, even the first next_thread()
>    can point to the already freed/reused memory.
>
> This patch adds signal_struct->thread_head and task->thread_node
> to create the normal rcu-safe list with the stable head. The new
> for_each_thread(g, t) helper is always safe under rcu_read_lock()
> as long as this task_struct can't go away.
>
> Note: of course it is ugly to have both task_struct->thread_node
> and the old task_struct->thread_group, we will kill it later, after
> we change the users of while_each_thread() to use for_each_thread().
>
> Perhaps we can kill it even before we convert all users, we can
> reimplement next_thread(t) using the new thread_head/thread_node.
> But we can't do this right now because this will lead to subtle
> behavioural changes. For example, do/while_each_thread() always
> sees at least one task, while for_each_thread() can do nothing if
> the whole thread group has died. Or thread_group_empty(), currently
> its semantics is not clear unless thread_group_leader(p) and we
> need to audit the callers before we can change it.
>
> So this patch adds the new interface which has to coexist with the
> old one for some time, hopefully the next changes will be more or
> less straightforward and the old one will go away soon.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sameer Nanda <snanda@chromium.org>

> ---
>  include/linux/init_task.h |    2 ++
>  include/linux/sched.h     |   12 ++++++++++++
>  kernel/exit.c             |    1 +
>  kernel/fork.c             |    7 +++++++
>  4 files changed, 22 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index b0ed422..668aae0 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -40,6 +40,7 @@ extern struct fs_struct init_fs;
>
>  #define INIT_SIGNALS(sig) {                                            \
>         .nr_threads     = 1,                                            \
> +       .thread_head    = LIST_HEAD_INIT(init_task.thread_node),        \
>         .wait_chldexit  = __WAIT_QUEUE_HEAD_INITIALIZER(sig.wait_chldexit),\
>         .shared_pending = {                                             \
>                 .list = LIST_HEAD_INIT(sig.shared_pending.list),        \
> @@ -213,6 +214,7 @@ extern struct task_group root_task_group;
>                 [PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),            \
>         },                                                              \
>         .thread_group   = LIST_HEAD_INIT(tsk.thread_group),             \
> +       .thread_node    = LIST_HEAD_INIT(init_signals.thread_head),     \
>         INIT_IDS                                                        \
>         INIT_PERF_EVENTS(tsk)                                           \
>         INIT_TRACE_IRQFLAGS                                             \
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index dc48056..0550083 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -487,6 +487,7 @@ struct signal_struct {
>         atomic_t                sigcnt;
>         atomic_t                live;
>         int                     nr_threads;
> +       struct list_head        thread_head;
>
>         wait_queue_head_t       wait_chldexit;  /* for wait4() */
>
> @@ -1162,6 +1163,7 @@ struct task_struct {
>         /* PID/PID hash table linkage. */
>         struct pid_link pids[PIDTYPE_MAX];
>         struct list_head thread_group;
> +       struct list_head thread_node;
>
>         struct completion *vfork_done;          /* for vfork() */
>         int __user *set_child_tid;              /* CLONE_CHILD_SETTID */
> @@ -2225,6 +2227,16 @@ extern bool current_is_single_threaded(void);
>  #define while_each_thread(g, t) \
>         while ((t = next_thread(t)) != g)
>
> +#define __for_each_thread(signal, t)   \
> +       list_for_each_entry_rcu(t, &(signal)->thread_head, thread_node)
> +
> +#define for_each_thread(p, t)          \
> +       __for_each_thread((p)->signal, t)
> +
> +/* Careful: this is a double loop, 'break' won't work as expected. */
> +#define for_each_process_thread(p, t)  \
> +       for_each_process(p) for_each_thread(p, t)
> +
>  static inline int get_nr_threads(struct task_struct *tsk)
>  {
>         return tsk->signal->nr_threads;
> diff --git a/kernel/exit.c b/kernel/exit.c
> index a949819..1e77fc6 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -74,6 +74,7 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
>                 __this_cpu_dec(process_counts);
>         }
>         list_del_rcu(&p->thread_group);
> +       list_del_rcu(&p->thread_node);
>  }
>
>  /*
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 9be5154..b84bef7 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1034,6 +1034,11 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>         sig->nr_threads = 1;
>         atomic_set(&sig->live, 1);
>         atomic_set(&sig->sigcnt, 1);
> +
> +       /* list_add(thread_node, thread_head) without INIT_LIST_HEAD() */
> +       sig->thread_head = (struct list_head)LIST_HEAD_INIT(tsk->thread_node);
> +       tsk->thread_node = (struct list_head)LIST_HEAD_INIT(sig->thread_head);
> +
>         init_waitqueue_head(&sig->wait_chldexit);
>         sig->curr_target = tsk;
>         init_sigpending(&sig->shared_pending);
> @@ -1470,6 +1475,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>                         atomic_inc(&current->signal->sigcnt);
>                         list_add_tail_rcu(&p->thread_group,
>                                           &p->group_leader->thread_group);
> +                       list_add_tail_rcu(&p->thread_node,
> +                                         &p->signal->thread_head);
>                 }
>                 attach_pid(p, PIDTYPE_PID);
>                 nr_threads++;
> --
> 1.5.5.1
>



-- 
Sameer
