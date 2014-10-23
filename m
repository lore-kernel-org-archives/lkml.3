Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaJWOmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:42:15 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42761 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbaJWOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:42:13 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: fold mem_cgroup_start_move()/mem_cgroup_end_move()
Date: Thu, 23 Oct 2014 10:42:07 -0400
Message-Id: <1414075327-15039-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having these functions and their documentation split out and somewhere
makes it harder, not easier, to follow what's going on.

Inline them directly where charge moving is prepared and finished, and
put an explanation right next to it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 40 ++++++++++++----------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3cd4f1e0bfb3..5b5c784dc39d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1447,32 +1447,6 @@ int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 }
 
 /*
- * memcg->moving_account is used for checking possibility that some thread is
- * calling move_account(). When a thread on CPU-A starts moving pages under
- * a memcg, other threads should check memcg->moving_account under
- * rcu_read_lock(), like this:
- *
- *         CPU-A                                    CPU-B
- *                                              rcu_read_lock()
- *         memcg->moving_account+1              if (memcg->mocing_account)
- *                                                   take heavy locks.
- *         synchronize_rcu()                    update something.
- *                                              rcu_read_unlock()
- *         start move here.
- */
-
-static void mem_cgroup_start_move(struct mem_cgroup *memcg)
-{
-	atomic_inc(&memcg->moving_account);
-	synchronize_rcu();
-}
-
-static void mem_cgroup_end_move(struct mem_cgroup *memcg)
-{
-	atomic_dec(&memcg->moving_account);
-}
-
-/*
  * A routine for checking "mem" is under move_account() or not.
  *
  * Checking a cgroup is mc.from or mc.to or under hierarchy of
@@ -5431,7 +5405,8 @@ static void mem_cgroup_clear_mc(void)
 	mc.from = NULL;
 	mc.to = NULL;
 	spin_unlock(&mc.lock);
-	mem_cgroup_end_move(from);
+
+	atomic_dec(&memcg->moving_account);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
@@ -5464,7 +5439,16 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
 			VM_BUG_ON(mc.precharge);
 			VM_BUG_ON(mc.moved_charge);
 			VM_BUG_ON(mc.moved_swap);
-			mem_cgroup_start_move(from);
+
+			/*
+			 * Signal mem_cgroup_begin_page_stat() to take
+			 * the memcg's move_lock while we're moving
+			 * its pages to another memcg.  Then wait for
+			 * already started RCU-only updates to finish.
+			 */
+			atomic_inc(&memcg->moving_account);
+			synchronize_rcu();
+
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = memcg;
-- 
2.1.2

