Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3LEL0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:26:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31864 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab3LEL0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:26:07 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-64-52a062cdf8bc
From: Anurag Aggarwal <a.anurag@samsung.com>
To: linux-arm-kernel@lists.infradead.org, dave.martin@arm.com,
        linux@arm.linux.org.uk
Cc: cpgs@samsung.com, a.anurag@samsung.com, narendra.m1@samsung.com,
        poorva.s@samsung.com, naveen.sel@samsung.com, ashish.kalra@samsung.com,
        mohammad.a2@samsung.com, rajat.suri@samsung.com,
        naveenkrishna.ch@gmail.com, anurag19aggarwal@gmail.com,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, nico@linaro.org,
        catalin.marinas@arm.com
Subject: [PATCH V4] ARM : unwinder : Prevent data abort due to stack overflow
Date: Thu, 05 Dec 2013 16:56:25 +0530
Message-id: <1386242785-5146-1-git-send-email-a.anurag@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQd2zSQuCDC4vULB4fKGV1WLJts2s
	FvenfWO3eL+sh9Hi5SFNi6a5exgtNj2+xmpxedccNovbl3ktJsz9y2yx9PwZZotv0xezWiza
	9p/ZYvqxv2wWpx48ZbH4PH8tq8XLjydYHAQ91sxbw+jR0tzD5rFz1l12jzvX9rB5bF5S79G3
	ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZkxesYC64aVTx/tU7xgbGi+pdjJwcEgImEt9WPGCH
	sMUkLtxbz9bFyMUhJDCdUeLMhB3MIAkhgXYmiYt/PUBsNgEdiVc72plAbBGBcIn//0+D1TAL
	3GSS2N4UDmILC/hK/OlpYQGxWQRUJV4/nQq2gFfAWWLWn16gOAfQMgWJOZNsJjByL2BkWMUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHJTPpHcwrmqwOMQowMGoxMP7InF+kBBrYllxZe4h
	RgkOZiURXsfYBUFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4
	OKUaGFu2frlivcZ4R6GZVlz1VUXPheUKv/Js2Cb3Se/aMaNAqr/h/KJJ8yuufrSUm1SdoHnh
	ktmVlx8ZhIq/6a1KXyp2V2la42qfizVWz/fa6DcdWbA1TYpV/pG6mX7P99UT25mld8/eKb3w
	aeY8q22ysUZTWy4tFnlWvX3Glx3Ns7ybG6OvS0wQyFdiKc5INNRiLipOBAC/ptSVRgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While unwinding backtrace, stack overflow is possible. This stack
overflow can sometimes lead to data abort in system if the area after
stack is not mapped to physical memory.

To prevent this problem from happening, execute the instructions that
can cause a data abort in separate helper functions, where a check for
feasibility is made before reading each word from the stack.

Signed-off-by: Anurag Aggarwal <a.anurag@samsung.com>
---
 arch/arm/kernel/unwind.c |  127 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 90 insertions(+), 37 deletions(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..94f6ef4 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -68,6 +68,7 @@ EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
 struct unwind_ctrl_block {
 	unsigned long vrs[16];		/* virtual register set */
 	const unsigned long *insn;	/* pointer to the current instructions word */
+	unsigned long sp_high;		/* highest value of sp allowed*/
 	int entries;			/* number of entries left to interpret */
 	int byte;			/* current byte number in the instructions word */
 };
@@ -235,6 +236,86 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
 	return ret;
 }
 
