Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161239AbaDPVN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:13:29 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58961 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552AbaDPVN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:13:26 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: memcontrol: remove hierarchy restrictions for swappiness and oom_control
Date: Wed, 16 Apr 2014 17:13:18 -0400
Message-Id: <1397682798-22906-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-memcg swappiness and oom killing can currently not be tweaked on a
memcg that is part of a hierarchy, but not the root of that hierarchy.
Users have complained that they can't configure this when they turned
on hierarchy mode.  In fact, with hierarchy mode becoming the default,
this restriction disables the tunables entirely.

But there is no good reason for this restriction.  The settings for
swappiness and OOM killing are taken from whatever memcg whose limit
triggered reclaim and OOM invocation, regardless of its position in
the hierarchy tree.

Allow setting swappiness on any group.  The knob on the root memcg
already reads the global VM swappiness, make it writable as well.

Allow disabling the OOM killer on any non-root memcg.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2a0d3986c74..edcc9513b419 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5548,22 +5548,14 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
 				       struct cftype *cft, u64 val)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
-	if (val > 100 || !parent)
+	if (val > 100)
 		return -EINVAL;
 
-	mutex_lock(&memcg_create_mutex);
-
-	/* If under hierarchy, only empty-root can set this value */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		mutex_unlock(&memcg_create_mutex);
-		return -EINVAL;
-	}
-
-	memcg->swappiness = val;
-
-	mutex_unlock(&memcg_create_mutex);
+	if (css_parent(css))
+		memcg->swappiness = val;
+	else
+		vm_swappiness = val;
 
 	return 0;
 }
@@ -5895,22 +5887,15 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	struct cftype *cft, u64 val)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
-	if (!parent || !((val == 0) || (val == 1)))
+	if (!css_parent(css) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
-	mutex_lock(&memcg_create_mutex);
-	/* oom-kill-disable is a flag for subhierarchy. */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		mutex_unlock(&memcg_create_mutex);
-		return -EINVAL;
-	}
 	memcg->oom_kill_disable = val;
 	if (!val)
 		memcg_oom_recover(memcg);
-	mutex_unlock(&memcg_create_mutex);
+
 	return 0;
 }
 
-- 
1.9.2

