Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3GWHt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:49:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3GWHrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:47:01 -0400
Date: Tue, 23 Jul 2013 00:46:40 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-2eaa1b407aa6592a884f1be061ef61de7012c97a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        feng.tang@intel.com
In-Reply-To: <1374185175-28272-1-git-send-email-dsahern@gmail.com>
References: <1374185175-28272-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Fix named threads support
Git-Commit-ID: 2eaa1b407aa6592a884f1be061ef61de7012c97a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:46:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2eaa1b407aa6592a884f1be061ef61de7012c97a
Gitweb:     http://git.kernel.org/tip/2eaa1b407aa6592a884f1be061ef61de7012c97a
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Thu, 18 Jul 2013 16:06:15 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Jul 2013 11:55:53 -0300

perf script: Fix named threads support

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
 
