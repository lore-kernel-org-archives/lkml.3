Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaBGLvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42245 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaBGLvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 174/233] memcg: fix endless loop caused by mem_cgroup_iter
Date: Fri,  7 Feb 2014 11:46:33 +0000
Message-Id: <1391773652-25214-175-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Hocko <mhocko@suse.cz>

commit ecc736fc3c71c411a9d201d8588c9e7e049e5d8c upstream.

Hugh has reported an endless loop when the hardlimit reclaim sees the
same group all the time.  This might happen when the reclaim races with
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

The issue seemed to be introduced by commit 5f5781619718 ("memcg: relax
memcg iter caching") which has replaced unconditional css_get/css_put by
css_tryget/css_put for the cached iterator.

This patch fixes the issue by skipping css_tryget on the root of the
tree walk in mem_cgroup_iter_load and symmetrically doesn't release it
in mem_cgroup_iter_update.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memcontrol.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b5f353f..bb13089 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1148,7 +1148,15 @@ mem_cgroup_iter_load(struct mem_cgroup_reclaim_iter *iter,
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
@@ -1157,9 +1165,11 @@ mem_cgroup_iter_load(struct mem_cgroup_reclaim_iter *iter,
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
@@ -1234,7 +1244,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 		memcg = __mem_cgroup_iter_next(root, last_visited);
 
 		if (reclaim) {
-			mem_cgroup_iter_update(iter, last_visited, memcg, seq);
+			mem_cgroup_iter_update(iter, last_visited, memcg, root,
+					seq);
 
 			if (!memcg)
 				iter->generation++;
-- 
1.8.3.2

