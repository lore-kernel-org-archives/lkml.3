Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab3FEUvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:51:54 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:54477 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab3FEUvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:51:51 -0400
Date: Wed, 5 Jun 2013 13:51:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH v2 08/10] cpuset: allow to keep tasks in empty cpusets
Message-ID: <20130605205146.GI10693@mtj.dyndns.org>
References: <51AF0183.8070602@huawei.com>
 <51AF020B.3030701@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AF020B.3030701@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Jun 05, 2013 at 05:16:59PM +0800, Li Zefan wrote:
> @@ -2092,11 +2183,13 @@ static void cpuset_propagate_hotplug_workfn(struct work_struct *work)
>  	mutex_unlock(&cpuset_mutex);
>  
>  	/*
> -	 * If @cs became empty, move tasks to the nearest ancestor with
> -	 * execution resources.  This is full cgroup operation which will
> +	 * If sane_behavior flag is set, we'll keep tasks in empty cpusets.
> +	 *
> +	 * Otherwise move tasks to the nearest ancestor with execution
> +	 *  resources.  This is full cgroup operation which will
>  	 * also call back into cpuset.  Should be done outside any lock.
>  	 */
> -	if (is_empty)
> +	if (!sane && is_empty)
>  		remove_tasks_in_empty_cpuset(cs);
>  
>  	/* the following may free @cs, should be the last operation */
> @@ -2171,6 +2264,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>  		cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
>  		mutex_unlock(&callback_mutex);
>  		/* we don't mess with cpumasks of tasks in top_cpuset */
> +		update_tasks_cpumask_hier(&top_cpuset, false, NULL);
>  	}

I'm a little confused by the order of operation.  We now have two
different hierarchical walks for hotplug propagation, right?  I
suppose the above one is added because we now also need to update the
mask when cpus are being brought online?

I wonder whether it'd be possible to merge the two paths.  My
suspicion is that we probably don't need propagate_hotplug_work
anymore now that we can drop RCU read lock while doing the pre-order
walk.  What do you think?

Thanks.

-- 
tejun
