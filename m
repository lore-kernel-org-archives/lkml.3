Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaDONc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:32:57 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:1774 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317AbaDONcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:32:53 -0400
X-IronPort-AV: E=Sophos;i="4.97,863,1389715200"; 
   d="scan'208";a="29292488"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <peterz@infradead.org>, <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Dongsheng <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 5/8] perf tools: record and process sched:sched_wait event.
Date: Tue, 15 Apr 2014 21:32:54 +0900
Message-ID: <3728a8252d0d33315931c11f078b865368896cae.1397562542.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng <yangds.fnst@cn.fujitsu.com>

Currently, perf sched tool does not cover any trace event when
a task from TASK_RINNING to TASK_{UN}INTERRUPTIBLE. Then if
a thread changed to TASK_{UN}INTERRUPTIBLE, but we did not
capture a event for it, so the state of atom is still TASK_RUNNING,
at this time, when we process a sched_wakeup event, we will see
the thread state is not TASK_SLEEP, and record a state_bug.

This patch make it record and process sched_wait event, to solve
this problem.

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-sched.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9ac0a49..a32af4e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -117,6 +117,10 @@ struct trace_sched_handler {
 				  struct perf_evsel *evsel,
 				  struct perf_sample *sample,
 				  struct machine *machine);
+
+	int (*wait_event)(struct perf_sched *sched, struct perf_evsel *evsel,
+			  struct perf_sample *sample, struct machine *machine);
+
 };
 
 struct perf_sched {
@@ -863,6 +867,22 @@ add_sched_out_event(struct work_atoms *atoms,
 	return 0;
 }
 
+static int
+add_sched_wait_event(struct work_atoms *atoms,
+		     u64 timestamp)
+{
+	struct work_atom *atom = zalloc(sizeof(*atom));
+	if (!atom) {
+		pr_err("Non memory at %s", __func__);
+		return -1;
+	}
+
+	atom->sched_out_time = timestamp;
+
+	list_add_tail(&atom->list, &atoms->work_list);
+	return 0;
+}
+
 static void
 add_runtime_event(struct work_atoms *atoms, u64 delta,
 		  u64 timestamp __maybe_unused)
@@ -1100,6 +1120,32 @@ static int latency_migrate_task_event(struct perf_sched *sched,
 	return 0;
 }
 
+static int latency_wait_event(struct perf_sched *sched,
+			      struct perf_evsel *evsel,
+			      struct perf_sample *sample,
+			      struct machine *machine)
+{
+	const u32 pid = perf_evsel__intval(evsel, sample, "pid");
+	struct work_atoms *atoms;
+	struct thread *wakee;
+	u64 timestamp = sample->time;
+
+	wakee = machine__findnew_thread(machine, 0, pid);
+	atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
+	if (!atoms) {
+		if (thread_atoms_insert(sched, wakee))
+			return -1;
+		atoms = thread_atoms_search(&sched->atom_root, wakee, &sched->cmp_pid);
+		if (!atoms) {
+			pr_err("wakeup-event: Internal tree error");
+			return -1;
+		}
+	}
+
+	add_sched_wait_event(atoms, timestamp);
+	return 0;
+}
+
 static void output_lat_thread(struct perf_sched *sched, struct work_atoms *work_list)
 {
 	int i;
@@ -1250,6 +1296,19 @@ static void perf_sched__sort_lat(struct perf_sched *sched)
 	}
 }
 
+static int process_sched_wait(struct perf_tool *tool,
+			      struct perf_evsel *evsel,
+			      struct perf_sample *sample,
+			      struct machine *machine)
+{
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
+
+	if (sched->tp_handler->wait_event)
+		return sched->tp_handler->wait_event(sched, evsel, sample, machine);
+
+	return 0;
+}
+
 static int process_sched_wakeup_event(struct perf_tool *tool,
 				      struct perf_evsel *evsel,
 				      struct perf_sample *sample,
@@ -1444,6 +1503,7 @@ static int perf_sched__read_events(struct perf_sched *sched,
 		{ "sched:sched_wakeup",	      process_sched_wakeup_event, },
 		{ "sched:sched_wakeup_new",   process_sched_wakeup_event, },
 		{ "sched:sched_migrate_task", process_sched_migrate_task_event, },
+		{ "sched:sched_wait",	      process_sched_wait, },
 	};
 	struct perf_session *session;
 	struct perf_data_file file = {
@@ -1636,6 +1696,7 @@ static int __cmd_record(int argc, const char **argv)
 		"-e", "sched:sched_process_fork",
 		"-e", "sched:sched_wakeup",
 		"-e", "sched:sched_migrate_task",
+		"-e", "sched:sched_wait",
 	};
 
 	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
@@ -1722,6 +1783,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		.switch_event	    = latency_switch_event,
 		.runtime_event	    = latency_runtime_event,
 		.migrate_task_event = latency_migrate_task_event,
+		.wait_event	    = latency_wait_event,
 	};
 	struct trace_sched_handler map_ops  = {
 		.switch_event	    = map_switch_event,
-- 
1.8.2.1

