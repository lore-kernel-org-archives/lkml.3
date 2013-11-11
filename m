Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3KKUXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:23:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43960 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3KKUWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:22:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Bill Gray <bgray@redhat.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/10] perf record: Synthesize non-exec MMAP records when --data used
Date: Mon, 11 Nov 2013 17:22:26 -0300
Message-Id: <1384201353-23863-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384201353-23863-1-git-send-email-acme@infradead.org>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When perf_event_attr.mmap_data is set the kernel will generate
PERF_RECORD_MMAP events when non-exec (data, SysV mem) mmaps are
created, so we need to synthesize from /proc/pid/maps for existing
threads, as we do for exec mmaps.

Right now just 'perf record' does it, but any other tool that uses
perf_event__synthesize_thread(s|map) can request it.

Reported-by: Don Zickus <dzickus@redhat.com>
Tested-by: Don Zickus <dzickus@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Bill Gray <bgray@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Fowles <rfowles@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ihwzraikx23ian9txinogvv2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c        |  4 ++--
 tools/perf/builtin-record.c     |  6 ++---
 tools/perf/builtin-top.c        |  4 ++--
 tools/perf/builtin-trace.c      |  4 ++--
 tools/perf/tests/code-reading.c |  2 +-
 tools/perf/util/event.c         | 50 ++++++++++++++++++++++++-----------------
 tools/perf/util/event.h         |  4 ++--
 7 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index cd9f92078aba..f36e8209c300 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1550,10 +1550,10 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 		perf_event__synthesize_thread_map(&kvm->tool,
 						  kvm->evlist->threads,
 						  perf_event__process,
-						  &kvm->session->machines.host);
+						  &kvm->session->machines.host, false);
 	else
 		perf_event__synthesize_threads(&kvm->tool, perf_event__process,
-					       &kvm->session->machines.host);
+					       &kvm->session->machines.host, false);
 
 
 	err = kvm_live_open_events(kvm);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 15280b5e5574..afb252cf6eca 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -482,11 +482,11 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	if (perf_target__has_task(&opts->target))
 		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
-						  process_synthesized_event,
-						  machine);
+							process_synthesized_event,
+							machine, opts->sample_address);
 	else if (perf_target__has_cpu(&opts->target))
 		err = perf_event__synthesize_threads(tool, process_synthesized_event,
-					       machine);
+						     machine, opts->sample_address);
 	else /* command specified */
 		err = 0;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9acca8856ccb..cc96d753db96 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -953,10 +953,10 @@ static int __cmd_top(struct perf_top *top)
 	if (perf_target__has_task(&opts->target))
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
-						  &top->session->machines.host);
+						  &top->session->machines.host, false);
 	else
 		perf_event__synthesize_threads(&top->tool, perf_event__process,
-					       &top->session->machines.host);
+					       &top->session->machines.host, false);
 
 	ret = perf_top__start_counters(top);
 	if (ret)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 68943cad70d4..277c2367e0cf 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1343,10 +1343,10 @@ static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 	if (perf_target__has_task(&trace->opts.target)) {
 		err = perf_event__synthesize_thread_map(&trace->tool, evlist->threads,
 							trace__tool_process,
-							trace->host);
+							trace->host, false);
 	} else {
 		err = perf_event__synthesize_threads(&trace->tool, trace__tool_process,
-						     trace->host);
+						     trace->host, false);
 	}
 
 	if (err)
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 49ccc3b2995e..6d9dc198a200 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -441,7 +441,7 @@ static int do_test_code_reading(bool try_kcore)
 	}
 
 	ret = perf_event__synthesize_thread_map(NULL, threads,
-						perf_event__process, machine);
+						perf_event__process, machine, false);
 	if (ret < 0) {
 		pr_debug("perf_event__synthesize_thread_map failed\n");
 		goto out_err;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ec9ae1114ed4..6e3a846aed0e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -170,7 +170,8 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 					      union perf_event *event,
 					      pid_t pid, pid_t tgid,
 					      perf_event__handler_t process,
-					      struct machine *machine)
+					      struct machine *machine,
+					      bool mmap_data)
 {
 	char filename[PATH_MAX];
 	FILE *fp;
@@ -188,10 +189,6 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 	}
 
 	event->header.type = PERF_RECORD_MMAP;
