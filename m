Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3JZO00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 10:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab3JZO0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 10:26:25 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 3/4] perf tools: Add call-graph option support into .perfconfig
Date: Sat, 26 Oct 2013 16:25:35 +0200
Message-Id: <1382797536-32303-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1382797536-32303-1-git-send-email-jolsa@redhat.com>
References: <20131026120336.GA24439@gmail.com>
 <1382797536-32303-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding call-graph option support into .perfconfig file,
so it's now possible use call-graph option like:

  [top]
        call-graph = fp

  [record]
        call-graph = dwarf,8192

Above options ONLY setup the unwind method. To enable
perf record/top to actually use it the command line
option -g/-G must be specified.

The --call-graph option overloads .perfconfig setup.

Assuming above configuration:

  $ perf record -g ls
  - enables dwarf unwind with user stack size dump 8192 bytes

  $ perf top -G
  - enables frame pointer unwind

  $ perf record --call-graph=fp ls
  - enables frame pointer unwind

  $ perf top --call-graph=dwarf,4096 ls
  - enables dwarf unwind with user stack size dump 4096 bytes

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-record.c | 16 ++++++++++++++++
 tools/perf/builtin-top.c    | 12 ++++++++++++
 tools/perf/perf.h           |  1 +
 tools/perf/util/evsel.c     |  2 +-
 4 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 27622bb..f597b9b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -750,6 +750,8 @@ int record_parse_callchain_opt(const struct option *opt,
 	struct perf_record_opts *opts = opt->value;
 	int ret;
 
+	opts->call_graph_enabled = !unset;
+
 	/* --no-call-graph */
 	if (unset) {
 		opts->call_graph = CALLCHAIN_NONE;
@@ -770,6 +772,8 @@ int record_callchain_opt(const struct option *opt,
 {
 	struct perf_record_opts *opts = opt->value;
 
+	opts->call_graph_enabled = !unset;
+
 	if (opts->call_graph == CALLCHAIN_NONE)
 		opts->call_graph = CALLCHAIN_FP;
 
@@ -777,6 +781,16 @@ int record_callchain_opt(const struct option *opt,
 	return 0;
 }
 
+static int perf_record_config(const char *var, const char *value, void *cb)
+{
+	struct perf_record *rec = cb;
+
+	if (!strcmp(var, "record.call-graph"))
+		return record_parse_callchain(value, &rec->opts);
+
+	return perf_default_config(var, value, cb);
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -905,6 +919,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	rec->evlist = evsel_list;
 
+	perf_config(perf_record_config, rec);
+
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && perf_target__none(&rec->opts.target))
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 488fec3..b326f61 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1028,6 +1028,16 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
+static int perf_top_config(const char *var, const char *value, void *cb)
+{
+	struct perf_top *top = cb;
+
+	if (!strcmp(var, "top.call-graph"))
+		return record_parse_callchain(value, &top->record_opts);
+
+	return perf_default_config(var, value, cb);
+}
+
 static int
 parse_percent_limit(const struct option *opt, const char *arg,
 		    int unset __maybe_unused)
@@ -1152,6 +1162,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
+	perf_config(perf_top_config, &top);
+
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index f61c230..c4ed633 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -215,6 +215,7 @@ enum perf_call_graph_mode {
 struct perf_record_opts {
 	struct perf_target target;
 	int	     call_graph;
+	bool         call_graph_enabled;
 	bool	     group;
 	bool	     inherit_stat;
 	bool	     no_delay;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ec0cc1e..f1ed2ad 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -633,7 +633,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph) {
+	if (opts->call_graph_enabled) {
 		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
 		if (opts->call_graph == CALLCHAIN_DWARF) {
-- 
1.7.11.7

