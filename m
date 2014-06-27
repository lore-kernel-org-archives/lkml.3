Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaF0MVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaF0MVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:21:15 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/5] perf tools powerpc: Adjust callchain based on DWARF debug info
Date: Fri, 27 Jun 2014 14:20:58 +0200
Message-Id: <1403871661-18474-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
References: <1403871661-18474-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

When saving the callchain on Power, the kernel conservatively saves excess
entries in the callchain. A few of these entries are needed in some cases
but not others. We should use the DWARF debug information to determine
when the entries are  needed.

Eg: the value in the link register (LR) is needed only when it holds the
return address of a function. At other times it must be ignored.

If the unnecessary entries are not ignored, we end up with duplicate arcs
in the call-graphs.

Use the DWARF debug information to determine if any callchain entries
should be ignored when building call-graphs.

Callgraph before the patch:

    14.67%          2234  sprintft  libc-2.18.so       [.] __random
            |
            --- __random
               |
               |--61.12%-- __random
               |          |
               |          |--97.15%-- rand
               |          |          do_my_sprintf
               |          |          main
               |          |          generic_start_main.isra.0
               |          |          __libc_start_main
               |          |          0x0
               |          |
               |           --2.85%-- do_my_sprintf
               |                     main
               |                     generic_start_main.isra.0
               |                     __libc_start_main
               |                     0x0
               |
                --38.88%-- rand
                          |
                          |--94.01%-- rand
                          |          do_my_sprintf
                          |          main
                          |          generic_start_main.isra.0
                          |          __libc_start_main
                          |          0x0
                          |
                           --5.99%-- do_my_sprintf
                                     main
                                     generic_start_main.isra.0
                                     __libc_start_main
                                     0x0

Callgraph after the patch:

    14.67%          2234  sprintft  libc-2.18.so       [.] __random
            |
            --- __random
               |
               |--95.93%-- rand
               |          do_my_sprintf
               |          main
               |          generic_start_main.isra.0
               |          __libc_start_main
               |          0x0
               |
                --4.07%-- do_my_sprintf
                          main
                          generic_start_main.isra.0
                          __libc_start_main
                          0x0

TODO:	For split-debug info objects like glibc, we can only determine
	the call-frame-address only when both .eh_frame and .debug_info
	sections are available. We should be able to determin the CFA
	even without the .eh_frame section.

Fix suggested by Anton Blanchard.

Thanks to valuable input on DWARF debug information from Ulrich Weigand.

Reported-by: Maynard Johnson <maynard@us.ibm.com>
Tested-by: Maynard Johnson <maynard@us.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20140625154903.GA29607@us.ibm.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/arch/powerpc/Makefile                  |   1 +
 tools/perf/arch/powerpc/util/skip-callchain-idx.c | 266 ++++++++++++++++++++++
 tools/perf/config/Makefile                        |   4 +
 tools/perf/util/callchain.h                       |  13 ++
 tools/perf/util/machine.c                         |  18 +-
 5 files changed, 300 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/skip-callchain-idx.c

diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 744e629..b92219b 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -3,3 +3,4 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/skip-callchain-idx.o
diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
new file mode 100644
index 0000000..a7c23a4
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -0,0 +1,266 @@
+/*
+ * Use DWARF Debug information to skip unnecessary callchain entries.
+ *
+ * Copyright (C) 2014 Sukadev Bhattiprolu, IBM Corporation.
+ * Copyright (C) 2014 Ulrich Weigand, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <inttypes.h>
+#include <dwarf.h>
+#include <elfutils/libdwfl.h>
+
+#include "util/thread.h"
+#include "util/callchain.h"
+
+/*
+ * When saving the callchain on Power, the kernel conservatively saves
+ * excess entries in the callchain. A few of these entries are needed
+ * in some cases but not others. If the unnecessary entries are not
+ * ignored, we end up with duplicate arcs in the call-graphs. Use
+ * DWARF debug information to skip over any unnecessary callchain
+ * entries.
+ *
+ * See function header for arch_adjust_callchain() below for more details.
+ *
+ * The libdwfl code in this file is based on code from elfutils
+ * (libdwfl/argp-std.c, libdwfl/tests/addrcfi.c, etc).
+ */
+static char *debuginfo_path;
+
+static const Dwfl_Callbacks offline_callbacks = {
+	.debuginfo_path = &debuginfo_path,
+	.find_debuginfo = dwfl_standard_find_debuginfo,
+	.section_address = dwfl_offline_section_address,
+};
+
+
+/*
+ * Use the DWARF expression for the Call-frame-address and determine
+ * if return address is in LR and if a new frame was allocated.
+ */
+static int check_return_reg(int ra_regno, Dwarf_Frame *frame)
+{
+	Dwarf_Op ops_mem[2];
+	Dwarf_Op dummy;
+	Dwarf_Op *ops = &dummy;
+	size_t nops;
+	int result;
+
+	result = dwarf_frame_register(frame, ra_regno, ops_mem, &ops, &nops);
+	if (result < 0) {
+		pr_debug("dwarf_frame_register() %s\n", dwarf_errmsg(-1));
+		return -1;
+	}
+
+	/*
+	 * Check if return address is on the stack.
+	 */
+	if (nops != 0 || ops != NULL)
+		return 0;
+
+	/*
+	 * Return address is in LR. Check if a frame was allocated
+	 * but not-yet used.
+	 */
+	result = dwarf_frame_cfa(frame, &ops, &nops);
+	if (result < 0) {
+		pr_debug("dwarf_frame_cfa() returns %d, %s\n", result,
+					dwarf_errmsg(-1));
+		return -1;
+	}
+
+	/*
+	 * If call frame address is in r1, no new frame was allocated.
+	 */
+	if (nops == 1 && ops[0].atom == DW_OP_bregx && ops[0].number == 1 &&
+				ops[0].number2 == 0)
+		return 1;
+
+	/*
+	 * A new frame was allocated but has not yet been used.
+	 */
+	return 2;
+}
+
+/*
+ * Get the DWARF frame from the .eh_frame section.
+ */
+static Dwarf_Frame *get_eh_frame(Dwfl_Module *mod, Dwarf_Addr pc)
+{
+	int		result;
+	Dwarf_Addr	bias;
+	Dwarf_CFI	*cfi;
+	Dwarf_Frame	*frame;
+
+	cfi = dwfl_module_eh_cfi(mod, &bias);
+	if (!cfi) {
+		pr_debug("%s(): no CFI - %s\n", __func__, dwfl_errmsg(-1));
+		return NULL;
+	}
+
+	result = dwarf_cfi_addrframe(cfi, pc, &frame);
+	if (result) {
+		pr_debug("%s(): %s\n", __func__, dwfl_errmsg(-1));
+		return NULL;
+	}
+
+	return frame;
+}
+
+/*
+ * Get the DWARF frame from the .debug_frame section.
+ */
+static Dwarf_Frame *get_dwarf_frame(Dwfl_Module *mod, Dwarf_Addr pc)
+{
+	Dwarf_CFI       *cfi;
+	Dwarf_Addr      bias;
+	Dwarf_Frame     *frame;
+	int             result;
+
+	cfi = dwfl_module_dwarf_cfi(mod, &bias);
+	if (!cfi) {
+		pr_debug("%s(): no CFI - %s\n", __func__, dwfl_errmsg(-1));
+		return NULL;
+	}
+
+	result = dwarf_cfi_addrframe(cfi, pc, &frame);
+	if (result) {
+		pr_debug("%s(): %s\n", __func__, dwfl_errmsg(-1));
+		return NULL;
+	}
+
+	return frame;
+}
+
+/*
+ * Return:
+ *	0 if return address for the program counter @pc is on stack
+ *	1 if return address is in LR and no new stack frame was allocated
+ *	2 if return address is in LR and a new frame was allocated (but not
+ *		yet used)
+ *	-1 in case of errors
+ */
+static int check_return_addr(const char *exec_file, Dwarf_Addr pc)
+{
+	int		rc = -1;
+	Dwfl		*dwfl;
+	Dwfl_Module	*mod;
+	Dwarf_Frame	*frame;
+	int		ra_regno;
+	Dwarf_Addr	start = pc;
+	Dwarf_Addr	end = pc;
+	bool		signalp;
+
+	dwfl = dwfl_begin(&offline_callbacks);
+	if (!dwfl) {
+		pr_debug("dwfl_begin() failed: %s\n", dwarf_errmsg(-1));
+		return -1;
+	}
+
+	if (dwfl_report_offline(dwfl, "",  exec_file, -1) == NULL) {
+		pr_debug("dwfl_report_offline() failed %s\n", dwarf_errmsg(-1));
+		goto out;
+	}
+
+	mod = dwfl_addrmodule(dwfl, pc);
+	if (!mod) {
+		pr_debug("dwfl_addrmodule() failed, %s\n", dwarf_errmsg(-1));
+		goto out;
+	}
+
+	/*
+	 * To work with split debug info files (eg: glibc), check both
+	 * .eh_frame and .debug_frame sections of the ELF header.
+	 */
+	frame = get_eh_frame(mod, pc);
+	if (!frame) {
+		frame = get_dwarf_frame(mod, pc);
+		if (!frame)
+			goto out;
+	}
+
+	ra_regno = dwarf_frame_info(frame, &start, &end, &signalp);
+	if (ra_regno < 0) {
+		pr_debug("Return address register unavailable: %s\n",
+				dwarf_errmsg(-1));
+		goto out;
+	}
+
+	rc = check_return_reg(ra_regno, frame);
+
+out:
+	dwfl_end(dwfl);
+	return rc;
+}
+
+/*
+ * The callchain saved by the kernel always includes the link register (LR).
+ *
+ *	0:	PERF_CONTEXT_USER
+ *	1:	Program counter (Next instruction pointer)
+ *	2:	LR value
+ *	3:	Caller's caller
+ *	4:	...
+ *
+ * The value in LR is only needed when it holds a return address. If the
+ * return address is on the stack, we should ignore the LR value.
+ *
+ * Further, when the return address is in the LR, if a new frame was just
+ * allocated but the LR was not saved into it, then the LR contains the
+ * caller, slot 4: contains the caller's caller and the contents of slot 3:
+ * (chain->ips[3]) is undefined and must be ignored.
+ *
+ * Use DWARF debug information to determine if any entries need to be skipped.
+ *
+ * Return:
+ *	index:	of callchain entry that needs to be ignored (if any)
+ *	-1	if no entry needs to be ignored or in case of errors
+ */
+int arch_skip_callchain_idx(struct machine *machine, struct thread *thread,
+				struct ip_callchain *chain)
+{
+	struct addr_location al;
+	struct dso *dso = NULL;
+	int rc;
+	u64 ip;
+	u64 skip_slot = -1;
+
+	if (chain->nr < 3)
+		return skip_slot;
+
+	ip = chain->ips[2];
+
+	thread__find_addr_location(thread, machine, PERF_RECORD_MISC_USER,
+			MAP__FUNCTION, ip, &al);
+
+	if (al.map)
+		dso = al.map->dso;
+
+	if (!dso) {
+		pr_debug("%" PRIx64 " dso is NULL\n", ip);
+		return skip_slot;
+	}
+
+	rc = check_return_addr(dso->long_name, ip);
+
+	pr_debug("DSO %s, nr %" PRIx64 ", ip 0x%" PRIx64 "rc %d\n",
+				dso->long_name, chain->nr, ip, rc);
+
+	if (rc == 0) {
+		/*
+		 * Return address on stack. Ignore LR value in callchain
+		 */
+		skip_slot = 2;
+	} else if (rc == 2) {
+		/*
+		 * New frame allocated but return address still in LR.
+		 * Ignore the caller's caller entry in callchain.
+		 */
+		skip_slot = 3;
+	}
+	return skip_slot;
+}
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f30ac5e..346bdb6 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -48,6 +48,10 @@ ifneq ($(ARCH),$(filter $(ARCH),x86 arm))
   NO_LIBDW_DWARF_UNWIND := 1
 endif
 
