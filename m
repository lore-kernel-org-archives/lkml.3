Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaAUKqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:46:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbaAUKp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:45:58 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 1/2] memcg: fix endless loop caused by mem_cgroup_iter
Date: Tue, 21 Jan 2014 11:45:42 +0100
Message-Id: <1390301143-9541-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <20140121083454.GA1894@dhcp22.suse.cz>
References: <20140121083454.GA1894@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh has reported an endless loop when the hardlimit reclaim sees the
same group all the time. This might happen when the reclaim races with
the memcg removal.

shrink_zone
                                                [rmdir root]
  mem_cgroup_iter(root, NULL, reclaim)
    // prev = NULL
    rcu_read_lock()
    mem_cgroup_iter_load
      last_visited = iter->last_visited   // gets root || NULL
      css_tryget(last_visited)            // failed
      last_visited = NULL                 [1]
    memcg = root = __mem_cgroup_iter_next(root, NULL)
    mem_cgroup_iter_update
      iter->last_visited = root;
    reclaim->generation = iter->generation

 mem_cgroup_iter(root, root, reclaim)
   // prev = root
   rcu_read_lock
    mem_cgroup_iter_load
      last_visited = iter->last_visited   // gets root
      css_tryget(last_visited)            // failed
    [1]

The issue seemed to be introduced by 5f5781619718 (memcg: relax memcg
iter caching) which has replaced unconditional css_get/css_put by
css_tryget/css_put for the cached iterator.

This patch fixes the issue by skipping css_tryget on the root of the
tree walk in mem_cgroup_iter_load and symmetrically doesn't release it
in mem_cgroup_iter_update.

Stable: stable@vger.kernel.org # 3.10+
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f016d26adfd3..45786dc129dc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1117,7 +1117,15 @@ mem_cgroup_iter_load(struct mem_cgroup_reclaim_iter *iter,
 	if (iter->last_dead_count == *sequence) {
 		smp_rmb();
 		position = iter->last_visited;
-		if (position && !css_tryget(&position->css))
+
+		/*
+		 * We cannot take a reference to root because we might race
+		 * with root removal and returning NULL would end up in
+		 * an endless loop on the iterator user level when root
+		 * would be returned all the time.
+		 */
+		if (position && position != root &&
+				!css_tryget(&position->css))
 			position = NULL;
 	}
 	return position;
@@ -1126,9 +1134,11 @@ mem_cgroup_iter_load(struct mem_cgroup_reclaim_iter *iter,
 static void mem_cgroup_iter_update(struct mem_cgroup_reclaim_iter *iter,
 				   struct mem_cgroup *last_visited,
 				   struct mem_cgroup *new_position,
+				   struct mem_cgroup *root,
 				   int sequence)
 {
-	if (last_visited)
+	/* root reference counting symmetric to mem_cgroup_iter_load */
+	if (last_visited && last_visited != root)
 		css_put(&last_visited->css);
 	/*
 	 * We store the sequence count from the time @last_visited was
@@ -1203,7 +1213,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		memcg = __mem_cgroup_iter_next(root, last_visited);
 
 		if (reclaim) {
-			mem_cgroup_iter_update(iter, last_visited, memcg, seq);
+			mem_cgroup_iter_update(iter, last_visited, memcg, root,
+					seq);
 
 			if (!memcg)
 				iter->generation++;
-- 
1.8.5.2

