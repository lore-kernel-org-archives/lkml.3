Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3LCJ0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:26:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24532 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3LCJ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:26:28 -0500
X-AuditID: cbfee61a-b7f796d000004313-85-529da3c213f6
From: Anurag Aggarwal <a.anurag@samsung.com>
To: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        dave.martin@arm.com
Cc: cpgs@samsung.com, a.anurag@samsung.com, narendra.m1@samsung.com,
        poorva.s@samsung.com, naveen.sel@samsung.com, ashish.kalra@samsung.com,
        mohammad.a2@samsung.com, rajat.suri@samsung.com,
        naveenkrishna.ch@gmail.com, anurag19aggarwal@gmail.com,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, nico@linaro.org,
        catalin.marinas@arm.com
Subject: [PATCH V3] ARM : unwinder : Prevent data abort due to stack overflow
Date: Tue, 03 Dec 2013 14:56:25 +0530
Message-id: <1386062785-3261-1-git-send-email-a.anurag@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd1Di+cGGTzrVbJ4fKGV1WLJts2s
	FvenfWO3eL+sh9Hi5SFNi6a5exgtNj2+xmpxedccNovbl3ktJsz9y2yx9PwZZotv0xezWiza
	9p/ZYvqxv2wWpx48ZbH4PH8tq8XLjydYHAQ91sxbw+jR0tzD5rFz1l12jzvX9rB5bF5S79G3
	ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZ05btZyn4ZF8x5UIrUwPjdsMuRk4OCQETifkdH5gh
	bDGJC/fWs3UxcnEICUxnlNh26iwzhNPOJPH6wFNWkCo2AR2JVzvamUBsEYFwid6+I2DdzAI3
	mSS2N4WD2MICvhKfb+5mA7FZBFQlVk3vA6vhFXCWWPdoDdAcDqBtChJzJtlMYORewMiwilE0
	tSC5oDgpPddQrzgxt7g0L10vOT93EyM4LJ9J7WBc2WBxiFGAg1GJh/fB9jlBQqyJZcWVuYcY
	JTiYlUR456fPDRLiTUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgmy8TB
	KdXA6GO9605a9wwho8eiS7O4b+o1J05rF7k7fX9XrfmjNTJ+8w7vWPuq8rX/8hnHWOd9f3Yh
	47b+u18Xb290PVxxcFYie9gyqwOHUuUSf53U3v1Bg2OvX82OSVvnTj8TIC8YMI/phlzi8enV
	iTZWm/aJ737IVl51wUjh/+77rJ7P27UncE7+sezY2vdKLMUZiYZazEXFiQCaW/gmRwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anurag Aggarwal <a.anurag@samsung.com>

While unwinding backtrace, stack overflow is possible. This stack
overflow can sometimes lead to data abort in system if the area after
stack is not mapped to physical memory.