+/* Before poping a register check whether it is feasible or not */
+static int unwind_pop_register(struct unwind_ctrl_block *ctrl,
+				unsigned long **vsp, unsigned int reg)
+{
+	if (*vsp >= (unsigned long *)ctrl->sp_high)
+		return -URC_FAILURE;
+
+	ctrl->vrs[reg] = *(*vsp)++;
+	return URC_OK;
+}
+
+/* Helper functions to execute the instructions */
+static int unwind_exec_pop_subset_r4_to_r13(struct unwind_ctrl_block *ctrl,
+						unsigned long mask)
+{
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
+	int load_sp, reg = 4;
+
+	load_sp = mask & (1 << (13 - 4));
+	while (mask) {
+		if (mask & 1)
+			if (unwind_pop_register(ctrl, &vsp, reg))
+				return -URC_FAILURE;
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
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
+	int reg;
+
+	/* pop R4-R[4+bbb] */
+	for (reg = 4; reg <= 4 + (insn & 7); reg++)
+		if (unwind_pop_register(ctrl, &vsp, reg))
+				return -URC_FAILURE;
+
+	if (insn & 0x80)
+		if (unwind_pop_register(ctrl, &vsp, 14))
+				return -URC_FAILURE;
+
+	ctrl->vrs[SP] = (unsigned long)vsp;
+
+	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
+		ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
+
+	return URC_OK;
+}
+
+static int unwind_exec_pop_subset_r0_to_r3(struct unwind_ctrl_block *ctrl,
+						unsigned long mask)
+{
+	unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
+	int reg = 0;
+
+	/* pop R0-R3 according to mask */
+	while (mask) {
+		if (mask & 1)
+			if (unwind_pop_register(ctrl, &vsp, reg))
+				return -URC_FAILURE;
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
@@ -250,8 +331,6 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 		ctrl->vrs[SP] -= ((insn & 0x3f) << 2) + 4;
 	else if ((insn & 0xf0) == 0x80) {
 		unsigned long mask;
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int load_sp, reg = 4;
 
 		insn = (insn << 8) | unwind_get_byte(ctrl);
 		mask = insn & 0x0fff;
@@ -261,38 +340,19 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 			return -URC_FAILURE;
 		}
 
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
+		return unwind_exec_pop_subset_r4_to_r13(ctrl, mask);
 	} else if ((insn & 0xf0) == 0x90 &&
 		   (insn & 0x0d) != 0x0d)
 		ctrl->vrs[SP] = ctrl->vrs[insn & 0x0f];
-	else if ((insn & 0xf0) == 0xa0) {
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int reg;
-
-		/* pop R4-R[4+bbb] */
-		for (reg = 4; reg <= 4 + (insn & 7); reg++)
-			ctrl->vrs[reg] = *vsp++;
-		if (insn & 0x80)
-			ctrl->vrs[14] = *vsp++;
-		ctrl->vrs[SP] = (unsigned long)vsp;
-	} else if (insn == 0xb0) {
+	else if ((insn & 0xf0) == 0xa0)
+		return unwind_exec_pop_r4_to_rN(ctrl, insn);
+	else if (insn == 0xb0) {
 		if (ctrl->vrs[PC] == 0)
 			ctrl->vrs[PC] = ctrl->vrs[LR];
 		/* no further processing */
 		ctrl->entries = 0;
 	} else if (insn == 0xb1) {
 		unsigned long mask = unwind_get_byte(ctrl);
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int reg = 0;
 
 		if (mask == 0 || mask & 0xf0) {
 			pr_warning("unwind: Spare encoding %04lx\n",
@@ -300,14 +360,7 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 			return -URC_FAILURE;
 		}
 
-		/* pop R0-R3 according to mask */
-		while (mask) {
-			if (mask & 1)
-				ctrl->vrs[reg] = *vsp++;
-			mask >>= 1;
-			reg++;
-		}
-		ctrl->vrs[SP] = (unsigned long)vsp;
+		return unwind_exec_pop_subset_r0_to_r3(ctrl, mask);
 	} else if (insn == 0xb2) {
 		unsigned long uleb128 = unwind_get_byte(ctrl);
 
@@ -329,13 +382,13 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
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
@@ -386,7 +439,7 @@ int unwind_frame(struct stackframe *frame)
 		int urc = unwind_exec_insn(&ctrl);
 		if (urc < 0)
 			return urc;
-		if (ctrl.vrs[SP] < low || ctrl.vrs[SP] >= high)
+		if (ctrl.vrs[SP] < low || ctrl.vrs[SP] >= ctrl.sp_high)
 			return -URC_FAILURE;
 	}
 
-- 
1.7.0.4

