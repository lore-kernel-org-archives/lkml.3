Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711Ab3HHCvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:51:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:52089 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636Ab3HHCvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:12 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 01/19] perf: sample after exit loses thread correlation - v3
Date: Wed,  7 Aug 2013 22:50:43 -0400
Message-Id: <1375930261-77273-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Occassionally events (e.g., context-switch, sched tracepoints) are losing
the conversion of sample data associated with a thread. For example:

$ perf record -e sched:sched_switch -c 1 -a -- sleep 5
$ perf script
<selected events shown>
    ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
    ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
:30482 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...

The last line lost the conversion from tid to comm. If you look at the events
(perf script -D) you see why - SAMPLE event is generated after the EXIT:

0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
... thread: :30482:30482

When perf processes the EXIT event the thread is moved to the dead_threads
list. When the SAMPLE event is processed no thread exists for the pid so a new
one is created by machine__findnew_thread.

This patch address the problem by delaying the move to the dead_threads list
until the tid is re-used (per Adrian's suggestion).

With this patch we get the previous example shows:

  ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
  ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
  ls 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...

and

  0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
  0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
  ... thread: ls:30482

v3: re-do from a time based check to a delayed move to dead_threads list

v2: Rebased to latest perf/core branch. Changed time comparison to use
    a macro which explicitly shows the time basis

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 6fcc358..7784a9d 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1011,11 +1011,27 @@ out_problem:
 	return 0;
 }
 
+static void machine__remove_thread(struct machine *machine, struct thread *th)
+{
+	machine->last_match = NULL;
+	rb_erase(&th->rb_node, &machine->threads);
+	/*
+	 * We may have references to this thread, for instance in some hist_entry
+	 * instances, so just move them to a separate list.
+	 */
+	list_add_tail(&th->node, &machine->dead_threads);
+}
+
 int machine__process_fork_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
+	struct thread *thread = machine__find_thread(machine, event->fork.tid);
 	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
 
+	/* if a thread currently exists for the thread id remove it */
+	if (thread != NULL)
+		machine__remove_thread(machine, thread);
+
+	thread = machine__findnew_thread(machine, event->fork.tid);
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
 
@@ -1028,27 +1044,12 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 	return 0;
 }
 
-static void machine__remove_thread(struct machine *machine, struct thread *th)
-{
-	machine->last_match = NULL;
-	rb_erase(&th->rb_node, &machine->threads);
-	/*
-	 * We may have references to this thread, for instance in some hist_entry
-	 * instances, so just move them to a separate list.
-	 */
-	list_add_tail(&th->node, &machine->dead_threads);
-}
-
-int machine__process_exit_event(struct machine *machine, union perf_event *event)
+int machine__process_exit_event(struct machine *machine __maybe_unused,
+				union perf_event *event)
 {
-	struct thread *thread = machine__find_thread(machine, event->fork.tid);
-
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
 
-	if (thread != NULL)
-		machine__remove_thread(machine, thread);
-
 	return 0;
 }
 
-- 
1.7.10.1

