Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaBJRcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:32:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbaBJRbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:31:02 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 19/21] perf, c2c: Add framework to analyze latency and display summary stats
Date: Mon, 10 Feb 2014 12:29:14 -0500
Message-Id: <1392053356-23024-20-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The overall goal for the cache-to-cache contention tool is to find extreme latencies and
help point out the problem, so they can be fixed.  The big assumption is remote cache hits
cause the biggest contentions.

Those are summarized by previous patches.  However, we still have non-remote cache hits with
high latency.  We display those here in a table.  We identify the outliers and focus on them.

Orignal work done by Dick Fowles.  I just ported it over to the perf framework.

Suggeted-by: Joe Mario <jmario@redhat.com>
Original-by: Dick Fowles <rfowles@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 456 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 456 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 014c9b0..b1d4a8b 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -12,6 +12,7 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <sched.h>
+#include <math.h>
 
 typedef struct {
 	int  locks;               /* count of 'lock' transactions */
@@ -46,6 +47,20 @@ struct c2c_stats {
 	struct stats		stats;
 };
 
+struct c2c_latency_stats {
+	int    min;
+	int    mode;
+	int    max;
+	int    cnt;
+	int    thrshld;
+	double median;
+	double stddev;
+	double cv;
+	double ci;
+	double mean;
+	struct rb_node *start;
+};
+
 struct perf_c2c {
 	struct perf_tool tool;
 	bool		 raw_records;
@@ -60,6 +75,7 @@ struct perf_c2c {
 
 struct c2c_entry {
 	struct rb_node		rb_node;
+	struct rb_node		latency;
 	struct list_head	scratch;  /* scratch list for resorting */
 	struct thread		*thread;
 	int			tid;  /* FIXME perf maps broken */
@@ -97,6 +113,21 @@ struct c2c_hit {
 	struct callchain_root   callchain[0]; /* must be last member */
 };
 
+typedef struct {
+	const char *label;
+	const char *fmt;
+	void       *overall;
+	void       *extremes;
+	void       *analyze;
+} stats_t;
+
+
+enum { EMPTY, SYMBOL, OBJECT };
+enum { OVERALL, EXTREMES, ANALYZE, SCOPES };
+enum { INVALID, NONE, INTEGER, DOUBLE };
+
+struct c2c_latency_stats hist_info[SCOPES];
+
 enum { OP, LVL, SNP, LCK, TLB };
 
 #define RMT_RAM              (PERF_MEM_LVL_REM_RAM1 | PERF_MEM_LVL_REM_RAM2)
@@ -512,6 +543,34 @@ static int c2c_hitm__add_to_list(struct rb_root *root, struct c2c_hit *h)
 	return 0;
 }
 
+static int c2c_latency__add_to_list(struct rb_root *root, struct c2c_entry *n)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct c2c_entry *ne;
+	int64_t cmp;
+
+	p = &root->rb_node;
+
+	while (*p != NULL) {
+		parent = *p;
+		ne = rb_entry(parent, struct c2c_entry, latency);
+
+		/* sort on weight */
+		cmp = ne->weight - n->weight;
+
+		if (cmp > 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&n->latency, parent, p);
+	rb_insert_color(&n->latency, root);
+
+	return 0;
+}
+
 static int perf_c2c__fprintf_header(FILE *fp)
 {
 	int printed = fprintf(fp, "%c %-16s  %6s  %6s  %4s  %18s  %18s  %18s  %6s  %-10s %-60s %s\n", 
@@ -1048,6 +1107,402 @@ cleanup:
 	}
 }
 
+stats_t data[] = {
+	{ "Samples           ", "%20d",   &hist_info[OVERALL].cnt,     &hist_info[EXTREMES].cnt,     &hist_info[ANALYZE].cnt     },
+	{ " ",                   NULL,    NULL,                        NULL,                         NULL                        },
+	{ "Minimum           ", "%20d",   &hist_info[OVERALL].min,     &hist_info[EXTREMES].min,     &hist_info[ANALYZE].min     },
+	{ "Maximum           ", "%20d",   &hist_info[OVERALL].max,     &hist_info[EXTREMES].max,     &hist_info[ANALYZE].max     },
+	{ "Threshold         ", "%20d",   &hist_info[OVERALL].thrshld, &hist_info[EXTREMES].thrshld, &hist_info[ANALYZE].thrshld },
+	{ " ",                   NULL,    NULL,                        NULL,                         NULL                        },
+	{ "Mode              ", "%20d",   &hist_info[OVERALL].mode,    &hist_info[EXTREMES].mode,    &hist_info[ANALYZE].mode    },
+	{ "Median            ", "%20.0f", &hist_info[OVERALL].median,  &hist_info[EXTREMES].median,  &hist_info[ANALYZE].median  },
+	{ "Mean              ", "%20.0f", &hist_info[OVERALL].mean,    &hist_info[EXTREMES].mean,    &hist_info[ANALYZE].mean    },
+	{ " ",                   NULL,    NULL,                        NULL,                         NULL                        },
+	{ "Std Dev           ", "%20.1f", &hist_info[OVERALL].stddev,  &hist_info[EXTREMES].stddev,  &hist_info[ANALYZE].stddev   },
+	{ "Coeff of Variation", "%20.3f", &hist_info[OVERALL].cv,      &hist_info[EXTREMES].cv,      &hist_info[ANALYZE].cv      },
+	{ "Confid Interval   ", "%20.1f", &hist_info[OVERALL].ci,      &hist_info[EXTREMES].ci,      &hist_info[ANALYZE].ci      },
+};
+
+#define STATS_ENTRIES (sizeof(data) / sizeof(stats_t))
+enum { C90, C95 };
+
+static double tdist(int ci, int num_samples)
+{
+	#define MAX_ENTRIES       32
+	#define INFINITE_SAMPLES  (MAX_ENTRIES-1)
+
+	/*
+	 * Student's T-distribution for 90% & 95% confidence intervals
+	 * The last entry is the value for infinite degress of freedom 
+	 */
+
+	static double t_dist[MAX_ENTRIES][2] = {
+				{ NAN,     NAN   },        /*   0  */
+				{ 6.31,   12.71  },        /*   1  */
+				{ 2.92,    4.30  },        /*   2  */
+				{ 2.35,    3.18  },        /*   3  */
+				{ 2.13,    2.78  },        /*   4  */
+				{ 2.02,    2.57  },        /*   5  */
+				{ 1.94,    2.45  },        /*   6  */
+				{ 1.90,    2.36  },        /*   7  */
+				{ 1.86,    2.31  },        /*   8  */
+				{ 1.83,    2.26  },        /*   9  */
+				{ 1.81,    2.23  },        /*  10  */
+				{ 1.80,    2.20  },        /*  11  */
+				{ 1.78,    2.18  },        /*  12  */
+				{ 1.77,    2.16  },        /*  13  */
+				{ 1.76,    2.14  },        /*  14  */
+				{ 1.75,    2.13  },        /*  15  */
+				{ 1.75,    2.12  },        /*  16  */
+				{ 1.74,    2.11  },        /*  17  */
+				{ 1.73,    2.10  },        /*  18  */
+				{ 1.73,    2.09  },        /*  19  */
+				{ 1.72,    2.09  },        /*  20  */
+				{ 1.72,    2.08  },        /*  21  */
+				{ 1.72,    2.07  },        /*  22  */
+				{ 1.71,    2.07  },        /*  23  */
+				{ 1.71,    2.06  },        /*  24  */
+				{ 1.71,    2.06  },        /*  25  */
+				{ 1.71,    2.06  },        /*  26  */
+				{ 1.70,    2.05  },        /*  27  */
+				{ 1.70,    2.05  },        /*  28  */
+				{ 1.70,    2.04  },        /*  29  */
+				{ 1.70,    2.04  },        /*  30  */
+				{ 1.645,   1.96  },        /*  31  */
+	};
+
+	double tvalue;
+
+	tvalue = 0;
+
+	switch (ci) {
+
+	case C90: /* 90% CI */
+		tvalue = ((num_samples-1) > 30) ? t_dist[INFINITE_SAMPLES][ci] : t_dist[num_samples-1][ci];
+		break;
+
+	case C95: /* 95% CI */
+		tvalue = ((num_samples-1) > 30) ? t_dist[INFINITE_SAMPLES][ci] : t_dist[num_samples-1][ci];
+		break;
+
+	default:
+		printf("internal error - invalid confidence interval value specified");
+		break;
+	}
+
+	return tvalue;
+}
+
+static inline void print_latency_info_header(void)
+{
+	const char	*title;
+	char		hdrstr[256];
+	int		twidth;
+	int		size;
+	int		pad;
+	int		i;
+
+	twidth = sprintf(hdrstr, "%-20s%20s%20s%20s",
+				"Metric", "Overall", "Extremes", "Selected");
+	title = "Execution Latency For Loads to Non Shared Memory";
+	size  = strlen(title);
+	pad   = (twidth - size)/2;
+
+	printf("\n\n");
+	for (i = 0; i < twidth; i++) printf("=");
+	printf("\n");
+
+	if (pad > 0) {
+		for (i = 0; i < pad; i++) printf(" ");
+	}
+	printf("%s\n", title);
+	printf("\n");
+
+	printf("%s\n", hdrstr);
+
+	for (i = 0; i < twidth; i++) printf("=");
+	printf("\n");
+}
+
+static void print_latency_info(void)
+{
+#define  LBLFMT "%-20s"
+
+	char	fmtstr[32];
+	int	i, dtype;
+	stats_t *ptr;
+
+	print_latency_info_header();
+
+	for (i = 0; i < (int)STATS_ENTRIES; i++) {
+
+		ptr = &data[i];
+
+		dtype = INVALID;
+
+		if (ptr->fmt == NULL)  {
+
+			dtype = EMPTY;
+
+		} else {
+
+			if (strchr(ptr->fmt, 'd') != NULL) dtype = INTEGER;
+			if (strchr(ptr->fmt, 'f') != NULL) dtype = DOUBLE;
+
+			strcpy(fmtstr, ptr->fmt);
+			strtok(fmtstr, ".d");
+			strcat(fmtstr, "s");
+
+		}
+
+		switch (dtype) {
+
+		case INTEGER:
+			printf(LBLFMT, ptr->label);
+			(ptr->overall  != NULL) ? printf(ptr->fmt, *((int *)ptr->overall))  : printf(fmtstr, "na");
+			(ptr->extremes != NULL) ? printf(ptr->fmt, *((int *)ptr->extremes)) : printf(fmtstr, "na");
+			(ptr->analyze  != NULL) ? printf(ptr->fmt, *((int *)ptr->analyze))  : printf(fmtstr, "na");
+			printf("\n");
+			break;
+
+
+		case DOUBLE:
+			printf(LBLFMT, ptr->label);
+			(ptr->overall  != NULL) ? printf(ptr->fmt, *((double *)ptr->overall))  : printf(fmtstr, "na");
+			(ptr->extremes != NULL) ? printf(ptr->fmt, *((double *)ptr->extremes)) : printf(fmtstr, "na");
+			(ptr->analyze  != NULL) ? printf(ptr->fmt, *((double *)ptr->analyze))  : printf(fmtstr, "na");
+			printf("\n");
+			break;
+
+
+		case EMPTY:
+			printf("\n");
+			break;
+
+
+		default:
+			printf("internal error - unsupported formtat specifier : %s\n", ptr->fmt);
+			break;
+
+		};
+
+	}
+	printf("\n\n");
+}
+
+static void calculate_latency_info(struct rb_root *tree,
+				   struct stats *stats,
+				   struct c2c_latency_stats *overall,
+				   struct c2c_latency_stats *extremes,
+				   struct c2c_latency_stats *selected)
+{
+	struct rb_node *next = rb_first(tree);
+	struct rb_node *start = NULL;
+	struct c2c_entry *n;
+	int count = 0, weight = 0;
+	int mode = 0, mode_count = 0, idx = 0;
+	int median;
+	double threshold;
+	struct stats s;
+
+
+	median = stats->n / 2.0;
+
+	overall->cnt = stats->n;
+	overall->min = stats->min;
+	overall->max = stats->max;
+	overall->thrshld = 0;
+	overall->mean = avg_stats(stats);
+	overall->stddev = stddev_stats(stats);
+	overall->cv = overall->stddev / overall->mean;
+	overall->ci = (tdist(C90, stats->n) * stddev_stats(stats)) / sqrt(stats->n);
+	overall->start = next;
+
+	/* set threshold to mean + 3 * stddev of stats */
+	threshold = avg_stats(stats) + 3 * stddev_stats(stats);
+	init_stats(&s);
+
+	/* calculate overall latency */
+	while (next) {
+		n = rb_entry(next, struct c2c_entry, latency);
+		next = rb_next(&n->latency);
+
+		/* sorted on weight, makes counting easy, look for boundary */
+		if (n->weight != weight) {
+			if (count > mode_count) {
+				mode = weight;
+				mode_count = count;
+			}
+			count = 0;
+			weight = n->weight;
+		}
+		count++;
+
+		if (idx == median)
+			overall->median = n->weight;
+
+		/* save start for extreme latency calculation */
+		if (n->weight > threshold) {
+			if (!start)
+				start = next;
+
+			update_stats(&s, n->weight);
+		}
+
+		idx++;
+	}
+	/* count last set */
+	if (count > mode_count)
+		mode = weight;
+
+	overall->mode = mode;
+
+	/* calculate extreme latency */
+	next = start;
+	start = NULL;
+	idx = 0;
+	count = 0;
+	mode_count = 0;
+	mode = 0;
+	weight = 0;
+	median = s.n / 2.0;
+
+	extremes->cnt = s.n;
+	extremes->min = s.min;
+	extremes->max = s.max;
+	extremes->thrshld = threshold;
+	extremes->mean = avg_stats(&s);
+	extremes->stddev = stddev_stats(&s);
+	extremes->cv = extremes->stddev / extremes->mean;
+	extremes->ci = (tdist(C90, s.n) * stddev_stats(&s)) / sqrt(s.n);
+	extremes->start = next;
+
+	/* set threshold to mean + 3 * stddev of stats */
+	threshold = avg_stats(&s) + 3 * stddev_stats(&s);
+	init_stats(&s);
+
+	while (next) {
+		n = rb_entry(next, struct c2c_entry, latency);
+		next = rb_next(&n->latency);
+
+		/* sorted on weight, makes counting easy, look for boundary */
+		if (n->weight != weight) {
+			if (count > mode_count) {
+				mode = weight;
+				mode_count = count;
+			}
+			count = 0;
+			weight = n->weight;
+		}
+		count++;
+
+		if (idx == median)
+			extremes->median = n->weight;
+
+		/* save start for extreme latency calculation */
+		if (n->weight > threshold) {
+			if (!start)
+				start = next;
+
+			update_stats(&s, n->weight);
+		}
+
+		idx++;
+	}
+	/* count last set */
+	if (count > mode_count)
+		mode = weight;
+
+	extremes->mode = mode;
+
+	/* calculate analyze latency */
+	next = start;
+	idx = 0;
+	count = 0;
+	mode_count = 0;
+	mode = 0;
+	weight = 0;
+	median = s.n / 2.0;
+
+	selected->cnt = s.n;
+	selected->min = s.min;
+	selected->max = s.max;
+	selected->thrshld = threshold;
+	selected->mean = avg_stats(&s);
+	selected->stddev = stddev_stats(&s);
+	selected->cv = selected->stddev / selected->mean;
+	selected->ci = (tdist(C90, s.n) * stddev_stats(stats)) / sqrt(s.n);
+	selected->start = next;
+
+	while (next) {
+		n = rb_entry(next, struct c2c_entry, latency);
+		next = rb_next(&n->latency);
+
+		/* sorted on weight, makes counting easy, look for boundary */
+		if (n->weight != weight) {
+			if (count > mode_count) {
+				mode = weight;
+				mode_count = count;
+			}
+			count = 0;
+			weight = n->weight;
+		}
+		count++;
+
+		if (idx == median)
+			selected->median = n->weight;
+
+		idx++;
+	}
+	/* count last set */
+	if (count > mode_count)
+		mode = weight;
+
+	selected->mode = mode;
+}
+
+static void c2c_analyze_latency(struct perf_c2c *c2c)
+{
+
+	struct rb_node *next = rb_first(&c2c->tree_physid);
+	struct c2c_entry *n;
+	struct c2c_latency_stats *overall, *extremes, *selected;
+	struct rb_root lat_tree = RB_ROOT;
+	struct c2c_stats lat_stats;
+	u64 snoop;
+	struct stats s;
+
+	init_stats(&s);
+	memset(&lat_stats, 0, sizeof(struct c2c_stats));
+	memset(&hist_info, 0, sizeof(struct c2c_latency_stats) * SCOPES);
+
+	overall = &hist_info[OVERALL];
+	extremes = &hist_info[EXTREMES];
+	selected = &hist_info[ANALYZE];
+
+	/* sort on latency */
+	while (next) {
+		n = rb_entry(next, struct c2c_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		snoop  = n->mi->data_src.mem_snoop;
+
+		/* filter out HITs as un-interesting */
+		if ((snoop & P(SNOOP, HIT)) ||
+		    (snoop & P(SNOOP, HITM)) ||
+		    (snoop & P(SNOOP, NA)))
+			continue;
+
+		c2c_latency__add_to_list(&lat_tree, n);
+		update_stats(&s, n->weight);
+	}
+
+	calculate_latency_info(&lat_tree, &s, overall, extremes, selected);
+	print_latency_info();
+
+	return;
+}
+
 static void print_c2c_shared_cacheline_report(struct rb_root *hitm_tree,
 					      struct c2c_stats *shared_stats __maybe_unused,
 					      struct c2c_stats *c2c_stats __maybe_unused)
@@ -1761,6 +2216,7 @@ static int perf_c2c__process_events(struct perf_session *session,
 	if (verbose > 2)
 		dump_rb_tree(&c2c->tree_physid, c2c);
 	print_c2c_trace_report(c2c);
+	c2c_analyze_latency(c2c);
 	c2c_analyze_hitms(c2c);
 	print_symbol_record_count(&c2c->tree_physid);
 
-- 
1.7.11.7

