Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaHDVPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 17:15:19 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58316 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbaHDVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 17:15:15 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 4/4] mm: memcontrol: add memory.vmstat to default hierarchy
Date: Mon,  4 Aug 2014 17:14:57 -0400
Message-Id: <1407186897-21048-5-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
References: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide basic per-memcg vmstat-style statistics on LRU sizes,
allocated and freed pages, major and minor faults.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/cgroups/unified-hierarchy.txt |  8 ++++++
 mm/memcontrol.c                             | 40 +++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 6c52c926810f..180b260c510a 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -337,6 +337,14 @@ supported and the interface files "release_agent" and
 - memory.max provides a hard upper limit as a last-resort backup to
   memory.high for situations with aggressive isolation requirements.
 
+- memory.stat has been replaced by memory.vmstat, which provides
+  page-based statistics in the style of /proc/vmstat.
+
+  As cgroups are now always hierarchical and no longer allow tasks in
+  intermediate levels, the local state is irrelevant and all
+  statistics represent the state of the entire hierarchy rooted at the
+  given group.
+
 
 5. Planned Changes
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 461834c86b94..6502e1cfc0fc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6336,6 +6336,42 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static u64 tree_events(struct mem_cgroup *memcg, int event)
+{
+	struct mem_cgroup *mi;
+	u64 val = 0;
+
+	for_each_mem_cgroup_tree(mi, memcg)
+		val += mem_cgroup_read_events(mi, event);
+	return val;
+}
+
+static int memory_vmstat_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	struct mem_cgroup *mi;
+	int i;
+
+	for (i = 0; i < NR_LRU_LISTS; i++) {
+		u64 val = 0;
+
+		for_each_mem_cgroup_tree(mi, memcg)
+			val += mem_cgroup_nr_lru_pages(mi, BIT(i));
+		seq_printf(m, "%s %llu\n", vmstat_text[NR_LRU_BASE + i], val);
+	}
+
+	seq_printf(m, "pgalloc %llu\n",
+		   tree_events(memcg, MEM_CGROUP_EVENTS_PGPGIN));
+	seq_printf(m, "pgfree %llu\n",
+		   tree_events(memcg, MEM_CGROUP_EVENTS_PGPGOUT));
+	seq_printf(m, "pgfault %llu\n",
+		   tree_events(memcg, MEM_CGROUP_EVENTS_PGFAULT));
+	seq_printf(m, "pgmajfault %llu\n",
+		   tree_events(memcg, MEM_CGROUP_EVENTS_PGMAJFAULT));
+
+	return 0;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6351,6 +6387,10 @@ static struct cftype memory_files[] = {
 		.read_u64 = memory_max_read,
 		.write = memory_max_write,
 	},
+	{
+		.name = "vmstat",
+		.seq_show = memory_vmstat_show,
+	},
 };
 
 struct cgroup_subsys memory_cgrp_subsys = {
-- 
2.0.3

