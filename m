Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3EMOJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:09:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46252 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3EMOJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:09:27 -0400
Date: Mon, 13 May 2013 16:06:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: Re: [patch v6 6/8] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
Message-ID: <20130513140625.GA15136@twins.programming.kicks-ass.net>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
 <1368199049-2798-7-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368199049-2798-7-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 11:17:27PM +0800, Alex Shi wrote:
> They are the base values in load balance, update them with rq runnable
> load average, then the load balance will consider runnable load avg
> naturally.
> 
> We also try to include the blocked_load_avg as cpu load in balancing,
> but that cause kbuild/aim7/oltp benchmark performance drop.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c |   16 ++++++++++++++--
>  kernel/sched/fair.c |    5 +++--
>  2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index f1f9641..8ab37c3 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2528,9 +2528,14 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  void update_idle_cpu_load(struct rq *this_rq)
>  {
>  	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> -	unsigned long load = this_rq->load.weight;
> +	unsigned long load;
>  	unsigned long pending_updates;
>  
> +#ifdef CONFIG_SMP
> +	load = this_rq->cfs.runnable_load_avg;
> +#else
> +	load = this_rq->load.weight;
> +#endif
>  	/*
>  	 * bail if there's load or we're actually up-to-date.
>  	 */
> @@ -2574,11 +2579,18 @@ void update_cpu_load_nohz(void)
>   */
>  static void update_cpu_load_active(struct rq *this_rq)
>  {
> +	unsigned long load;
> +
> +#ifdef CONFIG_SMP
> +	load = this_rq->cfs.runnable_load_avg;
> +#else
> +	load = this_rq->load.weight;
> +#endif
>  	/*
>  	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().

This just smells like you want a helper function... :-)

Also it doesn't apply anymore due to Paul Gortemaker moving some of this
stuff about.
