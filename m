Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3LKMjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:17698 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab3LKMi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:38:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450497408"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 14/71] perf tools: Add cpu to struct thread
Date: Wed, 11 Dec 2013 14:36:26 +0200
Message-Id: <1386765443-26966-15-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Tools may wish to track on which cpu a thread
is running.  Add 'cpu' to struct thread for
that purpose.  Also add machine functions to
get / set the cpu for a tid.

This will be used to determine the cpu when
decoding a per-thread Instruction Trace.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 26 ++++++++++++++++++++++++++
 tools/perf/util/machine.h |  3 +++
 tools/perf/util/thread.c  |  1 +
 tools/perf/util/thread.h  |  1 +
 4 files changed, 31 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 55f3608..52fbfb6 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1412,3 +1412,29 @@ pid_t machine__get_thread_pid(struct machine *machine, pid_t tid)
 
 	return thread->pid_;
 }
+
+int machine__get_thread_cpu(struct machine *machine, pid_t tid, pid_t *pid)
+{
+	struct thread *thread = machine__find_thread(machine, tid);
+
+	if (!thread)
+		return -1;
+
+	if (pid)
+		*pid = thread->pid_;
+
+	return thread->cpu;
+}
+
+int machine__set_thread_cpu(struct machine *machine, pid_t pid, pid_t tid,
+			    int cpu)
+{
+	struct thread *thread = machine__findnew_thread(machine, pid, tid);
+
+	if (!thread)
+		return -ENOMEM;
+
+	thread->cpu = cpu;
+
+	return 0;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index b800a5a..27486af 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -191,5 +191,8 @@ int machine__synthesize_threads(struct machine *machine, struct target *target,
 }
 
 pid_t machine__get_thread_pid(struct machine *machine, pid_t tid);
+int machine__get_thread_cpu(struct machine *machine, pid_t tid, pid_t *pid);
+int machine__set_thread_cpu(struct machine *machine, pid_t pid, pid_t tid,
+			    int cpu);
 
 #endif /* __PERF_MACHINE_H */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 49eaf1d..a120af3 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -19,6 +19,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->pid_ = pid;
 		thread->tid = tid;
 		thread->ppid = -1;
+		thread->cpu = -1;
 		INIT_LIST_HEAD(&thread->comm_list);
 
 		comm_str = malloc(32);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 5b856bf..7914050 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -17,6 +17,7 @@ struct thread {
 	pid_t			pid_; /* Not all tools update this */
 	pid_t			tid;
 	pid_t			ppid;
+	int			cpu;
 	char			shortname[3];
 	bool			comm_set;
 	bool			dead; /* if set thread has exited */
-- 
1.8.5.1

