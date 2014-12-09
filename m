Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaLILAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:00:09 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43917 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbaLIK76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:59:58 -0500
Date: Tue, 9 Dec 2014 11:59:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events tree changes for v3.19
Message-ID: <20141209105950.GA20601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

   # HEAD: cfa0bd52d0ba9b852f76c7b3f1055edd5e5c7846 Merge tag 'perf-core-for-mingo-2' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core

On the kernel side there's few changes, the one that stands out 
is PEBS machine state sampling support on x86, by Stephane 
Eranian.

On the tooling side:

    User visible tooling changes:

      - Don't open the DWARF info multiple times, keeping instead a dwfl handle
        in struct dso, greatly speeding up 'perf report' on powerpc. (Sukadev Bhattiprolu)

      - Introduce PARSE_OPT_DISABLED option flag and use it to avoid showing
        undersired options in tools that provides frontends to 'perf record', like
        sched, kvm, etc (Namhyung Kim)

      - Fallback to kallsyms when using the minimal 'ELF' loader (Arnaldo Carvalho de Melo)

      - Fix annotation with kcore (Adrian Hunter)

      - Support source line numbers in annotate using a hotkey (Andi Kleen)

      - Callchain improvements including:
        * Enable printing the srcline in the history
        * Make get_srcline fall back to sym+offset (Andi Kleen)

      - TUI hist_entry browser fixes, including showing missing overhead
        value for first level callchain. Detected comparing the output of
        --stdio/--gui (that matched) with --tui, that had this problem. (Namhyung Kim)

      - Support handling complete branch stacks as histograms (Andi Kleen)

    Tooling infrastructure changes:

      - Prep work for supporting per-pkg and snapshot counters in 'perf stat' (Jiri Olsa)

      - 'perf stat' refactorings, moving stuff from it to evsel.c to use in
        per-pkg/snapshot format changes (Jiri Olsa)

      - Add per-pkg format file parsing (Matt Fleming)

      - Clean up libelf feature support code (Namhyung Kim)

      - Add gzip decompression support for kernel modules (Namhyung Kim)

      - More prep patches for Intel PT, including a a thread stack and
        more stuff made available via the database export mechanism (Adrian Hunter)

      - More Intel PT work, including a facility to export sample data (comms,
        threads, symbol names, etc) in a database friendly way, with an script to use
        this to create a postgresql database. (Adrian Hunter)

      - Make sure that thread->mg->machine points to the machine where
        the thread exists (it was being set only for the kmaps kernel modules
        case, do it as well for the mmaps) and use it to shorten function
        signatures (Arnaldo Carvalho de Melo)

... and lots of other fixes and smaller improvements.

 Thanks,

	Ingo

------------------>
Adrian Hunter (20):
      perf pmu: Let pmu's with no events show up on perf list
      perf tools: Build programs to copy 32-bit compatibility
      perf tools: Add support for 32-bit compatibility VDSOs
      perf tools: Do not attempt to run perf-read-vdso32 if it wasn't built
      perf tools: Add facility to export data in database-friendly way
      perf scripting python: Extend interface to export data in a database-friendly way
      perf script: Add Python script to export to postgresql
      perf tools: Add id index
      perf session: Add perf_session__deliver_synth_event()
      perf tools: Add a thread stack for synthesizing call chains
      perf tools: Enhance the thread stack to output call/return data
      perf tools: Add branch type to db export
      perf tools: Add branch_type and in_tx to Python export
      perf tools: Add call information to the database export API
      perf tools: Add call information to Python export
      perf tools: Defer export of comms that were not 'set'
      perf tools: Fix annotation with kcore
      perf evlist: Do not poll events that use the system_wide flag
      perf tools: Add perf-read-vdso32 and perf-read-vdsox32 to .gitignore
      perf tools: Only override the default :tid comm entry

Andi Kleen (15):
      perf/x86/intel/uncore: Add scaling units to the EP iMC events
      perf/x86: Add INTEL_FLAGS_UEVENT_CONSTRAINT
      perf/x86/intel: Use INTEL_FLAGS_UEVENT_CONSTRAINT for PRECDIST
      perf/x86/intel: Disallow flags for most Core2/Atom/Nehalem/Westmere events
      perf callchain: Factor out adding new call chain entries
      perf callchain: Use al.addr to set up call chain
      perf callchain: Use a common function to resolve symbol or name
      perf tools: Only print base source file for srcline
      perf annotate: Support source line numbers in annotate
      perf callchain: Enable printing the srcline in the history
      perf callchain: Make get_srcline fall back to sym+offset
      perf tools: Allow to force redirect pr_debug to stderr.
      perf callchain: Support handling complete branch stacks as histograms
      perf report: Add --branch-history option
      perf report: In branch stack mode use address history sorting

Aravind Gopalakrishnan (1):
      perf/x86/amd/ibs: Update IBS MSRs and feature definitions

Arnaldo Carvalho de Melo (11):
      perf tools: Set thread->mg.machine in all places
      perf tools: A thread's machine can be found via thread->mg->machine
      perf thread: Adopt resolve_callchain method from machine
      perf callchains: Use thread->mg->machine
      perf tests: Remove misplaced __maybe_unused
      perf tests: Use thread->mg->machine
      perf pmu: Add proper error handling to print_pmu_events()
      perf tools: Use evlist__for_each in a few remaining places
      perf symbols: Fallback to kallsyms when using the minimal 'ELF' loader
      perf hists: Fix up srcline histogram key formatting
      perf symbols: Move bfd_demangle stubbing to its only user

Jiri Olsa (15):
      perf tools: Add test_and_set_bit function
      perf script perl: Removing event cache as it's no longer needed
      perf script python: Removing event cache as it's no longer needed
      perf evsel: Do not call pevent_free_format when deleting tracepoint
      perf evsel: Fix ftrace:function event recording
      perf evsel: Introduce perf_evsel__compute_deltas function
      perf evsel: Introduce perf_counts_values__scale function
      perf evsel: Introduce perf_evsel__read_cb function
      perf tools: Add snapshot format file parsing
      perf stat: Use perf_evsel__read_cb in read_counter
      perf stat: Make read_counter work over the thread dimension
      perf stat: Use read_counter in read_counter_aggr
      perf tools: Remove perf_evsel__read interface
      perf stat: Add support for per-pkg counters
      perf stat: Add support for snapshot counters

Kan Liang (1):
      perf diff: Add missing handler for PERF_RECORD_MMAP2 events

Masami Hiramatsu (1):
      perf probe: Add --quiet option to suppress output result message

Matt Fleming (1):
      perf tools: Add per-pkg format file parsing

Namhyung Kim (17):
      perf tools: Add PARSE_OPT_DISABLED flag
      perf tools: Export usage string and option table of perf record
      perf kvm: Print kvm specific --help output
      perf tools: Add support for exclusive option
      perf probe: Use PARSE_OPT_EXCLUSIVE flag
      perf symbols: Preparation for compressed kernel module support
      perf tools: Add gzip decompression support for kernel module
      perf build-id: Rename dsos__write_buildid_table()
      perf build-id: Move build-id related functions to util/build-id.c
      perf record: Do not save pathname in ./debug/.build-id directory for vmlinux
      perf tools: Fix build-id matching on vmlinux
      perf tools: Make vmlinux short name more like kallsyms short name
      perf build-id: Move disable_buildid_cache() to util/build-id.c
      perf tools: Clean up libelf feature support code
      perf hists browser: Print overhead percent value for first-level callchain
      perf tools: Collapse first level callchain entry if it has sibling
      perf tools: Fix segfault due to invalid kernel dso access

Peter Zijlstra (1):
      perf: Improve the perf_sample_data struct layout

Stephane Eranian (5):
      perf: Add ability to sample machine state on interrupt
      perf/x86: Add support for sampling PEBS machine state registers
      perf tools: Add core support for sampling intr machine state regs
      perf/tests: Add interrupted state sample parsing test
      perf record: Add new -I option to sample interrupted machine state

Sukadev Bhattiprolu (1):
      perf tools powerpc: Cache the DWARF debug info

WANG Chao (1):
      perf test: fix typo in python test

Wang Nan (1):
      perf tools: Ensure return negative value when write header error


 arch/x86/include/asm/perf_event.h                  |   3 +
 arch/x86/include/uapi/asm/msr-index.h              |   1 +
 arch/x86/kernel/cpu/perf_event.h                   |   4 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |  15 +
 arch/x86/kernel/cpu/perf_event_intel_ds.c          |  81 ++-
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c |   8 +
 include/linux/perf_event.h                         |  37 +-
 include/uapi/linux/perf_event.h                    |  15 +-
 kernel/events/core.c                               |  60 +-
 tools/perf/.gitignore                              |   2 +
 tools/perf/Documentation/perf-record.txt           |   6 +
 tools/perf/Documentation/perf-report.txt           |  12 +-
 tools/perf/Makefile.perf                           |  51 +-
 tools/perf/arch/powerpc/util/skip-callchain-idx.c  |  38 +-
 tools/perf/builtin-diff.c                          |   1 +
 tools/perf/builtin-inject.c                        |   4 +-
 tools/perf/builtin-kvm.c                           |  25 +
 tools/perf/builtin-probe.c                         |  65 +-
 tools/perf/builtin-record.c                        |  20 +-
 tools/perf/builtin-report.c                        |  31 +-
 tools/perf/builtin-script.c                        |   8 +-
 tools/perf/builtin-stat.c                          | 105 ++-
 tools/perf/builtin-timechart.c                     |   9 +-
 tools/perf/builtin-trace.c                         |   6 +-
 tools/perf/config/Makefile                         |  49 +-
 tools/perf/config/Makefile.arch                    |   8 +
 tools/perf/config/feature-checks/Makefile          |  16 +-
 tools/perf/config/feature-checks/test-all.c        |   5 +
 tools/perf/config/feature-checks/test-compile.c    |   4 +
 tools/perf/config/feature-checks/test-zlib.c       |   9 +
 tools/perf/perf-read-vdso.c                        |  34 +
 tools/perf/perf.h                                  |   4 +
 .../scripts/python/bin/export-to-postgresql-record |   8 +
 .../scripts/python/bin/export-to-postgresql-report |  29 +
 tools/perf/scripts/python/export-to-postgresql.py  | 444 ++++++++++++
 tools/perf/tests/builtin-test.c                    |   2 +-
 tools/perf/tests/code-reading.c                    |  13 +-
 tools/perf/tests/dwarf-unwind.c                    |  18 +-
 tools/perf/tests/hists_filter.c                    |   2 +-
 tools/perf/tests/mmap-thread-lookup.c              |   2 +-
 tools/perf/tests/sample-parsing.c                  |  55 +-
 tools/perf/ui/browsers/annotate.c                  |  13 +-
 tools/perf/ui/browsers/hists.c                     |  42 +-
 tools/perf/ui/gtk/hists.c                          |  11 +-
 tools/perf/ui/stdio/hist.c                         |  23 +-
 tools/perf/util/annotate.c                         |  34 +-
 tools/perf/util/annotate.h                         |   1 +
 tools/perf/util/build-id.c                         | 348 +++++++++-
 tools/perf/util/build-id.h                         |  12 +
 tools/perf/util/callchain.c                        |  37 +-
 tools/perf/util/callchain.h                        |  11 +-
 tools/perf/util/comm.h                             |   4 +
 tools/perf/util/db-export.c                        | 428 ++++++++++++
 tools/perf/util/db-export.h                        | 107 +++
 tools/perf/util/debug.c                            |   4 +-
 tools/perf/util/dso.c                              |  71 ++
 tools/perf/util/dso.h                              |  13 +
 tools/perf/util/event.c                            |  20 +-
 tools/perf/util/event.h                            |  43 +-
 tools/perf/util/evlist.c                           |  38 +-
 tools/perf/util/evsel.c                            | 156 +++--
 tools/perf/util/evsel.h                            |  50 +-
 tools/perf/util/find-vdso-map.c                    |  30 +
 tools/perf/util/header.c                           | 361 +---------
 tools/perf/util/header.h                           |   8 +-
 tools/perf/util/include/linux/bitmap.h             |  17 +
 tools/perf/util/include/linux/bitops.h             |   2 +
 tools/perf/util/machine.c                          | 264 ++++++--
 tools/perf/util/machine.h                          |  17 +-
 tools/perf/util/map.c                              |  10 +-
 tools/perf/util/map.h                              |   4 +-
 tools/perf/util/parse-events.c                     |   2 +
 tools/perf/util/parse-options.c                    |  78 ++-
 tools/perf/util/parse-options.h                    |   4 +
 tools/perf/util/pmu.c                              | 115 +++-
 tools/perf/util/pmu.h                              |   5 +
 tools/perf/util/probe-event.c                      |  18 +-
 .../perf/util/scripting-engines/trace-event-perl.c |  29 +-
 .../util/scripting-engines/trace-event-python.c    | 440 +++++++++++-
 tools/perf/util/session.c                          | 185 ++++-
 tools/perf/util/session.h                          |  15 +
 tools/perf/util/sort.c                             |   8 +-
 tools/perf/util/srcline.c                          |  17 +-
 tools/perf/util/symbol-elf.c                       |  56 +-
 tools/perf/util/symbol-minimal.c                   |   1 -
 tools/perf/util/symbol.c                           |  19 +-
 tools/perf/util/symbol.h                           |  25 +-
 tools/perf/util/thread-stack.c                     | 747 +++++++++++++++++++++
 tools/perf/util/thread-stack.h                     | 111 +++
 tools/perf/util/thread.c                           |  14 +-
 tools/perf/util/thread.h                           |   9 +-
 tools/perf/util/tool.h                             |   3 +-
 tools/perf/util/unwind-libdw.c                     |   8 +-
 tools/perf/util/unwind-libunwind.c                 |  17 +-
 tools/perf/util/unwind.h                           |   2 -
 tools/perf/util/util.h                             |  10 +-
 tools/perf/util/vdso.c                             | 217 +++++-
 tools/perf/util/vdso.h                             |   4 +-
 tools/perf/util/zlib.c                             |  78 +++
 99 files changed, 4723 insertions(+), 1002 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-compile.c
 create mode 100644 tools/perf/config/feature-checks/test-zlib.c
 create mode 100644 tools/perf/perf-read-vdso.c
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-record
 create mode 100644 tools/perf/scripts/python/bin/export-to-postgresql-report
 create mode 100644 tools/perf/scripts/python/export-to-postgresql.py
 create mode 100644 tools/perf/util/db-export.c
 create mode 100644 tools/perf/util/db-export.h
 create mode 100644 tools/perf/util/find-vdso-map.c
 create mode 100644 tools/perf/util/thread-stack.c
 create mode 100644 tools/perf/util/thread-stack.h
 create mode 100644 tools/perf/util/zlib.c

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8dfc9fd094a3..dc0f6ed35b08 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -177,6 +177,9 @@ struct x86_pmu_capability {
 #define IBS_CAPS_BRNTRGT		(1U<<5)
 #define IBS_CAPS_OPCNTEXT		(1U<<6)
 #define IBS_CAPS_RIPINVALIDCHK		(1U<<7)
+#define IBS_CAPS_OPBRNFUSE		(1U<<8)
+#define IBS_CAPS_FETCHCTLEXTD		(1U<<9)
+#define IBS_CAPS_OPDATA4		(1U<<10)
 
 #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
 					 | IBS_CAPS_FETCHSAM	\
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index e21331ce368f..8f02f6990759 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -206,6 +206,7 @@
 #define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
+#define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
 
 /* Fam 16h MSRs */
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fc5eb390b368..4e6cdb0ddc70 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -253,6 +253,10 @@ struct cpu_hw_events {
 #define INTEL_UEVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
 
+/* Like UEVENT_CONSTRAINT, but match flags too */
+#define INTEL_FLAGS_UEVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS)
+
 #define INTEL_PLD_CONSTRAINT(c, n)	\
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index cbb1be3ed9e4..a61f5c6911da 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -565,6 +565,21 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 				       perf_ibs->offset_max,
 				       offset + 1);
 	} while (offset < offset_max);
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+		/*
+		 * Read IbsBrTarget and IbsOpData4 separately
+		 * depending on their availability.
+		 * Can't add to offset_max as they are staggered
+		 */
+		if (ibs_caps & IBS_CAPS_BRNTRGT) {
+			rdmsrl(MSR_AMD64_IBSBRTARGET, *buf++);
+			size++;
+		}
+		if (ibs_caps & IBS_CAPS_OPDATA4) {
+			rdmsrl(MSR_AMD64_IBSOPDATA4, *buf++);
+			size++;
+		}
+	}
 	ibs_data.size = sizeof(u64) * size;
 
 	regs = *iregs;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 46211bcc813e..495ae9793628 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -552,18 +552,18 @@ int intel_pmu_drain_bts_buffer(void)
  * PEBS
  */
 struct event_constraint intel_core2_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
-	INTEL_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_atom_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
-	INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x00c0, 0x1), /* INST_RETIRED.ANY */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x00c5, 0x1), /* MISPREDICTED_BRANCH_RETIRED */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
 	EVENT_CONSTRAINT_END
 };
 
@@ -577,36 +577,36 @@ struct event_constraint intel_slm_pebs_event_constraints[] = {
 
 struct event_constraint intel_nehalem_pebs_event_constraints[] = {
 	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INST_RETIRED.ANY */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc0, 0xf),    /* INST_RETIRED.ANY */
 	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x02c5, 0xf), /* BR_MISP_RETIRED.NEAR_CALL */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_westmere_pebs_event_constraints[] = {
 	INTEL_PLD_CONSTRAINT(0x100b, 0xf),      /* MEM_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
-	INTEL_EVENT_CONSTRAINT(0xc0, 0xf),    /* INSTR_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x0f, 0xf),    /* MEM_UNCORE_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x010c, 0xf), /* MEM_STORE_RETIRED.DTLB_MISS */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc0, 0xf),    /* INSTR_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
-	INTEL_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
-	INTEL_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
-	INTEL_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xc7, 0xf),    /* SSEX_UOPS_RETIRED.* */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x20c8, 0xf), /* ITLB_MISS_RETIRED */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xcb, 0xf),    /* MEM_LOAD_RETIRED.* */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0xf7, 0xf),    /* FP_ASSIST.* */
 	EVENT_CONSTRAINT_END
 };
 
 struct event_constraint intel_snb_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
@@ -617,7 +617,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_ivb_pebs_event_constraints[] = {
-        INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+        INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
         INTEL_PLD_CONSTRAINT(0x01cd, 0x8),    /* MEM_TRANS_RETIRED.LAT_ABOVE_THR */
 	INTEL_PST_CONSTRAINT(0x02cd, 0x8),    /* MEM_TRANS_RETIRED.PRECISE_STORES */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
@@ -628,7 +628,7 @@ struct event_constraint intel_ivb_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_hsw_pebs_event_constraints[] = {
-	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
+	INTEL_FLAGS_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
 	INTEL_PLD_CONSTRAINT(0x01cd, 0xf),    /* MEM_TRANS_RETIRED.* */
 	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
 	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
@@ -886,6 +886,29 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR) {
+		regs.ax = pebs->ax;
+		regs.bx = pebs->bx;
+		regs.cx = pebs->cx;
+		regs.dx = pebs->dx;
+		regs.si = pebs->si;
+		regs.di = pebs->di;
+		regs.bp = pebs->bp;
+		regs.sp = pebs->sp;
+
+		regs.flags = pebs->flags;
+#ifndef CONFIG_X86_32
+		regs.r8 = pebs->r8;
+		regs.r9 = pebs->r9;
+		regs.r10 = pebs->r10;
+		regs.r11 = pebs->r11;
+		regs.r12 = pebs->r12;
+		regs.r13 = pebs->r13;
+		regs.r14 = pebs->r14;
+		regs.r15 = pebs->r15;
+#endif
+	}
+
 	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
 		regs.ip = pebs->real_ip;
 		regs.flags |= PERF_EFLAGS_EXACT;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index f9ed429d6e4f..745b158e9a65 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -449,7 +449,11 @@ static struct attribute *snbep_uncore_qpi_formats_attr[] = {
 static struct uncore_event_desc snbep_uncore_imc_events[] = {
 	INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0xff,umask=0x00"),
 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read.unit, "MiB"),
 	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write.unit, "MiB"),
 	{ /* end: all zeroes */ },
 };
 
@@ -2036,7 +2040,11 @@ static struct intel_uncore_type hswep_uncore_ha = {
 static struct uncore_event_desc hswep_uncore_imc_events[] = {
 	INTEL_UNCORE_EVENT_DESC(clockticks,      "event=0x00,umask=0x00"),
 	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_read.unit, "MiB"),
 	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write.scale, "6.103515625e-5"),
+	INTEL_UNCORE_EVENT_DESC(cas_count_write.unit, "MiB"),
 	{ /* end: all zeroes */ },
 };
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 893a0d07986f..486e84ccb1f9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -79,7 +79,7 @@ struct perf_branch_stack {
 	struct perf_branch_entry	entries[0];
 };
 
