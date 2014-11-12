Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaKLWx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:53:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:5516 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaKLWxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:53:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,371,1413270000"; 
   d="scan'208";a="621481397"
Subject: [PATCH] x86: remove arbitrary instruction size limit in instruction decoder
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        jkenisto@us.ibm.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
From: Dave Hansen <dave@sr71.net>
Date: Wed, 12 Nov 2014 14:53:52 -0800
Message-Id: <20141112225352.D49917A8@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

The current x86 instruction decoder steps along through the
instruction stream but always ensures that it never steps farther
than the largest possible instruction size (MAX_INSN_SIZE).

The MPX code is now going to be doing some decoding of userspace
instructions.  We copy those from userspace in to the kernel and
they're obviously completely untrusted coming from userspace.  In
addition to the constraint that instructions can only be so long,
we also have to be aware of how long the buffer is that came in
from userspace.  This _looks_ to be similar to what the perf and
kprobes is doing, but it's unclear to me whether they are
affected.

We shouldn't simply error out when we get short copy_from_user*()
results from userspace (like intel_pmu_pebs_fixup_ip() does
currently).  It is perfectly valid to be executing an instruction
within MAX_INSN_SIZE bytes of an unreadable page. We should be
able to gracefully handle short reads in those cases.

This adds support to the decoder to record how long the buffer
being decoded is and to refuse to "validate" the instruction if
we would have gone over the end of the buffer to decode it.

The kprobes code probably needs to be looked at here a bit more
carefully.  This patch still respects the MAX_INSN_SIZE limit
there but the kprobes code does look like it might be able to
be a bit more strict than it currently is.

Note: the v10 version of the MPX patches I just posted depends
on this patch.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 b/arch/x86/include/asm/insn.h                |   10 ++++++----
 b/arch/x86/kernel/cpu/perf_event_intel_ds.c  |    9 ++++++---
 b/arch/x86/kernel/cpu/perf_event_intel_lbr.c |    2 +-
 b/arch/x86/kernel/kprobes/core.c             |    8 +++++---
 b/arch/x86/kernel/kprobes/opt.c              |    4 +++-
 b/arch/x86/kernel/uprobes.c                  |    2 +-
 b/arch/x86/lib/insn.c                        |    5 +++--
 b/arch/x86/tools/insn_sanity.c               |    2 +-
 b/arch/x86/tools/test_get_len.c              |    2 +-
 9 files changed, 27 insertions(+), 17 deletions(-)

diff -puN arch/x86/include/asm/insn.h~x86-insn-decoder-remove-arbitrary-limit arch/x86/include/asm/insn.h
--- a/arch/x86/include/asm/insn.h~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.952753062 -0800
+++ b/arch/x86/include/asm/insn.h	2014-11-12 12:45:52.969753829 -0800
@@ -65,6 +65,7 @@ struct insn {
 	unsigned char x86_64;
 
 	const insn_byte_t *kaddr;	/* kernel address of insn to analyze */
+	const insn_byte_t *end_kaddr;	/* kernel address of last insn in buffer */
 	const insn_byte_t *next_byte;
 };
 
@@ -96,7 +97,7 @@ struct insn {
 #define X86_VEX_P(vex)	((vex) & 0x03)		/* VEX3 Byte2, VEX2 Byte1 */
 #define X86_VEX_M_MAX	0x1f			/* VEX3.M Maximum value */
 
-extern void insn_init(struct insn *insn, const void *kaddr, int x86_64);
+extern void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64);
 extern void insn_get_prefixes(struct insn *insn);
 extern void insn_get_opcode(struct insn *insn);
 extern void insn_get_modrm(struct insn *insn);
