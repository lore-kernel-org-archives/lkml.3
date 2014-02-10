Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaBJRbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:31:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbaBJRax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:53 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 10/21] perf, c2c: Add stats to track data source bits and cpu to node maps
Date: Mon, 10 Feb 2014 12:29:05 -0500
Message-Id: <1392053356-23024-11-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a bunch of stats that will be used later in post-processing
to determine where and with what frequency the HITMs are coming from.

Most of the stats are decoded from the data source response.  Another
piece of the stats is tracking which cpu the record came in on.

In order to properly build a cpu map to map where interesting events are coming
from, I shamelessly copy-n-pasted the cpu->NUMA node code from builtin-kmem.c.

As HITMs are most expensive when going across NUMA nodes, it only made sense
to create a quick cpu->NUMA lookup for when processing the records.

Credit to Dick Fowles for determining which bits are important and how to
properly track them.  Ported to perf by me.

Original-by: Dick Fowles <rfowles@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 327 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 326 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index a9c536b..360fbcf 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -5,15 +5,54 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/stat.h"
+#include "util/cpumap.h"
 #include "util/debug.h"
 
 #include <linux/compiler.h>
 #include <linux/kernel.h>
+#include <sched.h>
+
+typedef struct {
+	int  locks;               /* count of 'lock' transactions */
+	int  store;               /* count of all stores in trace */
+	int  st_uncache;          /* stores to uncacheable address */
+	int  st_noadrs;           /* cacheable store with no address */
+	int  st_l1hit;            /* count of stores that hit L1D */
+	int  st_l1miss;           /* count of stores that miss L1D */
+	int  load;                /* count of all loads in trace */
+	int  ld_excl;             /* exclusive loads, rmt/lcl DRAM - snp none/miss */
+	int  ld_shared;           /* shared loads, rmt/lcl DRAM - snp hit */
+	int  ld_uncache;          /* loads to uncacheable address */
+	int  ld_noadrs;           /* cacheable load with no address */
+	int  ld_fbhit;            /* count of loads hitting Fill Buffer */
+	int  ld_l1hit;            /* count of loads that hit L1D */
+	int  ld_l2hit;            /* count of loads that hit L2D */
+	int  ld_llchit;           /* count of loads that hit LLC */
+	int  lcl_hitm;            /* count of loads with local HITM  */
+	int  rmt_hitm;            /* count of loads with remote HITM */
+	int  rmt_hit;             /* count of loads with remote hit clean; */
+	int  lcl_dram;            /* count of loads miss to local DRAM */
+	int  rmt_dram;            /* count of loads miss to remote DRAM */
+	int  nomap;               /* count of load/stores with no phys adrs */
+	int  remap;               /* count of virt->phys remappings */
+} trinfo_t;
+
+struct c2c_stats {
+	cpu_set_t		cpuset;
+	int			nr_entries;
+	u64			total_period;
+	trinfo_t		t;
+	struct stats		stats;
+};
 
 struct perf_c2c {
 	struct perf_tool tool;
 	bool		 raw_records;
 	struct rb_root   tree_physid;
+
+	/* stats */
+	struct c2c_stats	stats;
 };
 
 #define REGION_SAME	1 << 0;
