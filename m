Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab3LDPka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:40:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab3LDPk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:40:29 -0500
Date: Wed, 4 Dec 2013 16:40:27 +0100
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
Subject: Re: [PATCH v2 4/4] oom_kill: add rcu_read_lock() into
 find_lock_task_mm()
Message-ID: <20131204154027.GI8410@dhcp22.suse.cz>
References: <20131204130351.GA5984@redhat.com>
 <20131204130420.GA6017@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204130420.GA6017@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04-12-13 14:04:20, Oleg Nesterov wrote:
> find_lock_task_mm() expects it is called under rcu or tasklist lock,
> but it seems that at least oom_unkillable_task()->task_in_mem_cgroup()
> and mem_cgroup_out_of_memory()->oom_badness() can call it lockless.
> 
> Perhaps we could fix the callers, but this patch simply adds rcu lock
> into find_lock_task_mm(). This also allows to simplify a bit one of its
> callers, oom_kill_process().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!
> ---
>  mm/oom_kill.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 0d8ad1e..054ff47 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -102,14 +102,19 @@ struct task_struct *find_lock_task_mm(struct task_struct *p)
>  {
>  	struct task_struct *t;
>  
> +	rcu_read_lock();
> +
>  	for_each_thread(p, t) {
>  		task_lock(t);
>  		if (likely(t->mm))
> -			return t;
> +			goto found;
>  		task_unlock(t);
>  	}
> +	t = NULL;
> +found:
> +	rcu_read_unlock();
>  
> -	return NULL;
> +	return t;
>  }
>  
>  /* return true if the task is not adequate as candidate victim task. */
> @@ -461,10 +466,8 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	}
>  	read_unlock(&tasklist_lock);
>  
> -	rcu_read_lock();
>  	p = find_lock_task_mm(victim);
>  	if (!p) {
> -		rcu_read_unlock();
>  		put_task_struct(victim);
>  		return;
>  	} else if (victim != p) {
> @@ -490,6 +493,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	 * That thread will now get access to memory reserves since it has a
>  	 * pending fatal signal.
>  	 */
> +	rcu_read_lock();
>  	for_each_process(p)
>  		if (p->mm == mm && !same_thread_group(p, victim) &&
>  		    !(p->flags & PF_KTHREAD)) {
> -- 
> 1.5.5.1
> 

-- 
Michal Hocko
SUSE Labs
