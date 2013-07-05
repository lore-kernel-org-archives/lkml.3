Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3GEAuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 20:50:13 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33666 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3GEAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 20:50:11 -0400
MIME-Version: 1.0
In-Reply-To: <1372951039-10375-3-git-send-email-k.krivyakin@samsung.com>
References: <1372951039-10375-1-git-send-email-k.krivyakin@samsung.com>
	<1372951039-10375-3-git-send-email-k.krivyakin@samsung.com>
Date: Fri, 5 Jul 2013 09:50:10 +0900
X-Google-Sender-Auth: _-im-CH6cr4KnvcofQNKjNdh_Uc
Message-ID: <CAH9JG2W46TnZW-7i-WhobGyFYhL_hOuusVcsOJ_T3EcGfYcpqw@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] Add power consumption counter in task_struct.
From: Kyungmin Park <kmpark@infradead.org>
To: Konstantin Krivyakin <k.krivyakin@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, viresh.kumar@linaro.org,
        mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>
Cc: i.zhbanov@samsung.com, e.voevodin@samsung.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ scheduler maintainers

On Fri, Jul 5, 2013 at 12:17 AM, Konstantin Krivyakin
<k.krivyakin@samsung.com> wrote:
> Signed-off-by: Konstantin Krivyakin <k.krivyakin@samsung.com>
> ---
>  include/linux/sched.h          |    2 ++
>  include/uapi/linux/taskstats.h |    2 ++
>  kernel/fork.c                  |    1 +
>  kernel/sched/core.c            |    8 ++++++++
>  kernel/sched/cputime.c         |   11 +++++++++++
>  kernel/tsacct.c                |    3 +++
>  6 files changed, 27 insertions(+)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index cdd5407..f074718 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1157,6 +1157,8 @@ struct task_struct {
>         int __user *clear_child_tid;            /* CLONE_CHILD_CLEARTID */
>
>         cputime_t utime, stime, utimescaled, stimescaled;
> +       u64 utime_power_cons;
> +       u64 stime_power_cons;
>         cputime_t gtime;
>  #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>         struct cputime prev_cputime;
> diff --git a/include/uapi/linux/taskstats.h b/include/uapi/linux/taskstats.h
> index 2466e55..02ac708 100644
> --- a/include/uapi/linux/taskstats.h
> +++ b/include/uapi/linux/taskstats.h
> @@ -116,6 +116,8 @@ struct taskstats {
>                                         /* Elapsed time [usec] */
>         __u64   ac_utime;               /* User CPU time [usec] */
>         __u64   ac_stime;               /* SYstem CPU time [usec] */
> +       __u64   ac_utime_power_cons;    /* User CPU time power consumption */
> +       __u64   ac_stime_power_cons;    /* System CPU time power consumption */
>         __u64   ac_minflt;              /* Minor Page Fault Count */
>         __u64   ac_majflt;              /* Major Page Fault Count */
>         /* Basic Accounting Fields end */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 6e6a1c1..a021d5b 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1240,6 +1240,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>
>         p->utime = p->stime = p->gtime = 0;
>         p->utimescaled = p->stimescaled = 0;
> +       p->utime_power_cons = p->stime_power_cons = 0;
>  #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
>         p->prev_cputime.utime = p->prev_cputime.stime = 0;
>  #endif
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9b1f2e5..cac73d7 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -73,6 +73,7 @@
>  #include <linux/init_task.h>
>  #include <linux/binfmts.h>
>  #include <linux/context_tracking.h>
> +#include <linux/cpufreq.h>
>
>  #include <asm/switch_to.h>
>  #include <asm/tlb.h>
> @@ -297,6 +298,13 @@ __read_mostly int scheduler_running;
>  int sysctl_sched_rt_runtime = 950000;
>
>
> +static u64 cpu_power_cons(cputime_t cputime)
> +{
> +       struct thread_info *ti = current_thread_info();
> +
> +       return cpu_power_get(ti->cpu) * cputime;
> +}
> +
>
>  /*
>   * __task_rq_lock - lock the rq @p resides on.
> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index a7959e0..512727d 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -4,6 +4,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/static_key.h>
>  #include <linux/context_tracking.h>
> +#include <linux/cpufreq.h>
>  #include "sched.h"
>
>
> @@ -126,6 +127,13 @@ static inline void task_group_account_field(struct task_struct *p, int index,
>         cpuacct_account_field(p, index, tmp);
>  }
>
> +static u64 cpu_power_cons(cputime_t cputime)
> +{
> +       struct thread_info *ti = current_thread_info();
> +
> +       return cpu_power_get(ti->cpu) * cputime;
> +}
> +
>  /*
>   * Account user cpu time to a process.
>   * @p: the process that the cpu time gets accounted to
> @@ -138,6 +146,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
>         int index;
>
>         /* Add user time to process. */
> +       p->utime_power_cons += cpu_power_cons(cputime);
>         p->utime += cputime;
>         p->utimescaled += cputime_scaled;
>         account_group_user_time(p, cputime);
> @@ -163,6 +172,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
>         u64 *cpustat = kcpustat_this_cpu->cpustat;
>
>         /* Add guest time to process. */
> +       p->utime_power_cons += cpu_power_cons(cputime);
>         p->utime += cputime;
>         p->utimescaled += cputime_scaled;
>         account_group_user_time(p, cputime);
> @@ -190,6 +200,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
>                         cputime_t cputime_scaled, int index)
>  {
>         /* Add system time to process. */
> +       p->stime_power_cons += cpu_power_cons(cputime);
>         p->stime += cputime;
>         p->stimescaled += cputime_scaled;
>         account_group_system_time(p, cputime);
> diff --git a/kernel/tsacct.c b/kernel/tsacct.c
> index a1dd9a1..cea4a9c 100644
> --- a/kernel/tsacct.c
> +++ b/kernel/tsacct.c
> @@ -75,6 +75,9 @@ void bacct_add_tsk(struct user_namespace *user_ns,
>         stats->ac_utimescaled = cputime_to_usecs(utimescaled);
>         stats->ac_stimescaled = cputime_to_usecs(stimescaled);
>
> +       stats->ac_utime_power_cons = tsk->utime_power_cons;
> +       stats->ac_stime_power_cons = tsk->stime_power_cons;
> +
>         stats->ac_minflt = tsk->min_flt;
>         stats->ac_majflt = tsk->maj_flt;
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
