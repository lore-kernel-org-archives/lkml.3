Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3F0QBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:01:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60802 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3F0QBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:01:36 -0400
Date: Thu, 27 Jun 2013 18:01:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] sched: Favour moving tasks towards the preferred node
Message-ID: <20130627160127.GY28407@twins.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-6-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372257487-9749-6-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:38:04PM +0100, Mel Gorman wrote:
> @@ -3897,6 +3907,28 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
>  	return delta < (s64)sysctl_sched_migration_cost;
>  }
>  
> +/* Returns true if the destination node has incurred more faults */
> +static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
> +{
> +	int src_nid, dst_nid;
> +
> +	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
> +		return false;
> +
> +	src_nid = cpu_to_node(env->src_cpu);
> +	dst_nid = cpu_to_node(env->dst_cpu);
> +
> +	if (src_nid == dst_nid)
> +		return false;
> +
> +	if (p->numa_migrate_seq < sysctl_numa_balancing_settle_count &&
> +	    p->numa_preferred_nid == dst_nid)
> +		return true;
> +
> +	return false;
> +}
> +

This references ->numa_faults, which is declared under NUMA_BALANCING
but lacks any such conditionality here.
