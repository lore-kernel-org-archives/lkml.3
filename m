Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaEAIwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 04:52:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbaEAIox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 04:44:53 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/17] mm: page_alloc: Use jump labels to avoid checking number_of_cpusets
Date: Thu,  1 May 2014 09:44:34 +0100
Message-Id: <1398933888-4940-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1398933888-4940-1-git-send-email-mgorman@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cpusets are not in use then we still check a global variable on every
page allocation. Use jump labels to avoid the overhead.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/cpuset.h | 31 +++++++++++++++++++++++++++++++
 kernel/cpuset.c        |  8 ++++++--
 mm/page_alloc.c        |  3 ++-
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index b19d3dc..2b89e07 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -17,6 +17,35 @@
 
 extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 
+#ifdef HAVE_JUMP_LABEL
+extern struct static_key cpusets_enabled_key;
+static inline bool cpusets_enabled(void)
+{
+	return static_key_false(&cpusets_enabled_key);
+}
+#else
+static inline bool cpusets_enabled(void)
+{
+	return number_of_cpusets > 1;
+}
+#endif
+
+static inline void cpuset_inc(void)
+{
+	number_of_cpusets++;
+#ifdef HAVE_JUMP_LABEL
+	static_key_slow_inc(&cpusets_enabled_key);
+#endif
+}
+
+static inline void cpuset_dec(void)
+{
+	number_of_cpusets--;
+#ifdef HAVE_JUMP_LABEL
+	static_key_slow_dec(&cpusets_enabled_key);
+#endif
+}
+
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_update_active_cpus(bool cpu_online);
@@ -124,6 +153,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 
 #else /* !CONFIG_CPUSETS */
 
+static inline bool cpusets_enabled(void) { return false; }
+
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3d54c41..34ada52 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -68,6 +68,10 @@
  */
 int number_of_cpusets __read_mostly;
 
+#ifdef HAVE_JUMP_LABEL
+struct static_key cpusets_enabled_key = STATIC_KEY_INIT_FALSE;
+#endif
+
 /* See "Frequency meter" comments, below. */
 
 struct fmeter {
@@ -1888,7 +1892,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
 
-	number_of_cpusets++;
+	cpuset_inc();
 
 	if (!test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags))
 		goto out_unlock;
@@ -1939,7 +1943,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
-	number_of_cpusets--;
+	cpuset_dec();
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5c559e3..cb12b9a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1930,7 +1930,8 @@ zonelist_scan:
 		if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
-		if ((alloc_flags & ALLOC_CPUSET) &&
+		if (cpusets_enabled() &&
+			(alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);
-- 
1.8.4.5

