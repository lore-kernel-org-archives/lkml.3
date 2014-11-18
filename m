Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaKRAFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:05:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48955 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKRAFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:05:13 -0500
Date: Mon, 17 Nov 2014 16:04:34 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-6ba48ff46f764414f979d2eacb23c4e6296bcc95@git.kernel.org>
Cc: anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, srikar@linux.vnet.ibm.com, ananth@in.ibm.com,
        jkenisto@us.ibm.com, tglx@linutronix.de, paulus@samba.org,
        davem@davemloft.net, dave.hansen@linux.intel.com,
        a.p.zijlstra@chello.nl, acme@kernel.org, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com
Reply-To: acme@kernel.org, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, mingo@kernel.org, tglx@linutronix.de,
        ananth@in.ibm.com, jkenisto@us.ibm.com, davem@davemloft.net,
        dave.hansen@linux.intel.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, srikar@linux.vnet.ibm.com,
        anil.s.keshavamurthy@intel.com
In-Reply-To: <20141114153957.E6B01535@viggo.jf.intel.com>
References: <20141114153957.E6B01535@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86:
  Remove arbitrary instruction size limit in instruction decoder
Git-Commit-ID: 6ba48ff46f764414f979d2eacb23c4e6296bcc95
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ba48ff46f764414f979d2eacb23c4e6296bcc95
Gitweb:     http://git.kernel.org/tip/6ba48ff46f764414f979d2eacb23c4e6296bcc95
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Fri, 14 Nov 2014 07:39:57 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 00:58:52 +0100

x86: Remove arbitrary instruction size limit in instruction decoder

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

The whole reason we need this is that it is perfectly valid to be
executing an instruction within MAX_INSN_SIZE bytes of an
unreadable page. We should be able to gracefully handle short
reads in those cases.

This adds support to the decoder to record how long the buffer
being decoded is and to refuse to "validate" the instruction if
we would have gone over the end of the buffer to decode it.

The kprobes code probably needs to be looked at here a bit more
carefully.  This patch still respects the MAX_INSN_SIZE limit
there but the kprobes code does look like it might be able to
be a bit more strict than it currently is.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Jim Keniston <jkenisto@us.ibm.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: x86@kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20141114153957.E6B01535@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/insn.h                | 10 ++++++----
 arch/x86/kernel/cpu/perf_event_intel_ds.c  | 17 ++++++++++++++---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 25 +++++++++++++++++++------
 arch/x86/kernel/kprobes/core.c             |  8 +++++---
 arch/x86/kernel/kprobes/opt.c              |  4 +++-
 arch/x86/kernel/uprobes.c                  |  2 +-
 arch/x86/lib/insn.c                        |  5 +++--
 arch/x86/tools/insn_sanity.c               |  2 +-
 arch/x86/tools/test_get_len.c              |  2 +-
 9 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 48eb30a..47f29b1 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
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
@@ -115,12 +116,13 @@ static inline void insn_get_attribute(struct insn *insn)
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
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 46211bc..6a94277 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -724,6 +724,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	unsigned long ip = regs->ip;
 	int is_64bit = 0;
 	void *kaddr;
+	int size;
 
 	/*
 	 * We don't need to fixup if the PEBS assist is fault like
@@ -758,11 +759,12 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
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
@@ -780,11 +782,20 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 #ifdef CONFIG_X86_64
 		is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
 #endif
-		insn_init(&insn, kaddr, is_64bit);
+		insn_init(&insn, kaddr, size, is_64bit);
 		insn_get_length(&insn);
+		/*
+		 * Make sure there was not a problem decoding the
+		 * instruction and getting the length.  This is
+		 * doubly important because we have an infinite
+		 * loop if insn.length=0.
+		 */
+		if (!insn.length)
+			break;
 
 		to += insn.length;
 		kaddr += insn.length;
