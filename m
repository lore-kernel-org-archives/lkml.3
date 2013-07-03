Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab3GCJL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:11:57 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51155 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3GCJL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:11:56 -0400
Message-ID: <51D3EAD1.7080507@linux.vnet.ibm.com>
Date: Wed, 03 Jul 2013 17:11:45 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com> <51D25A80.8090406@linux.vnet.ibm.com> <51D3C058.3020601@linux.vnet.ibm.com> <20130703085025.GG23916@twins.programming.kicks-ass.net>
In-Reply-To: <20130703085025.GG23916@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070309-3864-0000-0000-000008E9797D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 04:50 PM, Peter Zijlstra wrote:
> On Wed, Jul 03, 2013 at 02:10:32PM +0800, Michael Wang wrote:
>> +static int wake_wide(struct task_struct *p)
>> +{
>> +	int factor = nr_cpus_node(cpu_to_node(smp_processor_id()));
> 
> That's still a cpumask_weight() in there... 

Exactly, although the scale is lower but still it's a mask...

> we should avoid that. How about something like the below:

Amazing, cost will be lowest when we got such counter, will make them a
patch set and test again ;-)

Regards,
Michael Wang

> 
>> +
>> +	/*
>> +	 * Yeah, it's the switching-frequency, could means many wakee or
>> +	 * rapidly switch, use factor here will just help to automatically
>> +	 * adjust the loose-degree, so bigger node will lead to more pull.
>> +	 */
>> +	if (p->nr_wakee_switch > factor) {
>> +		/*
>> +		 * wakee is somewhat hot, it needs certain amount of cpu
>> +		 * resource, so if waker is far more hot, prefer to leave
>> +		 * it alone.
>> +		 */
>> +		if (current->nr_wakee_switch > (factor * p->nr_wakee_switch))
>> +			return 1;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9b1f2e5..166ab9b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5081,18 +5083,23 @@ static void destroy_sched_domains(struct sched_domain *sd, int cpu)
>   * two cpus are in the same cache domain, see cpus_share_cache().
>   */
>  DEFINE_PER_CPU(struct sched_domain *, sd_llc);
> +DEFINE_PER_CPU(int, sd_llc_size);
>  DEFINE_PER_CPU(int, sd_llc_id);
> 
>  static void update_top_cache_domain(int cpu)
>  {
>  	struct sched_domain *sd;
>  	int id = cpu;
> +	int size = 1;
> 
>  	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
> -	if (sd)
> +	if (sd) {
>  		id = cpumask_first(sched_domain_span(sd));
> +		size = cpumask_weight(sched_domain_span(sd));
> +	}
> 
>  	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
> +	per_cpu(sd_llc_size, cpu) = size;
>  	per_cpu(sd_llc_id, cpu) = id;
>  }
> 
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index ef0a7b2..c992f58 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -595,6 +595,7 @@ static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
>  }
> 
>  DECLARE_PER_CPU(struct sched_domain *, sd_llc);
> +DECLARE_PER_CPU(int, sd_llc_size);
>  DECLARE_PER_CPU(int, sd_llc_id);
> 
>  struct sched_group_power {
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3175,7 +3175,7 @@ static inline unsigned long effective_lo
> 
>  static int wake_wide(struct task_struct *p)
>  {
> -	int factor = nr_cpus_node(cpu_to_node(smp_processor_id()));
> +	int factor = this_cpu_read(sd_llc_size);
> 
>  	/*
>  	 * Yeah, it's the switching-frequency, could means many wakee or
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

