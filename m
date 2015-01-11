Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbbAKInA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 03:43:00 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45476 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbbAKIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 03:42:58 -0500
Date: Sun, 11 Jan 2015 09:42:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20150111084252.GA1817@gmail.com>
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

   # HEAD: 5306c31c5733cb4a79cc002e0c3ad256fd439614 perf/x86/uncore/hsw-ep: Handle systems with only two SBOXes

Mostly tooling fixes, but also some kernel side fixes: uncore PMU 
driver fix, user regs sampling fix and an instruction decoder fix 
that unbreaks PEBS precise sampling.

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      perf/x86/uncore/hsw-ep: Handle systems with only two SBOXes

Andy Lutomirski (2):
      perf: Move task_pt_regs sampling into arch code
      perf/x86_64: Improve user regs sampling

Masami Hiramatsu (1):
      perf probe: Fix to fall back to find probe point in symbols

Namhyung Kim (8):
      perf report: Show progress bar for output resorting
      perf ui/tui: Print backtrace symbols when segfault occurs
      perf callchain: Append callchains only when requested
      perf probe: Fix crash in dwarf_getcfi_elf
      perf diff: Fix to sort by baseline field by default
      perf hists: Fix children sort key behavior
      perf callchain: Free callchains when hist entries are deleted
      perf hists browser: Fix segfault when showing callchain

Peter Zijlstra (1):
      x86: Fix off-by-one in instruction decoder

Taesoo Kim (1):
      perf list: Fix --raw-dump option


 arch/arm/kernel/perf_regs.c                        |  8 ++
 arch/arm64/kernel/perf_regs.c                      |  8 ++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |  2 +-
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 17 ++++
 arch/x86/kernel/perf_regs.c                        | 90 ++++++++++++++++++++++
 arch/x86/lib/insn.c                                |  2 +-
 include/linux/perf_event.h                         | 12 +--
 include/linux/perf_regs.h                          | 16 ++++
 kernel/events/core.c                               | 19 ++---
 tools/perf/builtin-annotate.c                      |  2 +-
 tools/perf/builtin-diff.c                          | 46 ++++++++++-
 tools/perf/builtin-list.c                          | 13 +++-
 tools/perf/builtin-report.c                        | 24 +++++-
 tools/perf/builtin-top.c                           |  4 +-
 tools/perf/tests/hists_cumulate.c                  | 66 ++++++++--------
 tools/perf/tests/hists_filter.c                    |  2 +-
 tools/perf/tests/hists_output.c                    | 10 +--
 tools/perf/ui/browsers/hists.c                     |  2 +-
 tools/perf/ui/hist.c                               |  3 +
 tools/perf/ui/tui/setup.c                          | 26 ++++++-
 tools/perf/util/callchain.c                        | 30 ++++++++
 tools/perf/util/callchain.h                        |  2 +
 tools/perf/util/hist.c                             | 18 ++++-
 tools/perf/util/hist.h                             |  2 +-
 tools/perf/util/probe-event.c                      |  6 +-
 tools/perf/util/probe-finder.c                     | 18 ++++-
 26 files changed, 371 insertions(+), 77 deletions(-)

diff --git a/arch/arm/kernel/perf_regs.c b/arch/arm/kernel/perf_regs.c
index 6e4379c67cbc..592dda3f21ff 100644
--- a/arch/arm/kernel/perf_regs.c
+++ b/arch/arm/kernel/perf_regs.c
@@ -28,3 +28,11 @@ u64 perf_reg_abi(struct task_struct *task)
 {
 	return PERF_SAMPLE_REGS_ABI_32;
 }
+
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
diff --git a/arch/arm64/kernel/perf_regs.c b/arch/arm64/kernel/perf_regs.c
index 6762ad705587..3f62b35fb6f1 100644
--- a/arch/arm64/kernel/perf_regs.c
+++ b/arch/arm64/kernel/perf_regs.c
@@ -50,3 +50,11 @@ u64 perf_reg_abi(struct task_struct *task)
 	else
 		return PERF_SAMPLE_REGS_ABI_64;
 }
+
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 18eb78bbdd10..863d9b02563e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -17,7 +17,7 @@
 #define UNCORE_PCI_DEV_TYPE(data)	((data >> 8) & 0xff)
 #define UNCORE_PCI_DEV_IDX(data)	(data & 0xff)
 #define UNCORE_EXTRA_PCI_DEV		0xff
