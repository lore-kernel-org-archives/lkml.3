Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998Ab3DCJct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 05:32:49 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:50477 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761927Ab3DCJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:32:48 -0400
Message-ID: <515BF737.7070105@huawei.com>
Date: Wed, 3 Apr 2013 17:32:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <tj@kernel.org>
Subject: Re: [PATCH cpuset] Use rebuild_sched_domains() in cpuset_hotplug_workfn()
References: <1364886990.5859.12.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1364886990.5859.12.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/2 15:16, Li Zhong wrote:
> In cpuset_hotplug_workfn(), partition_sched_domains() is called without
> hotplug lock held, which is actually needed (stated in the function
> header of partition_sched_domains()). 
> 
> This patch tries to use rebuild_sched_domains() to solve the above
> issue, and makes the code looks a little simpler.
> 

I guess you found this just by code inspection, right?

The change looks fine and safe at a first glance, but we don't have
time to review the patch for now.

However I don't know why partition_sched_domains() has to be called
with hotplug lock held.

After a quick scan, seems the only place in partition_sched_domains()
that might need hotplug lock is arch_update_cpu_topology().

It would be better if you had CCed the scheduler guys...They may
know the answer.

> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> ---
>  kernel/cpuset.c |   13 ++-----------
>  1 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 4f9dfe4..515a713 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2222,17 +2222,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>  	flush_workqueue(cpuset_propagate_hotplug_wq);
>  
>  	/* rebuild sched domains if cpus_allowed has changed */
> -	if (cpus_updated) {
> -		struct sched_domain_attr *attr;
> -		cpumask_var_t *doms;
> -		int ndoms;
> -
> -		mutex_lock(&cpuset_mutex);
> -		ndoms = generate_sched_domains(&doms, &attr);
> -		mutex_unlock(&cpuset_mutex);
> -
> -		partition_sched_domains(ndoms, doms, attr);
> -	}
> +	if (cpus_updated)
> +		rebuild_sched_domains();
>  }
>  


