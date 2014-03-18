Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaCRIcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:32:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaCRIbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:31:49 -0400
Date: Tue, 18 Mar 2014 01:31:22 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-d75e6097ef1f7669deb500fbbdf53cfe524f1b53@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, dzickus@redhat.com
In-Reply-To: <1394805606-25883-3-git-send-email-jolsa@redhat.com>
References: <1394805606-25883-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine:
  Factor machine__find_thread to take tid argument
Git-Commit-ID: d75e6097ef1f7669deb500fbbdf53cfe524f1b53
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

Commit-ID:  d75e6097ef1f7669deb500fbbdf53cfe524f1b53
Gitweb:     http://git.kernel.org/tip/d75e6097ef1f7669deb500fbbdf53cfe524f1b53
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 14 Mar 2014 15:00:03 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 18:08:42 -0300

perf machine: Factor machine__find_thread to take tid argument

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
index f16ea28..c059ee8 100644
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
index a679953..5cecd98 100644
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
index 2e6c248..c8c74a1 100644
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
