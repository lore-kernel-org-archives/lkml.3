Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3LKMjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:47087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3LKMjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="422885407"
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
Subject: [PATCH v0 15/71] perf tools: Add ability to record the current tid for each cpu
Date: Wed, 11 Dec 2013 14:36:27 +0200
Message-Id: <1386765443-26966-16-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an array to struct machine to store
the current tid running on each cpu.
Add machine functions to get / set
the tid for a cpu.

This will be used to determine the tid
when decoding a per-cpu Instruction Trace.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 39 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/machine.h |  4 ++++
 2 files changed, 43 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 52fbfb6..a04210d 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -43,6 +43,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 		thread__set_comm(thread, comm, 0);
 	}
 
+	machine->current_tid = NULL;
+
 	return 0;
 }
 
@@ -103,6 +105,8 @@ void machine__exit(struct machine *machine)
 	dsos__delete(&machine->kernel_dsos);
 	free(machine->root_dir);
 	machine->root_dir = NULL;
+	free(machine->current_tid);
+	machine->current_tid = NULL;
 }
 
 void machine__delete(struct machine *machine)
@@ -1438,3 +1442,38 @@ int machine__set_thread_cpu(struct machine *machine, pid_t pid, pid_t tid,
 
 	return 0;
 }
+
+pid_t machine__get_current_tid(struct machine *machine, int cpu)
+{
+	if (cpu < 0 || cpu >= MAX_NR_CPUS || !machine->current_tid)
+		return -1;
+
+	return machine->current_tid[cpu];
+}
+
+int machine__set_current_tid(struct machine *machine, int cpu, pid_t pid,
+			     pid_t tid)
+{
+	if (cpu < 0)
+		return -EINVAL;
+
+	if (!machine->current_tid) {
+		int i;
+
+		machine->current_tid = calloc(MAX_NR_CPUS, sizeof(pid_t));
+		if (!machine->current_tid)
+			return -ENOMEM;
+		for (i = 0; i < MAX_NR_CPUS; i++)
+			machine->current_tid[i] = -1;
+	}
+
+	if (cpu >= MAX_NR_CPUS) {
+		pr_err("Requested CPU %d too large. ", cpu);
+		pr_err("Consider raising MAX_NR_CPUS\n");
+		return -EINVAL;
+	}
+
+	machine->current_tid[cpu] = tid;
+
+	return machine__set_thread_cpu(machine, pid, tid, cpu);
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 27486af..aaad99a 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -31,6 +31,7 @@ struct machine {
 	struct map_groups kmaps;
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
 	symbol_filter_t	  symbol_filter;
+	pid_t		  *current_tid;
 };
 
 static inline
@@ -194,5 +195,8 @@ pid_t machine__get_thread_pid(struct machine *machine, pid_t tid);
 int machine__get_thread_cpu(struct machine *machine, pid_t tid, pid_t *pid);
 int machine__set_thread_cpu(struct machine *machine, pid_t pid, pid_t tid,
 			    int cpu);
+pid_t machine__get_current_tid(struct machine *machine, int cpu);
+int machine__set_current_tid(struct machine *machine, int cpu, pid_t pid,
+			     pid_t tid);
 
 #endif /* __PERF_MACHINE_H */
-- 
1.8.5.1

