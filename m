Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaBXT46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:56:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49141 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaBXT4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/12] perf tools: Add libdw DWARF post unwind support
Date: Mon, 24 Feb 2014 16:56:36 -0300
Message-Id: <1393271800-17505-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393271800-17505-1-git-send-email-acme@infradead.org>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding libdw DWARF post unwind support, which is part of
elfutils-devel/libdw-dev package from version 0.158.

The new code is contained in unwin-libdw.c object, and implements
unwind__get_entries unwind interface function.

New Makefile variable NO_LIBDW_DWARF_UNWIND was added to control its
compilation, and is marked as disabled now.  It's factored with the rest
of the Makefile unwind build code in the next patch.

Arch specific code was added for x86.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392825179-5228-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf                |  11 ++
 tools/perf/arch/x86/Makefile            |   3 +
 tools/perf/arch/x86/util/unwind-libdw.c |  51 ++++++++
 tools/perf/config/Makefile              |   1 +
 tools/perf/util/unwind-libdw.c          | 210 ++++++++++++++++++++++++++++++++
 tools/perf/util/unwind-libdw.h          |  21 ++++
 6 files changed, 297 insertions(+)
 create mode 100644 tools/perf/arch/x86/util/unwind-libdw.c
 create mode 100644 tools/perf/util/unwind-libdw.c
 create mode 100644 tools/perf/util/unwind-libdw.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index bde91f8307ff..2dff0b8ed611 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -57,6 +57,12 @@ include config/utilities.mak
 # Define NO_LIBAUDIT if you do not want libaudit support
 #
 # Define NO_LIBBIONIC if you do not want bionic support
+#
+# Define NO_LIBDW_DWARF_UNWIND if you do not want libdw support
+# for dwarf backtrace post unwind.
+
+# temporarily disabled
+NO_LIBDW_DWARF_UNWIND := 1
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
@@ -478,6 +484,11 @@ ifndef NO_DWARF
 endif # NO_DWARF
 endif # NO_LIBELF
 
+ifndef NO_LIBDW_DWARF_UNWIND
+  LIB_OBJS += $(OUTPUT)util/unwind-libdw.o
+  LIB_H += util/unwind-libdw.h
+endif
+
 ifndef NO_LIBUNWIND
   LIB_OBJS += $(OUTPUT)util/unwind-libunwind.o
 endif
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 4fa9be983ad1..37c4652cc48a 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -7,6 +7,9 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
+ifndef NO_LIBDW_DWARF_UNWIND
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libdw.o
+endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
 LIB_H += arch/$(ARCH)/util/tsc.h
diff --git a/tools/perf/arch/x86/util/unwind-libdw.c b/tools/perf/arch/x86/util/unwind-libdw.c
new file mode 100644
index 000000000000..c4b72176ca83
--- /dev/null
+++ b/tools/perf/arch/x86/util/unwind-libdw.c
@@ -0,0 +1,51 @@
+#include <elfutils/libdwfl.h>
+#include "../../util/unwind-libdw.h"
+#include "../../util/perf_regs.h"
+
+bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
+{
+	struct unwind_info *ui = arg;
+	struct regs_dump *user_regs = &ui->sample->user_regs;
+	Dwarf_Word dwarf_regs[17];
+	unsigned nregs;
+
+#define REG(r) ({						\
+	Dwarf_Word val = 0;					\
+	perf_reg_value(&val, user_regs, PERF_REG_X86_##r);	\
+	val;							\
+})
+
+	if (user_regs->abi == PERF_SAMPLE_REGS_ABI_32) {
+		dwarf_regs[0] = REG(AX);
+		dwarf_regs[1] = REG(CX);
+		dwarf_regs[2] = REG(DX);
+		dwarf_regs[3] = REG(BX);
+		dwarf_regs[4] = REG(SP);
+		dwarf_regs[5] = REG(BP);
+		dwarf_regs[6] = REG(SI);
+		dwarf_regs[7] = REG(DI);
+		dwarf_regs[8] = REG(IP);
+		nregs = 9;
+	} else {
+		dwarf_regs[0]  = REG(AX);
+		dwarf_regs[1]  = REG(DX);
+		dwarf_regs[2]  = REG(CX);
+		dwarf_regs[3]  = REG(BX);
+		dwarf_regs[4]  = REG(SI);
+		dwarf_regs[5]  = REG(DI);
+		dwarf_regs[6]  = REG(BP);
+		dwarf_regs[7]  = REG(SP);
+		dwarf_regs[8]  = REG(R8);
+		dwarf_regs[9]  = REG(R9);
+		dwarf_regs[10] = REG(R10);
+		dwarf_regs[11] = REG(R11);
+		dwarf_regs[12] = REG(R12);
+		dwarf_regs[13] = REG(R13);
+		dwarf_regs[14] = REG(R14);
+		dwarf_regs[15] = REG(R15);
+		dwarf_regs[16] = REG(IP);
+		nregs = 17;
+	}
+
+	return dwfl_thread_state_registers(thread, 0, nregs, dwarf_regs);
+}
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 074fa618cc7b..c040d8618793 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -261,6 +261,7 @@ ifdef NO_LIBELF
   NO_DWARF := 1
   NO_DEMANGLE := 1
   NO_LIBUNWIND := 1