-struct perf_regs_user {
+struct perf_regs {
 	__u64		abi;
 	struct pt_regs	*regs;
 };
@@ -580,34 +580,40 @@ extern u64 perf_event_read_value(struct perf_event *event,
 
 
 struct perf_sample_data {
-	u64				type;
+	/*
+	 * Fields set by perf_sample_data_init(), group so as to
+	 * minimize the cachelines touched.
+	 */
+	u64				addr;
+	struct perf_raw_record		*raw;
+	struct perf_branch_stack	*br_stack;
+	u64				period;
+	u64				weight;
+	u64				txn;
+	union  perf_mem_data_src	data_src;
 
+	/*
+	 * The other fields, optionally {set,used} by
+	 * perf_{prepare,output}_sample().
+	 */
+	u64				type;
 	u64				ip;
 	struct {
 		u32	pid;
 		u32	tid;
 	}				tid_entry;
 	u64				time;
-	u64				addr;
 	u64				id;
 	u64				stream_id;
 	struct {
 		u32	cpu;
 		u32	reserved;
 	}				cpu_entry;
-	u64				period;
-	union  perf_mem_data_src	data_src;
 	struct perf_callchain_entry	*callchain;
-	struct perf_raw_record		*raw;
-	struct perf_branch_stack	*br_stack;
-	struct perf_regs_user		regs_user;
+	struct perf_regs		regs_user;
+	struct perf_regs		regs_intr;
 	u64				stack_user_size;
-	u64				weight;
-	/*
-	 * Transaction flags for abort events:
-	 */
-	u64				txn;
-};
+} ____cacheline_aligned;
 
 /* default value for data source */
 #define PERF_MEM_NA (PERF_MEM_S(OP, NA)   |\
@@ -624,9 +630,6 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->raw  = NULL;
 	data->br_stack = NULL;
 	data->period = period;
-	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
-	data->regs_user.regs = NULL;
-	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = PERF_MEM_NA;
 	data->txn = 0;
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9d845404d875..9b79abbd1ab8 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -137,8 +137,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 	PERF_SAMPLE_TRANSACTION			= 1U << 17,
+	PERF_SAMPLE_REGS_INTR			= 1U << 18,
 
-	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
 };
 
 /*
@@ -238,6 +239,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
+#define PERF_ATTR_SIZE_VER4	104	/* add: sample_regs_intr */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -334,6 +336,15 @@ struct perf_event_attr {
 
 	/* Align to u64. */
 	__u32	__reserved_2;
+	/*
+	 * Defines set of regs to dump for each sample
+	 * state captured on:
+	 *  - precise = 0: PMU interrupt
+	 *  - precise > 0: sampled instruction
+	 *
+	 * See asm/perf_regs.h for details.
+	 */
+	__u64	sample_regs_intr;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -686,6 +697,8 @@ enum perf_event_type {
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+	 *	{ u64			abi; # enum perf_sample_regs_abi
+	 *	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_INTR
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cd5eef1fcdd..3e19d3ebc29c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4460,7 +4460,7 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 	}
 }
 
-static void perf_sample_regs_user(struct perf_regs_user *regs_user,
+static void perf_sample_regs_user(struct perf_regs *regs_user,
 				  struct pt_regs *regs)
 {
 	if (!user_mode(regs)) {
@@ -4471,11 +4471,22 @@ static void perf_sample_regs_user(struct perf_regs_user *regs_user,
 	}
 
 	if (regs) {
-		regs_user->regs = regs;
 		regs_user->abi  = perf_reg_abi(current);
+		regs_user->regs = regs;
+	} else {
+		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
+		regs_user->regs = NULL;
 	}
 }
 
+static void perf_sample_regs_intr(struct perf_regs *regs_intr,
+				  struct pt_regs *regs)
+{
+	regs_intr->regs = regs;
+	regs_intr->abi  = perf_reg_abi(current);
+}
+
+
 /*
  * Get remaining task size from user stack pointer.
  *
@@ -4857,6 +4868,23 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_TRANSACTION)
 		perf_output_put(handle, data->txn);
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR) {
+		u64 abi = data->regs_intr.abi;
+		/*
+		 * If there are no regs to dump, notice it through
+		 * first u64 being zero (PERF_SAMPLE_REGS_ABI_NONE).
+		 */
+		perf_output_put(handle, abi);
+
+		if (abi) {
+			u64 mask = event->attr.sample_regs_intr;
+
+			perf_output_sample_regs(handle,
+						data->regs_intr.regs,
+						mask);
+		}
+	}
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
@@ -4922,12 +4950,13 @@ void perf_prepare_sample(struct perf_event_header *header,
 		header->size += size;
 	}
 
+	if (sample_type & (PERF_SAMPLE_REGS_USER | PERF_SAMPLE_STACK_USER))
+		perf_sample_regs_user(&data->regs_user, regs);
+
 	if (sample_type & PERF_SAMPLE_REGS_USER) {
 		/* regs dump ABI info */
 		int size = sizeof(u64);
 
-		perf_sample_regs_user(&data->regs_user, regs);
-
 		if (data->regs_user.regs) {
 			u64 mask = event->attr.sample_regs_user;
 			size += hweight64(mask) * sizeof(u64);
@@ -4943,15 +4972,11 @@ void perf_prepare_sample(struct perf_event_header *header,
 		 * in case new sample type is added, because we could eat
 		 * up the rest of the sample size.
 		 */
-		struct perf_regs_user *uregs = &data->regs_user;
 		u16 stack_size = event->attr.sample_stack_user;
 		u16 size = sizeof(u64);
 
-		if (!uregs->abi)
-			perf_sample_regs_user(uregs, regs);
-
 		stack_size = perf_sample_ustack_size(stack_size, header->size,
-						     uregs->regs);
+						     data->regs_user.regs);
 
 		/*
 		 * If there is something to dump, add space for the dump
@@ -4964,6 +4989,21 @@ void perf_prepare_sample(struct perf_event_header *header,
 		data->stack_user_size = stack_size;
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_REGS_INTR) {
+		/* regs dump ABI info */
+		int size = sizeof(u64);
+
+		perf_sample_regs_intr(&data->regs_intr, regs);
+
+		if (data->regs_intr.regs) {
+			u64 mask = event->attr.sample_regs_intr;
+
+			size += hweight64(mask) * sizeof(u64);
+		}
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -7151,6 +7191,8 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			ret = -EINVAL;
 	}
 
+	if (attr->sample_type & PERF_SAMPLE_REGS_INTR)
+		ret = perf_reg_validate(attr->sample_regs_intr);
 out:
 	return ret;
 
diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 717221e98450..40399c3d97d6 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -2,6 +2,8 @@ PERF-CFLAGS
 PERF-GUI-VARS
 PERF-VERSION-FILE
 perf
+perf-read-vdso32
+perf-read-vdsox32
 perf-help
 perf-record
 perf-report
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 398f8d53bd6d..af9a54ece024 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -214,6 +214,12 @@ if combined with -a or -C options.
 After starting the program, wait msecs before measuring. This is useful to
 filter out the startup phase of the program, which is often very different.
 
+-I::
+--intr-regs::
+Capture machine state (registers) at interrupt, i.e., on counter overflows for
+each sample. List of captured registers depends on the architecture. This option
+is off by default.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 0927bf4e6c2a..dd7cccdde498 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -159,7 +159,7 @@ OPTIONS
 --dump-raw-trace::
         Dump raw trace in ASCII.
 
--g [type,min[,limit],order[,key]]::
+-g [type,min[,limit],order[,key][,branch]]::
 --call-graph::
         Display call chains using type, min percent threshold, optional print
 	limit and order.
@@ -177,6 +177,11 @@ OPTIONS
 	- function: compare on functions
 	- address: compare on individual code addresses
 
+	branch can be:
+	- branch: include last branch information in callgraph
+	when available. Usually more convenient to use --branch-history
+	for this.
+
 	Default: fractal,0.5,callee,function.
 
 --children::
@@ -266,6 +271,11 @@ OPTIONS
 	branch stacks and it will automatically switch to the branch view mode,
 	unless --no-branch-stack is used.
 
+--branch-history::
+	Add the addresses of sampled taken branches to the callstack.
+	This allows to examine the path the program took to each sample.
+	The data collection must have used -b (or -j) and -g.
+
 --objdump=<path>::
         Path to objdump binary.
 
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 262916f4a377..478efa9b2364 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -60,6 +60,15 @@ include config/utilities.mak
 #
 # Define NO_LIBDW_DWARF_UNWIND if you do not want libdw support
 # for dwarf backtrace post unwind.
+#
+# Define NO_PERF_READ_VDSO32 if you do not want to build perf-read-vdso32
+# for reading the 32-bit compatibility VDSO in 64-bit mode
+#
+# Define NO_PERF_READ_VDSOX32 if you do not want to build perf-read-vdsox32
+# for reading the x32 mode 32-bit compatibility VDSO in 64-bit mode
+#
+# Define NO_ZLIB if you do not want to support compressed kernel modules
+
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
@@ -171,11 +180,16 @@ $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
-#
-# Single 'perf' binary right now:
-#
 PROGRAMS += $(OUTPUT)perf
 
+ifndef NO_PERF_READ_VDSO32
+PROGRAMS += $(OUTPUT)perf-read-vdso32
+endif
+
+ifndef NO_PERF_READ_VDSOX32
+PROGRAMS += $(OUTPUT)perf-read-vdsox32
+endif
+
 # what 'all' will build and 'install' will install, in perfexecdir
 ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
 
@@ -247,12 +261,14 @@ LIB_H += util/annotate.h
 LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
+LIB_H += util/db-export.h
 LIB_H += util/debug.h
 LIB_H += util/pmu.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
 LIB_H += util/evlist.h
 LIB_H += util/exec_cmd.h
+LIB_H += util/find-vdso-map.c
 LIB_H += util/levenshtein.h
 LIB_H += util/machine.h
 LIB_H += util/map.h
@@ -304,6 +320,7 @@ LIB_H += ui/util.h
 LIB_H += ui/ui.h
 LIB_H += util/data.h
 LIB_H += util/kvm-stat.h
+LIB_H += util/thread-stack.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -311,6 +328,7 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
+LIB_OBJS += $(OUTPUT)util/db-export.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
@@ -380,6 +398,7 @@ LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/cloexec.o
+LIB_OBJS += $(OUTPUT)util/thread-stack.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
@@ -478,8 +497,6 @@ ifneq ($(OUTPUT),)
 endif
 
 ifdef NO_LIBELF
-EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
-
 # Remove ELF/DWARF dependent codes
 LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
 LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
@@ -568,6 +585,10 @@ ifndef NO_LIBNUMA
   BUILTIN_OBJS += $(OUTPUT)bench/numa.o
 endif
 
+ifndef NO_ZLIB
+  LIB_OBJS += $(OUTPUT)util/zlib.o
+endif
+
 ifdef ASCIIDOC8
   export ASCIIDOC8
 endif
@@ -732,6 +753,16 @@ $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Uti
 $(OUTPUT)perf-%: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
 
+ifndef NO_PERF_READ_VDSO32
+$(OUTPUT)perf-read-vdso32: perf-read-vdso.c util/find-vdso-map.c
+	$(QUIET_CC)$(CC) -m32 $(filter -static,$(LDFLAGS)) -Wall -Werror -o $@ perf-read-vdso.c
+endif
+
+ifndef NO_PERF_READ_VDSOX32
+$(OUTPUT)perf-read-vdsox32: perf-read-vdso.c util/find-vdso-map.c
+	$(QUIET_CC)$(CC) -mx32 $(filter -static,$(LDFLAGS)) -Wall -Werror -o $@ perf-read-vdso.c
+endif
+
 $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 
@@ -876,6 +907,14 @@ install-bin: all install-gtk
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'; \
 		$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'; \
 		$(LN) '$(DESTDIR_SQ)$(bindir_SQ)/perf' '$(DESTDIR_SQ)$(bindir_SQ)/trace'
+ifndef NO_PERF_READ_VDSO32
+	$(call QUIET_INSTALL, perf-read-vdso32) \
+		$(INSTALL) $(OUTPUT)perf-read-vdso32 '$(DESTDIR_SQ)$(bindir_SQ)';
+endif
+ifndef NO_PERF_READ_VDSOX32
+	$(call QUIET_INSTALL, perf-read-vdsox32) \
+		$(INSTALL) $(OUTPUT)perf-read-vdsox32 '$(DESTDIR_SQ)$(bindir_SQ)';
+endif
 	$(call QUIET_INSTALL, libexec) \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(call QUIET_INSTALL, perf-archive) \
@@ -928,7 +967,7 @@ install: install-bin try-install-man install-traceevent-plugins
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
-	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
+	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(python-clean)
diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index d73ef8bb08c7..3bb50eac5542 100644
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -145,7 +145,7 @@ static Dwarf_Frame *get_dwarf_frame(Dwfl_Module *mod, Dwarf_Addr pc)
  *		yet used)
  *	-1 in case of errors
  */
-static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
+static int check_return_addr(struct dso *dso, Dwarf_Addr pc)
 {
 	int		rc = -1;
 	Dwfl		*dwfl;
@@ -156,15 +156,27 @@ static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
 	Dwarf_Addr	end = pc;
 	bool		signalp;
 
-	dwfl = dwfl_begin(&offline_callbacks);
-	if (!dwfl) {
-		pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
-		return -1;
-	}
+	dwfl = dso->dwfl;
 
-	if (dwfl_report_offline(dwfl, "",  exec_file, -1) == NULL) {
-		pr_debug("dwfl_report_offline() failed %s\n", dwarf_errmsg(-1));
-		goto out;
+	if (!dwfl) {
+		dwfl = dwfl_begin(&offline_callbacks);
+		if (!dwfl) {
+			pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
+			return -1;
+		}
+
+		if (dwfl_report_offline(dwfl, "", dso->long_name, -1) == NULL) {
+			pr_debug("dwfl_report_offline() failed %s\n",
+						dwarf_errmsg(-1));
+			/*
+			 * We normally cache the DWARF debug info and never
+			 * call dwfl_end(). But to prevent fd leak, free in
+			 * case of error.
+			 */
+			dwfl_end(dwfl);
+			goto out;
+		}
+		dso->dwfl = dwfl;
 	}
 
 	mod = dwfl_addrmodule(dwfl, pc);
@@ -194,7 +206,6 @@ static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
 	rc = check_return_reg(ra_regno, frame);
 
 out:
-	dwfl_end(dwfl);
 	return rc;
 }
 
@@ -221,8 +232,7 @@ static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
  *	index:	of callchain entry that needs to be ignored (if any)
  *	-1	if no entry needs to be ignored or in case of errors
  */
-int arch_skip_callchain_idx(struct machine *machine, struct thread *thread,
-				struct ip_callchain *chain)
+int arch_skip_callchain_idx(struct thread *thread, struct ip_callchain *chain)
 {
 	struct addr_location al;
 	struct dso *dso = NULL;
@@ -235,7 +245,7 @@ int arch_skip_callchain_idx(struct machine *machine, struct thread *thread,
 
 	ip = chain->ips[2];
 
-	thread__find_addr_location(thread, machine, PERF_RECORD_MISC_USER,
+	thread__find_addr_location(thread, PERF_RECORD_MISC_USER,
 			MAP__FUNCTION, ip, &al);
 
 	if (al.map)
@@ -246,7 +256,7 @@ int arch_skip_callchain_idx(struct machine *machine, struct thread *thread,
 		return skip_slot;
 	}
 
-	rc = check_return_addr(dso->long_name, ip);
+	rc = check_return_addr(dso, ip);
 
 	pr_debug("DSO %s, nr %" PRIx64 ", ip 0x%" PRIx64 "rc %d\n",
 				dso->long_name, chain->nr, ip, rc);
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 25114c9a6801..1ce425d101a9 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -357,6 +357,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool tool = {
 	.sample	= diff__process_sample_event,
 	.mmap	= perf_event__process_mmap,
+	.mmap2	= perf_event__process_mmap2,
 	.comm	= perf_event__process_comm,
 	.exit	= perf_event__process_exit,
 	.fork	= perf_event__process_fork,
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index de99ca1bb942..84df2deed988 100644
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
@@ -410,6 +409,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.tracing_data	= perf_event__repipe_op2_synth,
 			.finished_round	= perf_event__repipe_op2_synth,
 			.build_id	= perf_event__repipe_op2_synth,
+			.id_index	= perf_event__repipe_op2_synth,
 		},
 		.input_name  = "-",
 		.samples = LIST_HEAD_INIT(inject.samples),
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index b65eb0507b38..3c0f3d4fb021 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1132,6 +1132,10 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 		"-m", "1024",
 		"-c", "1",
 	};
+	const char * const kvm_stat_record_usage[] = {
+		"perf kvm stat record [<options>]",
+		NULL
+	};
 	const char * const *events_tp;
 	events_tp_size = 0;
 
@@ -1159,6 +1163,27 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	for (j = 1; j < (unsigned int)argc; j++, i++)
 		rec_argv[i] = argv[j];
 
+	set_option_flag(record_options, 'e', "event", PARSE_OPT_HIDDEN);
+	set_option_flag(record_options, 0, "filter", PARSE_OPT_HIDDEN);
+	set_option_flag(record_options, 'R', "raw-samples", PARSE_OPT_HIDDEN);
+
+	set_option_flag(record_options, 'F', "freq", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 0, "group", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'g', NULL, PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 0, "call-graph", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'd', "data", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'T', "timestamp", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'P', "period", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'n', "no-samples", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'N', "no-buildid-cache", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'B', "no-buildid", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'G', "cgroup", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'b', "branch-any", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'j', "branch-filter", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 'W', "weight", PARSE_OPT_DISABLED);
+	set_option_flag(record_options, 0, "transaction", PARSE_OPT_DISABLED);
+
+	record_usage = kvm_stat_record_usage;
 	return cmd_record(i, rec_argv, NULL);
 }
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 7af26acf06d9..921bb6942503 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -55,6 +55,7 @@ static struct {
 	bool show_funcs;
 	bool mod_events;
 	bool uprobes;
+	bool quiet;
 	int nevents;
 	struct perf_probe_event events[MAX_PROBES];
 	struct strlist *dellist;
@@ -312,9 +313,11 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 #endif
 		NULL
 };
-	const struct option options[] = {
+	struct option options[] = {
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
+	OPT_BOOLEAN('q', "quiet", &params.quiet,
+		    "be quiet (do not show any mesages)"),
 	OPT_BOOLEAN('l', "list", &params.list_events,
 		    "list up current probe events"),
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
@@ -382,6 +385,14 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	};
 	int ret;
 
+	set_option_flag(options, 'a', "add", PARSE_OPT_EXCLUSIVE);
+	set_option_flag(options, 'd', "del", PARSE_OPT_EXCLUSIVE);
+	set_option_flag(options, 'l', "list", PARSE_OPT_EXCLUSIVE);
+#ifdef HAVE_DWARF_SUPPORT
+	set_option_flag(options, 'L', "line", PARSE_OPT_EXCLUSIVE);
+	set_option_flag(options, 'V', "vars", PARSE_OPT_EXCLUSIVE);
+#endif
+
 	argc = parse_options(argc, argv, options, probe_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 	if (argc > 0) {
@@ -396,6 +407,14 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		}
 	}
 
+	if (params.quiet) {
+		if (verbose != 0) {
+			pr_err("  Error: -v and -q are exclusive.\n");
+			return -EINVAL;
+		}
+		verbose = -1;
+	}
+
 	if (params.max_probe_points == 0)
 		params.max_probe_points = MAX_PROBES;
 
@@ -409,22 +428,6 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);
 
 	if (params.list_events) {
-		if (params.mod_events) {
-			pr_err("  Error: Don't use --list with --add/--del.\n");
-			usage_with_options(probe_usage, options);
-		}
-		if (params.show_lines) {
-			pr_err("  Error: Don't use --list with --line.\n");
-			usage_with_options(probe_usage, options);
-		}
-		if (params.show_vars) {
-			pr_err(" Error: Don't use --list with --vars.\n");
-			usage_with_options(probe_usage, options);
-		}
-		if (params.show_funcs) {
-			pr_err("  Error: Don't use --list with --funcs.\n");
-			usage_with_options(probe_usage, options);
-		}
 		if (params.uprobes) {
 			pr_warning("  Error: Don't use --list with --exec.\n");
 			usage_with_options(probe_usage, options);
@@ -435,19 +438,6 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		return ret;
 	}
 	if (params.show_funcs) {
-		if (params.nevents != 0 || params.dellist) {
-			pr_err("  Error: Don't use --funcs with"
-			       " --add/--del.\n");
-			usage_with_options(probe_usage, options);
-		}
-		if (params.show_lines) {
-			pr_err("  Error: Don't use --funcs with --line.\n");
-			usage_with_options(probe_usage, options);
-		}
-		if (params.show_vars) {
-			pr_err("  Error: Don't use --funcs with --vars.\n");
-			usage_with_options(probe_usage, options);
-		}
 		if (!params.filter)
 			params.filter = strfilter__new(DEFAULT_FUNC_FILTER,
 						       NULL);
@@ -462,16 +452,6 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 
 #ifdef HAVE_DWARF_SUPPORT
 	if (params.show_lines) {
-		if (params.mod_events) {
-			pr_err("  Error: Don't use --line with"
-			       " --add/--del.\n");
-			usage_with_options(probe_usage, options);
-		}
-		if (params.show_vars) {
-			pr_err(" Error: Don't use --line with --vars.\n");
-			usage_with_options(probe_usage, options);
-		}
-
 		ret = show_line_range(&params.line_range, params.target,
 				      params.uprobes);
 		if (ret < 0)
@@ -479,11 +459,6 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		return ret;
 	}
 	if (params.show_vars) {
-		if (params.mod_events) {
-			pr_err("  Error: Don't use --vars with"
-			       " --add/--del.\n");
-			usage_with_options(probe_usage, options);
-		}
 		if (!params.filter)
 			params.filter = strfilter__new(DEFAULT_VAR_FILTER,
 						       NULL);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2583a9b04317..8648c6d3003d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -200,6 +200,17 @@ static int process_buildids(struct record *rec)
 	if (size == 0)
 		return 0;
 
+	/*
+	 * During this process, it'll load kernel map and replace the
+	 * dso->long_name to a real pathname it found.  In this case
+	 * we prefer the vmlinux path like
+	 *   /lib/modules/3.16.4/build/vmlinux
+	 *
+	 * rather than build-id path (in debug directory).
+	 *   $HOME/.debug/.build-id/f0/6e17aa50adf4d00b88925e03775de107611551
+	 */
+	symbol_conf.ignore_vmlinux_buildid = true;
+
 	return __perf_session__process_events(session, start,
 					      size - start,
 					      size, &build_id__mark_dso_hit_ops);
@@ -680,11 +691,12 @@ static int perf_record_config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static const char * const record_usage[] = {
+static const char * const __record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
 	NULL
 };
+const char * const *record_usage = __record_usage;
 
 /*
  * XXX Ideally would be local to cmd_record() and passed to a record__new
@@ -725,7 +737,7 @@ const char record_callchain_help[] = CALLCHAIN_HELP "fp";
  * perf_evlist__prepare_workload, etc instead of fork+exec'in 'perf record',
  * using pipes, etc.
  */
-const struct option record_options[] = {
+struct option __record_options[] = {
 	OPT_CALLBACK('e', "event", &record.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
@@ -799,9 +811,13 @@ const struct option record_options[] = {
 		    "sample transaction flags (special events only)"),
 	OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
 		    "use per-thread mmaps"),
+	OPT_BOOLEAN('I', "intr-regs", &record.opts.sample_intr_regs,
+		    "Sample machine registers on interrupt"),
 	OPT_END()
 };
 
+struct option *record_options = __record_options;
+
 int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int err = -ENOMEM;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 140a6cd88351..39367609c707 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -226,8 +226,9 @@ static int report__setup_sample_type(struct report *rep)
 			return -EINVAL;
 		}
 		if (symbol_conf.use_callchain) {
-			ui__error("Selected -g but no callchain data. Did "
-				    "you call 'perf record' without -g?\n");
+			ui__error("Selected -g or --branch-history but no "
+				  "callchain data. Did\n"
+				  "you call 'perf record' without -g?\n");
 			return -1;
 		}
 	} else if (!rep->dont_use_callchains &&
@@ -575,6 +576,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct stat st;
 	bool has_br_stack = false;
 	int branch_mode = -1;
+	bool branch_call_mode = false;
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
 		"perf report [<options>]",
@@ -637,8 +639,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
-		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order[,branch]",
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address), add branches. "
 		     "Default: fractal,0.5,callee,function", &report_parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN(0, "children", &symbol_conf.cumulate_callchain,
 		    "Accumulate callchains of children and show total overhead as well"),
@@ -684,7 +686,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
 		    "Show event group information together"),
 	OPT_CALLBACK_NOOPT('b', "branch-stack", &branch_mode, "",
-		    "use branch records for histogram filling", parse_branch_mode),
+		    "use branch records for per branch histogram filling",
+		    parse_branch_mode),
+	OPT_BOOLEAN(0, "branch-history", &branch_call_mode,
+		    "add last branch records to call history"),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
@@ -745,10 +750,24 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if ((branch_mode == -1 && has_br_stack) || branch_mode == 1) {
+	/*
+	 * Branch mode is a tristate:
+	 * -1 means default, so decide based on the file having branch data.
+	 * 0/1 means the user chose a mode.
+	 */
+	if (((branch_mode == -1 && has_br_stack) || branch_mode == 1) &&
+	    branch_call_mode == -1) {
 		sort__mode = SORT_MODE__BRANCH;
 		symbol_conf.cumulate_callchain = false;
 	}
+	if (branch_call_mode) {
+		callchain_param.key = CCKEY_ADDRESS;
+		callchain_param.branch_callstack = 1;
+		symbol_conf.use_callchain = true;
+		callchain_register_param(&callchain_param);
+		if (sort_order == NULL)
+			sort_order = "srcline,symbol,dso";
+	}
 
 	if (report.mem_mode) {
 		if (sort__mode == SORT_MODE__BRANCH) {
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9708a1290571..ce304dfd962a 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -23,7 +23,6 @@ static char const		*generate_script_lang;
 static bool			debug_mode;
 static u64			last_timestamp;
 static u64			nr_unordered;
-extern const struct option	record_options[];
 static bool			no_callchain;
 static bool			latency_format;
 static bool			system_wide;
@@ -379,7 +378,6 @@ static void print_sample_start(struct perf_sample *sample,
 
 static void print_sample_addr(union perf_event *event,
 			  struct perf_sample *sample,
-			  struct machine *machine,
 			  struct thread *thread,
 			  struct perf_event_attr *attr)
 {
@@ -390,7 +388,7 @@ static void print_sample_addr(union perf_event *event,
 	if (!sample_addr_correlates_sym(attr))
 		return;
 
-	perf_event__preprocess_sample_addr(event, sample, machine, thread, &al);
+	perf_event__preprocess_sample_addr(event, sample, thread, &al);
 
 	if (PRINT_FIELD(SYM)) {
 		printf(" ");
@@ -438,7 +436,7 @@ static void print_sample_bts(union perf_event *event,
 	    ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
 	     !output[attr->type].user_set)) {
 		printf(" => ");
-		print_sample_addr(event, sample, al->machine, thread, attr);
+		print_sample_addr(event, sample, thread, attr);
 	}
 
 	if (print_srcline_last)
@@ -475,7 +473,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 		event_format__print(evsel->tp_format, sample->cpu,
 				    sample->raw_data, sample->raw_size);
 	if (PRINT_FIELD(ADDR))
-		print_sample_addr(event, sample, al->machine, thread, attr);
+		print_sample_addr(event, sample, thread, attr);
 
 	if (PRINT_FIELD(IP)) {
 		if (!symbol_conf.use_callchain)
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 055ce9232c9e..891086376381 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -388,20 +388,102 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_itlb_cache_stats[0], count[0]);
 }
 
+static void zero_per_pkg(struct perf_evsel *counter)
+{
+	if (counter->per_pkg_mask)
+		memset(counter->per_pkg_mask, 0, MAX_NR_CPUS);
+}
+
+static int check_per_pkg(struct perf_evsel *counter, int cpu, bool *skip)
+{
+	unsigned long *mask = counter->per_pkg_mask;
+	struct cpu_map *cpus = perf_evsel__cpus(counter);
+	int s;
+
+	*skip = false;
+
+	if (!counter->per_pkg)
+		return 0;
+
+	if (cpu_map__empty(cpus))
+		return 0;
+
+	if (!mask) {
+		mask = zalloc(MAX_NR_CPUS);
+		if (!mask)
+			return -ENOMEM;
+
+		counter->per_pkg_mask = mask;
+	}
+
+	s = cpu_map__get_socket(cpus, cpu);
+	if (s < 0)
+		return -1;
+
+	*skip = test_and_set_bit(s, mask) == 1;
+	return 0;
+}
+
+static int read_cb(struct perf_evsel *evsel, int cpu, int thread __maybe_unused,
+		   struct perf_counts_values *count)
+{
+	struct perf_counts_values *aggr = &evsel->counts->aggr;
+	static struct perf_counts_values zero;
+	bool skip = false;
+
+	if (check_per_pkg(evsel, cpu, &skip)) {
+		pr_err("failed to read per-pkg counter\n");
+		return -1;
+	}
+
+	if (skip)
+		count = &zero;
+
+	switch (aggr_mode) {
+	case AGGR_CORE:
+	case AGGR_SOCKET:
+	case AGGR_NONE:
+		if (!evsel->snapshot)
+			perf_evsel__compute_deltas(evsel, cpu, count);
+		perf_counts_values__scale(count, scale, NULL);
+		evsel->counts->cpu[cpu] = *count;
+		update_shadow_stats(evsel, count->values);
+		break;
+	case AGGR_GLOBAL:
+		aggr->val += count->val;
+		if (scale) {
+			aggr->ena += count->ena;
+			aggr->run += count->run;
+		}
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int read_counter(struct perf_evsel *counter);
+
 /*
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
  */
 static int read_counter_aggr(struct perf_evsel *counter)
 {
+	struct perf_counts_values *aggr = &counter->counts->aggr;
 	struct perf_stat *ps = counter->priv;
 	u64 *count = counter->counts->aggr.values;
 	int i;
 
-	if (__perf_evsel__read(counter, perf_evsel__nr_cpus(counter),
-			       thread_map__nr(evsel_list->threads), scale) < 0)
+	aggr->val = aggr->ena = aggr->run = 0;
+
+	if (read_counter(counter))
 		return -1;
 
+	if (!counter->snapshot)
+		perf_evsel__compute_deltas(counter, -1, aggr);
+	perf_counts_values__scale(aggr, scale, &counter->counts->scaled);
+
 	for (i = 0; i < 3; i++)
 		update_stats(&ps->res_stats[i], count[i]);
 
@@ -424,16 +506,21 @@ static int read_counter_aggr(struct perf_evsel *counter)
  */
 static int read_counter(struct perf_evsel *counter)
 {
-	u64 *count;
-	int cpu;
+	int nthreads = thread_map__nr(evsel_list->threads);
+	int ncpus = perf_evsel__nr_cpus(counter);
+	int cpu, thread;
 
-	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
-		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
-			return -1;
+	if (counter->system_wide)
+		nthreads = 1;
 
-		count = counter->counts->cpu[cpu].values;
+	if (counter->per_pkg)
+		zero_per_pkg(counter);
 
-		update_shadow_stats(counter, count);
+	for (thread = 0; thread < nthreads; thread++) {
+		for (cpu = 0; cpu < ncpus; cpu++) {
+			if (perf_evsel__read_cb(counter, cpu, thread, read_cb))
+				return -1;
+		}
 	}
 
 	return 0;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 35b425b6293f..f3bb1a4bf060 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -528,7 +528,7 @@ static const char *cat_backtrace(union perf_event *event,
 		}
 
 		tal.filtered = 0;
-		thread__find_addr_location(al.thread, machine, cpumode,
+		thread__find_addr_location(al.thread, cpumode,
 					   MAP__FUNCTION, ip, &tal);
 
 		if (tal.sym)
@@ -1963,7 +1963,7 @@ int cmd_timechart(int argc, const char **argv,
 		NULL
 	};
 
-	const struct option record_options[] = {
+	const struct option timechart_record_options[] = {
 	OPT_BOOLEAN('P', "power-only", &tchart.power_only, "output power data only"),
 	OPT_BOOLEAN('T', "tasks-only", &tchart.tasks_only,
 		    "output processes data only"),
@@ -1972,7 +1972,7 @@ int cmd_timechart(int argc, const char **argv,
 	OPT_BOOLEAN('g', "callchain", &tchart.with_backtrace, "record callchain"),
 	OPT_END()
 	};
-	const char * const record_usage[] = {
+	const char * const timechart_record_usage[] = {
 		"perf timechart record [<options>]",
 		NULL
 	};
@@ -1985,7 +1985,8 @@ int cmd_timechart(int argc, const char **argv,
 	}
 
 	if (argc && !strncmp(argv[0], "rec", 3)) {
-		argc = parse_options(argc, argv, record_options, record_usage,
+		argc = parse_options(argc, argv, timechart_record_options,
+				     timechart_record_usage,
 				     PARSE_OPT_STOP_AT_NON_OPTION);
 
 		if (tchart.power_only && tchart.tasks_only) {
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index fb126459b134..83a4835c8118 100644
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
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 58f609198c6d..5d4b039fe1ed 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -150,7 +150,7 @@ CFLAGS += -std=gnu99
 # adding assembler files missing the .GNU-stack linker note.
 LDFLAGS += -Wl,-z,noexecstack
 
-EXTLIBS = -lelf -lpthread -lrt -lm -ldl
+EXTLIBS = -lpthread -lrt -lm -ldl
 
 ifneq ($(OUTPUT),)
   OUTPUT_FEATURES = $(OUTPUT)config/feature-checks/
@@ -200,7 +200,8 @@ CORE_FEATURE_TESTS =			\
 	libunwind			\
 	stackprotector-all		\
 	timerfd				\
-	libdw-dwarf-unwind
+	libdw-dwarf-unwind		\
+	zlib
 
 LIB_FEATURE_TESTS =			\
 	dwarf				\
@@ -214,7 +215,8 @@ LIB_FEATURE_TESTS =			\
 	libpython			\
 	libslang			\
 	libunwind			\
-	libdw-dwarf-unwind
+	libdw-dwarf-unwind		\
+	zlib
 
 VF_FEATURE_TESTS =			\
 	backtrace			\
@@ -230,7 +232,9 @@ VF_FEATURE_TESTS =			\
 	bionic				\
 	liberty				\
 	liberty-z			\
-	cplus-demangle
+	cplus-demangle			\
+	compile-32			\
+	compile-x32
 
 # Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
 # If in the future we need per-feature checks/flags for features not
@@ -350,6 +354,7 @@ endif # NO_LIBELF
 
 ifndef NO_LIBELF
   CFLAGS += -DHAVE_LIBELF_SUPPORT
+  EXTLIBS += -lelf
 
   ifeq ($(feature-libelf-mmap), 1)
     CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
@@ -369,7 +374,7 @@ ifndef NO_LIBELF
     else
       CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
       LDFLAGS += $(LIBDW_LDFLAGS)
-      EXTLIBS += -lelf -ldw
+      EXTLIBS += -ldw
     endif # PERF_HAVE_DWARF_REGS
   endif # NO_DWARF
 endif # NO_LIBELF
@@ -602,6 +607,15 @@ ifneq ($(filter -lbfd,$(EXTLIBS)),)
   CFLAGS += -DHAVE_LIBBFD_SUPPORT
 endif
 
+ifndef NO_ZLIB
+  ifeq ($(feature-zlib), 1)
+    CFLAGS += -DHAVE_ZLIB_SUPPORT
+    EXTLIBS += -lz
+  else
+    NO_ZLIB := 1
+  endif
+endif
+
 ifndef NO_BACKTRACE
   ifeq ($(feature-backtrace), 1)
     CFLAGS += -DHAVE_BACKTRACE_SUPPORT
@@ -622,6 +636,31 @@ ifdef HAVE_KVM_STAT_SUPPORT
     CFLAGS += -DHAVE_KVM_STAT_SUPPORT
 endif
 
+ifeq (${IS_64_BIT}, 1)
+  ifndef NO_PERF_READ_VDSO32
+    $(call feature_check,compile-32)
+    ifeq ($(feature-compile-32), 1)
+      CFLAGS += -DHAVE_PERF_READ_VDSO32
+    else
+      NO_PERF_READ_VDSO32 := 1
+    endif
+  endif
+  ifneq (${IS_X86_64}, 1)
+    NO_PERF_READ_VDSOX32 := 1
+  endif
+  ifndef NO_PERF_READ_VDSOX32
+    $(call feature_check,compile-x32)
+    ifeq ($(feature-compile-x32), 1)
+      CFLAGS += -DHAVE_PERF_READ_VDSOX32
+    else
+      NO_PERF_READ_VDSOX32 := 1
+    endif
+  endif
+else
+  NO_PERF_READ_VDSO32 := 1
+  NO_PERF_READ_VDSOX32 := 1
+endif
+
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
index 4b06719ee984..851cd0172a76 100644
--- a/tools/perf/config/Makefile.arch
+++ b/tools/perf/config/Makefile.arch
@@ -21,3 +21,11 @@ ifeq ($(ARCH),x86_64)
     RAW_ARCH := x86_64
   endif
 endif
+
+ifeq (${IS_X86_64}, 1)
+  IS_64_BIT := 1
+else ifeq ($(ARCH),x86)
+  IS_64_BIT := 0
+else
+  IS_64_BIT := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
+endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 72ab2984718e..53f19b5dbc37 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -27,7 +27,10 @@ FILES=					\
 	test-libunwind-debug-frame.bin	\
 	test-stackprotector-all.bin	\
 	test-timerfd.bin		\
-	test-libdw-dwarf-unwind.bin
+	test-libdw-dwarf-unwind.bin	\
+	test-compile-32.bin		\
+	test-compile-x32.bin		\
+	test-zlib.bin
 
 CC := $(CROSS_COMPILE)gcc -MD
 PKG_CONFIG := $(CROSS_COMPILE)pkg-config
@@ -39,7 +42,7 @@ BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $(patsubst %.bin,%.c,$@) $(LDFLAGS)
 ###############################
 
 test-all.bin:
-	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
+	$(BUILD) -Werror -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl -lz
 
 test-hello.bin:
 	$(BUILD)
@@ -131,6 +134,15 @@ FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 test-sync-compare-and-swap.bin:
 	$(BUILD) -Werror
 
+test-compile-32.bin:
+	$(CC) -m32 -o $(OUTPUT)$@ test-compile.c
+
+test-compile-x32.bin:
+	$(CC) -mx32 -o $(OUTPUT)$@ test-compile.c
+
+test-zlib.bin:
+	$(BUILD) -lz
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-all.c b/tools/perf/config/feature-checks/test-all.c
index a7d022e161c0..652e0098eba6 100644
--- a/tools/perf/config/feature-checks/test-all.c
+++ b/tools/perf/config/feature-checks/test-all.c
@@ -93,6 +93,10 @@
 # include "test-sync-compare-and-swap.c"
 #undef main
 
+#define main main_test_zlib
+# include "test-zlib.c"
+#undef main
+
 int main(int argc, char *argv[])
 {
 	main_test_libpython();
@@ -116,6 +120,7 @@ int main(int argc, char *argv[])
 	main_test_stackprotector_all();
 	main_test_libdw_dwarf_unwind();
 	main_test_sync_compare_and_swap(argc, argv);
+	main_test_zlib();
 
 	return 0;
 }
diff --git a/tools/perf/config/feature-checks/test-compile.c b/tools/perf/config/feature-checks/test-compile.c
new file mode 100644
index 000000000000..31dbf45bf99c
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-compile.c
@@ -0,0 +1,4 @@
+int main(void)
+{
+	return 0;
+}
diff --git a/tools/perf/config/feature-checks/test-zlib.c b/tools/perf/config/feature-checks/test-zlib.c
new file mode 100644
index 000000000000..e111fff6240e
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-zlib.c
@@ -0,0 +1,9 @@
+#include <zlib.h>
+
+int main(void)
+{
+	z_stream zs;
+
+	inflateInit(&zs);
+	return 0;
+}
diff --git a/tools/perf/perf-read-vdso.c b/tools/perf/perf-read-vdso.c
new file mode 100644
index 000000000000..764e2547c25a
--- /dev/null
+++ b/tools/perf/perf-read-vdso.c
@@ -0,0 +1,34 @@
+#include <stdio.h>
+#include <string.h>
+
+#define VDSO__MAP_NAME "[vdso]"
+
+/*
+ * Include definition of find_vdso_map() also used in util/vdso.c for
+ * building perf.
+ */
+#include "util/find-vdso-map.c"
+
+int main(void)
+{
+	void *start, *end;
+	size_t size, written;
+
+	if (find_vdso_map(&start, &end))
+		return 1;
+
+	size = end - start;
+
+	while (size) {
+		written = fwrite(start, 1, size, stdout);
+		if (!written)
+			return 1;
+		start += written;
+		size -= written;
+	}
+
+	if (fflush(stdout))
+		return 1;
+
+	return 0;
+}
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 220d44e44c1b..1dabb8553499 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -52,6 +52,7 @@ struct record_opts {
 	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
+	bool	     sample_intr_regs;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
@@ -62,4 +63,7 @@ struct record_opts {
 	unsigned     initial_delay;
 };
 
+struct option;
+extern const char * const *record_usage;
+extern struct option *record_options;
 #endif
diff --git a/tools/perf/scripts/python/bin/export-to-postgresql-record b/tools/perf/scripts/python/bin/export-to-postgresql-record
new file mode 100644
index 000000000000..221d66e05713
--- /dev/null
+++ b/tools/perf/scripts/python/bin/export-to-postgresql-record
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+#
+# export perf data to a postgresql database. Can cover
+# perf ip samples (excluding the tracepoints). No special
+# record requirements, just record what you want to export.
+#
+perf record $@
diff --git a/tools/perf/scripts/python/bin/export-to-postgresql-report b/tools/perf/scripts/python/bin/export-to-postgresql-report
new file mode 100644
index 000000000000..cd335b6e2a01
--- /dev/null
+++ b/tools/perf/scripts/python/bin/export-to-postgresql-report
@@ -0,0 +1,29 @@
+#!/bin/bash
+# description: export perf data to a postgresql database
+# args: [database name] [columns] [calls]
+n_args=0
+for i in "$@"
+do
+    if expr match "$i" "-" > /dev/null ; then
+	break
+    fi
+    n_args=$(( $n_args + 1 ))
+done
+if [ "$n_args" -gt 3 ] ; then
+    echo "usage: export-to-postgresql-report [database name] [columns] [calls]"
+    exit
+fi
+if [ "$n_args" -gt 2 ] ; then
+    dbname=$1
+    columns=$2
+    calls=$3
+    shift 3
+elif [ "$n_args" -gt 1 ] ; then
+    dbname=$1
+    columns=$2
+    shift 2
+elif [ "$n_args" -gt 0 ] ; then
+    dbname=$1
+    shift
+fi
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/export-to-postgresql.py $dbname $columns $calls
diff --git a/tools/perf/scripts/python/export-to-postgresql.py b/tools/perf/scripts/python/export-to-postgresql.py
new file mode 100644
index 000000000000..4cdafd880074
--- /dev/null
+++ b/tools/perf/scripts/python/export-to-postgresql.py
@@ -0,0 +1,444 @@
+# export-to-postgresql.py: export perf data to a postgresql database
+# Copyright (c) 2014, Intel Corporation.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms and conditions of the GNU General Public License,
+# version 2, as published by the Free Software Foundation.
+#
+# This program is distributed in the hope it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+# more details.
+
+import os
+import sys
+import struct
+import datetime
+
+from PySide.QtSql import *
+
+# Need to access PostgreSQL C library directly to use COPY FROM STDIN
+from ctypes import *
+libpq = CDLL("libpq.so.5")
+PQconnectdb = libpq.PQconnectdb
+PQconnectdb.restype = c_void_p
+PQfinish = libpq.PQfinish
+PQstatus = libpq.PQstatus
+PQexec = libpq.PQexec
+PQexec.restype = c_void_p
+PQresultStatus = libpq.PQresultStatus
+PQputCopyData = libpq.PQputCopyData
+PQputCopyData.argtypes = [ c_void_p, c_void_p, c_int ]
+PQputCopyEnd = libpq.PQputCopyEnd
+PQputCopyEnd.argtypes = [ c_void_p, c_void_p ]
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+# These perf imports are not used at present
+#from perf_trace_context import *
+#from Core import *
+
+perf_db_export_mode = True
+perf_db_export_calls = False
+
+def usage():
+	print >> sys.stderr, "Usage is: export-to-postgresql.py <database name> [<columns>] [<calls>]"
+	print >> sys.stderr, "where:	columns		'all' or 'branches'"
+	print >> sys.stderr, "		calls		'calls' => create calls table"
+	raise Exception("Too few arguments")
+
+if (len(sys.argv) < 2):
+	usage()
+
+dbname = sys.argv[1]
+
+if (len(sys.argv) >= 3):
+	columns = sys.argv[2]
+else:
+	columns = "all"
+
+if columns not in ("all", "branches"):
+	usage()
+
+branches = (columns == "branches")
+
+if (len(sys.argv) >= 4):
+	if (sys.argv[3] == "calls"):
+		perf_db_export_calls = True
+	else:
+		usage()
+
+output_dir_name = os.getcwd() + "/" + dbname + "-perf-data"
+os.mkdir(output_dir_name)
+
+def do_query(q, s):
+	if (q.exec_(s)):
+		return
+	raise Exception("Query failed: " + q.lastError().text())
+
+print datetime.datetime.today(), "Creating database..."
+
+db = QSqlDatabase.addDatabase('QPSQL')
+query = QSqlQuery(db)
+db.setDatabaseName('postgres')
+db.open()
+try:
+	do_query(query, 'CREATE DATABASE ' + dbname)
+except:
+	os.rmdir(output_dir_name)
+	raise
+query.finish()
+query.clear()
+db.close()
+
+db.setDatabaseName(dbname)
+db.open()
+
+query = QSqlQuery(db)
+do_query(query, 'SET client_min_messages TO WARNING')
+
+do_query(query, 'CREATE TABLE selected_events ('
+		'id		bigint		NOT NULL,'
+		'name		varchar(80))')
+do_query(query, 'CREATE TABLE machines ('
+		'id		bigint		NOT NULL,'
+		'pid		integer,'
+		'root_dir 	varchar(4096))')
+do_query(query, 'CREATE TABLE threads ('
+		'id		bigint		NOT NULL,'
+		'machine_id	bigint,'
+		'process_id	bigint,'
+		'pid		integer,'
+		'tid		integer)')
+do_query(query, 'CREATE TABLE comms ('
+		'id		bigint		NOT NULL,'
+		'comm		varchar(16))')
+do_query(query, 'CREATE TABLE comm_threads ('
+		'id		bigint		NOT NULL,'
+		'comm_id	bigint,'
+		'thread_id	bigint)')
+do_query(query, 'CREATE TABLE dsos ('
+		'id		bigint		NOT NULL,'
+		'machine_id	bigint,'
+		'short_name	varchar(256),'
+		'long_name	varchar(4096),'
+		'build_id	varchar(64))')
+do_query(query, 'CREATE TABLE symbols ('
+		'id		bigint		NOT NULL,'
+		'dso_id		bigint,'
+		'sym_start	bigint,'
+		'sym_end	bigint,'
+		'binding	integer,'
+		'name		varchar(2048))')
+do_query(query, 'CREATE TABLE branch_types ('
+		'id		integer		NOT NULL,'
+		'name		varchar(80))')
+
+if branches:
+	do_query(query, 'CREATE TABLE samples ('
+		'id		bigint		NOT NULL,'
+		'evsel_id	bigint,'
+		'machine_id	bigint,'
+		'thread_id	bigint,'
+		'comm_id	bigint,'
+		'dso_id		bigint,'
+		'symbol_id	bigint,'
+		'sym_offset	bigint,'
+		'ip		bigint,'
+		'time		bigint,'
+		'cpu		integer,'
+		'to_dso_id	bigint,'
+		'to_symbol_id	bigint,'
+		'to_sym_offset	bigint,'
+		'to_ip		bigint,'
+		'branch_type	integer,'
+		'in_tx		boolean)')
+else:
+	do_query(query, 'CREATE TABLE samples ('
+		'id		bigint		NOT NULL,'
+		'evsel_id	bigint,'
+		'machine_id	bigint,'
+		'thread_id	bigint,'
+		'comm_id	bigint,'
+		'dso_id		bigint,'
+		'symbol_id	bigint,'
+		'sym_offset	bigint,'
+		'ip		bigint,'
+		'time		bigint,'
+		'cpu		integer,'
+		'to_dso_id	bigint,'
+		'to_symbol_id	bigint,'
+		'to_sym_offset	bigint,'
+		'to_ip		bigint,'
+		'period		bigint,'
+		'weight		bigint,'
+		'transaction	bigint,'
+		'data_src	bigint,'
+		'branch_type	integer,'
+		'in_tx		boolean)')
+
+if perf_db_export_calls:
+	do_query(query, 'CREATE TABLE call_paths ('
+		'id		bigint		NOT NULL,'
+		'parent_id	bigint,'
+		'symbol_id	bigint,'
+		'ip		bigint)')
+	do_query(query, 'CREATE TABLE calls ('
+		'id		bigint		NOT NULL,'
+		'thread_id	bigint,'
+		'comm_id	bigint,'
+		'call_path_id	bigint,'
+		'call_time	bigint,'
+		'return_time	bigint,'
+		'branch_count	bigint,'
+		'call_id	bigint,'
+		'return_id	bigint,'
+		'parent_call_path_id	bigint,'
+		'flags		integer)')
+
+do_query(query, 'CREATE VIEW samples_view AS '
+	'SELECT '
+		'id,'
+		'time,'
+		'cpu,'
+		'(SELECT pid FROM threads WHERE id = thread_id) AS pid,'
+		'(SELECT tid FROM threads WHERE id = thread_id) AS tid,'
+		'(SELECT comm FROM comms WHERE id = comm_id) AS command,'
+		'(SELECT name FROM selected_events WHERE id = evsel_id) AS event,'
+		'to_hex(ip) AS ip_hex,'
+		'(SELECT name FROM symbols WHERE id = symbol_id) AS symbol,'
+		'sym_offset,'
+		'(SELECT short_name FROM dsos WHERE id = dso_id) AS dso_short_name,'
+		'to_hex(to_ip) AS to_ip_hex,'
+		'(SELECT name FROM symbols WHERE id = to_symbol_id) AS to_symbol,'
+		'to_sym_offset,'
+		'(SELECT short_name FROM dsos WHERE id = to_dso_id) AS to_dso_short_name,'
+		'(SELECT name FROM branch_types WHERE id = branch_type) AS branch_type_name,'
+		'in_tx'
+	' FROM samples')
+
+
+file_header = struct.pack("!11sii", "PGCOPY\n\377\r\n\0", 0, 0)
+file_trailer = "\377\377"
+
+def open_output_file(file_name):
+	path_name = output_dir_name + "/" + file_name
+	file = open(path_name, "w+")
+	file.write(file_header)
+	return file
+
+def close_output_file(file):
+	file.write(file_trailer)
+	file.close()
+
+def copy_output_file_direct(file, table_name):
+	close_output_file(file)
+	sql = "COPY " + table_name + " FROM '" + file.name + "' (FORMAT 'binary')"
+	do_query(query, sql)
+
+# Use COPY FROM STDIN because security may prevent postgres from accessing the files directly
+def copy_output_file(file, table_name):
+	conn = PQconnectdb("dbname = " + dbname)
+	if (PQstatus(conn)):
+		raise Exception("COPY FROM STDIN PQconnectdb failed")
+	file.write(file_trailer)
+	file.seek(0)
+	sql = "COPY " + table_name + " FROM STDIN (FORMAT 'binary')"
+	res = PQexec(conn, sql)
+	if (PQresultStatus(res) != 4):
+		raise Exception("COPY FROM STDIN PQexec failed")
+	data = file.read(65536)
+	while (len(data)):
+		ret = PQputCopyData(conn, data, len(data))
+		if (ret != 1):
+			raise Exception("COPY FROM STDIN PQputCopyData failed, error " + str(ret))
+		data = file.read(65536)
+	ret = PQputCopyEnd(conn, None)
+	if (ret != 1):
+		raise Exception("COPY FROM STDIN PQputCopyEnd failed, error " + str(ret))
+	PQfinish(conn)
+
+def remove_output_file(file):
+	name = file.name
+	file.close()
+	os.unlink(name)
+
+evsel_file		= open_output_file("evsel_table.bin")
+machine_file		= open_output_file("machine_table.bin")
+thread_file		= open_output_file("thread_table.bin")
+comm_file		= open_output_file("comm_table.bin")
+comm_thread_file	= open_output_file("comm_thread_table.bin")
+dso_file		= open_output_file("dso_table.bin")
+symbol_file		= open_output_file("symbol_table.bin")
+branch_type_file	= open_output_file("branch_type_table.bin")
+sample_file		= open_output_file("sample_table.bin")
+if perf_db_export_calls:
+	call_path_file		= open_output_file("call_path_table.bin")
+	call_file		= open_output_file("call_table.bin")
+
+def trace_begin():
+	print datetime.datetime.today(), "Writing to intermediate files..."
+	# id == 0 means unknown.  It is easier to create records for them than replace the zeroes with NULLs
+	evsel_table(0, "unknown")
+	machine_table(0, 0, "unknown")
+	thread_table(0, 0, 0, -1, -1)
+	comm_table(0, "unknown")
+	dso_table(0, 0, "unknown", "unknown", "")
+	symbol_table(0, 0, 0, 0, 0, "unknown")
+	sample_table(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
+	if perf_db_export_calls:
+		call_path_table(0, 0, 0, 0)
+
+unhandled_count = 0
+
+def trace_end():
+	print datetime.datetime.today(), "Copying to database..."
+	copy_output_file(evsel_file,		"selected_events")
+	copy_output_file(machine_file,		"machines")
+	copy_output_file(thread_file,		"threads")
+	copy_output_file(comm_file,		"comms")
+	copy_output_file(comm_thread_file,	"comm_threads")
+	copy_output_file(dso_file,		"dsos")
+	copy_output_file(symbol_file,		"symbols")
+	copy_output_file(branch_type_file,	"branch_types")
+	copy_output_file(sample_file,		"samples")
+	if perf_db_export_calls:
+		copy_output_file(call_path_file,	"call_paths")
+		copy_output_file(call_file,		"calls")
+
+	print datetime.datetime.today(), "Removing intermediate files..."
+	remove_output_file(evsel_file)
+	remove_output_file(machine_file)
+	remove_output_file(thread_file)
+	remove_output_file(comm_file)
+	remove_output_file(comm_thread_file)
+	remove_output_file(dso_file)
+	remove_output_file(symbol_file)
+	remove_output_file(branch_type_file)
+	remove_output_file(sample_file)
+	if perf_db_export_calls:
+		remove_output_file(call_path_file)
+		remove_output_file(call_file)
+	os.rmdir(output_dir_name)
+	print datetime.datetime.today(), "Adding primary keys"
+	do_query(query, 'ALTER TABLE selected_events ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE machines        ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE threads         ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE comms           ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE comm_threads    ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE dsos            ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE symbols         ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE branch_types    ADD PRIMARY KEY (id)')
+	do_query(query, 'ALTER TABLE samples         ADD PRIMARY KEY (id)')
+	if perf_db_export_calls:
+		do_query(query, 'ALTER TABLE call_paths      ADD PRIMARY KEY (id)')
+		do_query(query, 'ALTER TABLE calls           ADD PRIMARY KEY (id)')
+
+	print datetime.datetime.today(), "Adding foreign keys"
+	do_query(query, 'ALTER TABLE threads '
+					'ADD CONSTRAINT machinefk  FOREIGN KEY (machine_id)   REFERENCES machines   (id),'
+					'ADD CONSTRAINT processfk  FOREIGN KEY (process_id)   REFERENCES threads    (id)')
+	do_query(query, 'ALTER TABLE comm_threads '
+					'ADD CONSTRAINT commfk     FOREIGN KEY (comm_id)      REFERENCES comms      (id),'
+					'ADD CONSTRAINT threadfk   FOREIGN KEY (thread_id)    REFERENCES threads    (id)')
+	do_query(query, 'ALTER TABLE dsos '
+					'ADD CONSTRAINT machinefk  FOREIGN KEY (machine_id)   REFERENCES machines   (id)')
+	do_query(query, 'ALTER TABLE symbols '
+					'ADD CONSTRAINT dsofk      FOREIGN KEY (dso_id)       REFERENCES dsos       (id)')
+	do_query(query, 'ALTER TABLE samples '
+					'ADD CONSTRAINT evselfk    FOREIGN KEY (evsel_id)     REFERENCES selected_events (id),'
+					'ADD CONSTRAINT machinefk  FOREIGN KEY (machine_id)   REFERENCES machines   (id),'
+					'ADD CONSTRAINT threadfk   FOREIGN KEY (thread_id)    REFERENCES threads    (id),'
+					'ADD CONSTRAINT commfk     FOREIGN KEY (comm_id)      REFERENCES comms      (id),'
+					'ADD CONSTRAINT dsofk      FOREIGN KEY (dso_id)       REFERENCES dsos       (id),'
+					'ADD CONSTRAINT symbolfk   FOREIGN KEY (symbol_id)    REFERENCES symbols    (id),'
+					'ADD CONSTRAINT todsofk    FOREIGN KEY (to_dso_id)    REFERENCES dsos       (id),'
+					'ADD CONSTRAINT tosymbolfk FOREIGN KEY (to_symbol_id) REFERENCES symbols    (id)')
+	if perf_db_export_calls:
+		do_query(query, 'ALTER TABLE call_paths '
+					'ADD CONSTRAINT parentfk    FOREIGN KEY (parent_id)    REFERENCES call_paths (id),'
+					'ADD CONSTRAINT symbolfk    FOREIGN KEY (symbol_id)    REFERENCES symbols    (id)')
+		do_query(query, 'ALTER TABLE calls '
+					'ADD CONSTRAINT threadfk    FOREIGN KEY (thread_id)    REFERENCES threads    (id),'
+					'ADD CONSTRAINT commfk      FOREIGN KEY (comm_id)      REFERENCES comms      (id),'
+					'ADD CONSTRAINT call_pathfk FOREIGN KEY (call_path_id) REFERENCES call_paths (id),'
+					'ADD CONSTRAINT callfk      FOREIGN KEY (call_id)      REFERENCES samples    (id),'
+					'ADD CONSTRAINT returnfk    FOREIGN KEY (return_id)    REFERENCES samples    (id),'
+					'ADD CONSTRAINT parent_call_pathfk FOREIGN KEY (parent_call_path_id) REFERENCES call_paths (id)')
+		do_query(query, 'CREATE INDEX pcpid_idx ON calls (parent_call_path_id)')
+
+	if (unhandled_count):
+		print datetime.datetime.today(), "Warning: ", unhandled_count, " unhandled events"
+	print datetime.datetime.today(), "Done"
+
+def trace_unhandled(event_name, context, event_fields_dict):
+	global unhandled_count
+	unhandled_count += 1
+
+def sched__sched_switch(*x):
+	pass
+
+def evsel_table(evsel_id, evsel_name, *x):
+	n = len(evsel_name)
+	fmt = "!hiqi" + str(n) + "s"
+	value = struct.pack(fmt, 2, 8, evsel_id, n, evsel_name)
+	evsel_file.write(value)
+
+def machine_table(machine_id, pid, root_dir, *x):
+	n = len(root_dir)
+	fmt = "!hiqiii" + str(n) + "s"
+	value = struct.pack(fmt, 3, 8, machine_id, 4, pid, n, root_dir)
+	machine_file.write(value)
+
+def thread_table(thread_id, machine_id, process_id, pid, tid, *x):
+	value = struct.pack("!hiqiqiqiiii", 5, 8, thread_id, 8, machine_id, 8, process_id, 4, pid, 4, tid)
+	thread_file.write(value)
+
+def comm_table(comm_id, comm_str, *x):
+	n = len(comm_str)
+	fmt = "!hiqi" + str(n) + "s"
+	value = struct.pack(fmt, 2, 8, comm_id, n, comm_str)
+	comm_file.write(value)
+
+def comm_thread_table(comm_thread_id, comm_id, thread_id, *x):
+	fmt = "!hiqiqiq"
+	value = struct.pack(fmt, 3, 8, comm_thread_id, 8, comm_id, 8, thread_id)
+	comm_thread_file.write(value)
+
+def dso_table(dso_id, machine_id, short_name, long_name, build_id, *x):
+	n1 = len(short_name)
+	n2 = len(long_name)
+	n3 = len(build_id)
+	fmt = "!hiqiqi" + str(n1) + "si"  + str(n2) + "si" + str(n3) + "s"
+	value = struct.pack(fmt, 5, 8, dso_id, 8, machine_id, n1, short_name, n2, long_name, n3, build_id)
+	dso_file.write(value)
+
+def symbol_table(symbol_id, dso_id, sym_start, sym_end, binding, symbol_name, *x):
+	n = len(symbol_name)
+	fmt = "!hiqiqiqiqiii" + str(n) + "s"
+	value = struct.pack(fmt, 6, 8, symbol_id, 8, dso_id, 8, sym_start, 8, sym_end, 4, binding, n, symbol_name)
+	symbol_file.write(value)
+
+def branch_type_table(branch_type, name, *x):
+	n = len(name)
+	fmt = "!hiii" + str(n) + "s"
+	value = struct.pack(fmt, 2, 4, branch_type, n, name)
+	branch_type_file.write(value)
+
+def sample_table(sample_id, evsel_id, machine_id, thread_id, comm_id, dso_id, symbol_id, sym_offset, ip, time, cpu, to_dso_id, to_symbol_id, to_sym_offset, to_ip, period, weight, transaction, data_src, branch_type, in_tx, *x):
+	if branches:
+		value = struct.pack("!hiqiqiqiqiqiqiqiqiqiqiiiqiqiqiqiiiB", 17, 8, sample_id, 8, evsel_id, 8, machine_id, 8, thread_id, 8, comm_id, 8, dso_id, 8, symbol_id, 8, sym_offset, 8, ip, 8, time, 4, cpu, 8, to_dso_id, 8, to_symbol_id, 8, to_sym_offset, 8, to_ip, 4, branch_type, 1, in_tx)
+	else:
+		value = struct.pack("!hiqiqiqiqiqiqiqiqiqiqiiiqiqiqiqiqiqiqiqiiiB", 21, 8, sample_id, 8, evsel_id, 8, machine_id, 8, thread_id, 8, comm_id, 8, dso_id, 8, symbol_id, 8, sym_offset, 8, ip, 8, time, 4, cpu, 8, to_dso_id, 8, to_symbol_id, 8, to_sym_offset, 8, to_ip, 8, period, 8, weight, 8, transaction, 8, data_src, 4, branch_type, 1, in_tx)
+	sample_file.write(value)
+
+def call_path_table(cp_id, parent_id, symbol_id, ip, *x):
+	fmt = "!hiqiqiqiq"
+	value = struct.pack(fmt, 4, 8, cp_id, 8, parent_id, 8, symbol_id, 8, ip)
+	call_path_file.write(value)
+
+def call_return_table(cr_id, thread_id, comm_id, call_path_id, call_time, return_time, branch_count, call_id, return_id, parent_call_path_id, flags, *x):
+	fmt = "!hiqiqiqiqiqiqiqiqiqiqii"
+	value = struct.pack(fmt, 11, 8, cr_id, 8, thread_id, 8, comm_id, 8, call_path_id, 8, call_time, 8, return_time, 8, branch_count, 8, call_id, 8, return_id, 8, parent_call_path_id, 4, flags)
+	call_file.write(value)
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 162c978f1491..4b7d9ab0f049 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -85,7 +85,7 @@ static struct test {
 		.func = test__hists_link,
 	},
 	{
-		.desc = "Try 'use perf' in python, checking link problems",
+		.desc = "Try 'import perf' in python, checking link problems",
 		.func = test__python_use,
 	},
 	{
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 67f2d6323558..f671ec37a7c4 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -133,8 +133,7 @@ static int read_via_objdump(const char *filename, u64 addr, void *buf,
 }
 
 static int read_object_code(u64 addr, size_t len, u8 cpumode,
-			    struct thread *thread, struct machine *machine,
-			    struct state *state)
+			    struct thread *thread, struct state *state)
 {
 	struct addr_location al;
 	unsigned char buf1[BUFSZ];
@@ -145,8 +144,7 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 
 	pr_debug("Reading object code for memory address: %#"PRIx64"\n", addr);
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION, addr,
-			      &al);
+	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, addr, &al);
 	if (!al.map || !al.map->dso) {
 		pr_debug("thread__find_addr_map failed\n");
 		return -1;
@@ -170,8 +168,8 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 		len = al.map->end - addr;
 
 	/* Read the object code using perf */
-	ret_len = dso__data_read_offset(al.map->dso, machine, al.addr, buf1,
-					len);
+	ret_len = dso__data_read_offset(al.map->dso, thread->mg->machine,
+					al.addr, buf1, len);
 	if (ret_len != len) {
 		pr_debug("dso__data_read_offset failed\n");
 		return -1;
@@ -264,8 +262,7 @@ static int process_sample_event(struct machine *machine,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	return read_object_code(sample.ip, READLEN, cpumode, thread, machine,
-				state);
+	return read_object_code(sample.ip, READLEN, cpumode, thread, state);
 }
 
 static int process_event(struct machine *machine, struct perf_evlist *evlist,
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index fc25e57f4a5d..ab28cca2cb97 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -59,7 +59,7 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
 }
 
 __attribute__ ((noinline))
-static int unwind_thread(struct thread *thread, struct machine *machine)
+static int unwind_thread(struct thread *thread)
 {
 	struct perf_sample sample;
 	unsigned long cnt = 0;
@@ -72,7 +72,7 @@ static int unwind_thread(struct thread *thread, struct machine *machine)
 		goto out;
 	}
 
-	err = unwind__get_entries(unwind_entry, &cnt, machine, thread,
+	err = unwind__get_entries(unwind_entry, &cnt, thread,
 				  &sample, MAX_STACK);
 	if (err)
 		pr_debug("unwind failed\n");
@@ -89,21 +89,21 @@ static int unwind_thread(struct thread *thread, struct machine *machine)
 }
 
 __attribute__ ((noinline))
-static int krava_3(struct thread *thread, struct machine *machine)
+static int krava_3(struct thread *thread)
 {
-	return unwind_thread(thread, machine);
+	return unwind_thread(thread);
 }
 
 __attribute__ ((noinline))
-static int krava_2(struct thread *thread, struct machine *machine)
+static int krava_2(struct thread *thread)
 {
-	return krava_3(thread, machine);
+	return krava_3(thread);
 }
 
 __attribute__ ((noinline))
-static int krava_1(struct thread *thread, struct machine *machine)
+static int krava_1(struct thread *thread)
 {
-	return krava_2(thread, machine);
+	return krava_2(thread);
 }
 
 int test__dwarf_unwind(void)
@@ -137,7 +137,7 @@ int test__dwarf_unwind(void)
 		goto out;
 	}
 
-	err = krava_1(thread, machine);
+	err = krava_1(thread);
 
  out:
 	machine__delete_threads(machine);
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 5a31787cc6b9..74f257a81265 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -43,7 +43,7 @@ static struct sample fake_samples[] = {
 };
 
 static int add_hist_entries(struct perf_evlist *evlist,
-			    struct machine *machine __maybe_unused)
+			    struct machine *machine)
 {
 	struct perf_evsel *evsel;
 	struct addr_location al;
diff --git a/tools/perf/tests/mmap-thread-lookup.c b/tools/perf/tests/mmap-thread-lookup.c
index 4a456fef66ca..2113f1c8611f 100644
--- a/tools/perf/tests/mmap-thread-lookup.c
+++ b/tools/perf/tests/mmap-thread-lookup.c
@@ -187,7 +187,7 @@ static int mmap_events(synth_cb synth)
 
 		pr_debug("looking for map %p\n", td->map);
 
-		thread__find_addr_map(thread, machine,
+		thread__find_addr_map(thread,
 				      PERF_RECORD_MISC_USER, MAP__FUNCTION,
 				      (unsigned long) (td->map + 1), &al);
 
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index ca292f9a4ae2..4908c648a597 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -126,16 +126,28 @@ static bool samples_same(const struct perf_sample *s1,
 	if (type & PERF_SAMPLE_TRANSACTION)
 		COMP(transaction);
 
+	if (type & PERF_SAMPLE_REGS_INTR) {
+		size_t sz = hweight_long(s1->intr_regs.mask) * sizeof(u64);
+
+		COMP(intr_regs.mask);
+		COMP(intr_regs.abi);
+		if (s1->intr_regs.abi &&
+		    (!s1->intr_regs.regs || !s2->intr_regs.regs ||
+		     memcmp(s1->intr_regs.regs, s2->intr_regs.regs, sz))) {
+			pr_debug("Samples differ at 'intr_regs'\n");
+			return false;
+		}
+	}
+
 	return true;
 }
 
-static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
+static int do_test(u64 sample_type, u64 sample_regs, u64 read_format)
 {
 	struct perf_evsel evsel = {
 		.needs_swap = false,
 		.attr = {
 			.sample_type = sample_type,
-			.sample_regs_user = sample_regs_user,
 			.read_format = read_format,
 		},
 	};
@@ -154,7 +166,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		/* 1 branch_entry */
 		.data = {1, 211, 212, 213},
 	};
-	u64 user_regs[64];
+	u64 regs[64];
 	const u64 raw_data[] = {0x123456780a0b0c0dULL, 0x1102030405060708ULL};
 	const u64 data[] = {0x2211443366558877ULL, 0, 0xaabbccddeeff4321ULL};
 	struct perf_sample sample = {
@@ -176,8 +188,8 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		.branch_stack	= &branch_stack.branch_stack,
 		.user_regs	= {
 			.abi	= PERF_SAMPLE_REGS_ABI_64,
-			.mask	= sample_regs_user,
-			.regs	= user_regs,
+			.mask	= sample_regs,
+			.regs	= regs,
 		},
 		.user_stack	= {
 			.size	= sizeof(data),
@@ -187,14 +199,25 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 			.time_enabled = 0x030a59d664fca7deULL,
 			.time_running = 0x011b6ae553eb98edULL,
 		},
+		.intr_regs	= {
+			.abi	= PERF_SAMPLE_REGS_ABI_64,
+			.mask	= sample_regs,
+			.regs	= regs,
+		},
 	};
 	struct sample_read_value values[] = {{1, 5}, {9, 3}, {2, 7}, {6, 4},};
 	struct perf_sample sample_out;
 	size_t i, sz, bufsz;
 	int err, ret = -1;
 
-	for (i = 0; i < sizeof(user_regs); i++)
-		*(i + (u8 *)user_regs) = i & 0xfe;
+	if (sample_type & PERF_SAMPLE_REGS_USER)
+		evsel.attr.sample_regs_user = sample_regs;
+
+	if (sample_type & PERF_SAMPLE_REGS_INTR)
+		evsel.attr.sample_regs_intr = sample_regs;
+
+	for (i = 0; i < sizeof(regs); i++)
+		*(i + (u8 *)regs) = i & 0xfe;
 
 	if (read_format & PERF_FORMAT_GROUP) {
 		sample.read.group.nr     = 4;
@@ -271,7 +294,7 @@ int test__sample_parsing(void)
 {
 	const u64 rf[] = {4, 5, 6, 7, 12, 13, 14, 15};
 	u64 sample_type;
-	u64 sample_regs_user;
+	u64 sample_regs;
 	size_t i;
 	int err;
 
@@ -280,7 +303,7 @@ int test__sample_parsing(void)
 	 * were added.  Please actually update the test rather than just change
 	 * the condition below.
 	 */
-	if (PERF_SAMPLE_MAX > PERF_SAMPLE_TRANSACTION << 1) {
+	if (PERF_SAMPLE_MAX > PERF_SAMPLE_REGS_INTR << 1) {
 		pr_debug("sample format has changed, some new PERF_SAMPLE_ bit was introduced - test needs updating\n");
 		return -1;
 	}
@@ -297,22 +320,24 @@ int test__sample_parsing(void)
 			}
 			continue;
 		}
+		sample_regs = 0;
 
 		if (sample_type == PERF_SAMPLE_REGS_USER)
-			sample_regs_user = 0x3fff;
-		else
-			sample_regs_user = 0;
+			sample_regs = 0x3fff;
+
+		if (sample_type == PERF_SAMPLE_REGS_INTR)
+			sample_regs = 0xff0fff;
 
-		err = do_test(sample_type, sample_regs_user, 0);
+		err = do_test(sample_type, sample_regs, 0);
 		if (err)
 			return err;
 	}
 
 	/* Test all sample format bits together */
 	sample_type = PERF_SAMPLE_MAX - 1;
-	sample_regs_user = 0x3fff;
+	sample_regs = 0x3fff; /* shared yb intr and user regs */
 	for (i = 0; i < ARRAY_SIZE(rf); i++) {
-		err = do_test(sample_type, sample_regs_user, rf[i]);
+		err = do_test(sample_type, sample_regs, rf[i]);
 		if (err)
 			return err;
 	}
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index f0697a3aede0..1e0a2fd80115 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -27,6 +27,7 @@ static struct annotate_browser_opt {
 	bool hide_src_code,
 	     use_offset,
 	     jump_arrows,
+	     show_linenr,
 	     show_nr_jumps;
 } annotate_browser__opts = {
 	.use_offset	= true,
@@ -128,7 +129,11 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 	if (!*dl->line)
 		slsmg_write_nstring(" ", width - pcnt_width);
 	else if (dl->offset == -1) {
-		printed = scnprintf(bf, sizeof(bf), "%*s  ",
+		if (dl->line_nr && annotate_browser__opts.show_linenr)
+			printed = scnprintf(bf, sizeof(bf), "%-*d ",
+					ab->addr_width + 1, dl->line_nr);
+		else
+			printed = scnprintf(bf, sizeof(bf), "%*s  ",
 				    ab->addr_width, " ");
 		slsmg_write_nstring(bf, printed);
 		slsmg_write_nstring(dl->line, width - printed - pcnt_width + 1);
@@ -733,6 +738,7 @@ static int annotate_browser__run(struct annotate_browser *browser,
 		"o             Toggle disassembler output/simplified view\n"
 		"s             Toggle source code view\n"
 		"/             Search string\n"
+		"k             Toggle line numbers\n"
 		"r             Run available scripts\n"
 		"?             Search string backwards\n");
 			continue;
@@ -741,6 +747,10 @@ static int annotate_browser__run(struct annotate_browser *browser,
 				script_browse(NULL);
 				continue;
 			}
+		case 'k':
+			annotate_browser__opts.show_linenr =
+				!annotate_browser__opts.show_linenr;
+			break;
 		case 'H':
 			nd = browser->curr_hot;
 			break;
@@ -984,6 +994,7 @@ static struct annotate_config {
 } annotate__configs[] = {
 	ANNOTATE_CFG(hide_src_code),
 	ANNOTATE_CFG(jump_arrows),
+	ANNOTATE_CFG(show_linenr),
 	ANNOTATE_CFG(show_nr_jumps),
 	ANNOTATE_CFG(use_offset),
 };
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index cfb976b3de3a..502daff76ceb 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -227,10 +227,14 @@ static void callchain_node__init_have_children_rb_tree(struct callchain_node *no
 	}
 }
 
-static void callchain_node__init_have_children(struct callchain_node *node)
+static void callchain_node__init_have_children(struct callchain_node *node,
+					       bool has_sibling)
 {
 	struct callchain_list *chain;
 
+	chain = list_entry(node->val.next, struct callchain_list, list);
+	chain->ms.has_children = has_sibling;
+
 	if (!list_empty(&node->val)) {
 		chain = list_entry(node->val.prev, struct callchain_list, list);
 		chain->ms.has_children = !RB_EMPTY_ROOT(&node->rb_root);
@@ -241,11 +245,12 @@ static void callchain_node__init_have_children(struct callchain_node *node)
 
 static void callchain__init_have_children(struct rb_root *root)
 {
-	struct rb_node *nd;
+	struct rb_node *nd = rb_first(root);
+	bool has_sibling = nd && rb_next(nd);
 
 	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
 		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
-		callchain_node__init_have_children(node);
+		callchain_node__init_have_children(node, has_sibling);
 	}
 }
 
@@ -463,23 +468,6 @@ static int hist_browser__run(struct hist_browser *browser,
 	return key;
 }
 
-static char *callchain_list__sym_name(struct callchain_list *cl,
-				      char *bf, size_t bfsize, bool show_dso)
-{
-	int printed;
-
-	if (cl->ms.sym)
-		printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
-	else
-		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
-
-	if (show_dso)
-		scnprintf(bf + printed, bfsize - printed, " %s",
-			  cl->ms.map ? cl->ms.map->dso->short_name : "unknown");
-
-	return bf;
-}
-
 struct callchain_print_arg {
 	/* for hists browser */
 	off_t	row_offset;
@@ -559,8 +547,11 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	struct rb_node *node;
 	int first_row = row, offset = level * LEVEL_OFFSET_STEP;
 	u64 new_total;
+	bool need_percent;
 
 	node = rb_first(root);
+	need_percent = !!rb_next(node);
+
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
 		struct rb_node *next = rb_next(node);
@@ -577,7 +568,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 
 			if (first)
 				first = false;
-			else if (level > 1)
+			else if (need_percent)
 				extra_offset = LEVEL_OFFSET_STEP;
 
 			folded_sign = callchain_list__folded(chain);
@@ -590,7 +581,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 			str = callchain_list__sym_name(chain, bf, sizeof(bf),
 						       browser->show_dso);
 
-			if (was_first && level > 1) {
+			if (was_first && need_percent) {
 				double percent = cumul * 100.0 / total;
 
 				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
@@ -807,6 +798,13 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			.is_current_entry = current_entry,
 		};
 
+		if (callchain_param.mode == CHAIN_GRAPH_REL) {
+			if (symbol_conf.cumulate_callchain)
+				total = entry->stat_acc->period;
+			else
+				total = entry->stat.period;
+		}
+
 		printed += hist_browser__show_callchain(browser,
 					&entry->sorted_chain, 1, row, total,
 					hist_browser__show_callchain_entry, &arg,
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index fc654fb77ace..4b3585eed1e8 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -89,15 +89,6 @@ void perf_gtk__init_hpp(void)
 				perf_gtk__hpp_color_overhead_acc;
 }
 
-static void callchain_list__sym_name(struct callchain_list *cl,
-				     char *bf, size_t bfsize)
-{
-	if (cl->ms.sym)
-		scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
-	else
-		scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
-}
-
 static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 				    GtkTreeIter *parent, int col, u64 total)
 {
@@ -128,7 +119,7 @@ static void perf_gtk__add_callchain(struct rb_root *root, GtkTreeStore *store,
 			scnprintf(buf, sizeof(buf), "%5.2f%%", percent);
 			gtk_tree_store_set(store, &iter, 0, buf, -1);
 
-			callchain_list__sym_name(chain, buf, sizeof(buf));
+			callchain_list__sym_name(chain, buf, sizeof(buf), false);
 			gtk_tree_store_set(store, &iter, col, buf, -1);
 
 			if (need_new_parent) {
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 15b451acbde6..dfcbc90146ef 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -41,6 +41,7 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 {
 	int i;
 	size_t ret = 0;
+	char bf[1024];
 
 	ret += callchain__fprintf_left_margin(fp, left_margin);
 	for (i = 0; i < depth; i++) {
@@ -56,11 +57,8 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 		} else
 			ret += fprintf(fp, "%s", "          ");
 	}
-	if (chain->ms.sym)
-		ret += fprintf(fp, "%s\n", chain->ms.sym->name);
-	else
-		ret += fprintf(fp, "0x%0" PRIx64 "\n", chain->ip);
-
+	fputs(callchain_list__sym_name(chain, bf, sizeof(bf), false), fp);
+	fputc('\n', fp);
 	return ret;
 }
 
@@ -168,6 +166,7 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 	struct rb_node *node;
 	int i = 0;
 	int ret = 0;
+	char bf[1024];
 
 	/*
 	 * If have one single callchain root, don't bother printing
@@ -196,10 +195,8 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 			} else
 				ret += callchain__fprintf_left_margin(fp, left_margin);
 
-			if (chain->ms.sym)
-				ret += fprintf(fp, " %s\n", chain->ms.sym->name);
-			else
-				ret += fprintf(fp, " %p\n", (void *)(long)chain->ip);
+			ret += fprintf(fp, "%s\n", callchain_list__sym_name(chain, bf, sizeof(bf),
+							false));
 
 			if (++entries_printed == callchain_param.print_limit)
 				break;
@@ -219,6 +216,7 @@ static size_t __callchain__fprintf_flat(FILE *fp, struct callchain_node *node,
 {
 	struct callchain_list *chain;
 	size_t ret = 0;
+	char bf[1024];
 
 	if (!node)
 		return 0;
@@ -229,11 +227,8 @@ static size_t __callchain__fprintf_flat(FILE *fp, struct callchain_node *node,
 	list_for_each_entry(chain, &node->val, list) {
 		if (chain->ip >= PERF_CONTEXT_MAX)
 			continue;
-		if (chain->ms.sym)
-			ret += fprintf(fp, "                %s\n", chain->ms.sym->name);
-		else
-			ret += fprintf(fp, "                %p\n",
-					(void *)(long)chain->ip);
+		ret += fprintf(fp, "                %s\n", callchain_list__sym_name(chain,
+					bf, sizeof(bf), false));
 	}
 
 	return ret;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7dabde14ea54..79999ceaf2be 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -17,11 +17,13 @@
 #include "debug.h"
 #include "annotate.h"
 #include "evsel.h"
+#include <regex.h>
 #include <pthread.h>
 #include <linux/bitops.h>
 
 const char 	*disassembler_style;
 const char	*objdump_path;
+static regex_t	 file_lineno;
 
 static struct ins *ins__find(const char *name);
 static int disasm_line__parse(char *line, char **namep, char **rawp);
@@ -570,13 +572,15 @@ static int disasm_line__parse(char *line, char **namep, char **rawp)
 	return -1;
 }
 
-static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privsize)
+static struct disasm_line *disasm_line__new(s64 offset, char *line,
+					size_t privsize, int line_nr)
 {
 	struct disasm_line *dl = zalloc(sizeof(*dl) + privsize);
 
 	if (dl != NULL) {
 		dl->offset = offset;
 		dl->line = strdup(line);
+		dl->line_nr = line_nr;
 		if (dl->line == NULL)
 			goto out_delete;
 
@@ -788,13 +792,15 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
  * The ops.raw part will be parsed further according to type of the instruction.
  */
 static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
-				      FILE *file, size_t privsize)
+				      FILE *file, size_t privsize,
+				      int *line_nr)
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct disasm_line *dl;
 	char *line = NULL, *parsed_line, *tmp, *tmp2, *c;
 	size_t line_len;
 	s64 line_ip, offset = -1;
+	regmatch_t match[2];
 
 	if (getline(&line, &line_len, file) < 0)
 		return -1;
@@ -812,6 +818,12 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 	line_ip = -1;
 	parsed_line = line;
 
+	/* /filename:linenr ? Save line number and ignore. */
+	if (regexec(&file_lineno, line, 2, match, 0) == 0) {
+		*line_nr = atoi(line + match[1].rm_so);
+		return 0;
+	}
+
 	/*
 	 * Strip leading spaces:
 	 */
@@ -842,8 +854,9 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 			parsed_line = tmp2 + 1;
 	}
 
-	dl = disasm_line__new(offset, parsed_line, privsize);
+	dl = disasm_line__new(offset, parsed_line, privsize, *line_nr);
 	free(line);
+	(*line_nr)++;
 
 	if (dl == NULL)
 		return -1;
@@ -869,6 +882,11 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 	return 0;
 }
 
+static __attribute__((constructor)) void symbol__init_regexpr(void)
+{
+	regcomp(&file_lineno, "^/[^:]+:([0-9]+)", REG_EXTENDED);
+}
+
 static void delete_last_nop(struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
@@ -904,6 +922,7 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 	char symfs_filename[PATH_MAX];
 	struct kcore_extract kce;
 	bool delete_extract = false;
+	int lineno = 0;
 
 	if (filename)
 		symbol__join_symfs(symfs_filename, filename);
@@ -915,6 +934,8 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 			return -ENOMEM;
 		}
 		goto fallback;
+	} else if (dso__is_kcore(dso)) {
+		goto fallback;
 	} else if (readlink(symfs_filename, command, sizeof(command)) < 0 ||
 		   strstr(command, "[kernel.kallsyms]") ||
 		   access(symfs_filename, R_OK)) {
@@ -982,7 +1003,7 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 	snprintf(command, sizeof(command),
 		 "%s %s%s --start-address=0x%016" PRIx64
 		 " --stop-address=0x%016" PRIx64
-		 " -d %s %s -C %s 2>/dev/null|grep -v %s|expand",
+		 " -l -d %s %s -C %s 2>/dev/null|grep -v %s|expand",
 		 objdump_path ? objdump_path : "objdump",
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
@@ -999,7 +1020,8 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 		goto out_free_filename;
 
 	while (!feof(file))
-		if (symbol__parse_objdump_line(sym, map, file, privsize) < 0)
+		if (symbol__parse_objdump_line(sym, map, file, privsize,
+			    &lineno) < 0)
 			break;
 
 	/*
@@ -1170,7 +1192,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 			goto next;
 
 		offset = start + i;
-		src_line->path = get_srcline(map->dso, offset);
+		src_line->path = get_srcline(map->dso, offset, NULL, false);
 		insert_source_line(&tmp_root, src_line);
 
 	next:
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 112d6e268150..0784a9420528 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -58,6 +58,7 @@ struct disasm_line {
 	char		    *line;
 	char		    *name;
 	struct ins	    *ins;
+	int		    line_nr;
 	struct ins_operands ops;
 };
 
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index a904a4cfe7d3..e8d79e5bfaf7 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -15,6 +15,11 @@
 #include "debug.h"
 #include "session.h"
 #include "tool.h"
+#include "header.h"
+#include "vdso.h"
+
+
+static bool no_buildid_cache;
 
 int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 			   union perf_event *event,
@@ -33,8 +38,7 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->ip, &al);
+	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, sample->ip, &al);
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
@@ -106,3 +110,343 @@ char *dso__build_id_filename(const struct dso *dso, char *bf, size_t size)
 			 build_id_hex, build_id_hex + 2);
 	return bf;
 }
+
+#define dsos__for_each_with_build_id(pos, head)	\
+	list_for_each_entry(pos, head, node)	\
+		if (!pos->has_build_id)		\
+			continue;		\
+		else
+
+static int write_buildid(const char *name, size_t name_len, u8 *build_id,
+			 pid_t pid, u16 misc, int fd)
+{
+	int err;
+	struct build_id_event b;
+	size_t len;
+
+	len = name_len + 1;
+	len = PERF_ALIGN(len, NAME_ALIGN);
+
+	memset(&b, 0, sizeof(b));
+	memcpy(&b.build_id, build_id, BUILD_ID_SIZE);
+	b.pid = pid;
+	b.header.misc = misc;
+	b.header.size = sizeof(b) + len;
+
+	err = writen(fd, &b, sizeof(b));
+	if (err < 0)
+		return err;
+
+	return write_padded(fd, name, name_len + 1, len);
+}
+
+static int __dsos__write_buildid_table(struct list_head *head,
+				       struct machine *machine,
+				       pid_t pid, u16 misc, int fd)
+{
+	char nm[PATH_MAX];
+	struct dso *pos;
+
+	dsos__for_each_with_build_id(pos, head) {
+		int err;
+		const char *name;
+		size_t name_len;
+
+		if (!pos->hit)
+			continue;
+
+		if (dso__is_vdso(pos)) {
+			name = pos->short_name;
+			name_len = pos->short_name_len + 1;
+		} else if (dso__is_kcore(pos)) {
+			machine__mmap_name(machine, nm, sizeof(nm));
+			name = nm;
+			name_len = strlen(nm) + 1;
+		} else {
+			name = pos->long_name;
+			name_len = pos->long_name_len + 1;
+		}
+
+		err = write_buildid(name, name_len, pos->build_id,
+				    pid, misc, fd);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int machine__write_buildid_table(struct machine *machine, int fd)
+{
+	int err;
+	u16 kmisc = PERF_RECORD_MISC_KERNEL,
+	    umisc = PERF_RECORD_MISC_USER;
+
+	if (!machine__is_host(machine)) {
+		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
+		umisc = PERF_RECORD_MISC_GUEST_USER;
+	}
+
+	err = __dsos__write_buildid_table(&machine->kernel_dsos.head, machine,
+					  machine->pid, kmisc, fd);
+	if (err == 0)
+		err = __dsos__write_buildid_table(&machine->user_dsos.head,
+						  machine, machine->pid, umisc,
+						  fd);
+	return err;
+}
+
+int perf_session__write_buildid_table(struct perf_session *session, int fd)
+{
+	struct rb_node *nd;
+	int err = machine__write_buildid_table(&session->machines.host, fd);
+
+	if (err)
+		return err;
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		err = machine__write_buildid_table(pos, fd);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+static int __dsos__hit_all(struct list_head *head)
+{
+	struct dso *pos;
+
+	list_for_each_entry(pos, head, node)
+		pos->hit = true;
+
+	return 0;
+}
+
+static int machine__hit_all_dsos(struct machine *machine)
+{
+	int err;
+
+	err = __dsos__hit_all(&machine->kernel_dsos.head);
+	if (err)
+		return err;
+
+	return __dsos__hit_all(&machine->user_dsos.head);
+}
+
+int dsos__hit_all(struct perf_session *session)
+{
+	struct rb_node *nd;
+	int err;
+
+	err = machine__hit_all_dsos(&session->machines.host);
+	if (err)
+		return err;
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+
+		err = machine__hit_all_dsos(pos);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+void disable_buildid_cache(void)
+{
+	no_buildid_cache = true;
+}
+
+int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
+			  const char *name, bool is_kallsyms, bool is_vdso)
+{
+	const size_t size = PATH_MAX;
+	char *realname, *filename = zalloc(size),
+	     *linkname = zalloc(size), *targetname;
+	int len, err = -1;
+	bool slash = is_kallsyms || is_vdso;
+
+	if (is_kallsyms) {
+		if (symbol_conf.kptr_restrict) {
+			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
+			err = 0;
+			goto out_free;
+		}
+		realname = (char *) name;
+	} else
+		realname = realpath(name, NULL);
+
+	if (realname == NULL || filename == NULL || linkname == NULL)
+		goto out_free;
+
+	len = scnprintf(filename, size, "%s%s%s",
+		       debugdir, slash ? "/" : "",
+		       is_vdso ? DSO__NAME_VDSO : realname);
+	if (mkdir_p(filename, 0755))
+		goto out_free;
+
+	snprintf(filename + len, size - len, "/%s", sbuild_id);
+
+	if (access(filename, F_OK)) {
+		if (is_kallsyms) {
+			 if (copyfile("/proc/kallsyms", filename))
+				goto out_free;
+		} else if (link(realname, filename) && copyfile(name, filename))
+			goto out_free;
+	}
+
+	len = scnprintf(linkname, size, "%s/.build-id/%.2s",
+		       debugdir, sbuild_id);
+
+	if (access(linkname, X_OK) && mkdir_p(linkname, 0755))
+		goto out_free;
+
+	snprintf(linkname + len, size - len, "/%s", sbuild_id + 2);
+	targetname = filename + strlen(debugdir) - 5;
+	memcpy(targetname, "../..", 5);
+
+	if (symlink(targetname, linkname) == 0)
+		err = 0;
+out_free:
+	if (!is_kallsyms)
+		free(realname);
+	free(filename);
+	free(linkname);
+	return err;
+}
+
+static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
+				 const char *name, const char *debugdir,
+				 bool is_kallsyms, bool is_vdso)
+{
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	build_id__sprintf(build_id, build_id_size, sbuild_id);
+
+	return build_id_cache__add_s(sbuild_id, debugdir, name,
+				     is_kallsyms, is_vdso);
+}
+
+int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
+{
+	const size_t size = PATH_MAX;
+	char *filename = zalloc(size),
+	     *linkname = zalloc(size);
+	int err = -1;
+
+	if (filename == NULL || linkname == NULL)
+		goto out_free;
+
+	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
+		 debugdir, sbuild_id, sbuild_id + 2);
+
+	if (access(linkname, F_OK))
+		goto out_free;
+
+	if (readlink(linkname, filename, size - 1) < 0)
+		goto out_free;
+
+	if (unlink(linkname))
+		goto out_free;
+
+	/*
+	 * Since the link is relative, we must make it absolute:
+	 */
+	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
+		 debugdir, sbuild_id, filename);
+
+	if (unlink(linkname))
+		goto out_free;
+
+	err = 0;
+out_free:
+	free(filename);
+	free(linkname);
+	return err;
+}
+
+static int dso__cache_build_id(struct dso *dso, struct machine *machine,
+			       const char *debugdir)
+{
+	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
+	bool is_vdso = dso__is_vdso(dso);
+	const char *name = dso->long_name;
+	char nm[PATH_MAX];
+
+	if (dso__is_kcore(dso)) {
+		is_kallsyms = true;
+		machine__mmap_name(machine, nm, sizeof(nm));
+		name = nm;
+	}
+	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id), name,
+				     debugdir, is_kallsyms, is_vdso);
+}
+
+static int __dsos__cache_build_ids(struct list_head *head,
+				   struct machine *machine, const char *debugdir)
+{
+	struct dso *pos;
+	int err = 0;
+
+	dsos__for_each_with_build_id(pos, head)
+		if (dso__cache_build_id(pos, machine, debugdir))
+			err = -1;
+
+	return err;
+}
+
+static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
+{
+	int ret = __dsos__cache_build_ids(&machine->kernel_dsos.head, machine,
+					  debugdir);
+	ret |= __dsos__cache_build_ids(&machine->user_dsos.head, machine,
+				       debugdir);
+	return ret;
+}
+
+int perf_session__cache_build_ids(struct perf_session *session)
+{
+	struct rb_node *nd;
+	int ret;
+	char debugdir[PATH_MAX];
+
+	if (no_buildid_cache)
+		return 0;
+
+	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
+
+	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
+		return -1;
+
+	ret = machine__cache_build_ids(&session->machines.host, debugdir);
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret |= machine__cache_build_ids(pos, debugdir);
+	}
+	return ret ? -1 : 0;
+}
+
+static bool machine__read_build_ids(struct machine *machine, bool with_hits)
+{
+	bool ret;
+
+	ret  = __dsos__read_build_ids(&machine->kernel_dsos.head, with_hits);
+	ret |= __dsos__read_build_ids(&machine->user_dsos.head, with_hits);
+	return ret;
+}
+
+bool perf_session__read_build_ids(struct perf_session *session, bool with_hits)
+{
+	struct rb_node *nd;
+	bool ret = machine__read_build_ids(&session->machines.host, with_hits);
+
+	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		ret |= machine__read_build_ids(pos, with_hits);
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index ae392561470b..8236319514d5 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -15,4 +15,16 @@ char *dso__build_id_filename(const struct dso *dso, char *bf, size_t size);
 int build_id__mark_dso_hit(struct perf_tool *tool, union perf_event *event,
 			   struct perf_sample *sample, struct perf_evsel *evsel,
 			   struct machine *machine);
+
+int dsos__hit_all(struct perf_session *session);
+
+bool perf_session__read_build_ids(struct perf_session *session, bool with_hits);
+int perf_session__write_buildid_table(struct perf_session *session, int fd);
+int perf_session__cache_build_ids(struct perf_session *session);
+
+int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
+			  const char *name, bool is_kallsyms, bool is_vdso);
+int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
+void disable_buildid_cache(void);
+
 #endif
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index c84d3f8dcb75..cf524a35cc84 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -149,6 +149,10 @@ static int parse_callchain_sort_key(const char *value)
 		callchain_param.key = CCKEY_ADDRESS;
 		return 0;
 	}
+	if (!strncmp(value, "branch", strlen(value))) {
+		callchain_param.branch_callstack = 1;
+		return 0;
+	}
 	return -1;
 }
 
@@ -754,8 +758,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 
 	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain ||
 	    sort__has_parent) {
-		return machine__resolve_callchain(al->machine, evsel, al->thread,
-						  sample, parent, al, max_stack);
+		return thread__resolve_callchain(al->thread, evsel, sample,
+						 parent, al, max_stack);
 	}
 	return 0;
 }
@@ -808,3 +812,32 @@ int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *
 out:
 	return 1;
 }
+
+char *callchain_list__sym_name(struct callchain_list *cl,
+			       char *bf, size_t bfsize, bool show_dso)
+{
+	int printed;
+
+	if (cl->ms.sym) {
+		if (callchain_param.key == CCKEY_ADDRESS &&
+		    cl->ms.map && !cl->srcline)
+			cl->srcline = get_srcline(cl->ms.map->dso,
+						  map__rip_2objdump(cl->ms.map,
+								    cl->ip),
+						  cl->ms.sym, false);
+		if (cl->srcline)
+			printed = scnprintf(bf, bfsize, "%s %s",
+					cl->ms.sym->name, cl->srcline);
+		else
+			printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
+	} else
+		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
+
+	if (show_dso)
+		scnprintf(bf + printed, bfsize - printed, " %s",
+			  cl->ms.map ?
+			  cl->ms.map->dso->short_name :
+			  "unknown");
+
+	return bf;
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 94cfefddf4db..dbc08cf5f970 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -63,6 +63,7 @@ struct callchain_param {
 	sort_chain_func_t	sort;
 	enum chain_order	order;
 	enum chain_key		key;
+	bool			branch_callstack;
 };
 
 extern struct callchain_param callchain_param;
@@ -70,6 +71,7 @@ extern struct callchain_param callchain_param;
 struct callchain_list {
 	u64			ip;
 	struct map_symbol	ms;
+	char		       *srcline;
 	struct list_head	list;
 };
 
@@ -184,15 +186,16 @@ static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
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
 }
 #endif
 
+char *callchain_list__sym_name(struct callchain_list *cl,
+			       char *bf, size_t bfsize, bool show_dso);
+
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
index 51c10ab257f8..71c9c39340d4 100644
--- a/tools/perf/util/comm.h
+++ b/tools/perf/util/comm.h
@@ -12,6 +12,10 @@ struct comm {
 	u64 start;
 	struct list_head list;
 	bool exec;
+	union { /* Tool specific area */
+		void	*priv;
+		u64	db_id;
+	};
 };
 
 void comm__free(struct comm *comm);
diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
new file mode 100644
index 000000000000..c81dae399763
--- /dev/null
+++ b/tools/perf/util/db-export.c
@@ -0,0 +1,428 @@
+/*
+ * db-export.c: Support for exporting data suitable for import to a database
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <errno.h>
+
+#include "evsel.h"
+#include "machine.h"
+#include "thread.h"
+#include "comm.h"
+#include "symbol.h"
+#include "event.h"
+#include "util.h"
+#include "thread-stack.h"
+#include "db-export.h"
+
+struct deferred_export {
+	struct list_head node;
+	struct comm *comm;
+};
+
+static int db_export__deferred(struct db_export *dbe)
+{
+	struct deferred_export *de;
+	int err;
+
+	while (!list_empty(&dbe->deferred)) {
+		de = list_entry(dbe->deferred.next, struct deferred_export,
+				node);
+		err = dbe->export_comm(dbe, de->comm);
+		list_del(&de->node);
+		free(de);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void db_export__free_deferred(struct db_export *dbe)
+{
+	struct deferred_export *de;
+
+	while (!list_empty(&dbe->deferred)) {
+		de = list_entry(dbe->deferred.next, struct deferred_export,
+				node);
+		list_del(&de->node);
+		free(de);
+	}
+}
+
+static int db_export__defer_comm(struct db_export *dbe, struct comm *comm)
+{
+	struct deferred_export *de;
+
+	de = zalloc(sizeof(struct deferred_export));
+	if (!de)
+		return -ENOMEM;
+
+	de->comm = comm;
+	list_add_tail(&de->node, &dbe->deferred);
+
+	return 0;
+}
+
+int db_export__init(struct db_export *dbe)
+{
+	memset(dbe, 0, sizeof(struct db_export));
+	INIT_LIST_HEAD(&dbe->deferred);
+	return 0;
+}
+
+int db_export__flush(struct db_export *dbe)
+{
+	return db_export__deferred(dbe);
+}
+
+void db_export__exit(struct db_export *dbe)
+{
+	db_export__free_deferred(dbe);
+	call_return_processor__free(dbe->crp);
+	dbe->crp = NULL;
+}
+
+int db_export__evsel(struct db_export *dbe, struct perf_evsel *evsel)
+{
+	if (evsel->db_id)
+		return 0;
+
+	evsel->db_id = ++dbe->evsel_last_db_id;
+
+	if (dbe->export_evsel)
+		return dbe->export_evsel(dbe, evsel);
+
+	return 0;
+}
+
+int db_export__machine(struct db_export *dbe, struct machine *machine)
+{
+	if (machine->db_id)
+		return 0;
+
+	machine->db_id = ++dbe->machine_last_db_id;
+
+	if (dbe->export_machine)
+		return dbe->export_machine(dbe, machine);
+
+	return 0;
+}
+
+int db_export__thread(struct db_export *dbe, struct thread *thread,
+		      struct machine *machine, struct comm *comm)
+{
+	u64 main_thread_db_id = 0;
+	int err;
+
+	if (thread->db_id)
+		return 0;
+
+	thread->db_id = ++dbe->thread_last_db_id;
+
+	if (thread->pid_ != -1) {
+		struct thread *main_thread;
+
+		if (thread->pid_ == thread->tid) {
+			main_thread = thread;
+		} else {
+			main_thread = machine__findnew_thread(machine,
+							      thread->pid_,
+							      thread->pid_);
+			if (!main_thread)
+				return -ENOMEM;
+			err = db_export__thread(dbe, main_thread, machine,
+						comm);
+			if (err)
+				return err;
+			if (comm) {
+				err = db_export__comm_thread(dbe, comm, thread);
+				if (err)
+					return err;
+			}
+		}
+		main_thread_db_id = main_thread->db_id;
+	}
+
+	if (dbe->export_thread)
+		return dbe->export_thread(dbe, thread, main_thread_db_id,
+					  machine);
+
+	return 0;
+}
+
+int db_export__comm(struct db_export *dbe, struct comm *comm,
+		    struct thread *main_thread)
+{
+	int err;
+
+	if (comm->db_id)
+		return 0;
+
+	comm->db_id = ++dbe->comm_last_db_id;
+
+	if (dbe->export_comm) {
+		if (main_thread->comm_set)
+			err = dbe->export_comm(dbe, comm);
+		else
+			err = db_export__defer_comm(dbe, comm);
+		if (err)
+			return err;
+	}
+
+	return db_export__comm_thread(dbe, comm, main_thread);
+}
+
+int db_export__comm_thread(struct db_export *dbe, struct comm *comm,
+			   struct thread *thread)
+{
+	u64 db_id;
+
+	db_id = ++dbe->comm_thread_last_db_id;
+
+	if (dbe->export_comm_thread)
+		return dbe->export_comm_thread(dbe, db_id, comm, thread);
+
+	return 0;
+}
+
+int db_export__dso(struct db_export *dbe, struct dso *dso,
+		   struct machine *machine)
+{
+	if (dso->db_id)
+		return 0;
+
+	dso->db_id = ++dbe->dso_last_db_id;
+
+	if (dbe->export_dso)
+		return dbe->export_dso(dbe, dso, machine);
+
+	return 0;
+}
+
+int db_export__symbol(struct db_export *dbe, struct symbol *sym,
+		      struct dso *dso)
+{
+	u64 *sym_db_id = symbol__priv(sym);
+
+	if (*sym_db_id)
+		return 0;
+
+	*sym_db_id = ++dbe->symbol_last_db_id;
+
+	if (dbe->export_symbol)
+		return dbe->export_symbol(dbe, sym, dso);
+
+	return 0;
+}
+
+static struct thread *get_main_thread(struct machine *machine, struct thread *thread)
+{
+	if (thread->pid_ == thread->tid)
+		return thread;
+
+	if (thread->pid_ == -1)
+		return NULL;
+
+	return machine__find_thread(machine, thread->pid_, thread->pid_);
+}
+
+static int db_ids_from_al(struct db_export *dbe, struct addr_location *al,
+			  u64 *dso_db_id, u64 *sym_db_id, u64 *offset)
+{
+	int err;
+
+	if (al->map) {
+		struct dso *dso = al->map->dso;
+
+		err = db_export__dso(dbe, dso, al->machine);
+		if (err)
+			return err;
+		*dso_db_id = dso->db_id;
+
+		if (!al->sym) {
+			al->sym = symbol__new(al->addr, 0, 0, "unknown");
+			if (al->sym)
+				symbols__insert(&dso->symbols[al->map->type],
+						al->sym);
+		}
+
+		if (al->sym) {
+			u64 *db_id = symbol__priv(al->sym);
+
+			err = db_export__symbol(dbe, al->sym, dso);
+			if (err)
+				return err;
+			*sym_db_id = *db_id;
+			*offset = al->addr - al->sym->start;
+		}
+	}
+
+	return 0;
+}
+
+int db_export__branch_type(struct db_export *dbe, u32 branch_type,
+			   const char *name)
+{
+	if (dbe->export_branch_type)
+		return dbe->export_branch_type(dbe, branch_type, name);
+
+	return 0;
+}
+
+int db_export__sample(struct db_export *dbe, union perf_event *event,
+		      struct perf_sample *sample, struct perf_evsel *evsel,
+		      struct thread *thread, struct addr_location *al)
+{
+	struct export_sample es = {
+		.event = event,
+		.sample = sample,
+		.evsel = evsel,
+		.thread = thread,
+		.al = al,
+	};
+	struct thread *main_thread;
+	struct comm *comm = NULL;
+	int err;
+
+	err = db_export__evsel(dbe, evsel);
+	if (err)
+		return err;
+
+	err = db_export__machine(dbe, al->machine);
+	if (err)
+		return err;
+
+	main_thread = get_main_thread(al->machine, thread);
+	if (main_thread)
+		comm = machine__thread_exec_comm(al->machine, main_thread);
+
+	err = db_export__thread(dbe, thread, al->machine, comm);
+	if (err)
+		return err;
+
+	if (comm) {
+		err = db_export__comm(dbe, comm, main_thread);
+		if (err)
+			return err;
+		es.comm_db_id = comm->db_id;
+	}
+
+	es.db_id = ++dbe->sample_last_db_id;
+
+	err = db_ids_from_al(dbe, al, &es.dso_db_id, &es.sym_db_id, &es.offset);
+	if (err)
+		return err;
+
+	if ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
+	    sample_addr_correlates_sym(&evsel->attr)) {
+		struct addr_location addr_al;
+
+		perf_event__preprocess_sample_addr(event, sample, thread, &addr_al);
+		err = db_ids_from_al(dbe, &addr_al, &es.addr_dso_db_id,
+				     &es.addr_sym_db_id, &es.addr_offset);
+		if (err)
+			return err;
+		if (dbe->crp) {
+			err = thread_stack__process(thread, comm, sample, al,
+						    &addr_al, es.db_id,
+						    dbe->crp);
+			if (err)
+				return err;
+		}
+	}
+
+	if (dbe->export_sample)
+		return dbe->export_sample(dbe, &es);
+
+	return 0;
+}
+
+static struct {
+	u32 branch_type;
+	const char *name;
+} branch_types[] = {
+	{0, "no branch"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL, "call"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_RETURN, "return"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CONDITIONAL, "conditional jump"},
+	{PERF_IP_FLAG_BRANCH, "unconditional jump"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL | PERF_IP_FLAG_INTERRUPT,
+	 "software interrupt"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_RETURN | PERF_IP_FLAG_INTERRUPT,
+	 "return from interrupt"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL | PERF_IP_FLAG_SYSCALLRET,
+	 "system call"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_RETURN | PERF_IP_FLAG_SYSCALLRET,
+	 "return from system call"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_ASYNC, "asynchronous branch"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL | PERF_IP_FLAG_ASYNC |
+	 PERF_IP_FLAG_INTERRUPT, "hardware interrupt"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_TX_ABORT, "transaction abort"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_TRACE_BEGIN, "trace begin"},
+	{PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_TRACE_END, "trace end"},
+	{0, NULL}
+};
+
+int db_export__branch_types(struct db_export *dbe)
+{
+	int i, err = 0;
+
+	for (i = 0; branch_types[i].name ; i++) {
+		err = db_export__branch_type(dbe, branch_types[i].branch_type,
+					     branch_types[i].name);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+int db_export__call_path(struct db_export *dbe, struct call_path *cp)
+{
+	int err;
+
+	if (cp->db_id)
+		return 0;
+
+	if (cp->parent) {
+		err = db_export__call_path(dbe, cp->parent);
+		if (err)
+			return err;
+	}
+
+	cp->db_id = ++dbe->call_path_last_db_id;
+
+	if (dbe->export_call_path)
+		return dbe->export_call_path(dbe, cp);
+
+	return 0;
+}
+
+int db_export__call_return(struct db_export *dbe, struct call_return *cr)
+{
+	int err;
+
+	if (cr->db_id)
+		return 0;
+
+	err = db_export__call_path(dbe, cr->cp);
+	if (err)
+		return err;
+
+	cr->db_id = ++dbe->call_return_last_db_id;
+
+	if (dbe->export_call_return)
+		return dbe->export_call_return(dbe, cr);
+
+	return 0;
+}
diff --git a/tools/perf/util/db-export.h b/tools/perf/util/db-export.h
new file mode 100644
index 000000000000..adbd22d66798
--- /dev/null
+++ b/tools/perf/util/db-export.h
@@ -0,0 +1,107 @@
+/*
+ * db-export.h: Support for exporting data suitable for import to a database
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef __PERF_DB_EXPORT_H
+#define __PERF_DB_EXPORT_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+
+struct perf_evsel;
+struct machine;
+struct thread;
+struct comm;
+struct dso;
+struct perf_sample;
+struct addr_location;
+struct call_return_processor;
+struct call_path;
+struct call_return;
+
+struct export_sample {
+	union perf_event	*event;
+	struct perf_sample	*sample;
+	struct perf_evsel	*evsel;
+	struct thread		*thread;
+	struct addr_location	*al;
+	u64			db_id;
+	u64			comm_db_id;
+	u64			dso_db_id;
+	u64			sym_db_id;
+	u64			offset; /* ip offset from symbol start */
+	u64			addr_dso_db_id;
+	u64			addr_sym_db_id;
+	u64			addr_offset; /* addr offset from symbol start */
+};
+
+struct db_export {
+	int (*export_evsel)(struct db_export *dbe, struct perf_evsel *evsel);
+	int (*export_machine)(struct db_export *dbe, struct machine *machine);
+	int (*export_thread)(struct db_export *dbe, struct thread *thread,
+			     u64 main_thread_db_id, struct machine *machine);
+	int (*export_comm)(struct db_export *dbe, struct comm *comm);
+	int (*export_comm_thread)(struct db_export *dbe, u64 db_id,
+				  struct comm *comm, struct thread *thread);
+	int (*export_dso)(struct db_export *dbe, struct dso *dso,
+			  struct machine *machine);
+	int (*export_symbol)(struct db_export *dbe, struct symbol *sym,
+			     struct dso *dso);
+	int (*export_branch_type)(struct db_export *dbe, u32 branch_type,
+				  const char *name);
+	int (*export_sample)(struct db_export *dbe, struct export_sample *es);
+	int (*export_call_path)(struct db_export *dbe, struct call_path *cp);
+	int (*export_call_return)(struct db_export *dbe,
+				  struct call_return *cr);
+	struct call_return_processor *crp;
+	u64 evsel_last_db_id;
+	u64 machine_last_db_id;
+	u64 thread_last_db_id;
+	u64 comm_last_db_id;
+	u64 comm_thread_last_db_id;
+	u64 dso_last_db_id;
+	u64 symbol_last_db_id;
+	u64 sample_last_db_id;
+	u64 call_path_last_db_id;
+	u64 call_return_last_db_id;
+	struct list_head deferred;
+};
+
+int db_export__init(struct db_export *dbe);
+int db_export__flush(struct db_export *dbe);
+void db_export__exit(struct db_export *dbe);
+int db_export__evsel(struct db_export *dbe, struct perf_evsel *evsel);
+int db_export__machine(struct db_export *dbe, struct machine *machine);
+int db_export__thread(struct db_export *dbe, struct thread *thread,
+		      struct machine *machine, struct comm *comm);
+int db_export__comm(struct db_export *dbe, struct comm *comm,
+		    struct thread *main_thread);
+int db_export__comm_thread(struct db_export *dbe, struct comm *comm,
+			   struct thread *thread);
+int db_export__dso(struct db_export *dbe, struct dso *dso,
+		   struct machine *machine);
+int db_export__symbol(struct db_export *dbe, struct symbol *sym,
+		      struct dso *dso);
+int db_export__branch_type(struct db_export *dbe, u32 branch_type,
+			   const char *name);
+int db_export__sample(struct db_export *dbe, union perf_event *event,
+		      struct perf_sample *sample, struct perf_evsel *evsel,
+		      struct thread *thread, struct addr_location *al);
+
+int db_export__branch_types(struct db_export *dbe);
+
+int db_export__call_path(struct db_export *dbe, struct call_path *cp);
+int db_export__call_return(struct db_export *dbe, struct call_return *cr);
+
+#endif
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index ba357f3226c6..ad60b2f20258 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -19,13 +19,14 @@
 int verbose;
 bool dump_trace = false, quiet = false;
 int debug_ordered_events;
+static int redirect_to_stderr;
 
 static int _eprintf(int level, int var, const char *fmt, va_list args)
 {
 	int ret = 0;
 
 	if (var >= level) {
-		if (use_browser >= 1)
+		if (use_browser >= 1 && !redirect_to_stderr)
 			ui_helpline__vshow(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
@@ -145,6 +146,7 @@ static struct debug_variable {
 } debug_variables[] = {
 	{ .name = "verbose",		.ptr = &verbose },
 	{ .name = "ordered-events",	.ptr = &debug_ordered_events},
+	{ .name = "stderr",		.ptr = &redirect_to_stderr},
 	{ .name = NULL, }
 };
 
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 0247acfdfaca..45be944d450a 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -21,8 +21,10 @@ char dso__symtab_origin(const struct dso *dso)
 		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]		= 'b',
 		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]		= 'd',
 		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]		= 'K',
+		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP]	= 'm',
 		[DSO_BINARY_TYPE__GUEST_KALLSYMS]		= 'g',
 		[DSO_BINARY_TYPE__GUEST_KMODULE]		= 'G',
+		[DSO_BINARY_TYPE__GUEST_KMODULE_COMP]		= 'M',
 		[DSO_BINARY_TYPE__GUEST_VMLINUX]		= 'V',
 	};
 
@@ -112,11 +114,13 @@ int dso__read_binary_type_filename(const struct dso *dso,
 		break;
 
 	case DSO_BINARY_TYPE__GUEST_KMODULE:
+	case DSO_BINARY_TYPE__GUEST_KMODULE_COMP:
 		path__join3(filename, size, symbol_conf.symfs,
 			    root_dir, dso->long_name);
 		break;
 
 	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
+	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP:
 		__symbol__join_symfs(filename, size, dso->long_name);
 		break;
 
@@ -137,6 +141,73 @@ int dso__read_binary_type_filename(const struct dso *dso,
 	return ret;
 }
 
+static const struct {
+	const char *fmt;
+	int (*decompress)(const char *input, int output);
+} compressions[] = {
+#ifdef HAVE_ZLIB_SUPPORT
+	{ "gz", gzip_decompress_to_file },
+#endif
+	{ NULL, NULL },
+};
+
+bool is_supported_compression(const char *ext)
+{
+	unsigned i;
+
+	for (i = 0; compressions[i].fmt; i++) {
+		if (!strcmp(ext, compressions[i].fmt))
+			return true;
+	}
+	return false;
+}
+
+bool is_kmodule_extension(const char *ext)
+{
+	if (strncmp(ext, "ko", 2))
+		return false;
+
+	if (ext[2] == '\0' || (ext[2] == '.' && is_supported_compression(ext+3)))
+		return true;
+
+	return false;
+}
+
+bool is_kernel_module(const char *pathname, bool *compressed)
+{
+	const char *ext = strrchr(pathname, '.');
+
+	if (ext == NULL)
+		return false;
+
+	if (is_supported_compression(ext + 1)) {
+		if (compressed)
+			*compressed = true;
+		ext -= 3;
+	} else if (compressed)
+		*compressed = false;
+
+	return is_kmodule_extension(ext + 1);
+}
+
+bool decompress_to_file(const char *ext, const char *filename, int output_fd)
+{
+	unsigned i;
+
+	for (i = 0; compressions[i].fmt; i++) {
+		if (!strcmp(ext, compressions[i].fmt))
+			return !compressions[i].decompress(filename,
+							   output_fd);
+	}
+	return false;
+}
+
+bool dso__needs_decompress(struct dso *dso)
+{
+	return dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP ||
+		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE_COMP;
+}
+
 /*
  * Global list of open DSOs and the counter.
  */
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index acb651acc7fd..3782c82c6e44 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -22,7 +22,9 @@ enum dso_binary_type {
 	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
+	DSO_BINARY_TYPE__GUEST_KMODULE_COMP,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
+	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP,
 	DSO_BINARY_TYPE__KCORE,
 	DSO_BINARY_TYPE__GUEST_KCORE,
 	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
@@ -127,6 +129,7 @@ struct dso {
 	const char	 *long_name;
 	u16		 long_name_len;
 	u16		 short_name_len;
+	void		*dwfl;			/* DWARF debug info */
 
 	/* dso data file */
 	struct {
@@ -138,6 +141,11 @@ struct dso {
 		struct list_head open_entry;
 	} data;
 
+	union { /* Tool specific area */
+		void	 *priv;
+		u64	 db_id;
+	};
+
 	char		 name[0];
 };
 
@@ -179,6 +187,11 @@ int dso__kernel_module_get_build_id(struct dso *dso, const char *root_dir);
 char dso__symtab_origin(const struct dso *dso);
 int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type type,
 				   char *root_dir, char *filename, size_t size);
+bool is_supported_compression(const char *ext);
+bool is_kmodule_extension(const char *ext);
+bool is_kernel_module(const char *pathname, bool *compressed);
+bool decompress_to_file(const char *ext, const char *filename, int output_fd);
+bool dso__needs_decompress(struct dso *dso);
 
 /*
  * The dso__data_* external interface provides following functions:
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 4af6b279e34a..6c6d044e959a 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -28,6 +28,7 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
 	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
 	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
+	[PERF_RECORD_ID_INDEX]			= "ID_INDEX",
 };
 
 const char *perf_event__name(unsigned int id)
@@ -730,12 +731,12 @@ int perf_event__process(struct perf_tool *tool __maybe_unused,
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
@@ -806,14 +807,14 @@ void thread__find_addr_map(struct thread *thread,
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
@@ -842,8 +843,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 	    machine->vmlinux_maps[MAP__FUNCTION] == NULL)
 		machine__create_kernel_maps(machine);
 
-	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      sample->ip, al);
+	thread__find_addr_map(thread, cpumode, MAP__FUNCTION, sample->ip, al);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
@@ -902,16 +902,14 @@ bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 
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
index 5699e7e2a790..09b9e8d3fcf7 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -143,6 +143,32 @@ struct branch_stack {
 	struct branch_entry	entries[0];
 };
 
+enum {
+	PERF_IP_FLAG_BRANCH		= 1ULL << 0,
+	PERF_IP_FLAG_CALL		= 1ULL << 1,
+	PERF_IP_FLAG_RETURN		= 1ULL << 2,
+	PERF_IP_FLAG_CONDITIONAL	= 1ULL << 3,
+	PERF_IP_FLAG_SYSCALLRET		= 1ULL << 4,
+	PERF_IP_FLAG_ASYNC		= 1ULL << 5,
+	PERF_IP_FLAG_INTERRUPT		= 1ULL << 6,
+	PERF_IP_FLAG_TX_ABORT		= 1ULL << 7,
+	PERF_IP_FLAG_TRACE_BEGIN	= 1ULL << 8,
+	PERF_IP_FLAG_TRACE_END		= 1ULL << 9,
+	PERF_IP_FLAG_IN_TX		= 1ULL << 10,
+};
+
+#define PERF_BRANCH_MASK		(\
+	PERF_IP_FLAG_BRANCH		|\
+	PERF_IP_FLAG_CALL		|\
+	PERF_IP_FLAG_RETURN		|\
+	PERF_IP_FLAG_CONDITIONAL	|\
+	PERF_IP_FLAG_SYSCALLRET		|\
+	PERF_IP_FLAG_ASYNC		|\
+	PERF_IP_FLAG_INTERRUPT		|\
+	PERF_IP_FLAG_TX_ABORT		|\
+	PERF_IP_FLAG_TRACE_BEGIN	|\
+	PERF_IP_FLAG_TRACE_END)
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
@@ -162,6 +188,7 @@ struct perf_sample {
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
 	struct regs_dump  user_regs;
+	struct regs_dump  intr_regs;
 	struct stack_dump user_stack;
 	struct sample_read read;
 };
@@ -187,6 +214,7 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_BUILD_ID		= 67,
 	PERF_RECORD_FINISHED_ROUND		= 68,
+	PERF_RECORD_ID_INDEX			= 69,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -239,6 +267,19 @@ struct tracing_data_event {
 	u32 size;
 };
 
+struct id_index_entry {
+	u64 id;
+	u64 idx;
+	u64 cpu;
+	u64 tid;
+};
+
+struct id_index_event {
+	struct perf_event_header header;
+	u64 nr;
+	struct id_index_entry entries[0];
+};
+
 union perf_event {
 	struct perf_event_header	header;
 	struct mmap_event		mmap;
@@ -253,6 +294,7 @@ union perf_event {
 	struct event_type_event		event_type;
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
+	struct id_index_event		id_index;
 };
 
 void perf_event__print_totals(void);
@@ -322,7 +364,6 @@ bool is_bts_event(struct perf_event_attr *attr);
 bool sample_addr_correlates_sym(struct perf_event_attr *attr);
 void perf_event__preprocess_sample_addr(union perf_event *event,
 					struct perf_sample *sample,
-					struct machine *machine,
 					struct thread *thread,
 					struct addr_location *al);
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3c9e77d6b4c2..cfbe2b99b9aa 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -413,7 +413,7 @@ int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 	int nfds = 0;
 	struct perf_evsel *evsel;
 
-	list_for_each_entry(evsel, &evlist->entries, node) {
+	evlist__for_each(evlist, evsel) {
 		if (evsel->system_wide)
 			nfds += nr_cpus;
 		else
@@ -527,6 +527,22 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 	return 0;
 }
 
+static void perf_evlist__set_sid_idx(struct perf_evlist *evlist,
+				     struct perf_evsel *evsel, int idx, int cpu,
+				     int thread)
+{
+	struct perf_sample_id *sid = SID(evsel, cpu, thread);
+	sid->idx = idx;
+	if (evlist->cpus && cpu >= 0)
+		sid->cpu = evlist->cpus->map[cpu];
+	else
+		sid->cpu = -1;
+	if (!evsel->system_wide && evlist->threads && thread >= 0)
+		sid->tid = evlist->threads->map[thread];
+	else
+		sid->tid = -1;
+}
+
 struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id)
 {
 	struct hlist_head *head;
@@ -800,14 +816,26 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 			perf_evlist__mmap_get(evlist, idx);
 		}
 
-		if (__perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
+		/*
+		 * The system_wide flag causes a selected event to be opened
+		 * always without a pid.  Consequently it will never get a
+		 * POLLHUP, but it is used for tracking in combination with
+		 * other events, so it should not need to be polled anyway.
+		 * Therefore don't add it for polling.
+		 */
+		if (!evsel->system_wide &&
+		    __perf_evlist__add_pollfd(evlist, fd, idx) < 0) {
 			perf_evlist__mmap_put(evlist, idx);
 			return -1;
 		}
 
-		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-		    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
-			return -1;
+		if (evsel->attr.read_format & PERF_FORMAT_ID) {
+			if (perf_evlist__id_add_fd(evlist, evsel, cpu, thread,
+						   fd) < 0)
+				return -1;
+			perf_evlist__set_sid_idx(evlist, evsel, idx, cpu,
+						 thread);
+		}
 	}
 
 	return 0;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2f9e68025ede..1e90c8557ede 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -658,9 +658,22 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
+	/*
+	 * We don't allow user space callchains for  function trace
+	 * event, due to issues with page faults while tracing page
+	 * fault handler and its overall trickiness nature.
+	 */
+	if (perf_evsel__is_function_event(evsel))
+		evsel->attr.exclude_callchain_user = 1;
+
 	if (callchain_param.enabled && !evsel->no_aux_samples)
 		perf_evsel__config_callgraph(evsel);
 
+	if (opts->sample_intr_regs) {
+		attr->sample_regs_intr = PERF_REGS_MASK;
+		perf_evsel__set_sample_bit(evsel, REGS_INTR);
+	}
+
 	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
 
@@ -853,8 +866,6 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	perf_evsel__free_id(evsel);
 	close_cgroup(evsel->cgrp);
 	zfree(&evsel->group_name);
-	if (evsel->tp_format)
-		pevent_free_format(evsel->tp_format);
 	zfree(&evsel->name);
 	perf_evsel__object.fini(evsel);
 }
@@ -865,9 +876,8 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 	free(evsel);
 }
 
-static inline void compute_deltas(struct perf_evsel *evsel,
-				  int cpu,
-				  struct perf_counts_values *count)
+void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
+				struct perf_counts_values *count)
 {
 	struct perf_counts_values tmp;
 
@@ -887,81 +897,60 @@ static inline void compute_deltas(struct perf_evsel *evsel,
 	count->run = count->run - tmp.run;
 }
 
-int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
-			      int cpu, int thread, bool scale)
+void perf_counts_values__scale(struct perf_counts_values *count,
+			       bool scale, s8 *pscaled)
 {
-	struct perf_counts_values count;
-	size_t nv = scale ? 3 : 1;
-
-	if (FD(evsel, cpu, thread) < 0)
-		return -EINVAL;
-
-	if (evsel->counts == NULL && perf_evsel__alloc_counts(evsel, cpu + 1) < 0)
-		return -ENOMEM;
-
-	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
-		return -errno;
-
-	compute_deltas(evsel, cpu, &count);
+	s8 scaled = 0;
 
 	if (scale) {
-		if (count.run == 0)
-			count.val = 0;
-		else if (count.run < count.ena)
-			count.val = (u64)((double)count.val * count.ena / count.run + 0.5);
+		if (count->run == 0) {
+			scaled = -1;
+			count->val = 0;
+		} else if (count->run < count->ena) {
+			scaled = 1;
+			count->val = (u64)((double) count->val * count->ena / count->run + 0.5);
+		}
 	} else
-		count.ena = count.run = 0;
+		count->ena = count->run = 0;
 
-	evsel->counts->cpu[cpu] = count;
-	return 0;
+	if (pscaled)
+		*pscaled = scaled;
 }
 
-int __perf_evsel__read(struct perf_evsel *evsel,
-		       int ncpus, int nthreads, bool scale)
+int perf_evsel__read_cb(struct perf_evsel *evsel, int cpu, int thread,
+			perf_evsel__read_cb_t cb)
 {
-	size_t nv = scale ? 3 : 1;
-	int cpu, thread;
-	struct perf_counts_values *aggr = &evsel->counts->aggr, count;
+	struct perf_counts_values count;
 
-	if (evsel->system_wide)
-		nthreads = 1;
+	memset(&count, 0, sizeof(count));
 
-	aggr->val = aggr->ena = aggr->run = 0;
+	if (FD(evsel, cpu, thread) < 0)
+		return -EINVAL;
 
-	for (cpu = 0; cpu < ncpus; cpu++) {
-		for (thread = 0; thread < nthreads; thread++) {
-			if (FD(evsel, cpu, thread) < 0)
-				continue;
+	if (readn(FD(evsel, cpu, thread), &count, sizeof(count)) < 0)
+		return -errno;
 
-			if (readn(FD(evsel, cpu, thread),
-				  &count, nv * sizeof(u64)) < 0)
-				return -errno;
+	return cb(evsel, cpu, thread, &count);
+}
 
-			aggr->val += count.val;
-			if (scale) {
-				aggr->ena += count.ena;
-				aggr->run += count.run;
-			}
-		}
-	}
+int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
+			      int cpu, int thread, bool scale)
+{
+	struct perf_counts_values count;
+	size_t nv = scale ? 3 : 1;
 
-	compute_deltas(evsel, -1, aggr);
+	if (FD(evsel, cpu, thread) < 0)
+		return -EINVAL;
 
-	evsel->counts->scaled = 0;
-	if (scale) {
-		if (aggr->run == 0) {
-			evsel->counts->scaled = -1;
-			aggr->val = 0;
-			return 0;
-		}
+	if (evsel->counts == NULL && perf_evsel__alloc_counts(evsel, cpu + 1) < 0)
+		return -ENOMEM;
 
-		if (aggr->run < aggr->ena) {
-			evsel->counts->scaled = 1;
-			aggr->val = (u64)((double)aggr->val * aggr->ena / aggr->run + 0.5);
-		}
-	} else
-		aggr->ena = aggr->run = 0;
+	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
+		return -errno;
 
+	perf_evsel__compute_deltas(evsel, cpu, &count);
+	perf_counts_values__scale(&count, scale, NULL);
+	evsel->counts->cpu[cpu] = count;
 	return 0;
 }
 
@@ -1039,6 +1028,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR_X64(branch_sample_type);
 	ret += PRINT_ATTR_X64(sample_regs_user);
 	ret += PRINT_ATTR_U32(sample_stack_user);
+	ret += PRINT_ATTR_X64(sample_regs_intr);
 
 	ret += fprintf(fp, "%.60s\n", graph_dotted_line);
 
@@ -1538,6 +1528,23 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	data->intr_regs.abi = PERF_SAMPLE_REGS_ABI_NONE;
+	if (type & PERF_SAMPLE_REGS_INTR) {
+		OVERFLOW_CHECK_u64(array);
+		data->intr_regs.abi = *array;
+		array++;
+
+		if (data->intr_regs.abi != PERF_SAMPLE_REGS_ABI_NONE) {
+			u64 mask = evsel->attr.sample_regs_intr;
+
+			sz = hweight_long(mask) * sizeof(u64);
+			OVERFLOW_CHECK(array, sz, max_size);
+			data->intr_regs.mask = mask;
+			data->intr_regs.regs = (u64 *)array;
+			array = (void *)array + sz;
+		}
+	}
+
 	return 0;
 }
 
@@ -1633,6 +1640,16 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 	if (type & PERF_SAMPLE_TRANSACTION)
 		result += sizeof(u64);
 
+	if (type & PERF_SAMPLE_REGS_INTR) {
+		if (sample->intr_regs.abi) {
+			result += sizeof(u64);
+			sz = hweight_long(sample->intr_regs.mask) * sizeof(u64);
+			result += sz;
+		} else {
+			result += sizeof(u64);
+		}
+	}
+
 	return result;
 }
 
@@ -1811,6 +1828,17 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_REGS_INTR) {
+		if (sample->intr_regs.abi) {
+			*array++ = sample->intr_regs.abi;
+			sz = hweight_long(sample->intr_regs.mask) * sizeof(u64);
+			memcpy(array, sample->intr_regs.regs, sz);
+			array = (void *)array + sz;
+		} else {
+			*array++ = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -1940,7 +1968,7 @@ static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
 		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
 		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
 		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
-		bit_name(IDENTIFIER),
+		bit_name(IDENTIFIER), bit_name(REGS_INTR),
 		{ .name = NULL, }
 	};
 #undef bit_name
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 163c5604e5d1..38622747d130 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -36,6 +36,9 @@ struct perf_sample_id {
 	struct hlist_node 	node;
 	u64		 	id;
 	struct perf_evsel	*evsel;
+	int			idx;
+	int			cpu;
+	pid_t			tid;
 
 	/* Holds total ID period value for PERF_SAMPLE_READ processing. */
 	u64			period;
@@ -54,6 +57,7 @@ struct cgroup_sel;
  * @is_pos: the position (counting backwards) of the event id (PERF_SAMPLE_ID or
  *          PERF_SAMPLE_IDENTIFIER) in a non-sample event i.e. if sample_id_all
  *          is used there is an id sample appended to non-sample events
+ * @priv:   And what is in its containing unnamed union are tool specific
  */
 struct perf_evsel {
 	struct list_head	node;
@@ -69,10 +73,12 @@ struct perf_evsel {
 	char			*name;
 	double			scale;
 	const char		*unit;
+	bool			snapshot;
 	struct event_format	*tp_format;
 	union {
 		void		*priv;
 		off_t		id_offset;
+		u64		db_id;
 	};
 	struct cgroup_sel	*cgrp;
 	void			*handler;
@@ -86,6 +92,8 @@ struct perf_evsel {
 	bool			immediate;
 	bool			system_wide;
 	bool			tracking;
+	bool			per_pkg;
+	unsigned long		*per_pkg_mask;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
@@ -105,6 +113,12 @@ struct thread_map;
 struct perf_evlist;
 struct record_opts;
 
+void perf_counts_values__scale(struct perf_counts_values *count,
+			       bool scale, s8 *pscaled);
+
+void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
+				struct perf_counts_values *count);
+
 int perf_evsel__object_config(size_t object_size,
 			      int (*init)(struct perf_evsel *evsel),
 			      void (*fini)(struct perf_evsel *evsel));
@@ -222,6 +236,13 @@ static inline bool perf_evsel__match2(struct perf_evsel *e1,
 	 (a)->attr.type == (b)->attr.type &&	\
 	 (a)->attr.config == (b)->attr.config)
 
+typedef int (perf_evsel__read_cb_t)(struct perf_evsel *evsel,
+				    int cpu, int thread,
+				    struct perf_counts_values *count);
+
+int perf_evsel__read_cb(struct perf_evsel *evsel, int cpu, int thread,
+			perf_evsel__read_cb_t cb);
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale);
 
@@ -251,35 +272,6 @@ static inline int perf_evsel__read_on_cpu_scaled(struct perf_evsel *evsel,
 	return __perf_evsel__read_on_cpu(evsel, cpu, thread, true);
 }
 
-int __perf_evsel__read(struct perf_evsel *evsel, int ncpus, int nthreads,
-		       bool scale);
-
-/**
- * perf_evsel__read - Read the aggregate results on all CPUs
- *
- * @evsel - event selector to read value
- * @ncpus - Number of cpus affected, from zero
- * @nthreads - Number of threads affected, from zero
- */
-static inline int perf_evsel__read(struct perf_evsel *evsel,
-				    int ncpus, int nthreads)
-{
-	return __perf_evsel__read(evsel, ncpus, nthreads, false);
-}
-
-/**
- * perf_evsel__read_scaled - Read the aggregate results on all CPUs, scaled
- *
- * @evsel - event selector to read value
- * @ncpus - Number of cpus affected, from zero
- * @nthreads - Number of threads affected, from zero
- */
-static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
-					  int ncpus, int nthreads)
-{
-	return __perf_evsel__read(evsel, ncpus, nthreads, true);
-}
-
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *sample);
 
diff --git a/tools/perf/util/find-vdso-map.c b/tools/perf/util/find-vdso-map.c
new file mode 100644
index 000000000000..95ef1cffc056
--- /dev/null
+++ b/tools/perf/util/find-vdso-map.c
@@ -0,0 +1,30 @@
+static int find_vdso_map(void **start, void **end)
+{
+	FILE *maps;
+	char line[128];
+	int found = 0;
+
+	maps = fopen("/proc/self/maps", "r");
+	if (!maps) {
+		fprintf(stderr, "vdso: cannot open maps\n");
+		return -1;
+	}
+
+	while (!found && fgets(line, sizeof(line), maps)) {
+		int m = -1;
+
+		/* We care only about private r-x mappings. */
+		if (2 != sscanf(line, "%p-%p r-xp %*x %*x:%*x %*u %n",
+				start, end, &m))
+			continue;
+		if (m < 0)
+			continue;
+
+		if (!strncmp(&line[m], VDSO__MAP_NAME,
+			     sizeof(VDSO__MAP_NAME) - 1))
+			found = 1;
+	}
+
+	fclose(maps);
+	return !found;
+}
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 26f5b2fe5dc8..b20e40c74468 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -24,8 +24,6 @@
 #include "build-id.h"
 #include "data.h"
 
-static bool no_buildid_cache = false;
-
 static u32 header_argc;
 static const char **header_argv;
 
@@ -79,10 +77,7 @@ static int do_write(int fd, const void *buf, size_t size)
 	return 0;
 }
 
-#define NAME_ALIGN 64
-
-static int write_padded(int fd, const void *bf, size_t count,
-			size_t count_aligned)
+int write_padded(int fd, const void *bf, size_t count, size_t count_aligned)
 {
 	static const char zero_buf[NAME_ALIGN];
 	int err = do_write(fd, bf, count);
@@ -171,340 +166,6 @@ perf_header__set_cmdline(int argc, const char **argv)
 	return 0;
 }
 
-#define dsos__for_each_with_build_id(pos, head)	\
-	list_for_each_entry(pos, head, node)	\
-		if (!pos->has_build_id)		\
-			continue;		\
-		else
-
-static int write_buildid(const char *name, size_t name_len, u8 *build_id,
-			 pid_t pid, u16 misc, int fd)
-{
-	int err;
-	struct build_id_event b;
-	size_t len;
-
-	len = name_len + 1;
-	len = PERF_ALIGN(len, NAME_ALIGN);
-
-	memset(&b, 0, sizeof(b));
-	memcpy(&b.build_id, build_id, BUILD_ID_SIZE);
-	b.pid = pid;
-	b.header.misc = misc;
-	b.header.size = sizeof(b) + len;
-
-	err = do_write(fd, &b, sizeof(b));
-	if (err < 0)
-		return err;
-
-	return write_padded(fd, name, name_len + 1, len);
-}
-
-static int __dsos__hit_all(struct list_head *head)
-{
-	struct dso *pos;
-
-	list_for_each_entry(pos, head, node)
-		pos->hit = true;
-
-	return 0;
-}
-
-static int machine__hit_all_dsos(struct machine *machine)
-{
-	int err;
-
-	err = __dsos__hit_all(&machine->kernel_dsos.head);
-	if (err)
-		return err;
-
-	return __dsos__hit_all(&machine->user_dsos.head);
-}
-
-int dsos__hit_all(struct perf_session *session)
-{
-	struct rb_node *nd;
-	int err;
-
-	err = machine__hit_all_dsos(&session->machines.host);
-	if (err)
-		return err;
-
-	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-
-		err = machine__hit_all_dsos(pos);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int __dsos__write_buildid_table(struct list_head *head,
-				       struct machine *machine,
-				       pid_t pid, u16 misc, int fd)
-{
-	char nm[PATH_MAX];
-	struct dso *pos;
-
-	dsos__for_each_with_build_id(pos, head) {
-		int err;
-		const char *name;
-		size_t name_len;
-
-		if (!pos->hit)
-			continue;
-
-		if (dso__is_vdso(pos)) {
-			name = pos->short_name;
-			name_len = pos->short_name_len + 1;
-		} else if (dso__is_kcore(pos)) {
-			machine__mmap_name(machine, nm, sizeof(nm));
-			name = nm;
-			name_len = strlen(nm) + 1;
-		} else {
-			name = pos->long_name;
-			name_len = pos->long_name_len + 1;
-		}
-
-		err = write_buildid(name, name_len, pos->build_id,
-				    pid, misc, fd);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-static int machine__write_buildid_table(struct machine *machine, int fd)
-{
-	int err;
-	u16 kmisc = PERF_RECORD_MISC_KERNEL,
-	    umisc = PERF_RECORD_MISC_USER;
-
-	if (!machine__is_host(machine)) {
-		kmisc = PERF_RECORD_MISC_GUEST_KERNEL;
-		umisc = PERF_RECORD_MISC_GUEST_USER;
-	}
-
-	err = __dsos__write_buildid_table(&machine->kernel_dsos.head, machine,
-					  machine->pid, kmisc, fd);
-	if (err == 0)
-		err = __dsos__write_buildid_table(&machine->user_dsos.head,
-						  machine, machine->pid, umisc,
-						  fd);
-	return err;
-}
-
-static int dsos__write_buildid_table(struct perf_header *header, int fd)
-{
-	struct perf_session *session = container_of(header,
-			struct perf_session, header);
-	struct rb_node *nd;
-	int err = machine__write_buildid_table(&session->machines.host, fd);
-
-	if (err)
-		return err;
-
-	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		err = machine__write_buildid_table(pos, fd);
-		if (err)
-			break;
-	}
-	return err;
-}
-
-int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
-			  const char *name, bool is_kallsyms, bool is_vdso)
-{
-	const size_t size = PATH_MAX;
-	char *realname, *filename = zalloc(size),
-	     *linkname = zalloc(size), *targetname;
-	int len, err = -1;
-	bool slash = is_kallsyms || is_vdso;
-
-	if (is_kallsyms) {
-		if (symbol_conf.kptr_restrict) {
-			pr_debug("Not caching a kptr_restrict'ed /proc/kallsyms\n");
-			err = 0;
-			goto out_free;
-		}
-		realname = (char *) name;
-	} else
-		realname = realpath(name, NULL);
-
-	if (realname == NULL || filename == NULL || linkname == NULL)
-		goto out_free;
-
-	len = scnprintf(filename, size, "%s%s%s",
-		       debugdir, slash ? "/" : "",
-		       is_vdso ? DSO__NAME_VDSO : realname);
-	if (mkdir_p(filename, 0755))
-		goto out_free;
-
-	snprintf(filename + len, size - len, "/%s", sbuild_id);
-
-	if (access(filename, F_OK)) {
-		if (is_kallsyms) {
-			 if (copyfile("/proc/kallsyms", filename))
-				goto out_free;
-		} else if (link(realname, filename) && copyfile(name, filename))
-			goto out_free;
-	}
-
-	len = scnprintf(linkname, size, "%s/.build-id/%.2s",
-		       debugdir, sbuild_id);
-
-	if (access(linkname, X_OK) && mkdir_p(linkname, 0755))
-		goto out_free;
-
-	snprintf(linkname + len, size - len, "/%s", sbuild_id + 2);
-	targetname = filename + strlen(debugdir) - 5;
-	memcpy(targetname, "../..", 5);
-
-	if (symlink(targetname, linkname) == 0)
-		err = 0;
-out_free:
-	if (!is_kallsyms)
-		free(realname);
-	free(filename);
-	free(linkname);
-	return err;
-}
-
-static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
-				 const char *name, const char *debugdir,
-				 bool is_kallsyms, bool is_vdso)
-{
-	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
-
-	build_id__sprintf(build_id, build_id_size, sbuild_id);
-
-	return build_id_cache__add_s(sbuild_id, debugdir, name,
-				     is_kallsyms, is_vdso);
-}
-
-int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
-{
-	const size_t size = PATH_MAX;
-	char *filename = zalloc(size),
-	     *linkname = zalloc(size);
-	int err = -1;
-
-	if (filename == NULL || linkname == NULL)
-		goto out_free;
-
-	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
-		 debugdir, sbuild_id, sbuild_id + 2);
-
-	if (access(linkname, F_OK))
-		goto out_free;
-
-	if (readlink(linkname, filename, size - 1) < 0)
-		goto out_free;
-
-	if (unlink(linkname))
-		goto out_free;
-
-	/*
-	 * Since the link is relative, we must make it absolute:
-	 */
-	snprintf(linkname, size, "%s/.build-id/%.2s/%s",
-		 debugdir, sbuild_id, filename);
-
-	if (unlink(linkname))
-		goto out_free;
-
-	err = 0;
-out_free:
-	free(filename);
-	free(linkname);
-	return err;
-}
-
-static int dso__cache_build_id(struct dso *dso, struct machine *machine,
-			       const char *debugdir)
-{
-	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
-	bool is_vdso = dso__is_vdso(dso);
-	const char *name = dso->long_name;
-	char nm[PATH_MAX];
-
-	if (dso__is_kcore(dso)) {
-		is_kallsyms = true;
-		machine__mmap_name(machine, nm, sizeof(nm));
-		name = nm;
-	}
-	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id), name,
-				     debugdir, is_kallsyms, is_vdso);
-}
-
-static int __dsos__cache_build_ids(struct list_head *head,
-				   struct machine *machine, const char *debugdir)
-{
-	struct dso *pos;
-	int err = 0;
-
-	dsos__for_each_with_build_id(pos, head)
-		if (dso__cache_build_id(pos, machine, debugdir))
-			err = -1;
-
-	return err;
-}
-
-static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
-{
-	int ret = __dsos__cache_build_ids(&machine->kernel_dsos.head, machine,
-					  debugdir);
-	ret |= __dsos__cache_build_ids(&machine->user_dsos.head, machine,
-				       debugdir);
-	return ret;
-}
-
-static int perf_session__cache_build_ids(struct perf_session *session)
-{
-	struct rb_node *nd;
-	int ret;
-	char debugdir[PATH_MAX];
-
-	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
-
-	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
-		return -1;
-
-	ret = machine__cache_build_ids(&session->machines.host, debugdir);
-
-	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__cache_build_ids(pos, debugdir);
-	}
-	return ret ? -1 : 0;
-}
-
-static bool machine__read_build_ids(struct machine *machine, bool with_hits)
-{
-	bool ret;
-
-	ret  = __dsos__read_build_ids(&machine->kernel_dsos.head, with_hits);
-	ret |= __dsos__read_build_ids(&machine->user_dsos.head, with_hits);
-	return ret;
-}
-
-static bool perf_session__read_build_ids(struct perf_session *session, bool with_hits)
-{
-	struct rb_node *nd;
-	bool ret = machine__read_build_ids(&session->machines.host, with_hits);
-
-	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
-		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__read_build_ids(pos, with_hits);
-	}
-
-	return ret;
-}
-
 static int write_tracing_data(int fd, struct perf_header *h __maybe_unused,
 			    struct perf_evlist *evlist)
 {
@@ -523,13 +184,12 @@ static int write_build_id(int fd, struct perf_header *h,
 	if (!perf_session__read_build_ids(session, true))
 		return -1;
 
-	err = dsos__write_buildid_table(h, fd);
+	err = perf_session__write_buildid_table(session, fd);
 	if (err < 0) {
 		pr_debug("failed to write buildid table\n");
 		return err;
 	}
-	if (!no_buildid_cache)
-		perf_session__cache_build_ids(session);
+	perf_session__cache_build_ids(session);
 
 	return 0;
 }
@@ -601,8 +261,10 @@ static int __write_cpudesc(int fd, const char *cpuinfo_proc)
 			break;
 	}
 
-	if (ret)
+	if (ret) {
+		ret = -1;
 		goto done;
+	}
 
 	s = buf;
 
@@ -965,7 +627,8 @@ static int write_total_mem(int fd, struct perf_header *h __maybe_unused,
 		n = sscanf(buf, "%*s %"PRIu64, &mem);
 		if (n == 1)
 			ret = do_write(fd, &mem, sizeof(mem));
-	}
+	} else
+		ret = -1;
 	free(buf);
 	fclose(fp);
 	return ret;
@@ -1603,7 +1266,7 @@ static int __event_process_build_id(struct build_id_event *bev,
 
 		dso__set_build_id(dso, &bev->build_id);
 
-		if (filename[0] == '[')
+		if (!is_kernel_module(filename, NULL))
 			dso->kernel = dso_type;
 
 		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
@@ -2477,6 +2140,7 @@ static const int attr_file_abi_sizes[] = {
 	[1] = PERF_ATTR_SIZE_VER1,
 	[2] = PERF_ATTR_SIZE_VER2,
 	[3] = PERF_ATTR_SIZE_VER3,
+	[4] = PERF_ATTR_SIZE_VER4,
 	0,
 };
 
@@ -3124,8 +2788,3 @@ int perf_event__process_build_id(struct perf_tool *tool __maybe_unused,
 				 session);
 	return 0;
 }
-
-void disable_buildid_cache(void)
-{
-	no_buildid_cache = true;
-}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 8f5cbaea64a5..3bb90ac172a1 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -122,10 +122,6 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 
 int perf_header__fprintf_info(struct perf_session *s, FILE *fp, bool full);
 
-int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
-			  const char *name, bool is_kallsyms, bool is_vdso);
-int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
-
 int perf_event__synthesize_attr(struct perf_tool *tool,
 				struct perf_event_attr *attr, u32 ids, u64 *id,
 				perf_event__handler_t process);
