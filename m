Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3HUOLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:11:32 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:37882 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3HUOLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:11:30 -0400
Date: Wed, 21 Aug 2013 10:11:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 09/11] cpuset: enable onlined cpu/node in effective masks
Message-ID: <20130821141126.GI19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FE1.3080806@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52148FE1.3080806@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Aug 21, 2013 at 06:01:05PM +0800, Li Zefan wrote:
> Firstly offline cpu1:
> 
>   # echo 0-1 > cpuset.cpus
>   # echo 0 > /sys/devices/system/cpu/cpu1/online
>   # cat cpuset.cpus
>   0-1
>   # cat cpuset.effective_cpus
>   0
> 
> Then online it:
> 
>   # echo 1 > /sys/devices/system/cpu/cpu1/online
>   # cat cpuset.cpus
>   0-1
>   # cat cpuset.effective_cpus
>   0-1
> 
> And cpuset will bring it back to the effective mask.
> 
> This is a behavior change for sane_behavior.

It'd be great if the patch description also explains "how".

> +static void hotplug_update_tasks_insane(struct cpuset *cs,
> +					struct cpumask *off_cpus,
> +					nodemask_t *off_mems)
> +{
> +	bool is_empty;
> +
> +	cpumask_andnot(off_cpus, cs->real_cpus_allowed,
> +		       top_cpuset.real_cpus_allowed);
> +	nodes_andnot(*off_mems, cs->real_mems_allowed,
> +		     top_cpuset.real_mems_allowed);
> +
> +	mutex_lock(&callback_mutex);
> +	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, off_cpus);
> +	cpumask_andnot(cs->real_cpus_allowed, cs->real_cpus_allowed, off_cpus);
> +	nodes_andnot(cs->mems_allowed, cs->mems_allowed, *off_mems);
> +	nodes_andnot(cs->real_mems_allowed, cs->real_mems_allowed, *off_mems);
> +	mutex_unlock(&callback_mutex);
> +
> +	/*
> +	 * Don't call update_tasks_cpumask() if the cpuset becomes empty,
> +	 * as the tasks will be migrated to an ancestor.
> +	 */
> +	if (!cpumask_empty(off_cpus) && !cpumask_empty(cs->cpus_allowed))
> +		update_tasks_cpumask(cs, NULL);
> +
> +	if (!nodes_empty(*off_mems) && !cpumask_empty(cs->cpus_allowed))
> +		update_tasks_nodemask(cs, NULL);
> +
> +	is_empty = cpumask_empty(cs->cpus_allowed) ||
> +		   nodes_empty(cs->mems_allowed);
> +
> +	mutex_unlock(&cpuset_mutex);
> +	/*
> +	 * Move tasks to the nearest ancestor with execution resources,
> +	 * This is full cgroup operation which will also call back into
> +	 * cpuset. Should be don outside any lock.
> +	 */
> +	if (is_empty)
> +		remove_tasks_in_empty_cpuset(cs);
> +	mutex_lock(&cpuset_mutex);
> +}

Maybe the patch would be easier to follow if factoring out the above
was in a separate patch?

Thanks.

-- 
tejun
