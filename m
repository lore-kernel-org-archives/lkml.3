Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3DIEJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 00:09:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56020 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3DIEI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 00:08:58 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <51639446.6000205@jp.fujitsu.com>
Date: Tue, 09 Apr 2013 13:08:38 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/8] cgroup: implement cgroup_from_id()
References: <51627DA9.7020507@huawei.com> <51627DEB.4090104@huawei.com>
In-Reply-To: <51627DEB.4090104@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/08 17:20), Li Zefan wrote:
> This will be used as a replacement for css_lookup().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>   include/linux/cgroup.h |  1 +
>   kernel/cgroup.c        | 31 +++++++++++++++++++++++++------
>   2 files changed, 26 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 96072e4..6ae8ae1 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -732,6 +732,7 @@ unsigned short css_depth(struct cgroup_subsys_state *css);
>   struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
>   
>   bool cgroup_is_ancestor(struct cgroup *child, struct cgroup *root);
> +struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id);
>   
>   #else /* !CONFIG_CGROUPS */
>   
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index e87872c..5ae1e87 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -139,7 +139,7 @@ struct cgroupfs_root {
>   	unsigned long flags;
>   
>   	/* IDs for cgroups in this hierarchy */
> -	struct ida cgroup_ida;
> +	struct idr cgroup_idr;
>   
>   	/* The path to use for release notifications. */
>   	char release_agent_path[PATH_MAX];
> @@ -908,7 +908,7 @@ static void cgroup_free_fn(struct work_struct *work)
>   
>   	simple_xattrs_free(&cgrp->xattrs);
>   
> -	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
> +	idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
>   	kfree(rcu_dereference_raw(cgrp->name));
>   	kfree(cgrp);
>   }
> @@ -1512,7 +1512,8 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
>   
>   	root->subsys_mask = opts->subsys_mask;
>   	root->flags = opts->flags;
> -	ida_init(&root->cgroup_ida);
> +	idr_init(&root->cgroup_idr);
> +
>   	if (opts->release_agent)
>   		strcpy(root->release_agent_path, opts->release_agent);
>   	if (opts->name)
> @@ -1531,7 +1532,7 @@ static void cgroup_drop_root(struct cgroupfs_root *root)
>   	spin_lock(&hierarchy_id_lock);
>   	ida_remove(&hierarchy_ida, root->hierarchy_id);
>   	spin_unlock(&hierarchy_id_lock);
> -	ida_destroy(&root->cgroup_ida);
> +	idr_destroy(&root->cgroup_idr);
>   	kfree(root);
>   }
>   
> @@ -1645,6 +1646,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>   		mutex_lock(&cgroup_mutex);
>   		mutex_lock(&cgroup_root_mutex);
>   
> +		root_cgrp->id = idr_alloc(&root->cgroup_idr, root_cgrp,
> +					  0, 0, GFP_KERNEL);
> +		if (root_cgrp->id < 0)
> +			goto unlock_drop;

Ah. hmm, I'm sorry but css ID is allocated from "1" and 0 was an invalid number.
With this change, root cgroup will have 0.
If this change is intentional, please add comments in Changelog.
IIRC, swap_cgroup treats 0 as "unused" (root_memcg doesn't account anything...
so, I guess we'll not see troubles.) we need double check.

Thanks,
-Kame





