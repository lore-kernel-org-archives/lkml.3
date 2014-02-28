Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaB1RqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:46:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbaB1Rnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:50 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 12/19] perf, c2c: Add stats to track data source bits and cpu to node maps
Date: Fri, 28 Feb 2014 12:43:01 -0500
Message-Id: <1393609388-40489-13-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a bunch of stats that will be used later in post-processing
to determine where and with what frequency the HITMs are coming from.

Most of the stats are decoded from the data source response.  Another
piece of the stats is tracking which cpu the record came in on.

Credit to Dick Fowles for determining which bits are important and how to
properly track them.  Ported to perf by me.

V2: refresh with hist_entry

Original-by: Dick Fowles <rfowles@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 184 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 184 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 472d4d9..5deb7cc 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -5,20 +5,84 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/stat.h"
+#include "util/cpumap.h"
 #include "util/debug.h"
 #include "util/annotate.h"
 
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
+	int  ld_io;               /* loads to io address */
+	int  ld_miss;             /* loads miss */
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
+	int  noparse;             /* count of unparsable data sources */
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
 	struct hists	 hists;
+
+	/* stats */
+	struct c2c_stats	stats;
 };
 
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
 static int perf_c2c__scnprintf_data_src(char *bf, size_t size, uint64_t val)
 {
 #define PREFIX       "["
@@ -141,6 +205,106 @@ static int perf_sample__fprintf(struct perf_sample *sample, char tag,
 		       mi->iaddr.sym ? mi->iaddr.sym->name : "???");
 }
 
+static int c2c_decode_stats(struct c2c_stats *stats, struct hist_entry *entry)
+{
+	union perf_mem_data_src *data_src = &entry->mem_info->data_src;
+	u64 daddr = entry->mem_info->daddr.addr;
+	u64 weight = entry->stat.weight;
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
+	stats->total_period += entry->stat.period;
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
+			if (lvl & P(LVL,IO))  stats->t.ld_io++;
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
+		if ((lvl & P(LVL,MISS)))
+			stats->t.ld_miss++;
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
+		stats->t.noparse++;
+		return -1;
+	}
+
+	if (!entry->mem_info->daddr.map || !entry->mem_info->iaddr.map) {
+		stats->t.nomap++;
+		return -1;
+	}
+
+	return err;
+}
+
 static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -180,6 +344,14 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 		goto out_mem;
 	}
 
+	err = c2c_decode_stats(&c2c->stats, he);
+	if (err < 0) {
+		err = 0;
+		rb_erase(&he->rb_node_in, c2c->hists.entries_in);
+		free(he);
+		goto out;
+	}
+
 	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 	if (err)
 		goto out;
@@ -279,6 +451,9 @@ static int perf_c2c__read_events(struct perf_c2c *c2c)
 		goto out;
 	}
 
+	if (symbol__init() < 0)
+		goto out_delete;
+
 	/* setup the evsel handlers for each event type */
 	evlist__for_each(session->evlist, evsel) {
 		const char *name = perf_evsel__name(evsel);
@@ -292,12 +467,20 @@ static int perf_c2c__read_events(struct perf_c2c *c2c)
 
 	err = perf_c2c__process_events(session, c2c);
 
+out_delete:
+	perf_session__delete(session);
 out:
 	return err;
 }
 
 static int perf_c2c__init(struct perf_c2c *c2c)
 {
+	/* setup cpu map */
+	if (cpu_map__setup_cpunode_map() < 0) {
+		pr_err("can not setup cpu map\n");
+		return -1;
+	}
+
 	sort__mode = SORT_MODE__MEMORY;
 	sort__wants_unique = 1;
 	sort_order = "physid";
@@ -308,6 +491,7 @@ static int perf_c2c__init(struct perf_c2c *c2c)
 	}
 
 	hists__init(&c2c->hists);
+	CPU_ZERO(&c2c->stats.cpuset);
 
 	return 0;
 }
-- 
1.7.11.7

