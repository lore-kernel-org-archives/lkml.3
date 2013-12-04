Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab3LDQT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:19:56 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52616 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab3LDQTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:19:54 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Tony Lu <zlu@tilera.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-arch@vger.kernel.org
Subject: [RFC PATCH v3 17/19] smp, tile: kill SMP single function call interrupt
Date: Thu,  5 Dec 2013 00:13:08 +0800
Message-Id: <1386173591-28514-18-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
References: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" has unified the way to handle
single and multiple cross-CPU function calls. Now only one intterupt
is needed for architecture specific code to support generic SMP function
call interfaces, so kill the redundant single function call interrupt.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/tile/include/asm/smp.h | 7 +++----
 arch/tile/kernel/smp.c      | 6 +-----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/tile/include/asm/smp.h b/arch/tile/include/asm/smp.h
index 9a326b6..67e58e7 100644
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
index 01e8ab2..73a1cdc 100644
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
1.8.1.2

