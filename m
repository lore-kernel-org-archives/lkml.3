Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbaCLB3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:29:05 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33953 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbaCLB3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:29:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 6/8] memcg: get_mem_cgroup_from_mm()
Date: Tue, 11 Mar 2014 21:28:32 -0400
Message-Id: <1394587714-6966-7-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of returning NULL from try_get_mem_cgroup_from_mm() when the
mm owner is exiting, just return root_mem_cgroup.  This makes sense
for all callsites and gets rid of some of them having to fallback
manually.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1780e66ec61e..cc7f3ca3ef34 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1071,7 +1071,7 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 	return mem_cgroup_from_css(task_css(p, mem_cgroup_subsys_id));
 }
 
-struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
+struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
 	struct mem_cgroup *memcg = NULL;
 
@@ -1079,7 +1079,7 @@ struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 	do {
 		memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 		if (unlikely(!memcg))
-			break;
+			memcg = root_mem_cgroup;
 	} while (!css_tryget(&memcg->css));
 	rcu_read_unlock();
 	return memcg;
@@ -1475,7 +1475,7 @@ bool task_in_mem_cgroup(struct task_struct *task,
 
 	p = find_lock_task_mm(task);
 	if (p) {
-		curr = try_get_mem_cgroup_from_mm(p->mm);
+		curr = get_mem_cgroup_from_mm(p->mm);
 		task_unlock(p);
 	} else {
 		/*
@@ -1489,8 +1489,6 @@ bool task_in_mem_cgroup(struct task_struct *task,
 			css_get(&curr->css);
 		rcu_read_unlock();
 	}
-	if (!curr)
-		return false;
 	/*
 	 * We should check use_hierarchy of "memcg" not "curr". Because checking
 	 * use_hierarchy of "curr" here make this function true if hierarchy is
@@ -3649,15 +3647,7 @@ __memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
 	if (!current->mm || current->memcg_kmem_skip_account)
 		return true;
 
-	memcg = try_get_mem_cgroup_from_mm(current->mm);
-
-	/*
-	 * very rare case described in mem_cgroup_from_task. Unfortunately there
-	 * isn't much we can do without complicating this too much, and it would
-	 * be gfp-dependent anyway. Just let it go
-	 */
-	if (unlikely(!memcg))
-		return true;
+	memcg = get_mem_cgroup_from_mm(current->mm);
 
 	if (!memcg_can_account_kmem(memcg)) {
 		css_put(&memcg->css);
-- 
1.9.0

