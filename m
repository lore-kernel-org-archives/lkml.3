Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbaEPNdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:33:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54058 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaEPNdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:33:01 -0400
Date: Fri, 16 May 2014 06:31:59 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-b1ee544174fd0eb28a7770403b9577fd70f1cd3d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        tony.luck@intel.com
In-Reply-To: <20140507154334.482904047@linutronix.de>
References: <20140507154334.482904047@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: Implement arch_setup/teardown_hwirq()
Git-Commit-ID: b1ee544174fd0eb28a7770403b9577fd70f1cd3d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1ee544174fd0eb28a7770403b9577fd70f1cd3d
Gitweb:     http://git.kernel.org/tip/b1ee544174fd0eb28a7770403b9577fd70f1cd3d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:06 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:18 +0200

x86: Implement arch_setup/teardown_hwirq()

This is just a cleanup to get rid of the create/destroy_irq variants
which were designed in hell.

The long term solution for x86 is to switch over to irq domains and
cleanup the whole vector allocation mess.

The generic irq_alloc_hwirqs() interface deliberately prevents
multi-MSI vector allocation to further enforce the irq domain
conversion (aside of the desire to support ioapic hotplug).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20140507154334.482904047@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig               |  1 +
 arch/x86/kernel/apic/io_apic.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..4724770 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -831,6 +831,7 @@ config X86_LOCAL_APIC
 config X86_IO_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC || PCI_MSI
+	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 
 config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 	bool "Reroute for broken boot IRQs"
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 992060e..b7175c0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3010,6 +3010,39 @@ void destroy_irqs(unsigned int irq, unsigned int count)
 		destroy_irq(irq + i);
 }
 
+int arch_setup_hwirq(unsigned int irq, int node)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	int ret;
+
+	cfg = alloc_irq_cfg(irq, node);
+	if (!cfg)
+		return -ENOMEM;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	ret = __assign_irq_vector(irq, cfg, apic->target_cpus());
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+
+	if (!ret)
+		irq_set_chip_data(irq, cfg);
+	else
+		free_irq_cfg(irq, cfg);
+	return ret;
+}
+
+void arch_teardown_hwirq(unsigned int irq)
+{
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	unsigned long flags;
+
+	free_remapped_irq(irq);
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	__clear_irq_vector(irq, cfg);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+	free_irq_cfg(irq, cfg);
+}
+
 /*
  * MSI message composition
  */