To prevent this problem from happening, execute the instructions that
can cause a data abort in separate helper functions, where a check for
feasibility is made before reading data from the stack.
---
 arch/arm/kernel/unwind.c |  207 ++++++++++++++++++++++++++++++++++------------
 1 files changed, 153 insertions(+), 54 deletions(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..a140725 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -49,6 +49,8 @@
 #include <asm/traps.h>
 #include <asm/unwind.h>
 
+#define TOTAL_REGISTERS 16
+
 /* Dummy functions to avoid linker complaints */
 void __aeabi_unwind_cpp_pr0(void)
 {
@@ -66,8 +68,9 @@ void __aeabi_unwind_cpp_pr2(void)
 EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
 
 struct unwind_ctrl_block {
-	unsigned long vrs[16];		/* virtual register set */
+	unsigned long vrs[TOTAL_REGISTERS];	/* virtual register set */
 	const unsigned long *insn;	/* pointer to the current instructions word */
+	unsigned long sp_high;		/* highest value of sp allowed*/
 	int entries;			/* number of entries left to interpret */
 	int byte;			/* current byte number in the instructions word */
 };
@@ -235,6 +238,148 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
 	return ret;
 }
 
+static int unwind_exec_pop_subset_r4_to_r13(struct unwind_ctrl_block *ctrl,
+						unsigned long insn)
+{
+	int available_stack;
+	unsigned long mask;
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
+	int load_sp, reg = 4;
+
+	/* caculate the space available on stack */
+	available_stack = ctrl->sp_high - ctrl->vrs[SP];
+
+	insn = (insn << 8) | unwind_get_byte(ctrl);
+	mask = insn & 0x0fff;
+	if (mask == 0) {
+		pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
+			insn);
+		return -URC_FAILURE;
+	}
+
+	/*
+	 *  Check whether there is enough space
+	 *  on stack to execute the instruction
+	 *  if not then return failure
+	 */
+	if (available_stack < TOTAL_REGISTERS) {
+		unsigned long mask_copy = mask;
+		int required_stack = 0;
+
+		while (mask_copy) {
+			if (mask_copy & 1)
+				required_stack++;
+			mask_copy >>= 1;
+		}
+
+		if (available_stack < required_stack)
+			return -URC_FAILURE;
+	}
+
+	load_sp = mask & (1 << (13 - 4));
+	while (mask) {
+		if (mask & 1)
+			ctrl->vrs[reg] = *vsp++;
+		mask >>= 1;
+		reg++;
+	}
+	if (!load_sp)
+		ctrl->vrs[SP] = (unsigned long)vsp;
+
+	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
+		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
+
+	return URC_OK;
+}
+
+static int unwind_exec_pop_r4_to_rN(struct unwind_ctrl_block *ctrl,
+					unsigned long insn)
+{
+	int available_stack;
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
+	int reg;
+
+	/* caculate the space available on stack */
+	available_stack = ctrl->sp_high - ctrl->vrs[SP];
+
+	/*
+	 *  Check whether there is enough space
+	 *  on stack to execute the instruction
+	 *  if not then return failure
+	 */
+	if (available_stack < TOTAL_REGISTERS) {
+		int required_stack;
+
+		required_stack = insn & 7;
+		required_stack += (insn & 0x80) ? 1 : 0;
+
+		if (available_stack < required_stack)
+			return -URC_FAILURE;
+	}
+
+	/* pop R4-R[4+bbb] */
+	for (reg = 4; reg <= 4 + (insn & 7); reg++)
+		ctrl->vrs[reg] = *vsp++;
+	if (insn & 0x80)
+		ctrl->vrs[14] = *vsp++;
+	ctrl->vrs[SP] = (unsigned long)vsp;
+
+	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
+		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
+
+	return URC_OK;
+}
+
+static int unwind_exec_pop_subset_r0_to_r3(struct unwind_ctrl_block *ctrl,
+					unsigned long insn)
+{
+	int available_stack;
+	unsigned long mask = unwind_get_byte(ctrl);
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
+	int reg = 0;
+
+	if (mask == 0 || mask & 0xf0) {
+		pr_warning("unwind: Spare encoding %04lx\n",
+			(insn << 8) | mask);
+		return -URC_FAILURE;
+	}
+
+	/* caculate the space available on stack */
+	available_stack = ctrl->sp_high - ctrl->vrs[SP];
+
+	/*
+	 *  Check whether there is enough space
+	 *  on stack to execute the instruction
+	 *  if not then return failure
+	 */
+	if (available_stack < TOTAL_REGISTERS) {
+		unsigned long mask_copy = mask;
+		int required_stack = 0;
+
+		while (mask_copy) {
+			if (mask_copy & 1)
+				required_stack++;
+			mask_copy >>= 1;
+		}
+		if (available_stack < required_stack)
+			return -URC_FAILURE;
+	}
+
+	/* pop R0-R3 according to mask */
+	while (mask) {
+		if (mask & 1)
+			ctrl->vrs[reg] = *vsp++;
+		mask >>= 1;
+		reg++;
+	}
+	ctrl->vrs[SP] = (unsigned long)vsp;
+
+	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
+		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
+
+	return URC_OK;
+}
+
 /*
  * Execute the current unwind instruction.
  */
