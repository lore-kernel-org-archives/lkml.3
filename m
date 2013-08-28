Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3H1PDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:03:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40594 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3H1O7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/21] perf trace: Support ! in -e expressions
Date: Wed, 28 Aug 2013 11:59:25 -0300
Message-Id: <1377701977-2085-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we can ask for all but a set of syscalls to be traced.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-9j6hvap23qanyl96wx4mrj9k@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |  2 ++
 tools/perf/builtin-trace.c              | 28 +++++++++++++++++++---------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index cb3371e..4754f11 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -30,6 +30,8 @@ OPTIONS
 -e::
 --expr::
 	List of events to show, currently only syscall names.
+	Prefixing with ! shows all syscalls but the ones specified.  You may
+	need to escape it.
 
 -o::
 --output=::
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 9891d8c..6ab7a7a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -114,8 +114,9 @@ struct trace {
 	struct machine		host;
 	u64			base_time;
 	FILE			*output;
-	struct strlist		*ev_qualifier;
 	unsigned long		nr_events;
+	struct strlist		*ev_qualifier;
+	bool			not_ev_qualifier;
 	bool			sched;
 	bool			multiple_threads;
 	double			duration_filter;
@@ -234,13 +235,17 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 	sc = trace->syscalls.table + id;
 	sc->name = name;
 
-	if (trace->ev_qualifier && !strlist__find(trace->ev_qualifier, name)) {
-		sc->filtered = true;
-		/*
- 		 * No need to do read tracepoint information since this will be
- 		 * filtered out.
- 		 */
-		return 0;
+	if (trace->ev_qualifier) {
+		bool in = strlist__find(trace->ev_qualifier, name) != NULL;
+
+		if (!(in ^ trace->not_ev_qualifier)) {
+			sc->filtered = true;
+			/*
+			 * No need to do read tracepoint information since this will be
+			 * filtered out.
+			 */
+			return 0;
+		}
 	}
 
 	sc->fmt  = syscall_fmt__find(sc->name);
@@ -725,7 +730,12 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	if (ev_qualifier_str != NULL) {
-		trace.ev_qualifier = strlist__new(true, ev_qualifier_str);
+		const char *s = ev_qualifier_str;
+
+		trace.not_ev_qualifier = *s == '!';
+		if (trace.not_ev_qualifier)
+			++s;
+		trace.ev_qualifier = strlist__new(true, s);
 		if (trace.ev_qualifier == NULL) {
 			fputs("Not enough memory to parse event qualifier",
 			      trace.output);
-- 
1.8.1.4

