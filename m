Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaIZO4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:56:22 -0400
Received: from mga14.intel.com ([192.55.52.115]:47901 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbaIZO4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292124"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 08/28] x86, irq: Kill x86_io_apic_ops.setup_entry and related interfaces
Date: Fri, 26 Sep 2014 22:57:38 +0800
Message-Id: <1411743478-31435-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user of x86_io_apic_ops.setup_entry anymore, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h       |    4 ----
 arch/x86/include/asm/irq_remapping.h |   13 -------------
 arch/x86/include/asm/x86_init.h      |    3 ---
 arch/x86/kernel/apic/io_apic.c       |   24 ------------------------
 arch/x86/kernel/x86_init.c           |    1 -
 drivers/iommu/irq_remapping.c        |   13 -------------
 6 files changed, 58 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index fb501ec46ee8..f9f316b2ec1e 100644
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
@@ -291,7 +288,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
 #define native_ioapic_set_affinity	NULL
-#define native_setup_ioapic_entry	NULL
 #define native_eoi_ioapic_pin		NULL
 #endif
 
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index de1a5d3277e2..9ed7e2d5fd7d 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -43,11 +43,6 @@ extern int irq_remapping_enable(void);
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
@@ -98,14 +93,6 @@ static inline int irq_remapping_enable(void) { return -ENODEV; }
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
index d49791d2aacf..7de44a329028 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -197,9 +197,6 @@ struct x86_io_apic_ops {
 	int		(*set_affinity)(struct irq_data *data,
 					const struct cpumask *mask,
 					bool force);
-	int		(*setup_entry)(int irq, struct IO_APIC_route_entry *entry,
-				       unsigned int destination, int vector,
-				       struct io_apic_irq_attr *attr);
 	void		(*eoi_ioapic_pin)(int apic, int pin, int vector);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d6df6da203f6..e3628c3b6b07 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1288,30 +1288,6 @@ static inline int IO_APIC_irq_trigger(int irq)
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
index ba5ab975bb5b..77d0ea3dd1ea 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -155,6 +155,5 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
 	.set_affinity		= native_ioapic_set_affinity,
-	.setup_entry		= native_setup_ioapic_entry,
 	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index d72094e01dec..0486a123c29b 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -62,7 +62,6 @@ static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
 	x86_io_apic_ops.set_affinity	= set_remapped_irq_affinity;
-	x86_io_apic_ops.setup_entry	= setup_ioapic_remapped_entry;
 	x86_io_apic_ops.eoi_ioapic_pin	= eoi_ioapic_pin_remapped;
 }
 
@@ -177,18 +176,6 @@ int __init irq_remap_enable_fault_handling(void)
 	return remap_ops->enable_faulting();
 }
 
-int setup_ioapic_remapped_entry(int irq,
-				struct IO_APIC_route_entry *entry,
-				unsigned int destination, int vector,
-				struct io_apic_irq_attr *attr)
-{
-	if (!remap_ops || !remap_ops->setup_ioapic_entry)
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

