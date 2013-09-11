Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3IKA57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:57:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53811 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3IKA56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:57:58 -0400
X-AuditID: 9c93016f-b7cf0ae00000518f-3c-522fc0128e35
Date: Wed, 11 Sep 2013 09:58:15 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/50] sched: monolithic code dump of what is being
 pushed upstream
Message-ID: <20130911005815.GA24671@lge.com>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378805550-29949-2-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:31:41AM +0100, Mel Gorman wrote:
> @@ -5045,15 +5038,50 @@ static int need_active_balance(struct lb_env *env)
>  
>  static int active_load_balance_cpu_stop(void *data);
>  
> +static int should_we_balance(struct lb_env *env)
> +{
> +	struct sched_group *sg = env->sd->groups;
> +	struct cpumask *sg_cpus, *sg_mask;
> +	int cpu, balance_cpu = -1;
> +
> +	/*
> +	 * In the newly idle case, we will allow all the cpu's
> +	 * to do the newly idle load balance.
> +	 */
> +	if (env->idle == CPU_NEWLY_IDLE)
> +		return 1;
> +
> +	sg_cpus = sched_group_cpus(sg);
> +	sg_mask = sched_group_mask(sg);
> +	/* Try to find first idle cpu */
> +	for_each_cpu_and(cpu, sg_cpus, env->cpus) {
> +		if (!cpumask_test_cpu(cpu, sg_mask) || !idle_cpu(cpu))
> +			continue;
> +
> +		balance_cpu = cpu;
> +		break;
> +	}
> +
> +	if (balance_cpu == -1)
> +		balance_cpu = group_balance_cpu(sg);
> +
> +	/*
> +	 * First idle cpu or the first cpu(busiest) in this sched group
> +	 * is eligible for doing load balancing at this and above domains.
> +	 */
> +	return balance_cpu != env->dst_cpu;
> +}
> +

Hello, Mel.

There is one mistake from me.
The last return statement in should_we_balance() should be
'return balance_cpu == env->dst_cpu'. The fix was submitted yesterday.

You can get more information on below thread.
https://lkml.org/lkml/2013/9/10/1

I think that this fix is somewhat important to scheduler's behavior,
so it may be better to update your test result with this fix.
Sorry for notifying this.

Thanks.
