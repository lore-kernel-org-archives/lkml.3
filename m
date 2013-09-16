Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998Ab3IPTAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 15:00:34 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:55688 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3IPTAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 15:00:32 -0400
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: hughd@google.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        Ying Han <yinghan@google.com>
Subject: [PATCH 1/2 v4] memcg: refactor mem_control_numa_stat_show()
Date: Mon, 16 Sep 2013 12:00:22 -0700
Message-Id: <1379358023-3093-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor mem_control_numa_stat_show() to use a new stats structure for
smaller and simpler code.  This consolidates nearly identical code.

  text      data      bss        dec      hex   filename
8,137,679 1,703,496 1,896,448 11,737,623 b31a17 vmlinux.before
8,136,911 1,703,496 1,896,448 11,736,855 b31717 vmlinux.after

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Ying Han <yinghan@google.com>
---
Changelog since v3:
- Use ARRAY_SIZE(stats) rather than array terminator.
- rebased to latest linus/master (d8efd82) to incorporate 182446d08 "cgroup:
  pass around cgroup_subsys_state instead of cgroup in file methods".

 mm/memcontrol.c | 58 +++++++++++++++++++++++----------------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d5ff3ce..5806eea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5179,45 +5179,33 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 static int memcg_numa_stat_show(struct cgroup_subsys_state *css,
 				struct cftype *cft, struct seq_file *m)
 {
+	struct numa_stat {
+		const char *name;
+		unsigned int lru_mask;
+	};
+
+	static const struct numa_stat stats[] = {
+		{ "total", LRU_ALL },
+		{ "file", LRU_ALL_FILE },
+		{ "anon", LRU_ALL_ANON },
+		{ "unevictable", BIT(LRU_UNEVICTABLE) },
+	};
+	const struct numa_stat *stat;
 	int nid;
-	unsigned long total_nr, file_nr, anon_nr, unevictable_nr;
-	unsigned long node_nr;
+	unsigned long nr;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	total_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL);
-	seq_printf(m, "total=%lu", total_nr);
-	for_each_node_state(nid, N_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL);
-		seq_printf(m, " N%d=%lu", nid, node_nr);
-	}
-	seq_putc(m, '\n');
-
-	file_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_FILE);
-	seq_printf(m, "file=%lu", file_nr);
-	for_each_node_state(nid, N_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-				LRU_ALL_FILE);
-		seq_printf(m, " N%d=%lu", nid, node_nr);
-	}
-	seq_putc(m, '\n');
-
-	anon_nr = mem_cgroup_nr_lru_pages(memcg, LRU_ALL_ANON);
-	seq_printf(m, "anon=%lu", anon_nr);
-	for_each_node_state(nid, N_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-				LRU_ALL_ANON);
-		seq_printf(m, " N%d=%lu", nid, node_nr);
-	}
-	seq_putc(m, '\n');
-
-	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
-	seq_printf(m, "unevictable=%lu", unevictable_nr);
-	for_each_node_state(nid, N_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-				BIT(LRU_UNEVICTABLE));
-		seq_printf(m, " N%d=%lu", nid, node_nr);
+	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
+		nr = mem_cgroup_nr_lru_pages(memcg, stat->lru_mask);
+		seq_printf(m, "%s=%lu", stat->name, nr);
+		for_each_node_state(nid, N_MEMORY) {
+			nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
+							  stat->lru_mask);
+			seq_printf(m, " N%d=%lu", nid, nr);
+		}
+		seq_putc(m, '\n');
 	}
-	seq_putc(m, '\n');
+
 	return 0;
 }
 #endif /* CONFIG_NUMA */
-- 
1.8.4

