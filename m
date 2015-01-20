Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbbATFud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:50:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:16746 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbbATFub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:50:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664447202"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part2 v4 05/33] x86/irq: Kill x86_io_apic_ops.set_affinity and related interfaces
Date: Tue, 20 Jan 2015 13:51:25 +0800
Message-Id: <1421733113-15704-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user of x86_io_apic_ops.set_affinity anymore, so kill
it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-15-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h  |    4 ----
 arch/x86/include/asm/x86_init.h |    3 ---
 arch/x86/kernel/apic/io_apic.c  |   25 +------------------------
 arch/x86/kernel/x86_init.c      |    1 -
 drivers/iommu/irq_remapping.c   |   15 ---------------
 5 files changed, 1 insertion(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index d2a34e4718d2..0ff68daa9949 100644
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
 
 static inline void setup_IO_APIC(void) { }
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 0c690574efae..f9f83cfabcaa 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -191,9 +191,6 @@ struct x86_io_apic_ops {
 	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
-	int		(*set_affinity)(struct irq_data *data,
-					const struct cpumask *mask,
-					bool force);
 	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 769fcd10f217..fff17afdfe5d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1785,29 +1785,6 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
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
@@ -2684,7 +2661,7 @@ void __init setup_ioapic_dest(void)
 		else
 			mask = apic->target_cpus();
 
-		x86_io_apic_ops.set_affinity(idata, mask, false);
+		irq_set_affinity(irq, mask);
 	}
 
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 066cdaa6503e..f7e8eab3a7c4 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -144,6 +144,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.write			= native_io_apic_write,
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
-	.set_affinity		= native_ioapic_set_affinity,
 	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 5bb1a04c91f5..7baa54a13921 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -25,10 +25,6 @@ int no_x2apic_optout;
 static int disable_irq_remap;
 static struct irq_remap_ops *remap_ops;
 
-static int set_remapped_irq_affinity(struct irq_data *data,
-				     const struct cpumask *mask,
-				     bool force);
-
 static bool irq_remapped(struct irq_cfg *cfg)
 {
 	return (cfg->remapped == 1);
@@ -61,7 +57,6 @@ static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
 static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
-	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
 }
 
@@ -157,15 +152,6 @@ int __init irq_remap_enable_fault_handling(void)
 	return remap_ops->enable_faulting();
 }
 
-static int set_remapped_irq_affinity(struct irq_data *data,
-				     const struct cpumask *mask, bool force)
-{
-	if (!config_enabled(CONFIG_SMP) || !remap_ops->set_affinity)
-		return 0;
-
-	return remap_ops->set_affinity(data, mask, force);
-}
-
 void free_remapped_irq(int irq)
 {
 	struct irq_cfg *cfg = irq_cfg(irq);
@@ -201,7 +187,6 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip)
 	chip->irq_print_chip = ir_print_prefix;
 	chip->irq_ack = ir_ack_apic_edge;
 	chip->irq_eoi = ir_ack_apic_level;
-	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
 }
 
 bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
-- 
1.7.10.4

