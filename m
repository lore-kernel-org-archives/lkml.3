Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaLXHSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:18:42 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40243 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaLXHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:41 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 29/37] perf top: Always creates thread in the current task tree.
Date: Wed, 24 Dec 2014 16:15:25 +0900
Message-Id: <1419405333-27952-30-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When machine__findnew_thread_time() creates a new thread, it puts the
thread in the missing_threads tree assuming it's rare case that missed
related task/mmap events during the recorded header file.

However this is not the case of live profiling - so it should be
treated differently.  This patch fixes NULL thread->mg reference in
case of missing threads in live profiling.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c |  5 ++++-
 tools/perf/util/event.c  | 24 ++++++++++++++++++------
 tools/perf/util/event.h  |  5 +++++
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 818ae35cbd7b..2d75a7fab470 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -699,6 +699,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 {
 	struct perf_top *top = container_of(tool, struct perf_top, tool);
 	struct addr_location al;
+	struct thread *thread;
 	int err;
 
 	if (!machine && perf_guest) {
@@ -724,7 +725,9 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		top->exact_samples++;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0)
+	/* Always use current thread tree for live profiling */
+	thread = machine__findnew_thread(machine, sample->pid, sample->tid);
+	if (__perf_event__preprocess_sample(event, machine, thread, &al, sample) < 0)
 		return;
 
 	if (!top->kptr_restrict_warned &&
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3bb186a26314..452af8f4b0f3 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -863,14 +863,13 @@ void thread__find_addr_location_time(struct thread *thread, u8 cpumode,
 		al->sym = NULL;
 }
 
-int perf_event__preprocess_sample(const union perf_event *event,
-				  struct machine *machine,
-				  struct addr_location *al,
-				  struct perf_sample *sample)
+int __perf_event__preprocess_sample(const union perf_event *event,
+				    struct machine *machine,
+				    struct thread *thread,
+				    struct addr_location *al,
+				    struct perf_sample *sample)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread = machine__findnew_thread_time(machine, sample->pid,
-							     sample->tid, sample->time);
 
 	if (thread == NULL)
 		return -1;
@@ -928,6 +927,19 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	return 0;
 }
 
+int perf_event__preprocess_sample(const union perf_event *event,
+				  struct machine *machine,
+				  struct addr_location *al,
+				  struct perf_sample *sample)
+{
+	struct thread *thread;
+
+	thread = machine__findnew_thread_time(machine, sample->pid,
+					      sample->tid, sample->time);
+	return __perf_event__preprocess_sample(event, machine, thread,
+					       al, sample);
+}
+
 bool is_bts_event(struct perf_event_attr *attr)
 {
 	return attr->type == PERF_TYPE_HARDWARE &&
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 5f66abfa61ca..1fbd37864241 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -352,6 +352,11 @@ int perf_event__process(struct perf_tool *tool,
 
 struct addr_location;
 
+int __perf_event__preprocess_sample(const union perf_event *event,
+				    struct machine *machine,
+				    struct thread *thread,
+				    struct addr_location *al,
+				    struct perf_sample *sample);
 int perf_event__preprocess_sample(const union perf_event *event,
 				  struct machine *machine,
 				  struct addr_location *al,
-- 
2.1.3

