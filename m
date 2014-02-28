Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaB1Rnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:43:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbaB1Rnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:45 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 13/19] perf, c2c: Sort based on hottest cache line
Date: Fri, 28 Feb 2014 12:43:02 -0500
Message-Id: <1393609388-40489-14-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have all the events sort on a unique address, we can walk
the rbtree sequential and count up all the HITMs for each cacheline
fairly easily.

Once we encounter a new event on a different cacheline, process the previous
cacheline.  That includes determining if any HITMs were present on that
cacheline and if so, add it to another rbtree sorted on the number of HITMs.

This second rbtree sorted on number of HITMs will be the interesting data
we want to report and will be displayed in a follow up patch.

For now, organize the data properly.

V2: re-work using hist_entries

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 201 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 201 insertions(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 5deb7cc..30cb8c3 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -58,6 +58,25 @@ struct perf_c2c {
 	struct c2c_stats	stats;
 };
 
+#define CACHE_LINESIZE       64
+#define CLINE_OFFSET_MSK     (CACHE_LINESIZE - 1)
+#define CLADRS(a)            ((a) & ~(CLINE_OFFSET_MSK))
+#define CLOFFSET(a)          (int)((a) &  (CLINE_OFFSET_MSK))
+
+struct c2c_hit {
+	struct rb_node	rb_node;
+	struct rb_root  tree;
+	struct list_head list;
+	u64		cacheline;
+	int		color;
+	struct c2c_stats	stats;
+	pid_t		pid;
+	pid_t		tid;
+	u64		daddr;
+	u64		iaddr;
+	struct mem_info	*mi;
+};
+
 enum { OP, LVL, SNP, LCK, TLB };
 
 #define RMT_RAM              (PERF_MEM_LVL_REM_RAM1 | PERF_MEM_LVL_REM_RAM2)
@@ -153,6 +172,44 @@ static int perf_c2c__scnprintf_data_src(char *bf, size_t size, uint64_t val)
 	return printed;
 }
 
+static int c2c_hitm__add_to_list(struct rb_root *root, struct c2c_hit *h)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct c2c_hit *he;
+	int64_t cmp;
+	u64 l_hitms, r_hitms;
+
+	p = &root->rb_node;
+
+	while (*p != NULL) {
+		parent = *p;
+		he = rb_entry(parent, struct c2c_hit, rb_node);
+
+		/* sort on remote hitms first */
+		l_hitms = he->stats.t.rmt_hitm;
+		r_hitms = h->stats.t.rmt_hitm;
+		cmp = r_hitms - l_hitms;
+
+		if (!cmp) {
+			/* sort on local hitms */
+			l_hitms = he->stats.t.lcl_hitm;
+			r_hitms = h->stats.t.lcl_hitm;
+			cmp = r_hitms - l_hitms;
+		}
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
@@ -305,6 +362,50 @@ static int c2c_decode_stats(struct c2c_stats *stats, struct hist_entry *entry)
 	return err;
 }
 
+static struct c2c_hit *c2c_hit__new(u64 cacheline, struct hist_entry *entry)
+{
+	struct c2c_hit *h = zalloc(sizeof(struct c2c_hit));
+
+	if (!h) {
+		pr_err("Could not allocate c2c_hit memory\n");
+		return NULL;
+	}
+
+	CPU_ZERO(&h->stats.cpuset);
+	INIT_LIST_HEAD(&h->list);
+	init_stats(&h->stats.stats);
+	h->tree = RB_ROOT;
+	h->cacheline = cacheline;
+	h->pid = entry->thread->pid_;
+	h->tid = entry->thread->tid;
+
+	/* use original addresses here, not adjusted al_addr */
+	h->iaddr = entry->mem_info->iaddr.addr;
+	h->daddr = entry->mem_info->daddr.addr;
+
+	h->mi = entry->mem_info;
+	return h;
+}
+
+static void c2c_hit__update_strings(struct c2c_hit *h,
+				    struct hist_entry *n)
+{
+	if (h->pid != n->thread->pid_)
+		h->pid = -1;
+
+	if (h->tid != n->thread->tid)
+		h->tid = -1;
+
+	/* use original addresses here, not adjusted al_addr */
+	if (h->iaddr != n->mem_info->iaddr.addr)
+		h->iaddr = -1;
+
+	if (CLADRS(h->daddr) != CLADRS(n->mem_info->daddr.addr))
+		h->daddr = -1;
+
+	CPU_SET(n->cpu, &h->stats.cpuset);
+}
+
 static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -420,6 +521,104 @@ err:
 	return err;
 }
 
