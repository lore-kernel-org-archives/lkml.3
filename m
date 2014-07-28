Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaG1IYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:24:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaG1IYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:24:39 -0400
Date: Mon, 28 Jul 2014 01:23:39 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-b9d266baac0429f70df3f9cf751b045730d612e3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-17-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-17-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine:
  Add ability to record the current tid for each cpu
Git-Commit-ID: b9d266baac0429f70df3f9cf751b045730d612e3
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

Commit-ID:  b9d266baac0429f70df3f9cf751b045730d612e3
Gitweb:     http://git.kernel.org/tip/b9d266baac0429f70df3f9cf751b045730d612e3
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:25 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 11:35:43 -0300

perf machine: Add ability to record the current tid for each cpu

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
index 93c8b6f..cfc6910 100644
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
index c8c74a1..8771d0c 100644
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
