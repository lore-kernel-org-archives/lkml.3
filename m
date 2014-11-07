Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaKGFcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:32:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57920 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaKGFcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:32:46 -0500
Date: Thu, 6 Nov 2014 21:31:58 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-cdae2d1e936457bf72673cb77e7f5f4b9d4c451e@git.kernel.org>
Cc: namhyung@gmail.com, adrian.hunter@intel.com, jolsa@kernel.org,
        fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        peterz@infradead.org, hpa@zytor.com, acme@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        dsahern@gmail.com, acme@redhat.com, hpa@zytor.com,
        peterz@infradead.org, paulus@samba.org, mingo@redhat.com,
        fweisbec@gmail.com, jolsa@kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1414363445-22370-2-git-send-email-jolsa@kernel.org>
References: <1414363445-22370-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script perl: Removing event cache as it'
 s no longer needed
Git-Commit-ID: cdae2d1e936457bf72673cb77e7f5f4b9d4c451e
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

Commit-ID:  cdae2d1e936457bf72673cb77e7f5f4b9d4c451e
Gitweb:     http://git.kernel.org/tip/cdae2d1e936457bf72673cb77e7f5f4b9d4c451e
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sun, 26 Oct 2014 23:44:04 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Nov 2014 17:42:47 -0300

perf script perl: Removing event cache as it's no longer needed

We don't need to maintain cache of 'struct event_format' objects.
Currently the 'struct perf_evsel' holds this reference already.

Adding events_defined bitmap to keep track of defined events, which is
much cheaper than array of pointers.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1414363445-22370-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c | 29 +++++-----------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 0a01bac..22ebc46 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -24,6 +24,7 @@
 #include <string.h>
 #include <ctype.h>
 #include <errno.h>
+#include <linux/bitmap.h>
 
 #include "../util.h"
 #include <EXTERN.h>
@@ -57,7 +58,7 @@ INTERP my_perl;
 #define FTRACE_MAX_EVENT				\
 	((1 << (sizeof(unsigned short) * 8)) - 1)
 
-struct event_format *events[FTRACE_MAX_EVENT];
+static DECLARE_BITMAP(events_defined, FTRACE_MAX_EVENT);
 
 extern struct scripting_context *scripting_context;
 
@@ -238,35 +239,15 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
-{
-	static char ev_name[256];
-	struct event_format *event;
-	int type = evsel->attr.config;
-
-	if (events[type])
-		return events[type];
-
-	events[type] = event = evsel->tp_format;
-	if (!event)
-		return NULL;
-
-	sprintf(ev_name, "%s::%s", event->system, event->name);
-
-	define_event_symbols(event, ev_name, event->print_fmt.args);
-
-	return event;
-}
-
 static void perl_process_tracepoint(struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct thread *thread)
 {
+	struct event_format *event = evsel->tp_format;
 	struct format_field *field;
 	static char handler[256];
 	unsigned long long val;
 	unsigned long s, ns;
-	struct event_format *event;
 	int pid;
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
@@ -278,7 +259,6 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 	if (evsel->attr.type != PERF_TYPE_TRACEPOINT)
 		return;
 
-	event = find_cache_event(evsel);
 	if (!event)
 		die("ug! no event found for type %" PRIu64, (u64)evsel->attr.config);
 
@@ -286,6 +266,9 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 
 	sprintf(handler, "%s::%s", event->system, event->name);
 
+	if (!test_and_set_bit(event->id, events_defined))
+		define_event_symbols(event, handler, event->print_fmt.args);
+
 	s = nsecs / NSECS_PER_SEC;
 	ns = nsecs - s * NSECS_PER_SEC;
 
