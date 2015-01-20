Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbbATFuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:50:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:32661 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbbATFuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:50:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664446906"
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
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [Patch Part2 v4 04/33] x86/irq: Kill x86_io_apic_ops.setup_entry and related interfaces
Date: Tue, 20 Jan 2015 13:51:24 +0800
Message-Id: <1421733113-15704-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user of x86_io_apic_ops.setup_entry anymore, so kill it.

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
Link: http://lkml.kernel.org/r/1416901802-24211-14-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h       |    4 ----
 arch/x86/include/asm/irq_remapping.h |   13 -------------
 arch/x86/include/asm/x86_init.h      |    3 ---
 arch/x86/kernel/apic/io_apic.c       |   24 ------------------------
 arch/x86/kernel/x86_init.c           |    1 -
 drivers/iommu/irq_remapping.c        |   13 -------------
 6 files changed, 58 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 47af5a7af358..d2a34e4718d2 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,9 +150,6 @@ struct irq_cfg;
 extern void ioapic_insert_resources(void);
 extern int arch_early_ioapic_init(void);
 
-extern int native_setup_ioapic_entry(int, struct IO_APIC_route_entry *,
-				     unsigned int, int,
-				     struct io_apic_irq_attr *);
 extern void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg);
 
 extern void native_eoi_ioapic_pin(int apic, int pin, int vector);
@@ -289,7 +286,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
 #define native_ioapic_set_affinity	NULL
-#define native_setup_ioapic_entry	NULL
 #define native_eoi_ioapic_pin		NULL
 
 static inline void setup_IO_APIC(void) { }
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 5622a4fc7cd6..0a8edb4af770 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -42,11 +42,6 @@ extern int irq_remapping_enable(void);
 extern void irq_remapping_disable(void);
 extern int irq_remapping_reenable(int);
 extern int irq_remap_enable_fault_handling(void);
-extern int setup_ioapic_remapped_entry(int irq,
-				       struct IO_APIC_route_entry *entry,
-				       unsigned int destination,
-				       int vector,
-				       struct io_apic_irq_attr *attr);
 extern void free_remapped_irq(int irq);
 extern void panic_if_irq_remap(const char *msg);
 extern bool setup_remapped_irq(int irq,
@@ -77,14 +72,6 @@ static inline int irq_remapping_enable(void) { return -ENODEV; }
 static inline void irq_remapping_disable(void) { }
 static inline int irq_remapping_reenable(int eim) { return -ENODEV; }
 static inline int irq_remap_enable_fault_handling(void) { return -ENODEV; }
-static inline int setup_ioapic_remapped_entry(int irq,
-					      struct IO_APIC_route_entry *entry,
-					      unsigned int destination,
-					      int vector,
-					      struct io_apic_irq_attr *attr)
-{
-	return -ENODEV;
-}
 static inline void free_remapped_irq(int irq) { }
 
 static inline void panic_if_irq_remap(const char *msg)
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 2924bc88034a..0c690574efae 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -194,9 +194,6 @@ struct x86_io_apic_ops {
 	int		(*set_affinity)(struct irq_data *data,
 					const struct cpumask *mask,
 					bool force);
-	int		(*setup_entry)(int irq, struct IO_APIC_route_entry *entry,
-				       unsigned int destination, int vector,
-				       struct io_apic_irq_attr *attr);
 	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3d7ac5f82b8d..769fcd10f217 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1294,30 +1294,6 @@ static inline int IO_APIC_irq_trigger(int irq)
 }
 #endif
 
-int native_setup_ioapic_entry(int irq, struct IO_APIC_route_entry *entry,
-			      unsigned int destination, int vector,
-			      struct io_apic_irq_attr *attr)
-{
-	memset(entry, 0, sizeof(*entry));
-
-	entry->delivery_mode = apic->irq_delivery_mode;
-	entry->dest_mode     = apic->irq_dest_mode;
-	entry->dest	     = destination;
-	entry->vector	     = vector;
-	entry->mask	     = 0;			/* enable IRQ */
-	entry->trigger	     = attr->trigger;
-	entry->polarity	     = attr->polarity;
-
-	/*
-	 * Mask level triggered irqs.
-	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
-	 */
-	if (attr->trigger)
-		entry->mask = 1;
-
-	return 0;
-}
-
 static void __init setup_IO_APIC_irqs(void)
 {
 	unsigned int ioapic, pin;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index d6f36c7594d7..066cdaa6503e 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -145,6 +145,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
 	.set_affinity		= native_ioapic_set_affinity,
-	.setup_entry		= native_setup_ioapic_entry,
 	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 558c804dbe11..5bb1a04c91f5 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -62,7 +62,6 @@ static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
-	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
 }
 
@@ -158,18 +157,6 @@ int __init irq_remap_enable_fault_handling(void)
 	return remap_ops->enable_faulting();
 }
 
-int setup_ioapic_remapped_entry(int irq,
-				struct IO_APIC_route_entry *entry,
-				unsigned int destination, int vector,
-				struct io_apic_irq_attr *attr)
-{
-	if (!remap_ops->setup_ioapic_entry)
-		return -ENODEV;
-
-	return remap_ops->setup_ioapic_entry(irq, entry, destination,
-					     vector, attr);
-}
-
 static int set_remapped_irq_affinity(struct irq_data *data,
 				     const struct cpumask *mask, bool force)
 {
-- 
1.7.10.4

