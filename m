Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3DZNRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:17:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33551
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab3DZNRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:17:03 -0400
Date: Fri, 26 Apr 2013 15:15:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net, l.majewski@samsung.com
Subject: Re: [PATCH 08/14] sched: trig ILB on an idle buddy
Message-ID: <20130426131532.GB13964@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
 <1366910611-20048-9-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910611-20048-9-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:23:24PM +0200, Vincent Guittot wrote:
> If the buddy CPU is not full and currently idle, we trigger an Idle Load
> Balance to give it the opportunity to pull more tasks.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 874f330..954adfd 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5776,6 +5776,26 @@ end:
>  	clear_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu));
>  }
>  
> +static int check_nohz_buddy(int cpu)
> +{
> +	int buddy = per_cpu(sd_pack_buddy, cpu);
> +
> +	if (sysctl_sched_packing_mode != SCHED_PACKING_FULL)
> +		return false;
> +
> +	/* No pack buddy for this CPU */
> +	if (buddy == -1)
> +		return false;
> +
> +	if (is_buddy_full(buddy))
> +		return false;
> +
> +	if (cpumask_test_cpu(buddy, nohz.idle_cpus_mask))
> +		return true;
> +
> +	return false;

return cpumask_test_cpu(..); ?

> +}
> +
>  /*
>   * Current heuristic for kicking the idle load balancer in the presence
>   * of an idle cpu is the system.
> @@ -5813,6 +5833,10 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>  	if (rq->nr_running >= 2)
>  		goto need_kick;
>  
> +	/* the buddy is idle and not busy so we can pack */
> +	if (check_nohz_buddy(cpu))
> +		goto need_kick;
> +
>  	rcu_read_lock();
>  	for_each_domain(cpu, sd) {
>  		struct sched_group *sg = sd->groups;

Bah.. this code is so confusing.. nohz_balance_kick(cpu) won't actually kick
@cpu.

Again.. suppose we're a big cpu (2) and our little buddy cpu (0) is busy, we
miss an opportunity to kick the other little cpu into gear (1) and maybe take
the big core out.


