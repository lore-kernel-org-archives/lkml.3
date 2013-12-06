Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3LFGJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:09:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32481 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3LFGJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:09:39 -0500
X-AuditID: cbfee61a-b7f796d000004313-99-52a16a2173be
From: Anurag Aggarwal <a.anurag@samsung.com>
To: linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
Cc: cpgs@samsung.com, a.anurag@samsung.com, narendra.m1@samsung.com,
        poorva.s@samsung.com, naveen.sel@samsung.com, ashish.kalra@samsung.com,
        mohammad.a2@samsung.com, rajat.suri@samsung.com,
        naveenkrishna.ch@gmail.com, anurag19aggarwal@gmail.com,
        linux-kernel@vger.kernel.org, will.deacon@arm.com, nico@linaro.org,
        catalin.marinas@arm.com
Subject: [PATCH] ARM : unwinder : Prevent data abort due to stack overflow
Date: Fri, 06 Dec 2013 11:39:53 +0530
Message-id: <1386310193-6434-1-git-send-email-a.anurag@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAV3FrIVBBtfWiVs8vtDKarFk22ZW
	i/vTvrFbvF/Ww2jx8pCmRdPcPYwWmx5fY7W4vGsOm8WEuX+ZLZaeP8Ns8W36YlaLRdv+M1tM
	P/aXzeLUg6csFp/nr2W1ePnxBIuDgMeaeWsYPXbOusvucefaHjaPzUvqPfq2rGL0+LxJLoAt
	issmJTUnsyy1SN8ugStjz44XjAULLSs2rbrO3sB4WaeLkYNDQsBEYt3vgC5GTiBTTOLCvfVs
	XYxcHEICixgluue0soIkhATamSSWrigHsdkEdCRe7WhnArFFBGwlnm64xQhiMwvcZJLY3hQO
	YgsLeEk8mnGIBcRmEVCVuHr8JFg9r4CzxOIf5xgh9ipIzJlkM4GRewEjwypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4AB8JrWDcWWDxSFGAQ5GJR5ejlULgoRYE8uKK3MPMUpwMCuJ8PaI
	LwwS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwDhvIwdz
	SXLXprdhn5zdQ/o97wt4Z5568Gn+pPtPF80p32s/T/gvH8f0o+sXnPqjYMir8XBDtY9iz5Vt
	V19np1yW/OQWrXX31O86w3nfbxu1Tn72bJemfOTlfe5Ht9qbJUYr5mVeUXK8IcEUU8Wx2+Vx
	2wtb1f2a64utLoX/m5AnYzk/vbj5YrkSS3FGoqEWc1FxIgBajGK+PAIAAA==
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
 arch/arm/kernel/unwind.c | 138 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 100 insertions(+), 38 deletions(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..6d854f8 100644
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
@@ -66,9 +68,11 @@ void __aeabi_unwind_cpp_pr2(void)
 EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
 
 struct unwind_ctrl_block {
-	unsigned long vrs[16];		/* virtual register set */
+	unsigned long vrs[TOTAL_REGISTERS];	/* virtual register set */
 	const unsigned long *insn;	/* pointer to the current instructions word */
+	unsigned long sp_high;		/* highest value of sp allowed*/
 	int entries;			/* number of entries left to interpret */
+	int last_register_set;          /* store if we are at the last set */
 	int byte;			/* current byte number in the instructions word */
 };
 
@@ -235,12 +239,85 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
 	return ret;
 }
 
+/* Before poping a register check whether it is feasible or not */
+static int unwind_pop_register(struct unwind_ctrl_block *ctrl,
+				unsigned long **vsp, unsigned int reg)
+{
+	if (unlikely(ctrl->last_register_set))
+		if (*vsp >= (unsigned long *)ctrl->sp_high)
+			return -URC_FAILURE;
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
+	return URC_OK;
+}
+
 /*
  * Execute the current unwind instruction.
  */
 static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 {
 	unsigned long insn = unwind_get_byte(ctrl);
+	int ret = URC_OK;
 
 	pr_debug("%s: insn = %08lx\n", __func__, insn);
 
@@ -250,8 +327,6 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 		ctrl->vrs[SP] -= ((insn & 0x3f) << 2) + 4;
 	else if ((insn & 0xf0) == 0x80) {
 		unsigned long mask;
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int load_sp, reg = 4;
 
 		insn = (insn << 8) | unwind_get_byte(ctrl);
 		mask = insn & 0x0fff;
@@ -261,29 +336,16 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
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
+		ret = unwind_exec_pop_subset_r4_to_r13(ctrl, mask);
+		if (ret)
+			goto error;
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
+		ret = unwind_exec_pop_r4_to_rN(ctrl, insn);
+		if (ret)
+			goto error;
 	} else if (insn == 0xb0) {
 		if (ctrl->vrs[PC] == 0)
 			ctrl->vrs[PC] = ctrl->vrs[LR];
@@ -291,8 +353,6 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 		ctrl->entries = 0;
 	} else if (insn == 0xb1) {
 		unsigned long mask = unwind_get_byte(ctrl);
-		unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
-		int reg = 0;
 
 		if (mask == 0 || mask & 0xf0) {
 			pr_warning("unwind: Spare encoding %04lx\n",
@@ -300,14 +360,9 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
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
+		ret = unwind_exec_pop_subset_r0_to_r3(ctrl, mask);
+		if (ret)
+			goto error;
 	} else if (insn == 0xb2) {
 		unsigned long uleb128 = unwind_get_byte(ctrl);
 
@@ -320,7 +375,8 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 	pr_debug("%s: fp = %08lx sp = %08lx lr = %08lx pc = %08lx\n", __func__,
 		 ctrl->vrs[FP], ctrl->vrs[SP], ctrl->vrs[LR], ctrl->vrs[PC]);
 
-	return URC_OK;
+error:
+	return ret;
 }
 
 /*
@@ -329,13 +385,13 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
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
@@ -382,11 +438,17 @@ int unwind_frame(struct stackframe *frame)
 		return -URC_FAILURE;
 	}
 
+	/* we are just starting, initialize last register set as 0 */
+	ctrl.last_register_set = 0;
+
 	while (ctrl.entries > 0) {
-		int urc = unwind_exec_insn(&ctrl);
+		int urc;
+		if ((ctrl.sp_high - ctrl.vrs[SP]) < TOTAL_REGISTERS)
+			ctrl.last_register_set = 1;
+		urc = unwind_exec_insn(&ctrl);
 		if (urc < 0)
 			return urc;
-		if (ctrl.vrs[SP] < low || ctrl.vrs[SP] >= high)
+		if (ctrl.vrs[SP] < low || ctrl.vrs[SP] >= ctrl.sp_high)
 			return -URC_FAILURE;
 	}
 
-- 
1.8.1.2

