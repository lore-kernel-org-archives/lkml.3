Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbaJXNug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:50:36 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42866 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618AbaJXNt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:49:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/3] mm: memcontrol: pull the NULL check from __mem_cgroup_same_or_subtree()
Date: Fri, 24 Oct 2014 09:49:48 -0400
Message-Id: <1414158589-26094-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
References: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NULL in mm_match_cgroup() comes from a possibly exiting mm->owner.
It makes a lot more sense to check where it's looked up, rather than
check for it in __mem_cgroup_same_or_subtree() where it's unexpected.

No other callsite passes NULL to __mem_cgroup_same_or_subtree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 5 +++--
 mm/memcontrol.c            | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ea007615e8f9..e32ab948f589 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -83,11 +83,12 @@ static inline
 bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *task_memcg;
-	bool match;
+	bool match = false;
 
 	rcu_read_lock();
 	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
+	if (task_memcg)
+		match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
 	rcu_read_unlock();
 	return match;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bdf8520979cf..15b1c5110a8f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1316,7 +1316,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
 {
 	if (root_memcg == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy || !memcg)
+	if (!root_memcg->use_hierarchy)
 		return false;
 	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
 }
-- 
2.1.2

