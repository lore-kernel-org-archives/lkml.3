Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaBJRbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:31:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbaBJRbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:31:10 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 21/21] perf, c2c: Add summary latency table for various parts of caches
Date: Mon, 10 Feb 2014 12:29:16 -0500
Message-Id: <1392053356-23024-22-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a simple summary table of latencies for the different parts of a
hardware cache (L1, LFB, L2, LLC [local/remote], DRAM [local/remote]).

Of course, this is based on the original ldlat filter level, which is 30 cycles
as of this writing.  This makes the L1, LFB, L2 numbers slightly misleading.

Original done by Dick Fowles and ported to perf by me.

Suggested-by: Joe Mario <jmario@redhat.com>
Original-by: Dick Fowles <rfowles@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 215 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 215 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 1fa21b4..a73535a 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -122,6 +122,41 @@ typedef struct {
 	void       *analyze;
 } stats_t;
 
+enum {
+	LD_L1HIT_NONE,
+	LD_LFBHIT_NONE,
+	LD_L2HIT_NONE,
+	LD_L3HIT_NONE,
+	LD_L3HIT_MISS,           /* other core snoop miss */
+	LD_L3HIT_HIT,            /* hit on other core within socket, no fwd */
+	LD_L3HIT_HITM,           /* hitm on other core within socket */
+	LD_L3MISS_HIT_CACHE,     /* remote cache hit, fwd data? */
+	LD_L3MISS_HITM_CACHE,    /* remote cache hitm, C2C, implicit WB, invalidate */
+	LD_L3MISS_HIT_LDRAM,     /* load shared from local dram */
+	LD_L3MISS_HIT_RDRAM,     /* load shared from remote dram */
+	LD_L3MISS_MISS_LDRAM,    /* load exclusive from local dram */
+	LD_L3MISS_MISS_RDRAM,    /* load exclusive from remote dram */
+	LD_L3MISS_NA,
+	LD_UNCACHED,
+	LOAD_CATAGORIES,
+	ST_L1HIT_NA,
+	ST_L1MISS_NA,
+	ST_UNCACHED,
+	LOCK,                    /* defines a bit flag to represent locked events */
+	ALL_CATAGORIES
+};
+
+struct ld_lat_stats {
+	struct stats	stats;
+	u64		total;
+};
+
+struct ld_lat_stats ld_lat_stats[ALL_CATAGORIES];
+
+typedef struct {
+	const char  *name;
+	int    id;
+} xref_t;
 
 enum { EMPTY, SYMBOL, OBJECT };
 enum { OVERALL, EXTREMES, ANALYZE, SCOPES };
@@ -131,6 +166,16 @@ struct c2c_latency_stats hist_info[SCOPES];
 
 enum { OP, LVL, SNP, LCK, TLB };
 
+#define LOAD_OP(a)           ((a) & PERF_MEM_OP_LOAD  )
+#define STORE_OP(a)          ((a) & PERF_MEM_OP_STORE )
+#define LOCKED_OP(a)         ((a) & PERF_MEM_LOCK_LOCKED)
+
+#define SNOOP_NA(a)          ((a) & PERF_MEM_SNOOP_NA)
+#define SNOOP_NONE(a)        ((a) & PERF_MEM_SNOOP_NONE)
+#define SNOOP_MISS(a)        ((a) & PERF_MEM_SNOOP_MISS)
+#define SNOOP_HIT(a)         ((a) & PERF_MEM_SNOOP_HIT)
+#define SNOOP_HITM(a)        ((a) & PERF_MEM_SNOOP_HITM)
+
 #define RMT_RAM              (PERF_MEM_LVL_REM_RAM1 | PERF_MEM_LVL_REM_RAM2)
 #define RMT_LLC              (PERF_MEM_LVL_REM_CCE1 | PERF_MEM_LVL_REM_CCE2)
 
@@ -1066,6 +1111,87 @@ static void c2c_hit__update_stats(struct c2c_stats *new,
 	new->total_period	+= old->total_period;
 }
 