@@ -249,65 +394,19 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 	else if ((insn & 0xc0) == 0x40)
 		ctrl->vrs[SP] -= ((insn & 0x3f) << 2) + 4;
 	else if ((insn & 0xf0) == 0x80) {
-		unsigned long mask;
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int load_sp, reg = 4;
-
-		insn = (insn << 8) | unwind_get_byte(ctrl);
-		mask = insn & 0x0fff;
-		if (mask == 0) {
-			pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
-				   insn);
-			return -URC_FAILURE;
-		}
-
-		/* pop R4-R15 according to mask */
-		load_sp = mask & (1 << (13 - 4));
-		while (mask) {
-			if (mask & 1)
-				ctrl->vrs[reg] = *vsp++;
-			mask >>= 1;
-			reg++;
-		}
-		if (!load_sp)
-			ctrl->vrs[SP] = (unsigned long)vsp;
+		return unwind_exec_pop_subset_r4_to_r13(ctrl, insn);
 	} else if ((insn & 0xf0) == 0x90 &&
 		   (insn & 0x0d) != 0x0d)
 		ctrl->vrs[SP] = ctrl->vrs[insn & 0x0f];
 	else if ((insn & 0xf0) == 0xa0) {
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int reg;
-
-		/* pop R4-R[4+bbb] */
-		for (reg = 4; reg <= 4 + (insn & 7); reg++)
-			ctrl->vrs[reg] = *vsp++;
-		if (insn & 0x80)
-			ctrl->vrs[14] = *vsp++;
-		ctrl->vrs[SP] = (unsigned long)vsp;
+		return unwind_exec_pop_r4_to_rN(ctrl, insn);
 	} else if (insn == 0xb0) {
 		if (ctrl->vrs[PC] == 0)
 			ctrl->vrs[PC] = ctrl->vrs[LR];
 		/* no further processing */
 		ctrl->entries = 0;
 	} else if (insn == 0xb1) {
-		unsigned long mask = unwind_get_byte(ctrl);
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int reg = 0;
-
-		if (mask == 0 || mask & 0xf0) {
-			pr_warning("unwind: Spare encoding %04lx\n",
-			       (insn << 8) | mask);
-			return -URC_FAILURE;
-		}
-
-		/* pop R0-R3 according to mask */
-		while (mask) {
-			if (mask & 1)
-				ctrl->vrs[reg] = *vsp++;
-			mask >>= 1;
-			reg++;
-		}
-		ctrl->vrs[SP] = (unsigned long)vsp;
+		return unwind_exec_pop_subset_r0_to_r3(ctrl, insn);
 	} else if (insn == 0xb2) {
 		unsigned long uleb128 = unwind_get_byte(ctrl);
 
@@ -329,13 +428,13 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
  */
 int unwind_frame(struct stackframe *frame)
 {
-	unsigned long high, low;
+	unsigned long low;
 	const struct unwind_idx *idx;
 	struct unwind_ctrl_block ctrl;
 
-	/* only go to a higher address on the stack */
+	/* store the highest address on the stack to avoid crossing it*/
 	low = frame->sp;
-	high = ALIGN(low, THREAD_SIZE);
+	ctrl.sp_high = ALIGN(low, THREAD_SIZE);
 
 	pr_debug("%s(pc = %08lx lr = %08lx sp = %08lx)\n", __func__,
 		 frame->pc, frame->lr, frame->sp);
@@ -386,7 +485,7 @@ int unwind_frame(struct stackframe *frame)
 		int urc = unwind_exec_insn(&ctrl);
 		if (urc < 0)
 			return urc;
-		if (ctrl.vrs[SP] < low || ctrl.vrs[SP] >= high)
+		if (ctrl.vrs[SP] < low || ctrl.vrs[SP] >= ctrl.sp_high)
 			return -URC_FAILURE;
 	}
 
-- 
1.7.0.4

