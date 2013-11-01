Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3KAPYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:24:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab3KAPYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:24:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/3] perf tools: Add call-graph option support into .perfconfig
Date: Fri,  1 Nov 2013 16:23:12 +0100
Message-Id: <1383319394-19046-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1383319394-19046-1-git-send-email-jolsa@redhat.com>
References: <1383319394-19046-1-git-send-email-jolsa@redhat.com>
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

v2 changes:
  - Documentation updated

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
 tools/perf/Documentation/perf-record.txt |  5 +++++
 tools/perf/Documentation/perf-top.txt    |  8 ++++++++
 tools/perf/builtin-record.c              | 16 ++++++++++++++++
 tools/perf/builtin-top.c                 | 12 ++++++++++++
 tools/perf/perf.h                        |  1 +
 tools/perf/util/evsel.c                  |  2 +-
 6 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index ca0d3d9..22ccd63 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -105,6 +105,11 @@ OPTIONS
 	call graphs, using "dwarf", if available (perf tools linked to
 	the libunwind library) should be used instead.
 
+	It's possible to use 'call-grap' option as .perfconfig
+	entry, like:
+	[record]
+		call-graph = dwarf,8192
+
 -q::
 --quiet::
 	Don't print any message, useful for scripting.
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 6a118e7..456fd65 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -147,6 +147,14 @@ Default is to monitor all CPUS.
 	Setup and enable call-graph (stack chain/backtrace) recording,
 	implies -G.
 
+	Please check other 'call-graph' option DWARF details in
+	perf-record man page.
+
+	It's possible to use 'call-grap' option as .perfconfig
+	entry, like:
+	[top]
+		call-graph = dwarf,8192
+
 --ignore-callees=<regex>::
         Ignore callees of the function(s) matching the given regex.
         This has the effect of collecting the callers of each such
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d046514..2d00a19 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -784,6 +784,8 @@ int record_parse_callchain_opt(const struct option *opt,
 	struct perf_record_opts *opts = opt->value;
 	int ret;
 
+	opts->call_graph_enabled = !unset;
+
 	/* --no-call-graph */
 	if (unset) {
 		opts->call_graph = CALLCHAIN_NONE;
@@ -804,6 +806,8 @@ int record_callchain_opt(const struct option *opt,
 {
 	struct perf_record_opts *opts = opt->value;
 
+	opts->call_graph_enabled = !unset;
+
 	if (opts->call_graph == CALLCHAIN_NONE)
 		opts->call_graph = CALLCHAIN_FP;
 
@@ -811,6 +815,16 @@ int record_callchain_opt(const struct option *opt,
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
@@ -936,6 +950,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	rec->evlist = evsel_list;
 
+	perf_config(perf_record_config, rec);
+
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && perf_target__none(&rec->opts.target))
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5a11f13..e1671b1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1031,6 +1031,16 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
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
@@ -1147,6 +1157,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
+	perf_config(perf_top_config, &top);
+
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index cf20187..27223fb 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -213,6 +213,7 @@ enum perf_call_graph_mode {
 struct perf_record_opts {
 	struct perf_target target;
 	int	     call_graph;
+	bool         call_graph_enabled;
 	bool	     group;
 	bool	     inherit_stat;
 	bool	     no_delay;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9f1ef9b..349de75 100644
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