@@ -151,7 +147,9 @@ int perf_event__process_build_id(struct perf_tool *tool,
 				 struct perf_session *session);
 bool is_perf_magic(u64 magic);
 
-int dsos__hit_all(struct perf_session *session);
+#define NAME_ALIGN 64
+
+int write_padded(int fd, const void *bf, size_t count, size_t count_aligned);
 
 /*
  * arch specific callback
diff --git a/tools/perf/util/include/linux/bitmap.h b/tools/perf/util/include/linux/bitmap.h
index 01ffd12dc791..40bd21488032 100644
--- a/tools/perf/util/include/linux/bitmap.h
+++ b/tools/perf/util/include/linux/bitmap.h
@@ -46,4 +46,21 @@ static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 		__bitmap_or(dst, src1, src2, nbits);
 }
 
+/**
+ * test_and_set_bit - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ */
+static inline int test_and_set_bit(int nr, unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
+	unsigned long old;
+
+	old = *p;
+	*p = old | mask;
+
+	return (old & mask) != 0;
+}
+
 #endif /* _PERF_BITOPS_H */
diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index dadfa7e54287..c3294163de17 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -15,6 +15,8 @@
 #define BITS_TO_U64(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
 #define BITS_TO_U32(nr)         DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
 #define BITS_TO_BYTES(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE)
