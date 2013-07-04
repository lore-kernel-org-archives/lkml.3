Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab3GDNPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:15:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:65349 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445Ab3GDNPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:15:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,995,1363158000"; 
   d="scan'208";a="264088073"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V4 14/21] perf tools: change "machine" functions to set thread pid
Date: Thu,  4 Jul 2013 16:20:33 +0300
Message-Id: <1372944040-32690-15-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
References: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typically tracking events such as mmap events, comm events,
fork events and exit events, are processed by "machine"
functions.  Change these functions to put pid in the new
pid_ member of struct thread.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 21 +++++++++++++++++----
 tools/perf/util/machine.h |  2 ++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index fe5d9db..a7ed350 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -287,6 +287,12 @@ struct thread *machine__findnew_thread(struct machine *machine, pid_t tid)
 	return __machine__findnew_thread(machine, 0, tid, true);
 }
 
+struct thread *machine__findnew_thread_ex(struct machine *machine, pid_t pid,
+					  pid_t tid)
+{
+	return __machine__findnew_thread(machine, pid, tid, true);
+}
+
 struct thread *machine__find_thread(struct machine *machine, pid_t tid)
 {
 	return __machine__findnew_thread(machine, 0, tid, false);
@@ -294,7 +300,9 @@ struct thread *machine__find_thread(struct machine *machine, pid_t tid)
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
+	struct thread *thread = machine__findnew_thread_ex(machine,
+							   event->comm.pid,
+							   event->comm.tid);
 
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
@@ -975,7 +983,8 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 		return 0;
 	}
 
-	thread = machine__findnew_thread(machine, event->mmap.pid);
+	thread = machine__findnew_thread_ex(machine, event->mmap.pid,
+					    event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1002,8 +1011,12 @@ out_problem:
 
 int machine__process_fork_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
-	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
+	struct thread *thread = machine__findnew_thread_ex(machine,
+							   event->fork.pid,
+							   event->fork.tid);
+	struct thread *parent = machine__findnew_thread_ex(machine,
+							   event->fork.ppid,
+							   event->fork.ptid);
 
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index e49ba01..d986ecf 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -100,6 +100,8 @@ static inline bool machine__is_host(struct machine *machine)
 }
 
 struct thread *machine__findnew_thread(struct machine *machine, pid_t tid);
+struct thread *machine__findnew_thread_ex(struct machine *machine, pid_t pid,
+					  pid_t tid);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
-- 
1.7.11.7