-#define UNCORE_EXTRA_PCI_DEV_MAX	2
+#define UNCORE_EXTRA_PCI_DEV_MAX	3
 
 /* support up to 8 sockets */
 #define UNCORE_SOCKET_MAX		8
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 745b158e9a65..21af6149edf2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -891,6 +891,7 @@ void snbep_uncore_cpu_init(void)
 enum {
 	SNBEP_PCI_QPI_PORT0_FILTER,
 	SNBEP_PCI_QPI_PORT1_FILTER,
+	HSWEP_PCI_PCU_3,
 };
 
 static int snbep_qpi_hw_config(struct intel_uncore_box *box, struct perf_event *event)
@@ -2026,6 +2027,17 @@ void hswep_uncore_cpu_init(void)
 {
 	if (hswep_uncore_cbox.num_boxes > boot_cpu_data.x86_max_cores)
 		hswep_uncore_cbox.num_boxes = boot_cpu_data.x86_max_cores;
+
+	/* Detect 6-8 core systems with only two SBOXes */
+	if (uncore_extra_pci_dev[0][HSWEP_PCI_PCU_3]) {
+		u32 capid4;
+
+		pci_read_config_dword(uncore_extra_pci_dev[0][HSWEP_PCI_PCU_3],
+				      0x94, &capid4);
+		if (((capid4 >> 6) & 0x3) == 0)
+			hswep_uncore_sbox.num_boxes = 2;
+	}
+
 	uncore_msr_uncores = hswep_msr_uncores;
 }
 
@@ -2287,6 +2299,11 @@ static DEFINE_PCI_DEVICE_TABLE(hswep_uncore_pci_ids) = {
 		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
 						   SNBEP_PCI_QPI_PORT1_FILTER),
 	},
+	{ /* PCU.3 (for Capability registers) */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x2fc0),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   HSWEP_PCI_PCU_3),
+	},
 	{ /* end: all zeroes */ }
 };
 
diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
index e309cc5c276e..781861cc5ee8 100644
--- a/arch/x86/kernel/perf_regs.c
+++ b/arch/x86/kernel/perf_regs.c
@@ -78,6 +78,14 @@ u64 perf_reg_abi(struct task_struct *task)
 {
 	return PERF_SAMPLE_REGS_ABI_32;
 }
+
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
 #else /* CONFIG_X86_64 */
 #define REG_NOSUPPORT ((1ULL << PERF_REG_X86_DS) | \
 		       (1ULL << PERF_REG_X86_ES) | \
@@ -102,4 +110,86 @@ u64 perf_reg_abi(struct task_struct *task)
 	else
 		return PERF_SAMPLE_REGS_ABI_64;
 }
