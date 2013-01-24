Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3AXTME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:12:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33324 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3AXTMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:12:02 -0500
Date: Thu, 24 Jan 2013 11:11:37 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-wb9eti78bk2jd7wpasro8hsz@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Pass perf_record_opts to the callchain cmdline parsing callback
Git-Commit-ID: c5ff78c3092d0e7d14c82d2949e16fee063a83f1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:11:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5ff78c3092d0e7d14c82d2949e16fee063a83f1
Gitweb:     http://git.kernel.org/tip/c5ff78c3092d0e7d14c82d2949e16fee063a83f1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Dec 2012 16:16:47 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Dec 2012 17:21:52 -0300

perf record: Pass perf_record_opts to the callchain cmdline parsing callback

Its all it uses and makes the parsing callback suitable for use by
'perf top', which will happen in a followup patch.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-wb9eti78bk2jd7wpasro8hsz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fc4f080..d035040 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -868,11 +868,9 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* LIBUNWIND_SUPPORT */
 
-static int
-parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
-		    int unset)
+static int parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
-	struct perf_record *rec = (struct perf_record *)opt->value;
+	struct perf_record_opts *opts = opt->value;
 	char *tok, *name, *saveptr = NULL;
 	char *buf;
 	int ret = -1;
@@ -898,7 +896,7 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 		/* Framepointer style */
 		if (!strncmp(name, "fp", sizeof("fp"))) {
 			if (!strtok_r(NULL, ",", &saveptr)) {
-				rec->opts.call_graph = CALLCHAIN_FP;
+				opts->call_graph = CALLCHAIN_FP;
 				ret = 0;
 			} else
 				pr_err("callchain: No more arguments "
@@ -911,20 +909,20 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 			const unsigned long default_stack_dump_size = 8192;
 
 			ret = 0;
-			rec->opts.call_graph = CALLCHAIN_DWARF;
-			rec->opts.stack_dump_size = default_stack_dump_size;
+			opts->call_graph = CALLCHAIN_DWARF;
+			opts->stack_dump_size = default_stack_dump_size;
 
 			tok = strtok_r(NULL, ",", &saveptr);
 			if (tok) {
 				unsigned long size = 0;
 
 				ret = get_stack_size(tok, &size);
-				rec->opts.stack_dump_size = size;
+				opts->stack_dump_size = size;
 			}
 
 			if (!ret)
 				pr_debug("callchain: stack dump size %d\n",
-					 rec->opts.stack_dump_size);
+					 opts->stack_dump_size);
 #endif /* LIBUNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown -g option "
@@ -937,7 +935,7 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 	free(buf);
 
 	if (!ret)
-		pr_debug("callchain: type %d\n", rec->opts.call_graph);
+		pr_debug("callchain: type %d\n", opts->call_graph);
 
 	return ret;
 }
@@ -1021,9 +1019,9 @@ const struct option record_options[] = {
 		     "number of mmap data pages"),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &record, "mode[,dump_size]",
-			     callchain_help, &parse_callchain_opt,
-			     "fp"),
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
+			     "mode[,dump_size]", callchain_help,
+			     &parse_callchain_opt, "fp"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
