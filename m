Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaGVNUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:20:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:45360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbaGVNUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985569"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/52] perf tools: Add ability to record the current tid for each cpu
Date: Tue, 22 Jul 2014 16:17:25 +0300
Message-Id: <1406035081-14301-17-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an array to struct machine to store
the current tid running on each cpu.
Add machine functions to get / set
the tid for a cpu.

This will be used to determine the tid
when decoding a per-cpu Instruction Trace.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/machine.h |  5 +++++
 2 files changed, 51 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 04c17a7..34dd63f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -47,6 +47,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 		thread__set_comm(thread, comm, 0);
 	}
 
+	machine->current_tid = NULL;
+
 	return 0;
 }
 
@@ -106,6 +108,7 @@ void machine__exit(struct machine *machine)
 	dsos__delete(&machine->user_dsos);
 	dsos__delete(&machine->kernel_dsos);
 	zfree(&machine->root_dir);
+	zfree(&machine->current_tid);
 }
 
 void machine__delete(struct machine *machine)
@@ -1532,3 +1535,46 @@ int machine__get_kernel_start(struct machine *machine)
 	}
 	return err;
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
+	struct thread *thread;
+
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
+	thread = machine__findnew_thread(machine, pid, tid);
+	if (!thread)
+		return -ENOMEM;
+
+	thread->cpu = cpu;
+
+	return 0;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index be97021..6442d65 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -35,6 +35,7 @@ struct machine {
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
 	u64		  kernel_start;
 	symbol_filter_t	  symbol_filter;
+	pid_t		  *current_tid;
 };
 
 static inline
@@ -212,4 +213,8 @@ int machine__synthesize_threads(struct machine *machine, struct target *target,
 					     perf_event__process, data_mmap);
 }
 
+pid_t machine__get_current_tid(struct machine *machine, int cpu);
+int machine__set_current_tid(struct machine *machine, int cpu, pid_t pid,
+			     pid_t tid);
+
 #endif /* __PERF_MACHINE_H */
-- 
1.8.3.2

