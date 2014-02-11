Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbaBKVL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:11:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaBKTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:04:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 016/120] memcg: fix endless loop caused by mem_cgroup_iter
Date: Tue, 11 Feb 2014 11:04:17 -0800
Message-Id: <20140211184823.994027051@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1139,7 +1139,15 @@ mem_cgroup_iter_load(struct mem_cgroup_r
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
@@ -1148,9 +1156,11 @@ mem_cgroup_iter_load(struct mem_cgroup_r
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
@@ -1225,7 +1235,8 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		memcg = __mem_cgroup_iter_next(root, last_visited);
 
 		if (reclaim) {
-			mem_cgroup_iter_update(iter, last_visited, memcg, seq);
+			mem_cgroup_iter_update(iter, last_visited, memcg, root,
+					seq);
 
 			if (!memcg)
 				iter->generation++;


