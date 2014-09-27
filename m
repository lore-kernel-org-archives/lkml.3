Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaI0H03 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 03:26:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbaI0H01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 03:26:27 -0400
Date: Sat, 27 Sep 2014 00:25:52 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-72a128aa083a7f4cc4f800718aaae05d9c698e26@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        mail@milianw.de, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        mail@milianw.de, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1411434104-5307-3-git-send-email-namhyung@kernel.org>
References: <1411434104-5307-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move callchain config from record_opts to callchain_param
Git-Commit-ID: 72a128aa083a7f4cc4f800718aaae05d9c698e26
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72a128aa083a7f4cc4f800718aaae05d9c698e26
Gitweb:     http://git.kernel.org/tip/72a128aa083a7f4cc4f800718aaae05d9c698e26
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 23 Sep 2014 10:01:41 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Sep 2014 12:40:33 -0300

perf tools: Move callchain config from record_opts to callchain_param

So that all callchain config parameters can be read/written to a single
place.  It's a preparation to consolidate handling of all callchain
options.

Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1411434104-5307-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 45 ++++++++++++++++++++-------------------------
 tools/perf/builtin-top.c    |  4 +---
 tools/perf/perf.h           |  3 ---
 tools/perf/util/callchain.h |  5 ++++-
 tools/perf/util/evsel.c     | 11 +++++------
 5 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 320b198..fde0df7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -652,7 +652,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* HAVE_DWARF_UNWIND_SUPPORT */
 
-int record_parse_callchain(const char *arg, struct record_opts *opts)
+int record_parse_callchain(const char *arg)
 {
 	char *tok, *name, *saveptr = NULL;
 	char *buf;
@@ -672,7 +672,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 		/* Framepointer style */
 		if (!strncmp(name, "fp", sizeof("fp"))) {
 			if (!strtok_r(NULL, ",", &saveptr)) {
-				opts->call_graph = CALLCHAIN_FP;
+				callchain_param.record_mode = CALLCHAIN_FP;
 				ret = 0;
 			} else
 				pr_err("callchain: No more arguments "
@@ -685,15 +685,15 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
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
@@ -708,61 +708,56 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
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
index 5c16ba2..f7003fc 100644
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
index 510c65f..220d44e 100644
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
index da43619..819ae4f 100644
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
index b38de58..e0868a9 100644
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
