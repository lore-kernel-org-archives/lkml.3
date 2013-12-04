Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab3LDPhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:37:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932591Ab3LDPhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:37:09 -0500
Date: Wed, 4 Dec 2013 16:37:06 +0100
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
Subject: Re: [PATCH v2 2/4] oom_kill: change oom_kill.c to use
 for_each_thread()
Message-ID: <20131204153706.GG8410@dhcp22.suse.cz>
References: <20131204130351.GA5984@redhat.com>
 <20131204130412.GA6005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204130412.GA6005@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04-12-13 14:04:12, Oleg Nesterov wrote:
> Change oom_kill.c to use for_each_thread() rather than the racy
> while_each_thread() which can loop forever if we race with exit.
> 
> Note also that most users were buggy even if while_each_thread()
> was fine, the task can exit even _before_ rcu_read_lock().
> 
> Fortunately the new for_each_thread() only requires the stable
> task_struct, so this change fixes both problems.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-and-Tested-by: Sergey Dyasly <dserrg@gmail.com>
> Reviewed-by: Sameer Nanda <snanda@chromium.org>

Looks good to me
Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!
> ---
>  mm/oom_kill.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 1e4a600..96d7945 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -59,7 +59,7 @@ static bool has_intersects_mems_allowed(struct task_struct *tsk,
>  {
>  	struct task_struct *start = tsk;
>  
> -	do {
> +	for_each_thread(start, tsk) {
>  		if (mask) {
>  			/*
>  			 * If this is a mempolicy constrained oom, tsk's
> @@ -77,7 +77,7 @@ static bool has_intersects_mems_allowed(struct task_struct *tsk,
>  			if (cpuset_mems_allowed_intersects(current, tsk))
>  				return true;
>  		}
> -	} while_each_thread(start, tsk);
> +	}
>  
>  	return false;
>  }
> @@ -97,14 +97,14 @@ static bool has_intersects_mems_allowed(struct task_struct *tsk,
>   */
>  struct task_struct *find_lock_task_mm(struct task_struct *p)
>  {
> -	struct task_struct *t = p;
> +	struct task_struct *t;
>  
> -	do {
> +	for_each_thread(p, t) {
>  		task_lock(t);
>  		if (likely(t->mm))
>  			return t;
>  		task_unlock(t);
> -	} while_each_thread(p, t);
> +	}
>  
>  	return NULL;
>  }
> @@ -301,7 +301,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  	unsigned long chosen_points = 0;
>  
>  	rcu_read_lock();
> -	do_each_thread(g, p) {
> +	for_each_process_thread(g, p) {
>  		unsigned int points;
>  
>  		switch (oom_scan_process_thread(p, totalpages, nodemask,
> @@ -323,7 +323,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  			chosen = p;
>  			chosen_points = points;
>  		}
> -	} while_each_thread(g, p);
> +	}
>  	if (chosen)
>  		get_task_struct(chosen);
>  	rcu_read_unlock();
> @@ -406,7 +406,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  {
>  	struct task_struct *victim = p;
>  	struct task_struct *child;
> -	struct task_struct *t = p;
> +	struct task_struct *t;
>  	struct mm_struct *mm;
>  	unsigned int victim_points = 0;
>  	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
> @@ -437,7 +437,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	 * still freeing memory.
>  	 */
>  	read_lock(&tasklist_lock);
> -	do {
> +	for_each_thread(p, t) {
>  		list_for_each_entry(child, &t->children, sibling) {
>  			unsigned int child_points;
>  
> @@ -455,7 +455,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  				get_task_struct(victim);
>  			}
>  		}
> -	} while_each_thread(p, t);
> +	}
>  	read_unlock(&tasklist_lock);
>  
>  	rcu_read_lock();
> -- 
> 1.5.5.1
> 

-- 
Michal Hocko
SUSE Labs
