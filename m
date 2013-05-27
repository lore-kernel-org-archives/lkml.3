Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3E0ROJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:14:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab3E0RNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:13:40 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3/3] memcg: Track all children over limit in the root
Date: Mon, 27 May 2013 19:13:11 +0200
Message-Id: <1369674791-13861-4-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369674791-13861-1-git-send-email-mhocko@suse.cz>
References: <20130517160247.GA10023@cmpxchg.org>
 <1369674791-13861-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Children in soft limit excess are currently tracked up the hierarchy
in memcg->children_in_excess. Nevertheless there still might exist
tons of groups that are not in hierarchy relation to the root cgroup
(e.g. all first level groups if root_mem_cgroup->use_hierarchy ==
false).

As the whole tree walk has to be done when the iteration starts at
root_mem_cgroup the iterator should be able to skip the walk if there
is no child above the limit without iterating them. This can be done
easily if the root tracks all children rather than only hierarchical
children. This is done by this patch which updates root_mem_cgroup
children_in_excess if root_mem_cgroup->use_hierarchy == false so the
root knows about all children in excess.

Please note that this is not an issue for inner memcgs which have
use_hierarchy == false because then only the single group is visited so
no special optimization is necessary.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 592df10..7fb063f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -932,9 +932,15 @@ static void mem_cgroup_update_soft_limit(struct mem_cgroup *memcg)
 	/*
 	 * Necessary to update all ancestors when hierarchy is used
 	 * because their event counter is not touched.
+	 * We track children even outside the hierarchy for the root
+	 * cgroup because tree walk starting at root should visit
+	 * all cgroups and we want to prevent from pointless tree
+	 * walk if no children is below the limit.
 	 */
 	while (delta && (parent = parent_mem_cgroup(parent)))
 		atomic_add(delta, &parent->children_in_excess);
+	if (memcg != root_mem_cgroup && !root_mem_cgroup->use_hierarchy)
+		atomic_add(delta, &root_mem_cgroup->children_in_excess);
 	spin_unlock(&memcg->soft_lock);
 }
 
@@ -6200,6 +6206,9 @@ static void mem_cgroup_css_offline(struct cgroup *cont)
 	if (memcg->soft_contributed) {
 		while ((memcg = parent_mem_cgroup(memcg)))
 			atomic_dec(&memcg->children_in_excess);
+
+		if (memcg != root_mem_cgroup && !root_mem_cgroup->use_hierarchy)
+			atomic_dec(&root_mem_cgroup->children_in_excess);
 	}
 	mem_cgroup_destroy_all_caches(memcg);
 }
-- 
1.7.10.4

