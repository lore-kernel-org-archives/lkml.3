Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab3HHSZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 14:25:50 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:64316 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab3HHSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 14:25:49 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH] smp.c: Quit unconditionally enabling irqs in on_each_cpu_mask().
Date: Thu,  8 Aug 2013 11:25:42 -0700
Message-Id: <1375986342-22999-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

As in f21afc25f9ed (smp.h: Use local_irq_{save,restore}() in !SMP
version of on_each_cpu().), we don't want to enable irqs if they are
not already enabled.

I don't know of any bugs currently caused by this unconditional
local_irq_enable(), but I want to use this function in MIPS/OCTEON
early boot (when we have early_boot_irqs_disabled).  This also makes
this function have similar semantics to on_each_cpu() which is good in
itself.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 kernel/smp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 91c52ab..97edbbe 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -578,8 +578,10 @@ EXPORT_SYMBOL(on_each_cpu);
  *
  * If @wait is true, then returns once @func has returned.
  *
- * You must not call this function with disabled interrupts or
- * from a hardware interrupt handler or from a bottom half handler.
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler or from a bottom half handler.  The
+ * exception is that it may be used during early boot while
+ * early_boot_irqs_disabled is set.
  */
 void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
 			void *info, bool wait)
@@ -588,9 +590,10 @@ void on_each_cpu_mask(const struct cpumask *mask, smp_call_func_t func,
 
 	smp_call_function_many(mask, func, info, wait);
 	if (cpumask_test_cpu(cpu, mask)) {
-		local_irq_disable();
+		unsigned long flags;
+		local_irq_save(flags);
 		func(info);
-		local_irq_enable();
+		local_irq_restore(flags);
 	}
 	put_cpu();
 }
-- 
1.7.11.7

