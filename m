Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaHXPAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 11:00:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHXPAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 11:00:18 -0400
Date: Sun, 24 Aug 2014 07:58:43 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-fbe2af45f6bd27ee69fd775303c936c3af4a4807@git.kernel.org>
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
In-Reply-To: <1408129739-17368-5-git-send-email-adrian.hunter@intel.com>
References: <1408129739-17368-5-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add machine__kernel_ip()
Git-Commit-ID: fbe2af45f6bd27ee69fd775303c936c3af4a4807
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

Commit-ID:  fbe2af45f6bd27ee69fd775303c936c3af4a4807
Gitweb:     http://git.kernel.org/tip/fbe2af45f6bd27ee69fd775303c936c3af4a4807
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 15 Aug 2014 22:08:39 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 22 Aug 2014 13:12:12 -0300

perf tools: Add machine__kernel_ip()

Add a function to determine if an address is in the kernel.  This is
based on the kernel function kernel_ip().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408129739-17368-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c   |  6 +++---
 tools/perf/util/machine.c | 23 +++++++++++++++++++++++
 tools/perf/util/machine.h | 17 +++++++++++++++++
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1398c83..ed55819 100644
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
index 37f8dc5..e00daf0 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -32,6 +32,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	machine->symbol_filter = NULL;
 	machine->id_hdr_size = 0;
 	machine->comm_exec = false;
+	machine->kernel_start = 0;
 
 	machine->root_dir = strdup(root_dir);
 	if (machine->root_dir == NULL)
@@ -1559,3 +1560,25 @@ int machine__set_current_tid(struct machine *machine, int cpu, pid_t pid,
 
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
index 61216e0..6a6bcc1 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -36,6 +36,7 @@ struct machine {
 	struct list_head  kernel_dsos;
 	struct map_groups kmaps;
 	struct map	  *vmlinux_maps[MAP__NR_TYPES];
+	u64		  kernel_start;
 	symbol_filter_t	  symbol_filter;
 	pid_t		  *current_tid;
 };
@@ -46,6 +47,22 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
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
