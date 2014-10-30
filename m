Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbaJ3Gn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:43:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaJ3Gnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:43:53 -0400
Date: Wed, 29 Oct 2014 23:42:40 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ckcy19dcp1jfkmdihdjcqdn1@git.kernel.org>
Cc: acme@redhat.com, dzickus@redhat.com, efault@gmx.de, jean.pihet@linaro.org,
        tglx@linutronix.de, paulus@samba.org, linux-kernel@vger.kernel.org,
        bp@suse.de, adrian.hunter@intel.com, dsahern@gmail.com,
        namhyung@kernel.org, peterz@infradead.org, jolsa@redhat.com,
        mingo@kernel.org, eranian@google.com, hpa@zytor.com,
        fweisbec@gmail.com
Reply-To: efault@gmx.de, jean.pihet@linaro.org, tglx@linutronix.de,
        dzickus@redhat.com, acme@redhat.com, linux-kernel@vger.kernel.org,
        bp@suse.de, paulus@samba.org, jolsa@redhat.com, mingo@kernel.org,
        eranian@google.com, adrian.hunter@intel.com, dsahern@gmail.com,
        namhyung@kernel.org, peterz@infradead.org, hpa@zytor.com,
        fweisbec@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: A thread'
 s machine can be found via thread->mg->machine
Git-Commit-ID: bb871a9c8d68692ed2513b3f0e1c010c2ac12f44
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

Commit-ID:  bb871a9c8d68692ed2513b3f0e1c010c2ac12f44
Gitweb:     http://git.kernel.org/tip/bb871a9c8d68692ed2513b3f0e1c010c2ac12f44
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 23 Oct 2014 12:50:25 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:46 -0200

perf tools: A thread's machine can be found via thread->mg->machine

So stop passing both machine and thread to several thread methods,
reducing function signature length.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ckcy19dcp1jfkmdihdjcqdn1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/powerpc/util/skip-callchain-idx.c |  5 ++--
 tools/perf/builtin-inject.c                       |  3 +-
 tools/perf/builtin-script.c                       |  7 ++---
 tools/perf/builtin-timechart.c                    |  2 +-
 tools/perf/builtin-trace.c                        |  6 ++--
 tools/perf/tests/code-reading.c                   |  3 +-
 tools/perf/tests/mmap-thread-lookup.c             |  2 +-
 tools/perf/util/build-id.c                        |  3 +-
 tools/perf/util/callchain.h                       |  6 ++--
 tools/perf/util/event.c                           | 19 ++++++------
 tools/perf/util/event.h                           |  1 -
 tools/perf/util/machine.c                         | 35 +++++++++--------------
 tools/perf/util/thread.c                          |  4 +--
 tools/perf/util/thread.h                          |  5 ++--
 tools/perf/util/unwind-libdw.c                    |  4 +--
 tools/perf/util/unwind-libunwind.c                | 13 ++++-----
 16 files changed, 48 insertions(+), 70 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index 9892b0f..3bb50ea 100644
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -232,8 +232,7 @@ out:
  *	index:	of callchain entry that needs to be ignored (if any)
  *	-1	if no entry needs to be ignored or in case of errors
  */