@@ -115,12 +116,13 @@ static inline void insn_get_attribute(st
 extern int insn_rip_relative(struct insn *insn);
 
 /* Init insn for kernel text */
-static inline void kernel_insn_init(struct insn *insn, const void *kaddr)
+static inline void kernel_insn_init(struct insn *insn,
+				    const void *kaddr, int buf_len)
 {
 #ifdef CONFIG_X86_64
-	insn_init(insn, kaddr, 1);
+	insn_init(insn, kaddr, buf_len, 1);
 #else /* CONFIG_X86_32 */
-	insn_init(insn, kaddr, 0);
+	insn_init(insn, kaddr, buf_len, 0);
 #endif
 }
 
diff -puN arch/x86/kernel/cpu/perf_event_intel_ds.c~x86-insn-decoder-remove-arbitrary-limit arch/x86/kernel/cpu/perf_event_intel_ds.c
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.954753152 -0800
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c	2014-11-12 12:45:52.970753874 -0800
@@ -724,6 +724,7 @@ static int intel_pmu_pebs_fixup_ip(struc
 	unsigned long ip = regs->ip;
 	int is_64bit = 0;
 	void *kaddr;
+	int size;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -758,11 +759,12 @@ static int intel_pmu_pebs_fixup_ip(struc
 		return 1;
 	}
 
+	size = ip - to;
 	if (!kernel_ip(ip)) {
-		int size, bytes;
+		int bytes;
 		u8 *buf = this_cpu_read(insn_buffer);
 
-		size = ip - to; /* Must fit our buffer, see above */
+		/* 'size' must fit our buffer, see above */
 		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
 		if (bytes != 0)
 			return 0;
@@ -780,11 +782,12 @@ static int intel_pmu_pebs_fixup_ip(struc
 #ifdef CONFIG_X86_64
 		is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
 #endif
-		insn_init(&insn, kaddr, is_64bit);
+		insn_init(&insn, kaddr, size, is_64bit);
 		insn_get_length(&insn);
 
 		to += insn.length;
 		kaddr += insn.length;
+		size -= insn.length;
 	} while (to < ip);
 
 	if (to == ip) {
diff -puN arch/x86/kernel/cpu/perf_event_intel_lbr.c~x86-insn-decoder-remove-arbitrary-limit arch/x86/kernel/cpu/perf_event_intel_lbr.c
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.956753243 -0800
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c	2014-11-12 12:45:52.970753874 -0800
@@ -518,7 +518,7 @@ static int branch_type(unsigned long fro
 #ifdef CONFIG_X86_64
 	is64 = kernel_ip((unsigned long)addr) || !test_thread_flag(TIF_IA32);
 #endif
-	insn_init(&insn, addr, is64);
+	insn_init(&insn, addr, size, is64);
 	insn_get_opcode(&insn);
 
 	switch (insn.opcode.bytes[0]) {
diff -puN arch/x86/kernel/kprobes/core.c~x86-insn-decoder-remove-arbitrary-limit arch/x86/kernel/kprobes/core.c
--- a/arch/x86/kernel/kprobes/core.c~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.957753288 -0800
+++ b/arch/x86/kernel/kprobes/core.c	2014-11-12 12:45:52.970753874 -0800
@@ -285,7 +285,7 @@ static int can_probe(unsigned long paddr
 		 * normally used, we just go through if there is no kprobe.
 		 */
 		__addr = recover_probed_instruction(buf, addr);
-		kernel_insn_init(&insn, (void *)__addr);
+		kernel_insn_init(&insn, (void *)__addr, MAX_INSN_SIZE);
 		insn_get_length(&insn);
 
 		/*
@@ -330,8 +330,10 @@ int __copy_instruction(u8 *dest, u8 *src
 {
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
+	unsigned long recovered_insn =
+		recover_probed_instruction(buf, (unsigned long)src);
 
-	kernel_insn_init(&insn, (void *)recover_probed_instruction(buf, (unsigned long)src));
+	kernel_insn_init(&insn, (void *)recovered_insn, MAX_INSN_SIZE);
 	insn_get_length(&insn);
 	/* Another subsystem puts a breakpoint, failed to recover */
 	if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
@@ -342,7 +344,7 @@ int __copy_instruction(u8 *dest, u8 *src
 	if (insn_rip_relative(&insn)) {
 		s64 newdisp;
 		u8 *disp;
-		kernel_insn_init(&insn, dest);
+		kernel_insn_init(&insn, dest, insn.length);
 		insn_get_displacement(&insn);
 		/*
 		 * The copied instruction uses the %rip-relative addressing
diff -puN arch/x86/kernel/kprobes/opt.c~x86-insn-decoder-remove-arbitrary-limit arch/x86/kernel/kprobes/opt.c
--- a/arch/x86/kernel/kprobes/opt.c~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.959753378 -0800
+++ b/arch/x86/kernel/kprobes/opt.c	2014-11-12 12:45:52.971753919 -0800
@@ -251,13 +251,15 @@ static int can_optimize(unsigned long pa
 	/* Decode instructions */
 	addr = paddr - offset;
 	while (addr < paddr - offset + size) { /* Decode until function end */
+		unsigned long recovered_insn;
 		if (search_exception_tables(addr))
 			/*
 			 * Since some fixup code will jumps into this function,
 			 * we can't optimize kprobe in this function.
 			 */
 			return 0;
-		kernel_insn_init(&insn, (void *)recover_probed_instruction(buf, addr));
+		recovered_insn = recover_probed_instruction(buf, addr);
+		kernel_insn_init(&insn, (void *)recovered_insn, MAX_INSN_SIZE);
 		insn_get_length(&insn);
 		/* Another subsystem puts a breakpoint */
 		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
diff -puN arch/x86/kernel/uprobes.c~x86-insn-decoder-remove-arbitrary-limit arch/x86/kernel/uprobes.c
--- a/arch/x86/kernel/uprobes.c~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.961753468 -0800
+++ b/arch/x86/kernel/uprobes.c	2014-11-12 12:45:52.971753919 -0800
@@ -219,7 +219,7 @@ static int uprobe_init_insn(struct arch_
 {
 	u32 volatile *good_insns;
 
-	insn_init(insn, auprobe->insn, x86_64);
+	insn_init(insn, auprobe->insn, sizeof(auprobe->insn), x86_64);
 	/* has the side-effect of processing the entire instruction */
 	insn_get_length(insn);
 	if (WARN_ON_ONCE(!insn_complete(insn)))
diff -puN arch/x86/lib/insn.c~x86-insn-decoder-remove-arbitrary-limit arch/x86/lib/insn.c
--- a/arch/x86/lib/insn.c~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.962753513 -0800
+++ b/arch/x86/lib/insn.c	2014-11-12 12:45:52.972753964 -0800
@@ -28,7 +28,7 @@
 
 /* Verify next sizeof(t) bytes can be on the same instruction */
 #define validate_next(t, insn, n)	\
-	((insn)->next_byte + sizeof(t) + n - (insn)->kaddr <= MAX_INSN_SIZE)
+	((insn)->next_byte + sizeof(t) + n < (insn)->end_kaddr)
 
 #define __get_next(t, insn)	\
 	({ t r = *(t*)insn->next_byte; insn->next_byte += sizeof(t); r; })
@@ -50,10 +50,11 @@
  * @kaddr:	address (in kernel memory) of instruction (or copy thereof)
  * @x86_64:	!0 for 64-bit kernel or 64-bit app
  */
-void insn_init(struct insn *insn, const void *kaddr, int x86_64)
+void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64)
 {
 	memset(insn, 0, sizeof(*insn));
 	insn->kaddr = kaddr;
+	insn->end_kaddr = kaddr + buf_len;
 	insn->next_byte = kaddr;
 	insn->x86_64 = x86_64 ? 1 : 0;
 	insn->opnd_bytes = 4;
diff -puN arch/x86/tools/insn_sanity.c~x86-insn-decoder-remove-arbitrary-limit arch/x86/tools/insn_sanity.c
--- a/arch/x86/tools/insn_sanity.c~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.964753604 -0800
+++ b/arch/x86/tools/insn_sanity.c	2014-11-12 12:45:52.972753964 -0800
@@ -254,7 +254,7 @@ int main(int argc, char **argv)
 			continue;
 
 		/* Decode an instruction */
-		insn_init(&insn, insn_buf, x86_64);
+		insn_init(&insn, insn_buf, sizeof(insn_buf), x86_64);
 		insn_get_length(&insn);
 
 		if (insn.next_byte <= insn.kaddr ||
diff -puN arch/x86/tools/test_get_len.c~x86-insn-decoder-remove-arbitrary-limit arch/x86/tools/test_get_len.c
--- a/arch/x86/tools/test_get_len.c~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.966753694 -0800
+++ b/arch/x86/tools/test_get_len.c	2014-11-12 12:45:52.972753964 -0800
@@ -149,7 +149,7 @@ int main(int argc, char **argv)
 				break;
 		}
 		/* Decode an instruction */
-		insn_init(&insn, insn_buf, x86_64);
+		insn_init(&insn, insn_buf, sizeof(insn_buf), x86_64);
 		insn_get_length(&insn);
 		if (insn.length != nb) {
 			warnings++;
_
