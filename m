Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbbAWFgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:36:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:23499 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbbAWFg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:36:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444042454"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Chris Metcalf <cmetcalf@ezchip.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [Resend Patch v4 13/16] smp, tile: Kill SMP single function call interrupt
Date: Fri, 23 Jan 2015 13:36:52 +0800
Message-Id: <1421991416-20297-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" has unified the way to handle
single and multiple cross-CPU function calls. Now only one interrupt
is needed for architecture specific code to support generic SMP function
call interfaces, so kill the redundant single function call interrupt.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Chris Metcalf <cmetc...@tilera.com>
---
 arch/tile/include/asm/smp.h |    7 +++----
 arch/tile/kernel/smp.c      |    6 +-----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/tile/include/asm/smp.h b/arch/tile/include/asm/smp.h
index 9a326b64f7ae..67e58e781549 100644
--- a/arch/tile/include/asm/smp.h
+++ b/arch/tile/include/asm/smp.h
@@ -67,19 +67,18 @@ static inline int xy_to_cpu(int x, int y)
 /* Hypervisor message tags sent via the tile send_IPI*() routines. */
 #define MSG_TAG_START_CPU		1
 #define MSG_TAG_STOP_CPU		2
-#define MSG_TAG_CALL_FUNCTION_MANY	3
-#define MSG_TAG_CALL_FUNCTION_SINGLE	4
+#define MSG_TAG_CALL_FUNCTION		3
 
 /* Hook for the generic smp_call_function_many() routine. */
 static inline void arch_send_call_function_ipi_mask(struct cpumask *mask)
 {
-	send_IPI_many(mask, MSG_TAG_CALL_FUNCTION_MANY);
+	send_IPI_many(mask, MSG_TAG_CALL_FUNCTION);
 }
 
 /* Hook for the generic smp_call_function_single() routine. */
 static inline void arch_send_call_function_single_ipi(int cpu)
 {
-	send_IPI_single(cpu, MSG_TAG_CALL_FUNCTION_SINGLE);
+	send_IPI_single(cpu, MSG_TAG_CALL_FUNCTION);
 }
 
 /* Print out the boot string describing which cpus were disabled. */
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index d3c4ed780ce2..780410176341 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -139,14 +139,10 @@ void evaluate_message(int tag)
 		smp_stop_cpu_interrupt();
 		break;
 
-	case MSG_TAG_CALL_FUNCTION_MANY: /* Call function on cpumask */
+	case MSG_TAG_CALL_FUNCTION: /* Call function on cpumask */
 		generic_smp_call_function_interrupt();
 		break;
 
-	case MSG_TAG_CALL_FUNCTION_SINGLE: /* Call function on one other CPU */
-		generic_smp_call_function_single_interrupt();
-		break;
-
 	default:
 		panic("Unknown IPI message tag %d", tag);
 		break;
-- 
1.7.10.4

