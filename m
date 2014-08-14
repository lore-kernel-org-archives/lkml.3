Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaHNVmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:42:38 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:56243 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaHNVmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:42:37 -0400
MIME-Version: 1.0
In-Reply-To: <1407797345-28227-9-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140811224840.GA25594@linux.vnet.ibm.com> <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-9-git-send-email-paulmck@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 14 Aug 2014 17:42:06 -0400
Message-ID: <CAJhHMCDT1_Per3Qfx8qd23btnLmMVgPucL7OcUncUHWURGp6aQ@mail.gmail.com>
Subject: Re: [PATCH v5 tip/core/rcu 09/16] rcu: Improve RCU-tasks energy efficiency
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 6:48 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>
> The current RCU-tasks implementation uses strict polling to detect
> callback arrivals.  This works quite well, but is not so good for
> energy efficiency.  This commit therefore replaces the strict polling
> with a wait queue.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcu/update.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index f1535404a79e..1256a900cd01 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -368,6 +368,7 @@ early_initcall(check_cpu_stall_init);
>  /* Global list of callbacks and associated lock. */
>  static struct rcu_head *rcu_tasks_cbs_head;
>  static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
> +static DECLARE_WAIT_QUEUE_HEAD(rcu_tasks_cbs_wq);
>  static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
>
>  /* Track exiting tasks in order to allow them to be waited for. */
> @@ -381,13 +382,17 @@ module_param(rcu_task_stall_timeout, int, 0644);
>  void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
>  {
>         unsigned long flags;
> +       bool needwake;
>
>         rhp->next = NULL;
>         rhp->func = func;
>         raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
> +       needwake = !rcu_tasks_cbs_head;
>         *rcu_tasks_cbs_tail = rhp;
>         rcu_tasks_cbs_tail = &rhp->next;
>         raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
> +       if (needwake)
> +               wake_up(&rcu_tasks_cbs_wq);
>  }
>  EXPORT_SYMBOL_GPL(call_rcu_tasks);

I think you want

needwake = !!rcu_tasks_cbs_head;

otherwise it will wake up when rcu_tasks_cbs_head is null, no?

>
> @@ -498,8 +503,12 @@ static int __noreturn rcu_tasks_kthread(void *arg)
>
>                 /* If there were none, wait a bit and start over. */
>                 if (!list) {
> -                       schedule_timeout_interruptible(HZ);
> -                       WARN_ON(signal_pending(current));
> +                       wait_event_interruptible(rcu_tasks_cbs_wq,
> +                                                rcu_tasks_cbs_head);
> +                       if (!rcu_tasks_cbs_head) {
> +                               WARN_ON(signal_pending(current));
> +                               schedule_timeout_interruptible(HZ/10);
> +                       }
>                         continue;
>                 }
>
> @@ -605,6 +614,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
>                         list = next;
>                         cond_resched();
>                 }
> +               schedule_timeout_uninterruptible(HZ/10);
>         }
>  }
>
> --
> 1.8.1.5
>



-- 
Pranith
