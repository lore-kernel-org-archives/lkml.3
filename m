Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaGVNee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:34:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:51607 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbaGVNT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:19:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985454"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/52] perf tools: Add machine__kernel_ip()
Date: Tue, 22 Jul 2014 16:17:14 +0300
Message-Id: <1406035081-14301-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to determine if an address is in
the kernel.  This is based on the kernel function
kernel_ip().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/event.c   |  6 +++---
 tools/perf/util/machine.c | 23 +++++++++++++++++++++++
 tools/perf/util/machine.h | 17 +++++++++++++++++
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 7e0e8ae..d1283cc 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -784,9 +784,9 @@ try_again:
 		 * "[vdso]" dso, but for now lets use the old trick of looking
 		 * in the whole kernel symbol list.
 		 */
-		if ((long long)al->addr < 0 &&
-		    cpumode == PERF_RECORD_MISC_USER &&
-		    machine && mg != &machine->kmaps) {
+		if (cpumode == PERF_RECORD_MISC_USER && machine &&
+		    mg != &machine->kmaps &&
+		    machine__kernel_ip(machine, al->addr)) {
 			mg = &machine->kmaps;
 			load_map = true;
 			goto try_again;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f0539aa..04c17a7 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -29,6 +29,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	machine->symbol_filter = NULL;
 	machine->id_hdr_size = 0;
 	machine->comm_exec = false;
+	machine->kernel_start = 0;
 
 	machine->root_dir = strdup(root_dir);
 	if (machine->root_dir == NULL)
@@ -1509,3 +1510,25 @@ int __machine__synthesize_threads(struct machine *machine, struct perf_tool *too
 	/* command specified */
 	return 0;
 }
+
+int machine__get_kernel_start(struct machine *machine)
+{
+	struct map *map = machine__kernel_map(machine, MAP__FUNCTION);
+	int err = 0;
+
+	/*
+	 * The only addresses above 2^63 are kernel addresses of a 64-bit
+	 * kernel.  Note that addresses are unsigned so that on a 32-bit system
+	 * all addresses including kernel addresses are less than 2^32.  In
+	 * that case (32-bit system), if the kernel mapping is unknown, all
+	 * addresses will be assumed to be in user space - see
+	 * machine__kernel_ip().
+	 */
+	machine->kernel_start = 1ULL << 63;
+	if (map) {
+		err = map__load(map, machine->symbol_filter);
+		if (map->start)
+			machine->kernel_start = map->start;
+	}
+	return err;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 383c725..be97021 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -33,6 +33,7 @@ struct machine {
 	struct list_head  kernel_dsos;
 	struct map_groups kmaps;
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
+	u64		  kernel_start;
 	symbol_filter_t	  symbol_filter;
 };
 
@@ -42,6 +43,22 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
 	return machine->vmlinux_maps[type];
 }
 
+int machine__get_kernel_start(struct machine *machine);
+
+static inline u64 machine__kernel_start(struct machine *machine)
+{
+	if (!machine->kernel_start)
+		machine__get_kernel_start(machine);
+	return machine->kernel_start;
+}
+
+static inline bool machine__kernel_ip(struct machine *machine, u64 ip)
+{
+	u64 kernel_start = machine__kernel_start(machine);
+
+	return ip >= kernel_start;
+}
+
 struct thread *machine__find_thread(struct machine *machine, pid_t pid,
 				    pid_t tid);
 struct comm *machine__thread_exec_comm(struct machine *machine,
-- 
1.8.3.2

