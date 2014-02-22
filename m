Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBVR5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:57:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaBVR5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:57:18 -0500
Date: Sat, 22 Feb 2014 09:56:41 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-eb853e80324fa87faf7ae7e1a763ad643f908f2d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1391427883-13443-2-git-send-email-jolsa@redhat.com>
References: <1391427883-13443-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add call-graph option support into .perfconfig
Git-Commit-ID: eb853e80324fa87faf7ae7e1a763ad643f908f2d
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

Commit-ID:  eb853e80324fa87faf7ae7e1a763ad643f908f2d
Gitweb:     http://git.kernel.org/tip/eb853e80324fa87faf7ae7e1a763ad643f908f2d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 3 Feb 2014 12:44:42 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:47 -0300

perf tools: Add call-graph option support into .perfconfig

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
index af47531..be9e8bc 100644
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
index 76cd510..ed99ec4 100644
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
index e84fa26..2078f33 100644
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
index c6f8ce9..8201abe 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -595,7 +595,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph) {
+	if (opts->call_graph_enabled) {
 		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
 
 		if (opts->call_graph == CALLCHAIN_DWARF) {
