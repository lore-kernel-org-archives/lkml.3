Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaG3G5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:57:43 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:26578 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaG3G5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:57:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0BAM+W2FOERCABjGdsb2JhbABahDe0JJdOh1qBFBYQAQEBJz2EMVKBUYhCugmGMhePTB2ENAWKbqkCaQ
X-IPAS-Result: Ar0BAM+W2FOERCABjGdsb2JhbABahDe0JJdOh1qBFBYQAQEBJz2EMVKBUYhCugmGMhePTB2ENAWKbqkCaQ
X-IronPort-AV: E=Sophos;i="5.01,762,1400014800"; 
   d="scan'208";a="117376121"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, nadav.amit@gmail.com,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: Remove redundant and incorrect cpl check on task-switch
Date: Wed, 30 Jul 2014 09:57:16 +0300
Message-Id: <1406703436-9920-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Task-switch emulation checks the privilage level prior to performing the
task-switch.  This check is incorrect in the case of task-gates, in which the
tss.dpl is ignored, and can cause superfluous exceptions.  Moreover this check
is unnecassary, since the CPU checks the privilage levels prior to exiting.
Intel SDM 25.4.2 says "If CALL or JMP accesses a TSS descriptor directly
outside IA-32e mode, privilege levels are checked on the TSS descriptor" prior
to exiting.  AMD 15.14.1 says "The intercept is checked before the task switch
takes place but after the incoming TSS and task gate (if one was involved) have
been checked for correctness."

This patch removes the CPL checks for CALL and JMP.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 56657b0..a9b2bd6 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2698,7 +2698,8 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
 	 *
 	 * 1. jmp/call/int to task gate: Check against DPL of the task gate
 	 * 2. Exception/IRQ/iret: No check is performed
-	 * 3. jmp/call to TSS: Check against DPL of the TSS
+	 * 3. jmp/call to TSS/task-gate: No check is performed since the
+	 *    hardware checks it before exiting.
 	 */
 	if (reason == TASK_SWITCH_GATE) {
 		if (idt_index != -1) {
@@ -2715,13 +2716,8 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
 			if ((tss_selector & 3) > dpl || ops->cpl(ctxt) > dpl)
 				return emulate_gp(ctxt, (idt_index << 3) | 0x2);
 		}
-	} else if (reason != TASK_SWITCH_IRET) {
-		int dpl = next_tss_desc.dpl;
-		if ((tss_selector & 3) > dpl || ops->cpl(ctxt) > dpl)
-			return emulate_gp(ctxt, tss_selector);
 	}
 
-
 	desc_limit = desc_limit_scaled(&next_tss_desc);
 	if (!next_tss_desc.p ||
 	    ((desc_limit < 0x67 && (next_tss_desc.type & 8)) ||
-- 
1.9.1

