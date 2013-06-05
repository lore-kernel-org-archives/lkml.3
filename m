Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab3FEWyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:54:20 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:46740 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956Ab3FEWx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:53:58 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/2] mm: memcontrol: fix lockless reclaim hierarchy iterator
Date: Wed,  5 Jun 2013 18:53:45 -0400
Message-Id: <1370472826-29959-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lockless reclaim hierarchy iterator currently has a misplaced
barrier that can lead to use-after-free crashes.

The reclaim hierarchy iterator consist of a sequence count and a
position pointer that are read and written locklessly, with memory
barriers enforcing ordering.

The write side sets the position pointer first, then updates the
sequence count to "publish" the new position.  Likewise, the read side
must read the sequence count first, then the position.  If the
sequence count is up to date, it's guaranteed that the position is up
to date as well:

  writer:                         reader:
  iter->position = position       if iter->sequence == expected:
  smp_wmb()                           smp_rmb()
  iter->sequence = sequence           position = iter->position

However, the read side barrier is currently misplaced, which can lead
to dereferencing stale position pointers that no longer point to valid
memory.  Fix this.

Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@kernel.org [3.10+]
---
 mm/memcontrol.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 010d6c1..e2cbb44 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1199,7 +1199,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 
 			mz = mem_cgroup_zoneinfo(root, nid, zid);
 			iter = &mz->reclaim_iter[reclaim->priority];
-			last_visited = iter->last_visited;
 			if (prev && reclaim->generation != iter->generation) {
 				iter->last_visited = NULL;
 				goto out_unlock;
@@ -1218,13 +1217,12 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 			 * is alive.
 			 */
 			dead_count = atomic_read(&root->dead_count);
-			smp_rmb();
-			last_visited = iter->last_visited;
-			if (last_visited) {
-				if ((dead_count != iter->last_dead_count) ||
-					!css_tryget(&last_visited->css)) {
+			if (dead_count == iter->last_dead_count) {
+				smp_rmb();
+				last_visited = iter->last_visited;
+				if (last_visited &&
+				    !css_tryget(&last_visited->css))
 					last_visited = NULL;
-				}
 			}
 		}
 
-- 
1.8.3

