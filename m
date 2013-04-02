Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3DBO23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:28:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761319Ab3DBO20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:28:26 -0400
Date: Tue, 2 Apr 2013 16:28:25 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] memcg: don't do cleanup manually if
 mem_cgroup_css_online() fails
Message-ID: <20130402142825.GA32520@dhcp22.suse.cz>
References: <515A8A40.6020406@huawei.com>
 <20130402121600.GK24345@dhcp22.suse.cz>
 <20130402141646.GQ24345@dhcp22.suse.cz>
 <515AE948.1000704@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515AE948.1000704@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-04-13 18:20:56, Glauber Costa wrote:
> On 04/02/2013 06:16 PM, Michal Hocko wrote:
> >  mem_cgroup_css_online
> >       memcg_init_kmem
> >         mem_cgroup_get		# refcnt = 2
> >           memcg_update_all_caches
> >             memcg_update_cache_size	# fails with ENOMEM
> 
> Here is the thing: this one in kmem only happens for kmem enabled
> memcgs. For those, we tend to do a get once, and put only when the last
> kmem reference is gone.
> 
> For non-kmem memcgs, refcnt will be 1 here, and will be balanced out by
> the mem_cgroup_put() in css_free.

So we need this, right?
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f608546..2ef875d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5306,6 +5306,8 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
 	ret = memcg_update_cache_sizes(memcg);
 	mutex_unlock(&set_limit_mutex);
 out:
+	if (ret)
+		mem_cgroup_put(memcg);
 	return ret;
 }
 #endif /* CONFIG_MEMCG_KMEM */
@@ -6417,16 +6419,6 @@ mem_cgroup_css_online(struct cgroup *cont)
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
 	mutex_unlock(&memcg_create_mutex);
-	if (error) {
-		/*
-		 * We call put now because our (and parent's) refcnts
-		 * are already in place. mem_cgroup_put() will internally
-		 * call __mem_cgroup_free, so return directly
-		 */
-		mem_cgroup_put(memcg);
-		if (parent->use_hierarchy)
-			mem_cgroup_put(parent);
-	}
 	return error;
 }
 
-- 
Michal Hocko
SUSE Labs
