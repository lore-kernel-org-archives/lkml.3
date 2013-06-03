Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3FCKU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:20:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab3FCKTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:19:15 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>,
        Balbir Singh <bsingharora@gmail.com>
Subject: [patch -v4 6/8] memcg, vmscan: Do not attempt soft limit reclaim if it would not scan anything
Date: Mon,  3 Jun 2013 12:18:53 +0200
Message-Id: <1370254735-13012-7-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem_cgroup_should_soft_reclaim controls whether soft reclaim pass is
done and it always says yes currently. Memcg iterators are clever to
skip nodes that are not soft reclaimable quite efficiently but
mem_cgroup_should_soft_reclaim can be more clever and do not start the
soft reclaim pass at all if it knows that nothing would be scanned
anyway.

In order to do that, simply reuse mem_cgroup_soft_reclaim_eligible for
the target group of the reclaim and allow the pass only if the whole
subtree wouldn't be skipped.

Changes since v1
- do not export mem_cgroup_root and teach mem_cgroup_soft_reclaim_eligible
  to handle NULL memcg as mem_cgroup_root

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |    6 +++++-
 mm/vmscan.c     |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 90495d5..8ff9366 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1941,7 +1941,11 @@ enum mem_cgroup_filter_t
 mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
-	struct mem_cgroup *parent = memcg;
+	struct mem_cgroup *parent;
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+	parent = memcg;
 
 	if (res_counter_soft_limit_excess(&memcg->res))
 		return VISIT;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 10bcbc2..dc78f07 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -142,7 +142,9 @@ static bool global_reclaim(struct scan_control *sc)
 
 static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
 {
-	return !mem_cgroup_disabled();
+	struct mem_cgroup *root = sc->target_mem_cgroup;
+	return !mem_cgroup_disabled() &&
+		mem_cgroup_soft_reclaim_eligible(root, root) != SKIP_TREE;
 }
 #else
 static bool global_reclaim(struct scan_control *sc)
-- 
1.7.10.4

