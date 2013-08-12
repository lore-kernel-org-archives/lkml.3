Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab3HLKVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:21:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3HLKVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:21:39 -0400
Date: Mon, 12 Aug 2013 03:20:51 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-5b7ba82a75915e739709d0ace4bb559cb280db09@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375875537-4509-3-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Load kernel maps before using
Git-Commit-ID: 5b7ba82a75915e739709d0ace4bb559cb280db09
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:20:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b7ba82a75915e739709d0ace4bb559cb280db09
Gitweb:     http://git.kernel.org/tip/5b7ba82a75915e739709d0ace4bb559cb280db09
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:46 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:31 -0300

perf symbols: Load kernel maps before using

In order to use kernel maps to read object code, those maps must be
adjusted to map to the dso file offset.  Because lazy-initialization is
used, that is not done until symbols are loaded.  However the maps are
first used by thread__find_addr_map() before symbols are loaded.  So
this patch changes thread__find_addr() to "load" kernel maps before
using them.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375875537-4509-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
