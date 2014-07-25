Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbaGYPh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:37:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:34981 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaGYPh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:37:56 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/27] perf machine: Add ability to record the current tid for each cpu
Date: Fri, 25 Jul 2014 12:36:51 -0300
Message-Id: <1406302629-11790-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add an array to struct machine to store the current tid running on each
cpu.

Add machine functions to get / set the tid for a cpu.

This will be used to determine the tid when decoding a per-cpu
Instruction Trace.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-17-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/machine.h |  5 +++++
 2 files changed, 51 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 93c8b6fbc799..cfc691000f13 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -45,6 +45,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 		thread__set_comm(thread, comm, 0);
 	}
 
+	machine->current_tid = NULL;
+
 	return 0;
 }
 
@@ -104,6 +106,7 @@ void machine__exit(struct machine *machine)
 	dsos__delete(&machine->user_dsos);
 	dsos__delete(&machine->kernel_dsos);
 	zfree(&machine->root_dir);
+	zfree(&machine->current_tid);
 }
 
 void machine__delete(struct machine *machine)
@@ -1481,3 +1484,46 @@ int __machine__synthesize_threads(struct machine *machine, struct perf_tool *too
 	/* command specified */
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
index c8c74a119398..8771d0cbe9cb 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -33,6 +33,7 @@ struct machine {
 	struct map_groups kmaps;
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
 	symbol_filter_t	  symbol_filter;
+	pid_t		  *current_tid;
 };
 
 static inline
@@ -191,4 +192,8 @@ int machine__synthesize_threads(struct machine *machine, struct target *target,
 					     perf_event__process, data_mmap);
 }
 
+pid_t machine__get_current_tid(struct machine *machine, int cpu);
+int machine__set_current_tid(struct machine *machine, int cpu, pid_t pid,
+			     pid_t tid);
+
 #endif /* __PERF_MACHINE_H */
-- 
1.9.3

