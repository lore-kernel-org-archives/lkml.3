Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936297Ab3DHOZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:25:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935390Ab3DHOZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:25:07 -0400
Date: Mon, 8 Apr 2013 16:25:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 13/12] memcg: don't need memcg->memcg_name
Message-ID: <20130408142503.GH17178@dhcp22.suse.cz>
References: <5162648B.9070802@huawei.com>
 <51626584.7050405@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51626584.7050405@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 08-04-13 14:36:52, Li Zefan wrote:
[...]
> @@ -5188,12 +5154,28 @@ static int mem_cgroup_dangling_read(struct cgroup *cont, struct cftype *cft,
>  					struct seq_file *m)
>  {
>  	struct mem_cgroup *memcg;
> +	char *memcg_name;
> +	int ret;

The interface is only for debugging, all right, but that doesn't mean we
should allocate a buffer for each read. Why cannot we simply use
cgroup_path for seq_printf directly? Can we still race with the group
rename?

> +
> +	/*
> +	 * cgroup.c will do page-sized allocations most of the time,
> +	 * so we'll just follow the pattern. Also, __get_free_pages
> +	 * is a better interface than kmalloc for us here, because
> +	 * we'd like this memory to be always billed to the root cgroup,
> +	 * not to the process removing the memcg. While kmalloc would
> +	 * require us to wrap it into memcg_stop/resume_kmem_account,
> +	 * with __get_free_pages we just don't pass the memcg flag.
> +	 */
> +	memcg_name = (char *)__get_free_pages(GFP_KERNEL, 0);
> +	if (!memcg_name)
> +		return -ENOMEM;
>  
>  	mutex_lock(&dangling_memcgs_mutex);
>  
>  	list_for_each_entry(memcg, &dangling_memcgs, dead) {
> -		if (memcg->memcg_name)
> -			seq_printf(m, "%s:\n", memcg->memcg_name);
> +		ret = cgroup_path(memcg->css.cgroup, memcg_name, PAGE_SIZE);
> +		if (!ret)
> +			seq_printf(m, "%s:\n", memcg_name);
>  		else
>  			seq_printf(m, "%p (name lost):\n", memcg);
>  
> @@ -5203,6 +5185,7 @@ static int mem_cgroup_dangling_read(struct cgroup *cont, struct cftype *cft,
>  	}
>  
>  	mutex_unlock(&dangling_memcgs_mutex);
> +	free_pages((unsigned long)memcg_name, 0);
>  	return 0;
>  }
>  #endif
> -- 
> 1.8.0.2
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
