Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaBJRga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:36:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbaBJRaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:55 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 13/21] perf, c2c: Add callchain support
Date: Mon, 10 Feb 2014 12:29:08 -0500
Message-Id: <1392053356-23024-14-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
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

Suggested-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 160 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 159 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 39fd233..047fe26 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -49,6 +49,7 @@ struct c2c_stats {
 struct perf_c2c {
 	struct perf_tool tool;
 	bool		 raw_records;
+	bool		 call_graph;
 	struct rb_root   tree_physid;
 
 	/* stats */
@@ -67,6 +68,8 @@ struct c2c_entry {
 	int			weight;
 	int			period;
 	int			color;
+
+	struct callchain_root   callchain[0]; /* must be last member */
 };
 
 #define DISPLAY_LINE_LIMIT  0.0015
@@ -89,6 +92,8 @@ struct c2c_hit {
 	u64		daddr;
 	u64		iaddr;
 	struct mem_info	*mi;
+
+	struct callchain_root   callchain[0]; /* must be last member */
 };
 
 enum { OP, LVL, SNP, LCK, TLB };
@@ -676,7 +681,8 @@ static int c2c_decode_stats(struct c2c_stats *stats, struct c2c_entry *entry)
 
 static struct c2c_hit *c2c_hit__new(u64 cacheline, struct c2c_entry *entry)
 {
-	struct c2c_hit *h = zalloc(sizeof(struct c2c_hit));
+	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
+	struct c2c_hit *h = zalloc(sizeof(struct c2c_hit) + callchain_size);
 
 	if (!h) {
 		pr_err("Could not allocate c2c_hit memory\n");
@@ -690,6 +696,8 @@ static struct c2c_hit *c2c_hit__new(u64 cacheline, struct c2c_entry *entry)
 	h->cacheline = cacheline;
 	h->pid = entry->thread->pid_;
 	h->tid = entry->thread->tid;
+	if (symbol_conf.use_callchain)
+		callchain_init(h->callchain);
 
 	/* use original addresses here, not adjusted al_addr */
 	h->iaddr = entry->mi->iaddr.addr;
@@ -834,6 +842,7 @@ static int perf_c2c__process_sample(struct perf_tool *tool,
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct mem_info *mi;
 	struct thread *thread;
+	struct symbol *parent = NULL;
 	struct c2c_entry *entry;
 	sample_handler f;
 	int err = -1;
@@ -864,6 +873,19 @@ static int perf_c2c__process_sample(struct perf_tool *tool,
 	if (err)
 		goto err_entry;
 
+	/* attach callchain if everything is good */
+	if (symbol_conf.use_callchain && sample->callchain) {
+		callchain_init(entry->callchain);
+
+		err = machine__resolve_callchain(machine, evsel, thread,
+						 sample, &parent, NULL);
+		if (!err)
+			err = callchain_append(entry->callchain,
+					       &callchain_cursor,
+					       entry->period);
+		if (err)
+			pr_err("Could not attach callchain, skipping\n");
+	}
 	return 0;
 
 err_entry:
@@ -1217,6 +1239,13 @@ static void print_hitm_cacheline_offset(struct c2c_hit *clo,
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
@@ -1293,6 +1322,12 @@ static void print_c2c_hitm_report(struct rb_root *hitm_tree,
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
@@ -1424,6 +1459,30 @@ err:
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
@@ -1438,6 +1497,9 @@ static int perf_c2c__read_events(struct perf_c2c *c2c)
 	if (symbol__init() < 0)
 		goto out_delete;
 
+	if (perf_c2c__setup_sample_type(c2c, session) < 0)
+		goto out_delete;
+
 	if (perf_evlist__set_handlers(session->evlist, handlers))
 		goto out_delete;
 
@@ -1508,8 +1570,101 @@ static int perf_c2c__record(int argc, const char **argv)
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
@@ -1536,6 +1691,9 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
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

