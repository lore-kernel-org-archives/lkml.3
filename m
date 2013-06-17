Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab3FQMVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:21:21 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:52347 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab3FQMVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:21:20 -0400
MIME-Version: 1.0
In-Reply-To: <1370589652-24549-10-git-send-email-alex.shi@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-10-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 05:20:46 -0700
Message-ID: <CAPM31RJ_0xgymfN+5FzQCSrv-qgpT+42EOmWke1rOGy7GfHcYg@mail.gmail.com>
Subject: Re: [patch v8 9/9] sched/tg: remove blocked_load_avg in balance
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
> blocked_load_avg sometime is too heavy and far bigger than runnable load
> avg, that make balance make wrong decision. So remove it.

Ok so this is  going to have terrible effects on the correctness of
shares distribution; I'm fairly opposed to it in its present form.

So let's see, what could be happening..

In  "sched: compute runnable load avg in cpu_load and
cpu_avg_load_per_task" you already update the load average weights
solely based on current runnable load.  While this is generally poor
for stability (and I suspect the benefit is coming largely from
weighted_cpuload() where you do want to use runnable_load_avg and not
get_rq_runnable_load() where I suspect including blocked_load_avg() is
correct in the longer term).

Ah so.. I have an inkling:
  Inside weighted_cpuload() where you're trying to use only
runnable_load_avg; this is in-fact still including blocked_load_avg
for a cgroup since in the cgroup case a group entities' contribution
is a function of both runnable and blocked load.

Having weighted_cpuload() pull rq->load (possibly moderated by
rq->avg) would reasonably avoid this since issued shares are
calculated using instantaneous weights, without breaking the actual
model for how much load overall that we believe the group has.

>
> Changlong tested this patch, found ltp cgroup stress testing get better
> performance: https://lkml.org/lkml/2013/5/23/65
> ---
> 3.10-rc1          patch1-7         patch1-8
> duration=764   duration=754   duration=750
> duration=764   duration=754   duration=751
> duration=763   duration=755   duration=751
>
> duration means the seconds of testing cost.
> ---
>
> And Jason also tested this patchset on his 8 sockets machine:
> https://lkml.org/lkml/2013/5/29/673
> ---
> When using a 3.10-rc2 tip kernel with patches 1-8, there was about a 40%
> improvement in performance of the workload compared to when using the
> vanilla 3.10-rc2 tip kernel with no patches. When using a 3.10-rc2 tip
> kernel with just patches 1-7, the performance improvement of the
> workload over the vanilla 3.10-rc2 tip kernel was about 25%.
> ---
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Tested-by: Changlong Xie <changlongx.xie@intel.com>
> Tested-by: Jason Low <jason.low2@hp.com>
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 3aa1dc0..985d47e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1358,7 +1358,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>         struct task_group *tg = cfs_rq->tg;
>         s64 tg_contrib;
>
> -       tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> +       tg_contrib = cfs_rq->runnable_load_avg;
>         tg_contrib -= cfs_rq->tg_load_contrib;
>
>         if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
> --
> 1.7.12
>