+
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy)
+{
+	struct pt_regs *user_regs = task_pt_regs(current);
+
+	/*
+	 * If we're in an NMI that interrupted task_pt_regs setup, then
+	 * we can't sample user regs at all.  This check isn't really
+	 * sufficient, though, as we could be in an NMI inside an interrupt
+	 * that happened during task_pt_regs setup.
+	 */
+	if (regs->sp > (unsigned long)&user_regs->r11 &&
+	    regs->sp <= (unsigned long)(user_regs + 1)) {
+		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
+		regs_user->regs = NULL;
+		return;
+	}
+
+	/*
+	 * RIP, flags, and the argument registers are usually saved.
+	 * orig_ax is probably okay, too.
+	 */
+	regs_user_copy->ip = user_regs->ip;
+	regs_user_copy->cx = user_regs->cx;
+	regs_user_copy->dx = user_regs->dx;
+	regs_user_copy->si = user_regs->si;
+	regs_user_copy->di = user_regs->di;
+	regs_user_copy->r8 = user_regs->r8;
+	regs_user_copy->r9 = user_regs->r9;
+	regs_user_copy->r10 = user_regs->r10;
+	regs_user_copy->r11 = user_regs->r11;
+	regs_user_copy->orig_ax = user_regs->orig_ax;
+	regs_user_copy->flags = user_regs->flags;
+
+	/*
+	 * Don't even try to report the "rest" regs.
+	 */
+	regs_user_copy->bx = -1;
+	regs_user_copy->bp = -1;
+	regs_user_copy->r12 = -1;
+	regs_user_copy->r13 = -1;
+	regs_user_copy->r14 = -1;
+	regs_user_copy->r15 = -1;
+
+	/*
+	 * For this to be at all useful, we need a reasonable guess for
+	 * sp and the ABI.  Be careful: we're in NMI context, and we're
+	 * considering current to be the current task, so we should
+	 * be careful not to look at any other percpu variables that might
+	 * change during context switches.
+	 */
+	if (IS_ENABLED(CONFIG_IA32_EMULATION) &&
+	    task_thread_info(current)->status & TS_COMPAT) {
+		/* Easy case: we're in a compat syscall. */
+		regs_user->abi = PERF_SAMPLE_REGS_ABI_32;
+		regs_user_copy->sp = user_regs->sp;
+		regs_user_copy->cs = user_regs->cs;
+		regs_user_copy->ss = user_regs->ss;
+	} else if (user_regs->orig_ax != -1) {
+		/*
+		 * We're probably in a 64-bit syscall.
+		 * Warning: this code is severely racy.  At least it's better
+		 * than just blindly copying user_regs.
+		 */
+		regs_user->abi = PERF_SAMPLE_REGS_ABI_64;
+		regs_user_copy->sp = this_cpu_read(old_rsp);
+		regs_user_copy->cs = __USER_CS;
+		regs_user_copy->ss = __USER_DS;
+		regs_user_copy->cx = -1;  /* usually contains garbage */
+	} else {
+		/* We're probably in an interrupt or exception. */
+		regs_user->abi = user_64bit_mode(user_regs) ?
+			PERF_SAMPLE_REGS_ABI_64 : PERF_SAMPLE_REGS_ABI_32;
+		regs_user_copy->sp = user_regs->sp;
+		regs_user_copy->cs = user_regs->cs;
+		regs_user_copy->ss = user_regs->ss;
+	}
+
+	regs_user->regs = regs_user_copy;
+}
 #endif /* CONFIG_X86_32 */
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 2480978b31cc..1313ae6b478b 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -28,7 +28,7 @@
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
-	((insn)->next_byte + sizeof(t) + n < (insn)->end_kaddr)
+	((insn)->next_byte + sizeof(t) + n <= (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
 	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 486e84ccb1f9..4f7a61ca4b39 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -79,11 +79,6 @@ struct perf_branch_stack {
 	struct perf_branch_entry	entries[0];
 };
 
-struct perf_regs {
-	__u64		abi;
-	struct pt_regs	*regs;
-};
-
 struct task_struct;
 
 /*
@@ -610,7 +605,14 @@ struct perf_sample_data {
 		u32	reserved;
 	}				cpu_entry;
 	struct perf_callchain_entry	*callchain;
+
+	/*
+	 * regs_user may point to task_pt_regs or to regs_user_copy, depending
+	 * on arch details.
+	 */
 	struct perf_regs		regs_user;
+	struct pt_regs			regs_user_copy;
+
 	struct perf_regs		regs_intr;
 	u64				stack_user_size;
 } ____cacheline_aligned;
diff --git a/include/linux/perf_regs.h b/include/linux/perf_regs.h
index 3c73d5fe18be..a5f98d53d732 100644
--- a/include/linux/perf_regs.h
+++ b/include/linux/perf_regs.h
@@ -1,11 +1,19 @@
 #ifndef _LINUX_PERF_REGS_H
 #define _LINUX_PERF_REGS_H
 
+struct perf_regs {
+	__u64		abi;
+	struct pt_regs	*regs;
+};
+
 #ifdef CONFIG_HAVE_PERF_REGS
 #include <asm/perf_regs.h>
 u64 perf_reg_value(struct pt_regs *regs, int idx);
 int perf_reg_validate(u64 mask);
 u64 perf_reg_abi(struct task_struct *task);
+void perf_get_regs_user(struct perf_regs *regs_user,
+			struct pt_regs *regs,
+			struct pt_regs *regs_user_copy);
 #else
 static inline u64 perf_reg_value(struct pt_regs *regs, int idx)
 {
@@ -21,5 +29,13 @@ static inline u64 perf_reg_abi(struct task_struct *task)
 {
 	return PERF_SAMPLE_REGS_ABI_NONE;
 }
+
+static inline void perf_get_regs_user(struct perf_regs *regs_user,
+				      struct pt_regs *regs,
+				      struct pt_regs *regs_user_copy)
+{
+	regs_user->regs = task_pt_regs(current);
+	regs_user->abi = perf_reg_abi(current);
+}
 #endif /* CONFIG_HAVE_PERF_REGS */
 #endif /* _LINUX_PERF_REGS_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4c1ee7f2bebc..882f835a0d85 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4461,18 +4461,14 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 }
 
 static void perf_sample_regs_user(struct perf_regs *regs_user,
-				  struct pt_regs *regs)
+				  struct pt_regs *regs,
+				  struct pt_regs *regs_user_copy)
 {
-	if (!user_mode(regs)) {
-		if (current->mm)
-			regs = task_pt_regs(current);
-		else
-			regs = NULL;
-	}
-
-	if (regs) {
-		regs_user->abi  = perf_reg_abi(current);
+	if (user_mode(regs)) {
+		regs_user->abi = perf_reg_abi(current);
 		regs_user->regs = regs;
+	} else if (current->mm) {
+		perf_get_regs_user(regs_user, regs, regs_user_copy);
 	} else {
 		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
 		regs_user->regs = NULL;
@@ -4951,7 +4947,8 @@ void perf_prepare_sample(struct perf_event_header *header,
 	}
 
 	if (sample_type & (PERF_SAMPLE_REGS_USER | PERF_SAMPLE_STACK_USER))
-		perf_sample_regs_user(&data->regs_user, regs);
+		perf_sample_regs_user(&data->regs_user, regs,
+				      &data->regs_user_copy);
 
 	if (sample_type & PERF_SAMPLE_REGS_USER) {
 		/* regs dump ABI info */
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e7417fe97a97..747f86103599 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -232,7 +232,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		if (nr_samples > 0) {
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists, NULL);
-			hists__output_resort(hists);
+			hists__output_resort(hists, NULL);
 
 			if (symbol_conf.event_group &&
 			    !perf_evsel__is_group_leader(pos))
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 1ce425d101a9..1fd96c13f199 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -545,6 +545,42 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 	return __hist_entry__cmp_compute(p_left, p_right, c);
 }
 
+static int64_t
+hist_entry__cmp_nop(struct hist_entry *left __maybe_unused,
+		    struct hist_entry *right __maybe_unused)
+{
+	return 0;
+}
+
+static int64_t
+hist_entry__cmp_baseline(struct hist_entry *left, struct hist_entry *right)
+{
+	if (sort_compute)
+		return 0;
+
+	if (left->stat.period == right->stat.period)
+		return 0;
+	return left->stat.period > right->stat.period ? 1 : -1;
+}
+
+static int64_t
+hist_entry__cmp_delta(struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute(right, left, COMPUTE_DELTA);
+}
+
+static int64_t
+hist_entry__cmp_ratio(struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute(right, left, COMPUTE_RATIO);
+}
+
+static int64_t
+hist_entry__cmp_wdiff(struct hist_entry *left, struct hist_entry *right)
+{
+	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF);
+}
+
 static void insert_hist_entry_by_compute(struct rb_root *root,
 					 struct hist_entry *he,
 					 int c)
@@ -605,7 +641,7 @@ static void hists__process(struct hists *hists)
 		hists__precompute(hists);
 		hists__compute_resort(hists);
 	} else {
-		hists__output_resort(hists);
+		hists__output_resort(hists, NULL);
 	}
 
 	hists__fprintf(hists, true, 0, 0, 0, stdout);
@@ -1038,27 +1074,35 @@ static void data__hpp_register(struct data__file *d, int idx)
 	fmt->header = hpp__header;
 	fmt->width  = hpp__width;
 	fmt->entry  = hpp__entry_global;
+	fmt->cmp    = hist_entry__cmp_nop;
+	fmt->collapse = hist_entry__cmp_nop;
 
 	/* TODO more colors */
 	switch (idx) {
 	case PERF_HPP_DIFF__BASELINE:
 		fmt->color = hpp__color_baseline;
+		fmt->sort  = hist_entry__cmp_baseline;
 		break;
 	case PERF_HPP_DIFF__DELTA:
 		fmt->color = hpp__color_delta;
+		fmt->sort  = hist_entry__cmp_delta;
 		break;
 	case PERF_HPP_DIFF__RATIO:
 		fmt->color = hpp__color_ratio;
+		fmt->sort  = hist_entry__cmp_ratio;
 		break;
 	case PERF_HPP_DIFF__WEIGHTED_DIFF:
 		fmt->color = hpp__color_wdiff;
+		fmt->sort  = hist_entry__cmp_wdiff;
 		break;
 	default:
+		fmt->sort  = hist_entry__cmp_nop;
 		break;
 	}
 
 	init_header(d, dfmt);
 	perf_hpp__column_register(fmt);
+	perf_hpp__register_sort_field(fmt);
 }
 
 static void ui_init(void)
diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e38f21..198f3c3aff95 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -19,7 +19,9 @@
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
-	const struct option list_options[] = {
+	bool raw_dump = false;
+	struct option list_options[] = {
+		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "Dump raw events"),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
@@ -27,11 +29,18 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		NULL
 	};
 
+	set_option_flag(list_options, 0, "raw-dump", PARSE_OPT_HIDDEN);
+
 	argc = parse_options(argc, argv, list_options, list_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	setup_pager();
 
+	if (raw_dump) {
+		print_events(NULL, true);
+		return 0;
+	}
+
 	if (argc == 0) {
 		print_events(NULL, false);
 		return 0;
@@ -53,8 +62,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
 			print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 39367609c707..072ae8ad67fc 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -457,6 +457,19 @@ static void report__collapse_hists(struct report *rep)
 	ui_progress__finish();
 }
 
+static void report__output_resort(struct report *rep)
+{
+	struct ui_progress prog;
+	struct perf_evsel *pos;
+
+	ui_progress__init(&prog, rep->nr_entries, "Sorting events for output...");
+
+	evlist__for_each(rep->session->evlist, pos)
+		hists__output_resort(evsel__hists(pos), &prog);
+
+	ui_progress__finish();
+}
+
 static int __cmd_report(struct report *rep)
 {
 	int ret;
@@ -505,13 +518,20 @@ static int __cmd_report(struct report *rep)
 	if (session_done())
 		return 0;
 
+	/*
+	 * recalculate number of entries after collapsing since it
+	 * might be changed during the collapse phase.
+	 */
+	rep->nr_entries = 0;
+	evlist__for_each(session->evlist, pos)
+		rep->nr_entries += evsel__hists(pos)->nr_entries;
+
 	if (rep->nr_entries == 0) {
 		ui__error("The %s file has no samples!\n", file->path);
 		return 0;
 	}
 
-	evlist__for_each(session->evlist, pos)
-		hists__output_resort(evsel__hists(pos));
+	report__output_resort(rep);
 
 	return report__browse_hists(rep);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0aa7747ff139..961cea183a83 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -285,7 +285,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
 	}
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	hists__output_recalc_col_len(hists, top->print_entries - printed);
 	putchar('\n');
@@ -554,7 +554,7 @@ static void perf_top__sort_new_samples(void *arg)
 	}
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 }
 
 static void *display_thread_tui(void *arg)
diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 614d5c4978ab..8d110dec393e 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -187,7 +187,7 @@ static int do_test(struct hists *hists, struct result *expected, size_t nr_expec
 	 * function since TEST_ASSERT_VAL() returns in case of failure.
 	 */
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("use callchain: %d, cumulate callchain: %d\n",
@@ -454,12 +454,12 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 	 *   30.00%    10.00%     perf  perf           [.] cmd_record
 	 *   20.00%     0.00%     bash  libc           [.] malloc
 	 *   10.00%    10.00%     bash  [kernel]       [k] page_fault
-	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
-	 *   10.00%     0.00%     perf  [kernel]       [k] sys_perf_event_open
+	 *   10.00%    10.00%     bash  bash           [.] xmalloc
 	 *   10.00%    10.00%     perf  [kernel]       [k] page_fault
-	 *   10.00%    10.00%     perf  libc           [.] free
 	 *   10.00%    10.00%     perf  libc           [.] malloc
-	 *   10.00%    10.00%     bash  bash           [.] xmalloc
+	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
+	 *   10.00%    10.00%     perf  libc           [.] free
+	 *   10.00%     0.00%     perf  [kernel]       [k] sys_perf_event_open
 	 */
 	struct result expected[] = {
 		{ 7000, 2000, "perf", "perf",     "main" },
@@ -468,12 +468,12 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 		{ 3000, 1000, "perf", "perf",     "cmd_record" },
 		{ 2000,    0, "bash", "libc",     "malloc" },
 		{ 1000, 1000, "bash", "[kernel]", "page_fault" },
-		{ 1000, 1000, "perf", "[kernel]", "schedule" },
-		{ 1000,    0, "perf", "[kernel]", "sys_perf_event_open" },
+		{ 1000, 1000, "bash", "bash",     "xmalloc" },
 		{ 1000, 1000, "perf", "[kernel]", "page_fault" },
+		{ 1000, 1000, "perf", "[kernel]", "schedule" },
 		{ 1000, 1000, "perf", "libc",     "free" },
 		{ 1000, 1000, "perf", "libc",     "malloc" },
-		{ 1000, 1000, "bash", "bash",     "xmalloc" },
+		{ 1000,    0, "perf", "[kernel]", "sys_perf_event_open" },
 	};
 
 	symbol_conf.use_callchain = false;
@@ -537,10 +537,13 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 	 *                  malloc
 	 *                  main
 	 *
-	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
+	 *   10.00%    10.00%     bash  bash           [.] xmalloc
 	 *              |
-	 *              --- schedule
-	 *                  run_command
+	 *              --- xmalloc
+	 *                  malloc
+	 *                  xmalloc     <--- NOTE: there's a cycle
+	 *                  malloc
+	 *                  xmalloc
 	 *                  main
 	 *
 	 *   10.00%     0.00%     perf  [kernel]       [k] sys_perf_event_open
@@ -556,6 +559,12 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 	 *                  run_command
 	 *                  main
 	 *
+	 *   10.00%    10.00%     perf  [kernel]       [k] schedule
+	 *              |
+	 *              --- schedule
+	 *                  run_command
+	 *                  main
+	 *
 	 *   10.00%    10.00%     perf  libc           [.] free
 	 *              |
 	 *              --- free
@@ -570,15 +579,6 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 	 *                  run_command
 	 *                  main
 	 *
-	 *   10.00%    10.00%     bash  bash           [.] xmalloc
-	 *              |
-	 *              --- xmalloc
-	 *                  malloc
-	 *                  xmalloc     <--- NOTE: there's a cycle
-	 *                  malloc
-	 *                  xmalloc
-	 *                  main
-	 *
 	 */
 	struct result expected[] = {
 		{ 7000, 2000, "perf", "perf",     "main" },
@@ -587,12 +587,12 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 		{ 3000, 1000, "perf", "perf",     "cmd_record" },
 		{ 2000,    0, "bash", "libc",     "malloc" },
 		{ 1000, 1000, "bash", "[kernel]", "page_fault" },
-		{ 1000, 1000, "perf", "[kernel]", "schedule" },
+		{ 1000, 1000, "bash", "bash",     "xmalloc" },
 		{ 1000,    0, "perf", "[kernel]", "sys_perf_event_open" },
 		{ 1000, 1000, "perf", "[kernel]", "page_fault" },
+		{ 1000, 1000, "perf", "[kernel]", "schedule" },
 		{ 1000, 1000, "perf", "libc",     "free" },
 		{ 1000, 1000, "perf", "libc",     "malloc" },
-		{ 1000, 1000, "bash", "bash",     "xmalloc" },
 	};
 	struct callchain_result expected_callchain[] = {
 		{
@@ -622,9 +622,12 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 				{ "bash",     "main" }, },
 		},
 		{
-			3, {	{ "[kernel]", "schedule" },
-				{ "perf",     "run_command" },
-				{ "perf",     "main" }, },
+			6, {	{ "bash",     "xmalloc" },
+				{ "libc",     "malloc" },
+				{ "bash",     "xmalloc" },
+				{ "libc",     "malloc" },
+				{ "bash",     "xmalloc" },
+				{ "bash",     "main" }, },
 		},
 		{
 			3, {	{ "[kernel]", "sys_perf_event_open" },
@@ -638,6 +641,11 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 				{ "perf",     "main" }, },
 		},
 		{
+			3, {	{ "[kernel]", "schedule" },
+				{ "perf",     "run_command" },
+				{ "perf",     "main" }, },
+		},
+		{
 			4, {	{ "libc",     "free" },
 				{ "perf",     "cmd_record" },
 				{ "perf",     "run_command" },
@@ -649,14 +657,6 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 				{ "perf",     "run_command" },
 				{ "perf",     "main" }, },
 		},
-		{
-			6, {	{ "bash",     "xmalloc" },
-				{ "libc",     "malloc" },
-				{ "bash",     "xmalloc" },
-				{ "libc",     "malloc" },
-				{ "bash",     "xmalloc" },
-				{ "bash",     "main" }, },
-		},
 	};
 
 	symbol_conf.use_callchain = true;
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 74f257a81265..59e53db7914c 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -138,7 +138,7 @@ int test__hists_filter(void)
 		struct hists *hists = evsel__hists(evsel);
 
 		hists__collapse_resort(hists, NULL);
-		hists__output_resort(hists);
+		hists__output_resort(hists, NULL);
 
 		if (verbose > 2) {
 			pr_info("Normal histogram\n");
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index a748f2be1222..f5547610da02 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -152,7 +152,7 @@ static int test1(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
@@ -252,7 +252,7 @@ static int test2(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
@@ -306,7 +306,7 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
@@ -384,7 +384,7 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
@@ -487,7 +487,7 @@ static int test5(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index e6bb04b5b09b..788506eef567 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -550,7 +550,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	bool need_percent;
 
 	node = rb_first(root);
-	need_percent = !!rb_next(node);
+	need_percent = node && rb_next(node);
 
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index dc0d095f318c..482adae3cc44 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -204,6 +204,9 @@ static int __hpp__sort_acc(struct hist_entry *a, struct hist_entry *b,
 		if (ret)
 			return ret;
 
+		if (a->thread != b->thread || !symbol_conf.use_callchain)
+			return 0;
+
 		ret = b->callchain->max_depth - a->callchain->max_depth;
 	}
 	return ret;
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 2f612562978c..3c38f25b1695 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -1,5 +1,8 @@
 #include <signal.h>
 #include <stdbool.h>
+#ifdef HAVE_BACKTRACE_SUPPORT
+#include <execinfo.h>
+#endif
 
 #include "../../util/cache.h"
 #include "../../util/debug.h"
@@ -88,6 +91,25 @@ int ui__getch(int delay_secs)
 	return SLkp_getkey();
 }
 
+#ifdef HAVE_BACKTRACE_SUPPORT
+static void ui__signal_backtrace(int sig)
+{
+	void *stackdump[32];
+	size_t size;
+
+	ui__exit(false);
+	psignal(sig, "perf");
+
+	printf("-------- backtrace --------\n");
+	size = backtrace(stackdump, ARRAY_SIZE(stackdump));
+	backtrace_symbols_fd(stackdump, size, STDOUT_FILENO);
+
+	exit(0);
+}
+#else
+# define ui__signal_backtrace  ui__signal
+#endif
+
 static void ui__signal(int sig)
 {
 	ui__exit(false);
@@ -122,8 +144,8 @@ int ui__init(void)
 	ui_browser__init();
 	tui_progress__init();
 
-	signal(SIGSEGV, ui__signal);
-	signal(SIGFPE, ui__signal);
+	signal(SIGSEGV, ui__signal_backtrace);
+	signal(SIGFPE, ui__signal_backtrace);
 	signal(SIGINT, ui__signal);
 	signal(SIGQUIT, ui__signal);
 	signal(SIGTERM, ui__signal);
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 64b377e591e4..14e7a123d43b 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -841,3 +841,33 @@ char *callchain_list__sym_name(struct callchain_list *cl,
 
 	return bf;
 }
+
+static void free_callchain_node(struct callchain_node *node)
+{
+	struct callchain_list *list, *tmp;
+	struct callchain_node *child;
+	struct rb_node *n;
+
+	list_for_each_entry_safe(list, tmp, &node->val, list) {
+		list_del(&list->list);
+		free(list);
+	}
+
+	n = rb_first(&node->rb_root_in);
+	while (n) {
+		child = container_of(n, struct callchain_node, rb_node_in);
+		n = rb_next(n);
+		rb_erase(&child->rb_node_in, &node->rb_root_in);
+
+		free_callchain_node(child);
+		free(child);
+	}
+}
+
+void free_callchain(struct callchain_root *root)
+{
+	if (!symbol_conf.use_callchain)
+		return;
+
+	free_callchain_node(&root->node);
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index dbc08cf5f970..c0ec1acc38e4 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -198,4 +198,6 @@ static inline int arch_skip_callchain_idx(struct thread *thread __maybe_unused,
 char *callchain_list__sym_name(struct callchain_list *cl,
 			       char *bf, size_t bfsize, bool show_dso);
 
+void free_callchain(struct callchain_root *root);
+
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6e88b9e395df..182395546ddc 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -6,6 +6,7 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "annotate.h"
+#include "ui/progress.h"
 #include <math.h>
 
 static bool hists__filter_entry_by_dso(struct hists *hists,
@@ -303,7 +304,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template,
 	size_t callchain_size = 0;
 	struct hist_entry *he;
 
-	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain)
+	if (symbol_conf.use_callchain)
 		callchain_size = sizeof(struct callchain_root);
 
 	he = zalloc(sizeof(*he) + callchain_size);
@@ -736,7 +737,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
-	callchain_append(he->callchain, &callchain_cursor, sample->period);
+	hist_entry__append_callchain(he, sample);
 
 	/*
 	 * We need to re-initialize the cursor since callchain_append()
@@ -809,7 +810,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
-	callchain_append(he->callchain, &cursor, sample->period);
+	if (symbol_conf.use_callchain)
+		callchain_append(he->callchain, &cursor, sample->period);
 	return 0;
 }
 
@@ -945,6 +947,7 @@ void hist_entry__free(struct hist_entry *he)
 	zfree(&he->mem_info);
 	zfree(&he->stat_acc);
 	free_srcline(he->srcline);
+	free_callchain(he->callchain);
 	free(he);
 }
 
@@ -987,6 +990,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		else
 			p = &(*p)->rb_right;
 	}
+	hists->nr_entries++;
 
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, root);
@@ -1024,7 +1028,10 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 	if (!sort__need_collapse)
 		return;
 
+	hists->nr_entries = 0;
+
 	root = hists__get_rotate_entries_in(hists);
+
 	next = rb_first(root);
 
 	while (next) {
@@ -1119,7 +1126,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
-void hists__output_resort(struct hists *hists)
+void hists__output_resort(struct hists *hists, struct ui_progress *prog)
 {
 	struct rb_root *root;
 	struct rb_node *next;
@@ -1148,6 +1155,9 @@ void hists__output_resort(struct hists *hists)
 
 		if (!n->filtered)
 			hists__calc_col_len(hists, n);
+
+		if (prog)
+			ui_progress__update(prog, 1);
 	}
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d0ef9a19a744..46bd50344f85 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -121,7 +121,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 			      struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
-void hists__output_resort(struct hists *hists);
+void hists__output_resort(struct hists *hists, struct ui_progress *prog);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 28eb1417cb2a..7f9b8632e433 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -495,9 +495,11 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	if (ntevs == 0)	{	/* No error but failed to find probe point. */
-		pr_warning("Probe point '%s' not found.\n",
+		pr_warning("Probe point '%s' not found in debuginfo.\n",
 			   synthesize_perf_probe_point(&pev->point));
-		return -ENOENT;
+		if (need_dwarf)
+			return -ENOENT;
+		return 0;
 	}
 	/* Error path : ntevs < 0 */
 	pr_debug("An error occurred in debuginfo analysis (%d).\n", ntevs);
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c7918f83b300..b5247d777f0e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -989,8 +989,24 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
 	int ret = 0;
 
 #if _ELFUTILS_PREREQ(0, 142)
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+
 	/* Get the call frame information from this dwarf */
-	pf->cfi = dwarf_getcfi_elf(dwarf_getelf(dbg->dbg));
+	elf = dwarf_getelf(dbg->dbg);
+	if (elf == NULL)
+		return -EINVAL;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		return -EINVAL;
+
+	if (elf_section_by_name(elf, &ehdr, &shdr, ".eh_frame", NULL) &&
+	    shdr.sh_type == SHT_PROGBITS) {
+		pf->cfi = dwarf_getcfi_elf(elf);
+	} else {
+		pf->cfi = dwarf_getcfi(dbg->dbg);
+	}
 #endif
 
 	off = 0;
