Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbbAQOPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 09:15:51 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:43967 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbAQOPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 09:15:50 -0500
Date: Sat, 17 Jan 2015 15:15:44 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20150117141544.GA24414@gmail.com>
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

   # HEAD: d01de2389c0190f5959f0a1258a2e87d2fe4ca82 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Mostly tooling fixes, but also two PMU driver fixes.

 Thanks,

	Ingo

------------------>
Alexey Brodkin (1):
      perf tools: Fix statfs.f_type data type mismatch build error with uclibc

Arnaldo Carvalho de Melo (1):
      tools: Remove bitops/hweight usage of bits in tools/perf

Kan Liang (1):
      perf/x86/intel: Fix bug for "cycles:p" and "cycles:pp" on SLM

Namhyung Kim (4):
      perf probe: Propagate error code when write(2) failed
      perf tools: Fix building error in x86_64 when dwarf unwind is on
      perf machine: Fix __machine__findnew_thread() error path
      perf tools: Fix segfault for symbol annotation on TUI

Stephane Eranian (1):
      perf/rapl: Fix sysfs_show() initialization for RAPL PMU

Sukadev Bhattiprolu (1):
      perf tools powerpc: Use dwfl_report_elf() instead of offline.

Vineet Gupta (2):
      perf tools: Elide strlcpy warning with uclibc
      perf tools: Avoid build splat for syscall numbers with uclibc

Wang Nan (1):
      perf test: Fix dwarf unwind using libunwind.


 arch/x86/kernel/cpu/perf_event_intel_ds.c         |  4 +--
 arch/x86/kernel/cpu/perf_event_intel_rapl.c       | 44 ++++++++++++++++-------
 tools/include/asm-generic/bitops.h                |  2 ++
 tools/include/asm-generic/bitops/arch_hweight.h   |  1 +
 tools/include/asm-generic/bitops/const_hweight.h  |  1 +
 tools/include/asm-generic/bitops/hweight.h        |  7 ++++
 tools/include/linux/bitops.h                      |  7 +++-
 tools/lib/api/fs/debugfs.c                        |  2 +-
 tools/lib/api/fs/fs.c                             |  2 +-
 tools/perf/MANIFEST                               |  6 ++++
 tools/perf/Makefile.perf                          | 11 ++++--
 tools/perf/arch/powerpc/util/skip-callchain-idx.c | 19 +++++-----
 tools/perf/bench/sched-pipe.c                     |  2 +-
 tools/perf/builtin-top.c                          |  1 -
 tools/perf/config/Makefile                        |  2 +-
 tools/perf/config/Makefile.arch                   | 26 +++++++-------
 tools/perf/perf-sys.h                             |  1 -
 tools/perf/tests/dwarf-unwind.c                   | 36 +++++++++++++++++--
 tools/perf/util/annotate.h                        |  8 +----
 tools/perf/util/cache.h                           |  2 ++
 tools/perf/util/hweight.c                         | 31 ----------------
 tools/perf/util/include/asm/hweight.h             |  8 -----
 tools/perf/util/machine.c                         |  4 ++-
 tools/perf/util/probe-event.c                     |  4 ++-
 tools/perf/util/python-ext-sources                |  2 +-
 tools/perf/util/unwind-libunwind.c                | 28 ++++++++++++++-
 26 files changed, 165 insertions(+), 96 deletions(-)
 create mode 100644 tools/include/asm-generic/bitops/arch_hweight.h
 create mode 100644 tools/include/asm-generic/bitops/const_hweight.h
 create mode 100644 tools/include/asm-generic/bitops/hweight.h
 delete mode 100644 tools/perf/util/hweight.c
 delete mode 100644 tools/perf/util/include/asm/hweight.h

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3c895d480cd7..073983398364 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -568,8 +568,8 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
 };
 
 struct event_constraint intel_slm_pebs_event_constraints[] = {
-	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
-	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
+	/* INST_RETIRED.ANY_P, inv=1, cmask=16 (cycles:p). */
+	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x1),
 	/* Allow all events as PEBS with no flags */
 	INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
 	EVENT_CONSTRAINT_END
diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
index 673f930c700f..6e434f8e5fc8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
@@ -103,6 +103,13 @@ static struct kobj_attribute format_attr_##_var =		\
 
 #define RAPL_CNTR_WIDTH 32 /* 32-bit rapl counters */
 
+#define RAPL_EVENT_ATTR_STR(_name, v, str)				\
+static struct perf_pmu_events_attr event_attr_##v = {			\
+	.attr		= __ATTR(_name, 0444, rapl_sysfs_show, NULL),	\
+	.id		= 0,						\
+	.event_str	= str,						\
+};
+
 struct rapl_pmu {
 	spinlock_t	 lock;
 	int		 hw_unit;  /* 1/2^hw_unit Joule */
@@ -379,23 +386,36 @@ static struct attribute_group rapl_pmu_attr_group = {
 	.attrs = rapl_pmu_attrs,
 };
 
-EVENT_ATTR_STR(energy-cores, rapl_cores, "event=0x01");
-EVENT_ATTR_STR(energy-pkg  ,   rapl_pkg, "event=0x02");
-EVENT_ATTR_STR(energy-ram  ,   rapl_ram, "event=0x03");
-EVENT_ATTR_STR(energy-gpu  ,   rapl_gpu, "event=0x04");
+static ssize_t rapl_sysfs_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *page)
+{
+	struct perf_pmu_events_attr *pmu_attr = \
+		container_of(attr, struct perf_pmu_events_attr, attr);
+
+	if (pmu_attr->event_str)
+		return sprintf(page, "%s", pmu_attr->event_str);
+
+	return 0;
+}
+
+RAPL_EVENT_ATTR_STR(energy-cores, rapl_cores, "event=0x01");
+RAPL_EVENT_ATTR_STR(energy-pkg  ,   rapl_pkg, "event=0x02");
+RAPL_EVENT_ATTR_STR(energy-ram  ,   rapl_ram, "event=0x03");
+RAPL_EVENT_ATTR_STR(energy-gpu  ,   rapl_gpu, "event=0x04");
 
-EVENT_ATTR_STR(energy-cores.unit, rapl_cores_unit, "Joules");
-EVENT_ATTR_STR(energy-pkg.unit  ,   rapl_pkg_unit, "Joules");
-EVENT_ATTR_STR(energy-ram.unit  ,   rapl_ram_unit, "Joules");
-EVENT_ATTR_STR(energy-gpu.unit  ,   rapl_gpu_unit, "Joules");
+RAPL_EVENT_ATTR_STR(energy-cores.unit, rapl_cores_unit, "Joules");
+RAPL_EVENT_ATTR_STR(energy-pkg.unit  ,   rapl_pkg_unit, "Joules");
+RAPL_EVENT_ATTR_STR(energy-ram.unit  ,   rapl_ram_unit, "Joules");
+RAPL_EVENT_ATTR_STR(energy-gpu.unit  ,   rapl_gpu_unit, "Joules");
 
 /*
  * we compute in 0.23 nJ increments regardless of MSR
  */
