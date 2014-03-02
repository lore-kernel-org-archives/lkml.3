Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaCBIv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 03:51:56 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:63320 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaCBIvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 03:51:54 -0500
Date: Sun, 2 Mar 2014 09:51:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140302085147.GA17584@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: af76815a31adc75dd9526230affdd678e65ac59f Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Misc fixes, most of them on the tooling side.

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      perf tools: fix BFD detection on opensuse

Jiri Olsa (1):
      perf tools: Fix strict alias issue for find_first_bit

Namhyung Kim (2):
      perf annotate: Check availability of annotate when processing samples
      perf symbols: Destroy unused symsrcs

Peter Zijlstra (2):
      perf/x86: Fix event scheduling
      perf: Fix hotplug splat


 arch/x86/kernel/cpu/perf_event.c          |  3 +++
 kernel/events/core.c                      | 12 +++++-----
 tools/perf/builtin-report.c               | 40 ++++++++++++++++++-------------
 tools/perf/builtin-top.c                  |  6 +++--
 tools/perf/config/Makefile                |  2 +-
 tools/perf/config/feature-checks/Makefile |  2 +-
 tools/perf/util/annotate.c                |  9 ++++++-
 tools/perf/util/annotate.h                |  2 ++
 tools/perf/util/include/linux/bitops.h    |  4 +++-
 tools/perf/util/symbol.c                  |  2 ++
 10 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 895604f..79f9f84 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1192,6 +1192,9 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	for (i = 0; i < cpuc->n_events; i++) {
 		if (event == cpuc->event_list[i]) {
 
+			if (i >= cpuc->n_events - cpuc->n_added)
+				--cpuc->n_added;
+
 			if (x86_pmu.put_event_constraints)
 				x86_pmu.put_event_constraints(cpuc, event);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..fa0b2d4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7856,14 +7856,14 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
 static void __perf_event_exit_context(void *__info)
 {
 	struct perf_event_context *ctx = __info;
-	struct perf_event *event, *tmp;
+	struct perf_event *event;
 
 	perf_pmu_rotate_stop(ctx->pmu);
 
-	list_for_each_entry_safe(event, tmp, &ctx->pinned_groups, group_entry)
-		__perf_remove_from_context(event);
-	list_for_each_entry_safe(event, tmp, &ctx->flexible_groups, group_entry)
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry)
 		__perf_remove_from_context(event);
+	rcu_read_unlock();
 }
 
 static void perf_event_exit_cpu_context(int cpu)
@@ -7887,11 +7887,11 @@ static void perf_event_exit_cpu(int cpu)
 {
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
+	perf_event_exit_cpu_context(cpu);
+
 	mutex_lock(&swhash->hlist_mutex);
 	swevent_hlist_release(swhash);
 	mutex_unlock(&swhash->hlist_mutex);
-
-	perf_event_exit_cpu_context(cpu);
 }
 #else
 static inline void perf_event_exit_cpu(int cpu) { }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3c53ec2..02f985f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -113,14 +113,16 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	if (!he)
 		return -ENOMEM;
 
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	if (err)
-		goto out;
+	if (ui__has_annotation()) {
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+		if (err)
+			goto out;
 
-	mx = he->mem_info;
-	err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
-	if (err)
-		goto out;
+		mx = he->mem_info;
+		err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
+		if (err)
+			goto out;
+	}
 
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
@@ -164,14 +166,18 @@ static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_loc
 		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
 					1, 1, 0);
 		if (he) {
-			bx = he->branch_info;
-			err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
-			if (err)
-				goto out;
-
-			err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
-			if (err)
-				goto out;
+			if (ui__has_annotation()) {
+				bx = he->branch_info;
+				err = addr_map_symbol__inc_samples(&bx->from,
+								   evsel->idx);
+				if (err)
+					goto out;
+
+				err = addr_map_symbol__inc_samples(&bx->to,
+								   evsel->idx);
+				if (err)
+					goto out;
+			}
 
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
@@ -205,7 +211,9 @@ static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evs
 	if (err)
 		goto out;
 
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	if (ui__has_annotation())
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 out:
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 76cd510..5f989a7 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -176,7 +176,7 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 {
 	struct annotation *notes;
 	struct symbol *sym;
-	int err;
+	int err = 0;
 
 	if (he == NULL || he->ms.sym == NULL ||
 	    ((top->sym_filter_entry == NULL ||
@@ -190,7 +190,9 @@ static void perf_top__record_precise_ip(struct perf_top *top,
 		return;
 
 	ip = he->ms.map->map_ip(he->ms.map, ip);
-	err = hist_entry__inc_addr_samples(he, counter, ip);
+
+	if (ui__has_annotation())
+		err = hist_entry__inc_addr_samples(he, counter, ip);
 
 	pthread_mutex_unlock(&notes->lock);
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c48d449..0331ea2 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -478,7 +478,7 @@ else
 endif
 
 ifeq ($(feature-libbfd), 1)
-  EXTLIBS += -lbfd
+  EXTLIBS += -lbfd -lz -liberty
 endif
 
 ifdef NO_DEMANGLE
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 12e5513..523b7bc 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -121,7 +121,7 @@ test-libpython-version.bin:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
 test-libbfd.bin:
-	$(BUILD) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -DPACKAGE='"perf"' -lbfd -lz -liberty -ldl
 
 test-liberty.bin:
 	$(CC) -o $(OUTPUT)$@ test-libbfd.c -DPACKAGE='"perf"' -lbfd -ldl -liberty
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 469eb67..3aa555f 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -8,6 +8,8 @@
  */
 
 #include "util.h"
+#include "ui/ui.h"
+#include "sort.h"
 #include "build-id.h"
 #include "color.h"
 #include "cache.h"
@@ -489,7 +491,7 @@ static int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 {
 	struct annotation *notes;
 
-	if (sym == NULL || use_browser != 1 || !sort__has_sym)
+	if (sym == NULL)
 		return 0;
 
 	notes = symbol__annotation(sym);
@@ -1399,3 +1401,8 @@ int hist_entry__annotate(struct hist_entry *he, size_t privsize)
 {
 	return symbol__annotate(he->ms.sym, he->ms.map, privsize);
 }
+
+bool ui__has_annotation(void)
+{
+	return use_browser == 1 && sort__has_sym;
+}
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index b2aef59..56ad4f5 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -151,6 +151,8 @@ void symbol__annotate_zero_histogram(struct symbol *sym, int evidx);
 void symbol__annotate_decay_histogram(struct symbol *sym, int evidx);
 void disasm__purge(struct list_head *head);
 
+bool ui__has_annotation(void);
+
 int symbol__tty_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel, bool print_lines,
 			 bool full_paths, int min_pcnt, int max_lines);
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 45cf10a..dadfa7e 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -87,13 +87,15 @@ static __always_inline unsigned long __ffs(unsigned long word)
 	return num;
 }
 
+typedef const unsigned long __attribute__((__may_alias__)) long_alias_t;
+
 /*
  * Find the first set bit in a memory region.
  */
 static inline unsigned long
 find_first_bit(const unsigned long *addr, unsigned long size)
 {
-	const unsigned long *p = addr;
+	long_alias_t *p = (long_alias_t *) addr;
 	unsigned long result = 0;
 	unsigned long tmp;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a9d758a..e89afc0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1336,6 +1336,8 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 			if (syms_ss && runtime_ss)
 				break;
+		} else {
+			symsrc__destroy(ss);
 		}
 
 	}
