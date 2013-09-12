Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3ILNjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:39:04 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:38686 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3ILNjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:39:02 -0400
Date: Thu, 12 Sep 2013 15:38:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130912133855.GA23780@gmail.com>
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

   HEAD: dbc33f7016747bfce64f3d1e3af63f1251fcbf85 perf/x86: Fix uncore PCI fixed counter handling

Various fixes. (The -g perf report lockup you reported is only partially 
addressed, patches that fix the excessive runtime are still being worked 
on.)

 Thanks,

	Ingo

------------------>
Adrian Hunter (4):
      perf tools: Add test for parsing with no sample_id_all bit
      perf evlist: Fix parsing with no sample_id_all bit set
      perf evlist: Fix id pos in perf_evlist__open()
      perf kvm: Fix sample_type manipulation

Arnaldo Carvalho de Melo (4):
      perf trace: Check control+C more often
      perf hists: Fix formatting of long symbol names
      perf trace: Handle perf.data files with no tracepoints
      perf: Fix up MMAP2 buffer space reservation

Jiri Olsa (1):
      perf session: Separate progress bar update when processing events

Kyle McMartin (1):
      perf trace: Check if MAP_32BIT is defined

Oleg Nesterov (1):
      uprobes: Fix utask->depth accounting in handle_trampoline()

Stephane Eranian (3):
      perf tools: Add attr->mmap2 support
      perf/x86: Add constraint for IVB CYCLE_ACTIVITY:CYCLES_LDM_PENDING
      perf/x86: Fix uncore PCI fixed counter handling


 arch/x86/kernel/cpu/perf_event_intel.c        |   1 +
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   6 +-
 kernel/events/core.c                          |   1 +
 kernel/events/uprobes.c                       |   4 +-
 tools/perf/Makefile                           |   3 +-
 tools/perf/builtin-annotate.c                 |   1 +
 tools/perf/builtin-inject.c                   |  15 ++++
 tools/perf/builtin-kvm.c                      |  18 ++---
 tools/perf/builtin-mem.c                      |   1 +
 tools/perf/builtin-report.c                   |   1 +
 tools/perf/builtin-script.c                   |   1 +
 tools/perf/builtin-trace.c                    |   5 ++
 tools/perf/tests/builtin-test.c               |   4 +
 tools/perf/tests/parse-no-sample-id-all.c     | 108 ++++++++++++++++++++++++++
 tools/perf/tests/perf-record.c                |  15 +++-
 tools/perf/tests/tests.h                      |   1 +
 tools/perf/ui/stdio/hist.c                    |  23 ++++--
 tools/perf/util/build-id.c                    |   1 +
 tools/perf/util/event.c                       |  56 ++++++++++---
 tools/perf/util/event.h                       |  19 +++++
 tools/perf/util/evlist.c                      |  21 ++++-
 tools/perf/util/evsel.c                       |  16 +++-
 tools/perf/util/header.c                      |   3 +
 tools/perf/util/machine.c                     |  53 ++++++++++++-
 tools/perf/util/machine.h                     |   1 +
 tools/perf/util/map.c                         |   8 +-
 tools/perf/util/map.h                         |   8 +-
 tools/perf/util/session.c                     |  68 ++++++++--------
 tools/perf/util/tool.h                        |   1 +
 29 files changed, 381 insertions(+), 82 deletions(-)
 create mode 100644 tools/perf/tests/parse-no-sample-id-all.c

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0abf674..c62d883 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -124,6 +124,7 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
 	INTEL_UEVENT_CONSTRAINT(0x0148, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x0279, 0xf), /* IDQ.EMTPY */
 	INTEL_UEVENT_CONSTRAINT(0x019c, 0xf), /* IDQ_UOPS_NOT_DELIVERED.CORE */
