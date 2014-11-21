Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbaKUMfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:35:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36593 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758488AbaKUMfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:35:22 -0500
Date: Fri, 21 Nov 2014 12:35:59 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v9 05/10] sched: make scale_rt invariant with frequency
Message-ID: <20141121123559.GF23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-6-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415033687-23294-6-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:54:42PM +0000, Vincent Guittot wrote:
> The average running time of RT tasks is used to estimate the remaining compute
> capacity for CFS tasks. This remaining capacity is the original capacity scaled
> down by a factor (aka scale_rt_capacity). This estimation of available capacity
> must also be invariant with frequency scaling.
> 
> A frequency scaling factor is applied on the running time of the RT tasks for
> computing scale_rt_capacity.
> 
> In sched_rt_avg_update, we scale the RT execution time like below:
> rq->rt_avg += rt_delta * arch_scale_freq_capacity() >> SCHED_CAPACITY_SHIFT
> 
> Then, scale_rt_capacity can be summarized by:
> scale_rt_capacity = SCHED_CAPACITY_SCALE -
> 		((rq->rt_avg << SCHED_CAPACITY_SHIFT) / period)
> 
> We can optimize by removing right and left shift in the computation of rq->rt_avg
> and scale_rt_capacity
> 
> The call to arch_scale_frequency_capacity in the rt scheduling path might be
> a concern for RT folks because I'm not sure whether we can rely on
> arch_scale_freq_capacity to be short and efficient ?

It better be fast :) It is used in critical paths. However, if you
really care about latency you probably don't want frequency scaling to
mess around. If the architecture provides a fast-path for
arch_scale_freq_capacity() returning SCHED_CAPACITY_SCALE when frequency
scaling is disabled, the overhead should be minimal. If the architecture
doesn't provide arch_scale_freq_capacity() it becomes a constant
multiplication and should hopefully go away completely.

> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c  | 17 +++++------------
>  kernel/sched/sched.h |  4 +++-
>  2 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index a5039da..b37c27b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5785,7 +5785,7 @@ unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
>  static unsigned long scale_rt_capacity(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
> -	u64 total, available, age_stamp, avg;
> +	u64 total, used, age_stamp, avg;
>  	s64 delta;
>  
>  	/*
> @@ -5801,19 +5801,12 @@ static unsigned long scale_rt_capacity(int cpu)
>  
>  	total = sched_avg_period() + delta;
>  
> -	if (unlikely(total < avg)) {
> -		/* Ensures that capacity won't end up being negative */
> -		available = 0;
> -	} else {
> -		available = total - avg;
> -	}
> +	used = div_u64(avg, total);

I haven't looked through all the details of the rt avg tracking, but if
'used' is in the range [0..SCHED_CAPACITY_SCALE], I believe it should
work. Is it guaranteed that total > 0 so we don't get division by zero?

It does get a slightly more complicated if we want to figure out the
available capacity at the current frequency (current < max) later. Say,
rt eats 25% of the compute capacity, but the current frequency is only
50%. In that case get:

curr_avail_capacity = (arch_scale_cpu_capacity() *
  (arch_scale_freq_capacity() - (SCHED_SCALE_CAPACITY - scale_rt_capacity())))
  >> SCHED_CAPACITY_SHIFT

With numbers assuming arch_scale_cpu_capacity() = 800:

curr_avail_capacity = 800 * (512 - (1024 - 758)) >> 10 = 200

Which isn't actually that bad. Anyway, it isn't needed until we start
invovling energy models.

>  
> -	if (unlikely((s64)total < SCHED_CAPACITY_SCALE))
> -		total = SCHED_CAPACITY_SCALE;
> +	if (likely(used < SCHED_CAPACITY_SCALE))
> +		return SCHED_CAPACITY_SCALE - used;
>  
> -	total >>= SCHED_CAPACITY_SHIFT;
> -
> -	return div_u64(available, total);
> +	return 1;
>  }
>  
>  static void update_cpu_capacity(struct sched_domain *sd, int cpu)
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index c34bd11..fc5b152 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -1312,9 +1312,11 @@ static inline int hrtick_enabled(struct rq *rq)
>  
>  #ifdef CONFIG_SMP
>  extern void sched_avg_update(struct rq *rq);
> +extern unsigned long arch_scale_freq_capacity(struct sched_domain *sd, int cpu);

I'm not sure if it makes any difference, but shouldn't it be __weak
instead of extern?

unsigned long __weak arch_scale_freq_capacity(...)

Also, now that the function prototype definition is in the header file
we can kill the local prototype in fair.c introduced in patch 4:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6fd5ac6..921b174 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2277,8 +2277,6 @@ static u32 __compute_runnable_contrib(u64 n)
        return contrib + runnable_avg_yN_sum[n];
 }
 
-unsigned long __weak arch_scale_freq_capacity(struct sched_domain *sd,
int cpu);
-
 /*
  * We can represent the historical contribution to runnable average as
  * the
  * coefficients of a geometric series.  To do this we sub-divide our
  * runnable

