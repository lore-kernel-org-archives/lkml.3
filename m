Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935298Ab3DHSK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:10:56 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:41526 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934624Ab3DHSKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:10:54 -0400
Date: Mon, 8 Apr 2013 20:03:44 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/8] cgroup: implement cgroup_is_ancestor()
Message-ID: <20130408180335.GA22512@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
 <51627DBB.5050005@huawei.com>
 <20130408144750.GK17178@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408144750.GK17178@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 08-04-13 16:47:50, Michal Hocko wrote:
> On Mon 08-04-13 16:20:11, Li Zefan wrote:
> [...]
> > @@ -5299,6 +5300,26 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
> >  	return css ? css : ERR_PTR(-ENOENT);
> >  }
> >  
> > +/**
> > + * cgroup_is_ancestor - test "root" cgroup is an ancestor of "child"
> > + * @child: the cgroup to be tested.
> > + * @root: the cgroup supposed to be an ancestor of the child.
> > + *
> > + * Returns true if "root" is an ancestor of "child" in its hierarchy.
> > + */
> > +bool cgroup_is_ancestor(struct cgroup *child, struct cgroup *root)
> > +{
> > +	int depth = child->depth;
> 
> Is this functionality helpful for other controllers but memcg?
> css_is_ancestor is currently used only by memcg code AFAICS and we can
> get the same functionality easily by using something like:

And as it turned out using css_is_ancestor is not correct. Here
is a patch to fix the issue. I will leave the decision whether
cgroup_is_ancestor makes sense even without users to you.
Would you be willing to take this into your current series so that we to
not clash over that code?
---
>From 684e90bf2fcd5e0f376a3c7bb0176c1267add7df Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 8 Apr 2013 19:46:34 +0200
Subject: [PATCH] memcg: fix __mem_cgroup_same_or_subtree

__mem_cgroup_same_or_subtree relies on css_is_ancestor if hierarchy is
enabled for ages. This, however, is not correct because use_hierarchy
doesn't need to be true all the way up the cgroup hierarchy. Consider
the following example:
root (use_hierarchy=0)
 \
  A (use_hierarchy=0)
   \
    B (use_hierarchy=1)
     \
      C (use_hierarchy=1)

__mem_cgroup_same_or_subtree(A, C) would return true even though C is
not from the same hierarchy subtree. The bug shouldn't be critical but
at least dump_tasks might print unrelated tasks (via
task_in_mem_cgroup).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f608546..177bec2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1470,9 +1470,12 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 {
 	if (root_memcg == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy || !memcg)
+	if (!memcg)
 		return false;
-	return css_is_ancestor(&memcg->css, &root_memcg->css);
+	while ((memcg = parent_mem_cgroup(memcg)))
+		if (memcg == root_memcg)
+			return true;
+	return false;
 }
 
 static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
