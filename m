Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbbA1Byy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:54:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293AbbA1Bi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Theodore Tso <tytso@mit.edu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 49/77] mm: page_alloc: use jump labels to avoid checking number_of_cpusets
Date: Tue, 27 Jan 2015 17:27:27 -0800
Message-Id: <20150128012747.442546723@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 664eeddeef6539247691197c1ac124d4aa872ab6 upstream.

If cpusets are not in use then we still check a global variable on every
page allocation.  Use jump labels to avoid the overhead.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/cpuset.h |   29 ++++++++++++++++++++++++++---
 kernel/cpuset.c        |   14 ++++----------
 mm/page_alloc.c        |    3 ++-
 3 files changed, 32 insertions(+), 14 deletions(-)

--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -12,10 +12,31 @@
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
 #include <linux/mm.h>
+#include <linux/jump_label.h>
 
 #ifdef CONFIG_CPUSETS
 
-extern int number_of_cpusets;	/* How many cpusets are defined in system? */
+extern struct static_key cpusets_enabled_key;
+static inline bool cpusets_enabled(void)
+{
+	return static_key_false(&cpusets_enabled_key);
+}
+
+static inline int nr_cpusets(void)
+{
+	/* jump label reference count + the top-level cpuset */
+	return static_key_count(&cpusets_enabled_key) + 1;
+}
+
+static inline void cpuset_inc(void)
+{
+	static_key_slow_inc(&cpusets_enabled_key);
+}
+
+static inline void cpuset_dec(void)
+{
+	static_key_slow_dec(&cpusets_enabled_key);
+}
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
@@ -32,13 +53,13 @@ extern int __cpuset_node_allowed_hardwal
 
 static inline int cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 {
-	return number_of_cpusets <= 1 ||
+	return nr_cpusets() <= 1 ||
 		__cpuset_node_allowed_softwall(node, gfp_mask);
 }
 
 static inline int cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 {
-	return number_of_cpusets <= 1 ||
+	return nr_cpusets() <= 1 ||
 		__cpuset_node_allowed_hardwall(node, gfp_mask);
 }
 
@@ -124,6 +145,8 @@ static inline void set_mems_allowed(node
 
 #else /* !CONFIG_CPUSETS */
 
+static inline bool cpusets_enabled(void) { return false; }
+
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -61,12 +61,7 @@
 #include <linux/cgroup.h>
 #include <linux/wait.h>
 
-/*
- * Tracks how many cpusets are currently defined in system.
- * When there is only one cpuset (the root cpuset) we can
- * short circuit some hooks.
- */
-int number_of_cpusets __read_mostly;
+struct static_key cpusets_enabled_key __read_mostly = STATIC_KEY_INIT_FALSE;
 
 /* See "Frequency meter" comments, below. */
 
@@ -611,7 +606,7 @@ static int generate_sched_domains(cpumas
 		goto done;
 	}
 
-	csa = kmalloc(number_of_cpusets * sizeof(cp), GFP_KERNEL);
+	csa = kmalloc(nr_cpusets() * sizeof(cp), GFP_KERNEL);
 	if (!csa)
 		goto done;
 	csn = 0;
@@ -1961,7 +1956,7 @@ static int cpuset_css_online(struct cgro
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
 
-	number_of_cpusets++;
+	cpuset_inc();
 
 	if (!test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags))
 		goto out_unlock;
@@ -2012,7 +2007,7 @@ static void cpuset_css_offline(struct cg
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
-	number_of_cpusets--;
+	cpuset_dec();
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
@@ -2067,7 +2062,6 @@ int __init cpuset_init(void)
 	if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
 		BUG();
 
-	number_of_cpusets = 1;
 	return 0;
 }
 
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1945,7 +1945,8 @@ zonelist_scan:
 		if (IS_ENABLED(CONFIG_NUMA) && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
-		if ((alloc_flags & ALLOC_CPUSET) &&
+		if (cpusets_enabled() &&
+			(alloc_flags & ALLOC_CPUSET) &&
 			!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				continue;
 		BUILD_BUG_ON(ALLOC_NO_WATERMARKS < NR_WMARK);


