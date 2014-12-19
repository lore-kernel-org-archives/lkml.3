Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaLSUXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:23:40 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34821 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLSUXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:23:39 -0500
MIME-Version: 1.0
In-Reply-To: <tip-f6be8af1c95de4a46e325e728900a70ceadb52cf@git.kernel.org>
References: <1409815075-4180-1-git-send-email-chuansheng.liu@intel.com> <tip-f6be8af1c95de4a46e325e728900a70ceadb52cf@git.kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 19 Dec 2014 12:23:16 -0800
Message-ID: <CALCETrVSXQYpUpqa47WYjmPwEk7hv8mqguKw-Xyxe2QJeuc+yQ@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Add new API wake_up_if_idle() to wake up
 the idle cpu
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chuansheng Liu <chuansheng.liu@intel.com>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 4:43 AM, tip-bot for Chuansheng Liu
<tipbot@zytor.com> wrote:
> Commit-ID:  f6be8af1c95de4a46e325e728900a70ceadb52cf
> Gitweb:     http://git.kernel.org/tip/f6be8af1c95de4a46e325e728900a70ceadb52cf
> Author:     Chuansheng Liu <chuansheng.liu@intel.com>
> AuthorDate: Thu, 4 Sep 2014 15:17:53 +0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 19 Sep 2014 12:35:14 +0200
>
> sched: Add new API wake_up_if_idle() to wake up the idle cpu
>
> Implementing one new API wake_up_if_idle(), which is used to
> wake up the idle CPU.
>
> Suggested-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: daniel.lezcano@linaro.org
> Cc: rjw@rjwysocki.net
> Cc: linux-pm@vger.kernel.org
> Cc: changcheng.liu@intel.com
> Cc: xiaoming.wang@intel.com
> Cc: souvik.k.chakravarty@intel.com
> Cc: chuansheng.liu@intel.com
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Link: http://lkml.kernel.org/r/1409815075-4180-1-git-send-email-chuansheng.liu@intel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  include/linux/sched.h |  1 +
>  kernel/sched/core.c   | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index dd9eb48..82ff3d6 100644
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
> index 78e5c83..f7c6ed2 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1634,6 +1634,25 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
>         }
>  }
>
> +void wake_up_if_idle(int cpu)
> +{
> +       struct rq *rq = cpu_rq(cpu);
> +       unsigned long flags;
> +
> +       if (!is_idle_task(rq->curr))

This is old news, but why isn't this if (rq->curr != rq->idle)?

--Andy

> +               return;
> +
> +       if (set_nr_if_polling(rq->idle)) {
> +               trace_sched_wake_idle_without_ipi(cpu);
> +       } else {
> +               raw_spin_lock_irqsave(&rq->lock, flags);
> +               if (is_idle_task(rq->curr))
> +                       smp_send_reschedule(cpu);
> +               /* Else cpu is not in idle, do nothing here */
> +               raw_spin_unlock_irqrestore(&rq->lock, flags);
> +       }
> +}
> +
>  bool cpus_share_cache(int this_cpu, int that_cpu)
>  {
>         return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
