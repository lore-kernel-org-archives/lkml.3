Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3FRKDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:03:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39901 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3FRKDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:03:10 -0400
Date: Tue, 18 Jun 2013 12:03:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: mingo@redhat.com, linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com
Subject: Re: [PATCH 2/3] sched: don't call get_group() for covered cpus
Message-ID: <20130618100306.GL3204@twins.programming.kicks-ass.net>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
 <7a61e955abdcbb1dfa9fe493f11a5ec53a11ddd3.1370948150.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a61e955abdcbb1dfa9fe493f11a5ec53a11ddd3.1370948150.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 04:32:44PM +0530, Viresh Kumar wrote:
> In build_sched_groups() we don't need to call get_group() for cpus which are
> already covered in previous iterations. So, call get_group() after checking if
> cpu is covered or not.
> 

Aside from not needing it; doing it would mark the group used and
eventually leak it since we wouldn't connect it and not find it again to
free it, right?

So effectively this fixes a memory leak?

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/sched/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4abc743..27842f5 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5344,12 +5344,12 @@ build_sched_groups(struct sched_domain *sd, int cpu)
>  
>  	for_each_cpu(i, span) {
>  		struct sched_group *sg;
> -		int group = get_group(i, sdd, &sg);
> -		int j;
> +		int group, j;
>  
>  		if (cpumask_test_cpu(i, covered))
>  			continue;
>  
> +		group = get_group(i, sdd, &sg);
>  		cpumask_clear(sched_group_cpus(sg));
>  		sg->sgp->power = 0;
>  		cpumask_setall(sched_group_mask(sg));
> -- 
> 1.7.12.rc2.18.g61b472e
> 
