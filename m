Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbaJXOtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:49:14 -0400
Received: from mx2.parallels.com ([199.115.105.18]:46924 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaJXOtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:49:12 -0400
Date: Fri, 24 Oct 2014 18:49:03 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] mm: memcontrol: pull the NULL check from
 __mem_cgroup_same_or_subtree()
Message-ID: <20141024144903.GB28055@esperanza>
References: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
 <1414158589-26094-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1414158589-26094-2-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 09:49:48AM -0400, Johannes Weiner wrote:
> The NULL in mm_match_cgroup() comes from a possibly exiting mm->owner.
> It makes a lot more sense to check where it's looked up, rather than
> check for it in __mem_cgroup_same_or_subtree() where it's unexpected.
> 
> No other callsite passes NULL to __mem_cgroup_same_or_subtree().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>

> ---
>  include/linux/memcontrol.h | 5 +++--
>  mm/memcontrol.c            | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ea007615e8f9..e32ab948f589 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -83,11 +83,12 @@ static inline
>  bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
>  {
>  	struct mem_cgroup *task_memcg;
> -	bool match;
> +	bool match = false;
>  
>  	rcu_read_lock();
>  	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
> -	match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
> +	if (task_memcg)
> +		match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
>  	rcu_read_unlock();
>  	return match;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bdf8520979cf..15b1c5110a8f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1316,7 +1316,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
>  {
>  	if (root_memcg == memcg)
>  		return true;
> -	if (!root_memcg->use_hierarchy || !memcg)
> +	if (!root_memcg->use_hierarchy)
>  		return false;
>  	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
>  }
> -- 
> 2.1.2
> 
