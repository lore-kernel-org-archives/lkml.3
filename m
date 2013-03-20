Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779Ab3CTA7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:59:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25942 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab3CTA7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:59:04 -0400
Message-ID: <514909A0.4030808@huawei.com>
Date: Wed, 20 Mar 2013 08:58:08 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.10] cgroup: make cgroup_mutex outer to threadgroup_lock
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org> <513AE918.7020704@huawei.com> <20130319220246.GR3042@htj.dyndns.org>
In-Reply-To: <20130319220246.GR3042@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/20 6:02, Tejun Heo wrote:
> It doesn't make sense to nest cgroup_mutex inside threadgroup_lock
> when it should be outer to most all locks used by all cgroup
> controllers.  It was nested inside threadgroup_lock only because some
> controllers were abusing cgroup_mutex inside controllers leading to
> locking order inversion.
> 
> cgroup_mutex is no longer abused by controllers and can be put outer
> to threadgroup_lock.  Reverse the locking order in
> attach_task_by_pid().
> 

But the code contrast to the changelog. ;)

cgroup_mutex is currently outside of threadgroup_lock, and you're making
it nested inside threadgroup_lock in the code.

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> ---
> Li, can you please ack this?
> 
> Thanks!
> 
>  kernel/cgroup.c |   21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 04fa2ab..24106b8 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2134,17 +2134,13 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
>  	const struct cred *cred = current_cred(), *tcred;
>  	int ret;
>  
> -	if (!cgroup_lock_live_group(cgrp))
> -		return -ENODEV;
> -
>  retry_find_task:
>  	rcu_read_lock();
>  	if (pid) {
>  		tsk = find_task_by_vpid(pid);
>  		if (!tsk) {
>  			rcu_read_unlock();
> -			ret= -ESRCH;
> -			goto out_unlock_cgroup;
> +			return -ESRCH;
>  		}
>  		/*
>  		 * even if we're attaching all tasks in the thread group, we
> @@ -2155,8 +2151,7 @@ retry_find_task:
>  		    !uid_eq(cred->euid, tcred->uid) &&
>  		    !uid_eq(cred->euid, tcred->suid)) {
>  			rcu_read_unlock();
> -			ret = -EACCES;
> -			goto out_unlock_cgroup;
> +			return -EACCES;
>  		}
>  	} else
>  		tsk = current;
> @@ -2170,9 +2165,8 @@ retry_find_task:
>  	 * with no rt_runtime allocated.  Just say no.
>  	 */
>  	if (tsk == kthreadd_task || (tsk->flags & PF_THREAD_BOUND)) {
> -		ret = -EINVAL;
>  		rcu_read_unlock();
> -		goto out_unlock_cgroup;
> +		return -EINVAL;
>  	}
>  
>  	get_task_struct(tsk);
> @@ -2194,13 +2188,14 @@ retry_find_task:
>  		}
>  	}
>  
> -	ret = cgroup_attach_task(cgrp, tsk, threadgroup);
> +	ret = -ENODEV;
> +	if (cgroup_lock_live_group(cgrp)) {
> +		ret = cgroup_attach_task(cgrp, tsk, threadgroup);
> +		cgroup_unlock();
> +	}
>  
>  	threadgroup_unlock(tsk);
> -
>  	put_task_struct(tsk);
> -out_unlock_cgroup:
> -	cgroup_unlock();
>  	return ret;
>  }
>  
> .
> 

