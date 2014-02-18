Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaBRVJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:09:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35761 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaBRVJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/32] perf tools: Add call-graph option support into .perfconfig
Date: Tue, 18 Feb 2014 18:08:25 -0300
Message-Id: <1392757731-32619-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding call-graph option support into .perfconfig file, so it's now
possible use call-graph option like:

  [top]
        call-graph = fp

  [record]
        call-graph = dwarf,8192

Above options ONLY setup the unwind method. To enable perf record/top to
actually use it the command line option -g/-G must be specified.

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
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1391427883-13443-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 16 ++++++++++++++++
 tools/perf/builtin-top.c    | 12 ++++++++++++
 tools/perf/perf.h           |  1 +
 tools/perf/util/evsel.c     |  2 +-
 4 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index af47531b82ec..be9e8bc0c4aa 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -749,6 +749,8 @@ int record_parse_callchain_opt(const struct option *opt,
 	struct record_opts *opts = opt->value;
 	int ret;
 
+	opts->call_graph_enabled = !unset;
+
 	/* --no-call-graph */
 	if (unset) {
 		opts->call_graph = CALLCHAIN_NONE;
@@ -769,6 +771,8 @@ int record_callchain_opt(const struct option *opt,
 {
 	struct record_opts *opts = opt->value;
 
+	opts->call_graph_enabled = !unset;
+
 	if (opts->call_graph == CALLCHAIN_NONE)
 		opts->call_graph = CALLCHAIN_FP;
 
@@ -776,6 +780,16 @@ int record_callchain_opt(const struct option *opt,
 	return 0;
 }
 
+static int perf_record_config(const char *var, const char *value, void *cb)
+{
+	struct record *rec = cb;
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
@@ -907,6 +921,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (rec->evlist == NULL)
 		return -ENOMEM;
 
+	perf_config(perf_record_config, rec);
+
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target__none(&rec->opts.target))
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 76cd510d34d0..ed99ec4a309f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -991,6 +991,16 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
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
@@ -1115,6 +1125,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
+	perf_config(perf_top_config, &top);
+
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index e84fa26bc1be..2078f334617c 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -257,6 +257,7 @@ enum perf_call_graph_mode {
 struct record_opts {
 	struct target target;
 	int	     call_graph;
+	bool         call_graph_enabled;
 	bool	     group;
 	bool	     inherit_stat;
 	bool	     no_buffering;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c6f8ce9972e7..8201abe0925e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -595,7 +595,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph) {
+	if (opts->call_graph_enabled) {
 		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
 		if (opts->call_graph == CALLCHAIN_DWARF) {
-- 
1.8.1.4

