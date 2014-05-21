Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaEUB1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 21:27:03 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:50762 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaEUB1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 21:27:00 -0400
Date: Tue, 20 May 2014 18:26:44 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Maynard Johnson <mpjohn@us.ibm.com>, Ulrich.Weigand@de.ibm.com,
        Anton Blanchard <anton@au1.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au
Subject: [PATCH 1/1] powerpc/perf: Adjust callchain based on DWARF debug
Message-ID: <20140521012644.GA2890@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052101-9332-0000-0000-000000DA11E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc/perf: Adjust callchain based on DWARF debug info

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
Acked-by: Maynard Johnson <maynard@us.ibm.com>
---

  Changelog[v2]:
  	- Add missing dwfl_end()
	- Fix merge conflicts due to some unwind code

 tools/perf/arch/powerpc/Makefile                |    1 +
 tools/perf/arch/powerpc/util/adjust-callchain.c |  282 +++++++++++++++++++++++
 tools/perf/config/Makefile                      |    4 +
 tools/perf/util/callchain.h                     |   12 +
 tools/perf/util/machine.c                       |   16 +-
 5 files changed, 313 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/arch/powerpc/util/adjust-callchain.c

diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 744e629..512cc8d 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -3,3 +3,4 @@ PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/adjust-callchain.o
diff --git a/tools/perf/arch/powerpc/util/adjust-callchain.c b/tools/perf/arch/powerpc/util/adjust-callchain.c
new file mode 100644
index 0000000..8f9377b
--- /dev/null
+++ b/tools/perf/arch/powerpc/util/adjust-callchain.c
@@ -0,0 +1,282 @@
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
+ *
+ * TODO:
+ *	Rather than returning an index into the callchain and have the
+ *	caller skip that entry, we could modify the callchain in-place
+ *	by putting a PERF_CONTEXT_IGNORE marker in the affected entry.
+ *
+ *	But @chain points to read-only mmap, so the caller needs to
+ *	duplicate the callchain to modify in-place - something like:
+ *
+ *		new_callchain = arch_duplicate_callchain();
+ *		arch_adjust_callchain(new_callchain);
+ *		...
+ *		arch_free_callchain(new_callchain);
+ *
+ *	Since we only expect to adjust <= 1 entry for now, just return
+ *	the index.
+ */
+int arch_adjust_callchain(struct machine *machine, struct thread *thread,
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
index 729bbdf..464e9d9 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -48,6 +48,10 @@ ifneq ($(ARCH),$(filter $(ARCH),x86 arm))
   NO_LIBDW_DWARF_UNWIND := 1
 endif
 
+ifeq ($(ARCH),powerpc)
+  CFLAGS += -DHAVE_ADJUST_CALLCHAIN
+endif
+
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index bde2b0c..3e3848d 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -165,4 +165,16 @@ int hist_entry__append_callchain(struct hist_entry *he, struct perf_sample *samp
 
 extern const char record_callchain_help[];
 int parse_callchain_report_opt(const char *arg);
+
+#ifdef HAVE_ADJUST_CALLCHAIN
+extern int arch_adjust_callchain(struct machine *machine,
+			struct thread *thread, struct ip_callchain *chain);
+#else
+static inline int arch_adjust_callchain(struct machine *machine,
+			struct thread *thread, struct ip_callchain *chain)
+{
+	return -1;
+}
+#endif
+
 #endif	/* __PERF_CALLCHAIN_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 7409ac8..b648162 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1290,6 +1290,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	int chain_nr = min(max_stack, (int)chain->nr);
 	int i;
 	int err;
+	int skip_slot;
 
 	callchain_cursor_reset(&callchain_cursor);
 
@@ -1298,14 +1299,25 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		return 0;
 	}
 
+	/*
+	 * Based on DWARF debug information, some architectures skip
+	 * some of the callchain entries saved by the kernel.
+	 */
+	skip_slot = arch_adjust_callchain(machine, thread, chain);
+
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
 		struct addr_location al;
 
-		if (callchain_param.order == ORDER_CALLEE)
+		if (callchain_param.order == ORDER_CALLEE) {
+			if (i == skip_slot)
+				continue;
 			ip = chain->ips[i];
-		else
+		} else {
+			if ((int)(chain->nr - i - 1) == skip_slot)
+				continue;
 			ip = chain->ips[chain->nr - i - 1];
+		}
 
 		if (ip >= PERF_CONTEXT_MAX) {
 			switch (ip) {
-- 
1.7.9.5