+		size -= insn.length;
 	} while (to < ip);
 
 	if (to == ip) {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 45fa730..58f1a94 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -465,7 +465,7 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 {
 	struct insn insn;
 	void *addr;
-	int bytes, size = MAX_INSN_SIZE;
+	int bytes_read, bytes_left;
 	int ret = X86_BR_NONE;
 	int ext, to_plm, from_plm;
 	u8 buf[MAX_INSN_SIZE];
@@ -493,8 +493,10 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 			return X86_BR_NONE;
 
 		/* may fail if text not present */
-		bytes = copy_from_user_nmi(buf, (void __user *)from, size);
-		if (bytes != 0)
+		bytes_left = copy_from_user_nmi(buf, (void __user *)from,
+						MAX_INSN_SIZE);
+		bytes_read = MAX_INSN_SIZE - bytes_left;
+		if (!bytes_read)
 			return X86_BR_NONE;
 
 		addr = buf;
@@ -505,10 +507,19 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 		 * Ensure we don't blindy read any address by validating it is
 		 * a known text address.
 		 */
-		if (kernel_text_address(from))
+		if (kernel_text_address(from)) {
 			addr = (void *)from;
-		else
+			/*
+			 * Assume we can get the maximum possible size
+			 * when grabbing kernel data.  This is not
+			 * _strictly_ true since we could possibly be
+			 * executing up next to a memory hole, but
+			 * it is very unlikely to be a problem.
+			 */
+			bytes_read = MAX_INSN_SIZE;
+		} else {
 			return X86_BR_NONE;
+		}
 	}
 
 	/*
@@ -518,8 +529,10 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 #ifdef CONFIG_X86_64
 	is64 = kernel_ip((unsigned long)addr) || !test_thread_flag(TIF_IA32);
 #endif
-	insn_init(&insn, addr, is64);
+	insn_init(&insn, addr, bytes_read, is64);
 	insn_get_opcode(&insn);
+	if (!insn.opcode.got)
+		return X86_BR_ABORT;
 
 	switch (insn.opcode.bytes[0]) {
 	case 0xf:
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 67e6d19..f7e3cd5 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -285,7 +285,7 @@ static int can_probe(unsigned long paddr)
 		 * normally used, we just go through if there is no kprobe.
 		 */
 		__addr = recover_probed_instruction(buf, addr);
-		kernel_insn_init(&insn, (void *)__addr);
+		kernel_insn_init(&insn, (void *)__addr, MAX_INSN_SIZE);
 		insn_get_length(&insn);
 
 		/*
@@ -330,8 +330,10 @@ int __copy_instruction(u8 *dest, u8 *src)
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
@@ -342,7 +344,7 @@ int __copy_instruction(u8 *dest, u8 *src)
 	if (insn_rip_relative(&insn)) {
 		s64 newdisp;
 		u8 *disp;
-		kernel_insn_init(&insn, dest);
+		kernel_insn_init(&insn, dest, insn.length);
 		insn_get_displacement(&insn);
 		/*
 		 * The copied instruction uses the %rip-relative addressing
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index f1314d0..7c523bb 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -251,13 +251,15 @@ static int can_optimize(unsigned long paddr)
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
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 5d1cbfe..8b96a94 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -219,7 +219,7 @@ static int uprobe_init_insn(struct arch_uprobe *auprobe, struct insn *insn, bool
 {
 	u32 volatile *good_insns;
 
-	insn_init(insn, auprobe->insn, x86_64);
+	insn_init(insn, auprobe->insn, sizeof(auprobe->insn), x86_64);
 	/* has the side-effect of processing the entire instruction */
 	insn_get_length(insn);
 	if (WARN_ON_ONCE(!insn_complete(insn)))
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 54fcffe..2480978 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
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
diff --git a/arch/x86/tools/insn_sanity.c b/arch/x86/tools/insn_sanity.c
index 872eb60..ba70ff2 100644
--- a/arch/x86/tools/insn_sanity.c
+++ b/arch/x86/tools/insn_sanity.c
@@ -254,7 +254,7 @@ int main(int argc, char **argv)
 			continue;
 
 		/* Decode an instruction */
-		insn_init(&insn, insn_buf, x86_64);
+		insn_init(&insn, insn_buf, sizeof(insn_buf), x86_64);
 		insn_get_length(&insn);
 
 		if (insn.next_byte <= insn.kaddr ||
diff --git a/arch/x86/tools/test_get_len.c b/arch/x86/tools/test_get_len.c
index 13403fc..56f04db 100644
--- a/arch/x86/tools/test_get_len.c
+++ b/arch/x86/tools/test_get_len.c
@@ -149,7 +149,7 @@ int main(int argc, char **argv)
 				break;
 		}
 		/* Decode an instruction */
-		insn_init(&insn, insn_buf, x86_64);
+		insn_init(&insn, insn_buf, sizeof(insn_buf), x86_64);
 		insn_get_length(&insn);
 		if (insn.length != nb) {
 			warnings++;