+ifeq ($(ARCH),powerpc)
+  CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
+endif
+
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8f84423..da43619 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -176,4 +176,17 @@ static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
 	dest->first = src->curr;
 	dest->nr -= src->pos;
 }
+
+#ifdef HAVE_SKIP_CALLCHAIN_IDX
+extern int arch_skip_callchain_idx(struct machine *machine,
+			struct thread *thread, struct ip_callchain *chain);
+#else
+static inline int arch_skip_callchain_idx(struct machine *machine __maybe_unused,
+			struct thread *thread __maybe_unused,
+			struct ip_callchain *chain __maybe_unused)
+{
+	return -1;
+}
+#endif
+
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index c73e1fc..e9b943a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1281,7 +1281,9 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	u8 cpumode = PERF_RECORD_MISC_USER;
 	int chain_nr = min(max_stack, (int)chain->nr);
 	int i;
+	int j;
 	int err;
+	int skip_idx __maybe_unused;
 
 	callchain_cursor_reset(&callchain_cursor);
 
@@ -1290,14 +1292,26 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		return 0;
 	}
 
+	/*
+	 * Based on DWARF debug information, some architectures skip
+	 * a callchain entry saved by the kernel.
+	 */
+	skip_idx = arch_skip_callchain_idx(machine, thread, chain);
+
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
 		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
-			ip = chain->ips[i];
+			j = i;
 		else
-			ip = chain->ips[chain->nr - i - 1];
+			j = chain->nr - i - 1;
+
+#ifdef HAVE_SKIP_CALLCHAIN_IDX
+		if (j == skip_idx)
+			continue;
+#endif
+		ip = chain->ips[j];
 
 		if (ip >= PERF_CONTEXT_MAX) {
 			switch (ip) {
-- 
1.8.3.1

