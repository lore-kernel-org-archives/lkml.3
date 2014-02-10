Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaBJRc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:32:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbaBJRbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:31:03 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 20/21] perf, c2c: Add selected extreme latencies to output cacheline stats table
Date: Mon, 10 Feb 2014 12:29:15 -0500
Message-Id: <1392053356-23024-21-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just takes the previously calculated extreme latencies and prints them
in a pretty table with the cacheline and its offsets exposed for to help
further understand what they are coming from.

Original work done by Dick Fowles, ported to perf by me.

Suggested-by: Joe Mario <jmario@redhat.com>
Original-by: Dick Fowles <rfowles@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 265 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 265 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index b1d4a8b..1fa21b4 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -76,6 +76,7 @@ struct perf_c2c {
 struct c2c_entry {
 	struct rb_node		rb_node;
 	struct rb_node		latency;
+	struct rb_node		latency_scratch;
 	struct list_head	scratch;  /* scratch list for resorting */
 	struct thread		*thread;
 	int			tid;  /* FIXME perf maps broken */
@@ -571,6 +572,62 @@ static int c2c_latency__add_to_list(struct rb_root *root, struct c2c_entry *n)
 	return 0;
 }
 
+static struct c2c_entry *c2c_latency__add_to_list_physid(struct rb_root *root,
+							 struct c2c_entry *entry)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct c2c_entry *ce;
+	int64_t cmp;
+
+	p = &root->rb_node;
+
+	while (*p != NULL) {
+		parent = *p;
+		ce = rb_entry(parent, struct c2c_entry, latency_scratch);
+
+		cmp = physid_cmp(ce, entry);
+
+		if (cmp > 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&entry->latency_scratch, parent, p);
+	rb_insert_color(&entry->latency_scratch, root);
+
+	return entry;
+}
+
+static int c2c_latency__add_to_list_count(struct rb_root *root,
+					  struct c2c_hit *h)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct c2c_hit *he;
+	int64_t cmp;
+
+	p = &root->rb_node;
+
+	while (*p != NULL) {
+		parent = *p;
+		he = rb_entry(parent, struct c2c_hit, rb_node);
+
+		cmp = h->stats.stats.n - he->stats.stats.n;
+
+		if (cmp > 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&h->rb_node, parent, p);
+	rb_insert_color(&h->rb_node, root);
+
+	return 0;
+}
+
 static int perf_c2c__fprintf_header(FILE *fp)
 {
 	int printed = fprintf(fp, "%c %-16s  %6s  %6s  %4s  %18s  %18s  %18s  %6s  %-10s %-60s %s\n", 
@@ -1107,6 +1164,209 @@ cleanup:
 	}
 }
 
+static void print_latency_select_cacheline_offset(struct c2c_hit *offset,
+						  int total)
+{
+	struct stats *s = &offset->stats.stats;
+	struct addr_map_symbol *ams = &offset->mi->iaddr;
+
+	printf("%5s %6s %6s %7.1f%% %14s0x%02lx %#18lx %8ld %7.1f %8ld %7.1f %7.1f%%  %-30s %-20s\n",
+		" ",
+		" ",
+		" ",
+		((double) s->n / (double)total) * 100.0,
+		" ",
+		(cloffset == LVL2) ? (offset->mi->daddr.addr & 0xff) : CLOFFSET(offset->mi->daddr.addr),
+		offset->mi->iaddr.addr,
+		s->min,
+		0.0,
+		s->max,
+		avg_stats(s),
+		(stddev_stats(s)/avg_stats(s) * 100.0),
+		(ams->sym ? ams->sym->name : "?????"),
+		ams->map->dso->short_name);
+}
+
+static void print_latency_select_header(void)
+{
+#define EXCESS_LATENCY_TITLE "Non Shared Data Loads With Excessive Execution Latency"
+
+	static char delimit[MAXTITLE_SZ];
+	static char title[MAXTITLE_SZ];
+	int      pad;
+	int      i;
+
+	sprintf(title, "%5s %6s %6s %8s %18s %18s %8s %8s %8s %8s %8s  %-30s %-20s",
+		"Num",
+		"%dist",
+		"%cumm",
+		"Count",
+		"Data Address",
+		"Inst Address",
+		"Min",
+		"Median",
+		"Max",
+		"Mean",
+		"CV",
+		"Symbol",
+		"Object");
+
+	memset(delimit, 0, sizeof(delimit));
+	for (i = 0; i < (int)strlen(title); i++) delimit[i] = '=';
+
+	printf("\n\n");
+	printf("%s\n", delimit);
+
+	pad = (strlen(title)/2) - (strlen(EXCESS_LATENCY_TITLE)/2);
+	for (i = 0; i < pad; i++) printf(" ");
+	printf("%s\n", EXCESS_LATENCY_TITLE);
+	printf("\n");
+
+	printf("%5s %6s %6s %8s %18s %18s %44s  %-30s %-20s\n",
+		" ",
+		" ",
+		" ",
+		"Load",
+		" ",
+		" ",
+		"------ Load Inst Execute Latency ------",
+		" ",
+		" ");
+
+	printf("%s\n", title);
+	printf("%s\n", delimit);
+}
+
+static void print_latency_select_info(struct rb_root *root,
+				      struct c2c_stats *stats)
+{
+#define XLAT_DIST_LIMIT 0.1
+
+	struct rb_node *next = rb_first(root);
+	struct c2c_hit *h, *clo = NULL;
+	struct c2c_entry *entry;
+	double tot_dist, tot_cumm;
+	int idx = 0, j;
+	static char delimit[MAXTITLE_SZ];
+	static char summary[MAXTITLE_SZ];
+
+	print_latency_select_header();
+
+	tot_cumm = 0.0;
+
+	while (next) {
+		h = rb_entry(next, struct c2c_hit, rb_node);
+		next = rb_next(&h->rb_node);
+
+		tot_dist  = ((double)h->stats.stats.n / stats->stats.n);
+		tot_cumm += tot_dist;
+
+		/*
+		 * don't display lines with insignificant sharing contribution
+		 */
+		if (tot_dist*100.0 < XLAT_DIST_LIMIT)
+			break;
+
+		sprintf(summary, "%5d %5.1f%% %5.1f%% %8d %#18lx",
+			idx,
+			tot_dist*100.0,
+			tot_cumm*100.0,
+			(int)h->stats.stats.n,
+			h->cacheline);
+
+		if (delimit[0] != '-') {
+			memset(delimit, 0, sizeof(delimit));
+			for (j = 0; j < (int)strlen(summary); j++) delimit[j] = '-';
+		}
+
+		printf("%s\n", delimit);
+		printf("%s\n", summary);
+		printf("%s\n", delimit);
+
+		list_for_each_entry(entry, &h->list, scratch) {
+
+			if (!clo || !matching_coalescing(clo, entry)) {
+				u64 addr;
+
+				if (clo)
+					print_latency_select_cacheline_offset(clo, h->stats.stats.n);
+
+				free(clo);
+				addr = entry->mi->iaddr.al_addr;
+				clo = c2c_hit__new(addr, entry);
+			}
+			update_stats(&clo->stats.stats, entry->weight);
+		}
+		if (clo) {
+			print_latency_select_cacheline_offset(clo, h->stats.stats.n);
+			free(clo);
+			clo = NULL;
+		}
+
+		idx++;
+	}
+	printf("\n\n");
+}
+
+static void calculate_latency_selected_info(struct rb_root *root,
+					    struct rb_node *start,
+					    struct c2c_stats *lat_stats)
+{
+	struct rb_node *next = start;
+	struct rb_root lat_tree = RB_ROOT;
+	struct c2c_hit *h = NULL;
+	struct c2c_entry *n;
+	u64 cl;
+
+	/* new sort of 'selected' tree using physid_cmp */
+	while (next) {
+		n = rb_entry(next, struct c2c_entry, latency);
+		next = rb_next(&n->latency);
+
+		c2c_latency__add_to_list_physid(&lat_tree, n);
+	}
+
+	/* resort based on number of entries in each cacheline */
+	next = rb_first(&lat_tree);
+	while (next) {
+		n = rb_entry(next, struct c2c_entry, latency_scratch);
+		next = rb_next(&n->latency_scratch);
+
+		cl = n->mi->daddr.al_addr;
+
+		/* switch cache line objects */
+		/* 'color' forces a boundary change based on the original sort */
+		if (!h || !n->color || (CLADRS(cl) != h->cacheline)) {
+			if (h)
+				c2c_latency__add_to_list_count(root, h);
+
+			h = c2c_hit__new(CLADRS(cl), n);
+			if (!h)
+				goto cleanup;
+		}
+
+		update_stats(&h->stats.stats, n->weight);
+		update_stats(&lat_stats->stats, n->weight);
+
+		/* save the entry for later processing */
+		list_add_tail(&n->scratch, &h->list);
+	}
+	/* last chunk */
+	if (h)
+		c2c_latency__add_to_list_count(root, h);
+	return;
+
+cleanup:
+	next = rb_first(root);
+	while (next) {
+		h = rb_entry(next, struct c2c_hit, rb_node);
+		next = rb_next(&h->rb_node);
+		rb_erase(&h->rb_node, root);
+
+		free(h);
+	}
+}
+
 stats_t data[] = {
 	{ "Samples           ", "%20d",   &hist_info[OVERALL].cnt,     &hist_info[EXTREMES].cnt,     &hist_info[ANALYZE].cnt     },
 	{ " ",                   NULL,    NULL,                        NULL,                         NULL                        },
@@ -1471,6 +1731,8 @@ static void c2c_analyze_latency(struct perf_c2c *c2c)
 	struct c2c_stats lat_stats;
 	u64 snoop;
 	struct stats s;
+	int i;
+	struct rb_root lat_select_tree = RB_ROOT;
 
 	init_stats(&s);
 	memset(&lat_stats, 0, sizeof(struct c2c_stats));
@@ -1500,6 +1762,9 @@ static void c2c_analyze_latency(struct perf_c2c *c2c)
 	calculate_latency_info(&lat_tree, &s, overall, extremes, selected);
 	print_latency_info();
 
+	calculate_latency_selected_info(&lat_select_tree, selected->start, &lat_stats);
+	print_latency_select_info(&lat_select_tree, &lat_stats);
+
 	return;
 }
 
-- 
1.7.11.7

