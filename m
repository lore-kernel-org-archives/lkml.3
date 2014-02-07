Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaBGNpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:45:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaBGNpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:45:34 -0500
Date: Fri, 7 Feb 2014 14:45:33 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Message-ID: <20140207134533.GC5121@dhcp22.suse.cz>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-02-14 15:56:01, Hugh Dickins wrote:
> Sometimes the cleanup after memcg hierarchy testing gets stuck in
> mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.
> 
> There may turn out to be several causes, but a major cause is this: the
> workitem to offline parent can get run before workitem to offline child;
> parent's mem_cgroup_reparent_charges() circles around waiting for the
> child's pages to be reparented to its lrus, but it's holding cgroup_mutex
> which prevents the child from reaching its mem_cgroup_reparent_charges().
> 
> Just use an ordered workqueue for cgroup_destroy_wq.

Hmm, interesting. Markus has seen hangs even with mem_cgroup_css_offline
and the referenced cgroup fixes, maybe this is the the right one
finally.

> Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
> Suggested-by: Filipe Brandenburger <filbranden@google.com>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org # 3.10+

Reviewed-by: Michal Hocko <mhocko@suse.cz>

e5fca243abae was marked for 3.9 stable but I do not see it in the Greg's
3.9 stable branch so 3.10+ seems to be sufficient.

> ---
> 
>  kernel/cgroup.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- 3.14-rc1/kernel/cgroup.c	2014-02-02 18:49:07.737302111 -0800
> +++ linux/kernel/cgroup.c	2014-02-06 15:20:35.548904965 -0800
> @@ -4845,12 +4845,12 @@ static int __init cgroup_wq_init(void)
>  	/*
>  	 * There isn't much point in executing destruction path in
>  	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
> -	 * Use 1 for @max_active.
> +	 * Must be ordered to make sure parent is offlined after children.
>  	 *
>  	 * We would prefer to do this in cgroup_init() above, but that
>  	 * is called before init_workqueues(): so leave this until after.
>  	 */
> -	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
> +	cgroup_destroy_wq = alloc_ordered_workqueue("cgroup_destroy", 0);
>  	BUG_ON(!cgroup_destroy_wq);
>  
>  	/*

-- 
Michal Hocko
SUSE Labs
