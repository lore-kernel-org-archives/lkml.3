Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991Ab3DBJDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:03:00 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50604 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3DBJC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:02:57 -0400
X-AuditID: 9c930179-b7b2aae000000518-37-515a9ebec9ef
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v6 10/21] sched: get rq potential maximum utilization
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
	<1364654108-16307-11-git-send-email-alex.shi@intel.com>
Date: Tue, 02 Apr 2013 18:02:54 +0900
In-Reply-To: <1364654108-16307-11-git-send-email-alex.shi@intel.com> (Alex
	Shi's message of "Sat, 30 Mar 2013 22:34:57 +0800")
Message-ID: <87a9phfgox.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Sat, 30 Mar 2013 22:34:57 +0800, Alex Shi wrote:
> Since the rt task priority is higher than fair tasks, cfs_rq utilization
> is just the left of rt utilization.
>
> When there are some cfs tasks in queue, the potential utilization may
> be yielded, so mulitiplying cfs task number to get max potential
> utilization of cfs. Then the rq utilization is sum of rt util and cfs
> util.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ae87dab..0feeaee 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3350,6 +3350,22 @@ struct sg_lb_stats {
>  	unsigned int group_util;	/* sum utilization of group */
>  };
>  
> +static unsigned long scale_rt_util(int cpu);
> +
> +static unsigned int max_rq_util(int cpu)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	unsigned int rt_util = scale_rt_util(cpu);
> +	unsigned int cfs_util;
> +	unsigned int nr_running;
> +
> +	cfs_util = (FULL_UTIL - rt_util) > rq->util ? rq->util
> +			: (FULL_UTIL - rt_util);
> +	nr_running = rq->nr_running ? rq->nr_running : 1;

This can be cleaned up with proper min/max().

> +
> +	return rt_util + cfs_util * nr_running;

Should this nr_running consider tasks in cfs_rq only?  Also it seems
there's no upper bound so that it can possibly exceed FULL_UTIL.

Thanks,
Namhyung

> +}
> +
>  /*
>   * sched_balance_self: balance the current task (running on cpu) in domains
>   * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