@@ -31,6 +70,179 @@ struct c2c_entry {
 
 enum { OP, LVL, SNP, LCK, TLB };
 
+#define RMT_RAM              (PERF_MEM_LVL_REM_RAM1 | PERF_MEM_LVL_REM_RAM2)
+#define RMT_LLC              (PERF_MEM_LVL_REM_CCE1 | PERF_MEM_LVL_REM_CCE2)
+
+#define L1CACHE_HIT(a)       (((a) & PERF_MEM_LVL_L1 ) && ((a) & PERF_MEM_LVL_HIT))
+#define FILLBUF_HIT(a)       (((a) & PERF_MEM_LVL_LFB) && ((a) & PERF_MEM_LVL_HIT))
+#define L2CACHE_HIT(a)       (((a) & PERF_MEM_LVL_L2 ) && ((a) & PERF_MEM_LVL_HIT))
+#define L3CACHE_HIT(a)       (((a) & PERF_MEM_LVL_L3 ) && ((a) & PERF_MEM_LVL_HIT))
+
+#define L1CACHE_MISS(a)      (((a) & PERF_MEM_LVL_L1 ) && ((a) & PERF_MEM_LVL_MISS))
+#define L3CACHE_MISS(a)      (((a) & PERF_MEM_LVL_L3 ) && ((a) & PERF_MEM_LVL_MISS))
+
+#define LD_UNCACHED(a)       (((a) & PERF_MEM_LVL_UNC) && ((a) & PERF_MEM_LVL_HIT))
+#define ST_UNCACHED(a)       (((a) & PERF_MEM_LVL_UNC) && ((a) & PERF_MEM_LVL_HIT))
+
+#define RMT_LLCHIT(a)        (((a) & RMT_LLC) && ((a) & PERF_MEM_LVL_HIT))
+#define RMT_HIT(a,b)         (((a) & RMT_LLC) && ((b) & PERF_MEM_SNOOP_HIT))
+#define RMT_HITM(a,b)        (((a) & RMT_LLC) && ((b) & PERF_MEM_SNOOP_HITM))
+#define RMT_MEM(a)           (((a) & RMT_RAM) && ((a) & PERF_MEM_LVL_HIT))
+
+#define LCL_HIT(a,b)         (L3CACHE_HIT(a) && ((b) & PERF_MEM_SNOOP_HIT))
+#define LCL_HITM(a,b)        (L3CACHE_HIT(a) && ((b) & PERF_MEM_SNOOP_HITM))
+#define LCL_MEM(a)           (((a) & PERF_MEM_LVL_LOC_RAM) && ((a) & PERF_MEM_LVL_HIT))
+
+static int			max_cpu_num;
+static int			max_node_num;
+static int			*cpunode_map;
+
+#define PATH_SYS_NODE   "/sys/devices/system/node"
+
+/* Determine highest possible cpu in the system for sparse allocation */
+static void set_max_cpu_num(void)
+{
+	FILE *fp;
+	char buf[256];
+	int num;
+
+	/* set up default */
+	max_cpu_num = 4096;
+
+	/* get the highest possible cpu number for a sparse allocation */
+	fp = fopen("/sys/devices/system/cpu/possible", "r");
+	if (!fp)
+		goto out;
+
+	num = fread(&buf, 1, sizeof(buf), fp);
+	if (!num)
+		goto out_close;
+	buf[num] = '\0';
+
+	/* start on the right, to find highest cpu num */
+	while (--num) {
+		if ((buf[num] == ',') || (buf[num] == '-')) {
+			num++;
+			break;
+		}
+	}
+	if (sscanf(&buf[num], "%d", &max_cpu_num) < 1)
+		goto out_close;
+
+	max_cpu_num++;
+
+	fclose(fp);
+	return;
+
+out_close:
+	fclose(fp);
+out:
+	pr_err("Failed to read max cpus, using default of %d\n",
+		max_cpu_num);
+	return;
+}
+
+/* Determine highest possible node in the system for sparse allocation */
+static void set_max_node_num(void)
+{
+	FILE *fp;
+	char buf[256];
+	int num;
+
+	/* set up default */
+	max_node_num = 8;
+
+	/* get the highest possible cpu number for a sparse allocation */
+	fp = fopen("/sys/devices/system/node/possible", "r");
+	if (!fp)
+		goto out;
+
+	num = fread(&buf, 1, sizeof(buf), fp);
+	if (!num)
+		goto out_close;
+	buf[num] = '\0';
+
+	/* start on the right, to find highest node num */
+	while (--num) {
+		if ((buf[num] == ',') || (buf[num] == '-')) {
+			num++;
+			break;
+		}
+	}
+	if (sscanf(&buf[num], "%d", &max_node_num) < 1)
+		goto out_close;
+
+	max_node_num++;
+
+	fclose(fp);
+	return;
+
+out_close:
+	fclose(fp);
+out:
+	pr_err("Failed to read max nodes, using default of %d\n",
+		max_node_num);
+	return;
+}
+
+static int init_cpunode_map(void)
+{
+	int i;
+
+	set_max_cpu_num();
+	set_max_node_num();
+
+	cpunode_map = calloc(max_cpu_num, sizeof(int));
+	if (!cpunode_map) {
+		pr_err("%s: calloc failed\n", __func__);
+		goto out;
+	}
+
+	for (i = 0; i < max_cpu_num; i++)
+		cpunode_map[i] = -1;
+
+	return 0;
+out:
+	return -1;
+}
+
+static int setup_cpunode_map(void)
+{
+	struct dirent *dent1, *dent2;
+	DIR *dir1, *dir2;
+	unsigned int cpu, mem;
+	char buf[PATH_MAX];
+
+	/* initialize globals */
+	if (init_cpunode_map())
+		return -1;
+
+	dir1 = opendir(PATH_SYS_NODE);
+	if (!dir1)
+		return 0;
+
+	/* walk tree and setup map */
+	while ((dent1 = readdir(dir1)) != NULL) {
+		if (dent1->d_type != DT_DIR ||
+		    sscanf(dent1->d_name, "node%u", &mem) < 1)
+			continue;
+
+		snprintf(buf, PATH_MAX, "%s/%s", PATH_SYS_NODE, dent1->d_name);
+		dir2 = opendir(buf);
+		if (!dir2)
+			continue;
+		while ((dent2 = readdir(dir2)) != NULL) {
+			if (dent2->d_type != DT_LNK ||
+			    sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
+				continue;
+			cpunode_map[cpu] = mem;
+		}
+		closedir(dir2);
+	}
+	closedir(dir1);
+	return 0;
+}
+
 static int perf_c2c__scnprintf_data_src(char *bf, size_t size, uint64_t val)
 {
 #define PREFIX       "["
@@ -303,17 +515,120 @@ static struct c2c_entry *c2c_entry__new(struct perf_sample *sample,
 	return entry;
 }
 
+static int c2c_decode_stats(struct c2c_stats *stats, struct c2c_entry *entry)
+{
+	union perf_mem_data_src *data_src = &entry->mi->data_src;
+	u64 daddr = entry->mi->daddr.addr;
+	u64 weight = entry->weight;
+	int err = 0;
+
+	u64 op = data_src->mem_op;
+	u64 lvl = data_src->mem_lvl;
+	u64 snoop = data_src->mem_snoop;
+	u64 lock = data_src->mem_lock;
+
+#define P(a,b) PERF_MEM_##a##_##b
+
+	stats->nr_entries++;
+	stats->total_period += entry->period;
+
+	if (lock & P(LOCK,LOCKED)) stats->t.locks++;
+
+	if (op & P(OP,LOAD)) {
+		stats->t.load++;
+
+		if (!daddr) {
+			stats->t.ld_noadrs++;
+			return -1;
+		}
+
+		if (lvl & P(LVL,HIT)) {
+			if (lvl & P(LVL,UNC)) stats->t.ld_uncache++;
+			if (lvl & P(LVL,LFB)) stats->t.ld_fbhit++;
+			if (lvl & P(LVL,L1 )) stats->t.ld_l1hit++;
+			if (lvl & P(LVL,L2 )) stats->t.ld_l2hit++;
+			if (lvl & P(LVL,L3 )) {
+				if (snoop & P(SNOOP,HITM))
+					stats->t.lcl_hitm++;
+				else
+					stats->t.ld_llchit++;
+			}
+
+			if (lvl & P(LVL,LOC_RAM)) {
+				stats->t.lcl_dram++;
+				if (snoop & P(SNOOP,HIT))
+					stats->t.ld_shared++;
+				else
+					stats->t.ld_excl++;
+			}
+
+			if ((lvl & P(LVL,REM_RAM1)) ||
+			    (lvl & P(LVL,REM_RAM2))) {
+				stats->t.rmt_dram++;
+				if (snoop & P(SNOOP,HIT))
+					stats->t.ld_shared++;
+				else
+					stats->t.ld_excl++;
+			}
+		}
+
+		if ((lvl & P(LVL,REM_CCE1)) ||
+		    (lvl & P(LVL,REM_CCE2))) {
+			if (snoop & P(SNOOP, HIT))
+				stats->t.rmt_hit++;
+			else if (snoop & P(SNOOP, HITM)) {
+				stats->t.rmt_hitm++;
+				update_stats(&stats->stats, weight);
+			}
+		}
+
+	} else if (op & P(OP,STORE)) {
+		/* store */
+		stats->t.store++;
+
+		if (!daddr) {
+			stats->t.st_noadrs++;
+			return -1;
+		}
+
+		if (lvl & P(LVL,HIT)) {
+			if (lvl & P(LVL,UNC)) stats->t.st_uncache++;
+			if (lvl & P(LVL,L1 )) stats->t.st_l1hit++;
+		}
+		if (lvl & P(LVL,MISS))
+			if (lvl & P(LVL,L1)) stats->t.st_l1miss++;
+	} else {
+		/* unparsable data_src? */
+		return -1;
+	}
+
+	if (!entry->mi->daddr.map || !entry->mi->iaddr.map)
+		return -1;
+
+	return err;
+}
+
 static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 				  struct perf_sample *sample __maybe_unused,
 				  struct c2c_entry *entry)
 {
+	int err = 0;
+
+	err = c2c_decode_stats(&c2c->stats, entry);
+	if (err < 0) {
+		err = 1;
+		goto err;
+	}
+	err = 0;
+
 	c2c_entry__add_to_list(c2c, entry);
 
 	/* don't lose the maps if remapped */
 	entry->mi->iaddr.map->referenced = true;
 	entry->mi->daddr.map->referenced = true;
 
-	return 0;
+err:
+	return err;
 }
 
 static const struct perf_evsel_str_handler handlers[] = {
@@ -403,6 +718,9 @@ static int perf_c2c__read_events(struct perf_c2c *c2c)
 		goto out;
 	}
 
+	if (symbol__init() < 0)
+		goto out_delete;
+
 	if (perf_evlist__set_handlers(session->evlist, handlers))
 		goto out_delete;
 
@@ -416,6 +734,13 @@ out:
 
 static int perf_c2c__init(struct perf_c2c *c2c)
 {
+	/* setup cpu map */
+	if (setup_cpunode_map() < 0) {
+		pr_err("can not setup cpu map\n");
+		return -1;
+	}
+
+	CPU_ZERO(&c2c->stats.cpuset);
 	c2c->tree_physid = RB_ROOT;
 
 	return 0;
-- 
1.7.11.7

