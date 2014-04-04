Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaDDUsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:48:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbaDDUrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:47:21 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, x86@kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, mguzik@redhat.com,
        Aaron Tomlin <atomlin@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/4 v2] x86, nmi: Add more flexible NMI back trace support
Date: Fri,  4 Apr 2014 16:47:08 -0400
Message-Id: <1396644430-70649-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1396644430-70649-1-git-send-email-dzickus@redhat.com>
References: <1396644430-70649-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Tomlin <atomlin@redhat.com>

This patch introduces the x86 specific implementation
changes to the arch_trigger_all_cpu_backtrace() routine.
Now users have the ability to choose whether or not to
issue an NMI back trace which includes current.

[Don't print message in single processor case - dcz]

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/irq.h    |    2 +-
 arch/x86/kernel/apic/hw_nmi.c |   16 +++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index cb6cfcd..a80cbb8 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -43,7 +43,7 @@ extern int vector_used_by_percpu_irq(unsigned int vector);
 extern void init_ISA_irqs(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-void arch_trigger_all_cpu_backtrace(void);
+void arch_trigger_all_cpu_backtrace(bool);
 #define arch_trigger_all_cpu_backtrace arch_trigger_all_cpu_backtrace
 #endif
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a698d71..3614e34 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -33,7 +33,7 @@ static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 /* "in progress" flag of arch_trigger_all_cpu_backtrace */
 static unsigned long backtrace_flag;
 
-void arch_trigger_all_cpu_backtrace(void)
+void arch_trigger_all_cpu_backtrace(bool include_self)
 {
 	int i;
 
@@ -46,8 +46,18 @@ void arch_trigger_all_cpu_backtrace(void)
 
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
-	printk(KERN_INFO "sending NMI to all CPUs:\n");
-	apic->send_IPI_all(NMI_VECTOR);
+	if (include_self) {
+		printk(KERN_INFO "sending NMI to all CPUs:\n");
+		apic->send_IPI_all(NMI_VECTOR);
+	} else {
+		cpumask_clear_cpu(smp_processor_id(),
+			to_cpumask(backtrace_mask));
+
+		if (!cpumask_empty(to_cpumask(backtrace_mask))) {
+			printk(KERN_INFO "sending NMI to other CPUs:\n");
+			apic->send_IPI_allbutself(NMI_VECTOR);
+		}
+	}
 
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
-- 
1.7.1