+	INTEL_UEVENT_CONSTRAINT(0x02a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_LDM_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_EXECUTE */
 	INTEL_UEVENT_CONSTRAINT(0x05a3, 0xf), /* CYCLE_ACTIVITY.STALLS_L2_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x06a3, 0xf), /* CYCLE_ACTIVITY.STALLS_LDM_PENDING */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index fd8011e..8ed4458 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2808,7 +2808,7 @@ uncore_get_event_constraint(struct intel_uncore_box *box, struct perf_event *eve
 			return c;
 	}
 
-	if (event->hw.config == ~0ULL)
+	if (event->attr.config == UNCORE_FIXED_EVENT)
 		return &constraint_fixed;
 
 	if (type->constraints) {
@@ -3112,7 +3112,9 @@ static int uncore_pmu_event_init(struct perf_event *event)
 		 */
 		if (pmu->type->single_fixed && pmu->pmu_idx > 0)
 			return -EINVAL;
-		hwc->config = ~0ULL;
+
+		/* fixed counters have event field hardcoded to zero */
+		hwc->config = 0ULL;
 	} else {
 		hwc->config = event->attr.config & pmu->type->event_mask;
 		if (pmu->type->ops->hw_config) {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2207efc..dd236b6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5039,6 +5039,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 		mmap_event->event_id.header.size += sizeof(mmap_event->maj);
 		mmap_event->event_id.header.size += sizeof(mmap_event->min);
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
+		mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
 	}
 
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f356974..ad8e1bd 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1682,12 +1682,10 @@ static bool handle_trampoline(struct pt_regs *regs)
 		tmp = ri;
 		ri = ri->next;
 		kfree(tmp);
+		utask->depth--;
 
 		if (!chained)
 			break;
-
-		utask->depth--;
-
 		BUG_ON(!ri);
 	}
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c5dc1ad..3a0ff7f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -394,6 +394,8 @@ ifeq ($(ARCH),x86)
 LIB_OBJS += $(OUTPUT)tests/perf-time-to-tsc.o
 endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
+LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
+LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
@@ -439,7 +441,6 @@ PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
 ifneq ($(OUTPUT),)
   CFLAGS += -I$(OUTPUT)
 endif
-LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 
 ifdef NO_LIBELF
 EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index f988d38..5ebd0c3 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -277,6 +277,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample	= process_sample_event,
 			.mmap	= perf_event__process_mmap,
+			.mmap2	= perf_event__process_mmap2,
 			.comm	= perf_event__process_comm,
 			.exit	= perf_event__process_exit,
 			.fork	= perf_event__process_fork,
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 9b336fd..423875c 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -123,6 +123,19 @@ static int perf_event__repipe_mmap(struct perf_tool *tool,
 	return err;
 }
 
+static int perf_event__repipe_mmap2(struct perf_tool *tool,
+				   union perf_event *event,
+				   struct perf_sample *sample,
+				   struct machine *machine)
+{
+	int err;
+
+	err = perf_event__process_mmap2(tool, event, sample, machine);
+	perf_event__repipe(tool, event, sample, machine);
+
+	return err;
+}
+
 static int perf_event__repipe_fork(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_sample *sample,
@@ -339,6 +352,7 @@ static int __cmd_inject(struct perf_inject *inject)
 
 	if (inject->build_ids || inject->sched_stat) {
 		inject->tool.mmap	  = perf_event__repipe_mmap;
+		inject->tool.mmap2	  = perf_event__repipe_mmap2;
 		inject->tool.fork	  = perf_event__repipe_fork;
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
@@ -390,6 +404,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		= perf_event__repipe_sample,
 			.mmap		= perf_event__repipe,
+			.mmap2		= perf_event__repipe,
 			.comm		= perf_event__repipe,
 			.fork		= perf_event__repipe,
 			.exit		= perf_event__repipe,
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 47b3540..935d522 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1165,16 +1165,16 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 		struct perf_event_attr *attr = &pos->attr;
 
 		/* make sure these *are* set */
-		attr->sample_type |= PERF_SAMPLE_TID;
-		attr->sample_type |= PERF_SAMPLE_TIME;
-		attr->sample_type |= PERF_SAMPLE_CPU;
-		attr->sample_type |= PERF_SAMPLE_RAW;
+		perf_evsel__set_sample_bit(pos, TID);
+		perf_evsel__set_sample_bit(pos, TIME);
+		perf_evsel__set_sample_bit(pos, CPU);
+		perf_evsel__set_sample_bit(pos, RAW);
 		/* make sure these are *not*; want as small a sample as possible */
-		attr->sample_type &= ~PERF_SAMPLE_PERIOD;
-		attr->sample_type &= ~PERF_SAMPLE_IP;
-		attr->sample_type &= ~PERF_SAMPLE_CALLCHAIN;
-		attr->sample_type &= ~PERF_SAMPLE_ADDR;
-		attr->sample_type &= ~PERF_SAMPLE_READ;
+		perf_evsel__reset_sample_bit(pos, PERIOD);
+		perf_evsel__reset_sample_bit(pos, IP);
+		perf_evsel__reset_sample_bit(pos, CALLCHAIN);
+		perf_evsel__reset_sample_bit(pos, ADDR);
+		perf_evsel__reset_sample_bit(pos, READ);
 		attr->mmap = 0;
 		attr->comm = 0;
 		attr->task = 0;
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 791b432..253133a 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -190,6 +190,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		= process_sample_event,
 			.mmap		= perf_event__process_mmap,
+			.mmap2		= perf_event__process_mmap2,
 			.comm		= perf_event__process_comm,
 			.lost		= perf_event__process_lost,
 			.fork		= perf_event__process_fork,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9725aa3..8e50d8d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -744,6 +744,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		 = process_sample_event,
 			.mmap		 = perf_event__process_mmap,
+			.mmap2		 = perf_event__process_mmap2,
 			.comm		 = perf_event__process_comm,
 			.exit		 = perf_event__process_exit,
 			.fork		 = perf_event__process_fork,
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 93a34ce..7f31a3d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -542,6 +542,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool perf_script = {
 	.sample		 = process_sample_event,
 	.mmap		 = perf_event__process_mmap,
+	.mmap2		 = perf_event__process_mmap2,
 	.comm		 = perf_event__process_comm,
 	.exit		 = perf_event__process_exit,
 	.fork		 = perf_event__process_fork,
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index b6f0725..f5aa637 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -100,7 +100,9 @@ static size_t syscall_arg__scnprintf_mmap_flags(char *bf, size_t size,
 
 	P_MMAP_FLAG(SHARED);
 	P_MMAP_FLAG(PRIVATE);
+#ifdef MAP_32BIT
 	P_MMAP_FLAG(32BIT);
+#endif
 	P_MMAP_FLAG(ANONYMOUS);
 	P_MMAP_FLAG(DENYWRITE);
 	P_MMAP_FLAG(EXECUTABLE);
@@ -994,6 +996,9 @@ again:
 
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
+
+			if (done)
+				goto out_unmap_evlist;
 		}
 	}
 
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 8bbeba3..1e67437 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -112,6 +112,10 @@ static struct test {
 		.func = test__keep_tracking,
 	},
 	{
+		.desc = "Test parsing with no sample_id_all bit set",
+		.func = test__parse_no_sample_id_all,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/parse-no-sample-id-all.c b/tools/perf/tests/parse-no-sample-id-all.c
new file mode 100644
index 0000000..e117b6c
--- /dev/null
+++ b/tools/perf/tests/parse-no-sample-id-all.c
@@ -0,0 +1,108 @@
+#include <sys/types.h>
+#include <stddef.h>
+
+#include "tests.h"
+
+#include "event.h"
+#include "evlist.h"
+#include "header.h"
+#include "util.h"
+
+static int process_event(struct perf_evlist **pevlist, union perf_event *event)
+{
+	struct perf_sample sample;
+
+	if (event->header.type == PERF_RECORD_HEADER_ATTR) {
+		if (perf_event__process_attr(NULL, event, pevlist)) {
+			pr_debug("perf_event__process_attr failed\n");
+			return -1;
+		}
+		return 0;
+	}
+
+	if (event->header.type >= PERF_RECORD_USER_TYPE_START)
+		return -1;
+
+	if (!*pevlist)
+		return -1;
+
+	if (perf_evlist__parse_sample(*pevlist, event, &sample)) {
+		pr_debug("perf_evlist__parse_sample failed\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int process_events(union perf_event **events, size_t count)
+{
+	struct perf_evlist *evlist = NULL;
+	int err = 0;
+	size_t i;
+
+	for (i = 0; i < count && !err; i++)
+		err = process_event(&evlist, events[i]);
+
+	if (evlist)
+		perf_evlist__delete(evlist);
+
+	return err;
+}
+
+struct test_attr_event {
+	struct attr_event attr;
+	u64 id;
+};
+
+/**
+ * test__parse_no_sample_id_all - test parsing with no sample_id_all bit set.
+ *
+ * This function tests parsing data produced on kernel's that do not support the
+ * sample_id_all bit.  Without the sample_id_all bit, non-sample events (such as
+ * mmap events) do not have an id sample appended, and consequently logic
+ * designed to determine the id will not work.  That case happens when there is
+ * more than one selected event, so this test processes three events: 2
+ * attributes representing the selected events and one mmap event.
+ *
+ * Return: %0 on success, %-1 if the test fails.
+ */
+int test__parse_no_sample_id_all(void)
+{
+	int err;
+
+	struct test_attr_event event1 = {
+		.attr = {
+			.header = {
+				.type = PERF_RECORD_HEADER_ATTR,
+				.size = sizeof(struct test_attr_event),
+			},
+		},
+		.id = 1,
+	};
+	struct test_attr_event event2 = {
+		.attr = {
+			.header = {
+				.type = PERF_RECORD_HEADER_ATTR,
+				.size = sizeof(struct test_attr_event),
+			},
+		},
+		.id = 2,
+	};
+	struct mmap_event event3 = {
+		.header = {
+			.type = PERF_RECORD_MMAP,
+			.size = sizeof(struct mmap_event),
+		},
+	};
+	union perf_event *events[] = {
+		(union perf_event *)&event1,
+		(union perf_event *)&event2,
+		(union perf_event *)&event3,
+	};
+
+	err = process_events(events, ARRAY_SIZE(events));
+	if (err)
+		return -1;
+
+	return 0;
+}
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 72d8881..b8a7056 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -50,7 +50,7 @@ int test__PERF_RECORD(void)
 	struct perf_sample sample;
 	const char *cmd = "sleep";
 	const char *argv[] = { cmd, "1", NULL, };
-	char *bname;
+	char *bname, *mmap_filename;
 	u64 prev_time = 0;
 	bool found_cmd_mmap = false,
 	     found_libc_mmap = false,
@@ -212,6 +212,7 @@ int test__PERF_RECORD(void)
 
 				if ((type == PERF_RECORD_COMM ||
 				     type == PERF_RECORD_MMAP ||
+				     type == PERF_RECORD_MMAP2 ||
 				     type == PERF_RECORD_FORK ||
 				     type == PERF_RECORD_EXIT) &&
 				     (pid_t)event->comm.pid != evlist->workload.pid) {
@@ -220,7 +221,8 @@ int test__PERF_RECORD(void)
 				}
 
 				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP) &&
+				     type == PERF_RECORD_MMAP ||
+				     type == PERF_RECORD_MMAP2) &&
 				     event->comm.pid != event->comm.tid) {
 					pr_debug("%s with different pid/tid!\n", name);
 					++errs;
@@ -236,7 +238,12 @@ int test__PERF_RECORD(void)
 				case PERF_RECORD_EXIT:
 					goto found_exit;
 				case PERF_RECORD_MMAP:
-					bname = strrchr(event->mmap.filename, '/');
+					mmap_filename = event->mmap.filename;
+					goto check_bname;
+				case PERF_RECORD_MMAP2:
+					mmap_filename = event->mmap2.filename;
+				check_bname:
+					bname = strrchr(mmap_filename, '/');
 					if (bname != NULL) {
 						if (!found_cmd_mmap)
 							found_cmd_mmap = !strcmp(bname + 1, cmd);
@@ -245,7 +252,7 @@ int test__PERF_RECORD(void)
 						if (!found_ld_mmap)
 							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
 					} else if (!found_vdso_mmap)
-						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
+						found_vdso_mmap = !strcmp(mmap_filename, "[vdso]");
 					break;
 
 				case PERF_RECORD_SAMPLE:
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index c048b58..e0ac713 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -39,5 +39,6 @@ int test__perf_time_to_tsc(void);
 int test__code_reading(void);
 int test__sample_parsing(void);
 int test__keep_tracking(void);
+int test__parse_no_sample_id_all(void);
 
 #endif /* TESTS_H */
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 5b4fb33..194e2f4 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -350,9 +350,9 @@ static int hist_entry__period_snprintf(struct perf_hpp *hpp,
 }
 
 static int hist_entry__fprintf(struct hist_entry *he, size_t size,
-			       struct hists *hists, FILE *fp)
+			       struct hists *hists,
+			       char *bf, size_t bfsz, FILE *fp)
 {
-	char bf[512];
 	int ret;
 	struct perf_hpp hpp = {
 		.buf		= bf,
@@ -360,8 +360,8 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 	};
 	bool color = !symbol_conf.field_sep;
 
-	if (size == 0 || size > sizeof(bf))
-		size = hpp.size = sizeof(bf);
+	if (size == 0 || size > bfsz)
+		size = hpp.size = bfsz;
 
 	ret = hist_entry__period_snprintf(&hpp, he, color);
 	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
@@ -392,6 +392,8 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		.ptr	= hists_to_evsel(hists),
 	};
 	bool first = true;
+	size_t linesz;
+	char *line = NULL;
 
 	init_rem_hits();
 
@@ -479,6 +481,13 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		goto out;
 
 print_entries:
+	linesz = hists__sort_list_width(hists) + 3 + 1;
+	line = malloc(linesz);
+	if (line == NULL) {
+		ret = -1;
+		goto out;
+	}
+
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		float percent = h->stat.period * 100.0 /
@@ -490,10 +499,10 @@ print_entries:
 		if (percent < min_pcnt)
 			continue;
 
-		ret += hist_entry__fprintf(h, max_cols, hists, fp);
+		ret += hist_entry__fprintf(h, max_cols, hists, line, linesz, fp);
 
 		if (max_rows && ++nr_rows >= max_rows)
-			goto out;
+			break;
 
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
@@ -501,6 +510,8 @@ print_entries:
 			fprintf(fp, "%.10s end\n", graph_dotted_line);
 		}
 	}
+
+	free(line);
 out:
 	free(rem_sq_bracket);
 
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index fb58409..7ded71d 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -67,6 +67,7 @@ static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
 struct perf_tool build_id__mark_dso_hit_ops = {
 	.sample	= build_id__mark_dso_hit,
 	.mmap	= perf_event__process_mmap,
+	.mmap2	= perf_event__process_mmap2,
 	.fork	= perf_event__process_fork,
 	.exit	= perf_event__exit_del_thread,
 	.attr		 = perf_event__process_attr,
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 8d51f21..9b393e7 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -11,6 +11,7 @@
 static const char *perf_event__names[] = {
 	[0]					= "TOTAL",
 	[PERF_RECORD_MMAP]			= "MMAP",
+	[PERF_RECORD_MMAP2]			= "MMAP2",
 	[PERF_RECORD_LOST]			= "LOST",
 	[PERF_RECORD_COMM]			= "COMM",
 	[PERF_RECORD_EXIT]			= "EXIT",
@@ -186,7 +187,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		return -1;
 	}
 
-	event->header.type = PERF_RECORD_MMAP;
+	event->header.type = PERF_RECORD_MMAP2;
 	/*
 	 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 	 */
@@ -197,7 +198,9 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		char prot[5];
 		char execname[PATH_MAX];
 		char anonstr[] = "//anon";
+		unsigned int ino;
 		size_t size;
+		ssize_t n;
 
 		if (fgets(bf, sizeof(bf), fp) == NULL)
 			break;
@@ -206,9 +209,16 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		strcpy(execname, "");
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
-		       &event->mmap.start, &event->mmap.len, prot,
-		       &event->mmap.pgoff, execname);
+		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
+		       &event->mmap2.start, &event->mmap2.len, prot,
+		       &event->mmap2.pgoff, &event->mmap2.maj,
+		       &event->mmap2.min,
+		       &ino, execname);
+
+		event->mmap2.ino = (u64)ino;
+
+		if (n != 8)
+			continue;
 
 		if (prot[2] != 'x')
 			continue;
@@ -217,15 +227,15 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			strcpy(execname, anonstr);
 
 		size = strlen(execname) + 1;
-		memcpy(event->mmap.filename, execname, size);
+		memcpy(event->mmap2.filename, execname, size);
 		size = PERF_ALIGN(size, sizeof(u64));
-		event->mmap.len -= event->mmap.start;
-		event->mmap.header.size = (sizeof(event->mmap) -
-					   (sizeof(event->mmap.filename) - size));
-		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
-		event->mmap.header.size += machine->id_hdr_size;
-		event->mmap.pid = tgid;
-		event->mmap.tid = pid;
+		event->mmap2.len -= event->mmap.start;
+		event->mmap2.header.size = (sizeof(event->mmap2) -
+					(sizeof(event->mmap2.filename) - size));
+		memset(event->mmap2.filename + size, 0, machine->id_hdr_size);
+		event->mmap2.header.size += machine->id_hdr_size;
+		event->mmap2.pid = tgid;
+		event->mmap2.tid = pid;
 
 		if (process(tool, event, &synth_sample, machine) != 0) {
 			rc = -1;
@@ -527,6 +537,17 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 		       event->mmap.len, event->mmap.pgoff, event->mmap.filename);
 }
 
