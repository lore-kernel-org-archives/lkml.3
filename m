Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab3LDPhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:37:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525Ab3LDPhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:37:54 -0500
Date: Wed, 4 Dec 2013 16:37:53 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] oom_kill: has_intersects_mems_allowed() needs
 rcu_read_lock()
Message-ID: <20131204153753.GH8410@dhcp22.suse.cz>
References: <20131204130351.GA5984@redhat.com>
 <20131204130416.GA6014@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204130416.GA6014@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04-12-13 14:04:16, Oleg Nesterov wrote:
> At least out_of_memory() calls has_intersects_mems_allowed()
> without even rcu_read_lock(), this is obviously buggy.
> 
> Add the necessary rcu_read_lock(). This means that we can not
> simply return from the loop, we need "bool ret" and "break".
> 
> While at it, swap the names of task_struct's (the argument and
> the local). This cleanups the code a little bit and avoids the
> unnecessary initialization.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-and-Tested-by: Sergey Dyasly <dserrg@gmail.com>
> Reviewed-by: Sameer Nanda <snanda@chromium.org>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!
> ---
>  mm/oom_kill.c |   19 +++++++++++--------
>  1 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 96d7945..0d8ad1e 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -47,18 +47,20 @@ static DEFINE_SPINLOCK(zone_scan_lock);
>  #ifdef CONFIG_NUMA
>  /**
>   * has_intersects_mems_allowed() - check task eligiblity for kill
> - * @tsk: task struct of which task to consider
> + * @start: task struct of which task to consider
>   * @mask: nodemask passed to page allocator for mempolicy ooms
>   *
>   * Task eligibility is determined by whether or not a candidate task, @tsk,
>   * shares the same mempolicy nodes as current if it is bound by such a policy
>   * and whether or not it has the same set of allowed cpuset nodes.
>   */
> -static bool has_intersects_mems_allowed(struct task_struct *tsk,
> +static bool has_intersects_mems_allowed(struct task_struct *start,
>  					const nodemask_t *mask)
>  {
> -	struct task_struct *start = tsk;
> +	struct task_struct *tsk;
> +	bool ret = false;
>  
> +	rcu_read_lock();
>  	for_each_thread(start, tsk) {
>  		if (mask) {
>  			/*
> @@ -67,19 +69,20 @@ static bool has_intersects_mems_allowed(struct task_struct *tsk,
>  			 * mempolicy intersects current, otherwise it may be
>  			 * needlessly killed.
>  			 */
> -			if (mempolicy_nodemask_intersects(tsk, mask))
> -				return true;
> +			ret = mempolicy_nodemask_intersects(tsk, mask);
>  		} else {
>  			/*
>  			 * This is not a mempolicy constrained oom, so only
>  			 * check the mems of tsk's cpuset.
>  			 */
> -			if (cpuset_mems_allowed_intersects(current, tsk))
> -				return true;
> +			ret = cpuset_mems_allowed_intersects(current, tsk);
>  		}
> +		if (ret)
> +			break;
>  	}
> +	rcu_read_unlock();
>  
> -	return false;
> +	return ret;
>  }
>  #else
>  static bool has_intersects_mems_allowed(struct task_struct *tsk,
> -- 
> 1.5.5.1
> 

-- 
Michal Hocko
SUSE Labs
