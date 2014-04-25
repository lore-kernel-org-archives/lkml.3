Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaDYBgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:36:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:62703 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbaDYBgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:36:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,923,1389772800"; 
   d="scan'208";a="527012031"
From: Jason Chen <jason.cj.chen@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Jason Chen <jason.cj.chen@intel.com>
Subject: [PATCH 1/1] x86/apic: add apic_irqs bitmap to identify irqs from apic
Date: Fri, 25 Apr 2014 09:30:52 +0800
Message-Id: <de1f9f2834ba87e3ceba9e4d413f949397a83397.1398418448.git.jason.cj.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During irq migration, fixup_irqs() in arch/x86/kernel/irq.c will
call irq_force_complete_move() for every valid irqs, including
whose irq_chip is not apic(like ioapic_chip, msi_chip, etc) kind.

While the function irq_force_complete_move() in
arch/x86/kernel/apic/io_apic.c will treat all input irqs as apic
kind, which has the structure irq_cfg as its chip_data and with
chance to be modified.

During supporting intel MID platform, some new irq_chip were added
like gpio, whose sub-irqs are valid and will call
irq_force_complete_move(). We met one softlockup/hardlockup issue
while adding a new pmic irq_chip, whose chip_data's value condition
triggered IPI send for clean up vector when miss calling
irq_force_complete_move(),  then one lock field in its chip_data
was unexpected modified.

This patch add an apic_irqs bitmap to identify irqs from apic
irq_chip, this bitmap only be set when apic kind of irq try to
assign_irq_vector, and clear when __clear_irq_vector.
By checking apic_irqs bitmap, irq_force_complete_move() can avoid
being called when input irq does not belong to apic kind of irq_chip.

Signed-off-by: Jason Chen <jason.cj.chen@intel.com>
---
 arch/x86/kernel/apic/io_apic.c | 21 ++++++++++++++++++++-
 include/linux/irqdesc.h        |  6 ++++++
 kernel/irq/internals.h         |  6 ------
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658..1e2bcb5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -37,6 +37,7 @@
 #include <linux/kthread.h>
 #include <linux/jiffies.h>	/* time_after() */
 #include <linux/slab.h>
+#include <linux/irqdesc.h>
 #include <linux/bootmem.h>
 #include <linux/dmar.h>
 #include <linux/hpet.h>
@@ -74,6 +75,8 @@ int sis_apic_bug = -1;
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
 
+static DECLARE_BITMAP(apic_irqs, IRQ_BITMAP_BITS);
+
 static struct ioapic {
 	/*
 	 * # of IRQ routing registers
@@ -1158,6 +1161,10 @@ next:
 		err = 0;
 		break;
 	}
+
+	if (err == 0)
+		set_bit(irq, apic_irqs);
+
 	free_cpumask_var(tmp_mask);
 	return err;
 }
@@ -1185,6 +1192,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 
 	cfg->vector = 0;
 	cpumask_clear(cfg->domain);
+	clear_bit(irq, apic_irqs);
 
 	if (likely(!cfg->move_in_progress))
 		return;
@@ -1213,6 +1221,9 @@ void __setup_vector_irq(int cpu)
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_active_irq(irq) {
+		if (!test_bit(irq, apic_irqs))
+			continue;
+
 		cfg = irq_get_chip_data(irq);
 		if (!cfg)
 			continue;
@@ -2268,7 +2279,12 @@ static void irq_complete_move(struct irq_cfg *cfg)
 
 void irq_force_complete_move(int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg;
+
+	if (!test_bit(irq, apic_irqs))
+		return;
+
+	cfg = irq_get_chip_data(irq);
 
 	if (!cfg)
 		return;
@@ -2541,6 +2557,9 @@ static inline void init_IO_APIC_traps(void)
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for_each_active_irq(irq) {
+		if (!test_bit(irq, apic_irqs))
+			continue;
+
 		cfg = irq_get_chip_data(irq);
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 26e2661..1b20979 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -1,6 +1,12 @@
 #ifndef _LINUX_IRQDESC_H
 #define _LINUX_IRQDESC_H
 
+#ifdef CONFIG_SPARSE_IRQ
+# define IRQ_BITMAP_BITS	(NR_IRQS + 8196)
+#else
+# define IRQ_BITMAP_BITS	NR_IRQS
+#endif
+
 /*
  * Core internal functions to deal with irq descriptors
  *
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index ddf1ffe..b2fb994 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -8,12 +8,6 @@
 #include <linux/irqdesc.h>
 #include <linux/kernel_stat.h>
 
-#ifdef CONFIG_SPARSE_IRQ
-# define IRQ_BITMAP_BITS	(NR_IRQS + 8196)
-#else
-# define IRQ_BITMAP_BITS	NR_IRQS
-#endif
-
 #define istate core_internal_state__do_not_mess_with_it
 
 extern bool noirqdebug;
-- 
1.8.1.2

