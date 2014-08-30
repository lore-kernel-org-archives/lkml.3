Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaH3RHx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 13:07:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51655 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaH3RHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 13:07:51 -0400
Message-ID: <540204DC.5090204@linux.vnet.ibm.com>
Date: Sat, 30 Aug 2014 22:37:40 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 04/12] sched: Allow all archs to set the capacity_orig
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org> <1409051215-16788-5-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1409051215-16788-5-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14083017-0928-0000-0000-000004736867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On 08/26/2014 04:36 PM, Vincent Guittot wrote:
> capacity_orig is only changed for system with a SMT sched_domain level in order

I think I had asked this before, but why only capacity_orig? The
capacity of a group is also being updated the same way. This patch fixes
the capacity of a group to reflect the capacity of the heterogeneous
CPUs in it, this capacity being both the full capacity of the group:
capacity_orig and the capacity available for the fair tasks. So I feel
in the subject as well as the changelog it would suffice to say 'capacity'.

> to reflect the lower capacity of CPUs. Heterogenous system also have to reflect an
> original capacity that is different from the default value.
> 
> Create a more generic function arch_scale_cpu_capacity that can be also used by
> non SMT platform to set capacity_orig.
> 
> The weak behavior of arch_scale_cpu_capacity is the previous SMT one in order to
> keep backward compatibility in the use of capacity_orig.
> 
> arch_scale_smt_capacity and default_scale_smt_capacity have been removed as
> they were not use elsewhere than in arch_scale_cpu_capacity.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 25 ++++++-------------------
>  1 file changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b85e9f7..8176bda 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5705,19 +5705,12 @@ unsigned long __weak arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
>  	return default_scale_capacity(sd, cpu);
>  }
> 
> -static unsigned long default_scale_smt_capacity(struct sched_domain *sd, int cpu)
> +unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
>  {
> -	unsigned long weight = sd->span_weight;
> -	unsigned long smt_gain = sd->smt_gain;
> +	if ((sd->flags & SD_SHARE_CPUCAPACITY) && (sd->span_weight > 1))
> +		return sd->smt_gain / sd->span_weight;
> 
> -	smt_gain /= weight;
> -
> -	return smt_gain;
> -}
> -
> -unsigned long __weak arch_scale_smt_capacity(struct sched_domain *sd, int cpu)
> -{
> -	return default_scale_smt_capacity(sd, cpu);
> +	return SCHED_CAPACITY_SCALE;
>  }
> 
>  static unsigned long scale_rt_capacity(int cpu)
> @@ -5756,18 +5749,12 @@ static unsigned long scale_rt_capacity(int cpu)
> 
>  static void update_cpu_capacity(struct sched_domain *sd, int cpu)
>  {
> -	unsigned long weight = sd->span_weight;
>  	unsigned long capacity = SCHED_CAPACITY_SCALE;
>  	struct sched_group *sdg = sd->groups;
> 
> -	if ((sd->flags & SD_SHARE_CPUCAPACITY) && weight > 1) {
> -		if (sched_feat(ARCH_CAPACITY))

Aren't you missing this check above? I understand that it is not
crucial, but that would also mean removing ARCH_CAPACITY sched_feat
altogether, wouldn't it?

Regards
Preeti U Murthy
> -			capacity *= arch_scale_smt_capacity(sd, cpu);
> -		else
> -			capacity *= default_scale_smt_capacity(sd, cpu);
> +	capacity *= arch_scale_cpu_capacity(sd, cpu);
> 
> -		capacity >>= SCHED_CAPACITY_SHIFT;
> -	}
> +	capacity >>= SCHED_CAPACITY_SHIFT;
> 
>  	sdg->sgc->capacity_orig = capacity;
> 

