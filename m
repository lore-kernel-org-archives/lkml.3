Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaDSRCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 13:02:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDSRCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 13:02:02 -0400
Date: Sat, 19 Apr 2014 19:01:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] uprobes/x86: Add uprobe_init_insn(), kill
	validate_insn_{32,64}bits()
Message-ID: <20140419170147.GA30850@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140419170104.GA30667@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

validate_insn_32bits() and validate_insn_64bits() are very similar,
turn them into the single uprobe_init_insn() which has the additional
"bool x86_64" argument which can be passed to insn_init() and used to
choose between good_insns_64/good_insns_32.

Also kill UPROBE_FIX_NONE, it has no users.

Note: the current code doesn't use ifdef's consistently, good_insns_64
depends on CONFIG_X86_64 but good_insns_32 is unconditional. This patch
removes ifdef around good_insns_64, we will add it back later along with
the similar one for good_insns_32.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/uprobes.c |   45 +++++++++++++--------------------------------
 1 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index e1d7115..68c63ab 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -32,9 +32,6 @@
 
 /* Post-execution fixups. */
 
-/* No fixup needed */
-#define UPROBE_FIX_NONE		0x0
-
 /* Adjust IP back to vicinity of actual insn */
 #define UPROBE_FIX_IP		0x1
 
@@ -114,7 +111,6 @@ static volatile u32 good_2byte_insns[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 };
 
-#ifdef CONFIG_X86_64
 /* Good-instruction tables for 64-bit apps */
 static volatile u32 good_insns_64[256 / 32] = {
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
@@ -138,7 +134,6 @@ static volatile u32 good_insns_64[256 / 32] = {
 	/*      ----------------------------------------------         */
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
 };
-#endif
 #undef W
 
 /*
@@ -209,16 +204,22 @@ static bool is_prefix_bad(struct insn *insn)
 	return false;
 }
 
-static int validate_insn_32bits(struct arch_uprobe *auprobe, struct insn *insn)
+static int uprobe_init_insn(struct arch_uprobe *auprobe, struct insn *insn, bool x86_64)
 {
-	insn_init(insn, auprobe->insn, false);
+	u32 volatile *good_insns;
+
+	insn_init(insn, auprobe->insn, x86_64);
 
-	/* Skip good instruction prefixes; reject "bad" ones. */
 	insn_get_opcode(insn);
 	if (is_prefix_bad(insn))
 		return -ENOTSUPP;
 
-	if (test_bit(OPCODE1(insn), (unsigned long *)good_insns_32))
+	if (x86_64)
+		good_insns = good_insns_64;
+	else
+		good_insns = good_insns_32;
+
+	if (test_bit(OPCODE1(insn), (unsigned long *)good_insns))
 		return 0;
 
 	if (insn->opcode.nbytes == 2) {
@@ -355,30 +356,10 @@ handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *
 	}
 }
 
-static int validate_insn_64bits(struct arch_uprobe *auprobe, struct insn *insn)
-{
-	insn_init(insn, auprobe->insn, true);
-
-	/* Skip good instruction prefixes; reject "bad" ones. */
-	insn_get_opcode(insn);
-	if (is_prefix_bad(insn))
-		return -ENOTSUPP;
-
-	if (test_bit(OPCODE1(insn), (unsigned long *)good_insns_64))
-		return 0;
-
-	if (insn->opcode.nbytes == 2) {
-		if (test_bit(OPCODE2(insn), (unsigned long *)good_2byte_insns))
-			return 0;
-	}
-	return -ENOTSUPP;
-}
-
 static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm, struct insn *insn)
 {
-	if (mm->context.ia32_compat)
-		return validate_insn_32bits(auprobe, insn);
-	return validate_insn_64bits(auprobe, insn);
+	bool x86_64 = !mm->context.ia32_compat;
+	return uprobe_init_insn(auprobe, insn, x86_64);
 }
 #else /* 32-bit: */
 /*
@@ -398,7 +379,7 @@ static void handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *
 
 static int validate_insn_bits(struct arch_uprobe *auprobe, struct mm_struct *mm,  struct insn *insn)
 {
-	return validate_insn_32bits(auprobe, insn);
+	return uprobe_init_insn(auprobe, insn, false);
 }
 #endif /* CONFIG_X86_64 */
 
-- 
1.5.5.1

