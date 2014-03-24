Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaCXTiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbaCXTh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:37:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, peterz@infradead.org, eranian@google.com,
        andi.kleen@intel.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 11/15 V3] perf, c2c: Add callchain support
Date: Mon, 24 Mar 2014 15:37:02 -0400
Message-Id: <1395689826-215033-12-git-send-email-dzickus@redhat.com>
In-Reply-To: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing cacheline statistics is useful by itself.  Seeing the callchain
for these cache contentions saves time tracking things down.

This patch tries to add callchain support.  I had to use the generic
interface from a previous patch to output things to stdout easily.

Other than the displaying the results, collecting the callchain and
merging it was fairly straightforward.

I used a lot of copying-n-pasting from other builtin tools to get
the intial parameter setup correctly and the automatic reading of
'symbol_conf.use_callchain' from the data file.

Hopefully this is all correct.  The amount of memory corruption (from the
callchain dynamic array) seems to have dwindled done to nothing. :-)

V2: update to latest api
V3: remove call_graph variable, unused

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index e3dbb76..363deec 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -79,6 +79,8 @@ struct c2c_hit {
 	u64		daddr;
 	u64		iaddr;
 	struct mem_info	*mi;
+
+	struct callchain_root   callchain[0]; /* must be last member */
 };
 
 enum { OP, LVL, SNP, LCK, TLB };
@@ -382,7 +384,8 @@ static int c2c_decode_stats(struct c2c_stats *stats, struct hist_entry *entry)
 
 static struct c2c_hit *c2c_hit__new(u64 cacheline, struct hist_entry *entry)
 {
-	struct c2c_hit *h = zalloc(sizeof(struct c2c_hit));
+	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
+	struct c2c_hit *h = zalloc(sizeof(struct c2c_hit) + callchain_size);
 
 	if (!h) {
 		pr_err("Could not allocate c2c_hit memory\n");
@@ -396,6 +399,8 @@ static struct c2c_hit *c2c_hit__new(u64 cacheline, struct hist_entry *entry)
 	h->cacheline = cacheline;
 	h->pid = entry->thread->pid_;
 	h->tid = entry->thread->tid;
+	if (symbol_conf.use_callchain)
+		callchain_init(h->callchain);
 
 	/* use original addresses here, not adjusted al_addr */
 	h->iaddr = entry->mem_info->iaddr.addr;
@@ -519,6 +524,10 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 		return 0;
 	}
 
+	err = sample__resolve_callchain(sample, &parent, evsel, al, PERF_MAX_STACK_DEPTH);
+	if (err)
+		return err;
+
 	cost = sample->weight;
 	if (!cost)
 		cost = 1;
@@ -547,6 +556,7 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 
 	c2c->hists.stats.total_period += cost;
 	hists__inc_nr_events(&c2c->hists, PERF_RECORD_SAMPLE);
+	err = hist_entry__append_callchain(he, sample);
 	return err;
 
 out_mem:
@@ -948,6 +958,13 @@ static void print_hitm_cacheline_offset(struct c2c_hit *clo,
 		print_socket_shared_str(node_stats);
 
 	printf("\n");
+
+	if (symbol_conf.use_callchain) {
+		generic_entry_callchain__fprintf(clo->callchain,
+						 h->stats.total_period,
+						 clo->stats.total_period,
+						 23, stdout);
+	}
 }
 
 static void print_c2c_hitm_report(struct rb_root *hitm_tree,
@@ -1024,6 +1041,12 @@ static void print_c2c_hitm_report(struct rb_root *hitm_tree,
 				c2c_decode_stats(&node_stats[node], entry);
 				CPU_SET(entry->cpu, &(node_stats[node].cpuset));
 			}
+			if (symbol_conf.use_callchain) {
+				callchain_cursor_reset(&callchain_cursor);
+				callchain_merge(&callchain_cursor,
+						clo->callchain,
+						entry->callchain);
+			}
 
 		}
 		if (clo) {
@@ -1155,6 +1178,29 @@ err:
 	return err;
 }
 
+static int perf_c2c__setup_sample_type(struct perf_c2c *c2c __maybe_unused,
+				       struct perf_session *session)
+{
+	u64 sample_type = perf_evlist__combined_sample_type(session->evlist);
+
+	if (!(sample_type & PERF_SAMPLE_CALLCHAIN)) {
+		if (symbol_conf.use_callchain) {
+			printf("Selected -g but no callchain data. Did "
+				  "you call 'perf c2c record' without -g?\n");
+			return -1;
+		}
+	} else if (callchain_param.mode != CHAIN_NONE &&
+		   !symbol_conf.use_callchain) {
+			symbol_conf.use_callchain = true;
+			if (callchain_register_param(&callchain_param) < 0) {
+				printf("Can't register callchain params.\n");
+				return -EINVAL;
+			}
+	}
+
+	return 0;
+}
+
 static int perf_c2c__read_events(struct perf_c2c *c2c)
 {
 	int err = -1;
@@ -1174,6 +1220,9 @@ static int perf_c2c__read_events(struct perf_c2c *c2c)
 	if (symbol__init() < 0)
 		goto out_delete;
 
+	if (perf_c2c__setup_sample_type(c2c, session) < 0)
+		goto out_delete;
+
 	/* setup the evsel handlers for each event type */
 	evlist__for_each(session->evlist, evsel) {
 		const char *name = perf_evsel__name(evsel);
@@ -1306,8 +1355,21 @@ opt_no_stores_cb(const struct option *opt __maybe_unused, const char *arg __mayb
 	return 0;
 }
 
+static int
+opt_callchain_cb(const struct option *opt __maybe_unused, const char *arg, int unset)
+{
+	/*
+	 * --no-call-graph
+	 */
+	if (unset)
+		return 0;
+
+	return report_parse_callchain_opt(arg);
+}
+
 int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	char callchain_default_opt[] = "fractal,0.05,callee";
 	struct perf_c2c c2c = {
 		.tool = {
 			.sample		 = perf_c2c__process_sample,
@@ -1340,6 +1402,9 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "separator",
 		   "separator for columns, no spaces will be added"
 		   " between columns '.' is reserved."),
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &c2c, "output_type,min_percent[,print_limit],call_order",
+			     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
+			     "Default: fractal,0.5,callee,function", &opt_callchain_cb, callchain_default_opt),
 	OPT_END()
 	};
 	const char * const c2c_usage[] = {
-- 
1.7.11.7

