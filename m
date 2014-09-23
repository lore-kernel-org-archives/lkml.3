Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbaIWBCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 21:02:12 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59249 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbaIWBCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 21:02:10 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>
Subject: [PATCH 2/5] perf tools: Move callchain config from record_opts to callchain_param
Date: Tue, 23 Sep 2014 10:01:41 +0900
Message-Id: <1411434104-5307-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411434104-5307-1-git-send-email-namhyung@kernel.org>
References: <1411434104-5307-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that all callchain config parameters can be read/written to a single place.
It's a preparation to consolidate handling of all callchain options.

Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 45 ++++++++++++++++++++-------------------------
 tools/perf/builtin-top.c    |  4 +---
 tools/perf/perf.h           |  3 ---
 tools/perf/util/callchain.h |  5 ++++-
 tools/perf/util/evsel.c     | 11 +++++------
 5 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a1b040394170..4de632cd677b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -649,7 +649,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
 
-int record_parse_callchain(const char *arg, struct record_opts *opts)
+int record_parse_callchain(const char *arg)
 {
 	char *tok, *name, *saveptr = NULL;
 	char *buf;
@@ -669,7 +669,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 		/* Framepointer style */
 		if (!strncmp(name, "fp", sizeof("fp"))) {
 			if (!strtok_r(NULL, ",", &saveptr)) {
-				opts->call_graph = CALLCHAIN_FP;
+				callchain_param.record_mode = CALLCHAIN_FP;
 				ret = 0;
 			} else
 				pr_err("callchain: No more arguments "
@@ -682,15 +682,15 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 			const unsigned long default_stack_dump_size = 8192;
 
 			ret = 0;
-			opts->call_graph = CALLCHAIN_DWARF;
-			opts->stack_dump_size = default_stack_dump_size;
+			callchain_param.record_mode = CALLCHAIN_DWARF;
+			callchain_param.dump_size = default_stack_dump_size;
 
 			tok = strtok_r(NULL, ",", &saveptr);
 			if (tok) {
 				unsigned long size = 0;
 
 				ret = get_stack_size(tok, &size);
-				opts->stack_dump_size = size;
+				callchain_param.dump_size = size;
 			}
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
 		} else {
@@ -705,61 +705,56 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 	return ret;
 }
 
-static void callchain_debug(struct record_opts *opts)
+static void callchain_debug(void)
 {
 	static const char *str[CALLCHAIN_MAX] = { "NONE", "FP", "DWARF" };
 
-	pr_debug("callchain: type %s\n", str[opts->call_graph]);
+	pr_debug("callchain: type %s\n", str[callchain_param.record_mode]);
 
-	if (opts->call_graph == CALLCHAIN_DWARF)
+	if (callchain_param.record_mode == CALLCHAIN_DWARF)
 		pr_debug("callchain: stack dump size %d\n",
-			 opts->stack_dump_size);
+			 callchain_param.dump_size);
 }
 
-int record_parse_callchain_opt(const struct option *opt,
+int record_parse_callchain_opt(const struct option *opt __maybe_unused,
 			       const char *arg,
 			       int unset)
 {
-	struct record_opts *opts = opt->value;
 	int ret;
 
-	opts->call_graph_enabled = !unset;
+	callchain_param.enabled = !unset;
 
 	/* --no-call-graph */
 	if (unset) {
-		opts->call_graph = CALLCHAIN_NONE;
+		callchain_param.record_mode = CALLCHAIN_NONE;
 		pr_debug("callchain: disabled\n");
 		return 0;
 	}
 
-	ret = record_parse_callchain(arg, opts);
+	ret = record_parse_callchain(arg);
 	if (!ret)
-		callchain_debug(opts);
+		callchain_debug();
 
 	return ret;
 }
 
-int record_callchain_opt(const struct option *opt,
+int record_callchain_opt(const struct option *opt __maybe_unused,
 			 const char *arg __maybe_unused,
 			 int unset __maybe_unused)
 {
-	struct record_opts *opts = opt->value;
+	callchain_param.enabled = true;
 
-	opts->call_graph_enabled = !unset;
+	if (callchain_param.record_mode == CALLCHAIN_NONE)
+		callchain_param.record_mode = CALLCHAIN_FP;
 
-	if (opts->call_graph == CALLCHAIN_NONE)
-		opts->call_graph = CALLCHAIN_FP;
-
-	callchain_debug(opts);
+	callchain_debug();
 	return 0;
 }
 
 static int perf_record_config(const char *var, const char *value, void *cb)
 {
-	struct record *rec = cb;
-
 	if (!strcmp(var, "record.call-graph"))
-		return record_parse_callchain(value, &rec->opts);
+		return record_parse_callchain(value);
 
 	return perf_default_config(var, value, cb);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e13864be2acb..200a44b370c3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1020,10 +1020,8 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 
 static int perf_top_config(const char *var, const char *value, void *cb)
 {
-	struct perf_top *top = cb;
-
 	if (!strcmp(var, "top.call-graph"))
-		return record_parse_callchain(value, &top->record_opts);
+		return record_parse_callchain(value);
 	if (!strcmp(var, "top.children")) {
 		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
 		return 0;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 510c65f72858..220d44e44c1b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -41,8 +41,6 @@ void pthread__unblock_sigwinch(void);
 
 struct record_opts {
 	struct target target;
-	int	     call_graph;
-	bool         call_graph_enabled;
 	bool	     group;
 	bool	     inherit_stat;
 	bool	     no_buffering;
@@ -60,7 +58,6 @@ struct record_opts {
 	u64          branch_stack;
 	u64	     default_interval;
 	u64	     user_interval;
-	u16	     stack_dump_size;
 	bool	     sample_transaction;
 	unsigned     initial_delay;
 };
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index da43619d6173..819ae4f61e08 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -54,6 +54,9 @@ enum chain_key {
 };
 
 struct callchain_param {
+	bool			enabled;
+	enum perf_call_graph_mode record_mode;
+	u32			dump_size;
 	enum chain_mode 	mode;
 	u32			print_limit;
 	double			min_percent;
@@ -154,7 +157,7 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 struct option;
 struct hist_entry;
 
-int record_parse_callchain(const char *arg, struct record_opts *opts);
+int record_parse_callchain(const char *arg);
 int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
 int record_callchain_opt(const struct option *opt, const char *arg, int unset);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b38de5819323..e0868a901c4a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -503,20 +503,19 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
 }
 
 static void
-perf_evsel__config_callgraph(struct perf_evsel *evsel,
-			     struct record_opts *opts)
+perf_evsel__config_callgraph(struct perf_evsel *evsel)
 {
 	bool function = perf_evsel__is_function_event(evsel);
 	struct perf_event_attr *attr = &evsel->attr;
 
 	perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
-	if (opts->call_graph == CALLCHAIN_DWARF) {
+	if (callchain_param.record_mode == CALLCHAIN_DWARF) {
 		if (!function) {
 			perf_evsel__set_sample_bit(evsel, REGS_USER);
 			perf_evsel__set_sample_bit(evsel, STACK_USER);
 			attr->sample_regs_user = PERF_REGS_MASK;
-			attr->sample_stack_user = opts->stack_dump_size;
+			attr->sample_stack_user = callchain_param.dump_size;
 			attr->exclude_callchain_user = 1;
 		} else {
 			pr_info("Cannot use DWARF unwind for function trace event,"
@@ -625,8 +624,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph_enabled && !evsel->no_aux_samples)
-		perf_evsel__config_callgraph(evsel, opts);
+	if (callchain_param.enabled && !evsel->no_aux_samples)
+		perf_evsel__config_callgraph(evsel);
 
 	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
-- 
2.1.0

