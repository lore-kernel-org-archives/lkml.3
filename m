Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaB1Rny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:43:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbaB1Rnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:46 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 15/19] perf, c2c: Add callchain support
Date: Fri, 28 Feb 2014 12:43:04 -0500
Message-Id: <1393609388-40489-16-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
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

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 153 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 150 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index c5f4b5a..8756ca5 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -52,6 +52,7 @@ struct c2c_stats {
 struct perf_c2c {
 	struct perf_tool tool;
 	bool		 raw_records;
+	bool		 call_graph;
 	struct hists	 hists;
 
 	/* stats */
@@ -78,6 +79,8 @@ struct c2c_hit {
 	u64		daddr;
 	u64		iaddr;
 	struct mem_info	*mi;
+
+	struct callchain_root   callchain[0]; /* must be last member */
 };
 
 enum { OP, LVL, SNP, LCK, TLB };
@@ -372,7 +375,8 @@ static int c2c_decode_stats(struct c2c_stats *stats, struct hist_entry *entry)
 
 static struct c2c_hit *c2c_hit__new(u64 cacheline, struct hist_entry *entry)
 {
-	struct c2c_hit *h = zalloc(sizeof(struct c2c_hit));
+	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
+	struct c2c_hit *h = zalloc(sizeof(struct c2c_hit) + callchain_size);
 
 	if (!h) {
 		pr_err("Could not allocate c2c_hit memory\n");
@@ -386,6 +390,8 @@ static struct c2c_hit *c2c_hit__new(u64 cacheline, struct hist_entry *entry)
 	h->cacheline = cacheline;
 	h->pid = entry->thread->pid_;
 	h->tid = entry->thread->tid;
+	if (symbol_conf.use_callchain)
+		callchain_init(h->callchain);
 
 	/* use original addresses here, not adjusted al_addr */
 	h->iaddr = entry->mem_info->iaddr.addr;
@@ -509,6 +515,10 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 		return 0;
 	}
 
+	err = sample__resolve_callchain(sample, &parent, evsel, al, PERF_MAX_STACK_DEPTH);
+	if (err)
+		return err;
+
 	cost = sample->weight;
 	if (!cost)
 		cost = 1;
@@ -544,8 +554,9 @@ static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 	if (err)
 		goto out;
 
-	c2c->hists.stats.total_period += cost;
-	hists__inc_nr_events(&c2c->hists, PERF_RECORD_SAMPLE);
+        c2c->hists.stats.total_period += cost;
+        hists__inc_nr_events(&c2c->hists, PERF_RECORD_SAMPLE);
+        err = hist_entry__append_callchain(he, sample);
 	return err;
 
 out_mem:
@@ -944,6 +955,13 @@ static void print_hitm_cacheline_offset(struct c2c_hit *clo,
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
@@ -1020,6 +1038,12 @@ static void print_c2c_hitm_report(struct rb_root *hitm_tree,
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
@@ -1151,6 +1175,30 @@ err:
 	return err;
 }
 
+static int perf_c2c__setup_sample_type(struct perf_c2c *c2c,
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
+			c2c->call_graph = true;
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
@@ -1170,6 +1218,9 @@ static int perf_c2c__read_events(struct perf_c2c *c2c)
 	if (symbol__init() < 0)
 		goto out_delete;
 
+	if (perf_c2c__setup_sample_type(c2c, session) < 0)
+		goto out_delete;
+
 	/* setup the evsel handlers for each event type */
 	evlist__for_each(session->evlist, evsel) {
 		const char *name = perf_evsel__name(evsel);
@@ -1257,8 +1308,101 @@ static int perf_c2c__record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
+static int
+opt_callchain_cb(const struct option *opt, const char *arg, int unset)
+{
+	struct perf_c2c *c2c = (struct perf_c2c *)opt->value;
+	char *tok, *tok2;
+	char *endptr;
+
+	/*
+	 * --no-call-graph
+	 */
+	if (unset) {
+		c2c->call_graph = false;
+		return 0;
+	}
+
+	symbol_conf.use_callchain = true;
+	c2c->call_graph = true;
+
+	if (!arg)
+		return 0;
+
+	tok = strtok((char *)arg, ",");
+	if (!tok)
+		return -1;
+
+	/* get the output mode */
+	if (!strncmp(tok, "graph", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_ABS;
+
+	else if (!strncmp(tok, "flat", strlen(arg)))
+		callchain_param.mode = CHAIN_FLAT;
+
+	else if (!strncmp(tok, "fractal", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_REL;
+
+	else if (!strncmp(tok, "none", strlen(arg))) {
+		callchain_param.mode = CHAIN_NONE;
+		symbol_conf.use_callchain = false;
+
+		return 0;
+	}
+
+	else
+		return -1;
+
+	/* get the min percentage */
+	tok = strtok(NULL, ",");
+	if (!tok)
+		goto setup;
+
+	callchain_param.min_percent = strtod(tok, &endptr);
+	if (tok == endptr)
+		return -1;
+
+	/* get the print limit */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+
+	if (tok2[0] != 'c') {
+		callchain_param.print_limit = strtoul(tok2, &endptr, 0);
+		tok2 = strtok(NULL, ",");
+		if (!tok2)
+			goto setup;
+	}
+
+	/* get the call chain order */
+	if (!strncmp(tok2, "caller", strlen("caller")))
+		callchain_param.order = ORDER_CALLER;
+	else if (!strncmp(tok2, "callee", strlen("callee")))
+		callchain_param.order = ORDER_CALLEE;
+	else
+		return -1;
+
+	/* Get the sort key */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+	if (!strncmp(tok2, "function", strlen("function")))
+		callchain_param.key = CCKEY_FUNCTION;
+	else if (!strncmp(tok2, "address", strlen("address")))
+		callchain_param.key = CCKEY_ADDRESS;
+	else
+		return -1;
+setup:
+	if (callchain_register_param(&callchain_param) < 0) {
+		fprintf(stderr, "Can't register callchain params\n");
+		return -1;
+	}
+	return 0;
+}
+
 int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	char callchain_default_opt[] = "fractal,0.05,callee";
 	struct perf_c2c c2c = {
 		.tool = {
 			.sample		 = perf_c2c__process_sample,
@@ -1285,6 +1429,9 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
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

