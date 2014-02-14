Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaBNIdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:33:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaBNIdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:33:49 -0500
Date: Fri, 14 Feb 2014 09:33:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 cgroup tree
Message-ID: <20140214083345.GA29814@dhcp22.suse.cz>
References: <20140214153414.b15e54bf5aa61d0e75bacc90@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214153414.b15e54bf5aa61d0e75bacc90@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14-02-14 15:34:14, Stephen Rothwell wrote:
[...]
> diff --cc mm/memcontrol.c
> index d9c6ac1532e6,de1a2aed4954..000000000000
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@@ -1683,25 -1683,54 +1683,25 @@@ static void move_unlock_mem_cgroup(stru
>    */
>   void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>   {
>  -	/*
>  -	 * protects memcg_name and makes sure that parallel ooms do not
>  -	 * interleave
>  -	 */
>  +	/* oom_info_lock ensures that parallel ooms do not interleave */
> - 	static DEFINE_SPINLOCK(oom_info_lock);
> + 	static DEFINE_MUTEX(oom_info_lock);
>  -	struct cgroup *task_cgrp;
>  -	struct cgroup *mem_cgrp;
>  -	static char memcg_name[PATH_MAX];
>  -	int ret;
>   	struct mem_cgroup *iter;
>   	unsigned int i;
>   
>   	if (!p)
>   		return;
>   
> - 	spin_lock(&oom_info_lock);
> + 	mutex_lock(&oom_info_lock);
>   	rcu_read_lock();
>   
>  -	mem_cgrp = memcg->css.cgroup;
>  -	task_cgrp = task_cgroup(p, mem_cgroup_subsys_id);
>  -
>  -	ret = cgroup_path(task_cgrp, memcg_name, PATH_MAX);
>  -	if (ret < 0) {
>  -		/*
>  -		 * Unfortunately, we are unable to convert to a useful name
>  -		 * But we'll still print out the usage information
>  -		 */
>  -		rcu_read_unlock();
>  -		goto done;
>  -	}
>  -	rcu_read_unlock();
>  -
>  -	pr_info("Task in %s killed", memcg_name);
>  +	pr_info("Task in ");
>  +	pr_cont_cgroup_path(task_cgroup(p, memory_cgrp_id));
>  +	pr_info(" killed as a result of limit of ");
>  +	pr_cont_cgroup_path(memcg->css.cgroup);
>  +	pr_info("\n");
>   
>  -	rcu_read_lock();
>  -	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
>  -	if (ret < 0) {
>  -		rcu_read_unlock();
>  -		goto done;
>  -	}
>   	rcu_read_unlock();
>   
>  -	/*
>  -	 * Continues from above, so we don't need an KERN_ level
>  -	 */
>  -	pr_cont(" as a result of limit of %s\n", memcg_name);
>  -done:
>  -
>   	pr_info("memory: usage %llukB, limit %llukB, failcnt %llu\n",
>   		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
>   		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,

I do not see spin_unlock -> mutex_unlock at the very end of this function.


-- 
Michal Hocko
SUSE Labs