+size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp)
+{
+	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64
+			   " %02x:%02x %"PRIu64" %"PRIu64"]: %s\n",
+		       event->mmap2.pid, event->mmap2.tid, event->mmap2.start,
+		       event->mmap2.len, event->mmap2.pgoff, event->mmap2.maj,
+		       event->mmap2.min, event->mmap2.ino,
+		       event->mmap2.ino_generation,
+		       event->mmap2.filename);
+}
+
 int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
 			     struct perf_sample *sample __maybe_unused,
@@ -535,6 +556,14 @@ int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 	return machine__process_mmap_event(machine, event);
 }
 
+int perf_event__process_mmap2(struct perf_tool *tool __maybe_unused,
+			     union perf_event *event,
+			     struct perf_sample *sample __maybe_unused,
+			     struct machine *machine)
+{
+	return machine__process_mmap2_event(machine, event);
+}
+
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
 {
 	return fprintf(fp, "(%d:%d):(%d:%d)\n",
@@ -574,6 +603,9 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 	case PERF_RECORD_MMAP:
 		ret += perf_event__fprintf_mmap(event, fp);
 		break;
+	case PERF_RECORD_MMAP2:
+		ret += perf_event__fprintf_mmap2(event, fp);
+		break;
 	default:
 		ret += fprintf(fp, "\n");
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 93130d8..c67ecc4 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -17,6 +17,19 @@ struct mmap_event {
 	char filename[PATH_MAX];
 };
 
+struct mmap2_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
+	u32 maj;
+	u32 min;
+	u64 ino;
+	u64 ino_generation;
+	char filename[PATH_MAX];
+};
+
 struct comm_event {
 	struct perf_event_header header;
 	u32 pid, tid;
@@ -159,6 +172,7 @@ struct tracing_data_event {
 union perf_event {
 	struct perf_event_header	header;
 	struct mmap_event		mmap;
+	struct mmap2_event		mmap2;
 	struct comm_event		comm;
 	struct fork_event		fork;
 	struct lost_event		lost;
@@ -208,6 +222,10 @@ int perf_event__process_mmap(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
+int perf_event__process_mmap2(struct perf_tool *tool,
+			     union perf_event *event,
+			     struct perf_sample *sample,
+			     struct machine *machine);
 int perf_event__process_fork(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
@@ -238,6 +256,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
+size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf(union perf_event *event, FILE *fp);
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b8727ae..f9f77be 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -64,6 +64,16 @@ void perf_evlist__set_id_pos(struct perf_evlist *evlist)
 	evlist->is_pos = first->is_pos;
 }
 
+static void perf_evlist__update_id_pos(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		perf_evsel__calc_id_pos(evsel);
+
+	perf_evlist__set_id_pos(evlist);
+}
+
 static void perf_evlist__purge(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *n;
@@ -446,20 +456,25 @@ static int perf_evlist__event2id(struct perf_evlist *evlist,
 static struct perf_evsel *perf_evlist__event2evsel(struct perf_evlist *evlist,
 						   union perf_event *event)
 {
+	struct perf_evsel *first = perf_evlist__first(evlist);
 	struct hlist_head *head;
 	struct perf_sample_id *sid;
 	int hash;
 	u64 id;
 
 	if (evlist->nr_entries == 1)
-		return perf_evlist__first(evlist);
+		return first;
+
+	if (!first->attr.sample_id_all &&
+	    event->header.type != PERF_RECORD_SAMPLE)
+		return first;
 
 	if (perf_evlist__event2id(evlist, event, &id))
 		return NULL;
 
 	/* Synthesized events have an id of zero */
 	if (!id)
-		return perf_evlist__first(evlist);
+		return first;
 
 	hash = hash_64(id, PERF_EVLIST__HLIST_BITS);
 	head = &evlist->heads[hash];
@@ -915,6 +930,8 @@ int perf_evlist__open(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 	int err;
 
+	perf_evlist__update_id_pos(evlist);
+
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
 		if (err < 0)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 3612183..0ce9feb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -27,6 +27,7 @@
 static struct {
 	bool sample_id_all;
 	bool exclude_guest;
+	bool mmap2;
 } perf_missing_features;
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
@@ -676,8 +677,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (opts->sample_weight)
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
-	attr->mmap = track;
-	attr->comm = track;
+	attr->mmap  = track;
+	attr->mmap2 = track && !perf_missing_features.mmap2;
+	attr->comm  = track;
 
 	/*
 	 * XXX see the function comment above
@@ -1016,6 +1018,8 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 fallback_missing_features:
+	if (perf_missing_features.mmap2)
+		evsel->attr.mmap2 = 0;
 	if (perf_missing_features.exclude_guest)
 		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
 retry_sample_id:
@@ -1080,8 +1084,11 @@ try_fallback:
 	if (err != -EINVAL || cpu > 0 || thread > 0)
 		goto out_close;
 
-	if (!perf_missing_features.exclude_guest &&
-	    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
+	if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
+		perf_missing_features.mmap2 = true;
+		goto fallback_missing_features;
+	} else if (!perf_missing_features.exclude_guest &&
+		   (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
 		perf_missing_features.exclude_guest = true;
 		goto fallback_missing_features;
 	} else if (!perf_missing_features.sample_id_all) {
@@ -1925,6 +1932,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(exclude_hv);
 		if_print(exclude_idle);
 		if_print(mmap);
+		if_print(mmap2);
 		if_print(comm);
 		if_print(freq);
 		if_print(inherit_stat);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a33197a..26441d0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1351,6 +1351,9 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 
 		fprintf(fp, ", precise_ip = %d", evsel->attr.precise_ip);
 
+		fprintf(fp, ", attr_mmap2 = %d", evsel->attr.mmap2);
+		fprintf(fp, ", attr_mmap  = %d", evsel->attr.mmap);
+		fprintf(fp, ", attr_mmap_data = %d", evsel->attr.mmap_data);
 		if (evsel->ids) {
 			fprintf(fp, ", id = {");
 			for (j = 0, id = evsel->id; j < evsel->ids; j++, id++) {
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 1dca61f..933d14f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -997,6 +997,54 @@ out_problem:
 	return -1;
 }
 
+int machine__process_mmap2_event(struct machine *machine,
+				 union perf_event *event)
+{
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread;
+	struct map *map;
+	enum map_type type;
+	int ret = 0;
+
+	if (dump_trace)
+		perf_event__fprintf_mmap2(event, stdout);
+
+	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
+	    cpumode == PERF_RECORD_MISC_KERNEL) {
+		ret = machine__process_kernel_mmap_event(machine, event);
+		if (ret < 0)
+			goto out_problem;
+		return 0;
+	}
+
+	thread = machine__findnew_thread(machine, event->mmap2.pid,
+					event->mmap2.pid);
+	if (thread == NULL)
+		goto out_problem;
+
+	if (event->header.misc & PERF_RECORD_MISC_MMAP_DATA)
+		type = MAP__VARIABLE;
+	else
+		type = MAP__FUNCTION;
+
+	map = map__new(&machine->user_dsos, event->mmap2.start,
+			event->mmap2.len, event->mmap2.pgoff,
+			event->mmap2.pid, event->mmap2.maj,
+			event->mmap2.min, event->mmap2.ino,
+			event->mmap2.ino_generation,
+			event->mmap2.filename, type);
+
+	if (map == NULL)
+		goto out_problem;
+
+	thread__insert_map(thread, map);
+	return 0;
+
+out_problem:
+	dump_printf("problem processing PERF_RECORD_MMAP2, skipping event.\n");
+	return 0;
+}
+
 int machine__process_mmap_event(struct machine *machine, union perf_event *event)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -1028,7 +1076,8 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
-			event->mmap.pid, event->mmap.filename,
+			event->mmap.pid, 0, 0, 0, 0,
+			event->mmap.filename,
 			type);
 
 	if (map == NULL)
@@ -1101,6 +1150,8 @@ int machine__process_event(struct machine *machine, union perf_event *event)
 		ret = machine__process_comm_event(machine, event); break;
 	case PERF_RECORD_MMAP:
 		ret = machine__process_mmap_event(machine, event); break;
+	case PERF_RECORD_MMAP2:
+		ret = machine__process_mmap2_event(machine, event); break;
 	case PERF_RECORD_FORK:
 		ret = machine__process_fork_event(machine, event); break;
 	case PERF_RECORD_EXIT:
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 0df925b..58a6be1 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -45,6 +45,7 @@ int machine__process_exit_event(struct machine *machine, union perf_event *event
 int machine__process_fork_event(struct machine *machine, union perf_event *event);
 int machine__process_lost_event(struct machine *machine, union perf_event *event);
 int machine__process_mmap_event(struct machine *machine, union perf_event *event);
+int machine__process_mmap2_event(struct machine *machine, union perf_event *event);
 int machine__process_event(struct machine *machine, union perf_event *event);
 
 typedef void (*machine__process_t)(struct machine *machine, void *data);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9e8304c..4f6680d 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -48,7 +48,8 @@ void map__init(struct map *map, enum map_type type,
 }
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, char *filename,
+		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
+		     u64 ino_gen, char *filename,
 		     enum map_type type)
 {
 	struct map *map = malloc(sizeof(*map));
@@ -62,6 +63,11 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		vdso = is_vdso_map(filename);
 		no_dso = is_no_dso_memory(filename);
 
+		map->maj = d_maj;
+		map->min = d_min;
+		map->ino = ino;
+		map->ino_generation = ino_gen;
+
 		if (anon) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
 			filename = newfilename;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 2cc93cb..4886ca2 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -36,6 +36,9 @@ struct map {
 	bool			erange_warned;
 	u32			priv;
 	u64			pgoff;
+	u32			maj, min; /* only valid for MMAP2 record */
+	u64			ino;      /* only valid for MMAP2 record */
+	u64			ino_generation;/* only valid for MMAP2 record */
 
 	/* ip -> dso rip */
 	u64			(*map_ip)(struct map *, u64);
@@ -88,8 +91,9 @@ typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, char *filename,
-		     enum map_type type);
+		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
+		     u64 ino_gen,
+		     char *filename, enum map_type type);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 void map__delete(struct map *map);
 struct map *map__clone(struct map *map);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1fc0c62..51f5edf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -351,6 +351,25 @@ static void perf_event__mmap_swap(union perf_event *event,
 	}
 }
 
+static void perf_event__mmap2_swap(union perf_event *event,
+				  bool sample_id_all)
+{
+	event->mmap2.pid   = bswap_32(event->mmap2.pid);
+	event->mmap2.tid   = bswap_32(event->mmap2.tid);
+	event->mmap2.start = bswap_64(event->mmap2.start);
+	event->mmap2.len   = bswap_64(event->mmap2.len);
+	event->mmap2.pgoff = bswap_64(event->mmap2.pgoff);
+	event->mmap2.maj   = bswap_32(event->mmap2.maj);
+	event->mmap2.min   = bswap_32(event->mmap2.min);
+	event->mmap2.ino   = bswap_64(event->mmap2.ino);
+
+	if (sample_id_all) {
+		void *data = &event->mmap2.filename;
+
+		data += PERF_ALIGN(strlen(data) + 1, sizeof(u64));
+		swap_sample_id_all(event, data);
+	}
+}
 static void perf_event__task_swap(union perf_event *event, bool sample_id_all)
 {
 	event->fork.pid	 = bswap_32(event->fork.pid);
@@ -455,6 +474,7 @@ typedef void (*perf_event__swap_op)(union perf_event *event,
 
 static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_MMAP]		  = perf_event__mmap_swap,
+	[PERF_RECORD_MMAP2]		  = perf_event__mmap2_swap,
 	[PERF_RECORD_COMM]		  = perf_event__comm_swap,
 	[PERF_RECORD_FORK]		  = perf_event__task_swap,
 	[PERF_RECORD_EXIT]		  = perf_event__task_swap,
@@ -504,6 +524,7 @@ static int flush_sample_queue(struct perf_session *s,
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
 	unsigned idx = 0, progress_next = os->nr_samples / 16;
+	bool show_progress = limit == ULLONG_MAX;
 	int ret;
 
 	if (!tool->ordered_samples || !limit)
@@ -526,7 +547,7 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
-		if (++idx >= progress_next) {
+		if (show_progress && (++idx >= progress_next)) {
 			progress_next += os->nr_samples / 16;
 			ui_progress__update(idx, os->nr_samples,
 					    "Processing time ordered events...");
@@ -850,7 +871,8 @@ static struct machine *
 	     (cpumode == PERF_RECORD_MISC_GUEST_USER))) {
 		u32 pid;
 
-		if (event->header.type == PERF_RECORD_MMAP)
+		if (event->header.type == PERF_RECORD_MMAP
+		    || event->header.type == PERF_RECORD_MMAP2)
 			pid = event->mmap.pid;
 		else
 			pid = sample->pid;
@@ -977,6 +999,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 						    sample, evsel, machine);
 	case PERF_RECORD_MMAP:
 		return tool->mmap(tool, event, sample, machine);
+	case PERF_RECORD_MMAP2:
+		return tool->mmap2(tool, event, sample, machine);
 	case PERF_RECORD_COMM:
 		return tool->comm(tool, event, sample, machine);
 	case PERF_RECORD_FORK:
@@ -1619,52 +1643,26 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 					     const struct perf_evsel_str_handler *assocs,
 					     size_t nr_assocs)
 {
-	struct perf_evlist *evlist = session->evlist;
-	struct event_format *format;
 	struct perf_evsel *evsel;
-	char *tracepoint, *name;
 	size_t i;
 	int err;
 
 	for (i = 0; i < nr_assocs; i++) {
-		err = -ENOMEM;
-		tracepoint = strdup(assocs[i].name);
-		if (tracepoint == NULL)
-			goto out;
-
-		err = -ENOENT;
-		name = strchr(tracepoint, ':');
-		if (name == NULL)
-			goto out_free;
-
-		*name++ = '\0';
-		format = pevent_find_event_by_name(session->pevent,
-						   tracepoint, name);
-		if (format == NULL) {
-			/*
-			 * Adding a handler for an event not in the session,
-			 * just ignore it.
-			 */
-			goto next;
-		}
-
-		evsel = perf_evlist__find_tracepoint_by_id(evlist, format->id);
+		/*
+		 * Adding a handler for an event not in the session,
+		 * just ignore it.
+		 */
+		evsel = perf_evlist__find_tracepoint_by_name(session->evlist, assocs[i].name);
 		if (evsel == NULL)
-			goto next;
+			continue;
 
 		err = -EEXIST;
 		if (evsel->handler.func != NULL)
-			goto out_free;
+			goto out;
 		evsel->handler.func = assocs[i].handler;
-next:
-		free(tracepoint);
 	}
 
 	err = 0;
 out:
 	return err;
-
-out_free:
-	free(tracepoint);
-	goto out;
 }
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 62b16b6..4385816 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -29,6 +29,7 @@ struct perf_tool {
 	event_sample	sample,
 			read;
 	event_op	mmap,
+			mmap2,
 			comm,
 			fork,
 			exit,
