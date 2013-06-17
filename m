Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab3FQLvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:51:43 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:60980 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab3FQLvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:51:41 -0400
MIME-Version: 1.0
In-Reply-To: <1370589652-24549-5-git-send-email-alex.shi@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-5-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 04:51:09 -0700
Message-ID: <CAPM31RLB6nN+qN8UNq0RXiRYKaFZ6GYVP-=kZMR8-rkP9831Bw@mail.gmail.com>
Subject: Re: [patch v8 4/9] sched: fix slept time double counting in enqueue entity
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
> The wakeuped migrated task will __synchronize_entity_decay(se); in
> migrate_task_fair, then it needs to set
> `se->avg.last_runnable_update -= (-se->avg.decay_count) << 20'
> before update_entity_load_avg, in order to avoid slept time is updated
> twice for se.avg.load_avg_contrib in both __syncchronize and
> update_entity_load_avg.
>
> but if the slept task is waked up from self cpu, it miss the
> last_runnable_update before update_entity_load_avg(se, 0, 1), then the
> slept time was used twice in both functions.
> So we need to remove the double slept time counting.

Good catch.

>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1fc30b9..42c7be0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1570,7 +1570,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>                 }
>                 wakeup = 0;
>         } else {
> -               __synchronize_entity_decay(se);
> +               se->avg.last_runnable_update += __synchronize_entity_decay(se)
> +                                                       << 20;

Can you add something like:

+               /*
+                * Task re-woke on same cpu (or else
migrate_task_rq_fair()
+                * would have made count negative); we must be careful
to avoid
+                * double-accounting blocked time after synchronizing
decays.
+                */


Reviewed-by: Paul Turner <pjt@google.com>
