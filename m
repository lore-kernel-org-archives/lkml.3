Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3IYSAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:00:08 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:32883 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3IYSAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:00:06 -0400
Date: Wed, 25 Sep 2013 20:00:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20130925180000.GA15165@gmail.com>
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

   HEAD: cf3b425dd8d99e01214515a6754f9e69ecc6dce8 perf/x86/intel: Add model number for Avoton Silvermont

Assorted standalone fixes.

 Thanks,

	Ingo

------------------>
Adrian Hunter (3):
      perf annotate: Fix objdump line parsing offset validation
      perf tools: Fix buildid cache handling of kallsyms with kcore
      perf tools: Fix compile with libelf without get_phdrnum

Arnaldo Carvalho de Melo (1):
      perf session: Check for SIGINT in more loops

Ingo Molnar (3):
      perf tools: Sharpen the libaudit dependencies test
      perf tools: Fill in new definitions for madvise()/mmap() flags
      perf tools: Fix old GCC build error in trace-event-parse.c:parse_proc_kallsyms()

Masami Hiramatsu (1):
      perf probe: Fix finder to find lines of given function

Peter Zijlstra (2):
      perf: Update ABI comment
      perf: Fix capabilities bitfield compatibility in 'struct perf_event_mmap_page'

Vinson Lee (1):
      tools lib lk: Uninclude linux/magic.h in debugfs.c

Yan, Zheng (2):
      perf/x86/intel/uncore: Don't use smp_processor_id() in validate_group()
      perf/x86/intel: Add model number for Avoton Silvermont


 arch/x86/kernel/cpu/perf_event.c              | 10 +++----
 arch/x86/kernel/cpu/perf_event_intel.c        |  1 +
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 10 +++----
 include/uapi/linux/perf_event.h               | 15 ++++++----
 kernel/events/core.c                          | 21 ++++++++++++++
 tools/lib/lk/debugfs.c                        |  1 -
 tools/perf/arch/x86/util/tsc.c                |  6 ++--
 tools/perf/builtin-inject.c                   |  2 --
 tools/perf/builtin-report.c                   |  5 ++--
 tools/perf/builtin-script.c                   |  2 --
 tools/perf/builtin-trace.c                    | 17 +++++++++++
 tools/perf/config/Makefile                    |  3 ++
 tools/perf/config/feature-tests.mak           | 10 +++++++
 tools/perf/util/annotate.c                    |  2 +-
 tools/perf/util/dwarf-aux.c                   | 19 +++++++++++++
 tools/perf/util/dwarf-aux.h                   |  3 ++
 tools/perf/util/header.c                      | 41 ++++++++++++++++++---------
 tools/perf/util/hist.c                        |  2 ++
 tools/perf/util/probe-finder.c                | 12 ++++----
 tools/perf/util/session.c                     |  9 ++++--
 tools/perf/util/session.h                     |  4 +++
 tools/perf/util/symbol-elf.c                  | 16 +++++++++++
 tools/perf/util/trace-event-parse.c           |  2 +-
 23 files changed, 164 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 8355c84..a9c606b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1883,9 +1883,9 @@ static struct pmu pmu = {
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
-	userpg->cap_usr_time = 0;
-	userpg->cap_usr_time_zero = 0;
-	userpg->cap_usr_rdpmc = x86_pmu.attr_rdpmc;
+	userpg->cap_user_time = 0;
+	userpg->cap_user_time_zero = 0;
+	userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
 	userpg->pmc_width = x86_pmu.cntval_bits;
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
@@ -1894,13 +1894,13 @@ void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 		return;
 
-	userpg->cap_usr_time = 1;
+	userpg->cap_user_time = 1;
 	userpg->time_mult = this_cpu_read(cyc2ns);
 	userpg->time_shift = CYC2NS_SCALE_FACTOR;
 	userpg->time_offset = this_cpu_read(cyc2ns_offset) - now;
 
 	if (sched_clock_stable && !check_tsc_disabled()) {
-		userpg->cap_usr_time_zero = 1;
+		userpg->cap_user_time_zero = 1;
 		userpg->time_zero = this_cpu_read(cyc2ns_offset);
 	}
 }
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9db76c3..f31a165 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2325,6 +2325,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 55: /* Atom 22nm "Silvermont" */
+	case 77: /* Avoton "Silvermont" */
 		memcpy(hw_cache_event_ids, slm_hw_cache_event_ids,
 			sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, slm_hw_cache_extra_regs,
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 8ed4458..4118f9f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2706,14 +2706,14 @@ static void uncore_pmu_init_hrtimer(struct intel_uncore_box *box)
 	box->hrtimer.function = uncore_pmu_hrtimer;
 }
 
-struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int cpu)
+static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type, int node)
 {
 	struct intel_uncore_box *box;
 	int i, size;
 
 	size = sizeof(*box) + type->num_shared_regs * sizeof(struct intel_uncore_extra_reg);
 
-	box = kzalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+	box = kzalloc_node(size, GFP_KERNEL, node);
 	if (!box)
 		return NULL;
 
@@ -3031,7 +3031,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
 	struct intel_uncore_box *fake_box;
 	int ret = -EINVAL, n;
 
-	fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
+	fake_box = uncore_alloc_box(pmu->type, NUMA_NO_NODE);
 	if (!fake_box)
 		return -ENOMEM;
 
@@ -3294,7 +3294,7 @@ static int uncore_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id
 	}
 
 	type = pci_uncores[UNCORE_PCI_DEV_TYPE(id->driver_data)];
-	box = uncore_alloc_box(type, 0);
+	box = uncore_alloc_box(type, NUMA_NO_NODE);
 	if (!box)
 		return -ENOMEM;
 
@@ -3499,7 +3499,7 @@ static int uncore_cpu_prepare(int cpu, int phys_id)
 			if (pmu->func_id < 0)
 				pmu->func_id = j;
 
-			box = uncore_alloc_box(type, cpu);
+			box = uncore_alloc_box(type, cpu_to_node(cpu));
 			if (!box)
 				return -ENOMEM;
 
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 40a1fb8..009a655 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -380,10 +380,13 @@ struct perf_event_mmap_page {
 	union {
 		__u64	capabilities;
 		struct {
-			__u64	cap_usr_time		: 1,
-				cap_usr_rdpmc		: 1,
-				cap_usr_time_zero	: 1,
-				cap_____res		: 61;
+			__u64	cap_bit0		: 1, /* Always 0, deprecated, see commit 860f085b74e9 */
+				cap_bit0_is_deprecated	: 1, /* Always 1, signals that bit 0 is zero */
+
+				cap_user_rdpmc		: 1, /* The RDPMC instruction can be used to read counts */
+				cap_user_time		: 1, /* The time_* fields are used */
+				cap_user_time_zero	: 1, /* The time_zero field is used */
+				cap_____res		: 59;
 		};
 	};
 
@@ -442,12 +445,13 @@ struct perf_event_mmap_page {
 	 *               ((rem * time_mult) >> time_shift);
 	 */
 	__u64	time_zero;
+	__u32	size;			/* Header size up to __reserved[] fields. */
 
 		/*
 		 * Hole for extension of the self monitor capabilities
 		 */
 
-	__u64	__reserved[119];	/* align to 1k */
+	__u8	__reserved[118*8+4];	/* align to 1k. */
 
 	/*
 	 * Control data for the mmap() data buffer.
@@ -528,6 +532,7 @@ enum perf_event_type {
 	 *	u64				len;
 	 *	u64				pgoff;
 	 *	char				filename[];
+	 * 	struct sample_id		sample_id;
 	 * };
 	 */
 	PERF_RECORD_MMAP			= 1,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd236b6..cb4238e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3660,6 +3660,26 @@ static void calc_timer_values(struct perf_event *event,
 	*running = ctx_time - event->tstamp_running;
 }
 
+static void perf_event_init_userpage(struct perf_event *event)
+{
+	struct perf_event_mmap_page *userpg;
+	struct ring_buffer *rb;
+
+	rcu_read_lock();
+	rb = rcu_dereference(event->rb);
+	if (!rb)
+		goto unlock;
+
+	userpg = rb->user_page;
+
+	/* Allow new userspace to detect that bit 0 is deprecated */
+	userpg->cap_bit0_is_deprecated = 1;
+	userpg->size = offsetof(struct perf_event_mmap_page, __reserved);
+
+unlock:
+	rcu_read_unlock();
+}
+
 void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
 }
@@ -4044,6 +4064,7 @@ again:
 	ring_buffer_attach(event, rb);
 	rcu_assign_pointer(event->rb, rb);
 
+	perf_event_init_userpage(event);
 	perf_event_update_userpage(event);
 
 unlock:
diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
index 099e7cd..7c43479 100644
--- a/tools/lib/lk/debugfs.c
+++ b/tools/lib/lk/debugfs.c
@@ -5,7 +5,6 @@
 #include <stdbool.h>
 #include <sys/vfs.h>
 #include <sys/mount.h>
-#include <linux/magic.h>
 #include <linux/kernel.h>
 
 #include "debugfs.h"
diff --git a/tools/perf/arch/x86/util/tsc.c b/tools/perf/arch/x86/util/tsc.c
index 9570c2b..b2519e4 100644
--- a/tools/perf/arch/x86/util/tsc.c
+++ b/tools/perf/arch/x86/util/tsc.c
@@ -32,7 +32,7 @@ u64 tsc_to_perf_time(u64 cyc, struct perf_tsc_conversion *tc)
 int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 			     struct perf_tsc_conversion *tc)
 {
-	bool cap_usr_time_zero;
+	bool cap_user_time_zero;
 	u32 seq;
 	int i = 0;
 
@@ -42,7 +42,7 @@ int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 		tc->time_mult = pc->time_mult;
 		tc->time_shift = pc->time_shift;
 		tc->time_zero = pc->time_zero;
-		cap_usr_time_zero = pc->cap_usr_time_zero;
+		cap_user_time_zero = pc->cap_user_time_zero;
 		rmb();
 		if (pc->lock == seq && !(seq & 1))
 			break;
@@ -52,7 +52,7 @@ int perf_read_tsc_conversion(const struct perf_event_mmap_page *pc,
 		}
 	}
 
