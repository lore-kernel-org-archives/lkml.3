Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaFFDW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 23:22:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49196 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaFFDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 23:22:57 -0400
Date: Thu, 5 Jun 2014 20:22:32 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Anton Blanchard <anton@au1.ibm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Ulrich.Weigand@de.ibm.com, michael@ellerman.id.au,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2]: powerpc/perf: Adjust callchain based on DWARF debug
 info
Message-ID: <20140606032232.GB16600@us.ibm.com>
References: <20140606032109.GA16600@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606032109.GA16600@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060603-0928-0000-0000-00000273F5A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replace the arch_skip_callchain_idx() stub in Powerpc with code that
checks the DWARF debug information and identifies the callchain entry
to skip.

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
---
Changelog[v4]
	Move Powerpc-specific code into a separate patch

Changelog[v3]
        [Jiri Olsa] Rename function to arch_skip_callchain_idx() to be
                consistent with behavior.
        [Jiri Olsa] Add '__maybe_unused' tags for unused parameters.

Changelog[v2]:
        Add missing dwfl_end()
        Fix merge conflicts due to some unwind code

 tools/perf/arch/powerpc/util/skip-callchain-idx.c |  251 ++++++++++++++++++++-
 1 file changed, 246 insertions(+), 5 deletions(-)

diff --git a/tools/perf/arch/powerpc/util/skip-callchain-idx.c b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
index 7350c36..a7c23a4 100644
--- a/tools/perf/arch/powerpc/util/skip-callchain-idx.c
+++ b/tools/perf/arch/powerpc/util/skip-callchain-idx.c
@@ -16,10 +16,251 @@
 #include "util/thread.h"
 #include "util/callchain.h"
 
-/* Stub for now */
-int arch_skip_callchain_idx(struct machine *machine __maybe_unused,
-			    struct thread *thread __maybe_unused,
-			    struct ip_callchain *chain __maybe_unused)
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
 {
-	return -1;
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
 }
-- 
1.7.9.5

