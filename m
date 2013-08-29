Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3H2KJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:09:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3H2KJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:09:16 -0400
Date: Thu, 29 Aug 2013 03:08:38 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-9j6hvap23qanyl96wx4mrj9k@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Support ! in -e expressions
Git-Commit-ID: b059efdf52a27819b78aa30f171f1e8e439152b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:08:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b059efdf52a27819b78aa30f171f1e8e439152b6
Gitweb:     http://git.kernel.org/tip/b059efdf52a27819b78aa30f171f1e8e439152b6
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 21 Aug 2013 12:56:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Aug 2013 17:25:41 -0300

perf trace: Support ! in -e expressions

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
