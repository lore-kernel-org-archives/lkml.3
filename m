Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaKSQYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:24:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:58543 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755331AbaKSQYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:24:54 -0500
Date: Wed, 19 Nov 2014 11:24:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 3/4] sched/deadline: add the "set_flag" argument to
 cpudl_find()
Message-ID: <20141119112451.6fef30f0@gandalf.local.home>
In-Reply-To: <1416411982-1204-3-git-send-email-pang.xunlei@linaro.org>
References: <1416411982-1204-1-git-send-email-pang.xunlei@linaro.org>
	<1416411982-1204-3-git-send-email-pang.xunlei@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 23:46:21 +0800
"pang.xunlei" <pang.xunlei@linaro.org> wrote:

> The call site of cpudl_find() in check_preempt_equal_dl() doesn't
> use later_mask, so add this extra argument to distinquish the case.
> 
> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
> ---
>  kernel/sched/cpudeadline.c |    6 ++++--
>  kernel/sched/cpudeadline.h |    2 +-
>  kernel/sched/deadline.c    |    6 +++---
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
> index c01b3aa..3047846 100644
> --- a/kernel/sched/cpudeadline.c
> +++ b/kernel/sched/cpudeadline.c
> @@ -98,11 +98,12 @@ static inline int cpudl_maximum(struct cpudl *cp)
>   * @cp: the cpudl max-heap context
>   * @p: the task
>   * @later_mask: a mask to fill in with the selected CPUs (not NULL)
> + * @set_flag: indicate if later_mask should be set
>   *
>   * Returns: int - best CPU (heap maximum if suitable)
>   */
>  int cpudl_find(struct cpudl *cp, struct task_struct *p,
> -	       struct cpumask *later_mask)
> +	       struct cpumask *later_mask, int set_flag)

set_flag should be a bool type.

>  {
>  	int best_cpu = -1;
>  	const struct sched_dl_entity *dl_se = &p->dl;
> @@ -114,7 +115,8 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
>  	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
>  			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
>  		best_cpu = cpudl_maximum(cp);
> -		cpumask_set_cpu(best_cpu, later_mask);
> +		if (set_flag)
> +			cpumask_set_cpu(best_cpu, later_mask);

I'm not sure this is worth it. cpumask_set_cpu() is rather efficient.

>  	}
>  
>  out:

