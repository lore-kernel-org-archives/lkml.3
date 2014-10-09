Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbaJIVOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:14:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59721 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbaJIVMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:12:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 157/163] mm: memcontrol: do not iterate uninitialized memcgs
Date: Thu,  9 Oct 2014 14:03:02 -0700
Message-Id: <1412888588-26755-158-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 2f7dd7a4100ad4affcb141605bef178ab98ccb18 upstream.

The cgroup iterators yield css objects that have not yet gone through
css_online(), but they are not complete memcgs at this point and so the
memcg iterators should not return them.  Commit d8ad30559715 ("mm/memcg:
iteration skip memcgs not yet fully initialized") set out to implement
exactly this, but it uses CSS_ONLINE, a cgroup-internal flag that does
not meet the ordering requirements for memcg, and so the iterator may
skip over initialized groups, or return partially initialized memcgs.

The cgroup core can not reasonably provide a clear answer on whether the
object around the css has been fully initialized, as that depends on
controller-specific locking and lifetime rules.  Thus, introduce a
memcg-specific flag that is set after the memcg has been initialized in
css_online(), and read before mem_cgroup_iter() callers access the memcg
members.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ kamal: Johannes' 3.12 backport applied to 3.13-stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/memcontrol.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a106a2d..6cbf902 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -251,6 +251,9 @@ struct mem_cgroup {
 	/* vmpressure notifications */
 	struct vmpressure vmpressure;
 
+	/* css_online() has been completed */
+	int initialized;
+
 	/*
 	 * the counter to account for mem+swap usage.
 	 */
@@ -1108,9 +1111,23 @@ skip_node:
 	 * skipping css reference should be safe.
 	 */
 	if (next_css) {
-		if ((next_css == &root->css) ||
-		    ((next_css->flags & CSS_ONLINE) && css_tryget(next_css)))
-			return mem_cgroup_from_css(next_css);
+		struct mem_cgroup *memcg = mem_cgroup_from_css(next_css);
+
+		if (next_css == &root->css)
+			return memcg;
+
+		if (css_tryget(next_css)) {
+			if (memcg->initialized) {
+				/*
+				 * Make sure the memcg is initialized:
+				 * mem_cgroup_css_online() orders the the
+				 * initialization against setting the flag.
+				 */
+				smp_rmb();
+				return memcg;
+			}
+			css_put(next_css);
+		}
 
 		prev_css = next_css;
 		goto skip_node;
@@ -6341,6 +6358,16 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
 	mutex_unlock(&memcg_create_mutex);
+
+	if (!error) {
+		/*
+		 * Make sure the memcg is initialized: mem_cgroup_iter()
+		 * orders reading memcg->initialized against its callers
+		 * reading the memcg members.
+		 */
+		smp_wmb();
+		memcg->initialized = 1;
+	}
 	return error;
 }
 
-- 
1.9.1

