Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3HUNjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:39:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63333 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3HUNjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:39:10 -0400
Date: Wed, 21 Aug 2013 09:39:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 04/11] cpuset: update cs->real_{cpus,mems}_allowed when
 config changes
Message-ID: <20130821133906.GD19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148F84.9050309@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148F84.9050309@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 05:59:32PM +0800, Li Zefan wrote:
...
> +	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
> +		struct cpuset *parent = parent_cs(cs);
> +		struct cpumask *new_cpus = trialcs->real_cpus_allowed;
> +
> +		cpumask_and(new_cpus, cp->cpus_allowed,
> +			    parent->real_cpus_allowed);
> +
> +		/*
> +		 * Skip the whole subtree if the cpumask is not changed, unless
> +		 * it's empty, and in this case we need to update tasks to take
> +		 * on an ancestor's cpumask.

Something like the following would be clearer?

"Skip the whole subtree if the cpumask remains the same and isn't
empty.  If empty, we need..."

> @@ -931,7 +941,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  {
>  	struct ptr_heap heap;
>  	int retval;
> -	int is_load_balanced;
>  
>  	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
>  	if (cs == &top_cpuset)
> @@ -966,17 +975,15 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>  	if (retval)
>  		return retval;
>  
> -	is_load_balanced = is_sched_load_balance(trialcs);
> -
>  	mutex_lock(&callback_mutex);
>  	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
>  	mutex_unlock(&callback_mutex);
>  
> -	update_tasks_cpumask_hier(cs, true, &heap);
> +	update_cpumasks_hier(cs, trialcs, &heap);
>  
>  	heap_free(&heap);
>  
> -	if (is_load_balanced)
> +	if (is_sched_load_balance(cs))
>  		rebuild_sched_domains_locked();

Hmmm... Maybe the above change needs some explanation in the patch
description?

Ooh and @update_root params are gone.  Maybe nice to note that in the
description too?

Thanks.

-- 
tejun
