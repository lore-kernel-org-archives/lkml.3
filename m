Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaLEIsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:48:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:34019 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaLEIsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:48:35 -0500
Message-Id: <20141205084147.313026156@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 05 Dec 2014 08:48:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: [patch 3/5] iommu/vt-d: Move iommu preparatory allocations to
 irq_remap_ops.prepare
References: <20141204234737.728961990@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=iommu-intel-remap-move-domain-setup.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole iommu setup for irq remapping is a convoluted mess. The
iommu detect function gets called from mem_init() and the prepare
callback gets called from enable_IR_x2apic() for unknown reasons.

Of course AMD and Intel setup differs in nonsensical ways. Intels
prepare callback is explicit while AMDs prepare callback is implicit
in setup_irq_remapping_ops() just to be called in the prepare call
again.

Because all of this gets called from enable_IR_x2apic() and the dmar
prepare function merily parses the ACPI tables, but does not allocate
memory we end up with memory allocation from irq disabled context
later on.

AMDs iommu code at least allocates the required memory from the
prepare function. That has issues as well, but thats not scope of this
patch.

The goal of this change is to distangle the allocation from the actual
enablement. There is no point to allocate memory from irq disabled
regions with GFP_ATOMIC just because it does not matter at that point
in the boot stage. It matters with physical hotplug later on.

There is another issue with the current setup. Due to the conversion
to stacked irqdomains we end up with a call into the irqdomain
allocation code from irq disabled context, but that code does
GFP_KERNEL allocations rightfully as there is no reason to do
preperatory allocations with GFP_ATOMIC.

That change caused the allocator code to complain about GFP_KERNEL
allocations invoked in atomic context. Boris provided a temporary
hackaround which changed the GFP flags if irq_domain_add() got called
from atomic context. Not pretty and we really dont want to get this
into a mainline release for obvious reasons.

Move the ACPI table parsing and the resulting memory allocations from
the enable to the prepare function. That allows to get rid of the
horrible hackaround in irq_domain_add() later.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/iommu/intel_irq_remapping.c |   64 ++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 20 deletions(-)

Index: tip/drivers/iommu/intel_irq_remapping.c
===================================================================
--- tip.orig/drivers/iommu/intel_irq_remapping.c
+++ tip/drivers/iommu/intel_irq_remapping.c
@@ -539,22 +539,57 @@ static int __init intel_irq_remapping_su
 	return 1;
 }
 
-static int __init intel_enable_irq_remapping(void)
+static void __init intel_cleanup_irq_remapping(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+
+	for_each_iommu(iommu, drhd) {
+		if (ecap_ir_support(iommu->ecap)) {
+			iommu_disable_irq_remapping(iommu);
+			intel_teardown_irq_remapping(iommu);
+		}
+	}
+
+	if (x2apic_supported())
+		pr_warn("Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
+}
+
+static int __init intel_prepare_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
-	bool x2apic_present;
-	int setup = 0;
-	int eim = 0;
 
-	x2apic_present = x2apic_supported();
+	if (dmar_table_init() < 0)
+		return -1;
 
 	if (parse_ioapics_under_ir() != 1) {
-		printk(KERN_INFO "Not enable interrupt remapping\n");
+		printk(KERN_INFO "Not enabling interrupt remapping\n");
 		goto error;
 	}
 
-	if (x2apic_present) {
+	for_each_iommu(iommu, drhd) {
+		if (!ecap_ir_support(iommu->ecap))
+			continue;
+
+		/* Do the allocations early */
+		if (intel_setup_irq_remapping(iommu))
+			goto error;
+	}
+	return 0;
+error:
+	intel_cleanup_irq_remapping();
+	return -1;
+}
+
+static int __init intel_enable_irq_remapping(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	int setup = 0;
+	int eim = 0;
+
+	if (x2apic_supported()) {
 		pr_info("Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
 
 		eim = !dmar_x2apic_optout();
@@ -622,9 +657,6 @@ static int __init intel_enable_irq_remap
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
-		if (intel_setup_irq_remapping(iommu))
-			goto error;
-
 		iommu_set_irq_remapping(iommu, eim);
 		setup = 1;
 	}
@@ -639,15 +671,7 @@ static int __init intel_enable_irq_remap
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
 
 error:
-	for_each_iommu(iommu, drhd)
-		if (ecap_ir_support(iommu->ecap)) {
-			iommu_disable_irq_remapping(iommu);
-			intel_teardown_irq_remapping(iommu);
-		}
-
-	if (x2apic_present)
-		pr_warn("Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
-
+	intel_cleanup_irq_remapping();
 	return -1;
 }
 
@@ -947,7 +971,7 @@ static struct irq_domain *intel_get_irq_
 
 struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_irq_remapping_supported,
-	.prepare		= dmar_table_init,
+	.prepare		= intel_prepare_irq_remapping,
 	.enable			= intel_enable_irq_remapping,
 	.disable		= disable_irq_remapping,
 	.reenable		= reenable_irq_remapping,


