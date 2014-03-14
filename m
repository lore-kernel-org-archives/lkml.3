Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbaCNVaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:30:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54014 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbaCNVaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:30:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/16] perf machine: Factor machine__find_thread to take tid argument
Date: Fri, 14 Mar 2014 18:30:10 -0300
Message-Id: <1394832610-17818-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Forcing the code to always search thread by pid/tid pair.

The PID value will be needed in future to determine the process thread
leader for map groups sharing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1394805606-25883-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/dwarf-unwind.c |  2 +-
 tools/perf/util/machine.c       | 13 +++++++++----
 tools/perf/util/machine.h       |  3 ++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index f16ea2808a75..c059ee81c038 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -128,7 +128,7 @@ int test__dwarf_unwind(void)
 	if (verbose > 1)
 		machine__fprintf(machine, stderr);
 
-	thread = machine__find_thread(machine, getpid());
+	thread = machine__find_thread(machine, getpid(), getpid());
 	if (!thread) {
 		pr_err("Could not get thread\n");
 		goto out;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a6799538069c..5cecd98c1bc0 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -327,9 +327,10 @@ struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
 	return __machine__findnew_thread(machine, pid, tid, true);
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t tid)
+struct thread *machine__find_thread(struct machine *machine, pid_t pid,
+				    pid_t tid)
 {
-	return __machine__findnew_thread(machine, 0, tid, false);
+	return __machine__findnew_thread(machine, pid, tid, false);
 }
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event,
@@ -1114,7 +1115,9 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
 int machine__process_fork_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample)
 {
-	struct thread *thread = machine__find_thread(machine, event->fork.tid);
+	struct thread *thread = machine__find_thread(machine,
+						     event->fork.pid,
+						     event->fork.tid);
 	struct thread *parent = machine__findnew_thread(machine,
 							event->fork.ppid,
 							event->fork.ptid);
@@ -1140,7 +1143,9 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 int machine__process_exit_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample __maybe_unused)
 {
-	struct thread *thread = machine__find_thread(machine, event->fork.tid);
+	struct thread *thread = machine__find_thread(machine,
+						     event->fork.pid,
+						     event->fork.tid);
 
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 2e6c248c870f..c8c74a119398 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -41,7 +41,8 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
 	return machine->vmlinux_maps[type];
 }
 
-struct thread *machine__find_thread(struct machine *machine, pid_t tid);
+struct thread *machine__find_thread(struct machine *machine, pid_t pid,
+				    pid_t tid);
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample);
-- 
1.8.1.4