+#define HAS_HITMS(h) (h->stats.t.lcl_hitm || h->stats.t.rmt_hitm)
+
+static void c2c_hit__update_stats(struct c2c_stats *new,
+				  struct c2c_stats *old)
+{
+	new->t.load		+= old->t.load;
+	new->t.ld_fbhit		+= old->t.ld_fbhit;
+	new->t.ld_l1hit		+= old->t.ld_l1hit;
+	new->t.ld_l2hit		+= old->t.ld_l2hit;
+	new->t.ld_llchit	+= old->t.ld_llchit;
+	new->t.locks		+= old->t.locks;
+	new->t.lcl_dram		+= old->t.lcl_dram;
+	new->t.rmt_dram		+= old->t.rmt_dram;
+	new->t.lcl_hitm		+= old->t.lcl_hitm;
+	new->t.rmt_hitm		+= old->t.rmt_hitm;
+	new->t.rmt_hit		+= old->t.rmt_hit;
+	new->t.store		+= old->t.store;
+	new->t.st_l1hit		+= old->t.st_l1hit;
+
+	new->total_period	+= old->total_period;
+}
+
+static inline int valid_hitm_or_store(union perf_mem_data_src *dsrc)
+{
+	return ((dsrc->mem_snoop & P(SNOOP,HITM)) ||
+		(dsrc->mem_op & P(OP,STORE)));
+}
+
+static void c2c_analyze_hitms(struct perf_c2c *c2c)
+{
+
+	struct rb_node *next = rb_first(c2c->hists.entries_in);
+	struct hist_entry *he;
+	struct c2c_hit *h = NULL;
+	struct c2c_stats hitm_stats;
+	struct rb_root hitm_tree = RB_ROOT;
+	int shared_clines = 0;
+	u64 cl = 0;
+
+	memset(&hitm_stats, 0, sizeof(struct c2c_stats));
+
+	/* find HITMs */
+	while (next) {
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
+
+		cl = he->mem_info->daddr.al_addr;
+
+		/* switch cache line objects */
+		/* 'color' forces a boundary change based on the original sort */
+		if (!h || !he->color || (CLADRS(cl) != h->cacheline)) {
+			if (h && HAS_HITMS(h)) {
+				c2c_hit__update_stats(&hitm_stats, &h->stats);
+
+				/* sort based on hottest cacheline */
+				c2c_hitm__add_to_list(&hitm_tree, h);
+				shared_clines++;
+			} else {
+				/* stores-only are un-interesting */
+				free(h);
+			}
+			h = c2c_hit__new(CLADRS(cl), he);
+			if (!h)
+				goto cleanup;
+		}
+
+
+		c2c_decode_stats(&h->stats, he);
+
+		/* filter out non-hitms as un-interesting noise */
+		if (valid_hitm_or_store(&he->mem_info->data_src)) {
+			/* save the entry for later processing */
+			list_add_tail(&he->pairs.node, &h->list);
+
+			c2c_hit__update_strings(h, he);
+		}
+	}
+
+	/* last chunk */
+	if (HAS_HITMS(h)) {
+		c2c_hit__update_stats(&hitm_stats, &h->stats);
+		c2c_hitm__add_to_list(&hitm_tree, h);
+		shared_clines++;
+	} else
+		free(h);
+
+cleanup:
+	next = rb_first(&hitm_tree);
+	while (next) {
+		h = rb_entry(next, struct c2c_hit, rb_node);
+		next = rb_next(&h->rb_node);
+		rb_erase(&h->rb_node, &hitm_tree);
+
+		free(h);
+	}
+	return;
+}
+
 static int perf_c2c__process_events(struct perf_session *session,
 				    struct perf_c2c *c2c)
 {
@@ -431,6 +630,8 @@ static int perf_c2c__process_events(struct perf_session *session,
 		goto err;
 	}
 
+	c2c_analyze_hitms(c2c);
+
 err:
 	return err;
 }
-- 
1.7.11.7

