Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbaJ3GpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:45:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327AbaJ3GpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:45:04 -0400
Date: Wed, 29 Oct 2014 23:44:11 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e5b2c20755d37d781bb6e1e733faec5c39bd087a@git.kernel.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        hemant@linux.vnet.ibm.com, hpa@zytor.com, peterz@infradead.org,
        mingo@kernel.org, tglx@linutronix.de, dsahern@gmail.com,
        acme@redhat.com, jolsa@redhat.com, namhyung@kernel.org,
        yarygin@linux.vnet.ibm.com
Reply-To: namhyung@kernel.org, yarygin@linux.vnet.ibm.com, jolsa@redhat.com,
        acme@redhat.com, dsahern@gmail.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hpa@zytor.com,
        hemant@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com
In-Reply-To: <1413990949-13953-3-git-send-email-namhyung@kernel.org>
References: <1413990949-13953-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Export usage string and option table of perf record
Git-Commit-ID: e5b2c20755d37d781bb6e1e733faec5c39bd087a
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

Commit-ID:  e5b2c20755d37d781bb6e1e733faec5c39bd087a
Gitweb:     http://git.kernel.org/tip/e5b2c20755d37d781bb6e1e733faec5c39bd087a
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 23 Oct 2014 00:15:46 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:47 -0200

perf tools: Export usage string and option table of perf record

Those are shared with other builtin commands like kvm, script.  So
make it accessable from them.  This is a preparation of later change
that limiting possible options.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1413990949-13953-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    | 7 +++++--
 tools/perf/builtin-script.c    | 1 -
 tools/perf/builtin-timechart.c | 7 ++++---
 tools/perf/perf.h              | 3 +++
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2583a9b..5091a27 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -680,11 +680,12 @@ static int perf_record_config(const char *var, const char *value, void *cb)
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
@@ -725,7 +726,7 @@ const char record_callchain_help[] = CALLCHAIN_HELP "fp";
  * perf_evlist__prepare_workload, etc instead of fork+exec'in 'perf record',
  * using pipes, etc.
  */
-const struct option record_options[] = {
+struct option __record_options[] = {
 	OPT_CALLBACK('e', "event", &record.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
@@ -802,6 +803,8 @@ const struct option record_options[] = {
 	OPT_END()
 };
 
+struct option *record_options = __record_options;
+
 int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int err = -ENOMEM;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b35517f..ce304df 100644
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
index f5fb256..f3bb1a4 100644
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
index 220d44e..511c2831 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -62,4 +62,7 @@ struct record_opts {
 	unsigned     initial_delay;
 };
 
+struct option;
+extern const char * const *record_usage;
+extern struct option *record_options;
 #endif
