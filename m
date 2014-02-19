Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaBSJE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:04:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49993 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaBSJEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:04:20 -0500
Date: Wed, 19 Feb 2014 10:04:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lei Wen <leiwen@marvell.com>
Cc: mingo@redhat.com, preeti.lkml@gmail.com, daniel.lezcano@linaro.org,
        viresh.kumar@linaro.org, xjian@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: keep quiescent cpu out of idle balance loop
Message-ID: <20140219090415.GK27965@twins.programming.kicks-ass.net>
References: <1392787230-17986-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392787230-17986-1-git-send-email-leiwen@marvell.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:20:30PM +0800, Lei Wen wrote:
> Since cpu which is put into quiescent mode, would remove itself
> from kernel's sched_domain. So we could use search sched_domain
> method to check whether this cpu don't want to be disturbed as
> idle load balance would send IPI to it.
> 
> Signed-off-by: Lei Wen <leiwen@marvell.com>
> ---
>  kernel/sched/fair.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 235cfa7..14230ae 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6783,6 +6783,8 @@ out_unlock:
>   * - When one of the busy CPUs notice that there may be an idle rebalancing
>   *   needed, they will kick the idle load balancer, which then does idle
>   *   load balancing for all the idle CPUs.
> + * - exclude those cpus not inside current call_cpu's sched_domain, so that
> + *   those isolated cpu could be kept in their quisecnt mode.
>   */
>  static struct {
>  	cpumask_var_t idle_cpus_mask;
> @@ -6792,10 +6794,16 @@ static struct {
>  
>  static inline int find_new_ilb(void)
>  {
> -	int ilb = cpumask_first(nohz.idle_cpus_mask);
> +	int ilb;
> +	int cpu = smp_processor_id();
> +	struct sched_domain *tmp;
>  
> -	if (ilb < nr_cpu_ids && idle_cpu(ilb))
> -		return ilb;
> +	for_each_domain(cpu, tmp) {
> +		ilb = cpumask_first_and(nohz.idle_cpus_mask,
> +				sched_domain_span(tmp));
> +		if (ilb < nr_cpu_ids && idle_cpu(ilb))
> +			return ilb;
> +	}

The ILB code is bad; but you just made it horrible. Don't add pointless
for_each_domain() iterations.

I'm thinking something like:

  ilb = cpumask_first_and(nohz.idle_cpus_mask, this_rq()->rd.span);

Should work just fine, no?

Better still would be to maybe not participate in the ILB in the first
place and leave this selection loop alone.
