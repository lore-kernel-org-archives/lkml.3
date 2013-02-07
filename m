Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab3BGDIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:08:43 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35595 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab3BGDIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:08:39 -0500
From: Andy Lutomirski <luto@amacapital.net>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] intel_iommu: Disable vfio and kvm interrupt assignment when unsafe
Date: Wed,  6 Feb 2013 19:08:24 -0800
Message-Id: <5fc782f401fc7bb0cd829b2316d7f29eb2595036.1360206266.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently report IOMMU_CAP_INTR_REMAP whenever interrupt remapping
is enabled.  Users of that capability expect it to mean that remapping
is secure (i.e. compatibility format interrupts are blocked).  Explicitly
check whether CFIs are blocked and, if not, don't report the capability.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

This applies on top of my previous patch:

http://git.kernel.org/tip/af8d102f999a41c0189bd2cce488bac2ee88c29b

This is poorly tested.  My x2apic-opted-out server boots and appears
to work.  My x2apic-supporting server is busy doing production
things, so I can't reboot it to test.  I don't have anything that
uses vfio or kvm device assignment.

 drivers/iommu/intel-iommu.c         |  9 +++++++--
 drivers/iommu/intel_irq_remapping.c | 25 ++++++++++++++-----------
 include/linux/intel-iommu.h         |  7 +++++++
 3 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c2c07a4..b764117 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4129,8 +4129,13 @@ static int intel_iommu_domain_has_cap(struct iommu_domain *domain,
 
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
 		return dmar_domain->iommu_snooping;
-	if (cap == IOMMU_CAP_INTR_REMAP)
-		return irq_remapping_enabled;
+	if (cap == IOMMU_CAP_INTR_REMAP) {
+		/*
+		 * This could be per-domain, but unless something's wrong,
+		 * we should have CFIs blocked on all domains.
+		 */
+		return irq_remapping_enabled && irq_remapping_is_secure;
+	}
 
 	return 0;
 }
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index eca8832..c7eda74 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -37,6 +37,7 @@ struct hpet_scope {
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static struct hpet_scope ir_hpet[MAX_HPET_TBS];
 static int ir_ioapic_num, ir_hpet_num;
+bool irq_remapping_is_secure;
 
 static DEFINE_RAW_SPINLOCK(irq_2_ir_lock);
 
@@ -436,10 +437,15 @@ static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
 	 * protected from dangerous (i.e. compatibility) interrupts
 	 * regardless of x2apic status.  Check just to be sure.
 	 */
-	if (sts & DMA_GSTS_CFIS)
+	if (sts & DMA_GSTS_CFIS) {
+		/* This should not happen unless the hardware is broken. */
 		WARN(1, KERN_WARNING
-			"Compatibility-format IRQs enabled despite intr remapping;\n"
-			"you are vulnerable to IRQ injection.\n");
+			"Failed to block compatibility format interrupts.\n");
+		iommu->cfi_blocked = false;
+	} else {
+		/* We are now secure against irq injection attack. */
+		iommu->cfi_blocked = true;
+	}
 
 	raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
@@ -537,18 +543,15 @@ static int __init intel_irq_remapping_supported(void)
 static int __init intel_enable_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
-	bool x2apic_present;
 	int setup = 0;
 	int eim = 0;
 
-	x2apic_present = x2apic_supported();
-
 	if (parse_ioapics_under_ir() != 1) {
 		printk(KERN_INFO "Not enable interrupt remapping\n");
 		goto error;
 	}
 
-	if (x2apic_present) {
+	if (x2apic_supported()) {
 		eim = !dmar_x2apic_optout();
 		if (!eim)
 			printk(KERN_WARNING
@@ -616,6 +619,7 @@ static int __init intel_enable_irq_remapping(void)
 	/*
 	 * Setup Interrupt-remapping for all the DRHD's now.
 	 */
+	irq_remapping_is_secure = 1;
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
 
@@ -624,6 +628,8 @@ static int __init intel_enable_irq_remapping(void)
 
 		if (intel_setup_irq_remapping(iommu, eim))
 			goto error;
+		if (!iommu->cfi_blocked)
+			irq_remapping_is_secure = 0;
 
 		setup = 1;
 	}
@@ -641,10 +647,7 @@ error:
 	 * handle error condition gracefully here!
 	 */
 
-	if (x2apic_present)
-		WARN(1, KERN_WARNING
-			"Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
-
+	irq_remapping_is_secure = 0;
 	return -1;
 }
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 78e2ada..85cb711 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -333,6 +333,7 @@ struct intel_iommu {
 
 #ifdef CONFIG_IRQ_REMAP
 	struct ir_table *ir_table;	/* Interrupt remapping info */
+	bool cfi_blocked;
 #endif
 	int		node;
 };
@@ -365,4 +366,10 @@ extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
 extern int dmar_ir_support(void);
 
+#ifdef CONFIG_IRQ_REMAP
+extern bool irq_remapping_is_secure;  /* Do all iommus block CFI? */
+#else
+#define irq_remapping_is_secure 0
+#endif
+
 #endif
-- 
1.8.1