+#define BIT_WORD(nr)            ((nr) / BITS_PER_LONG)
+#define BIT_MASK(nr)            (1UL << ((nr) % BITS_PER_LONG))
 
 #define for_each_set_bit(bit, addr, size) \
 	for ((bit) = find_first_bit((addr), (size));		\
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 34fc7c8672e4..15dd0a9691ce 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -12,6 +12,7 @@
 #include <stdbool.h>
 #include <symbol/kallsyms.h>
 #include "unwind.h"
+#include "linux/hash.h"
 
 static void dsos__init(struct dsos *dsos)
 {
@@ -21,7 +22,7 @@ static void dsos__init(struct dsos *dsos)
 
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
-	map_groups__init(&machine->kmaps);
+	map_groups__init(&machine->kmaps, machine);
 	RB_CLEAR_NODE(&machine->rb_node);
 	dsos__init(&machine->user_dsos);
 	dsos__init(&machine->kernel_dsos);
@@ -32,7 +33,6 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 
 	machine->vdso_info = NULL;
 
-	machine->kmaps.machine = machine;
 	machine->pid = pid;
 
 	machine->symbol_filter = NULL;
@@ -319,7 +319,7 @@ static void machine__update_thread_pid(struct machine *machine,
 		goto out_err;
 
 	if (!leader->mg)
-		leader->mg = map_groups__new();
+		leader->mg = map_groups__new(machine);
 
 	if (!leader->mg)
 		goto out_err;
@@ -465,6 +465,7 @@ struct map *machine__new_module(struct machine *machine, u64 start,
 {
 	struct map *map;
 	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, filename);
+	bool compressed;
 
 	if (dso == NULL)
 		return NULL;
@@ -477,6 +478,11 @@ struct map *machine__new_module(struct machine *machine, u64 start,
 		dso->symtab_type = DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE;
 	else
 		dso->symtab_type = DSO_BINARY_TYPE__GUEST_KMODULE;
+
+	/* _KMODULE_COMP should be next to _KMODULE */
+	if (is_kernel_module(filename, &compressed) && compressed)
+		dso->symtab_type++;
+
 	map_groups__insert(&machine->kmaps, map);
 	return map;
 }
@@ -862,8 +868,14 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 			struct map *map;
 			char *long_name;
 
-			if (dot == NULL || strcmp(dot, ".ko"))
+			if (dot == NULL)
 				continue;
+
+			/* On some system, modules are compressed like .ko.gz */
+			if (is_supported_compression(dot + 1) &&
+			    is_kmodule_extension(dot - 2))
+				dot -= 3;
+
 			snprintf(dso_name, sizeof(dso_name), "[%.*s]",
 				 (int)(dot - dent->d_name), dent->d_name);
 
@@ -1045,6 +1057,11 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 			dot = strrchr(name, '.');
 			if (dot == NULL)
 				goto out_problem;
+			/* On some system, modules are compressed like .ko.gz */
+			if (is_supported_compression(dot + 1))
+				dot -= 3;
+			if (!is_kmodule_extension(dot + 1))
+				goto out_problem;
 			snprintf(short_module_name, sizeof(short_module_name),
 					"[%.*s]", (int)(dot - name), name);
 			strxfrchar(short_module_name, '-', '_');
@@ -1069,8 +1086,20 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		 * Should be there already, from the build-id table in
 		 * the header.
 		 */
-		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
-						     kmmap_prefix);
+		struct dso *kernel = NULL;
+		struct dso *dso;
+
+		list_for_each_entry(dso, &machine->kernel_dsos.head, node) {
+			if (is_kernel_module(dso->long_name, NULL))
+				continue;
+
+			kernel = dso;
+			break;
+		}
+
+		if (kernel == NULL)
+			kernel = __dsos__findnew(&machine->kernel_dsos,
+						 kmmap_prefix);
 		if (kernel == NULL)
 			goto out_problem;
 
@@ -1078,6 +1107,9 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		if (__machine__create_kernel_maps(machine, kernel) < 0)
 			goto out_problem;
 
+		if (strstr(kernel->long_name, "vmlinux"))
+			dso__set_short_name(kernel, "[kernel.vmlinux]", false);
+
 		machine__set_kernel_mmap_len(machine, event);
 
 		/*
@@ -1290,7 +1322,7 @@ static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 	return 0;
 }
 
-static void ip__resolve_ams(struct machine *machine, struct thread *thread,
+static void ip__resolve_ams(struct thread *thread,
 			    struct addr_map_symbol *ams,
 			    u64 ip)
 {
@@ -1304,7 +1336,7 @@ static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 	 * Thus, we have to try consecutively until we find a match
 	 * or else, the symbol is unknown
 	 */
-	thread__find_cpumode_addr_location(thread, machine, MAP__FUNCTION, ip, &al);
+	thread__find_cpumode_addr_location(thread, MAP__FUNCTION, ip, &al);
 
 	ams->addr = ip;
 	ams->al_addr = al.addr;
@@ -1312,23 +1344,21 @@ static void ip__resolve_ams(struct machine *machine, struct thread *thread,
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
@@ -1345,14 +1375,45 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 	if (!mi)
 		return NULL;
 
-	ip__resolve_ams(al->machine, al->thread, &mi->iaddr, sample->ip);
-	ip__resolve_data(al->machine, al->thread, al->cpumode,
-			 &mi->daddr, sample->addr);
+	ip__resolve_ams(al->thread, &mi->iaddr, sample->ip);
+	ip__resolve_data(al->thread, al->cpumode, &mi->daddr, sample->addr);
 	mi->data_src.val = sample->data_src;
 
 	return mi;
 }
 
+static int add_callchain_ip(struct thread *thread,
+			    struct symbol **parent,
+			    struct addr_location *root_al,
+			    int cpumode,
+			    u64 ip)
+{
+	struct addr_location al;
+
+	al.filtered = 0;
+	al.sym = NULL;
+	if (cpumode == -1)
+		thread__find_cpumode_addr_location(thread, MAP__FUNCTION,
+						   ip, &al);
+	else
+		thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
+				   ip, &al);
+	if (al.sym != NULL) {
+		if (sort__has_parent && !*parent &&
+		    symbol__match_regex(al.sym, &parent_regex))
+			*parent = al.sym;
+		else if (have_ignore_callees && root_al &&
+		  symbol__match_regex(al.sym, &ignore_callees_regex)) {
+			/* Treat this symbol as the root,
+			   forgetting its callees. */
+			*root_al = al;
+			callchain_cursor_reset(&callchain_cursor);
+		}
+	}
+
+	return callchain_cursor_append(&callchain_cursor, al.addr, al.map, al.sym);
+}
+
 struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 					   struct addr_location *al)
 {
@@ -1364,16 +1425,57 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
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
+#define CHASHSZ 127
+#define CHASHBITS 7
+#define NO_ENTRY 0xff
+
+#define PERF_MAX_BRANCH_DEPTH 127
+
+/* Remove loops. */
+static int remove_loops(struct branch_entry *l, int nr)
+{
+	int i, j, off;
+	unsigned char chash[CHASHSZ];
+
+	memset(chash, NO_ENTRY, sizeof(chash));
+
+	BUG_ON(PERF_MAX_BRANCH_DEPTH > 255);
+
+	for (i = 0; i < nr; i++) {
+		int h = hash_64(l[i].from, CHASHBITS) % CHASHSZ;
+
+		/* no collision handling for now */
+		if (chash[h] == NO_ENTRY) {
+			chash[h] = i;
+		} else if (l[chash[h]].from == l[i].from) {
+			bool is_loop = true;
+			/* check if it is a real loop */
+			off = 0;
+			for (j = chash[h]; j < i && i + off < nr; j++, off++)
+				if (l[j].from != l[i + off].from) {
+					is_loop = false;
+					break;
+				}
+			if (is_loop) {
+				memmove(l + i, l + i + off,
+					(nr - (i + off)) * sizeof(*l));
+				nr -= off;
+			}
+		}
+	}
+	return nr;
+}
+
+static int thread__resolve_callchain_sample(struct thread *thread,
 					     struct ip_callchain *chain,
+					     struct branch_stack *branch,
 					     struct symbol **parent,
 					     struct addr_location *root_al,
 					     int max_stack)
@@ -1383,24 +1485,83 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	int i;
 	int j;
 	int err;
-	int skip_idx __maybe_unused;
+	int skip_idx = -1;
+	int first_call = 0;
+
+	/*
+	 * Based on DWARF debug information, some architectures skip
+	 * a callchain entry saved by the kernel.
+	 */
+	if (chain->nr < PERF_MAX_STACK_DEPTH)
+		skip_idx = arch_skip_callchain_idx(thread, chain);
 
 	callchain_cursor_reset(&callchain_cursor);
 
+	/*
+	 * Add branches to call stack for easier browsing. This gives
+	 * more context for a sample than just the callers.
+	 *
+	 * This uses individual histograms of paths compared to the
+	 * aggregated histograms the normal LBR mode uses.
+	 *
+	 * Limitations for now:
+	 * - No extra filters
+	 * - No annotations (should annotate somehow)
+	 */
+
+	if (branch && callchain_param.branch_callstack) {
+		int nr = min(max_stack, (int)branch->nr);
+		struct branch_entry be[nr];
+
+		if (branch->nr > PERF_MAX_BRANCH_DEPTH) {
+			pr_warning("corrupted branch chain. skipping...\n");
+			goto check_calls;
+		}
+
+		for (i = 0; i < nr; i++) {
+			if (callchain_param.order == ORDER_CALLEE) {
+				be[i] = branch->entries[i];
+				/*
+				 * Check for overlap into the callchain.
+				 * The return address is one off compared to
+				 * the branch entry. To adjust for this
+				 * assume the calling instruction is not longer
+				 * than 8 bytes.
+				 */
+				if (i == skip_idx ||
+				    chain->ips[first_call] >= PERF_CONTEXT_MAX)
+					first_call++;
+				else if (be[i].from < chain->ips[first_call] &&
+				    be[i].from >= chain->ips[first_call] - 8)
+					first_call++;
+			} else
+				be[i] = branch->entries[branch->nr - i - 1];
+		}
+
+		nr = remove_loops(be, nr);
+
+		for (i = 0; i < nr; i++) {
+			err = add_callchain_ip(thread, parent, root_al,
+					       -1, be[i].to);
+			if (!err)
+				err = add_callchain_ip(thread, parent, root_al,
+						       -1, be[i].from);
+			if (err == -EINVAL)
+				break;
+			if (err)
+				return err;
+		}
+		chain_nr -= nr;
+	}
+
+check_calls:
 	if (chain->nr > PERF_MAX_STACK_DEPTH) {
 		pr_warning("corrupted callchain. skipping...\n");
 		return 0;
 	}
 
-	/*
-	 * Based on DWARF debug information, some architectures skip
-	 * a callchain entry saved by the kernel.
-	 */
-	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
-
-	for (i = 0; i < chain_nr; i++) {
+	for (i = first_call; i < chain_nr; i++) {
 		u64 ip;
-		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
 			j = i;
@@ -1437,24 +1598,10 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 			continue;
 		}
 
-		al.filtered = 0;
-		thread__find_addr_location(thread, machine, cpumode,
-					   MAP__FUNCTION, ip, &al);
-		if (al.sym != NULL) {
-			if (sort__has_parent && !*parent &&
-			    symbol__match_regex(al.sym, &parent_regex))
-				*parent = al.sym;
-			else if (have_ignore_callees && root_al &&
-			  symbol__match_regex(al.sym, &ignore_callees_regex)) {
-				/* Treat this symbol as the root,
-				   forgetting its callees. */
-				*root_al = al;
-				callchain_cursor_reset(&callchain_cursor);
-			}
-		}
-
-		err = callchain_cursor_append(&callchain_cursor,
-					      ip, al.map, al.sym);
+		err = add_callchain_ip(thread, parent, root_al,
+				       cpumode, ip);
+		if (err == -EINVAL)
+			break;
 		if (err)
 			return err;
 	}
@@ -1469,19 +1616,16 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
 				       entry->map, entry->sym);
 }
 
