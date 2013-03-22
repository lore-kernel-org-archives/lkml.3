Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3CVIH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:07:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3CVIHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:07:53 -0400
Date: Fri, 22 Mar 2013 09:07:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Message-ID: <20130322080749.GB31457@dhcp22.suse.cz>
References: <514A60CD.60208@huawei.com>
 <20130321090849.GF6094@dhcp22.suse.cz>
 <20130321102257.GH6094@dhcp22.suse.cz>
 <514BB23E.70908@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514BB23E.70908@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-03-13 09:22:06, Li Zefan wrote:
> On 2013/3/21 18:22, Michal Hocko wrote:
> > On Thu 21-03-13 10:08:49, Michal Hocko wrote:
> >> On Thu 21-03-13 09:22:21, Li Zefan wrote:
> >>> As cgroup supports rename, it's unsafe to dereference dentry->d_name
> >>> without proper vfs locks. Fix this by using cgroup_name().
> >>>
> >>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> >>> ---
> >>>
> >>> This patch depends on "cgroup: fix cgroup_path() vs rename() race",
> >>> which has been queued for 3.10.
> >>>
> >>> ---
> >>>  mm/memcontrol.c | 15 +++++++--------
> >>>  1 file changed, 7 insertions(+), 8 deletions(-)
> >>>
> >>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >>> index 53b8201..72be5c9 100644
> >>> --- a/mm/memcontrol.c
> >>> +++ b/mm/memcontrol.c
> >>> @@ -3217,17 +3217,16 @@ void mem_cgroup_destroy_cache(struct kmem_cache *cachep)
> >>>  static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
> >>>  {
> >>>  	char *name;
> >>> -	struct dentry *dentry;
> >>> +
> >>> +	name = (char *)__get_free_page(GFP_TEMPORARY);
> >>
> >> Ouch. Can we use a static temporary buffer instead?
> > 
> >> This is called from workqueue context so we do not have to be afraid
> >> of the deep call chain.
> > 
> > Bahh, I was thinking about two things at the same time and that is how
> > it ends... I meant a temporary buffer on the stack. But a separate
> > allocation sounds even easier.
> > 
> 
> Actually I don't care much about which way to take. Use on-stack buffer (if stack
> usage is not a concern) or local static buffer (caller already held memcg_cache_mutex)
> is simplest.
> 
> But why it's bad to allocate a page for temp use?

GFP_TEMPORARY groups short lived allocations but the mem cache is not
an ideal candidate of this type of allocations..

> >> It is also not a hot path AFAICS.
> >>
> >> Even GFP_ATOMIC for kasprintf would be an improvement IMO.
> > 
> > What about the following (not even compile tested because I do not have
> > cgroup_name in my tree yet):
> 
> No, it won't compile. ;)

Somehow expected so as this was just a quick hack to show what I meant.
The full patch is bellow (compile time tested on top of for-3.10 branch
this time :P)
---
>From 7e1f6f0e266a230ced238a9bf2398b4069a6a764 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 22 Mar 2013 09:04:58 +0100
Subject: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()

As cgroup supports rename, it's unsafe to dereference dentry->d_name
without proper vfs locks. Fix this by using cgroup_name().

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 53b8201..5741bf5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3220,13 +3220,18 @@ static char *memcg_cache_name(struct mem_cgroup *memcg, struct kmem_cache *s)
 	struct dentry *dentry;
 
 	rcu_read_lock();
-	dentry = rcu_dereference(memcg->css.cgroup->dentry);
+	name = kasprintf(GFP_ATOMIC, "%s(%d:%s)", s->name,
+			 memcg_cache_id(memcg), dcgroup_name(memcg->css.cgroup));
 	rcu_read_unlock();
 
-	BUG_ON(dentry == NULL);
+	if (!name) {
+		name = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		rcu_read_lock();
+		name = snprintf(name, PAGE_SIZE, "%s(%d:%s)", s->name,
+				 memcg_cache_id(memcg), dcgroup_name(memcg->css.cgroup));
+		rcu_read_unlock();
 
-	name = kasprintf(GFP_KERNEL, "%s(%d:%s)", s->name,
-			 memcg_cache_id(memcg), dentry->d_name.name);
+	}
 
 	return name;
 }
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
