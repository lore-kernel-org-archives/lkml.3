Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3CTE7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 00:59:19 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49516 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3CTE7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 00:59:17 -0400
Message-ID: <514941C5.6080007@linux.vnet.ibm.com>
Date: Wed, 20 Mar 2013 10:27:41 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de
CC: torvalds@linux-foundation.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 14/15] sched: power aware load balance
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-15-git-send-email-alex.shi@intel.com>
In-Reply-To: <1361164062-20111-15-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032004-0260-0000-0000-000002B18336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

Please note one point below.

On 02/18/2013 10:37 AM, Alex Shi wrote:
> This patch enabled the power aware consideration in load balance.
> 
> As mentioned in the power aware scheduler proposal, Power aware
> scheduling has 2 assumptions:
> 1, race to idle is helpful for power saving
> 2, less active sched_groups will reduce power consumption
> 
> The first assumption make performance policy take over scheduling when
> any scheduler group is busy.
> The second assumption make power aware scheduling try to pack disperse
> tasks into fewer groups.
> 
> The enabling logical summary here:
> 1, Collect power aware scheduler statistics during performance load
> balance statistics collection.
> 2, If the balance cpu is eligible for power load balance, just do it
> and forget performance load balance. If the domain is suitable for
> power balance, but the cpu is inappropriate(idle or full), stop both
> power/performance balance in this domain. If using performance balance
> or any group is busy, do performance balance.
> 
> Above logical is mainly implemented in update_sd_lb_power_stats(). It
> decides if a domain is suitable for power aware scheduling. If so,
> it will fill the dst group and source group accordingly.
> 
> This patch reuse some of Suresh's power saving load balance code.
> 
> A test can show the effort on different policy:
> for ((i = 0; i < I; i++)) ; do while true; do :; done  &   done
> 
> On my SNB laptop with 4core* HT: the data is Watts
>         powersaving     balance         performance
> i = 2   40              54              54
> i = 4   57              64*             68
> i = 8   68              68              68
> 
> Note:
> When i = 4 with balance policy, the power may change in 57~68Watt,
> since the HT capacity and core capacity are both 1.
> 
> on SNB EP machine with 2 sockets * 8 cores * HT:
>         powersaving     balance         performance
> i = 4   190             201             238
> i = 8   205             241             268
> i = 16  271             348             376
> 
> If system has few continued tasks, use power policy can get
> the performance/power gain. Like sysbench fileio randrw test with 16
> thread on the SNB EP box,
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 129 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 126 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ffdf35d..3b1e9a6 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4650,6 +4753,12 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>  		sgs->group_load += load;
>  		sgs->sum_nr_running += nr_running;
>  		sgs->sum_weighted_load += weighted_cpuload(i);
> +
> +		/* accumulate the maximum potential util */
> +		if (!nr_running)
> +			nr_running = 1;
> +		sgs->group_utils += rq->util * nr_running;

You may have observed the following,but I thought it would be best to
bring this to notice.

The above will lead to situations where sched groups never fill to their
full capacity. This is explained with an example below:

Say the topology is two cores with hyper threading of two logical
threads each. If we choose powersaving policy,and run two workloads at
full utilization, the load will get distributed one on each core, they
will not get consolidated on a single core.
The reason being,the condition:
" if (sgs->group_utils + FULL_UTIL > threshold_util) " in
update_sd_lb_power_stats will fail.

The situation goes thus:


w1                 w2
t1  t2             t3  t4
-------            -------
core1               core2

Above t->thread(logical cpu)
      w->workload


Neither core will be able to pull the task from the other to consolidate
the load because the rq->util of t2 and t4, on which no process is
running, continue to show some number even though they degrade with time
and sgs->utils accounts for them. Therefore,
for core1 and core2, the sgs->utils will be slightly above 100 and the
above condition will fail, thus failing them as candidates for
group_leader,since threshold_util will be 200.

This phenomenon is seen for balance policy and wider topology as well.
I think we would be better off without accounting the rq->utils of the
cpus which do not have any processes running on them for sgs->utils.
What do you think?


Regards
Preeti U Murthy

