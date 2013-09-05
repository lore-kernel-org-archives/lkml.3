Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab3IEG3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 02:29:09 -0400
Received: from mail-qe0-f73.google.com ([209.85.128.73]:60138 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3IEG3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 02:29:07 -0400
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: hughd@google.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        Ying Han <yinghan@google.com>
Subject: [PATCH 1/2 v3] memcg: refactor mem_control_numa_stat_show()
Date: Wed,  4 Sep 2013 23:28:58 -0700
Message-Id: <1378362539-18100-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor mem_control_numa_stat_show() to use a new stats structure for
smaller and simpler code.  This consolidates nearly identical code.

   text     data      bss        dec      hex   filename
8,055,980 1,675,648 1,896,448 11,628,076 b16e2c vmlinux.before
8,055,276 1,675,648 1,896,448 11,627,372 b16b6c vmlinux.after

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Ying Han <yinghan@google.com>
---
Changelog since v2:
- rebased to v3.11
- updated commit description

 mm/memcontrol.c | 57 +++++++++++++++++++++++----------------------------------
 1 file changed, 23 insertions(+), 34 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0878ff7..4d2b037 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5378,45 +5378,34 @@ static int mem_cgroup_move_charge_write(struct cgroup *cgrp,
 static int memcg_numa_stat_show(struct cgroup *cont, struct cftype *cft,
 				      struct seq_file *m)
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
+		{ NULL, 0 }  /* terminator */
+	};
+	const struct numa_stat *stat;
 	int nid;
-	unsigned long total_nr, file_nr, anon_nr, unevictable_nr;
-	unsigned long node_nr;
+	unsigned long nr;
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 
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
+	for (stat = stats; stat->name; stat++) {
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
 
-	unevictable_nr = mem_cgroup_nr_lru_pages(memcg, BIT(LRU_UNEVICTABLE));
-	seq_printf(m, "unevictable=%lu", unevictable_nr);
-	for_each_node_state(nid, N_MEMORY) {
-		node_nr = mem_cgroup_node_nr_lru_pages(memcg, nid,
-				BIT(LRU_UNEVICTABLE));
-		seq_printf(m, " N%d=%lu", nid, node_nr);
-	}
-	seq_putc(m, '\n');
 	return 0;
 }
 #endif /* CONFIG_NUMA */
-- 
1.8.4