+  NO_LIBDW_DWARF_UNWIND := 1
 else
   ifeq ($(feature-libelf), 0)
     ifeq ($(feature-glibc), 1)
diff --git a/tools/perf/util/unwind-libdw.c b/tools/perf/util/unwind-libdw.c
new file mode 100644
index 000000000000..67db73ec3dab
--- /dev/null
+++ b/tools/perf/util/unwind-libdw.c
@@ -0,0 +1,210 @@
+#include <linux/compiler.h>
+#include <elfutils/libdw.h>
+#include <elfutils/libdwfl.h>
+#include <inttypes.h>
+#include <errno.h>
+#include "unwind.h"
+#include "unwind-libdw.h"
+#include "machine.h"
+#include "thread.h"
+#include "types.h"
+#include "event.h"
+#include "perf_regs.h"
+
+static char *debuginfo_path;
+
+static const Dwfl_Callbacks offline_callbacks = {
+	.find_debuginfo		= dwfl_standard_find_debuginfo,
+	.debuginfo_path		= &debuginfo_path,
+	.section_address	= dwfl_offline_section_address,
+};
+
+static int __report_module(struct addr_location *al, u64 ip,
+			    struct unwind_info *ui)
+{
+	Dwfl_Module *mod;
+	struct dso *dso = NULL;
+
+	thread__find_addr_location(ui->thread, ui->machine,
+				   PERF_RECORD_MISC_USER,
+				   MAP__FUNCTION, ip, al);
+
+	if (al->map)
+		dso = al->map->dso;
+
+	if (!dso)
+		return 0;
+
+	mod = dwfl_addrmodule(ui->dwfl, ip);
+	if (!mod)
+		mod = dwfl_report_elf(ui->dwfl, dso->short_name,
+				      dso->long_name, -1, al->map->start,
+				      false);
+
+	return mod && dwfl_addrmodule(ui->dwfl, ip) == mod ? 0 : -1;
+}
+
+static int report_module(u64 ip, struct unwind_info *ui)
+{
+	struct addr_location al;
+
+	return __report_module(&al, ip, ui);
+}
+
+static int entry(u64 ip, struct unwind_info *ui)
+
+{
+	struct unwind_entry e;
+	struct addr_location al;
+
+	if (__report_module(&al, ip, ui))
+		return -1;
+
+	e.ip  = ip;
+	e.map = al.map;
+	e.sym = al.sym;
+
+	pr_debug("unwind: %s:ip = 0x%" PRIx64 " (0x%" PRIx64 ")\n",
+		 al.sym ? al.sym->name : "''",
+		 ip,
+		 al.map ? al.map->map_ip(al.map, ip) : (u64) 0);
+
+	return ui->cb(&e, ui->arg);
+}
+
+static pid_t next_thread(Dwfl *dwfl, void *arg, void **thread_argp)
+{
+	/* We want only single thread to be processed. */
+	if (*thread_argp != NULL)
+		return 0;
+
+	*thread_argp = arg;
+	return dwfl_pid(dwfl);
+}
+
+static int access_dso_mem(struct unwind_info *ui, Dwarf_Addr addr,
+			  Dwarf_Word *data)
+{
+	struct addr_location al;
+	ssize_t size;
+
+	thread__find_addr_map(ui->thread, ui->machine, PERF_RECORD_MISC_USER,
+			      MAP__FUNCTION, addr, &al);
+	if (!al.map) {
+		pr_debug("unwind: no map for %lx\n", (unsigned long)addr);
+		return -1;
+	}
+
+	if (!al.map->dso)
+		return -1;
+
+	size = dso__data_read_addr(al.map->dso, al.map, ui->machine,
+				   addr, (u8 *) data, sizeof(*data));
+
+	return !(size == sizeof(*data));
+}
+
+static bool memory_read(Dwfl *dwfl __maybe_unused, Dwarf_Addr addr, Dwarf_Word *result,
+			void *arg)
+{
+	struct unwind_info *ui = arg;
+	struct stack_dump *stack = &ui->sample->user_stack;
+	u64 start, end;
+	int offset;
+	int ret;
+
+	ret = perf_reg_value(&start, &ui->sample->user_regs, PERF_REG_SP);
+	if (ret)
+		return false;
+
+	end = start + stack->size;
+
+	/* Check overflow. */
+	if (addr + sizeof(Dwarf_Word) < addr)
+		return false;
+
+	if (addr < start || addr + sizeof(Dwarf_Word) > end) {
+		ret = access_dso_mem(ui, addr, result);
+		if (ret) {
+			pr_debug("unwind: access_mem 0x%" PRIx64 " not inside range"
+				 " 0x%" PRIx64 "-0x%" PRIx64 "\n",
+				addr, start, end);
+			return false;
+		}
+		return true;
+	}
+
+	offset  = addr - start;
+	*result = *(Dwarf_Word *)&stack->data[offset];
+	pr_debug("unwind: access_mem addr 0x%" PRIx64 ", val %lx, offset %d\n",
+		 addr, (unsigned long)*result, offset);
+	return true;
+}
+
+static const Dwfl_Thread_Callbacks callbacks = {
+	.next_thread		= next_thread,
+	.memory_read		= memory_read,
+	.set_initial_registers	= libdw__arch_set_initial_registers,
+};
+
+static int
+frame_callback(Dwfl_Frame *state, void *arg)
+{
+	struct unwind_info *ui = arg;
+	Dwarf_Addr pc;
+
+	if (!dwfl_frame_pc(state, &pc, NULL)) {
+		pr_err("%s", dwfl_errmsg(-1));
+		return DWARF_CB_ABORT;
+	}
+
+	return entry(pc, ui) || !(--ui->max_stack) ?
+	       DWARF_CB_ABORT : DWARF_CB_OK;
+}
+
+int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
+			struct machine *machine, struct thread *thread,
+			struct perf_sample *data,
+			int max_stack)
+{
+	struct unwind_info ui = {
+		.sample		= data,
+		.thread		= thread,
+		.machine	= machine,
+		.cb		= cb,
+		.arg		= arg,
+		.max_stack	= max_stack,
+	};
+	Dwarf_Word ip;
+	int err = -EINVAL;
+
+	if (!data->user_regs.regs)
+		return -EINVAL;
+
+	ui.dwfl = dwfl_begin(&offline_callbacks);
+	if (!ui.dwfl)
+		goto out;
+
+	err = perf_reg_value(&ip, &data->user_regs, PERF_REG_IP);
+	if (err)
+		goto out;
+
+	err = report_module(ip, &ui);
+	if (err)
+		goto out;
+
+	if (!dwfl_attach_state(ui.dwfl, EM_NONE, thread->tid, &callbacks, &ui))
+		goto out;
+
+	err = dwfl_getthread_frames(ui.dwfl, thread->tid, frame_callback, &ui);
+
+	if (err && !ui.max_stack)
+		err = 0;
+
+ out:
+	if (err)
+		pr_debug("unwind: failed with '%s'\n", dwfl_errmsg(-1));
+
+	dwfl_end(ui.dwfl);
+	return 0;
+}
diff --git a/tools/perf/util/unwind-libdw.h b/tools/perf/util/unwind-libdw.h
new file mode 100644
index 000000000000..417a1426f3ad
--- /dev/null
+++ b/tools/perf/util/unwind-libdw.h
@@ -0,0 +1,21 @@
+#ifndef __PERF_UNWIND_LIBDW_H
+#define __PERF_UNWIND_LIBDW_H
+
+#include <elfutils/libdwfl.h>
+#include "event.h"
+#include "thread.h"
+#include "unwind.h"
+
+bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg);
+
+struct unwind_info {
+	Dwfl			*dwfl;
+	struct perf_sample      *sample;
+	struct machine          *machine;
+	struct thread           *thread;
+	unwind_entry_cb_t	cb;
+	void			*arg;
+	int			max_stack;
+};
+
+#endif /* __PERF_UNWIND_LIBDW_H */
-- 
1.8.1.4

