Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427Ab3GVUWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:22:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337Ab3GVUWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:22:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/11] perf script: Fix named threads support
Date: Mon, 22 Jul 2013 17:22:29 -0300
Message-Id: <1374524559-9839-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374524559-9839-1-git-send-email-acme@infradead.org>
References: <1374524559-9839-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Commit 73994dc broke named thread support in perf-script. The thread
struct in al is the main thread for a multithreaded process. The thread
struct used for analysis (e.g., dumping events) should be the specific
thread for the sample.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Link: http://lkml.kernel.org/r/1374185175-28272-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c                            |  6 +++---
 tools/perf/util/scripting-engines/trace-event-perl.c   | 14 ++++++++------
 tools/perf/util/scripting-engines/trace-event-python.c |  9 +++++----
 tools/perf/util/trace-event-scripting.c                |  3 ++-
 tools/perf/util/trace-event.h                          |  4 +++-
 5 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ecb6979..1cad370 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -397,10 +397,10 @@ static void print_sample_bts(union perf_event *event,
 
 static void process_event(union perf_event *event, struct perf_sample *sample,
 			  struct perf_evsel *evsel, struct machine *machine,
-			  struct addr_location *al)
+			  struct thread *thread,
+			  struct addr_location *al __maybe_unused)
 {
 	struct perf_event_attr *attr = &evsel->attr;
-	struct thread *thread = al->thread;
 
 	if (output[attr->type].fields == 0)
 		return;
@@ -511,7 +511,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, sample, evsel, machine, &al);
+	scripting_ops->process_event(event, sample, evsel, machine, thread, &al);
 
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index eacec85..a85e4ae 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -261,7 +261,8 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 				    struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct machine *machine __maybe_unused,
-				    struct addr_location *al)
+				    struct thread *thread,
+					struct addr_location *al)
 {
 	struct format_field *field;
 	static char handler[256];
@@ -272,7 +273,6 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
-	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	dSP;
@@ -351,7 +351,8 @@ static void perl_process_event_generic(union perf_event *event,
 				       struct perf_sample *sample,
 				       struct perf_evsel *evsel,
 				       struct machine *machine __maybe_unused,
-				       struct addr_location *al __maybe_unused)
+				       struct thread *thread __maybe_unused,
+					   struct addr_location *al __maybe_unused)
 {
 	dSP;
 
@@ -377,10 +378,11 @@ static void perl_process_event(union perf_event *event,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
-			       struct addr_location *al)
+			       struct thread *thread,
+				   struct addr_location *al)
 {
-	perl_process_tracepoint(event, sample, evsel, machine, al);
-	perl_process_event_generic(event, sample, evsel, machine, al);
+	perl_process_tracepoint(event, sample, evsel, machine, thread, al);
+	perl_process_event_generic(event, sample, evsel, machine, thread, al);
 }
 
 static void run_start_sub(void)
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index e87aa5d..cc75a3c 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -225,6 +225,7 @@ static void python_process_tracepoint(union perf_event *perf_event
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine __maybe_unused,
+				 struct thread *thread,
 				 struct addr_location *al)
 {
 	PyObject *handler, *retval, *context, *t, *obj, *dict = NULL;
@@ -238,7 +239,6 @@ static void python_process_tracepoint(union perf_event *perf_event
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
 	unsigned long long nsecs = sample->time;
-	struct thread *thread = al->thread;
 	char *comm = thread->comm;
 
 	t = PyTuple_New(MAX_FIELDS);
@@ -345,12 +345,12 @@ static void python_process_general_event(union perf_event *perf_event
 					 struct perf_sample *sample,
 					 struct perf_evsel *evsel,
 					 struct machine *machine __maybe_unused,
+					 struct thread *thread,
 					 struct addr_location *al)
 {
 	PyObject *handler, *retval, *t, *dict;
 	static char handler_name[64];
 	unsigned n = 0;
-	struct thread *thread = al->thread;
 
 	/*
 	 * Use the MAX_FIELDS to make the function expandable, though
@@ -404,17 +404,18 @@ static void python_process_event(union perf_event *perf_event,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine,
+				 struct thread *thread,
 				 struct addr_location *al)
 {
 	switch (evsel->attr.type) {
 	case PERF_TYPE_TRACEPOINT:
 		python_process_tracepoint(perf_event, sample, evsel,
-					  machine, al);
+					  machine, thread, al);
 		break;
 	/* Reserve for future process_hw/sw/raw APIs */
 	default:
 		python_process_general_event(perf_event, sample, evsel,
-					     machine, al);
+					     machine, thread, al);
 	}
 }
 
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 8715a10..95199e4 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -39,7 +39,8 @@ static void process_event_unsupported(union perf_event *event __maybe_unused,
 				      struct perf_sample *sample __maybe_unused,
 				      struct perf_evsel *evsel __maybe_unused,
 				      struct machine *machine __maybe_unused,
-				      struct addr_location *al __maybe_unused)
+				      struct thread *thread __maybe_unused,
+					  struct addr_location *al __maybe_unused)
 {
 }
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 669a64a..fafe1a4 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -9,6 +9,7 @@ struct machine;
 struct perf_sample;
 union perf_event;
 struct perf_tool;
+struct thread;
 
 extern struct pevent *perf_pevent;
 
@@ -68,7 +69,8 @@ struct scripting_ops {
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct machine *machine,
-			       struct addr_location *al);
+			       struct thread *thread,
+				   struct addr_location *al);
 	int (*generate_script) (struct pevent *pevent, const char *outfile);
 };
 
-- 
1.8.1.4