-int arch_skip_callchain_idx(struct machine *machine, struct thread *thread,
-				struct ip_callchain *chain)
+int arch_skip_callchain_idx(struct thread *thread, struct ip_callchain *chain)
 {
 	struct addr_location al;
 	struct dso *dso = NULL;
@@ -246,7 +245,7 @@ int arch_skip_callchain_idx(struct machine *machine, struct thread *thread,
 
 	ip = chain->ips[2];
 
-	thread__find_addr_location(thread, machine, PERF_RECORD_MISC_USER,
+	thread__find_addr_location(thread, PERF_RECORD_MISC_USER,
 			MAP__FUNCTION, ip, &al);
 
 	if (al.map)
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index de99ca1..06f1758 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -217,8 +217,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 		goto repipe;
 	}
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->ip, &al);
+	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, sample->ip, &al);
 
 	if (al.map != NULL) {
 		if (!al.map->dso->hit) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9708a12..b35517f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -379,7 +379,6 @@ static void print_sample_start(struct perf_sample *sample,
 
 static void print_sample_addr(union perf_event *event,
 			  struct perf_sample *sample,
-			  struct machine *machine,
 			  struct thread *thread,
 			  struct perf_event_attr *attr)
 {
@@ -390,7 +389,7 @@ static void print_sample_addr(union perf_event *event,
 	if (!sample_addr_correlates_sym(attr))
 		return;
 
-	perf_event__preprocess_sample_addr(event, sample, machine, thread, &al);
+	perf_event__preprocess_sample_addr(event, sample, thread, &al);
 
 	if (PRINT_FIELD(SYM)) {
 		printf(" ");
@@ -438,7 +437,7 @@ static void print_sample_bts(union perf_event *event,
 	    ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
 	     !output[attr->type].user_set)) {
 		printf(" => ");
-		print_sample_addr(event, sample, al->machine, thread, attr);
+		print_sample_addr(event, sample, thread, attr);
 	}
 
 	if (print_srcline_last)
@@ -475,7 +474,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 		event_format__print(evsel->tp_format, sample->cpu,
 				    sample->raw_data, sample->raw_size);
 	if (PRINT_FIELD(ADDR))
-		print_sample_addr(event, sample, al->machine, thread, attr);
+		print_sample_addr(event, sample, thread, attr);
 
 	if (PRINT_FIELD(IP)) {
 		if (!symbol_conf.use_callchain)
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 35b425b..f5fb256 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -528,7 +528,7 @@ static const char *cat_backtrace(union perf_event *event,
 		}
 
 		tal.filtered = 0;
-		thread__find_addr_location(al.thread, machine, cpumode,
+		thread__find_addr_location(al.thread, cpumode,
 					   MAP__FUNCTION, ip, &tal);
 
 		if (tal.sym)
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fb12645..83a4835 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1846,7 +1846,7 @@ static int trace__pgfault(struct trace *trace,
 	if (trace->summary_only)
 		return 0;
 
-	thread__find_addr_location(thread, trace->host, cpumode, MAP__FUNCTION,
+	thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
 			      sample->ip, &al);
 
 	trace__fprintf_entry_head(trace, thread, 0, sample->time, trace->output);
@@ -1859,11 +1859,11 @@ static int trace__pgfault(struct trace *trace,
 
 	fprintf(trace->output, "] => ");
 
-	thread__find_addr_location(thread, trace->host, cpumode, MAP__VARIABLE,
+	thread__find_addr_location(thread, cpumode, MAP__VARIABLE,
 				   sample->addr, &al);
 
 	if (!al.map) {
-		thread__find_addr_location(thread, trace->host, cpumode,
+		thread__find_addr_location(thread, cpumode,
 					   MAP__FUNCTION, sample->addr, &al);
 
 		if (al.map)
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 67f2d63..144a412 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -145,8 +145,7 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 
 	pr_debug("Reading object code for memory address: %#"PRIx64"\n", addr);
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION, addr,
-			      &al);
+	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, addr, &al);
 	if (!al.map || !al.map->dso) {
 		pr_debug("thread__find_addr_map failed\n");
 		return -1;
diff --git a/tools/perf/tests/mmap-thread-lookup.c b/tools/perf/tests/mmap-thread-lookup.c
index 4a456fe..2113f1c 100644
--- a/tools/perf/tests/mmap-thread-lookup.c
+++ b/tools/perf/tests/mmap-thread-lookup.c
@@ -187,7 +187,7 @@ static int mmap_events(synth_cb synth)
 
 		pr_debug("looking for map %p\n", td->map);
 
-		thread__find_addr_map(thread, machine,
+		thread__find_addr_map(thread,
 				      PERF_RECORD_MISC_USER, MAP__FUNCTION,
 				      (unsigned long) (td->map + 1), &al);
 
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index a904a4c..2e7c68e 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -33,8 +33,7 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->ip, &al);
+	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, sample->ip, &al);
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 94cfefd..3caccc2 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -184,11 +184,9 @@ static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
 }
 
 #ifdef HAVE_SKIP_CALLCHAIN_IDX
-extern int arch_skip_callchain_idx(struct machine *machine,
-			struct thread *thread, struct ip_callchain *chain);
+extern int arch_skip_callchain_idx(struct thread *thread, struct ip_callchain *chain);
 #else
-static inline int arch_skip_callchain_idx(struct machine *machine __maybe_unused,
-			struct thread *thread __maybe_unused,
+static inline int arch_skip_callchain_idx(struct thread *thread __maybe_unused,
 			struct ip_callchain *chain __maybe_unused)
 {
 	return -1;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 4af6b27..e00a29f 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -730,12 +730,12 @@ int perf_event__process(struct perf_tool *tool __maybe_unused,
 	return machine__process_event(machine, event, sample);
 }
 
-void thread__find_addr_map(struct thread *thread,
-			   struct machine *machine, u8 cpumode,
+void thread__find_addr_map(struct thread *thread, u8 cpumode,
 			   enum map_type type, u64 addr,
 			   struct addr_location *al)
 {
 	struct map_groups *mg = thread->mg;
+	struct machine *machine = mg->machine;
 	bool load_map = false;
 
 	al->machine = machine;
@@ -806,14 +806,14 @@ try_again:
 	}
 }
 
-void thread__find_addr_location(struct thread *thread, struct machine *machine,
+void thread__find_addr_location(struct thread *thread,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al)
 {
-	thread__find_addr_map(thread, machine, cpumode, type, addr, al);
+	thread__find_addr_map(thread, cpumode, type, addr, al);
 	if (al->map != NULL)
 		al->sym = map__find_symbol(al->map, al->addr,
-					   machine->symbol_filter);
+					   thread->mg->machine->symbol_filter);
 	else
 		al->sym = NULL;
 }
@@ -842,8 +842,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	    machine->vmlinux_maps[MAP__FUNCTION] == NULL)
 		machine__create_kernel_maps(machine);
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->ip, al);
+	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, sample->ip, al);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
@@ -902,16 +901,14 @@ bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 
 void perf_event__preprocess_sample_addr(union perf_event *event,
 					struct perf_sample *sample,
-					struct machine *machine,
 					struct thread *thread,
 					struct addr_location *al)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->addr, al);
+	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, sample->addr, al);
 	if (!al->map)
-		thread__find_addr_map(thread, machine, cpumode, MAP__VARIABLE,
+		thread__find_addr_map(thread, cpumode, MAP__VARIABLE,
 				      sample->addr, al);
 
 	al->cpu = sample->cpu;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 5699e7e..5f0e0b8 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -322,7 +322,6 @@ bool is_bts_event(struct perf_event_attr *attr);
 bool sample_addr_correlates_sym(struct perf_event_attr *attr);
 void perf_event__preprocess_sample_addr(union perf_event *event,
 					struct perf_sample *sample,
-					struct machine *machine,
 					struct thread *thread,
 					struct addr_location *al);
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c70b3ff..08e63fd 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1289,7 +1289,7 @@ static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 	return 0;
 }
 
-static void ip__resolve_ams(struct machine *machine, struct thread *thread,
+static void ip__resolve_ams(struct thread *thread,
 			    struct addr_map_symbol *ams,
 			    u64 ip)
 {
@@ -1303,7 +1303,7 @@ static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 	 * Thus, we have to try consecutively until we find a match
 	 * or else, the symbol is unknown
 	 */
-	thread__find_cpumode_addr_location(thread, machine, MAP__FUNCTION, ip, &al);
+	thread__find_cpumode_addr_location(thread, MAP__FUNCTION, ip, &al);
 
 	ams->addr = ip;
 	ams->al_addr = al.addr;
@@ -1311,23 +1311,21 @@ static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 	ams->map = al.map;
 }
 
-static void ip__resolve_data(struct machine *machine, struct thread *thread,
+static void ip__resolve_data(struct thread *thread,
 			     u8 m, struct addr_map_symbol *ams, u64 addr)
 {
 	struct addr_location al;
 
 	memset(&al, 0, sizeof(al));
 
-	thread__find_addr_location(thread, machine, m, MAP__VARIABLE, addr,
-				   &al);
+	thread__find_addr_location(thread, m, MAP__VARIABLE, addr, &al);
 	if (al.map == NULL) {
 		/*
 		 * some shared data regions have execute bit set which puts
 		 * their mapping in the MAP__FUNCTION type array.
 		 * Check there as a fallback option before dropping the sample.
 		 */
-		thread__find_addr_location(thread, machine, m, MAP__FUNCTION, addr,
-					   &al);
+		thread__find_addr_location(thread, m, MAP__FUNCTION, addr, &al);
 	}
 
 	ams->addr = addr;
@@ -1344,9 +1342,8 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 	if (!mi)
 		return NULL;
 
-	ip__resolve_ams(al->machine, al->thread, &mi->iaddr, sample->ip);
-	ip__resolve_data(al->machine, al->thread, al->cpumode,
-			 &mi->daddr, sample->addr);
+	ip__resolve_ams(al->thread, &mi->iaddr, sample->ip);
+	ip__resolve_data(al->thread, al->cpumode, &mi->daddr, sample->addr);
 	mi->data_src.val = sample->data_src;
 
 	return mi;
@@ -1363,15 +1360,14 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 		return NULL;
 
 	for (i = 0; i < bs->nr; i++) {
-		ip__resolve_ams(al->machine, al->thread, &bi[i].to, bs->entries[i].to);
-		ip__resolve_ams(al->machine, al->thread, &bi[i].from, bs->entries[i].from);
+		ip__resolve_ams(al->thread, &bi[i].to, bs->entries[i].to);
+		ip__resolve_ams(al->thread, &bi[i].from, bs->entries[i].from);
 		bi[i].flags = bs->entries[i].flags;
 	}
 	return bi;
 }
 
-static int machine__resolve_callchain_sample(struct machine *machine,
-					     struct thread *thread,
+static int thread__resolve_callchain_sample(struct thread *thread,
 					     struct ip_callchain *chain,
 					     struct symbol **parent,
 					     struct addr_location *root_al,
@@ -1395,7 +1391,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	 * Based on DWARF debug information, some architectures skip
 	 * a callchain entry saved by the kernel.
 	 */
-	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
+	skip_idx = arch_skip_callchain_idx(thread, chain);
 
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
@@ -1437,7 +1433,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		}
 
 		al.filtered = 0;
-		thread__find_addr_location(thread, machine, cpumode,
+		thread__find_addr_location(thread, cpumode,
 					   MAP__FUNCTION, ip, &al);
 		if (al.sym != NULL) {
 			if (sort__has_parent && !*parent &&
@@ -1476,11 +1472,8 @@ int machine__resolve_callchain(struct machine *machine,
 			       struct addr_location *root_al,
 			       int max_stack)
 {
-	int ret;
-
-	ret = machine__resolve_callchain_sample(machine, thread,
-						sample->callchain, parent,
-						root_al, max_stack);
+	int ret = thread__resolve_callchain_sample(thread, sample->callchain,
+						   parent, root_al, max_stack);
 	if (ret)
 		return ret;
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 8db9626..bf5bf85 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -198,7 +198,6 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 }
 
 void thread__find_cpumode_addr_location(struct thread *thread,
-					struct machine *machine,
 					enum map_type type, u64 addr,
 					struct addr_location *al)
 {
@@ -211,8 +210,7 @@ void thread__find_cpumode_addr_location(struct thread *thread,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(cpumodes); i++) {
-		thread__find_addr_location(thread, machine, cpumodes[i], type,
-					   addr, al);
+		thread__find_addr_location(thread, cpumodes[i], type, addr, al);
 		if (al->map)
 			break;
 	}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 8c75fa7..6ef9fe6 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -54,16 +54,15 @@ void thread__insert_map(struct thread *thread, struct map *map);
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
 
-void thread__find_addr_map(struct thread *thread, struct machine *machine,
+void thread__find_addr_map(struct thread *thread,
 			   u8 cpumode, enum map_type type, u64 addr,
 			   struct addr_location *al);
 
-void thread__find_addr_location(struct thread *thread, struct machine *machine,
+void thread__find_addr_location(struct thread *thread,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al);
 
 void thread__find_cpumode_addr_location(struct thread *thread,
-					struct machine *machine,
 					enum map_type type, u64 addr,
 					struct addr_location *al);
 
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index 7419768..f24b350 100644
--- a/tools/perf/util/unwind-libdw.c
+++ b/tools/perf/util/unwind-libdw.c
@@ -26,7 +26,7 @@ static int __report_module(struct addr_location *al, u64 ip,
 	Dwfl_Module *mod;
 	struct dso *dso = NULL;
 
-	thread__find_addr_location(ui->thread, ui->machine,
+	thread__find_addr_location(ui->thread,
 				   PERF_RECORD_MISC_USER,
 				   MAP__FUNCTION, ip, al);
 
@@ -89,7 +89,7 @@ static int access_dso_mem(struct unwind_info *ui, Dwarf_Addr addr,
 	struct addr_location al;
 	ssize_t size;
 
-	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
+	thread__find_addr_map(ui->thread, PERF_RECORD_MISC_USER,
 			      MAP__FUNCTION, addr, &al);
 	if (!al.map) {
 		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 4d45c0d..29acc8c 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -284,7 +284,7 @@ static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
 {
 	struct addr_location al;
 
-	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
+	thread__find_addr_map(ui->thread, PERF_RECORD_MISC_USER,
 			      MAP__FUNCTION, ip, &al);
 	return al.map;
 }
@@ -374,7 +374,7 @@ static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
 	struct addr_location al;
 	ssize_t size;
 
-	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
+	thread__find_addr_map(ui->thread, PERF_RECORD_MISC_USER,
 			      MAP__FUNCTION, addr, &al);
 	if (!al.map) {
 		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
@@ -476,14 +476,13 @@ static void put_unwind_info(unw_addr_space_t __maybe_unused as,
 	pr_debug("unwind: put_unwind_info called\n");
 }
 
-static int entry(u64 ip, struct thread *thread, struct machine *machine,
+static int entry(u64 ip, struct thread *thread,
 		 unwind_entry_cb_t cb, void *arg)
 {
 	struct unwind_entry e;
 	struct addr_location al;
 
-	thread__find_addr_location(thread, machine,
-				   PERF_RECORD_MISC_USER,
+	thread__find_addr_location(thread, PERF_RECORD_MISC_USER,
 				   MAP__FUNCTION, ip, &al);
 
 	e.ip = ip;
@@ -586,7 +585,7 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		unw_word_t ip;
 
 		unw_get_reg(&c, UNW_REG_IP, &ip);
-		ret = ip ? entry(ip, ui->thread, ui->machine, cb, arg) : 0;
+		ret = ip ? entry(ip, ui->thread, cb, arg) : 0;
 	}
 
 	return ret;
@@ -611,7 +610,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (ret)
 		return ret;
 
-	ret = entry(ip, thread, machine, cb, arg);
+	ret = entry(ip, thread, cb, arg);
 	if (ret)
 		return -ENOMEM;
 