-int machine__resolve_callchain(struct machine *machine,
-			       struct perf_evsel *evsel,
-			       struct thread *thread,
-			       struct perf_sample *sample,
-			       struct symbol **parent,
-			       struct addr_location *root_al,
-			       int max_stack)
+int thread__resolve_callchain(struct thread *thread,
+			      struct perf_evsel *evsel,
+			      struct perf_sample *sample,
+			      struct symbol **parent,
+			      struct addr_location *root_al,
+			      int max_stack)
 {
-	int ret;
-
-	ret = machine__resolve_callchain_sample(machine, thread,
-						sample->callchain, parent,
-						root_al, max_stack);
+	int ret = thread__resolve_callchain_sample(thread, sample->callchain,
+						   sample->branch_stack,
+						   parent, root_al, max_stack);
 	if (ret)
 		return ret;
 
@@ -1495,7 +1639,7 @@ int machine__resolve_callchain(struct machine *machine,
 	    (!sample->user_stack.size))
 		return 0;
 
-	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
+	return unwind__get_entries(unwind_entry, &callchain_cursor,
 				   thread, sample, max_stack);
 
 }
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 2b651a7f5d0d..e8b7779a0a3f 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -40,6 +40,10 @@ struct machine {
 	u64		  kernel_start;
 	symbol_filter_t	  symbol_filter;
 	pid_t		  *current_tid;
+	union { /* Tool specific area */
+		void	  *priv;
+		u64	  db_id;
+	};
 };
 
 static inline
