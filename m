Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaJMCgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:36:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaJMCaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3.17 10/25] x86: Tell irq work about self IPI support
Date: Mon, 13 Oct 2014 04:25:03 +0200
Message-Id: <20141013022454.727690492@linuxfoundation.org>
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

commit 3010279f0fc36f0388872203e63ca49912f648fd upstream.

x86 supports irq work self-IPIs when local apic is available. This is
partly known on runtime so lets implement arch_irq_work_has_interrupt()
accordingly.

This should be safely called after setup_arch().

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/Kbuild     |    1 -
 arch/x86/include/asm/irq_work.h |   11 +++++++++++
 arch/x86/kernel/irq_work.c      |    2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -7,6 +7,5 @@ genhdr-y += unistd_x32.h
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += early_ioremap.h
-generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += scatterlist.h
--- /dev/null
+++ b/arch/x86/include/asm/irq_work.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_IRQ_WORK_H
+#define _ASM_IRQ_WORK_H
+
+#include <asm/processor.h>
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return cpu_has_apic;
+}
+
+#endif /* _ASM_IRQ_WORK_H */
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -41,7 +41,7 @@ __visible void smp_trace_irq_work_interr
 void arch_irq_work_raise(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
-	if (!cpu_has_apic)
+	if (!arch_irq_work_has_interrupt())
 		return;
 
 	apic->send_IPI_self(IRQ_WORK_VECTOR);


