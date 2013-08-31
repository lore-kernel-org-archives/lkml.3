Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3HaIQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:16:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59757 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab3HaIQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:16:02 -0400
Date: Sat, 31 Aug 2013 01:15:26 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-bdc896617b4fcaa9c89da9a9c5b72660f6741d46@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1377750593-48046-4-git-send-email-dsahern@gmail.com>
References: <1377750593-48046-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Honor target pid /
  tid options when analyzing a file
Git-Commit-ID: bdc896617b4fcaa9c89da9a9c5b72660f6741d46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:15:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdc896617b4fcaa9c89da9a9c5b72660f6741d46
Gitweb:     http://git.kernel.org/tip/bdc896617b4fcaa9c89da9a9c5b72660f6741d46
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 28 Aug 2013 22:29:53 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 17:45:39 -0300

perf trace: Honor target pid / tid options when analyzing a file

Allows capture of raw_syscall events for all processes or threads in a
task and then analyzing specific ones.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377750593-48046-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2a6ebe1..845facc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -8,6 +8,7 @@
 #include "util/thread.h"
 #include "util/parse-options.h"
 #include "util/strlist.h"
+#include "util/intlist.h"
 #include "util/thread_map.h"
 
 #include <libaudit.h>
@@ -259,6 +260,8 @@ struct trace {
 	unsigned long		nr_events;
 	struct strlist		*ev_qualifier;
 	bool			not_ev_qualifier;
+	struct intlist		*tid_list;
+	struct intlist		*pid_list;
 	bool			sched;
 	bool			multiple_threads;
 	double			duration_filter;
@@ -653,6 +656,18 @@ out_dump:
 	return 0;
 }
 
+static bool skip_sample(struct trace *trace, struct perf_sample *sample)
+{
+	if ((trace->pid_list && intlist__find(trace->pid_list, sample->pid)) ||
+	    (trace->tid_list && intlist__find(trace->tid_list, sample->tid)))
+		return false;
+
+	if (trace->pid_list || trace->tid_list)
+		return true;
+
+	return false;
+}
+
 static int trace__process_sample(struct perf_tool *tool,
 				 union perf_event *event __maybe_unused,
 				 struct perf_sample *sample,
@@ -664,6 +679,9 @@ static int trace__process_sample(struct perf_tool *tool,
 
 	tracepoint_handler handler = evsel->handler.func;
 
+	if (skip_sample(trace, sample))
+		return 0;
+
 	if (trace->base_time == 0)
 		trace->base_time = sample->time;
 
@@ -683,6 +701,27 @@ perf_session__has_tp(struct perf_session *session, const char *name)
 	return evsel != NULL;
 }
 
+static int parse_target_str(struct trace *trace)
+{
+	if (trace->opts.target.pid) {
+		trace->pid_list = intlist__new(trace->opts.target.pid);
+		if (trace->pid_list == NULL) {
+			pr_err("Error parsing process id string\n");
+			return -EINVAL;
+		}
+	}
+
+	if (trace->opts.target.tid) {
+		trace->tid_list = intlist__new(trace->opts.target.tid);
+		if (trace->tid_list == NULL) {
+			pr_err("Error parsing thread id string\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -869,6 +908,10 @@ static int trace__replay(struct trace *trace)
 		goto out;
 	}
 
+	err = parse_target_str(trace);
+	if (err != 0)
+		goto out;
+
 	setup_pager();
 
 	err = perf_session__process_events(session, &trace->tool);
