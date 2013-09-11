Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3IKQLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:11:04 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33953 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3IKQKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:10:38 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 20/25] smp, tile: kill SMP single function call interrupt
Date: Thu, 12 Sep 2013 00:07:24 +0800
Message-Id: <1378915649-16395-21-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" has unified the way to handle
single and multiple cross-CPU function calls. Now only one interrupt
is needed for architecture specific code to support generic SMP function
call interfaces, so kill the redundant single function call interrupt.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 arch/tile/include/asm/smp.h | 7 +++----
 arch/tile/kernel/smp.c      | 6 +-----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/tile/include/asm/smp.h b/arch/tile/include/asm/smp.h
index 1aa759a..4b39184 100644
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
index cbc73a8..44d7132 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -134,14 +134,10 @@ void evaluate_message(int tag)
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

