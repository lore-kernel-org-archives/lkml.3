Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaJSWHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:07:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:9411 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaJSWFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644511"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 15/17] perf, x86: Discard zero length call entries in LBR call stack
Date: Sun, 19 Oct 2014 17:55:10 -0400
Message-Id: <1413755712-8259-16-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Zero length call" uses the attribute of the call instruction to push
the immediate instruction pointer on to the stack and then pops off
that address into a register. This is accomplished without any matching
return instruction. It confuses the hardware and make the recorded call
stack incorrect.

We can partially resolve this issue by: decode call instructions and
discard any zero length call entry in the LBR stack.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index cd4bd6f..fe25c42 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -94,7 +94,8 @@ enum {
 	X86_BR_ABORT		= 1 << 12,/* transaction abort */
 	X86_BR_IN_TX		= 1 << 13,/* in transaction */
 	X86_BR_NO_TX		= 1 << 14,/* not in transaction */
-	X86_BR_CALL_STACK	= 1 << 15,/* call stack */
+	X86_BR_ZERO_CALL	= 1 << 15,/* zero length call */
+	X86_BR_CALL_STACK	= 1 << 16,/* call stack */
 };
 
 #define X86_BR_PLM (X86_BR_USER | X86_BR_KERNEL)
@@ -111,13 +112,15 @@ enum {
 	 X86_BR_JMP	 |\
 	 X86_BR_IRQ	 |\
 	 X86_BR_ABORT	 |\
-	 X86_BR_IND_CALL)
+	 X86_BR_IND_CALL |\
+	 X86_BR_ZERO_CALL)
 
 #define X86_BR_ALL (X86_BR_PLM | X86_BR_ANY)
 
 #define X86_BR_ANY_CALL		 \
 	(X86_BR_CALL		|\
 	 X86_BR_IND_CALL	|\
+	 X86_BR_ZERO_CALL	|\
 	 X86_BR_SYSCALL		|\
 	 X86_BR_IRQ		|\
 	 X86_BR_INT)
@@ -688,6 +691,12 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
 		ret = X86_BR_INT;
 		break;
 	case 0xe8: /* call near rel */
+		insn_get_immediate(&insn);
+		if (insn.immediate1.value == 0) {
+			/* zero length call */
+			ret = X86_BR_ZERO_CALL;
+			break;
+		}
 	case 0x9a: /* call far absolute */
 		ret = X86_BR_CALL;
 		break;
-- 
1.8.3.2

