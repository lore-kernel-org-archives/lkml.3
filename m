Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763548Ab3DDF7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:59:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54767 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab3DDF7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:59:43 -0400
X-AuditID: 9c930197-b7b50ae00000018c-81-515d16cca877
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [patch v7 15/21] sched: pull all tasks from source group
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
	<1365040862-8390-16-git-send-email-alex.shi@intel.com>
Date: Thu, 04 Apr 2013 14:59:40 +0900
In-Reply-To: <1365040862-8390-16-git-send-email-alex.shi@intel.com> (Alex
	Shi's message of "Thu, 4 Apr 2013 10:00:56 +0800")
Message-ID: <87a9peesz7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Thu,  4 Apr 2013 10:00:56 +0800, Alex Shi wrote:
> In power balance, we hope some sched groups are fully empty to save
> CPU power of them. So, we want to move any tasks from them.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f861427..0dd29f4 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5105,7 +5105,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>  		 * When comparing with imbalance, use weighted_cpuload()
>  		 * which is not scaled with the cpu power.
>  		 */
> -		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
> +		if (rq->nr_running == 0 ||
> +			(!(env->flags & LBF_POWER_BAL) && capacity &&
> +				rq->nr_running == 1 && wl > env->imbalance))

Just out of curious.

In load_balance(), we only move normal tasks, right?

Then shouldn't it check rq->cfs.h_nr_running rather than rq->nr_running?

Thanks,
Namhyung


>  			continue;
>  
>  		/*
> @@ -5208,7 +5210,8 @@ redo:
>  
>  	ld_moved = 0;
>  	lb_iterations = 1;
> -	if (busiest->nr_running > 1) {
> +	if (busiest->nr_running > 1 ||
> +		(busiest->nr_running == 1 && env.flags & LBF_POWER_BAL)) {
>  		/*
>  		 * Attempt to move tasks. If find_busiest_group has found
>  		 * an imbalance but busiest->nr_running <= 1, the group is
