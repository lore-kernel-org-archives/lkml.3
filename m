Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaBJVlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:41:05 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61260 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaBJVk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:40:59 -0500
Date: Mon, 10 Feb 2014 13:40:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] memcg: change oom_info_lock to mutex
In-Reply-To: <1392040082-14303-1-git-send-email-mhocko@suse.cz>
Message-ID: <alpine.DEB.2.02.1402101339580.15624@chino.kir.corp.google.com>
References: <1392040082-14303-1-git-send-email-mhocko@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, Michal Hocko wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 19d5d4274e22..55e6731ebcd5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1687,7 +1687,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  	 * protects memcg_name and makes sure that parallel ooms do not
>  	 * interleave
>  	 */
> -	static DEFINE_SPINLOCK(oom_info_lock);
> +	static DEFINE_MUTEX(oom_info_lock);
>  	struct cgroup *task_cgrp;
>  	struct cgroup *mem_cgrp;
>  	static char memcg_name[PATH_MAX];
> @@ -1698,7 +1698,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  	if (!p)
>  		return;
>  
> -	spin_lock(&oom_info_lock);
> +	mutex_lock(&oom_info_lock);
>  	rcu_read_lock();
>  
>  	mem_cgrp = memcg->css.cgroup;
> @@ -1767,7 +1767,7 @@ done:
>  
>  		pr_cont("\n");
>  	}
> -	spin_unlock(&oom_info_lock);
> +	mutex_unlock(&oom_info_lock);
>  }
>  
>  /*

Can we change oom_info_lock() to only protecting memcg_name and forget 
about interleaving the hierarchical memcg stats instead?