+xref_t names[LOAD_CATAGORIES] = {
+	{ "L1  Hit  - Snp None            ",  LD_L1HIT_NONE        },
+	{ "LFB Hit  - Snp None            ",  LD_LFBHIT_NONE       },
+	{ "L2  Hit  - Snp None            ",  LD_L2HIT_NONE        },
+	{ "L3  Hit  - Snp None            ",  LD_L3HIT_NONE        },
+	{ "L3  Hit  - Snp Miss            ",  LD_L3HIT_MISS        },
+	{ "L3  Hit  - Snp Hit  - Lcl Cache",  LD_L3HIT_HIT         },
+	{ "L3  Hit  - Snp Hitm - Lcl Cache",  LD_L3HIT_HITM        },
+	{ "L3  Miss - Snp Hit  - Rmt Cache",  LD_L3MISS_HIT_CACHE  },
+	{ "L3  Miss - Snp Hitm - Rmt Cache",  LD_L3MISS_HITM_CACHE },
+	{ "L3  Miss - Snp Hit  - Lcl Dram ",  LD_L3MISS_HIT_LDRAM  },
+	{ "L3  Miss - Snp Hit  - Rmt Dram ",  LD_L3MISS_HIT_RDRAM  },
+	{ "L3  Miss - Snp Miss - Lcl Dram ",  LD_L3MISS_MISS_LDRAM },
+	{ "L3  Miss - Snp Miss - Rmt Dram ",  LD_L3MISS_MISS_RDRAM },
+	{ "L3  Miss - Snp NA              ",  LD_L3MISS_NA         },
+	{ "Ld  UNC  - Snp None            ",  LD_UNCACHED          },
+};
+
+static void print_latency_load_info(void)
+{
+#define TITLE "Load Access & Excute Latency Information"
+
+	char     title_str[256];
+	double   stddev;
+	double   mean;
+	double   covar;
+	uint64_t cycles;
+	int      pad;
+	int      idx;
+	int      i;
+
+
+	cycles = 0;
+
+	for (i = 0; i < LOAD_CATAGORIES; i++)
+		cycles += ld_lat_stats[i].total;
+
+	sprintf(title_str, "%32s  %10s  %10s  %10s  %10s  %10s  %10s",
+		" ",
+		"Count",
+		"Minmum",
+		"Average",
+		"CV  ",
+		"Maximum",
+		"%dist");
+
+	pad = (strlen(title_str)/2) - (strlen(TITLE)/2);
+
+	printf("\n\n");
+	for (i = 0; i < (int)strlen(title_str); i++) printf("=");
+	printf("\n");
+	for (i = 0; i < pad; i++) printf(" ");
+	printf("%s\n", TITLE);
+	printf("\n");
+	printf("%s\n", title_str);
+	for (i = 0; i < (int)strlen(title_str); i++) printf("=");
+	printf("\n");
+
+	for (i = 0; i < LOAD_CATAGORIES; i++) {
+
+		idx    = names[i].id;
+
+		mean   = avg_stats(&ld_lat_stats[idx].stats);
+		stddev = stddev_stats(&ld_lat_stats[idx].stats);
+		covar  = stddev / mean;
+
+		printf("%-32s  %10lu  %10lu  %10.0f  %10.4f  %10lu  %10.1f%%\n",
+			names[i].name,
+			(u64)ld_lat_stats[idx].stats.n,
+			ld_lat_stats[idx].stats.min,
+			ld_lat_stats[idx].stats.mean,
+			covar,
+			ld_lat_stats[idx].stats.max,
+			100. * ((double)ld_lat_stats[idx].total / (double)cycles));
+
+	}
+
+	printf("\n");
+
+}
+
 LIST_HEAD(ref_tree);
 LIST_HEAD(ref_tree_sorted);
 struct refs {
@@ -1721,6 +1847,88 @@ static void calculate_latency_info(struct rb_root *tree,
 	selected->mode = mode;
 }
 
+static int decode_src(union perf_mem_data_src dsrc)
+{
+	if (LOAD_OP(dsrc.mem_op)) {
+
+		if (FILLBUF_HIT(dsrc.mem_lvl)) return(LD_LFBHIT_NONE);
+		if (L1CACHE_HIT(dsrc.mem_lvl)) return(LD_L1HIT_NONE);
+		if (L2CACHE_HIT(dsrc.mem_lvl)) return(LD_L2HIT_NONE);
+
+		if (L3CACHE_HIT(dsrc.mem_lvl)) {
+
+			if (SNOOP_HITM(dsrc.mem_snoop)) return(LD_L3HIT_HITM);
+			if (SNOOP_HIT(dsrc.mem_snoop))  return(LD_L3HIT_HIT);
+			if (SNOOP_MISS(dsrc.mem_snoop)) return(LD_L3HIT_MISS);
+			if (SNOOP_NONE(dsrc.mem_snoop)) return(LD_L3HIT_NONE);
+
+		}
+
+		if (L3CACHE_MISS(dsrc.mem_lvl)) {
+
+			if (SNOOP_NA(dsrc.mem_snoop)) return(LD_L3MISS_NA);
+
+		}
+
+		if (RMT_LLCHIT(dsrc.mem_lvl)) {
+
+			if (SNOOP_HITM(dsrc.mem_snoop)) return(LD_L3MISS_HITM_CACHE);
+			if (SNOOP_HIT(dsrc.mem_snoop))  return(LD_L3MISS_HIT_CACHE);
+
+		}
+
+
+		if (LCL_MEM(dsrc.mem_lvl)) {
+
+			if (SNOOP_MISS(dsrc.mem_snoop)) return(LD_L3MISS_MISS_LDRAM);
+			if (SNOOP_HIT(dsrc.mem_snoop))  return(LD_L3MISS_HIT_LDRAM);
+
+		}
+
+
+		if (RMT_MEM(dsrc.mem_lvl)) {
+
+			if (SNOOP_MISS(dsrc.mem_snoop)) return(LD_L3MISS_MISS_RDRAM);
+			if (SNOOP_HIT(dsrc.mem_snoop))  return(LD_L3MISS_HIT_RDRAM);
+
+		}
+
+		if (LD_UNCACHED(dsrc.mem_lvl)) {
+			if (SNOOP_NONE(dsrc.mem_snoop)) return(LD_UNCACHED);
+		}
+
+	}
+
+
+	if (STORE_OP(dsrc.mem_op)) {
+
+		if (SNOOP_NA(dsrc.mem_snoop)) {
+
+			if (L1CACHE_HIT(dsrc.mem_lvl))  return(ST_L1HIT_NA);
+			if (L1CACHE_MISS(dsrc.mem_lvl)) return(ST_L1MISS_NA);
+
+		}
+
+	}
+	return -1;
+}
+
+static void latency_update_stats(union perf_mem_data_src src,
+				u64 weight)
+{
+	int id = decode_src(src);
+
+	if (id < 0) {
+		pr_err("Bad data_src: %llx\n", src.val);
+		return;
+	}
+
+	update_stats(&ld_lat_stats[id].stats, weight);
+	ld_lat_stats[id].total += weight;
+
+	return;
+}
+
 static void c2c_analyze_latency(struct perf_c2c *c2c)
 {
 
@@ -1742,6 +1950,9 @@ static void c2c_analyze_latency(struct perf_c2c *c2c)
 	extremes = &hist_info[EXTREMES];
 	selected = &hist_info[ANALYZE];
 
+	for (i = 0; i < LOAD_CATAGORIES; i++)
+		init_stats(&ld_lat_stats[i].stats);
+
 	/* sort on latency */
 	while (next) {
 		n = rb_entry(next, struct c2c_entry, rb_node);
@@ -1749,6 +1960,9 @@ static void c2c_analyze_latency(struct perf_c2c *c2c)
 
 		snoop  = n->mi->data_src.mem_snoop;
 
+		/* piggy back updating load latency stats */
+		latency_update_stats(n->mi->data_src, n->weight);
+
 		/* filter out HITs as un-interesting */
 		if ((snoop & P(SNOOP, HIT)) ||
 		    (snoop & P(SNOOP, HITM)) ||
@@ -1765,6 +1979,7 @@ static void c2c_analyze_latency(struct perf_c2c *c2c)
 	calculate_latency_selected_info(&lat_select_tree, selected->start, &lat_stats);
 	print_latency_select_info(&lat_select_tree, &lat_stats);
 
+	print_latency_load_info();
 	return;
 }
 
-- 
1.7.11.7