-	/*
-	 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
-	 */
-	event->header.misc = PERF_RECORD_MISC_USER;
 
 	while (1) {
 		char bf[BUFSIZ];
@@ -215,9 +212,17 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 
 		if (n != 5)
 			continue;
+		/*
+		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
+		 */
+		event->header.misc = PERF_RECORD_MISC_USER;
 
-		if (prot[2] != 'x')
-			continue;
+		if (prot[2] != 'x') {
+			if (!mmap_data || prot[0] != 'r')
+				continue;
+
+			event->header.misc |= PERF_RECORD_MISC_MMAP_DATA;
+		}
 
 		if (!strcmp(execname, ""))
 			strcpy(execname, anonstr);
@@ -304,20 +309,21 @@ static int __event__synthesize_thread(union perf_event *comm_event,
 				      pid_t pid, int full,
 					  perf_event__handler_t process,
 				      struct perf_tool *tool,
-				      struct machine *machine)
+				      struct machine *machine, bool mmap_data)
 {
 	pid_t tgid = perf_event__synthesize_comm(tool, comm_event, pid, full,
 						 process, machine);
 	if (tgid == -1)
 		return -1;
 	return perf_event__synthesize_mmap_events(tool, mmap_event, pid, tgid,
-						  process, machine);
+						  process, machine, mmap_data);
 }
 
 int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      struct thread_map *threads,
 				      perf_event__handler_t process,
-				      struct machine *machine)
+				      struct machine *machine,
+				      bool mmap_data)
 {
 	union perf_event *comm_event, *mmap_event;
 	int err = -1, thread, j;
@@ -334,7 +340,8 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 	for (thread = 0; thread < threads->nr; ++thread) {
 		if (__event__synthesize_thread(comm_event, mmap_event,
 					       threads->map[thread], 0,
-					       process, tool, machine)) {
+					       process, tool, machine,
+					       mmap_data)) {
 			err = -1;
 			break;
 		}
@@ -356,10 +363,10 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 
 			/* if not, generate events for it */
 			if (need_leader &&
-			    __event__synthesize_thread(comm_event,
-						      mmap_event,
-						      comm_event->comm.pid, 0,
-						      process, tool, machine)) {
+			    __event__synthesize_thread(comm_event, mmap_event,
+						       comm_event->comm.pid, 0,
+						       process, tool, machine,
+						       mmap_data)) {
 				err = -1;
 				break;
 			}
@@ -374,7 +381,7 @@ out:
 
 int perf_event__synthesize_threads(struct perf_tool *tool,
 				   perf_event__handler_t process,
-				   struct machine *machine)
+				   struct machine *machine, bool mmap_data)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
@@ -404,7 +411,7 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
  		 * one thread couldn't be synthesized.
  		 */
 		__event__synthesize_thread(comm_event, mmap_event, pid, 1,
-					   process, tool, machine);
+					   process, tool, machine, mmap_data);
 	}
 
 	err = 0;
@@ -528,19 +535,22 @@ int perf_event__process_lost(struct perf_tool *tool __maybe_unused,
 
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 {
-	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64 "]: %s\n",
+	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64 "]: %c %s\n",
 		       event->mmap.pid, event->mmap.tid, event->mmap.start,
-		       event->mmap.len, event->mmap.pgoff, event->mmap.filename);
+		       event->mmap.len, event->mmap.pgoff,
+		       (event->header.misc & PERF_RECORD_MISC_MMAP_DATA) ? 'r' : 'x',
+		       event->mmap.filename);
 }
 
 size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp)
 {
 	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64
-			   " %02x:%02x %"PRIu64" %"PRIu64"]: %s\n",
+			   " %02x:%02x %"PRIu64" %"PRIu64"]: %c %s\n",
 		       event->mmap2.pid, event->mmap2.tid, event->mmap2.start,
 		       event->mmap2.len, event->mmap2.pgoff, event->mmap2.maj,
 		       event->mmap2.min, event->mmap2.ino,
 		       event->mmap2.ino_generation,
+		       (event->header.misc & PERF_RECORD_MISC_MMAP_DATA) ? 'r' : 'x',
 		       event->mmap2.filename);
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index f8d70f3003ab..30fec9901e44 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -208,10 +208,10 @@ typedef int (*perf_event__handler_t)(struct perf_tool *tool,
 int perf_event__synthesize_thread_map(struct perf_tool *tool,
 				      struct thread_map *threads,
 				      perf_event__handler_t process,
-				      struct machine *machine);
+				      struct machine *machine, bool mmap_data);
 int perf_event__synthesize_threads(struct perf_tool *tool,
 				   perf_event__handler_t process,
-				   struct machine *machine);
+				   struct machine *machine, bool mmap_data);
 int perf_event__synthesize_kernel_mmap(struct perf_tool *tool,
 				       perf_event__handler_t process,
 				       struct machine *machine,
-- 
1.8.1.4

