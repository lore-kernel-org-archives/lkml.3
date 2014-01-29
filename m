Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaA2MJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:09:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaA2MJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:09:09 -0500
Date: Wed, 29 Jan 2014 13:09:07 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] cgroup: remove cgroup->name
Message-ID: <20140129120907.GA22183@dhcp22.suse.cz>
References: <1390953585-16554-1-git-send-email-tj@kernel.org>
 <1390953585-16554-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390953585-16554-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28-01-14 18:59:43, Tejun Heo wrote:
> cgroup->name handling became quite complicated over time involving
> dedicated struct cgroup_name for RCU protection.  Now that cgroup is
> on kernfs, we can drop all of it and simply use kernfs_name/path() and
> friends.  Replace cgroup->name and all related code with kernfs
> name/path constructs.
> 
> * Reimplement cgroup_name() and cgroup_path() as thin wrappers on top
>   of kernfs counterparts, which involves semantic changes.
>   pr_cont_cgroup_name() and pr_cont_cgroup_path() added.
> 
> * cgroup->name handling dropped from cgroup_rename().
> 
> * All users of cgroup_name/path() updated to the new semantics.  Users
>   which were formatting the string just to printk them are converted
>   to use pr_cont_cgroup_name/path() instead, which simplifies things
>   quite a bit.  As cgroup_name() no longer requires RCU read lock
>   around it, RCU lockings which were protecting only cgroup_name() are
>   removed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Nice. I hated the way how we retrieved the name previously.
Acked-by: Michal Hocko <mhocko@suse.cz>

Btw. after this change we should drop part of the comment above
oom_info_lock:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 19d5d4274e22..d998baec5deb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1684,8 +1684,7 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
 void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
 	/*
-	 * protects memcg_name and makes sure that parallel ooms do not
-	 * interleave
+	 * Makes sure that parallel ooms do not interleave
 	 */
 	static DEFINE_SPINLOCK(oom_info_lock);
 	struct cgroup *task_cgrp;
-- 
Michal Hocko
SUSE Labs
