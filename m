Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717Ab3DIIuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:50:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47327
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383Ab3DIIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:50:14 -0400
Message-ID: <1365497406.2609.162.camel@laptop>
Subject: Re: [PATCH v4] sched: fix wrong rq's runnable_avg update with rt
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, pjt@google.com, rostedt@goodmis.org,
        fweisbec@gmail.com, efault@gmx.de
Date: Tue, 09 Apr 2013 10:50:06 +0200
In-Reply-To: <1365084959-28374-1-git-send-email-vincent.guittot@linaro.org>
References: <1365084959-28374-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 16:15 +0200, Vincent Guittot wrote:
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c      |   23 +++++++++++++++++++++--
>  kernel/sched/idle_task.c |   10 ++++++++++
>  kernel/sched/sched.h     |   12 ++++++++++++
>  3 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0fcdbff..1851ca8 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1562,6 +1562,27 @@ static inline void
> dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
>                 se->avg.decay_count =
> atomic64_read(&cfs_rq->decay_counter);
>         } /* migrations, e.g. sleep=0 leave decay_count == 0 */
>  }
> +
> +/*
> + * Update the rq's load with the elapsed running time before entering
> + * idle. if the last scheduled task is not a CFS task, idle_enter
> will
> + * be the only way to update the runnable statistic.
> + */
> +void idle_enter(struct rq *this_rq)
> +{
> +       update_rq_runnable_avg(this_rq, 1);
> +}
> +
> +/*
> + * Update the rq's load with the elapsed idle time before a task is
> + * scheduled. if the newly scheduled task is not a CFS task,
> idle_exit will
> + * be the only way to update the runnable statistic.
> + */
> +void idle_exit(struct rq *this_rq)
> +{
> +       update_rq_runnable_avg(this_rq, 0);
> +}

These seem like fairly unfortunate names to expose to the global
namespace, why not expose update_rq_runnable_avg() instead?


