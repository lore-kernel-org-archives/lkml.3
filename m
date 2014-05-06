Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbaEFPtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757603AbaEFPtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:49:20 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] uprobe: fix 2-byte opcode table
Date: Tue,  6 May 2014 17:49:07 +0200
Message-Id: <1399391347-5753-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabled probing of lar, lsl, popcnt, lddqu, prefetch insns
- should be safe, they throw no exceptions.

Enabled probing of 3-byte opcodes 0f 38-3f xx - these are
vector isns, so should be safe.

Enabled probing of many currently undefined 0f xx insns.
At the rate new vector instructions are getting added,
we don't want to constantly enable more bits.
We want to only occasionally *disable* ones which
for some reason can't be probed.
This includes 0f 24,26 opcodes, which are undefined
since Pentium. On 486, they were "mov to/from test register".

Fixed mnemonic of 0f 0b in the comment: ud1 -> ud2.

Explained more fully what 0f 78,79 opcodes are.

Explained what 0f ae opcode is. (It's unclear why we don't allow
probing it, but let's not change it for now).

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Jim Keniston <jkenisto@us.ibm.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c | 54 ++++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 05e32e6..7529e43 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -190,61 +190,43 @@ static volatile u32 good_insns_64[256 / 32] = {
  * 0f 01 - SGDT/SIDT/LGDT/LIDT/SMSW/-/LMSW/INVLPG group.
  *	Also encodes tons of other system insns if mod=11.
  *	Some are in fact non-system: xend, xtest, rdtscp, maybe more
- * 0f 02 - lar (why? should be safe, it throws no exceptipons)
- * 0f 03 - lsl (why? should be safe, it throws no exceptipons)
- * 0f 04 - undefined
  * 0f 05 - syscall
  * 0f 06 - clts (CPL0 insn)
  * 0f 07 - sysret
  * 0f 08 - invd (CPL0 insn)
  * 0f 09 - wbinvd (CPL0 insn)
- * 0f 0a - undefined
- * 0f 0b - ud1
- * 0f 0c - undefined
- * 0f 0d - prefetchFOO (amd prefetch insns)
- * 0f 18 - prefetchBAR (intel prefetch insns)
- * 0f 24 - mov from test regs (perhaps entire 20-27 area can be disabled (special reg ops))
- * 0f 25 - undefined
- * 0f 26 - mov to test regs
- * 0f 27 - undefined
- * 0f 30 - wrmsr (CPL0 insn)
+ * 0f 0b - ud2
+ * 0f 30 - wrmsr (CPL0 insn) (then why rdmsr is allowed, it's also CPL0 insn?)
  * 0f 34 - sysenter
  * 0f 35 - sysexit
- * 0f 36 - undefined
  * 0f 37 - getsec
- * 0f 38-3f - 3-byte opcodes (why?? all look safe)
- * 0f 78 - vmread
- * 0f 79 - vmwrite
- * 0f 7a - undefined
- * 0f 7b - undefined
- * 0f 7c - undefined
- * 0f 7d - undefined
- * 0f a6 - undefined
- * 0f a7 - undefined
- * 0f b8 - popcnt (why?? it's an ordinary ALU op)
- * 0f d0 - undefined
- * 0f f0 - lddqu (why?? it's an ordinary vector load op)
- * 0f ff - undefined
+ * 0f 78 - vmread (Intel VMX. CPL0 insn)
+ * 0f 79 - vmwrite (Intel VMX. CPL0 insn)
+ *	Note: with prefixes, these two opcodes are
+ *	extrq/insertq/AVX512 convert vector ops.
+ * 0f ae - group15: [f]xsave,[f]xrstor,[v]{ld,st}mxcsr,clflush[opt],
+ *	{rd,wr}{f,g}sbase,{s,l,m}fence.
+ *	Why? They are all user-executable.
  */
 static volatile u32 good_2byte_insns[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 	/*      ----------------------------------------------         */
-	W(0x00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1) | /* 00 */
-	W(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1) , /* 10 */
-	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* 20 */
-	W(0x30, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 30 */
+	W(0x00, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1) | /* 00 */
+	W(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 20 */
+	W(0x30, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) , /* 30 */
 	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
 	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
 	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 60 */
-	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) , /* 70 */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) , /* 70 */
 	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
 	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
-	W(0xa0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1) | /* a0 */
-	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
+	W(0xa0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1) | /* a0 */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
 	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* c0 */
-	W(0xd0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
+	W(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
 	W(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* e0 */
-	W(0xf0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)   /* f0 */
+	W(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1)   /* f0 */
 	/*      ----------------------------------------------         */
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 };
-- 
1.8.1.4