@@ -122,13 +126,12 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 					   struct addr_location *al);
 struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 				     struct addr_location *al);
-int machine__resolve_callchain(struct machine *machine,
-			       struct perf_evsel *evsel,
-			       struct thread *thread,
-			       struct perf_sample *sample,
-			       struct symbol **parent,
-			       struct addr_location *root_al,
-			       int max_stack);
+int thread__resolve_callchain(struct thread *thread,
+			      struct perf_evsel *evsel,
+			      struct perf_sample *sample,
+			      struct symbol **parent,
+			      struct addr_location *root_al,
+			      int max_stack);
 
 /*
  * Default guest kernel is defined by parameter --guestkallsyms
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 2137c4596ec7..62ca9f2607d5 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -360,7 +360,7 @@ int map__fprintf_srcline(struct map *map, u64 addr, const char *prefix,
 
 	if (map && map->dso) {
 		srcline = get_srcline(map->dso,
-				      map__rip_2objdump(map, addr));
+				      map__rip_2objdump(map, addr), NULL, true);
 		if (srcline != SRCLINE_UNKNOWN)
 			ret = fprintf(fp, "%s%s", prefix, srcline);
 		free_srcline(srcline);
@@ -413,14 +413,14 @@ u64 map__objdump_2mem(struct map *map, u64 ip)
 	return ip + map->reloc;
 }
 
-void map_groups__init(struct map_groups *mg)
+void map_groups__init(struct map_groups *mg, struct machine *machine)
 {
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i) {
 		mg->maps[i] = RB_ROOT;
 		INIT_LIST_HEAD(&mg->removed_maps[i]);
 	}
-	mg->machine = NULL;
+	mg->machine = machine;
 	mg->refcnt = 1;
 }
 
@@ -471,12 +471,12 @@ bool map_groups__empty(struct map_groups *mg)
 	return true;
 }
 
-struct map_groups *map_groups__new(void)
+struct map_groups *map_groups__new(struct machine *machine)
 {
 	struct map_groups *mg = malloc(sizeof(*mg));
 
 	if (mg != NULL)
-		map_groups__init(mg);
+		map_groups__init(mg, machine);
 
 	return mg;
 }
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 2f83954af050..6951a9d42339 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -64,7 +64,7 @@ struct map_groups {
 	int		 refcnt;
 };
 
-struct map_groups *map_groups__new(void);
+struct map_groups *map_groups__new(struct machine *machine);
 void map_groups__delete(struct map_groups *mg);
 bool map_groups__empty(struct map_groups *mg);
 
@@ -150,7 +150,7 @@ void maps__remove(struct rb_root *maps, struct map *map);
 struct map *maps__find(struct rb_root *maps, u64 addr);
 struct map *maps__first(struct rb_root *maps);
 struct map *maps__next(struct map *map);
-void map_groups__init(struct map_groups *mg);
+void map_groups__init(struct map_groups *mg, struct machine *machine);
 void map_groups__exit(struct map_groups *mg);
 int map_groups__clone(struct map_groups *mg,
 		      struct map_groups *parent, enum map_type type);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c659a3ca1283..77b43fe43d55 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -681,6 +681,8 @@ int parse_events_add_pmu(struct list_head *list, int *idx,
 	if (evsel) {
 		evsel->unit = info.unit;
 		evsel->scale = info.scale;
+		evsel->per_pkg = info.per_pkg;
+		evsel->snapshot = info.snapshot;
 	}
 
 	return evsel ? 0 : -ENOMEM;
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index bf48092983c6..f62dee7bd924 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -42,7 +42,26 @@ static int get_value(struct parse_opt_ctx_t *p,
 		return opterror(opt, "takes no value", flags);
 	if (unset && (opt->flags & PARSE_OPT_NONEG))
 		return opterror(opt, "isn't available", flags);
-
+	if (opt->flags & PARSE_OPT_DISABLED)
+		return opterror(opt, "is not usable", flags);
+
+	if (opt->flags & PARSE_OPT_EXCLUSIVE) {
+		if (p->excl_opt) {
+			char msg[128];
+
+			if (((flags & OPT_SHORT) && p->excl_opt->short_name) ||
+			    p->excl_opt->long_name == NULL) {
+				scnprintf(msg, sizeof(msg), "cannot be used with switch `%c'",
+					  p->excl_opt->short_name);
+			} else {
+				scnprintf(msg, sizeof(msg), "cannot be used with %s",
+					  p->excl_opt->long_name);
+			}
+			opterror(opt, msg, flags);
+			return -3;
+		}
+		p->excl_opt = opt;
+	}
 	if (!(flags & OPT_SHORT) && p->opt) {
 		switch (opt->type) {
 		case OPTION_CALLBACK:
@@ -343,13 +362,14 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 		       const char * const usagestr[])
 {
 	int internal_help = !(ctx->flags & PARSE_OPT_NO_INTERNAL_HELP);
+	int excl_short_opt = 1;
+	const char *arg;
 
 	/* we must reset ->opt, unknown short option leave it dangling */
 	ctx->opt = NULL;
 
 	for (; ctx->argc; ctx->argc--, ctx->argv++) {
-		const char *arg = ctx->argv[0];
-
+		arg = ctx->argv[0];
 		if (*arg != '-' || !arg[1]) {
 			if (ctx->flags & PARSE_OPT_STOP_AT_NON_OPTION)
 				break;
@@ -358,19 +378,21 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 		}
 
 		if (arg[1] != '-') {
-			ctx->opt = arg + 1;
+			ctx->opt = ++arg;
 			if (internal_help && *ctx->opt == 'h')
 				return usage_with_options_internal(usagestr, options, 0);
 			switch (parse_short_opt(ctx, options)) {
 			case -1:
-				return parse_options_usage(usagestr, options, arg + 1, 1);
+				return parse_options_usage(usagestr, options, arg, 1);
 			case -2:
 				goto unknown;
+			case -3:
+				goto exclusive;
 			default:
 				break;
 			}
 			if (ctx->opt)
-				check_typos(arg + 1, options);
+				check_typos(arg, options);
 			while (ctx->opt) {
 				if (internal_help && *ctx->opt == 'h')
 					return usage_with_options_internal(usagestr, options, 0);
@@ -387,6 +409,8 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 					ctx->argv[0] = strdup(ctx->opt - 1);
 					*(char *)ctx->argv[0] = '-';
 					goto unknown;
+				case -3:
+					goto exclusive;
 				default:
 					break;
 				}
@@ -402,19 +426,23 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 			break;
 		}
 
-		if (internal_help && !strcmp(arg + 2, "help-all"))
+		arg += 2;
+		if (internal_help && !strcmp(arg, "help-all"))
 			return usage_with_options_internal(usagestr, options, 1);
-		if (internal_help && !strcmp(arg + 2, "help"))
+		if (internal_help && !strcmp(arg, "help"))
 			return usage_with_options_internal(usagestr, options, 0);
-		if (!strcmp(arg + 2, "list-opts"))
+		if (!strcmp(arg, "list-opts"))
 			return PARSE_OPT_LIST_OPTS;
-		if (!strcmp(arg + 2, "list-cmds"))
+		if (!strcmp(arg, "list-cmds"))
 			return PARSE_OPT_LIST_SUBCMDS;
-		switch (parse_long_opt(ctx, arg + 2, options)) {
+		switch (parse_long_opt(ctx, arg, options)) {
 		case -1:
-			return parse_options_usage(usagestr, options, arg + 2, 0);
+			return parse_options_usage(usagestr, options, arg, 0);
 		case -2:
 			goto unknown;
+		case -3:
+			excl_short_opt = 0;
+			goto exclusive;
 		default:
 			break;
 		}
@@ -426,6 +454,17 @@ int parse_options_step(struct parse_opt_ctx_t *ctx,
 		ctx->opt = NULL;
 	}
 	return PARSE_OPT_DONE;
+
+exclusive:
+	parse_options_usage(usagestr, options, arg, excl_short_opt);
+	if ((excl_short_opt && ctx->excl_opt->short_name) ||
+	    ctx->excl_opt->long_name == NULL) {
+		char opt = ctx->excl_opt->short_name;
+		parse_options_usage(NULL, options, &opt, 1);
+	} else {
+		parse_options_usage(NULL, options, ctx->excl_opt->long_name, 0);
+	}
+	return PARSE_OPT_HELP;
 }
 
 int parse_options_end(struct parse_opt_ctx_t *ctx)
@@ -509,6 +548,8 @@ static void print_option_help(const struct option *opts, int full)
 	}
 	if (!full && (opts->flags & PARSE_OPT_HIDDEN))
 		return;
+	if (opts->flags & PARSE_OPT_DISABLED)
+		return;
 
 	pos = fprintf(stderr, "    ");
 	if (opts->short_name)
@@ -679,3 +720,16 @@ int parse_opt_verbosity_cb(const struct option *opt,
 	}
 	return 0;
 }
+
+void set_option_flag(struct option *opts, int shortopt, const char *longopt,
+		     int flag)
+{
+	for (; opts->type != OPTION_END; opts++) {
+		if ((shortopt && opts->short_name == shortopt) ||
+		    (opts->long_name && longopt &&
+		     !strcmp(opts->long_name, longopt))) {
+			opts->flags |= flag;
+			break;
+		}
+	}
+}
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index b59ba858e73d..97b153fb4999 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -38,6 +38,8 @@ enum parse_opt_option_flags {
 	PARSE_OPT_NONEG   = 4,
 	PARSE_OPT_HIDDEN  = 8,
 	PARSE_OPT_LASTARG_DEFAULT = 16,
+	PARSE_OPT_DISABLED = 32,
+	PARSE_OPT_EXCLUSIVE = 64,
 };
 
 struct option;
@@ -173,6 +175,7 @@ struct parse_opt_ctx_t {
 	const char **out;
 	int argc, cpidx;
 	const char *opt;
+	const struct option *excl_opt;
 	int flags;
 };
 
@@ -211,4 +214,5 @@ extern int parse_opt_verbosity_cb(const struct option *, const char *, int);
 
 extern const char *parse_options_fix_filename(const char *prefix, const char *file);
 
+void set_option_flag(struct option *opts, int sopt, const char *lopt, int flag);
 #endif /* __PERF_PARSE_OPTIONS_H */
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index e243ad962a4d..5c9c4947cfb4 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -163,6 +163,41 @@ static int perf_pmu__parse_unit(struct perf_pmu_alias *alias, char *dir, char *n
 	return -1;
 }
 
+static int
+perf_pmu__parse_per_pkg(struct perf_pmu_alias *alias, char *dir, char *name)
+{
+	char path[PATH_MAX];
+	int fd;
+
+	snprintf(path, PATH_MAX, "%s/%s.per-pkg", dir, name);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	close(fd);
+
+	alias->per_pkg = true;
+	return 0;
+}
+
+static int perf_pmu__parse_snapshot(struct perf_pmu_alias *alias,
+				    char *dir, char *name)
+{
+	char path[PATH_MAX];
+	int fd;
+
+	snprintf(path, PATH_MAX, "%s/%s.snapshot", dir, name);
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	alias->snapshot = true;
+	close(fd);
+	return 0;
+}
+
 static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FILE *file)
 {
 	struct perf_pmu_alias *alias;
@@ -181,6 +216,7 @@ static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FI
 	INIT_LIST_HEAD(&alias->terms);
 	alias->scale = 1.0;
 	alias->unit[0] = '\0';
+	alias->per_pkg = false;
 
 	ret = parse_events_terms(&alias->terms, buf);
 	if (ret) {
@@ -194,6 +230,8 @@ static int perf_pmu__new_alias(struct list_head *list, char *dir, char *name, FI
 	 */
 	perf_pmu__parse_unit(alias, dir, name);
 	perf_pmu__parse_scale(alias, dir, name);
+	perf_pmu__parse_per_pkg(alias, dir, name);
+	perf_pmu__parse_snapshot(alias, dir, name);
 
 	list_add_tail(&alias->list, list);
 
@@ -209,6 +247,10 @@ static inline bool pmu_alias_info_file(char *name)
 		return true;
 	if (len > 6 && !strcmp(name + len - 6, ".scale"))
 		return true;
+	if (len > 8 && !strcmp(name + len - 8, ".per-pkg"))
+		return true;
+	if (len > 9 && !strcmp(name + len - 9, ".snapshot"))
+		return true;
 
 	return false;
 }
@@ -617,23 +659,27 @@ static struct perf_pmu_alias *pmu_find_alias(struct perf_pmu *pmu,
 }
 
 
-static int check_unit_scale(struct perf_pmu_alias *alias,
-			    const char **unit, double *scale)
+static int check_info_data(struct perf_pmu_alias *alias,
+			   struct perf_pmu_info *info)
 {
 	/*
 	 * Only one term in event definition can
-	 * define unit and scale, fail if there's
-	 * more than one.
+	 * define unit, scale and snapshot, fail
+	 * if there's more than one.
 	 */
-	if ((*unit && alias->unit) ||
-	    (*scale && alias->scale))
+	if ((info->unit && alias->unit) ||
+	    (info->scale && alias->scale) ||
+	    (info->snapshot && alias->snapshot))
 		return -EINVAL;
 
 	if (alias->unit)
-		*unit = alias->unit;
+		info->unit = alias->unit;
 
 	if (alias->scale)
-		*scale = alias->scale;
+		info->scale = alias->scale;
+
+	if (alias->snapshot)
+		info->snapshot = alias->snapshot;
 
 	return 0;
 }
@@ -649,12 +695,15 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 	struct perf_pmu_alias *alias;
 	int ret;
 
+	info->per_pkg = false;
+
 	/*
 	 * Mark unit and scale as not set
 	 * (different from default values, see below)
 	 */
-	info->unit   = NULL;
-	info->scale  = 0.0;
+	info->unit     = NULL;
+	info->scale    = 0.0;
+	info->snapshot = false;
 
 	list_for_each_entry_safe(term, h, head_terms, list) {
 		alias = pmu_find_alias(pmu, term);
@@ -664,10 +713,13 @@ int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms,
 		if (ret)
 			return ret;
 
-		ret = check_unit_scale(alias, &info->unit, &info->scale);
+		ret = check_info_data(alias, info);
 		if (ret)
 			return ret;
 
+		if (alias->per_pkg)
+			info->per_pkg = true;
+
 		list_del(&term->list);
 		free(term);
 	}
@@ -747,15 +799,18 @@ void print_pmu_events(const char *event_glob, bool name_only)
 
 	pmu = NULL;
 	len = 0;
-	while ((pmu = perf_pmu__scan(pmu)) != NULL)
+	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
 		list_for_each_entry(alias, &pmu->aliases, list)
 			len++;
-	aliases = malloc(sizeof(char *) * len);
+		if (pmu->selectable)
+			len++;
+	}
+	aliases = zalloc(sizeof(char *) * len);
 	if (!aliases)
-		return;
+		goto out_enomem;
 	pmu = NULL;
 	j = 0;
-	while ((pmu = perf_pmu__scan(pmu)) != NULL)
+	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
 		list_for_each_entry(alias, &pmu->aliases, list) {
 			char *name = format_alias(buf, sizeof(buf), pmu, alias);
 			bool is_cpu = !strcmp(pmu->name, "cpu");
@@ -765,13 +820,23 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			      (!is_cpu && strglobmatch(alias->name,
 						       event_glob))))
 				continue;
-			aliases[j] = name;
+
 			if (is_cpu && !name_only)
-				aliases[j] = format_alias_or(buf, sizeof(buf),
-							      pmu, alias);
-			aliases[j] = strdup(aliases[j]);
+				name = format_alias_or(buf, sizeof(buf), pmu, alias);
+
+			aliases[j] = strdup(name);
+			if (aliases[j] == NULL)
+				goto out_enomem;
 			j++;
 		}
+		if (pmu->selectable) {
+			char *s;
+			if (asprintf(&s, "%s//", pmu->name) < 0)
+				goto out_enomem;
+			aliases[j] = s;
+			j++;
+		}
+	}
 	len = j;
 	qsort(aliases, len, sizeof(char *), cmp_string);
 	for (j = 0; j < len; j++) {
@@ -780,12 +845,20 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			continue;
 		}
 		printf("  %-50s [Kernel PMU event]\n", aliases[j]);
-		zfree(&aliases[j]);
 		printed++;
 	}
 	if (printed)
 		printf("\n");