-EVENT_ATTR_STR(energy-cores.scale, rapl_cores_scale, "2.3283064365386962890625e-10");
-EVENT_ATTR_STR(energy-pkg.scale,     rapl_pkg_scale, "2.3283064365386962890625e-10");
-EVENT_ATTR_STR(energy-ram.scale,     rapl_ram_scale, "2.3283064365386962890625e-10");
-EVENT_ATTR_STR(energy-gpu.scale,     rapl_gpu_scale, "2.3283064365386962890625e-10");
+RAPL_EVENT_ATTR_STR(energy-cores.scale, rapl_cores_scale, "2.3283064365386962890625e-10");
+RAPL_EVENT_ATTR_STR(energy-pkg.scale,     rapl_pkg_scale, "2.3283064365386962890625e-10");
+RAPL_EVENT_ATTR_STR(energy-ram.scale,     rapl_ram_scale, "2.3283064365386962890625e-10");
+RAPL_EVENT_ATTR_STR(energy-gpu.scale,     rapl_gpu_scale, "2.3283064365386962890625e-10");
 
 static struct attribute *rapl_events_srv_attr[] = {
 	EVENT_PTR(rapl_cores),
diff --git a/tools/include/asm-generic/bitops.h b/tools/include/asm-generic/bitops.h
index 6eedba1f7732..653d1bad77de 100644
--- a/tools/include/asm-generic/bitops.h
+++ b/tools/include/asm-generic/bitops.h
@@ -22,6 +22,8 @@
 #error only <linux/bitops.h> can be included directly
 #endif
 
+#include <asm-generic/bitops/hweight.h>
+
 #include <asm-generic/bitops/atomic.h>
 
 #endif /* __TOOLS_ASM_GENERIC_BITOPS_H */
diff --git a/tools/include/asm-generic/bitops/arch_hweight.h b/tools/include/asm-generic/bitops/arch_hweight.h
new file mode 100644
index 000000000000..318bb2b202b0
--- /dev/null
+++ b/tools/include/asm-generic/bitops/arch_hweight.h
@@ -0,0 +1 @@
+#include "../../../../include/asm-generic/bitops/arch_hweight.h"
diff --git a/tools/include/asm-generic/bitops/const_hweight.h b/tools/include/asm-generic/bitops/const_hweight.h
new file mode 100644
index 000000000000..0afd644aff83
--- /dev/null
+++ b/tools/include/asm-generic/bitops/const_hweight.h
@@ -0,0 +1 @@
+#include "../../../../include/asm-generic/bitops/const_hweight.h"
diff --git a/tools/include/asm-generic/bitops/hweight.h b/tools/include/asm-generic/bitops/hweight.h
new file mode 100644
index 000000000000..290120c01a8e
--- /dev/null
+++ b/tools/include/asm-generic/bitops/hweight.h
@@ -0,0 +1,7 @@
+#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_HWEIGHT_H_
+#define _TOOLS_LINUX_ASM_GENERIC_BITOPS_HWEIGHT_H_
+
+#include <asm-generic/bitops/arch_hweight.h>
+#include <asm-generic/bitops/const_hweight.h>
+
+#endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS_HWEIGHT_H_ */
diff --git a/tools/include/linux/bitops.h b/tools/include/linux/bitops.h
index 26005a15e7e2..5ad9ee1dd7f6 100644
--- a/tools/include/linux/bitops.h
+++ b/tools/include/linux/bitops.h
@@ -1,9 +1,9 @@
 #ifndef _TOOLS_LINUX_BITOPS_H_
 #define _TOOLS_LINUX_BITOPS_H_
 
+#include <asm/types.h>
 #include <linux/kernel.h>
 #include <linux/compiler.h>
-#include <asm/hweight.h>
 
 #ifndef __WORDSIZE
 #define __WORDSIZE (__SIZEOF_LONG__ * 8)
@@ -19,6 +19,11 @@
 #define BITS_TO_U32(nr)		DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u32))
 #define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
 
+extern unsigned int __sw_hweight8(unsigned int w);
+extern unsigned int __sw_hweight16(unsigned int w);
+extern unsigned int __sw_hweight32(unsigned int w);
+extern unsigned long __sw_hweight64(__u64 w);
+
 /*
  * Include this here because some architectures need generic_ffs/fls in
  * scope
diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index a74fba6d7743..86ea2d7b8845 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -67,7 +67,7 @@ int debugfs_valid_mountpoint(const char *debugfs)
 
 	if (statfs(debugfs, &st_fs) < 0)
 		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+	else if ((long)st_fs.f_type != (long)DEBUGFS_MAGIC)
 		return -ENOENT;
 
 	return 0;
diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 65d9be3f9887..128ef6332a6b 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -79,7 +79,7 @@ static int fs__valid_mount(const char *fs, long magic)
 
 	if (statfs(fs, &st_fs) < 0)
 		return -ENOENT;
-	else if (st_fs.f_type != magic)
+	else if ((long)st_fs.f_type != magic)
 		return -ENOENT;
 
 	return 0;
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 83e2887f91a3..fbbfdc39271d 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -6,12 +6,15 @@ tools/lib/symbol/kallsyms.c
 tools/lib/symbol/kallsyms.h
 tools/lib/util/find_next_bit.c
 tools/include/asm/bug.h
+tools/include/asm-generic/bitops/arch_hweight.h
 tools/include/asm-generic/bitops/atomic.h
+tools/include/asm-generic/bitops/const_hweight.h
 tools/include/asm-generic/bitops/__ffs.h
 tools/include/asm-generic/bitops/__fls.h
 tools/include/asm-generic/bitops/find.h
 tools/include/asm-generic/bitops/fls64.h
 tools/include/asm-generic/bitops/fls.h
+tools/include/asm-generic/bitops/hweight.h
 tools/include/asm-generic/bitops.h
 tools/include/linux/bitops.h
 tools/include/linux/compiler.h
@@ -19,6 +22,8 @@ tools/include/linux/export.h
 tools/include/linux/hash.h
 tools/include/linux/log2.h
 tools/include/linux/types.h
+include/asm-generic/bitops/arch_hweight.h
+include/asm-generic/bitops/const_hweight.h
 include/asm-generic/bitops/fls64.h
 include/asm-generic/bitops/__fls.h
 include/asm-generic/bitops/fls.h
@@ -29,6 +34,7 @@ include/linux/list.h
 include/linux/hash.h
 include/linux/stringify.h
 lib/find_next_bit.c
+lib/hweight.c
 lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 67a03a825b3c..aa6a50447c32 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -232,12 +232,15 @@ LIB_H += ../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
 LIB_H += util/include/linux/bitmap.h
 LIB_H += ../include/linux/bitops.h
+LIB_H += ../include/asm-generic/bitops/arch_hweight.h
 LIB_H += ../include/asm-generic/bitops/atomic.h
+LIB_H += ../include/asm-generic/bitops/const_hweight.h
 LIB_H += ../include/asm-generic/bitops/find.h
 LIB_H += ../include/asm-generic/bitops/fls64.h
 LIB_H += ../include/asm-generic/bitops/fls.h
 LIB_H += ../include/asm-generic/bitops/__ffs.h
 LIB_H += ../include/asm-generic/bitops/__fls.h
+LIB_H += ../include/asm-generic/bitops/hweight.h
 LIB_H += ../include/asm-generic/bitops.h
 LIB_H += ../include/linux/compiler.h
 LIB_H += ../include/linux/log2.h
@@ -255,7 +258,6 @@ LIB_H += util/include/linux/linkage.h
 LIB_H += util/include/asm/asm-offsets.h
 LIB_H += ../include/asm/bug.h
 LIB_H += util/include/asm/byteorder.h
-LIB_H += util/include/asm/hweight.h
 LIB_H += util/include/asm/swab.h
 LIB_H += util/include/asm/system.h
 LIB_H += util/include/asm/uaccess.h
@@ -462,10 +464,12 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
-ifeq ($(RAW_ARCH),x86_64)
+ifeq ($(ARCH), x86)
+ifeq ($(IS_64_BIT), 1)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif
+endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
@@ -743,6 +747,9 @@ $(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)util/hweight.o: ../../lib/hweight.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
+
 $(OUTPUT)util/find_next_bit.o: ../lib/util/find_next_bit.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index 3bb50eac5542..0c370f81e002 100644
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -103,7 +103,7 @@ static Dwarf_Frame *get_eh_frame(Dwfl_Module *mod, Dwarf_Addr pc)
 		return NULL;
 	}
 
-	result = dwarf_cfi_addrframe(cfi, pc, &frame);
+	result = dwarf_cfi_addrframe(cfi, pc-bias, &frame);
 	if (result) {
 		pr_debug("%s(): %s\n", __func__, dwfl_errmsg(-1));
 		return NULL;
@@ -128,7 +128,7 @@ static Dwarf_Frame *get_dwarf_frame(Dwfl_Module *mod, Dwarf_Addr pc)
 		return NULL;
 	}
 
-	result = dwarf_cfi_addrframe(cfi, pc, &frame);
+	result = dwarf_cfi_addrframe(cfi, pc-bias, &frame);
 	if (result) {
 		pr_debug("%s(): %s\n", __func__, dwfl_errmsg(-1));
 		return NULL;
@@ -145,7 +145,7 @@ static Dwarf_Frame *get_dwarf_frame(Dwfl_Module *mod, Dwarf_Addr pc)
  *		yet used)
  *	-1 in case of errors
  */
-static int check_return_addr(struct dso *dso, Dwarf_Addr pc)
+static int check_return_addr(struct dso *dso, u64 map_start, Dwarf_Addr pc)
 {
 	int		rc = -1;
 	Dwfl		*dwfl;
@@ -155,6 +155,7 @@ static int check_return_addr(struct dso *dso, Dwarf_Addr pc)
 	Dwarf_Addr	start = pc;
 	Dwarf_Addr	end = pc;
 	bool		signalp;
+	const char	*exec_file = dso->long_name;
 
 	dwfl = dso->dwfl;
 
@@ -165,8 +166,10 @@ static int check_return_addr(struct dso *dso, Dwarf_Addr pc)
 			return -1;
 		}
 
-		if (dwfl_report_offline(dwfl, "", dso->long_name, -1) == NULL) {
-			pr_debug("dwfl_report_offline() failed %s\n",
+		mod = dwfl_report_elf(dwfl, exec_file, exec_file, -1,
+						map_start, false);
+		if (!mod) {
+			pr_debug("dwfl_report_elf() failed %s\n",
 						dwarf_errmsg(-1));
 			/*
 			 * We normally cache the DWARF debug info and never
@@ -256,10 +259,10 @@ int arch_skip_callchain_idx(struct thread *thread, struct ip_callchain *chain)
 		return skip_slot;
 	}
 
-	rc = check_return_addr(dso, ip);
+	rc = check_return_addr(dso, al.map->start, ip);
 
-	pr_debug("DSO %s, nr %" PRIx64 ", ip 0x%" PRIx64 "rc %d\n",
-				dso->long_name, chain->nr, ip, rc);
+	pr_debug("[DSO %s, sym %s, ip 0x%" PRIx64 "] rc %d\n",
+				dso->long_name, al.sym->name, ip, rc);
 
 	if (rc == 0) {
 		/*
diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 07a8d7646a15..005cc283790c 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -19,12 +19,12 @@
 #include <stdlib.h>
 #include <signal.h>
 #include <sys/wait.h>
-#include <linux/unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <assert.h>
 #include <sys/time.h>
 #include <sys/types.h>
+#include <sys/syscall.h>
 
 #include <pthread.h>
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 961cea183a83..616f0fcb4701 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -66,7 +66,6 @@
 #include <sys/utsname.h>
 #include <sys/mman.h>
 
-#include <linux/unistd.h>
 #include <linux/types.h>
 
 static volatile int done;
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d4b039fe1ed..648e31ff4021 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -20,7 +20,7 @@ NO_PERF_REGS := 1
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),x86)
-  ifeq (${IS_X86_64}, 1)
+  ifeq (${IS_64_BIT}, 1)
     CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
     ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
     LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
index 851cd0172a76..ff95a68741d1 100644
--- a/tools/perf/config/Makefile.arch
+++ b/tools/perf/config/Makefile.arch
@@ -1,7 +1,7 @@
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+RAW_ARCH := $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
                                   -e s/arm.*/arm/ -e s/sa110/arm/ \
                                   -e s/s390x/s390/ -e s/parisc64/parisc/ \
                                   -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
@@ -9,23 +9,23 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
                                   -e s/tile.*/tile/ )
 
 # Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-  override ARCH := x86
+ifeq ($(RAW_ARCH),i386)
+  ARCH ?= x86
 endif
 
-ifeq ($(ARCH),x86_64)
-  override ARCH := x86
-  IS_X86_64 := 0
-  ifeq (, $(findstring m32,$(CFLAGS)))
-    IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
-    RAW_ARCH := x86_64
+ifeq ($(RAW_ARCH),x86_64)
+  ARCH ?= x86
+
+  ifneq (, $(findstring m32,$(CFLAGS)))
+    RAW_ARCH := x86_32
   endif
 endif
 
-ifeq (${IS_X86_64}, 1)
+ARCH ?= $(RAW_ARCH)
+
+LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
+ifeq ($(LP64), 1)
   IS_64_BIT := 1
-else ifeq ($(ARCH),x86)
-  IS_64_BIT := 0
 else
-  IS_64_BIT := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
+  IS_64_BIT := 0
 endif
diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index a3b13d7dc1d4..6ef68165c9db 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -6,7 +6,6 @@
 #include <sys/syscall.h>
 #include <linux/types.h>
 #include <linux/perf_event.h>
-#include <asm/unistd.h>
 
 #if defined(__i386__)
 #define mb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index ab28cca2cb97..0bf06bec68c7 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -11,6 +11,9 @@
 #include "thread.h"
 #include "callchain.h"
 
+/* For bsearch. We try to unwind functions in shared object. */
+#include <stdlib.h>
+
 static int mmap_handler(struct perf_tool *tool __maybe_unused,
 			union perf_event *event,
 			struct perf_sample *sample __maybe_unused,
@@ -28,7 +31,7 @@ static int init_live_machine(struct machine *machine)
 						  mmap_handler, machine, true);
 }
 
-#define MAX_STACK 6
+#define MAX_STACK 8
 
 static int unwind_entry(struct unwind_entry *entry, void *arg)
 {
@@ -37,6 +40,8 @@ static int unwind_entry(struct unwind_entry *entry, void *arg)
 	static const char *funcs[MAX_STACK] = {
 		"test__arch_unwind_sample",
 		"unwind_thread",
+		"compare",
+		"bsearch",
 		"krava_3",
 		"krava_2",
 		"krava_1",
@@ -88,10 +93,37 @@ static int unwind_thread(struct thread *thread)
 	return err;
 }
 
+static int global_unwind_retval = -INT_MAX;
+
+__attribute__ ((noinline))
+static int compare(void *p1, void *p2)
+{
+	/* Any possible value should be 'thread' */
+	struct thread *thread = *(struct thread **)p1;
+
+	if (global_unwind_retval == -INT_MAX)
+		global_unwind_retval = unwind_thread(thread);
+
+	return p1 - p2;
+}
+
 __attribute__ ((noinline))
 static int krava_3(struct thread *thread)
 {
-	return unwind_thread(thread);
+	struct thread *array[2] = {thread, thread};
+	void *fp = &bsearch;
+	/*
+	 * make _bsearch a volatile function pointer to
+	 * prevent potential optimization, which may expand
+	 * bsearch and call compare directly from this function,
+	 * instead of libc shared object.
+	 */
+	void *(*volatile _bsearch)(void *, void *, size_t,
+			size_t, int (*)(void *, void *));
+
+	_bsearch = fp;
+	_bsearch(array, &thread, 2, sizeof(struct thread **), compare);
+	return global_unwind_retval;
 }
 
 __attribute__ ((noinline))
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 0784a9420528..cadbdc90a5cb 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -116,11 +116,6 @@ struct annotation {
 	struct annotated_source *src;
 };
 
-struct sannotation {
-	struct annotation annotation;
-	struct symbol	  symbol;
-};
-
 static inline struct sym_hist *annotation__histogram(struct annotation *notes, int idx)
 {
 	return (((void *)&notes->src->histograms) +
@@ -129,8 +124,7 @@ static inline struct sym_hist *annotation__histogram(struct annotation *notes, i
 
 static inline struct annotation *symbol__annotation(struct symbol *sym)
 {
-	struct sannotation *a = container_of(sym, struct sannotation, symbol);
-	return &a->annotation;
+	return (void *)sym - symbol_conf.priv_size;
 }
 
 int addr_map_symbol__inc_samples(struct addr_map_symbol *ams, int evidx);
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 5cf9e1b5989d..d04d770d90f6 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -71,7 +71,9 @@ extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2
 extern char *perf_pathdup(const char *fmt, ...)
 	__attribute__((format (printf, 1, 2)));
 
+#ifndef __UCLIBC__
 /* Matches the libc/libbsd function attribute so we declare this unconditionally: */
 extern size_t strlcpy(char *dest, const char *src, size_t size);
+#endif
 
 #endif /* __PERF_CACHE_H */
diff --git a/tools/perf/util/hweight.c b/tools/perf/util/hweight.c
deleted file mode 100644
index 5c1d0d099f0d..000000000000
--- a/tools/perf/util/hweight.c
+++ /dev/null
@@ -1,31 +0,0 @@
-#include <linux/bitops.h>
-
-/**
- * hweightN - returns the hamming weight of a N-bit word
- * @x: the word to weigh
- *
- * The Hamming Weight of a number is the total number of bits set in it.
- */
-
-unsigned int hweight32(unsigned int w)
-{
-	unsigned int res = w - ((w >> 1) & 0x55555555);
-	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
-	res = (res + (res >> 4)) & 0x0F0F0F0F;
-	res = res + (res >> 8);
-	return (res + (res >> 16)) & 0x000000FF;
-}
-
-unsigned long hweight64(__u64 w)
-{
-#if BITS_PER_LONG == 32
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
-#elif BITS_PER_LONG == 64
-	__u64 res = w - ((w >> 1) & 0x5555555555555555ul);
-	res = (res & 0x3333333333333333ul) + ((res >> 2) & 0x3333333333333333ul);
-	res = (res + (res >> 4)) & 0x0F0F0F0F0F0F0F0Ful;
-	res = res + (res >> 8);
-	res = res + (res >> 16);
-	return (res + (res >> 32)) & 0x00000000000000FFul;
-#endif
-}
diff --git a/tools/perf/util/include/asm/hweight.h b/tools/perf/util/include/asm/hweight.h
deleted file mode 100644
index 36cf26d434a5..000000000000
--- a/tools/perf/util/include/asm/hweight.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef PERF_HWEIGHT_H
-#define PERF_HWEIGHT_H
-
-#include <linux/types.h>
-unsigned int hweight32(unsigned int w);
-unsigned long hweight64(__u64 w);
-
-#endif /* PERF_HWEIGHT_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 94de3e48b490..1bca3a9f2b16 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -389,7 +389,6 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &machine->threads);
-		machine->last_match = th;
 
 		/*
 		 * We have to initialize map_groups separately
@@ -400,9 +399,12 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 		 * leader and that would screwed the rb tree.
 		 */
 		if (thread__init_map_groups(th, machine)) {
+			rb_erase(&th->rb_node, &machine->threads);
 			thread__delete(th);
 			return NULL;
 		}
+
+		machine->last_match = th;
 	}
 
 	return th;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7f9b8632e433..94a717bf007d 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2052,9 +2052,11 @@ static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
 	pr_debug("Writing event: %s\n", buf);
 	if (!probe_event_dry_run) {
 		ret = write(fd, buf, strlen(buf));
-		if (ret <= 0)
+		if (ret <= 0) {
+			ret = -errno;
 			pr_warning("Failed to write event: %s\n",
 				   strerror_r(errno, sbuf, sizeof(sbuf)));
+		}
 	}
 	free(buf);
 	return ret;
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 16a475a7d492..6c6a6953fa93 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -10,7 +10,7 @@ util/ctype.c
 util/evlist.c
 util/evsel.c
 util/cpumap.c
-util/hweight.c
+../../lib/hweight.c
 util/thread_map.c
 util/util.c
 util/xyarray.c
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 371219a6daf1..6edf535f65c2 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -185,6 +185,28 @@ static u64 elf_section_offset(int fd, const char *name)
 	return offset;
 }
 
+#ifndef NO_LIBUNWIND_DEBUG_FRAME
+static int elf_is_exec(int fd, const char *name)
+{
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	int retval = 0;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		return 0;
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		goto out;
+
+	retval = (ehdr.e_type == ET_EXEC);
+
+out:
+	elf_end(elf);
+	pr_debug("unwind: elf_is_exec(%s): %d\n", name, retval);
+	return retval;
+}
+#endif
+
 struct table_entry {
 	u32 start_ip_offset;
 	u32 fde_offset;
@@ -322,8 +344,12 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
 #ifndef NO_LIBUNWIND_DEBUG_FRAME
 	/* Check the .debug_frame section for unwinding info */
 	if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
+		int fd = dso__data_fd(map->dso, ui->machine);
+		int is_exec = elf_is_exec(fd, map->dso->name);
+		unw_word_t base = is_exec ? 0 : map->start;
+
 		memset(&di, 0, sizeof(di));
-		if (dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
+		if (dwarf_find_debug_frame(0, &di, ip, base, map->dso->name,
 					   map->start, map->end))
 			return dwarf_search_unwind_table(as, ip, &di, pi,
 							 need_unwind_info, arg);