-	if (!cap_usr_time_zero)
+	if (!cap_user_time_zero)
 		return -EOPNOTSUPP;
 
 	return 0;
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 423875c..afe377b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -321,8 +321,6 @@ found:
 	return perf_event__repipe(tool, event_sw, &sample_sw, machine);
 }
 
-extern volatile int session_done;
-
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8e50d8d..72eae74 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -401,8 +401,6 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 	return 0;
 }
 
-extern volatile int session_done;
-
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
@@ -568,6 +566,9 @@ static int __cmd_report(struct perf_report *rep)
 		}
 	}
 
+	if (session_done())
+		return 0;
+
 	if (nr_samples == 0) {
 		ui__error("The %s file has no samples!\n", session->filename);
 		return 0;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7f31a3d..9c333ff 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -553,8 +553,6 @@ static struct perf_tool perf_script = {
 	.ordering_requires_timestamps = true,
 };
 
-extern volatile int session_done;
-
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f5aa637..fd48534 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -16,6 +16,23 @@
 #include <sys/mman.h>
 #include <linux/futex.h>
 
+/* For older distros: */
+#ifndef MAP_STACK
+# define MAP_STACK		0x20000
+#endif
+
+#ifndef MADV_HWPOISON
+# define MADV_HWPOISON		100
+#endif
+
+#ifndef MADV_MERGEABLE
+# define MADV_MERGEABLE		12
+#endif
+
+#ifndef MADV_UNMERGEABLE
+# define MADV_UNMERGEABLE	13
+#endif
+
 static size_t syscall_arg__scnprintf_hex(char *bf, size_t size,
 					 unsigned long arg,
 					 u8 arg_idx __maybe_unused,
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 214e17e..346ee92 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -180,6 +180,9 @@ FLAGS_LIBELF=$(CFLAGS) $(LDFLAGS) $(EXTLIBS)
 ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
   CFLAGS += -DLIBELF_MMAP
 endif
+ifeq ($(call try-cc,$(SOURCE_ELF_GETPHDRNUM),$(FLAGS_LIBELF),-DHAVE_ELF_GETPHDRNUM),y)
+  CFLAGS += -DHAVE_ELF_GETPHDRNUM
+endif
 
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 708fb8e..d5a8dd4 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -61,6 +61,15 @@ int main(void)
 }
 endef
 
+define SOURCE_ELF_GETPHDRNUM
+#include <libelf.h>
+int main(void)
+{
+	size_t dst;
+	return elf_getphdrnum(0, &dst);
+}
+endef
+
 ifndef NO_SLANG
 define SOURCE_SLANG
 #include <slang.h>
@@ -210,6 +219,7 @@ define SOURCE_LIBAUDIT
 
 int main(void)
 {
+	printf(\"error message: %s\n\", audit_errno_to_name(0));
 	return audit_open();
 }
 endef
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index bfc5a27..7eae548 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -809,7 +809,7 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		    end = map__rip_2objdump(map, sym->end);
 
 		offset = line_ip - start;
-		if (offset < 0 || (u64)line_ip > end)
+		if ((u64)line_ip < start || (u64)line_ip > end)
 			offset = -1;
 		else
 			parsed_line = tmp2 + 1;
diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 3e5f543..e23bde1 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -263,6 +263,21 @@ bool die_is_signed_type(Dwarf_Die *tp_die)
 }
 
 /**
+ * die_is_func_def - Ensure that this DIE is a subprogram and definition
+ * @dw_die: a DIE
+ *
+ * Ensure that this DIE is a subprogram and NOT a declaration. This
+ * returns true if @dw_die is a function definition.
+ **/
+bool die_is_func_def(Dwarf_Die *dw_die)
+{
+	Dwarf_Attribute attr;
+
+	return (dwarf_tag(dw_die) == DW_TAG_subprogram &&
+		dwarf_attr(dw_die, DW_AT_declaration, &attr) == NULL);
+}
+
+/**
  * die_get_data_member_location - Get the data-member offset
  * @mb_die: a DIE of a member of a data structure
  * @offs: The offset of the member in the data structure
@@ -392,6 +407,10 @@ static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
 {
 	struct __addr_die_search_param *ad = data;
 
+	/*
+	 * Since a declaration entry doesn't has given pc, this always returns
+	 * function definition entry.
+	 */
 	if (dwarf_tag(fn_die) == DW_TAG_subprogram &&
 	    dwarf_haspc(fn_die, ad->addr)) {
 		memcpy(ad->die_mem, fn_die, sizeof(Dwarf_Die));
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index 6ce1717..8658d41 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -38,6 +38,9 @@ extern int cu_find_lineinfo(Dwarf_Die *cudie, unsigned long addr,
 extern int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
 			int (*callback)(Dwarf_Die *, void *), void *data);
 
+/* Ensure that this DIE is a subprogram and definition (not declaration) */
+extern bool die_is_func_def(Dwarf_Die *dw_die);
+
 /* Compare diename and tname */
 extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 26441d0..ce69901 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -199,9 +199,11 @@ static int write_buildid(char *name, size_t name_len, u8 *build_id,
 	return write_padded(fd, name, name_len + 1, len);
 }
 
-static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
-				u16 misc, int fd)
+static int __dsos__write_buildid_table(struct list_head *head,
+				       struct machine *machine,
+				       pid_t pid, u16 misc, int fd)
 {
+	char nm[PATH_MAX];
 	struct dso *pos;
 
 	dsos__for_each_with_build_id(pos, head) {
@@ -215,6 +217,10 @@ static int __dsos__write_buildid_table(struct list_head *head, pid_t pid,
 		if (is_vdso_map(pos->short_name)) {
 			name = (char *) VDSO__MAP_NAME;
 			name_len = sizeof(VDSO__MAP_NAME) + 1;
+		} else if (dso__is_kcore(pos)) {
+			machine__mmap_name(machine, nm, sizeof(nm));
+			name = nm;
+			name_len = strlen(nm) + 1;
 		} else {
 			name = pos->long_name;
 			name_len = pos->long_name_len + 1;
@@ -240,10 +246,10 @@ static int machine__write_buildid_table(struct machine *machine, int fd)
 		umisc = PERF_RECORD_MISC_GUEST_USER;
 	}
 
-	err = __dsos__write_buildid_table(&machine->kernel_dsos, machine->pid,
-					  kmisc, fd);
+	err = __dsos__write_buildid_table(&machine->kernel_dsos, machine,
+					  machine->pid, kmisc, fd);
 	if (err == 0)
-		err = __dsos__write_buildid_table(&machine->user_dsos,
+		err = __dsos__write_buildid_table(&machine->user_dsos, machine,
 						  machine->pid, umisc, fd);
 	return err;
 }
@@ -375,23 +381,31 @@ out_free:
 	return err;
 }
 
-static int dso__cache_build_id(struct dso *dso, const char *debugdir)
+static int dso__cache_build_id(struct dso *dso, struct machine *machine,
+			       const char *debugdir)
 {
 	bool is_kallsyms = dso->kernel && dso->long_name[0] != '/';
 	bool is_vdso = is_vdso_map(dso->short_name);
+	char *name = dso->long_name;
+	char nm[PATH_MAX];
 
-	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id),
-				     dso->long_name, debugdir,
-				     is_kallsyms, is_vdso);
+	if (dso__is_kcore(dso)) {
+		is_kallsyms = true;
+		machine__mmap_name(machine, nm, sizeof(nm));
+		name = nm;
+	}
+	return build_id_cache__add_b(dso->build_id, sizeof(dso->build_id), name,
+				     debugdir, is_kallsyms, is_vdso);
 }
 
-static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
+static int __dsos__cache_build_ids(struct list_head *head,
+				   struct machine *machine, const char *debugdir)
 {
 	struct dso *pos;
 	int err = 0;
 
 	dsos__for_each_with_build_id(pos, head)
-		if (dso__cache_build_id(pos, debugdir))
+		if (dso__cache_build_id(pos, machine, debugdir))
 			err = -1;
 
 	return err;
@@ -399,8 +413,9 @@ static int __dsos__cache_build_ids(struct list_head *head, const char *debugdir)
 
 static int machine__cache_build_ids(struct machine *machine, const char *debugdir)
 {
-	int ret = __dsos__cache_build_ids(&machine->kernel_dsos, debugdir);
-	ret |= __dsos__cache_build_ids(&machine->user_dsos, debugdir);
+	int ret = __dsos__cache_build_ids(&machine->kernel_dsos, machine,
+					  debugdir);
+	ret |= __dsos__cache_build_ids(&machine->user_dsos, machine, debugdir);
 	return ret;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 46a0d35..9ff6cf3 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -611,6 +611,8 @@ void hists__collapse_resort(struct hists *hists)
 	next = rb_first(root);
 
 	while (next) {
+		if (session_done())
+			break;
 		n = rb_entry(next, struct hist_entry, rb_node_in);
 		next = rb_next(&n->rb_node_in);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index be03293..20c7299 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -734,7 +734,7 @@ static int call_probe_finder(Dwarf_Die *sc_die, struct probe_finder *pf)
 	}
 
 	/* If not a real subprogram, find a real one */
-	if (dwarf_tag(sc_die) != DW_TAG_subprogram) {
+	if (!die_is_func_def(sc_die)) {
 		if (!die_find_realfunc(&pf->cu_die, pf->addr, &pf->sp_die)) {
 			pr_warning("Failed to find probe point in any "
 				   "functions.\n");
@@ -980,12 +980,10 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 	struct dwarf_callback_param *param = data;
 	struct probe_finder *pf = param->data;
 	struct perf_probe_point *pp = &pf->pev->point;
-	Dwarf_Attribute attr;
 
 	/* Check tag and diename */
-	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
-	    !die_compare_name(sp_die, pp->function) ||
-	    dwarf_attr(sp_die, DW_AT_declaration, &attr))
+	if (!die_is_func_def(sp_die) ||
+	    !die_compare_name(sp_die, pp->function))
 		return DWARF_CB_OK;
 
 	/* Check declared file */
@@ -1474,7 +1472,7 @@ static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
 	return 0;
 }
 
-/* Search function from function name */
+/* Search function definition from function name */
 static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct dwarf_callback_param *param = data;
@@ -1485,7 +1483,7 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	if (lr->file && strtailcmp(lr->file, dwarf_decl_file(sp_die)))
 		return DWARF_CB_OK;
 
-	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
+	if (die_is_func_def(sp_die) &&
 	    die_compare_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);
 		dwarf_decl_line(sp_die, &lr->offset);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 51f5edf..70ffa41 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -531,6 +531,9 @@ static int flush_sample_queue(struct perf_session *s,
 		return 0;
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
+		if (session_done())
+			return 0;
+
 		if (iter->timestamp > limit)
 			break;
 
@@ -1160,7 +1163,6 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 	}
 }
 
-#define session_done()	(*(volatile int *)(&session_done))
 volatile int session_done;
 
 static int __perf_session__process_pipe_events(struct perf_session *self,
@@ -1372,10 +1374,13 @@ more:
 				    "Processing events...");
 	}
 
+	err = 0;
+	if (session_done())
+		goto out_err;
+
 	if (file_pos < file_size)
 		goto more;
 
-	err = 0;
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
 	err = flush_sample_queue(session, tool);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 3aa75fb..04bf737 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -124,4 +124,8 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 
 #define perf_session__set_tracepoints_handlers(session, array) \
 	__perf_session__set_tracepoints_handlers(session, array, ARRAY_SIZE(array))
+
+extern volatile int session_done;
+
+#define session_done()	(*(volatile int *)(&session_done))
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a7b9ab5..a9c829b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -8,6 +8,22 @@
 #include "symbol.h"
 #include "debug.h"
 
+#ifndef HAVE_ELF_GETPHDRNUM
+static int elf_getphdrnum(Elf *elf, size_t *dst)
+{
+	GElf_Ehdr gehdr;
+	GElf_Ehdr *ehdr;
+
+	ehdr = gelf_getehdr(elf, &gehdr);
+	if (!ehdr)
+		return -1;
+
+	*dst = ehdr->e_phnum;
+
+	return 0;
+}
+#endif
+
 #ifndef NT_GNU_BUILD_ID
 #define NT_GNU_BUILD_ID 3
 #endif
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index fe7a27d..e9e1c03 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -186,7 +186,7 @@ void parse_proc_kallsyms(struct pevent *pevent,
 	char *next = NULL;
 	char *addr_str;
 	char *mod;
-	char *fmt;
+	char *fmt = NULL;
 
 	line = strtok_r(file, "\n", &next);
 	while (line) {
