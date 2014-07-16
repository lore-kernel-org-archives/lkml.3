Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbaGPLL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:11:59 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61566 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830AbaGPLLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:11:53 -0400
Date: Wed, 16 Jul 2014 13:11:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140716111145.GA6150@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 1f9a7268c67f0290837aada443d28fd953ddca90 perf: Do not allow optimized switch for non-cloned events

Tooling fixes and an Intel PMU driver fixlet.

 Thanks,

	Ingo

------------------>
HATAYAMA Daisuke (1):
      perf/x86/intel: ignore CondChgd bit to avoid false NMI handling

Jiri Olsa (2):
      perf tools: Fix segfault in cumulative.callchain report
      perf: Do not allow optimized switch for non-cloned events

Simon Que (1):
      perf symbols: Get kernel start address by symbol name


 arch/x86/kernel/cpu/perf_event_intel.c |  9 ++++++
 kernel/events/core.c                   |  2 +-
 tools/perf/ui/browsers/hists.c         | 21 +++++++++----
 tools/perf/util/machine.c              | 54 ++++++++++++++--------------------
 4 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index adb02aa..07846d7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1382,6 +1382,15 @@ again:
 	intel_pmu_lbr_read();
 
 	/*
+	 * CondChgd bit 63 doesn't mean any overflow status. Ignore
+	 * and clear the bit.
+	 */
+	if (__test_and_clear_bit(63, (unsigned long *)&status)) {
+		if (!status)
+			goto done;
+	}
+
+	/*
 	 * PEBS overflow sets bit 62 in the global status register
 	 */
 	if (__test_and_clear_bit(62, (unsigned long *)&status)) {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a33d9a2b..b0c95f0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2320,7 +2320,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	next_parent = rcu_dereference(next_ctx->parent_ctx);
 
 	/* If neither context have a parent context; they cannot be clones. */
-	if (!parent && !next_parent)
+	if (!parent || !next_parent)
 		goto unlock;
 
 	if (next_parent == ctx || next_ctx == parent || next_parent == parent) {
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 52c03fb..04a229a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -17,6 +17,7 @@
 #include "../util.h"
 #include "../ui.h"
 #include "map.h"
+#include "annotate.h"
 
 struct hist_browser {
 	struct ui_browser   b;
@@ -1593,13 +1594,18 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					 bi->to.sym->name) > 0)
 				annotate_t = nr_options++;
 		} else {
-
 			if (browser->selection != NULL &&
 			    browser->selection->sym != NULL &&
-			    !browser->selection->map->dso->annotate_warned &&
-				asprintf(&options[nr_options], "Annotate %s",
-					 browser->selection->sym->name) > 0)
-				annotate = nr_options++;
+			    !browser->selection->map->dso->annotate_warned) {
+				struct annotation *notes;
+
+				notes = symbol__annotation(browser->selection->sym);
+
+				if (notes->src &&
+				    asprintf(&options[nr_options], "Annotate %s",
+						 browser->selection->sym->name) > 0)
+					annotate = nr_options++;
+			}
 		}
 
 		if (thread != NULL &&
@@ -1656,6 +1662,7 @@ retry_popup_menu:
 
 		if (choice == annotate || choice == annotate_t || choice == annotate_f) {
 			struct hist_entry *he;
+			struct annotation *notes;
 			int err;
 do_annotate:
 			if (!objdump_path && perf_session_env__lookup_objdump(env))
@@ -1679,6 +1686,10 @@ do_annotate:
 				he->ms.map = he->branch_info->to.map;
 			}
 
+			notes = symbol__annotation(he->ms.sym);
+			if (!notes->src)
+				continue;
+
 			/*
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0e5fea9..c73e1fc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -496,18 +496,6 @@ struct process_args {
 	u64 start;
 };
 
-static int symbol__in_kernel(void *arg, const char *name,
-			     char type __maybe_unused, u64 start)
-{
-	struct process_args *args = arg;
-
-	if (strchr(name, '['))
-		return 0;
-
-	args->start = start;
-	return 1;
-}
-
 static void machine__get_kallsyms_filename(struct machine *machine, char *buf,
 					   size_t bufsz)
 {
@@ -517,27 +505,41 @@ static void machine__get_kallsyms_filename(struct machine *machine, char *buf,
 		scnprintf(buf, bufsz, "%s/proc/kallsyms", machine->root_dir);
 }
 
-/* Figure out the start address of kernel map from /proc/kallsyms */
-static u64 machine__get_kernel_start_addr(struct machine *machine)
+const char *ref_reloc_sym_names[] = {"_text", "_stext", NULL};
+
+/* Figure out the start address of kernel map from /proc/kallsyms.
+ * Returns the name of the start symbol in *symbol_name. Pass in NULL as
+ * symbol_name if it's not that important.
+ */
+static u64 machine__get_kernel_start_addr(struct machine *machine,
+					  const char **symbol_name)
 {
 	char filename[PATH_MAX];
-	struct process_args args;
+	int i;
+	const char *name;
+	u64 addr = 0;
 
 	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
 
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
 		return 0;
 
-	if (kallsyms__parse(filename, &args, symbol__in_kernel) <= 0)
-		return 0;
+	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
+		addr = kallsyms__get_function_start(filename, name);
+		if (addr)
+			break;
+	}
+
+	if (symbol_name)
+		*symbol_name = name;
 
-	return args.start;
+	return addr;
 }
 
 int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel)
 {
 	enum map_type type;
-	u64 start = machine__get_kernel_start_addr(machine);
+	u64 start = machine__get_kernel_start_addr(machine, NULL);
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
@@ -852,23 +854,11 @@ static int machine__create_modules(struct machine *machine)
 	return 0;
 }
 
-const char *ref_reloc_sym_names[] = {"_text", "_stext", NULL};
-
 int machine__create_kernel_maps(struct machine *machine)
 {
 	struct dso *kernel = machine__get_kernel(machine);
-	char filename[PATH_MAX];
 	const char *name;
-	u64 addr = 0;
-	int i;
-
-	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
-
-	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
-		addr = kallsyms__get_function_start(filename, name);
-		if (addr)
-			break;
-	}
+	u64 addr = machine__get_kernel_start_addr(machine, &name);
 	if (!addr)
 		return -1;
 
