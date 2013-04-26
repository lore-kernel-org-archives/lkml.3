Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3DZMvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:51:04 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33400
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498Ab3DZMvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:51:02 -0400
Date: Fri, 26 Apr 2013 14:49:32 +0200
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
Subject: Re: [PATCH 04/14] sched: pack the idle load balance
Message-ID: <20130426124931.GC13464@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
 <1366910611-20048-5-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910611-20048-5-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:23:20PM +0200, Vincent Guittot wrote:
> Look for an idle CPU close to the pack buddy CPU whenever possible.
> The goal is to prevent the wake up of a CPU which doesn't share the power
> domain of the pack buddy CPU.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reviewed-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  kernel/sched/fair.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 6adc57c..a985c98 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5469,7 +5469,26 @@ static struct {
>  
>  static inline int find_new_ilb(int call_cpu)
>  {
> +	struct sched_domain *sd;
>  	int ilb = cpumask_first(nohz.idle_cpus_mask);
> +	int buddy = per_cpu(sd_pack_buddy, call_cpu);
> +
> +	/*
> +	 * If we have a pack buddy CPU, we try to run load balance on a CPU
> +	 * that is close to the buddy.
> +	 */
> +	if (buddy != -1) {
> +		for_each_domain(buddy, sd) {
> +			if (sd->flags & SD_SHARE_CPUPOWER)
> +				continue;
> +
> +			ilb = cpumask_first_and(sched_domain_span(sd),
> +					nohz.idle_cpus_mask);
> +
> +			if (ilb < nr_cpu_ids)
> +				break;
> +		}
> +	}
>  
>  	if (ilb < nr_cpu_ids && idle_cpu(ilb))
>  		return ilb;

Ha! and here you hope people won't put multiple big-little clusters in a single
machine? :-)



