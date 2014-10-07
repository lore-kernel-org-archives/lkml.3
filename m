Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaJGILE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:11:04 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33280 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaJGIKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:10:36 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: [PATCH 2/3] perf tools: Export usage string and option table of perf record
Date: Tue,  7 Oct 2014 17:10:31 +0900
Message-Id: <1412669432-14833-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1412669432-14833-1-git-send-email-namhyung@kernel.org>
References: <1412669432-14833-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those are shared with other builtin commands like kvm, script.  So
make it accessable from them.  This is a preparation of later change
that limiting possible options.

Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c    | 7 +++++--
 tools/perf/builtin-script.c    | 1 -
 tools/perf/builtin-timechart.c | 7 ++++---
 tools/perf/perf.h              | 3 +++
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 44c6f3d55ce7..4d1f224c90ab 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -678,11 +678,12 @@ static int perf_record_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static const char * const record_usage[] = {
+static const char * const __record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
 	NULL
 };
+const char * const *record_usage = __record_usage;
 
 /*
  * XXX Ideally would be local to cmd_record() and passed to a record__new
@@ -723,7 +724,7 @@ const char record_callchain_help[] = CALLCHAIN_HELP "fp";
  * perf_evlist__prepare_workload, etc instead of fork+exec'in 'perf record',
  * using pipes, etc.
  */
-const struct option record_options[] = {
+struct option __record_options[] = {
 	OPT_CALLBACK('e', "event", &record.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
@@ -800,6 +801,8 @@ const struct option record_options[] = {
 	OPT_END()
 };
 
+struct option *record_options = __record_options;
+
 int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int err = -ENOMEM;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b9b9e58a6c39..c9cf613efa79 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -23,7 +23,6 @@ static char const		*generate_script_lang;
 static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
-extern const struct option	record_options[];
 static bool			no_callchain;
 static bool			latency_format;
 static bool			system_wide;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 35b425b6293f..9a68fda17cb5 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1963,7 +1963,7 @@ int cmd_timechart(int argc, const char **argv,
 		NULL
 	};
 
-	const struct option record_options[] = {
+	const struct option timechart_record_options[] = {
 	OPT_BOOLEAN('P', "power-only", &tchart.power_only, "output power data only"),
 	OPT_BOOLEAN('T', "tasks-only", &tchart.tasks_only,
 		    "output processes data only"),
@@ -1972,7 +1972,7 @@ int cmd_timechart(int argc, const char **argv,
 	OPT_BOOLEAN('g', "callchain", &tchart.with_backtrace, "record callchain"),
 	OPT_END()
 	};
-	const char * const record_usage[] = {
+	const char * const timechart_record_usage[] = {
 		"perf timechart record [<options>]",
 		NULL
 	};
@@ -1985,7 +1985,8 @@ int cmd_timechart(int argc, const char **argv,
 	}
 
 	if (argc && !strncmp(argv[0], "rec", 3)) {
-		argc = parse_options(argc, argv, record_options, record_usage,
+		argc = parse_options(argc, argv, timechart_record_options,
+				     timechart_record_usage,
 				     PARSE_OPT_STOP_AT_NON_OPTION);
 
 		if (tchart.power_only && tchart.tasks_only) {
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 220d44e44c1b..511c2831aa81 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -62,4 +62,7 @@ struct record_opts {
 	unsigned     initial_delay;
 };
 
+struct option;
+extern const char * const *record_usage;
+extern struct option *record_options;
 #endif
-- 
2.1.2

