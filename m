Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaEESYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:24:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaEESYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:24:21 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/2] uprobes: add comment with insn opcodes, mnemonics and why we dont support them
Date: Mon,  5 May 2014 20:24:06 +0200
Message-Id: <1399314247-7368-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After adding these, it's clear we have some awkward choices there.
Some valid instructions are prohibited from uprobing while
several invalid ones are allowed.

Hopefully future edits to the good-opcode tables will fix wrong bits
or explain why those bits are not wrong.

No actual code changes.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Jim Keniston <jkenisto@us.ibm.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c | 153 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 134 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index dbbf6cd..4c66a7c 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -63,6 +63,49 @@
  * Good-instruction tables for 32-bit apps.  This is non-const and volatile
  * to keep gcc from statically optimizing it out, as variable_test_bit makes
  * some versions of gcc to think only *(unsigned long*) is used.
+ *
+ * Prefixes. Most marked as "bad", but it doesn't matter, since insn decoder
+ * won't report *prefixes* as OPCODE1(insn).
+ * 0f - 2-byte opcode prefix
+ * 26,2e,36,3e - es:/cs:/ss:/ds:
+ * 64 - fs: (marked as "good", why?)
+ * 65 - gs: (marked as "good", why?)
+ * 66 - operand-size prefix
+ * 67 - address-size prefix
+ * f0 - lock prefix
+ * f2 - repnz    (marked as "good", why?)
+ * f3 - rep/repz (marked as "good", why?)
+ *
+ * Opcodes we'll probably never support:
+ * 6c-6f - ins,outs. SEGVs if used in userspace
+ * e4-e7 - in,out imm. SEGVs if used in userspace
+ * ec-ef - in,out acc. SEGVs if used in userspace
+ * cc - int3. SIGTRAP if used in userspace
+ * ce - into. Not used in userspace - no kernel support to make it useful. SEGVs
+ *	(why we support bound (62) then? it's similar, and similarly unused...)
+ * f1 - int1. SIGTRAP if used in userspace
+ * f4 - hlt. SEGVs if used in userspace
+ * fa - cli. SEGVs if used in userspace
+ * fb - sti. SEGVs if used in userspace
+ *
+ * Opcodes which need some work to be supported:
+ * 07,17,1f - pop es/ss/ds
+ *	Normally not used in userspace, but would execute if used.
+ *	Can cause GP or stack exception if tries to load wrong segment descriptor.
+ *	We hesitate to run them under single step since kernel's handling
+ *	of userspace single-stepping (TF flag) is fragile.
+ *	We can easily refuse to support push es/cs/ss/ds (06/0e/16/1e)
+ *	on the same grounds that they are never used.
+ * cd - int N.
+ *	Used by userspace for "int 80" syscall entry. (Other "int N"
+ *	cause GP -> SEGV since their IDT gates don't allow calls from CPL 3).
+ *	Not supported since kernel's handling of userspace single-stepping
+ *	(TF flag) is fragile.
+ * cf - iret. Normally not used in userspace. Doesn't SEGV unless arguments are bad
+ *
+ * Opcodes which can be enabled right away:
+ * 63 - arpl. This insn has no unusual exceptions (it's basically an arith op).
+ * d6 - salc. Undocumented "sign-extend carry flag to AL" insn
  */
 #if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
 static volatile u32 good_insns_32[256 / 32] = {
@@ -91,7 +134,55 @@ static volatile u32 good_insns_32[256 / 32] = {
 #define good_insns_32	NULL
 #endif
 
-/* Good-instruction tables for 64-bit apps */
+/* Good-instruction tables for 64-bit apps.
+ *
+ * Prefixes. Most marked as "bad", but it doesn't matter, since insn decoder
+ * won't report *prefixes* as OPCODE1(insn).
+ * 0f - 2-byte opcode prefix
+ * 26,2e,36,3e - es:/cs:/ss:/ds:
+ * 40-4f - rex prefixes
+ * 64 - fs: (marked as "good", why?)
+ * 65 - gs: (marked as "good", why?)
+ * 66 - operand-size prefix
+ * 67 - address-size prefix
+ * f0 - lock prefix
+ * f2 - repnz    (marked as "good", why?)
+ * f3 - rep/repz (marked as "good", why?)
+ *
+ * Genuinely invalid opcodes:
+ * 06,07 - formerly push/pop es
+ * 0e - formerly push cs
+ * 16,17 - formerly push/pop ss
+ * 1e,1f - formerly push/pop ds
+ * 27,2f,37,3f - formerly daa/das/aaa/aas
+ * 60,61 - formerly pusha/popa
+ * 62 - formerly bound. EVEX prefix for AVX512
+ * 82 - formerly redundant encoding of Group1
+ * 9a - formerly call seg:ofs (marked as "supported"???)
+ * c4,c5 - formerly les/lds. VEX prefixes for AVX
+ * ce - formerly into
+ * d4,d5 - formerly aam/aad
+ * d6 - formerly undocumented salc
+ * ea - formerly jmp seg:ofs (marked as "supported"???)
+ *
+ * Opcodes we'll probably never support:
+ * 6c-6f - ins,outs. SEGVs if used in userspace
+ * e4-e7 - in,out imm. SEGVs if used in userspace
+ * ec-ef - in,out acc. SEGVs if used in userspace
+ * cc - int3. SIGTRAP if used in userspace
+ * f1 - int1. SIGTRAP if used in userspace
+ * f4 - hlt. SEGVs if used in userspace
+ * fa - cli. SEGVs if used in userspace
+ * fb - sti. SEGVs if used in userspace
+ *
+ * Opcodes which need some work to be supported:
+ * cd - int N.
+ *	Used by userspace for "int 80" syscall entry. (Other "int N"
+ *	cause GP -> SEGV since their IDT gates don't allow calls from CPL 3).
+ *	Not supported since kernel's handling of userspace single-stepping
+ *	(TF flag) is fragile.
+ * cf - iret. Normally not used in userspace. Doesn't SEGV unless arguments are bad
+ */
 #if defined(CONFIG_X86_64)
 static volatile u32 good_insns_64[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
@@ -119,7 +210,48 @@ static volatile u32 good_insns_64[256 / 32] = {
 #define good_insns_64	NULL
 #endif
 
-/* Using this for both 64-bit and 32-bit apps */
+/* Using this for both 64-bit and 32-bit apps.
+ * Opcodes we don't support:
+ * 0f 00 - SLDT/STR/LLDT/LTR/VERR/VERW/-/- group. System insns
+ * 0f 01 - SGDT/SIDT/LGDT/LIDT/SMSW/-/LMSW/INVLPG group.
+ *	Also encodes tons of other system insns if mod=11.
+ *	Some are in fact non-system: xend, xtest, rdtscp, maybe more
+ * 0f 02 - lar (why? should be safe, it throws no exceptipons)
+ * 0f 03 - lsl (why? should be safe, it throws no exceptipons)
+ * 0f 04 - undefined
+ * 0f 05 - syscall
+ * 0f 06 - clts (CPL0 insn)
+ * 0f 07 - sysret
+ * 0f 08 - invd (CPL0 insn)
+ * 0f 09 - wbinvd (CPL0 insn)
+ * 0f 0a - undefined
+ * 0f 0b - ud1
+ * 0f 0c - undefined
+ * 0f 0d - prefetchFOO (amd prefetch insns)
+ * 0f 18 - prefetchBAR (intel prefetch insns)
+ * 0f 24 - mov from test regs (perhaps entire 20-27 area can be disabled (special reg ops))
+ * 0f 25 - undefined
+ * 0f 26 - mov to test regs
+ * 0f 27 - undefined
+ * 0f 30 - wrmsr (CPL0 insn)
+ * 0f 34 - sysenter
+ * 0f 35 - sysexit
+ * 0f 36 - undefined
+ * 0f 37 - getsec
+ * 0f 38-3f - 3-byte opcodes (why?? all look safe)
+ * 0f 78 - vmread
+ * 0f 79 - vmwrite
+ * 0f 7a - undefined
+ * 0f 7b - undefined
+ * 0f 7c - undefined
+ * 0f 7d - undefined
+ * 0f a6 - undefined
+ * 0f a7 - undefined
+ * 0f b8 - popcnt (why?? it's an ordinary ALU op)
+ * 0f d0 - undefined
+ * 0f f0 - lddqu (why?? it's an ordinary vector load op)
+ * 0f ff - undefined
+ */
 static volatile u32 good_2byte_insns[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 	/*      ----------------------------------------------         */
@@ -145,23 +277,6 @@ static volatile u32 good_2byte_insns[256 / 32] = {
 #undef W
 
 /*
- * opcodes we'll probably never support:
- *
- *  6c-6d, e4-e5, ec-ed - in
- *  6e-6f, e6-e7, ee-ef - out
- *  cc, cd - int3, int
- *  cf - iret
- *  d6 - illegal instruction
- *  f1 - int1/icebp
- *  f4 - hlt
- *  fa, fb - cli, sti
- *  0f - lar, lsl, syscall, clts, sysret, sysenter, sysexit, invd, wbinvd, ud2
- *
- * invalid opcodes in 64-bit mode:
- *
- *  06, 0e, 16, 1e, 27, 2f, 37, 3f, 60-62, 82, c4-c5, d4-d5
- *  63 - we support this opcode in x86_64 but not in i386.
- *
  * opcodes we may need to refine support for:
  *
  *  0f - 2-byte instructions: For many of these instructions, the validity
-- 
1.8.1.4

