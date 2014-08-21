Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaHUVWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:22:14 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:34581 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbaHUVWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com>
References: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 21 Aug 2014 14:21:51 -0700
Message-ID: <CALCETrWns2cPzS+goDmXjhVuxzD2OczxTF9UtARBFnw3hibjZg@mail.gmail.com>
Subject: Re: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
 idle cpu
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 18, 2014 3:52 AM, "Chuansheng Liu" <chuansheng.liu@intel.com> wrote:
>
> Implementing one new API wake_up_if_idle(), which is used to
> wake up the idle CPU.
>
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> ---
>  include/linux/sched.h |    1 +
>  kernel/sched/core.c   |   16 ++++++++++++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 857ba40..3f89ac1 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1024,6 +1024,7 @@ struct sched_domain_topology_level {
>  extern struct sched_domain_topology_level *sched_domain_topology;
>
>  extern void set_sched_topology(struct sched_domain_topology_level *tl);
> +extern void wake_up_if_idle(int cpu);
>
>  #ifdef CONFIG_SCHED_DEBUG
>  # define SD_INIT_NAME(type)            .name = #type
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1211575..adf104f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1620,6 +1620,22 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
>         }
>  }
>
> +void wake_up_if_idle(int cpu)
> +{
> +       struct rq *rq = cpu_rq(cpu);
> +       unsigned long flags;
> +
> +       if (set_nr_if_polling(rq->idle)) {
> +               trace_sched_wake_idle_without_ipi(cpu);
> +       } else {
> +

FWIW, adding:

if (rq->curr != rq->idle)
    return;

Right here could improve performance on large, mostly non-idle
systems.  It would skip the spinlock in most cases.

I don't know whether this code is relevant on systems like that, though.

 raw_spin_lock_irqsave(&rq->lock, flags);
> +               if (rq->curr == rq->idle)
> +                       smp_send_reschedule(cpu);
> +               /* Else cpu is not in idle, do nothing here */
> +               raw_spin_unlock_irqrestore(&rq->lock, flags);
> +       }
> +

--Andy
