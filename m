Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaJMCaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:30:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaJMCaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3.17 11/25] arm: Tell irq work about self IPI support
Date: Mon, 13 Oct 2014 04:25:04 +0200
Message-Id: <20141013022454.776799372@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit 09f6edd424218eb69078551b2ecfada1f2d098eb upstream.

ARM irq work IPI support depends on SMP support. That information is
partly known at early boottime. Lets implement
arch_irq_work_has_interrupt() accordingly.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/Kbuild     |    1 -
 arch/arm/include/asm/irq_work.h |   11 +++++++++++
 arch/arm/kernel/smp.c           |    2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -11,7 +11,6 @@ generic-y += hash.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
-generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += local.h
 generic-y += local64.h
--- /dev/null
+++ b/arch/arm/include/asm/irq_work.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_ARM_IRQ_WORK_H
+#define __ASM_ARM_IRQ_WORK_H
+
+#include <asm/smp_plat.h>
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return is_smp();
+}
+
+#endif /* _ASM_ARM_IRQ_WORK_H */
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -503,7 +503,7 @@ void arch_send_call_function_single_ipi(
 #ifdef CONFIG_IRQ_WORK
 void arch_irq_work_raise(void)
 {
-	if (is_smp())
+	if (arch_irq_work_has_interrupt())
 		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
 }
 #endif


