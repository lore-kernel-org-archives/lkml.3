Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaKHSOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:14:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:14485 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaKHSOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:14:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533683"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part3 v3 14/38] x86, irq: Kill x86_io_apic_ops.set_affinity and related interfaces
Date: Sun,  9 Nov 2014 02:13:14 +0800
Message-Id: <1415470418-10874-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user of x86_io_apic_ops.set_affinity anymore, so kill
it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h  |    4 ----
 arch/x86/include/asm/x86_init.h |    3 ---
 arch/x86/kernel/apic/io_apic.c  |   25 +------------------------
 arch/x86/kernel/x86_init.c      |    1 -
 drivers/iommu/irq_remapping.c   |   16 ----------------
 5 files changed, 1 insertion(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0c66c4759987..5fba350fec1f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -222,9 +222,6 @@ extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
 extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_disable_io_apic(void);
-extern int native_ioapic_set_affinity(struct irq_data *,
-				      const struct cpumask *,
-				      bool);
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
@@ -285,7 +282,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_write		NULL
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
-#define native_ioapic_set_affinity	NULL
 #define native_eoi_ioapic_pin		NULL
 #endif
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 7de44a329028..2637e8fb978d 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -194,9 +194,6 @@ struct x86_io_apic_ops {
 	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
-	int		(*set_affinity)(struct irq_data *data,
-					const struct cpumask *mask,
-					bool force);
 	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c862f8299a3f..26fa504b57f6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1777,29 +1777,6 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 	}
 }
 
-int native_ioapic_set_affinity(struct irq_data *data,
-			       const struct cpumask *mask,
-			       bool force)
-{
-	unsigned int dest, irq = data->irq;
-	unsigned long flags;
-	int ret;
-
-	if (!config_enabled(CONFIG_SMP))
-		return -EPERM;
-
-	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	ret = apic_set_affinity(data, mask, &dest);
-	if (!ret) {
-		/* Only the high 8 bits are valid. */
-		dest = SET_APIC_LOGICAL_ID(dest);
-		__target_IO_APIC_irq(irq, dest, irqd_cfg(data));
-		ret = IRQ_SET_MASK_OK_NOCOPY;
-	}
-	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-	return ret;
-}
-
 atomic_t irq_mis_count;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
@@ -2676,7 +2653,7 @@ void __init setup_ioapic_dest(void)
 		else
 			mask = apic->target_cpus();
 
-		x86_io_apic_ops.set_affinity(idata, mask, false);
+		irq_set_affinity(irq, mask);
 	}
 
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 77d0ea3dd1ea..377b22008280 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -154,6 +154,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.write			= native_io_apic_write,
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
-	.set_affinity		= native_ioapic_set_affinity,
 	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index c66de7848619..0e2a80491170 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -26,10 +26,6 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
-static int set_remapped_irq_affinity(struct irq_data *data,
-				     const struct cpumask *mask,
-				     bool force);
-
 static bool irq_remapped(struct irq_cfg *cfg)
 {
 	return (cfg->remapped == 1);
@@ -62,7 +58,6 @@ static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
 static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
-	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
 }
 
@@ -177,16 +172,6 @@ int __init irq_remap_enable_fault_handling(void)
 	return remap_ops->enable_faulting();
 }
 
-static int set_remapped_irq_affinity(struct irq_data *data,
-				     const struct cpumask *mask, bool force)
-{
-	if (!config_enabled(CONFIG_SMP) || !remap_ops ||
-	    !remap_ops->set_affinity)
-		return 0;
-
-	return remap_ops->set_affinity(data, mask, force);
-}
-
 void free_remapped_irq(int irq)
 {
 	struct irq_cfg *cfg = irq_cfg(irq);
@@ -238,7 +223,6 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
 	chip->irq_eoi = ir_ack_apic_level;
-	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
 }
 
 bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
-- 
1.7.10.4

