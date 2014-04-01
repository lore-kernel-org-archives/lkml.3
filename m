Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaDAKnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:43:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37354 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaDAKnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:43:39 -0400
Message-ID: <533A9768.6060006@linux.vnet.ibm.com>
Date: Tue, 01 Apr 2014 16:09:36 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        Morten.Rasmussen@arm.com, efault@gmx.de,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC 1/4] sched: extend the usage of cpu_power_orig
References: <1396012949-6227-1-git-send-email-vincent.guittot@linaro.org> <1396012949-6227-2-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1396012949-6227-2-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040110-1344-0000-0000-000000A162E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On 03/28/2014 06:52 PM, Vincent Guittot wrote:
> cpu_power_orig is only changed for SMT system in order to reflect the lower
> capacity of CPUs. Heterogenous system also have to reflect an original
> capacity that is different from the default value.

There is no parameter 'cpu_power_orig' till your fourth patch right?
Why is this term being used in this patch?

Besides, both parameters power and power_orig are changed for SMT
systems to reflect the lower capacity of the CPUs.Why is there a mention
of only power_orig?

IMO, the subject of the patch is not clearly reflecting the main
intention of the patch. There is nothing done to change the way
cpu_power is used; rather you are changing the way the cpu_power is
being set to be flexible, thus allowing for the right power value to be
set on heterogeneous systems.

'Allow archs to set the cpu_power instead of falling to default value'
or something similar would be more appropriate. What do you think?

Regards
Preeti U Murthy
> 
> Create a more generic function arch_scale_cpu_power that can be also used by
> non SMT platform to set cpu_power_orig.
> 
> The weak behavior of arch_scale_cpu_power is the previous SMT one in order to
> keep backward compatibility in the use of cpu_power_orig.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7e9bd0b..ed42061 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5559,6 +5559,20 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
>  	return default_scale_smt_power(sd, cpu);
>  }
> 
> +unsigned long __weak arch_scale_cpu_power(struct sched_domain *sd, int cpu)
> +{
> +	unsigned long weight = sd->span_weight;
> +
> +	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
> +		if (sched_feat(ARCH_POWER))
> +			return arch_scale_smt_power(sd, cpu);
> +		else
> +			return default_scale_smt_power(sd, cpu);
> +	}
> +
> +	return SCHED_POWER_SCALE;
> +}
> +
>  static unsigned long scale_rt_power(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> @@ -5590,18 +5604,12 @@ static unsigned long scale_rt_power(int cpu)
> 
>  static void update_cpu_power(struct sched_domain *sd, int cpu)
>  {
> -	unsigned long weight = sd->span_weight;
>  	unsigned long power = SCHED_POWER_SCALE;
>  	struct sched_group *sdg = sd->groups;
> 
> -	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
> -		if (sched_feat(ARCH_POWER))
> -			power *= arch_scale_smt_power(sd, cpu);
> -		else
> -			power *= default_scale_smt_power(sd, cpu);
> +	power *= arch_scale_cpu_power(sd, cpu);
> 
> -		power >>= SCHED_POWER_SHIFT;
> -	}
> +	power >>= SCHED_POWER_SHIFT;
> 
>  	sdg->sgp->power_orig = power;
> 

