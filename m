Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab3HBKFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:05:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:52034 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465Ab3HBKFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:05:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,800,1367996400"; 
   d="scan'208";a="380030174"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V3 02/10] perf tools: load kernel maps before using
Date: Fri,  2 Aug 2013 13:10:44 +0300
Message-Id: <1375438252-24776-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375438252-24776-1-git-send-email-adrian.hunter@intel.com>
References: <1375438252-24776-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to use kernel maps to read object code, those
maps must be adjusted to map to the dso file offset.
Because lazy-initialization is used, that is not done
until symbols are loaded.  However the maps are first
used by thread__find_addr_map() before symbols are loaded.
So this patch changes thread__find_addr() to "load" kernel
maps before using them.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c     |  2 +-
 tools/perf/builtin-script.c     |  4 ++--
 tools/perf/tests/code-reading.c |  2 +-
 tools/perf/util/build-id.c      |  2 +-
 tools/perf/util/event.c         | 18 ++++++++++++++----
 tools/perf/util/thread.h        |  2 +-
 tools/perf/util/unwind.c        |  4 ++--
 7 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 1d8de2e..f012a98 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -206,7 +206,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 	}
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, &al);
+			      event->ip.ip, &al, NULL);
 
 	if (al.map != NULL) {
 		if (!al.map->dso->hit) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1cad370..cd616ff 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -341,10 +341,10 @@ static void print_sample_addr(union perf_event *event,
 		return;
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->addr, &al);
+			      sample->addr, &al, NULL);
 	if (!al.map)
 		thread__find_addr_map(thread, machine, cpumode, MAP__VARIABLE,
-				      sample->addr, &al);
+				      sample->addr, &al, NULL);
 
 	al.cpu = sample->cpu;
 	al.sym = NULL;
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 28bee62..0c7b052 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -138,7 +138,7 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 	pr_debug("Reading object code for memory address: %#"PRIx64"\n", addr);
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION, addr,
-			      &al);
+			      &al, NULL);
 	if (!al.map || !al.map->dso) {
 		pr_debug("thread__find_addr_map failed\n");
 		return -1;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 5295625..3a0f508 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -33,7 +33,7 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 	}
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, &al);
+			      event->ip.ip, &al, NULL);
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 9541270..cc7c0c9 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -592,9 +592,10 @@ int perf_event__process(struct perf_tool *tool __maybe_unused,
 void thread__find_addr_map(struct thread *self,
 			   struct machine *machine, u8 cpumode,
 			   enum map_type type, u64 addr,
-			   struct addr_location *al)
+			   struct addr_location *al, symbol_filter_t filter)
 {
 	struct map_groups *mg = &self->mg;
+	bool load_map = false;
 
 	al->thread = self;
 	al->addr = addr;
@@ -609,11 +610,13 @@ void thread__find_addr_map(struct thread *self,
 	if (cpumode == PERF_RECORD_MISC_KERNEL && perf_host) {
 		al->level = 'k';
 		mg = &machine->kmaps;
+		load_map = true;
 	} else if (cpumode == PERF_RECORD_MISC_USER && perf_host) {
 		al->level = '.';
 	} else if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL && perf_guest) {
 		al->level = 'g';
 		mg = &machine->kmaps;
+		load_map = true;
 	} else {
 		/*
 		 * 'u' means guest os user space.
@@ -654,8 +657,15 @@ try_again:
 			mg = &machine->kmaps;
 			goto try_again;
 		}
-	} else
+	} else {
+		/*
+		 * Kernel maps might be changed when loading symbols so loading
+		 * must be done prior to using kernel maps.
+		 */
+		if (load_map)
+			map__load(al->map, filter);
 		al->addr = al->map->map_ip(al->map, al->addr);
+	}
 }
 
 void thread__find_addr_location(struct thread *thread, struct machine *machine,
@@ -663,7 +673,7 @@ void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				struct addr_location *al,
 				symbol_filter_t filter)
 {
-	thread__find_addr_map(thread, machine, cpumode, type, addr, al);
+	thread__find_addr_map(thread, machine, cpumode, type, addr, al, filter);
 	if (al->map != NULL)
 		al->sym = map__find_symbol(al->map, al->addr, filter);
 	else
@@ -699,7 +709,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		machine__create_kernel_maps(machine);
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, al);
+			      event->ip.ip, al, filter);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 0fe1f9c..f98d1d9 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -41,7 +41,7 @@ static inline struct map *thread__find_map(struct thread *self,
 
 void thread__find_addr_map(struct thread *thread, struct machine *machine,
 			   u8 cpumode, enum map_type type, u64 addr,
-			   struct addr_location *al);
+			   struct addr_location *al, symbol_filter_t filter);
 
 void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 958723b..5bbd494 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -272,7 +272,7 @@ static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
 	struct addr_location al;
 
 	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
-			      MAP__FUNCTION, ip, &al);
+			      MAP__FUNCTION, ip, &al, NULL);
 	return al.map;
 }
 
@@ -349,7 +349,7 @@ static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
 	ssize_t size;
 
 	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
-			      MAP__FUNCTION, addr, &al);
+			      MAP__FUNCTION, addr, &al, NULL);
 	if (!al.map) {
 		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
 		return -1;
-- 
1.7.11.7

