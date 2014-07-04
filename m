Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106AbaGDNEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:04:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbaGDNEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:04:11 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/3] uprobes: fix 1-byte opcode tables
Date: Fri,  4 Jul 2014 15:03:45 +0200
Message-Id: <1404479026-9894-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1404479026-9894-1-git-send-email-dvlasenk@redhat.com>
References: <1404479026-9894-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes 1-byte opcode tables so that only insns
for which we have real reasons to disallow probing are marked
with unset bits.

To that end:

Set bits for all prefix bytes. Their setting is ignored anyway -
we check the bitmap against OPCODE1(insn), not against first byte.
Keeping them set to 0 only confuses code reader with
"why we don't support that opcode" question.

Thus: enable bytes c4,c5 in 64-bit mode (VEX prefixes).
Byte 62 (EVEX prefix) is not yet enabled since insn decoder
does not support that yet.

For 32-bit mode, enable probing of opcodes 63 (arpl) and d6 (salc).
They don't require any special handling.

For 64-bit mode, disable 9a and ea - these undefined opcodes
were mistakenly left enabled.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Jim Keniston <jkenisto@us.ibm.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c | 66 +++++++++++++----------------------------------
 1 file changed, 18 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 9ba2fb2..40dfb4e 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -67,18 +67,6 @@
  * to keep gcc from statically optimizing it out, as variable_test_bit makes
  * some versions of gcc to think only *(unsigned long*) is used.
  *
- * Prefixes. Most marked as "bad", but it doesn't matter, since insn decoder
- * won't report *prefixes* as OPCODE1(insn).
- * 0f - 2-byte opcode prefix
- * 26,2e,36,3e - es:/cs:/ss:/ds:
- * 64 - fs: (marked as "good", why?)
- * 65 - gs: (marked as "good", why?)
- * 66 - operand-size prefix
- * 67 - address-size prefix
- * f0 - lock prefix
- * f2 - repnz    (marked as "good", why?)
- * f3 - rep/repz (marked as "good", why?)
- *
  * Opcodes we'll probably never support:
  * 6c-6f - ins,outs. SEGVs if used in userspace
  * e4-e7 - in,out imm. SEGVs if used in userspace
@@ -105,31 +93,27 @@
  *	Not supported since kernel's handling of userspace single-stepping
  *	(TF flag) is fragile.
  * cf - iret. Normally not used in userspace. Doesn't SEGV unless arguments are bad
- *
- * Opcodes which can be enabled right away:
- * 63 - arpl. This insn has no unusual exceptions (it's basically an arith op).
- * d6 - salc. Undocumented "sign-extend carry flag to AL" insn
  */
 #if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
 static volatile u32 good_insns_32[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 	/*      ----------------------------------------------         */
-	W(0x00, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0) | /* 00 */
+	W(0x00, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* 00 */
 	W(0x10, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0) , /* 10 */
-	W(0x20, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1) | /* 20 */
-	W(0x30, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1) , /* 30 */
+	W(0x20, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 20 */
+	W(0x30, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 30 */
 	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
 	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
-	W(0x60, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
+	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
 	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 70 */
 	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
 	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
 	W(0xa0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* a0 */
 	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
 	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* c0 */
-	W(0xd0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
+	W(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
 	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* e0 */
-	W(0xf0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
+	W(0xf0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
 	/*      ----------------------------------------------         */
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 };
@@ -139,19 +123,6 @@ static volatile u32 good_insns_32[256 / 32] = {
 
 /* Good-instruction tables for 64-bit apps.
  *
- * Prefixes. Most marked as "bad", but it doesn't matter, since insn decoder
- * won't report *prefixes* as OPCODE1(insn).
- * 0f - 2-byte opcode prefix
- * 26,2e,36,3e - es:/cs:/ss:/ds:
- * 40-4f - rex prefixes
- * 64 - fs: (marked as "good", why?)
- * 65 - gs: (marked as "good", why?)
- * 66 - operand-size prefix
- * 67 - address-size prefix
- * f0 - lock prefix
- * f2 - repnz    (marked as "good", why?)
- * f3 - rep/repz (marked as "good", why?)
- *
  * Genuinely invalid opcodes:
  * 06,07 - formerly push/pop es
  * 0e - formerly push cs
@@ -159,14 +130,13 @@ static volatile u32 good_insns_32[256 / 32] = {
  * 1e,1f - formerly push/pop ds
  * 27,2f,37,3f - formerly daa/das/aaa/aas
  * 60,61 - formerly pusha/popa
- * 62 - formerly bound. EVEX prefix for AVX512
+ * 62 - formerly bound. EVEX prefix for AVX512 (not yet supported)
  * 82 - formerly redundant encoding of Group1
- * 9a - formerly call seg:ofs (marked as "supported"???)
- * c4,c5 - formerly les/lds. VEX prefixes for AVX
+ * 9a - formerly call seg:ofs
  * ce - formerly into
  * d4,d5 - formerly aam/aad
  * d6 - formerly undocumented salc
- * ea - formerly jmp seg:ofs (marked as "supported"???)
+ * ea - formerly jmp seg:ofs
  *
  * Opcodes we'll probably never support:
  * 6c-6f - ins,outs. SEGVs if used in userspace
@@ -190,22 +160,22 @@ static volatile u32 good_insns_32[256 / 32] = {
 static volatile u32 good_insns_64[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 	/*      ----------------------------------------------         */
-	W(0x00, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 00 */
+	W(0x00, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1) | /* 00 */
 	W(0x10, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 10 */
-	W(0x20, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 20 */
-	W(0x30, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 30 */
-	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 40 */
+	W(0x20, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0) | /* 20 */
+	W(0x30, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0) , /* 30 */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
 	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
-	W(0x60, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
+	W(0x60, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
 	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 70 */
 	W(0x80, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
-	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1) , /* 90 */
 	W(0xa0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* a0 */
 	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
-	W(0xc0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* c0 */
+	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* c0 */
 	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
-	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* e0 */
-	W(0xf0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
+	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0) | /* e0 */
+	W(0xf0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
 	/*      ----------------------------------------------         */
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 };
-- 
1.8.1.4