-	free(aliases);
+out_free:
+	for (j = 0; j < len; j++)
+		zfree(&aliases[j]);
+	zfree(&aliases);
+	return;
+
+out_enomem:
+	printf("FATAL: not enough memory to print PMU events\n");
+	if (aliases)
+		goto out_free;
 }
 
 bool pmu_have_event(const char *pname, const char *name)
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index fe9dfbee8eed..6b1249fbdb5f 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -18,6 +18,7 @@ struct perf_event_attr;
 struct perf_pmu {
 	char *name;
 	__u32 type;
+	bool selectable;
 	struct perf_event_attr *default_config;
 	struct cpu_map *cpus;
 	struct list_head format;  /* HEAD struct perf_pmu_format -> list */
@@ -28,6 +29,8 @@ struct perf_pmu {
 struct perf_pmu_info {
 	const char *unit;
 	double scale;
+	bool per_pkg;
+	bool snapshot;
 };
 
 #define UNIT_MAX_LEN	31 /* max length for event unit name */
@@ -38,6 +41,8 @@ struct perf_pmu_alias {
 	struct list_head list;  /* ELEM */
 	char unit[UNIT_MAX_LEN+1];
 	double scale;
+	bool per_pkg;
+	bool snapshot;
 };
 
 struct perf_pmu *perf_pmu__find(const char *name);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c150ca4343eb..28eb1417cb2a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1910,21 +1910,21 @@ static int show_perf_probe_event(struct perf_probe_event *pev,
 	if (ret < 0)
 		return ret;
 
-	printf("  %-20s (on %s", buf, place);
+	pr_info("  %-20s (on %s", buf, place);
 	if (module)
-		printf(" in %s", module);
+		pr_info(" in %s", module);
 
 	if (pev->nargs > 0) {
-		printf(" with");
+		pr_info(" with");
 		for (i = 0; i < pev->nargs; i++) {
 			ret = synthesize_perf_probe_arg(&pev->args[i],
 							buf, 128);
 			if (ret < 0)
 				break;
-			printf(" %s", buf);
+			pr_info(" %s", buf);
 		}
 	}
-	printf(")\n");
+	pr_info(")\n");
 	free(place);
 	return ret;
 }
@@ -2124,7 +2124,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	ret = 0;
-	printf("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
+	pr_info("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
 	for (i = 0; i < ntevs; i++) {
 		tev = &tevs[i];
 		if (pev->event)
@@ -2179,8 +2179,8 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 
 	if (ret >= 0) {
 		/* Show how to use the event. */
-		printf("\nYou can now use it in all perf tools, such as:\n\n");
-		printf("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
+		pr_info("\nYou can now use it in all perf tools, such as:\n\n");
+		pr_info("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
 			 tev->event);
 	}
 
@@ -2444,7 +2444,7 @@ static int __del_trace_probe_event(int fd, struct str_node *ent)
 		goto error;
 	}
 
-	printf("Removed event: %s\n", ent->s);
+	pr_info("Removed event: %s\n", ent->s);
 	return 0;
 error:
 	pr_warning("Failed to delete event: %s\n",
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 0a01bac4ce02..22ebc46226e7 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -24,6 +24,7 @@
 #include <string.h>
 #include <ctype.h>
 #include <errno.h>
+#include <linux/bitmap.h>
 
 #include "../util.h"
 #include <EXTERN.h>
@@ -57,7 +58,7 @@ INTERP my_perl;
 #define FTRACE_MAX_EVENT				\
 	((1 << (sizeof(unsigned short) * 8)) - 1)
 
-struct event_format *events[FTRACE_MAX_EVENT];
+static DECLARE_BITMAP(events_defined, FTRACE_MAX_EVENT);
 
 extern struct scripting_context *scripting_context;
 
@@ -238,35 +239,15 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
-{
-	static char ev_name[256];
-	struct event_format *event;
-	int type = evsel->attr.config;
-
-	if (events[type])
-		return events[type];
-
-	events[type] = event = evsel->tp_format;
-	if (!event)
-		return NULL;
-
-	sprintf(ev_name, "%s::%s", event->system, event->name);
-
-	define_event_symbols(event, ev_name, event->print_fmt.args);
-
-	return event;
-}
-
 static void perl_process_tracepoint(struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct thread *thread)
 {
+	struct event_format *event = evsel->tp_format;
 	struct format_field *field;
 	static char handler[256];
 	unsigned long long val;
 	unsigned long s, ns;
-	struct event_format *event;
 	int pid;
 	int cpu = sample->cpu;
 	void *data = sample->raw_data;
@@ -278,7 +259,6 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 	if (evsel->attr.type != PERF_TYPE_TRACEPOINT)
 		return;
 
-	event = find_cache_event(evsel);
 	if (!event)
 		die("ug! no event found for type %" PRIu64, (u64)evsel->attr.config);
 
@@ -286,6 +266,9 @@ static void perl_process_tracepoint(struct perf_sample *sample,
 
 	sprintf(handler, "%s::%s", event->system, event->name);
 
+	if (!test_and_set_bit(event->id, events_defined))
+		define_event_symbols(event, handler, event->print_fmt.args);
+
 	s = nsecs / NSECS_PER_SEC;
 	ns = nsecs - s * NSECS_PER_SEC;
 
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 496f21cadd97..d808a328f4dc 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -24,7 +24,9 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <stdbool.h>
 #include <errno.h>
+#include <linux/bitmap.h>
 
 #include "../../perf.h"
 #include "../debug.h"
@@ -33,6 +35,10 @@
 #include "../util.h"
 #include "../event.h"
 #include "../thread.h"
+#include "../comm.h"
+#include "../machine.h"
+#include "../db-export.h"
+#include "../thread-stack.h"
 #include "../trace-event.h"
 #include "../machine.h"
 
@@ -41,7 +47,7 @@ PyMODINIT_FUNC initperf_trace_context(void);
 #define FTRACE_MAX_EVENT				\
 	((1 << (sizeof(unsigned short) * 8)) - 1)
 
-struct event_format *events[FTRACE_MAX_EVENT];
+static DECLARE_BITMAP(events_defined, FTRACE_MAX_EVENT);
 
 #define MAX_FIELDS	64
 #define N_COMMON_FIELDS	7
@@ -53,6 +59,24 @@ static int zero_flag_atom;
 
 static PyObject *main_module, *main_dict;
 
+struct tables {
+	struct db_export	dbe;
+	PyObject		*evsel_handler;
+	PyObject		*machine_handler;
+	PyObject		*thread_handler;
+	PyObject		*comm_handler;
+	PyObject		*comm_thread_handler;
+	PyObject		*dso_handler;
+	PyObject		*symbol_handler;
+	PyObject		*branch_type_handler;
+	PyObject		*sample_handler;
+	PyObject		*call_path_handler;
+	PyObject		*call_return_handler;
+	bool			db_export_mode;
+};
+
+static struct tables tables_global;
+
 static void handler_call_die(const char *handler_name) NORETURN;
 static void handler_call_die(const char *handler_name)
 {
@@ -232,31 +256,6 @@ static void define_event_symbols(struct event_format *event,
 		define_event_symbols(event, ev_name, args->next);
 }
 
-static inline struct event_format *find_cache_event(struct perf_evsel *evsel)
-{
-	static char ev_name[256];
-	struct event_format *event;
-	int type = evsel->attr.config;
-
-	/*
- 	 * XXX: Do we really need to cache this since now we have evsel->tp_format
- 	 * cached already? Need to re-read this "cache" routine that as well calls
- 	 * define_event_symbols() :-\
- 	 */
-	if (events[type])
-		return events[type];
-
-	events[type] = event = evsel->tp_format;
-	if (!event)
-		return NULL;
-
-	sprintf(ev_name, "%s__%s", event->system, event->name);
-
-	define_event_symbols(event, ev_name, event->print_fmt.args);
-
-	return event;
-}
-
 static PyObject *get_field_numeric_entry(struct event_format *event,
 		struct format_field *field, void *data)
 {
@@ -312,9 +311,9 @@ static PyObject *python_process_callchain(struct perf_sample *sample,
 	if (!symbol_conf.use_callchain || !sample->callchain)
 		goto exit;
 
-	if (machine__resolve_callchain(al->machine, evsel, al->thread,
-					   sample, NULL, NULL,
-					   PERF_MAX_STACK_DEPTH) != 0) {
+	if (thread__resolve_callchain(al->thread, evsel,
+				      sample, NULL, NULL,
+				      PERF_MAX_STACK_DEPTH) != 0) {
 		pr_err("Failed to resolve callchain. Skipping\n");
 		goto exit;
 	}
@@ -380,12 +379,12 @@ static void python_process_tracepoint(struct perf_sample *sample,
 				      struct thread *thread,
 				      struct addr_location *al)
 {
+	struct event_format *event = evsel->tp_format;
 	PyObject *handler, *context, *t, *obj, *callchain;
 	PyObject *dict = NULL;
 	static char handler_name[256];
 	struct format_field *field;
 	unsigned long s, ns;
-	struct event_format *event;
 	unsigned n = 0;
 	int pid;
 	int cpu = sample->cpu;
@@ -397,7 +396,6 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	if (!t)
 		Py_FatalError("couldn't create Python tuple");
 
-	event = find_cache_event(evsel);
 	if (!event)
 		die("ug! no event found for type %d", (int)evsel->attr.config);
 
@@ -405,6 +403,9 @@ static void python_process_tracepoint(struct perf_sample *sample,
 
 	sprintf(handler_name, "%s__%s", event->system, event->name);
 
+	if (!test_and_set_bit(event->id, events_defined))
+		define_event_symbols(event, handler_name, event->print_fmt.args);
+
 	handler = get_handler(handler_name);
 	if (!handler) {
 		dict = PyDict_New();
@@ -475,6 +476,289 @@ static void python_process_tracepoint(struct perf_sample *sample,
 	Py_DECREF(t);
 }
 
+static PyObject *tuple_new(unsigned int sz)
+{
+	PyObject *t;
+
+	t = PyTuple_New(sz);
+	if (!t)
+		Py_FatalError("couldn't create Python tuple");
+	return t;
+}
+
+static int tuple_set_u64(PyObject *t, unsigned int pos, u64 val)
+{
+#if BITS_PER_LONG == 64
+	return PyTuple_SetItem(t, pos, PyInt_FromLong(val));
+#endif
+#if BITS_PER_LONG == 32
+	return PyTuple_SetItem(t, pos, PyLong_FromLongLong(val));
+#endif
+}
+
+static int tuple_set_s32(PyObject *t, unsigned int pos, s32 val)
+{
+	return PyTuple_SetItem(t, pos, PyInt_FromLong(val));
+}
+
+static int tuple_set_string(PyObject *t, unsigned int pos, const char *s)
+{
+	return PyTuple_SetItem(t, pos, PyString_FromString(s));
+}
+
+static int python_export_evsel(struct db_export *dbe, struct perf_evsel *evsel)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(2);
+
+	tuple_set_u64(t, 0, evsel->db_id);
+	tuple_set_string(t, 1, perf_evsel__name(evsel));
+
+	call_object(tables->evsel_handler, t, "evsel_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_machine(struct db_export *dbe,
+				 struct machine *machine)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(3);
+
+	tuple_set_u64(t, 0, machine->db_id);
+	tuple_set_s32(t, 1, machine->pid);
+	tuple_set_string(t, 2, machine->root_dir ? machine->root_dir : "");
+
+	call_object(tables->machine_handler, t, "machine_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_thread(struct db_export *dbe, struct thread *thread,
+				u64 main_thread_db_id, struct machine *machine)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(5);
+
+	tuple_set_u64(t, 0, thread->db_id);
+	tuple_set_u64(t, 1, machine->db_id);
+	tuple_set_u64(t, 2, main_thread_db_id);
+	tuple_set_s32(t, 3, thread->pid_);
+	tuple_set_s32(t, 4, thread->tid);
+
+	call_object(tables->thread_handler, t, "thread_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_comm(struct db_export *dbe, struct comm *comm)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(2);
+
+	tuple_set_u64(t, 0, comm->db_id);
+	tuple_set_string(t, 1, comm__str(comm));
+
+	call_object(tables->comm_handler, t, "comm_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_comm_thread(struct db_export *dbe, u64 db_id,
+				     struct comm *comm, struct thread *thread)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(3);
+
+	tuple_set_u64(t, 0, db_id);
+	tuple_set_u64(t, 1, comm->db_id);
+	tuple_set_u64(t, 2, thread->db_id);
+
+	call_object(tables->comm_thread_handler, t, "comm_thread_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_dso(struct db_export *dbe, struct dso *dso,
+			     struct machine *machine)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+	PyObject *t;
+
+	build_id__sprintf(dso->build_id, sizeof(dso->build_id), sbuild_id);
+
+	t = tuple_new(5);
+
+	tuple_set_u64(t, 0, dso->db_id);
+	tuple_set_u64(t, 1, machine->db_id);
+	tuple_set_string(t, 2, dso->short_name);
+	tuple_set_string(t, 3, dso->long_name);
+	tuple_set_string(t, 4, sbuild_id);
+
+	call_object(tables->dso_handler, t, "dso_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_symbol(struct db_export *dbe, struct symbol *sym,
+				struct dso *dso)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	u64 *sym_db_id = symbol__priv(sym);
+	PyObject *t;
+
+	t = tuple_new(6);
+
+	tuple_set_u64(t, 0, *sym_db_id);
+	tuple_set_u64(t, 1, dso->db_id);
+	tuple_set_u64(t, 2, sym->start);
+	tuple_set_u64(t, 3, sym->end);
+	tuple_set_s32(t, 4, sym->binding);
+	tuple_set_string(t, 5, sym->name);
+
+	call_object(tables->symbol_handler, t, "symbol_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_branch_type(struct db_export *dbe, u32 branch_type,
+				     const char *name)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(2);
+
+	tuple_set_s32(t, 0, branch_type);
+	tuple_set_string(t, 1, name);
+
+	call_object(tables->branch_type_handler, t, "branch_type_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_sample(struct db_export *dbe,
+				struct export_sample *es)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+
+	t = tuple_new(21);
+
+	tuple_set_u64(t, 0, es->db_id);
+	tuple_set_u64(t, 1, es->evsel->db_id);
+	tuple_set_u64(t, 2, es->al->machine->db_id);
+	tuple_set_u64(t, 3, es->thread->db_id);
+	tuple_set_u64(t, 4, es->comm_db_id);
+	tuple_set_u64(t, 5, es->dso_db_id);
+	tuple_set_u64(t, 6, es->sym_db_id);
+	tuple_set_u64(t, 7, es->offset);
+	tuple_set_u64(t, 8, es->sample->ip);
+	tuple_set_u64(t, 9, es->sample->time);
+	tuple_set_s32(t, 10, es->sample->cpu);
+	tuple_set_u64(t, 11, es->addr_dso_db_id);
+	tuple_set_u64(t, 12, es->addr_sym_db_id);
+	tuple_set_u64(t, 13, es->addr_offset);
+	tuple_set_u64(t, 14, es->sample->addr);
+	tuple_set_u64(t, 15, es->sample->period);
+	tuple_set_u64(t, 16, es->sample->weight);
+	tuple_set_u64(t, 17, es->sample->transaction);
+	tuple_set_u64(t, 18, es->sample->data_src);
+	tuple_set_s32(t, 19, es->sample->flags & PERF_BRANCH_MASK);
+	tuple_set_s32(t, 20, !!(es->sample->flags & PERF_IP_FLAG_IN_TX));
+
+	call_object(tables->sample_handler, t, "sample_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_call_path(struct db_export *dbe, struct call_path *cp)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	PyObject *t;
+	u64 parent_db_id, sym_db_id;
+
+	parent_db_id = cp->parent ? cp->parent->db_id : 0;
+	sym_db_id = cp->sym ? *(u64 *)symbol__priv(cp->sym) : 0;
+
+	t = tuple_new(4);
+
+	tuple_set_u64(t, 0, cp->db_id);
+	tuple_set_u64(t, 1, parent_db_id);
+	tuple_set_u64(t, 2, sym_db_id);
+	tuple_set_u64(t, 3, cp->ip);
+
+	call_object(tables->call_path_handler, t, "call_path_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_export_call_return(struct db_export *dbe,
+				     struct call_return *cr)
+{
+	struct tables *tables = container_of(dbe, struct tables, dbe);
+	u64 comm_db_id = cr->comm ? cr->comm->db_id : 0;
+	PyObject *t;
+
+	t = tuple_new(11);
+
+	tuple_set_u64(t, 0, cr->db_id);
+	tuple_set_u64(t, 1, cr->thread->db_id);
+	tuple_set_u64(t, 2, comm_db_id);
+	tuple_set_u64(t, 3, cr->cp->db_id);
+	tuple_set_u64(t, 4, cr->call_time);
+	tuple_set_u64(t, 5, cr->return_time);
+	tuple_set_u64(t, 6, cr->branch_count);
+	tuple_set_u64(t, 7, cr->call_ref);
+	tuple_set_u64(t, 8, cr->return_ref);
+	tuple_set_u64(t, 9, cr->cp->parent->db_id);
+	tuple_set_s32(t, 10, cr->flags);
+
+	call_object(tables->call_return_handler, t, "call_return_table");
+
+	Py_DECREF(t);
+
+	return 0;
+}
+
+static int python_process_call_return(struct call_return *cr, void *data)
+{
+	struct db_export *dbe = data;
+
+	return db_export__call_return(dbe, cr);
+}
+
 static void python_process_general_event(struct perf_sample *sample,
 					 struct perf_evsel *evsel,
 					 struct thread *thread,
@@ -551,19 +835,25 @@ static void python_process_general_event(struct perf_sample *sample,
 	Py_DECREF(t);
 }
 
-static void python_process_event(union perf_event *event __maybe_unused,
+static void python_process_event(union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct thread *thread,
 				 struct addr_location *al)
 {
+	struct tables *tables = &tables_global;
+
 	switch (evsel->attr.type) {
 	case PERF_TYPE_TRACEPOINT:
 		python_process_tracepoint(sample, evsel, thread, al);
 		break;
 	/* Reserve for future process_hw/sw/raw APIs */
 	default:
-		python_process_general_event(sample, evsel, thread, al);
+		if (tables->db_export_mode)
+			db_export__sample(&tables->dbe, event, sample, evsel,
+					  thread, al);
+		else
+			python_process_general_event(sample, evsel, thread, al);
 	}
 }
 
@@ -589,11 +879,79 @@ static int run_start_sub(void)
 	return -1;
 }
 
+#define SET_TABLE_HANDLER_(name, handler_name, table_name) do {		\
+	tables->handler_name = get_handler(#table_name);		\
+	if (tables->handler_name)					\
+		tables->dbe.export_ ## name = python_export_ ## name;	\
+} while (0)
+
+#define SET_TABLE_HANDLER(name) \
+	SET_TABLE_HANDLER_(name, name ## _handler, name ## _table)
+
+static void set_table_handlers(struct tables *tables)
+{
+	const char *perf_db_export_mode = "perf_db_export_mode";
+	const char *perf_db_export_calls = "perf_db_export_calls";
+	PyObject *db_export_mode, *db_export_calls;
+	bool export_calls = false;
+	int ret;
+
+	memset(tables, 0, sizeof(struct tables));
+	if (db_export__init(&tables->dbe))
+		Py_FatalError("failed to initialize export");
+
+	db_export_mode = PyDict_GetItemString(main_dict, perf_db_export_mode);
+	if (!db_export_mode)
+		return;
+
+	ret = PyObject_IsTrue(db_export_mode);
+	if (ret == -1)
+		handler_call_die(perf_db_export_mode);
+	if (!ret)
+		return;
+
+	tables->dbe.crp = NULL;
+	db_export_calls = PyDict_GetItemString(main_dict, perf_db_export_calls);
+	if (db_export_calls) {
+		ret = PyObject_IsTrue(db_export_calls);
+		if (ret == -1)
+			handler_call_die(perf_db_export_calls);
+		export_calls = !!ret;
+	}
+
+	if (export_calls) {
+		tables->dbe.crp =
+			call_return_processor__new(python_process_call_return,
+						   &tables->dbe);
+		if (!tables->dbe.crp)
+			Py_FatalError("failed to create calls processor");
+	}
+
+	tables->db_export_mode = true;
+	/*
+	 * Reserve per symbol space for symbol->db_id via symbol__priv()
+	 */
+	symbol_conf.priv_size = sizeof(u64);
+
+	SET_TABLE_HANDLER(evsel);
+	SET_TABLE_HANDLER(machine);
+	SET_TABLE_HANDLER(thread);
+	SET_TABLE_HANDLER(comm);
+	SET_TABLE_HANDLER(comm_thread);
+	SET_TABLE_HANDLER(dso);
+	SET_TABLE_HANDLER(symbol);
+	SET_TABLE_HANDLER(branch_type);
+	SET_TABLE_HANDLER(sample);
+	SET_TABLE_HANDLER(call_path);
+	SET_TABLE_HANDLER(call_return);
+}
+
 /*
  * Start trace script
  */
 static int python_start_script(const char *script, int argc, const char **argv)
 {
+	struct tables *tables = &tables_global;
 	const char **command_line;
 	char buf[PATH_MAX];
 	int i, err = 0;
@@ -632,6 +990,14 @@ static int python_start_script(const char *script, int argc, const char **argv)
 
 	free(command_line);
 
+	set_table_handlers(tables);
+
+	if (tables->db_export_mode) {
+		err = db_export__branch_types(&tables->dbe);
+		if (err)
+			goto error;
+	}
+
 	return err;
 error:
 	Py_Finalize();
@@ -642,7 +1008,9 @@ static int python_start_script(const char *script, int argc, const char **argv)
 
 static int python_flush_script(void)
 {
-	return 0;
+	struct tables *tables = &tables_global;
+
+	return db_export__flush(&tables->dbe);
 }
 
 /*
@@ -650,8 +1018,12 @@ static int python_flush_script(void)
  */
 static int python_stop_script(void)
 {
+	struct tables *tables = &tables_global;
+
 	try_call_object("trace_end", NULL);
 
+	db_export__exit(&tables->dbe);
+
 	Py_XDECREF(main_dict);
 	Py_XDECREF(main_module);
 	Py_Finalize();
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6702ac28754b..6ac62ae6b8fa 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -228,6 +228,15 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
 
+static int process_id_index_stub(struct perf_tool *tool __maybe_unused,
+				 union perf_event *event __maybe_unused,
+				 struct perf_session *perf_session
+				 __maybe_unused)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 void perf_tool__fill_defaults(struct perf_tool *tool)
 {
 	if (tool->sample == NULL)
@@ -262,6 +271,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		else
 			tool->finished_round = process_finished_round_stub;
 	}
+	if (tool->id_index == NULL)
+		tool->id_index = process_id_index_stub;
 }
  
 static void swap_sample_id_all(union perf_event *event, void *data)
@@ -460,6 +471,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
 	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
+	[PERF_RECORD_ID_INDEX]		  = perf_event__all64_swap,
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
@@ -580,15 +592,46 @@ static void regs_dump__printf(u64 mask, u64 *regs)
 	}
 }
 
+static const char *regs_abi[] = {
+	[PERF_SAMPLE_REGS_ABI_NONE] = "none",
+	[PERF_SAMPLE_REGS_ABI_32] = "32-bit",
+	[PERF_SAMPLE_REGS_ABI_64] = "64-bit",
+};
+
+static inline const char *regs_dump_abi(struct regs_dump *d)
+{
+	if (d->abi > PERF_SAMPLE_REGS_ABI_64)
+		return "unknown";
+
+	return regs_abi[d->abi];
+}
+
+static void regs__printf(const char *type, struct regs_dump *regs)
+{
+	u64 mask = regs->mask;
+
+	printf("... %s regs: mask 0x%" PRIx64 " ABI %s\n",
+	       type,
+	       mask,
+	       regs_dump_abi(regs));
+
+	regs_dump__printf(mask, regs->regs);
+}
+
 static void regs_user__printf(struct perf_sample *sample)
 {
 	struct regs_dump *user_regs = &sample->user_regs;
 
-	if (user_regs->regs) {
-		u64 mask = user_regs->mask;
-		printf("... user regs: mask 0x%" PRIx64 "\n", mask);
-		regs_dump__printf(mask, user_regs->regs);
-	}
+	if (user_regs->regs)
+		regs__printf("user", user_regs);
+}
+
+static void regs_intr__printf(struct perf_sample *sample)
+{
+	struct regs_dump *intr_regs = &sample->intr_regs;
+
+	if (intr_regs->regs)
+		regs__printf("intr", intr_regs);
 }
 
 static void stack_user__printf(struct stack_dump *dump)
@@ -687,6 +730,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (sample_type & PERF_SAMPLE_REGS_USER)
 		regs_user__printf(sample);
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR)
+		regs_intr__printf(sample);
+
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
 
@@ -888,11 +934,26 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 		return tool->build_id(tool, event, session);
 	case PERF_RECORD_FINISHED_ROUND:
 		return tool->finished_round(tool, event, session);
+	case PERF_RECORD_ID_INDEX:
+		return tool->id_index(tool, event, session);
 	default:
 		return -EINVAL;
 	}
 }
 
+int perf_session__deliver_synth_event(struct perf_session *session,
+				      union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_tool *tool)
+{
+	events_stats__inc(&session->stats, event->header.type);
+
+	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
+		return perf_session__process_user_event(session, event, tool, 0);
+
+	return perf_session__deliver_event(session, event, sample, tool, 0);
+}
+
 static void event_swap(union perf_event *event, bool sample_id_all)
 {
 	perf_event__swap_op swap;
@@ -1417,9 +1478,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
 	if (symbol_conf.use_callchain && sample->callchain) {
 		struct addr_location node_al;
 
-		if (machine__resolve_callchain(al->machine, evsel, al->thread,
-					       sample, NULL, NULL,
-					       PERF_MAX_STACK_DEPTH) != 0) {
+		if (thread__resolve_callchain(al->thread, evsel,
+					      sample, NULL, NULL,
+					      PERF_MAX_STACK_DEPTH) != 0) {
 			if (verbose)
 				error("Failed to resolve callchain. Skipping\n");
 			return;
@@ -1594,3 +1655,111 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 out:
 	return err;
 }
+
+int perf_event__process_id_index(struct perf_tool *tool __maybe_unused,
+				 union perf_event *event,
+				 struct perf_session *session)
+{
+	struct perf_evlist *evlist = session->evlist;
+	struct id_index_event *ie = &event->id_index;
+	size_t i, nr, max_nr;
+
+	max_nr = (ie->header.size - sizeof(struct id_index_event)) /
+		 sizeof(struct id_index_entry);
+	nr = ie->nr;
+	if (nr > max_nr)
+		return -EINVAL;
+
+	if (dump_trace)
+		fprintf(stdout, " nr: %zu\n", nr);
+
+	for (i = 0; i < nr; i++) {
+		struct id_index_entry *e = &ie->entries[i];
+		struct perf_sample_id *sid;
+
+		if (dump_trace) {
+			fprintf(stdout,	" ... id: %"PRIu64, e->id);
+			fprintf(stdout,	"  idx: %"PRIu64, e->idx);
+			fprintf(stdout,	"  cpu: %"PRId64, e->cpu);
+			fprintf(stdout,	"  tid: %"PRId64"\n", e->tid);
+		}
+
+		sid = perf_evlist__id2sid(evlist, e->id);
+		if (!sid)
+			return -ENOENT;
+		sid->idx = e->idx;
+		sid->cpu = e->cpu;
+		sid->tid = e->tid;
+	}
+	return 0;
+}
+
+int perf_event__synthesize_id_index(struct perf_tool *tool,
+				    perf_event__handler_t process,
+				    struct perf_evlist *evlist,
+				    struct machine *machine)
+{
+	union perf_event *ev;
+	struct perf_evsel *evsel;
+	size_t nr = 0, i = 0, sz, max_nr, n;
+	int err;
+
+	pr_debug2("Synthesizing id index\n");
+
+	max_nr = (UINT16_MAX - sizeof(struct id_index_event)) /
+		 sizeof(struct id_index_entry);
+
+	evlist__for_each(evlist, evsel)
+		nr += evsel->ids;
+
+	n = nr > max_nr ? max_nr : nr;
+	sz = sizeof(struct id_index_event) + n * sizeof(struct id_index_entry);
+	ev = zalloc(sz);
+	if (!ev)
+		return -ENOMEM;
+
+	ev->id_index.header.type = PERF_RECORD_ID_INDEX;
+	ev->id_index.header.size = sz;
+	ev->id_index.nr = n;
+
+	evlist__for_each(evlist, evsel) {
+		u32 j;
+
+		for (j = 0; j < evsel->ids; j++) {
+			struct id_index_entry *e;
+			struct perf_sample_id *sid;
+
+			if (i >= n) {
+				err = process(tool, ev, NULL, machine);
+				if (err)
+					goto out_err;
+				nr -= n;
+				i = 0;
+			}
+
+			e = &ev->id_index.entries[i++];
+
+			e->id = evsel->id[j];
+
+			sid = perf_evlist__id2sid(evlist, e->id);
+			if (!sid) {
+				free(ev);
+				return -ENOENT;
+			}
+
+			e->idx = sid->idx;
+			e->cpu = sid->cpu;
+			e->tid = sid->tid;
+		}
+	}
+
+	sz = sizeof(struct id_index_event) + nr * sizeof(struct id_index_entry);
+	ev->id_index.header.size = sz;
+	ev->id_index.nr = nr;
+
+	err = process(tool, ev, NULL, machine);
+out_err:
+	free(ev);
+
+	return err;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index a4be851f1a90..dc26ebf60fe4 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -126,4 +126,19 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 extern volatile int session_done;
 
 #define session_done()	ACCESS_ONCE(session_done)
+
+int perf_session__deliver_synth_event(struct perf_session *session,
+				      union perf_event *event,
+				      struct perf_sample *sample,
+				      struct perf_tool *tool);
+
+int perf_event__process_id_index(struct perf_tool *tool,
+				 union perf_event *event,
+				 struct perf_session *session);
+
+int perf_event__synthesize_id_index(struct perf_tool *tool,
+				    perf_event__handler_t process,
+				    struct perf_evlist *evlist,
+				    struct machine *machine);
+
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9402885a77f3..9139dda9f9a3 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -291,7 +291,8 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 		else {
 			struct map *map = left->ms.map;
 			left->srcline = get_srcline(map->dso,
-					    map__rip_2objdump(map, left->ip));
+					   map__rip_2objdump(map, left->ip),
+						    left->ms.sym, true);
 		}
 	}
 	if (!right->srcline) {
@@ -300,7 +301,8 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 		else {
 			struct map *map = right->ms.map;
 			right->srcline = get_srcline(map->dso,
-					    map__rip_2objdump(map, right->ip));
+					     map__rip_2objdump(map, right->ip),
+						     right->ms.sym, true);
 		}
 	}
 	return strcmp(right->srcline, left->srcline);
@@ -309,7 +311,7 @@ sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__srcline_snprintf(struct hist_entry *he, char *bf,
 					size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*.*-s", width, width, he->srcline);
+	return repsep_snprintf(bf, size, "%-*.*s", width, width, he->srcline);
 }
 
 struct sort_entry sort_srcline = {
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index f3e4bc5fe5d2..e73b6a5c9e0f 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -8,6 +8,8 @@
 #include "util/util.h"
 #include "util/debug.h"
 
+#include "symbol.h"
+
 #ifdef HAVE_LIBBFD_SUPPORT
 
 /*
@@ -250,7 +252,8 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
  */
 #define A2L_FAIL_LIMIT 123
 
-char *get_srcline(struct dso *dso, unsigned long addr)
+char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+		  bool show_sym)
 {
 	char *file = NULL;
 	unsigned line = 0;
@@ -258,7 +261,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	const char *dso_name;
 
 	if (!dso->has_srcline)
-		return SRCLINE_UNKNOWN;
+		goto out;
 
 	if (dso->symsrc_filename)
 		dso_name = dso->symsrc_filename;
@@ -274,7 +277,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	if (!addr2line(dso_name, addr, &file, &line, dso))
 		goto out;
 
-	if (asprintf(&srcline, "%s:%u", file, line) < 0) {
+	if (asprintf(&srcline, "%s:%u", basename(file), line) < 0) {
 		free(file);
 		goto out;
 	}
@@ -289,7 +292,13 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 		dso->has_srcline = 0;
 		dso__free_a2l(dso);
 	}
-	return SRCLINE_UNKNOWN;
+	if (sym) {
+		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
+					addr - sym->start) < 0)
+			return SRCLINE_UNKNOWN;
+	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
+		return SRCLINE_UNKNOWN;
+	return srcline;
 }
 
 void free_srcline(char *srcline)
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 1e23a5bfb044..06fcd1bf98b6 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -11,6 +11,27 @@
 #include <symbol/kallsyms.h>
 #include "debug.h"
 
+#ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
+extern char *cplus_demangle(const char *, int);
+
+static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
+{
+	return cplus_demangle(c, i);
+}
+#else
+#ifdef NO_DEMANGLE
+static inline char *bfd_demangle(void __maybe_unused *v,
+				 const char __maybe_unused *c,
+				 int __maybe_unused i)
+{
+	return NULL;
+}
+#else
+#define PACKAGE 'perf'
+#include <bfd.h>
+#endif
+#endif
+
 #ifndef HAVE_ELF_GETPHDRNUM_SUPPORT
 static int elf_getphdrnum(Elf *elf, size_t *dst)
 {
@@ -546,6 +567,35 @@ static int dso__swap_init(struct dso *dso, unsigned char eidata)
 	return 0;
 }
 
+static int decompress_kmodule(struct dso *dso, const char *name,
+			      enum dso_binary_type type)
+{
+	int fd;
+	const char *ext = strrchr(name, '.');
+	char tmpbuf[] = "/tmp/perf-kmod-XXXXXX";
+
+	if ((type != DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP &&
+	     type != DSO_BINARY_TYPE__GUEST_KMODULE_COMP) ||
+	    type != dso->symtab_type)
+		return -1;
+
+	if (!ext || !is_supported_compression(ext + 1))
+		return -1;
+
+	fd = mkstemp(tmpbuf);
+	if (fd < 0)
+		return -1;
+
+	if (!decompress_to_file(ext + 1, name, fd)) {
+		close(fd);
+		fd = -1;
+	}
+
+	unlink(tmpbuf);
+
+	return fd;
+}
+
 bool symsrc__possibly_runtime(struct symsrc *ss)
 {
 	return ss->dynsym || ss->opdsec;
@@ -571,7 +621,11 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 	Elf *elf;
 	int fd;
 
-	fd = open(name, O_RDONLY);
+	if (dso__needs_decompress(dso))
+		fd = decompress_kmodule(dso, name, type);
+	else
+		fd = open(name, O_RDONLY);
+
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index c9541fea9514..fa585c63f56a 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -341,7 +341,6 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 
 	if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) > 0) {
 		dso__set_build_id(dso, build_id);
-		return 1;
 	}
 	return 0;
 }
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 078331140d8c..c24c5b83156c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -51,7 +51,9 @@ static enum dso_binary_type binary_type_symtab[] = {
 	DSO_BINARY_TYPE__BUILDID_DEBUGINFO,
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
+	DSO_BINARY_TYPE__GUEST_KMODULE_COMP,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
+	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP,
 	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
@@ -1300,7 +1302,9 @@ static bool dso__is_compatible_symtab_type(struct dso *dso, bool kmod,
 		return dso->kernel == DSO_TYPE_GUEST_KERNEL;
 
 	case DSO_BINARY_TYPE__GUEST_KMODULE:
+	case DSO_BINARY_TYPE__GUEST_KMODULE_COMP:
 	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
+	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP:
 		/*
 		 * kernel modules know their symtab type - it's set when
 		 * creating a module dso in machine__new_module().
@@ -1368,7 +1372,9 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 		return -1;
 
 	kmod = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
-		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE;
+		dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP ||
+		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE ||
+		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE_COMP;
 
 	/*
 	 * Iterate over candidate debug images.
@@ -1505,12 +1511,10 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 			   symbol_filter_t filter)
 {
 	int i, err = 0;
-	char *filename;
+	char *filename = NULL;
 
-	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
-		 vmlinux_path__nr_entries + 1);
-
-	filename = dso__build_id_filename(dso, NULL, 0);
+	if (!symbol_conf.ignore_vmlinux_buildid)
+		filename = dso__build_id_filename(dso, NULL, 0);
 	if (filename != NULL) {
 		err = dso__load_vmlinux(dso, map, filename, true, filter);
 		if (err > 0)
@@ -1518,6 +1522,9 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 		free(filename);
 	}
 
+	pr_debug("Looking at the vmlinux_path (%d entries long)\n",
+		 vmlinux_path__nr_entries + 1);
+
 	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
 		err = dso__load_vmlinux(dso, map, vmlinux_path[i], false, filter);
 		if (err > 0)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index eb2c19bf8d90..9d602e9c6f59 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -23,27 +23,6 @@
 
 #include "dso.h"
 
-#ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
-extern char *cplus_demangle(const char *, int);
-
-static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
-{
-	return cplus_demangle(c, i);
-}
-#else
-#ifdef NO_DEMANGLE
-static inline char *bfd_demangle(void __maybe_unused *v,
-				 const char __maybe_unused *c,
-				 int __maybe_unused i)
-{
-	return NULL;
-}
-#else
-#define PACKAGE 'perf'
-#include <bfd.h>
-#endif
-#endif
-
 /*
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
@@ -105,6 +84,7 @@ struct symbol_conf {
 	unsigned short	nr_events;
 	bool		try_vmlinux_path,
 			ignore_vmlinux,
+			ignore_vmlinux_buildid,
 			show_kernel_path,
 			use_modules,
 			sort_by_name,
@@ -122,7 +102,8 @@ struct symbol_conf {
 			demangle,
 			demangle_kernel,
 			filter_relative,
-			show_hist_headers;
+			show_hist_headers,
+			branch_callstack;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
diff --git a/tools/perf/util/thread-stack.c b/tools/perf/util/thread-stack.c
new file mode 100644
index 000000000000..9ed59a452d1f
--- /dev/null
+++ b/tools/perf/util/thread-stack.c
@@ -0,0 +1,747 @@
+/*
+ * thread-stack.c: Synthesize a thread's stack using call / return events
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/rbtree.h>
+#include <linux/list.h>
+#include "thread.h"
+#include "event.h"
+#include "machine.h"
+#include "util.h"
+#include "debug.h"
+#include "symbol.h"
+#include "comm.h"
+#include "thread-stack.h"
+
+#define CALL_PATH_BLOCK_SHIFT 8
+#define CALL_PATH_BLOCK_SIZE (1 << CALL_PATH_BLOCK_SHIFT)
+#define CALL_PATH_BLOCK_MASK (CALL_PATH_BLOCK_SIZE - 1)
+
+struct call_path_block {
+	struct call_path cp[CALL_PATH_BLOCK_SIZE];
+	struct list_head node;
+};
+
+/**
+ * struct call_path_root - root of all call paths.
+ * @call_path: root call path
+ * @blocks: list of blocks to store call paths
+ * @next: next free space
+ * @sz: number of spaces
+ */
+struct call_path_root {
+	struct call_path call_path;
+	struct list_head blocks;
+	size_t next;
+	size_t sz;
+};
+
+/**
+ * struct call_return_processor - provides a call-back to consume call-return
+ *                                information.
+ * @cpr: call path root
+ * @process: call-back that accepts call/return information
+ * @data: anonymous data for call-back
+ */
+struct call_return_processor {
+	struct call_path_root *cpr;
+	int (*process)(struct call_return *cr, void *data);
+	void *data;
+};
+
+#define STACK_GROWTH 2048
+
+/**
+ * struct thread_stack_entry - thread stack entry.
+ * @ret_addr: return address
+ * @timestamp: timestamp (if known)
+ * @ref: external reference (e.g. db_id of sample)
+ * @branch_count: the branch count when the entry was created
+ * @cp: call path
+ * @no_call: a 'call' was not seen
+ */
+struct thread_stack_entry {
+	u64 ret_addr;
+	u64 timestamp;
+	u64 ref;
+	u64 branch_count;
+	struct call_path *cp;
+	bool no_call;
+};
+
+/**
+ * struct thread_stack - thread stack constructed from 'call' and 'return'
+ *                       branch samples.
+ * @stack: array that holds the stack
+ * @cnt: number of entries in the stack
+ * @sz: current maximum stack size
+ * @trace_nr: current trace number
+ * @branch_count: running branch count
+ * @kernel_start: kernel start address
+ * @last_time: last timestamp
+ * @crp: call/return processor
+ * @comm: current comm
+ */
+struct thread_stack {
+	struct thread_stack_entry *stack;
+	size_t cnt;
+	size_t sz;
+	u64 trace_nr;
+	u64 branch_count;
+	u64 kernel_start;
+	u64 last_time;
+	struct call_return_processor *crp;
+	struct comm *comm;
+};
+
+static int thread_stack__grow(struct thread_stack *ts)
+{
+	struct thread_stack_entry *new_stack;
+	size_t sz, new_sz;
+
+	new_sz = ts->sz + STACK_GROWTH;
+	sz = new_sz * sizeof(struct thread_stack_entry);
+
+	new_stack = realloc(ts->stack, sz);
+	if (!new_stack)
+		return -ENOMEM;
+
+	ts->stack = new_stack;
+	ts->sz = new_sz;
+
+	return 0;
+}
+
+static struct thread_stack *thread_stack__new(struct thread *thread,
+					      struct call_return_processor *crp)
+{
+	struct thread_stack *ts;
+
+	ts = zalloc(sizeof(struct thread_stack));
+	if (!ts)
+		return NULL;
+
+	if (thread_stack__grow(ts)) {
+		free(ts);
+		return NULL;
+	}
+
+	if (thread->mg && thread->mg->machine)
+		ts->kernel_start = machine__kernel_start(thread->mg->machine);
+	else
+		ts->kernel_start = 1ULL << 63;
+	ts->crp = crp;
+
+	return ts;
+}
+
+static int thread_stack__push(struct thread_stack *ts, u64 ret_addr)
+{
+	int err = 0;
+
+	if (ts->cnt == ts->sz) {
+		err = thread_stack__grow(ts);
+		if (err) {
+			pr_warning("Out of memory: discarding thread stack\n");
+			ts->cnt = 0;
+		}
+	}
+
+	ts->stack[ts->cnt++].ret_addr = ret_addr;
+
+	return err;
+}
+
+static void thread_stack__pop(struct thread_stack *ts, u64 ret_addr)
+{
+	size_t i;
+
+	/*
+	 * In some cases there may be functions which are not seen to return.
+	 * For example when setjmp / longjmp has been used.  Or the perf context
+	 * switch in the kernel which doesn't stop and start tracing in exactly
+	 * the same code path.  When that happens the return address will be
+	 * further down the stack.  If the return address is not found at all,
+	 * we assume the opposite (i.e. this is a return for a call that wasn't
+	 * seen for some reason) and leave the stack alone.
+	 */
+	for (i = ts->cnt; i; ) {
+		if (ts->stack[--i].ret_addr == ret_addr) {
+			ts->cnt = i;
+			return;
+		}
+	}
+}
+
+static bool thread_stack__in_kernel(struct thread_stack *ts)
+{
+	if (!ts->cnt)
+		return false;
+
+	return ts->stack[ts->cnt - 1].cp->in_kernel;
+}
+
+static int thread_stack__call_return(struct thread *thread,
+				     struct thread_stack *ts, size_t idx,
+				     u64 timestamp, u64 ref, bool no_return)
+{
+	struct call_return_processor *crp = ts->crp;
+	struct thread_stack_entry *tse;
+	struct call_return cr = {
+		.thread = thread,
+		.comm = ts->comm,
+		.db_id = 0,
+	};
+
+	tse = &ts->stack[idx];
+	cr.cp = tse->cp;
+	cr.call_time = tse->timestamp;
+	cr.return_time = timestamp;
+	cr.branch_count = ts->branch_count - tse->branch_count;
+	cr.call_ref = tse->ref;
+	cr.return_ref = ref;
+	if (tse->no_call)
+		cr.flags |= CALL_RETURN_NO_CALL;
+	if (no_return)
+		cr.flags |= CALL_RETURN_NO_RETURN;
+
+	return crp->process(&cr, crp->data);
+}
+
+static int thread_stack__flush(struct thread *thread, struct thread_stack *ts)
+{
+	struct call_return_processor *crp = ts->crp;
+	int err;
+
+	if (!crp) {
+		ts->cnt = 0;
+		return 0;
+	}
+
+	while (ts->cnt) {
+		err = thread_stack__call_return(thread, ts, --ts->cnt,
+						ts->last_time, 0, true);
+		if (err) {
+			pr_err("Error flushing thread stack!\n");
+			ts->cnt = 0;
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+int thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
+			u64 to_ip, u16 insn_len, u64 trace_nr)
+{
+	if (!thread)
+		return -EINVAL;
+
+	if (!thread->ts) {
+		thread->ts = thread_stack__new(thread, NULL);
+		if (!thread->ts) {
+			pr_warning("Out of memory: no thread stack\n");
+			return -ENOMEM;
+		}
+		thread->ts->trace_nr = trace_nr;
+	}
+
+	/*
+	 * When the trace is discontinuous, the trace_nr changes.  In that case
+	 * the stack might be completely invalid.  Better to report nothing than
+	 * to report something misleading, so flush the stack.
+	 */
+	if (trace_nr != thread->ts->trace_nr) {
+		if (thread->ts->trace_nr)
+			thread_stack__flush(thread, thread->ts);
+		thread->ts->trace_nr = trace_nr;
+	}
+
+	/* Stop here if thread_stack__process() is in use */
+	if (thread->ts->crp)
+		return 0;
+
+	if (flags & PERF_IP_FLAG_CALL) {
+		u64 ret_addr;
+
+		if (!to_ip)
+			return 0;
+		ret_addr = from_ip + insn_len;
+		if (ret_addr == to_ip)
+			return 0; /* Zero-length calls are excluded */
+		return thread_stack__push(thread->ts, ret_addr);
+	} else if (flags & PERF_IP_FLAG_RETURN) {
+		if (!from_ip)
+			return 0;
+		thread_stack__pop(thread->ts, to_ip);
+	}
+
+	return 0;
+}
+
+void thread_stack__set_trace_nr(struct thread *thread, u64 trace_nr)
+{
+	if (!thread || !thread->ts)
+		return;
+
+	if (trace_nr != thread->ts->trace_nr) {
+		if (thread->ts->trace_nr)
+			thread_stack__flush(thread, thread->ts);
+		thread->ts->trace_nr = trace_nr;
+	}
+}
+
+void thread_stack__free(struct thread *thread)
+{
+	if (thread->ts) {
+		thread_stack__flush(thread, thread->ts);
+		zfree(&thread->ts->stack);
+		zfree(&thread->ts);
+	}
+}
+
+void thread_stack__sample(struct thread *thread, struct ip_callchain *chain,
+			  size_t sz, u64 ip)
+{
+	size_t i;
+
+	if (!thread || !thread->ts)
+		chain->nr = 1;
+	else
+		chain->nr = min(sz, thread->ts->cnt + 1);
+
+	chain->ips[0] = ip;
+
+	for (i = 1; i < chain->nr; i++)
+		chain->ips[i] = thread->ts->stack[thread->ts->cnt - i].ret_addr;
+}
+
+static void call_path__init(struct call_path *cp, struct call_path *parent,
+			    struct symbol *sym, u64 ip, bool in_kernel)
+{
+	cp->parent = parent;
+	cp->sym = sym;
+	cp->ip = sym ? 0 : ip;
+	cp->db_id = 0;
+	cp->in_kernel = in_kernel;
+	RB_CLEAR_NODE(&cp->rb_node);
+	cp->children = RB_ROOT;
+}
+
+static struct call_path_root *call_path_root__new(void)
+{
+	struct call_path_root *cpr;
+
+	cpr = zalloc(sizeof(struct call_path_root));
+	if (!cpr)
+		return NULL;
+	call_path__init(&cpr->call_path, NULL, NULL, 0, false);
+	INIT_LIST_HEAD(&cpr->blocks);
+	return cpr;
+}
+
+static void call_path_root__free(struct call_path_root *cpr)
+{
+	struct call_path_block *pos, *n;
+
+	list_for_each_entry_safe(pos, n, &cpr->blocks, node) {
+		list_del(&pos->node);
+		free(pos);
+	}
+	free(cpr);
+}
+
+static struct call_path *call_path__new(struct call_path_root *cpr,
+					struct call_path *parent,
+					struct symbol *sym, u64 ip,
+					bool in_kernel)
+{
+	struct call_path_block *cpb;
+	struct call_path *cp;
+	size_t n;
+
+	if (cpr->next < cpr->sz) {
+		cpb = list_last_entry(&cpr->blocks, struct call_path_block,
+				      node);
+	} else {
+		cpb = zalloc(sizeof(struct call_path_block));
+		if (!cpb)
+			return NULL;
+		list_add_tail(&cpb->node, &cpr->blocks);
+		cpr->sz += CALL_PATH_BLOCK_SIZE;
+	}
+
+	n = cpr->next++ & CALL_PATH_BLOCK_MASK;
+	cp = &cpb->cp[n];
+
+	call_path__init(cp, parent, sym, ip, in_kernel);
+
+	return cp;
+}
+
+static struct call_path *call_path__findnew(struct call_path_root *cpr,
+					    struct call_path *parent,
+					    struct symbol *sym, u64 ip, u64 ks)
+{
+	struct rb_node **p;
+	struct rb_node *node_parent = NULL;
+	struct call_path *cp;
+	bool in_kernel = ip >= ks;
+
+	if (sym)
+		ip = 0;
+
+	if (!parent)
+		return call_path__new(cpr, parent, sym, ip, in_kernel);
+
+	p = &parent->children.rb_node;
+	while (*p != NULL) {
+		node_parent = *p;
+		cp = rb_entry(node_parent, struct call_path, rb_node);
+
+		if (cp->sym == sym && cp->ip == ip)
+			return cp;
+
+		if (sym < cp->sym || (sym == cp->sym && ip < cp->ip))
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	cp = call_path__new(cpr, parent, sym, ip, in_kernel);
+	if (!cp)
+		return NULL;
+
+	rb_link_node(&cp->rb_node, node_parent, p);
+	rb_insert_color(&cp->rb_node, &parent->children);
+
+	return cp;
+}
+
+struct call_return_processor *
+call_return_processor__new(int (*process)(struct call_return *cr, void *data),
+			   void *data)
+{
+	struct call_return_processor *crp;
+
+	crp = zalloc(sizeof(struct call_return_processor));
+	if (!crp)
+		return NULL;
+	crp->cpr = call_path_root__new();
+	if (!crp->cpr)
+		goto out_free;
+	crp->process = process;
+	crp->data = data;
+	return crp;
+
+out_free:
+	free(crp);
+	return NULL;
+}
+
+void call_return_processor__free(struct call_return_processor *crp)
+{
+	if (crp) {
+		call_path_root__free(crp->cpr);
+		free(crp);
+	}
+}
+
+static int thread_stack__push_cp(struct thread_stack *ts, u64 ret_addr,
+				 u64 timestamp, u64 ref, struct call_path *cp,
+				 bool no_call)
+{
+	struct thread_stack_entry *tse;
+	int err;
+
+	if (ts->cnt == ts->sz) {
+		err = thread_stack__grow(ts);
+		if (err)
+			return err;
+	}
+
+	tse = &ts->stack[ts->cnt++];
+	tse->ret_addr = ret_addr;
+	tse->timestamp = timestamp;
+	tse->ref = ref;
+	tse->branch_count = ts->branch_count;
+	tse->cp = cp;
+	tse->no_call = no_call;
+
+	return 0;
+}
+
+static int thread_stack__pop_cp(struct thread *thread, struct thread_stack *ts,
+				u64 ret_addr, u64 timestamp, u64 ref,
+				struct symbol *sym)
+{
+	int err;
+
+	if (!ts->cnt)
+		return 1;
+
+	if (ts->cnt == 1) {
+		struct thread_stack_entry *tse = &ts->stack[0];
+
+		if (tse->cp->sym == sym)
+			return thread_stack__call_return(thread, ts, --ts->cnt,
+							 timestamp, ref, false);
+	}
+
+	if (ts->stack[ts->cnt - 1].ret_addr == ret_addr) {
+		return thread_stack__call_return(thread, ts, --ts->cnt,
+						 timestamp, ref, false);
+	} else {
+		size_t i = ts->cnt - 1;
+
+		while (i--) {
+			if (ts->stack[i].ret_addr != ret_addr)
+				continue;
+			i += 1;
+			while (ts->cnt > i) {
+				err = thread_stack__call_return(thread, ts,
+								--ts->cnt,
+								timestamp, ref,
+								true);
+				if (err)
+					return err;
+			}
+			return thread_stack__call_return(thread, ts, --ts->cnt,
+							 timestamp, ref, false);
+		}
+	}
+
+	return 1;
+}
+
+static int thread_stack__bottom(struct thread *thread, struct thread_stack *ts,
+				struct perf_sample *sample,
+				struct addr_location *from_al,
+				struct addr_location *to_al, u64 ref)
+{
+	struct call_path_root *cpr = ts->crp->cpr;
+	struct call_path *cp;
+	struct symbol *sym;
+	u64 ip;
+
+	if (sample->ip) {
+		ip = sample->ip;
+		sym = from_al->sym;
+	} else if (sample->addr) {
+		ip = sample->addr;
+		sym = to_al->sym;
+	} else {
+		return 0;
+	}
+
+	cp = call_path__findnew(cpr, &cpr->call_path, sym, ip,
+				ts->kernel_start);
+	if (!cp)
+		return -ENOMEM;
+
+	return thread_stack__push_cp(thread->ts, ip, sample->time, ref, cp,
+				     true);
+}
+
+static int thread_stack__no_call_return(struct thread *thread,
+					struct thread_stack *ts,
+					struct perf_sample *sample,
+					struct addr_location *from_al,
+					struct addr_location *to_al, u64 ref)
+{
+	struct call_path_root *cpr = ts->crp->cpr;
+	struct call_path *cp, *parent;
+	u64 ks = ts->kernel_start;
+	int err;
+
+	if (sample->ip >= ks && sample->addr < ks) {
+		/* Return to userspace, so pop all kernel addresses */
+		while (thread_stack__in_kernel(ts)) {
+			err = thread_stack__call_return(thread, ts, --ts->cnt,
+							sample->time, ref,
+							true);
+			if (err)
+				return err;
+		}
+
+		/* If the stack is empty, push the userspace address */
+		if (!ts->cnt) {
+			cp = call_path__findnew(cpr, &cpr->call_path,
+						to_al->sym, sample->addr,
+						ts->kernel_start);
+			if (!cp)
+				return -ENOMEM;
+			return thread_stack__push_cp(ts, 0, sample->time, ref,
+						     cp, true);
+		}
+	} else if (thread_stack__in_kernel(ts) && sample->ip < ks) {
+		/* Return to userspace, so pop all kernel addresses */
+		while (thread_stack__in_kernel(ts)) {
+			err = thread_stack__call_return(thread, ts, --ts->cnt,
+							sample->time, ref,
+							true);
+			if (err)
+				return err;
+		}
+	}
+
+	if (ts->cnt)
+		parent = ts->stack[ts->cnt - 1].cp;
+	else
+		parent = &cpr->call_path;
+
+	/* This 'return' had no 'call', so push and pop top of stack */
+	cp = call_path__findnew(cpr, parent, from_al->sym, sample->ip,
+				ts->kernel_start);
+	if (!cp)
+		return -ENOMEM;
+
+	err = thread_stack__push_cp(ts, sample->addr, sample->time, ref, cp,
+				    true);
+	if (err)
+		return err;
+
+	return thread_stack__pop_cp(thread, ts, sample->addr, sample->time, ref,
+				    to_al->sym);
+}
+
+static int thread_stack__trace_begin(struct thread *thread,
+				     struct thread_stack *ts, u64 timestamp,
+				     u64 ref)
+{
+	struct thread_stack_entry *tse;
+	int err;
+
+	if (!ts->cnt)
+		return 0;
+
+	/* Pop trace end */
+	tse = &ts->stack[ts->cnt - 1];
+	if (tse->cp->sym == NULL && tse->cp->ip == 0) {
+		err = thread_stack__call_return(thread, ts, --ts->cnt,
+						timestamp, ref, false);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int thread_stack__trace_end(struct thread_stack *ts,
+				   struct perf_sample *sample, u64 ref)
+{
+	struct call_path_root *cpr = ts->crp->cpr;
+	struct call_path *cp;
+	u64 ret_addr;
+
+	/* No point having 'trace end' on the bottom of the stack */
+	if (!ts->cnt || (ts->cnt == 1 && ts->stack[0].ref == ref))
+		return 0;
+
+	cp = call_path__findnew(cpr, ts->stack[ts->cnt - 1].cp, NULL, 0,
+				ts->kernel_start);
+	if (!cp)
+		return -ENOMEM;
+
+	ret_addr = sample->ip + sample->insn_len;
+
+	return thread_stack__push_cp(ts, ret_addr, sample->time, ref, cp,
+				     false);
+}
+
+int thread_stack__process(struct thread *thread, struct comm *comm,
+			  struct perf_sample *sample,
+			  struct addr_location *from_al,
+			  struct addr_location *to_al, u64 ref,
+			  struct call_return_processor *crp)
+{
+	struct thread_stack *ts = thread->ts;
+	int err = 0;
+
+	if (ts) {
+		if (!ts->crp) {
+			/* Supersede thread_stack__event() */
+			thread_stack__free(thread);
+			thread->ts = thread_stack__new(thread, crp);
+			if (!thread->ts)
+				return -ENOMEM;
+			ts = thread->ts;
+			ts->comm = comm;
+		}
+	} else {
+		thread->ts = thread_stack__new(thread, crp);
+		if (!thread->ts)
+			return -ENOMEM;
+		ts = thread->ts;
+		ts->comm = comm;
+	}
+
+	/* Flush stack on exec */
+	if (ts->comm != comm && thread->pid_ == thread->tid) {
+		err = thread_stack__flush(thread, ts);
+		if (err)
+			return err;
+		ts->comm = comm;
+	}
+
+	/* If the stack is empty, put the current symbol on the stack */
+	if (!ts->cnt) {
+		err = thread_stack__bottom(thread, ts, sample, from_al, to_al,
+					   ref);
+		if (err)
+			return err;
+	}
+
+	ts->branch_count += 1;
+	ts->last_time = sample->time;
+
+	if (sample->flags & PERF_IP_FLAG_CALL) {
+		struct call_path_root *cpr = ts->crp->cpr;
+		struct call_path *cp;
+		u64 ret_addr;
+
+		if (!sample->ip || !sample->addr)
+			return 0;
+
+		ret_addr = sample->ip + sample->insn_len;
+		if (ret_addr == sample->addr)
+			return 0; /* Zero-length calls are excluded */
+
+		cp = call_path__findnew(cpr, ts->stack[ts->cnt - 1].cp,
+					to_al->sym, sample->addr,
+					ts->kernel_start);
+		if (!cp)
+			return -ENOMEM;
+		err = thread_stack__push_cp(ts, ret_addr, sample->time, ref,
+					    cp, false);
+	} else if (sample->flags & PERF_IP_FLAG_RETURN) {
+		if (!sample->ip || !sample->addr)
+			return 0;
+
+		err = thread_stack__pop_cp(thread, ts, sample->addr,
+					   sample->time, ref, from_al->sym);
+		if (err) {
+			if (err < 0)
+				return err;
+			err = thread_stack__no_call_return(thread, ts, sample,
+							   from_al, to_al, ref);
+		}
+	} else if (sample->flags & PERF_IP_FLAG_TRACE_BEGIN) {
+		err = thread_stack__trace_begin(thread, ts, sample->time, ref);
+	} else if (sample->flags & PERF_IP_FLAG_TRACE_END) {
+		err = thread_stack__trace_end(ts, sample, ref);
+	}
+
+	return err;
+}
diff --git a/tools/perf/util/thread-stack.h b/tools/perf/util/thread-stack.h
new file mode 100644
index 000000000000..b843bbef8ba2
--- /dev/null
+++ b/tools/perf/util/thread-stack.h
@@ -0,0 +1,111 @@
+/*
+ * thread-stack.h: Synthesize a thread's stack using call / return events
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef __PERF_THREAD_STACK_H
+#define __PERF_THREAD_STACK_H
+
+#include <sys/types.h>
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+
+struct thread;
+struct comm;
+struct ip_callchain;
+struct symbol;
+struct dso;
+struct call_return_processor;
+struct comm;
+struct perf_sample;
+struct addr_location;
+
+/*
+ * Call/Return flags.
+ *
+ * CALL_RETURN_NO_CALL: 'return' but no matching 'call'
+ * CALL_RETURN_NO_RETURN: 'call' but no matching 'return'
+ */
+enum {
+	CALL_RETURN_NO_CALL	= 1 << 0,
+	CALL_RETURN_NO_RETURN	= 1 << 1,
+};
+
+/**
+ * struct call_return - paired call/return information.
+ * @thread: thread in which call/return occurred
+ * @comm: comm in which call/return occurred
+ * @cp: call path
+ * @call_time: timestamp of call (if known)
+ * @return_time: timestamp of return (if known)
+ * @branch_count: number of branches seen between call and return
+ * @call_ref: external reference to 'call' sample (e.g. db_id)
+ * @return_ref:  external reference to 'return' sample (e.g. db_id)
+ * @db_id: id used for db-export
+ * @flags: Call/Return flags
+ */
+struct call_return {
+	struct thread *thread;
+	struct comm *comm;
+	struct call_path *cp;
+	u64 call_time;
+	u64 return_time;
+	u64 branch_count;
+	u64 call_ref;
+	u64 return_ref;
+	u64 db_id;
+	u32 flags;
+};
+
+/**
+ * struct call_path - node in list of calls leading to a function call.
+ * @parent: call path to the parent function call
+ * @sym: symbol of function called
+ * @ip: only if sym is null, the ip of the function
+ * @db_id: id used for db-export
+ * @in_kernel: whether function is a in the kernel
+ * @rb_node: node in parent's tree of called functions
+ * @children: tree of call paths of functions called
+ *
+ * In combination with the call_return structure, the call_path structure
+ * defines a context-sensitve call-graph.
+ */
+struct call_path {
+	struct call_path *parent;
+	struct symbol *sym;
+	u64 ip;
+	u64 db_id;
+	bool in_kernel;
+	struct rb_node rb_node;
+	struct rb_root children;
+};
+
+int thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
+			u64 to_ip, u16 insn_len, u64 trace_nr);
+void thread_stack__set_trace_nr(struct thread *thread, u64 trace_nr);
+void thread_stack__sample(struct thread *thread, struct ip_callchain *chain,
+			  size_t sz, u64 ip);
+void thread_stack__free(struct thread *thread);
+
+struct call_return_processor *
+call_return_processor__new(int (*process)(struct call_return *cr, void *data),
+			   void *data);
+void call_return_processor__free(struct call_return_processor *crp);
+int thread_stack__process(struct thread *thread, struct comm *comm,
+			  struct perf_sample *sample,
+			  struct addr_location *from_al,
+			  struct addr_location *to_al, u64 ref,
+			  struct call_return_processor *crp);
+
+#endif
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index c41411726c7a..9ebc8b1f9be5 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -4,6 +4,7 @@
 #include <string.h>
 #include "session.h"
 #include "thread.h"
+#include "thread-stack.h"
 #include "util.h"
 #include "debug.h"
 #include "comm.h"
@@ -15,7 +16,7 @@ int thread__init_map_groups(struct thread *thread, struct machine *machine)
 	pid_t pid = thread->pid_;
 
 	if (pid == thread->tid || pid == -1) {
-		thread->mg = map_groups__new();
+		thread->mg = map_groups__new(machine);
 	} else {
 		leader = machine__findnew_thread(machine, pid, pid);
 		if (leader)
@@ -66,6 +67,8 @@ void thread__delete(struct thread *thread)
 {
 	struct comm *comm, *tmp;
 
+	thread_stack__free(thread);
+
 	if (thread->mg) {
 		map_groups__put(thread->mg);
 		thread->mg = NULL;
@@ -100,15 +103,14 @@ struct comm *thread__exec_comm(const struct thread *thread)
 	return last;
 }
 
-/* CHECKME: time should always be 0 if event aren't ordered */
 int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
 		       bool exec)
 {
 	struct comm *new, *curr = thread__comm(thread);
 	int err;
 
-	/* Override latest entry if it had no specific time coverage */
-	if (!curr->start && !curr->exec) {
+	/* Override the default :tid entry */
+	if (!thread->comm_set) {
 		err = comm__override(curr, str, timestamp, exec);
 		if (err)
 			return err;
@@ -198,7 +200,6 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 }
 
 void thread__find_cpumode_addr_location(struct thread *thread,
-					struct machine *machine,
 					enum map_type type, u64 addr,
 					struct addr_location *al)
 {
@@ -211,8 +212,7 @@ void thread__find_cpumode_addr_location(struct thread *thread,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(cpumodes); i++) {
-		thread__find_addr_location(thread, machine, cpumodes[i], type,
-					   addr, al);
+		thread__find_addr_location(thread, cpumodes[i], type, addr, al);
 		if (al->map)
 			break;
 	}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 8c75fa774706..160fd066a7d1 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -8,6 +8,8 @@
 #include "symbol.h"
 #include <strlist.h>
 
+struct thread_stack;
+
 struct thread {
 	union {
 		struct rb_node	 rb_node;
@@ -23,8 +25,10 @@ struct thread {
 	bool			dead; /* if set thread has exited */
 	struct list_head	comm_list;
 	int			comm_len;
+	u64			db_id;
 
 	void			*priv;
+	struct thread_stack	*ts;
 };
 
 struct machine;
@@ -54,16 +58,15 @@ void thread__insert_map(struct thread *thread, struct map *map);
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
 
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index f11636966a0f..bb2708bbfaca 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -39,7 +39,8 @@ struct perf_tool {
 	event_attr_op	attr;
 	event_op2	tracing_data;
 	event_op2	finished_round,
-			build_id;
+			build_id,
+			id_index;
 	bool		ordered_events;
 	bool		ordering_requires_timestamps;
 };
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
index 7419768c38b1..2dcfe9a7c8d0 100644
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
@@ -164,14 +164,14 @@ frame_callback(Dwfl_Frame *state, void *arg)
 }
 
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
-			struct machine *machine, struct thread *thread,
+			struct thread *thread,
 			struct perf_sample *data,
 			int max_stack)
 {
 	struct unwind_info ui = {
 		.sample		= data,
 		.thread		= thread,
-		.machine	= machine,
+		.machine	= thread->mg->machine,
 		.cb		= cb,
 		.arg		= arg,
 		.max_stack	= max_stack,
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 4d45c0dfe343..371219a6daf1 100644
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
@@ -586,21 +585,21 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 		unw_word_t ip;
 
 		unw_get_reg(&c, UNW_REG_IP, &ip);
-		ret = ip ? entry(ip, ui->thread, ui->machine, cb, arg) : 0;
+		ret = ip ? entry(ip, ui->thread, cb, arg) : 0;
 	}
 
 	return ret;
 }
 
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
-			struct machine *machine, struct thread *thread,
+			struct thread *thread,
 			struct perf_sample *data, int max_stack)
 {
 	u64 ip;
 	struct unwind_info ui = {
 		.sample       = data,
 		.thread       = thread,
-		.machine      = machine,
+		.machine      = thread->mg->machine,
 	};
 	int ret;
 
@@ -611,7 +610,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (ret)
 		return ret;
 
-	ret = entry(ip, thread, machine, cb, arg);
+	ret = entry(ip, thread, cb, arg);
 	if (ret)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index f50b737235eb..12790cf94618 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -16,7 +16,6 @@ typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
-			struct machine *machine,
 			struct thread *thread,
 			struct perf_sample *data, int max_stack);
 /* libunwind specific */
@@ -38,7 +37,6 @@ static inline void unwind__finish_access(struct thread *thread __maybe_unused) {
 static inline int
 unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 		    void *arg __maybe_unused,
-		    struct machine *machine __maybe_unused,
 		    struct thread *thread __maybe_unused,
 		    struct perf_sample *data __maybe_unused,
 		    int max_stack __maybe_unused)
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 80bfdaa0e2a4..419bee030f83 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -154,7 +154,6 @@ extern void set_die_routine(void (*routine)(const char *err, va_list params) NOR
 
 extern int prefixcmp(const char *str, const char *prefix);
 extern void set_buildid_dir(void);
-extern void disable_buildid_cache(void);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
@@ -338,8 +337,10 @@ static inline int path__join3(char *bf, size_t size,
 }
 
 struct dso;
+struct symbol;
 
-char *get_srcline(struct dso *dso, unsigned long addr);
+char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+		  bool show_sym);
 void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
@@ -351,4 +352,9 @@ void mem_bswap_32(void *src, int byte_size);
 
 const char *get_filename_for_perf_kvm(void);
 bool find_process(const char *name);
+
+#ifdef HAVE_ZLIB_SUPPORT
+int gzip_decompress_to_file(const char *input, int output_fd);
+#endif
+
 #endif /* GIT_COMPAT_UTIL_H */
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index adca69384fcc..5c7dd796979d 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -12,9 +12,16 @@
 #include "util.h"
 #include "symbol.h"
 #include "machine.h"
+#include "thread.h"
 #include "linux/string.h"
 #include "debug.h"
 
+/*
+ * Include definition of find_vdso_map() also used in perf-read-vdso.c for
+ * building perf-read-vdso32 and perf-read-vdsox32.
+ */
+#include "find-vdso-map.c"
+
 #define VDSO__TEMP_FILE_NAME "/tmp/perf-vdso.so-XXXXXX"
 
 struct vdso_file {
@@ -22,10 +29,15 @@ struct vdso_file {
 	bool error;
 	char temp_file_name[sizeof(VDSO__TEMP_FILE_NAME)];
 	const char *dso_name;
+	const char *read_prog;
 };
 
 struct vdso_info {
 	struct vdso_file vdso;
+#if BITS_PER_LONG == 64
+	struct vdso_file vdso32;
+	struct vdso_file vdsox32;
+#endif
 };
 
 static struct vdso_info *vdso_info__new(void)
@@ -35,42 +47,23 @@ static struct vdso_info *vdso_info__new(void)
 			.temp_file_name = VDSO__TEMP_FILE_NAME,
 			.dso_name = DSO__NAME_VDSO,
 		},
+#if BITS_PER_LONG == 64
+		.vdso32  = {
+			.temp_file_name = VDSO__TEMP_FILE_NAME,
+			.dso_name = DSO__NAME_VDSO32,
+			.read_prog = "perf-read-vdso32",
+		},
+		.vdsox32  = {
+			.temp_file_name = VDSO__TEMP_FILE_NAME,
+			.dso_name = DSO__NAME_VDSOX32,
+			.read_prog = "perf-read-vdsox32",
+		},
+#endif
 	};
 
 	return memdup(&vdso_info_init, sizeof(vdso_info_init));
 }
 
-static int find_vdso_map(void **start, void **end)
-{
-	FILE *maps;
-	char line[128];
-	int found = 0;
-
-	maps = fopen("/proc/self/maps", "r");
-	if (!maps) {
-		pr_err("vdso: cannot open maps\n");
-		return -1;
-	}
-
-	while (!found && fgets(line, sizeof(line), maps)) {
-		int m = -1;
-
-		/* We care only about private r-x mappings. */
-		if (2 != sscanf(line, "%p-%p r-xp %*x %*x:%*x %*u %n",
-				start, end, &m))
-			continue;
-		if (m < 0)
-			continue;
-
-		if (!strncmp(&line[m], VDSO__MAP_NAME,
-			     sizeof(VDSO__MAP_NAME) - 1))
-			found = 1;
-	}
-
-	fclose(maps);
-	return !found;
-}
-
 static char *get_file(struct vdso_file *vdso_file)
 {
 	char *vdso = NULL;
@@ -117,6 +110,12 @@ void vdso__exit(struct machine *machine)
 
 	if (vdso_info->vdso.found)
 		unlink(vdso_info->vdso.temp_file_name);
+#if BITS_PER_LONG == 64
+	if (vdso_info->vdso32.found)
+		unlink(vdso_info->vdso32.temp_file_name);
+	if (vdso_info->vdsox32.found)
+		unlink(vdso_info->vdsox32.temp_file_name);
+#endif
 
 	zfree(&machine->vdso_info);
 }
@@ -135,6 +134,153 @@ static struct dso *vdso__new(struct machine *machine, const char *short_name,
 	return dso;
 }
 
+#if BITS_PER_LONG == 64
+
+static enum dso_type machine__thread_dso_type(struct machine *machine,
+					      struct thread *thread)
+{
+	enum dso_type dso_type = DSO__TYPE_UNKNOWN;
+	struct map *map;
+	struct dso *dso;
+
+	map = map_groups__first(thread->mg, MAP__FUNCTION);
+	for (; map ; map = map_groups__next(map)) {
+		dso = map->dso;
+		if (!dso || dso->long_name[0] != '/')
+			continue;
+		dso_type = dso__type(dso, machine);
+		if (dso_type != DSO__TYPE_UNKNOWN)
+			break;
+	}
+
+	return dso_type;
+}
+
+static int vdso__do_copy_compat(FILE *f, int fd)
+{
+	char buf[4096];
+	size_t count;
+
+	while (1) {
+		count = fread(buf, 1, sizeof(buf), f);
+		if (ferror(f))
+			return -errno;
+		if (feof(f))
+			break;
+		if (count && writen(fd, buf, count) != (ssize_t)count)
+			return -errno;
+	}
+
+	return 0;
+}
+
+static int vdso__copy_compat(const char *prog, int fd)
+{
+	FILE *f;
+	int err;
+
+	f = popen(prog, "r");
+	if (!f)
+		return -errno;
+
+	err = vdso__do_copy_compat(f, fd);
+
+	if (pclose(f) == -1)
+		return -errno;
+
+	return err;
+}
+
+static int vdso__create_compat_file(const char *prog, char *temp_name)
+{
+	int fd, err;
+
+	fd = mkstemp(temp_name);
+	if (fd < 0)
+		return -errno;
+
+	err = vdso__copy_compat(prog, fd);
+
+	if (close(fd) == -1)
+		return -errno;
+
+	return err;
+}
+
+static const char *vdso__get_compat_file(struct vdso_file *vdso_file)
+{
+	int err;
+
+	if (vdso_file->found)
+		return vdso_file->temp_file_name;
+
+	if (vdso_file->error)
+		return NULL;
+
+	err = vdso__create_compat_file(vdso_file->read_prog,
+				       vdso_file->temp_file_name);
+	if (err) {
+		pr_err("%s failed, error %d\n", vdso_file->read_prog, err);
+		vdso_file->error = true;
+		return NULL;
+	}
+
+	vdso_file->found = true;
+
+	return vdso_file->temp_file_name;
+}
+
+static struct dso *vdso__findnew_compat(struct machine *machine,
+					struct vdso_file *vdso_file)
+{
+	const char *file_name;
+	struct dso *dso;
+
+	dso = dsos__find(&machine->user_dsos, vdso_file->dso_name, true);
+	if (dso)
+		return dso;
+
+	file_name = vdso__get_compat_file(vdso_file);
+	if (!file_name)
+		return NULL;
+
+	return vdso__new(machine, vdso_file->dso_name, file_name);
+}
+
+static int vdso__dso_findnew_compat(struct machine *machine,
+				    struct thread *thread,
+				    struct vdso_info *vdso_info,
+				    struct dso **dso)
+{
+	enum dso_type dso_type;
+
+	dso_type = machine__thread_dso_type(machine, thread);
+
+#ifndef HAVE_PERF_READ_VDSO32
+	if (dso_type == DSO__TYPE_32BIT)
+		return 0;
+#endif
+#ifndef HAVE_PERF_READ_VDSOX32
+	if (dso_type == DSO__TYPE_X32BIT)
+		return 0;
+#endif
+
+	switch (dso_type) {
+	case DSO__TYPE_32BIT:
+		*dso = vdso__findnew_compat(machine, &vdso_info->vdso32);
+		return 1;
+	case DSO__TYPE_X32BIT:
+		*dso = vdso__findnew_compat(machine, &vdso_info->vdsox32);
+		return 1;
+	case DSO__TYPE_UNKNOWN:
+	case DSO__TYPE_64BIT:
+	default:
+		return 0;
+	}
+}
+
+#endif
+
 struct dso *vdso__dso_findnew(struct machine *machine,
 			      struct thread *thread __maybe_unused)
 {
@@ -148,6 +294,11 @@ struct dso *vdso__dso_findnew(struct machine *machine,
 	if (!vdso_info)
 		return NULL;
 
+#if BITS_PER_LONG == 64
+	if (vdso__dso_findnew_compat(machine, thread, vdso_info, &dso))
+		return dso;
+#endif
+
 	dso = dsos__find(&machine->user_dsos, DSO__NAME_VDSO, true);
 	if (!dso) {
 		char *file;
@@ -164,5 +315,7 @@ struct dso *vdso__dso_findnew(struct machine *machine,
 
 bool dso__is_vdso(struct dso *dso)
 {
-	return !strcmp(dso->short_name, DSO__NAME_VDSO);
+	return !strcmp(dso->short_name, DSO__NAME_VDSO) ||
+	       !strcmp(dso->short_name, DSO__NAME_VDSO32) ||
+	       !strcmp(dso->short_name, DSO__NAME_VDSOX32);
 }
diff --git a/tools/perf/util/vdso.h b/tools/perf/util/vdso.h
index af9d6929a215..d97da1616f0c 100644
--- a/tools/perf/util/vdso.h
+++ b/tools/perf/util/vdso.h
@@ -7,7 +7,9 @@
 
 #define VDSO__MAP_NAME "[vdso]"
 
-#define DSO__NAME_VDSO "[vdso]"
+#define DSO__NAME_VDSO    "[vdso]"
+#define DSO__NAME_VDSO32  "[vdso32]"
+#define DSO__NAME_VDSOX32 "[vdsox32]"
 
 static inline bool is_vdso_map(const char *filename)
 {
diff --git a/tools/perf/util/zlib.c b/tools/perf/util/zlib.c
new file mode 100644
index 000000000000..495a449fc25c
--- /dev/null
+++ b/tools/perf/util/zlib.c
@@ -0,0 +1,78 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <zlib.h>
+
+#include "util/util.h"
+#include "util/debug.h"
+
+
+#define CHUNK_SIZE  16384
+
+int gzip_decompress_to_file(const char *input, int output_fd)
+{
+	int ret = Z_STREAM_ERROR;
+	int input_fd;
+	void *ptr;
+	int len;
+	struct stat stbuf;
+	unsigned char buf[CHUNK_SIZE];
+	z_stream zs = {
+		.zalloc		= Z_NULL,
+		.zfree		= Z_NULL,
+		.opaque		= Z_NULL,
+		.avail_in	= 0,
+		.next_in	= Z_NULL,
+	};
+
+	input_fd = open(input, O_RDONLY);
+	if (input_fd < 0)
+		return -1;
+
+	if (fstat(input_fd, &stbuf) < 0)
+		goto out_close;
+
+	ptr = mmap(NULL, stbuf.st_size, PROT_READ, MAP_PRIVATE, input_fd, 0);
+	if (ptr == MAP_FAILED)
+		goto out_close;
+
+	if (inflateInit2(&zs, 16 + MAX_WBITS) != Z_OK)
+		goto out_unmap;
+
+	zs.next_in = ptr;
+	zs.avail_in = stbuf.st_size;
+
+	do {
+		zs.next_out = buf;
+		zs.avail_out = CHUNK_SIZE;
+
+		ret = inflate(&zs, Z_NO_FLUSH);
+		switch (ret) {
+		case Z_NEED_DICT:
+			ret = Z_DATA_ERROR;
+			/* fall through */
+		case Z_DATA_ERROR:
+		case Z_MEM_ERROR:
+			goto out;
+		default:
+			break;
+		}
+
+		len = CHUNK_SIZE - zs.avail_out;
+		if (writen(output_fd, buf, len) != len) {
+			ret = Z_DATA_ERROR;
+			goto out;
+		}
+
+	} while (ret != Z_STREAM_END);
+
+out:
+	inflateEnd(&zs);
+out_unmap:
+	munmap(ptr, stbuf.st_size);
+out_close:
+	close(input_fd);
+
+	return ret == Z_STREAM_END ? 0 : -1;
+}
