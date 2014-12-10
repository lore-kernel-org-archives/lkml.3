Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbaLJGpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:45:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:21063 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705AbaLJGpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:45:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,550,1413270000"; 
   d="scan'208";a="645283322"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Beulich <JBeulich@suse.com>, Richard Weinberger <richard@nod.at>,
        Oren Twaig <oren@scalemp.com>
Cc: Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC Patch V1 5/9] iommu/irq_remapping: Kill function irq_remapping_supported() and related code
Date: Wed, 10 Dec 2014 14:47:47 +0800
Message-Id: <1418194071-13785-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify irq_remapping code by killing irq_remapping_supported() and
related interfaces.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |    2 --
 arch/x86/kernel/apic/apic.c          |    7 +------
 drivers/iommu/amd_iommu.c            |    1 -
 drivers/iommu/amd_iommu_init.c       |    5 -----
 drivers/iommu/amd_iommu_proto.h      |    1 -
 drivers/iommu/intel_irq_remapping.c  |    6 ------
 drivers/iommu/irq_remapping.c        |   12 ++----------
 drivers/iommu/irq_remapping.h        |    3 ---
 8 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index ab3bd0f54ba9..f2f52a8bb14e 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -31,7 +31,6 @@ struct irq_alloc_info;
 
 #ifdef CONFIG_IRQ_REMAP
 
-extern int irq_remapping_supported(void);
 extern void set_irq_remapping_broken(void);
 extern int irq_remapping_prepare(void);
 extern int irq_remapping_enable(void);
@@ -57,7 +56,6 @@ static inline struct irq_domain *arch_get_ir_parent_domain(void)
 
 #else  /* CONFIG_IRQ_REMAP */
 
-static inline int irq_remapping_supported(void) { return 0; }
 static inline void set_irq_remapping_broken(void) { }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
 static inline int irq_remapping_enable(void) { return -ENODEV; }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2a9bac837be4..4549695b8df0 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1574,12 +1574,7 @@ void enable_x2apic(void)
 
 static int __init try_to_enable_IR(void)
 {
-#ifdef CONFIG_IRQ_REMAP
-	if (!irq_remapping_supported()) {
-		pr_debug("intr-remapping not supported\n");
-		return -1;
-	}
-
+#ifdef CONFIG_X86_IO_APIC
 	if (!x2apic_enabled() && skip_ioapic_setup) {
 		pr_info("Skipped enabling intr-remap because of skipping "
 			"io-apic setup\n");
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a5c59b434c77..05ffb7c8bfe3 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4114,7 +4114,6 @@ static struct irq_domain *get_irq_domain(struct irq_alloc_info *info)
 }
 
 struct irq_remap_ops amd_iommu_irq_ops = {
-	.supported		= amd_iommu_supported,
 	.prepare		= amd_iommu_prepare,
 	.enable			= amd_iommu_enable,
 	.disable		= amd_iommu_disable,
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index de3390a7d345..fc047a4ee661 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2130,11 +2130,6 @@ int __init amd_iommu_prepare(void)
 	return iommu_go_to_state(IOMMU_ACPI_FINISHED);
 }
 
-int __init amd_iommu_supported(void)
-{
-	return amd_iommu_irq_remap ? 1 : 0;
-}
-
 int __init amd_iommu_enable(void)
 {
 	int ret;
diff --git a/drivers/iommu/amd_iommu_proto.h b/drivers/iommu/amd_iommu_proto.h
index 612a22192fa0..fcf61cae53d6 100644
--- a/drivers/iommu/amd_iommu_proto.h
+++ b/drivers/iommu/amd_iommu_proto.h
@@ -33,7 +33,6 @@ extern void amd_iommu_init_notifier(void);
 extern void amd_iommu_init_api(void);
 
 /* Needed for interrupt remapping */
-extern int amd_iommu_supported(void);
 extern int amd_iommu_prepare(void);
 extern int amd_iommu_enable(void);
 extern void amd_iommu_disable(void);
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 9e102168d8ae..c2255927766b 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -510,11 +510,6 @@ static int __init dmar_x2apic_optout(void)
 	return dmar->flags & DMAR_X2APIC_OPT_OUT;
 }
 
-static int __init intel_irq_remapping_supported(void)
-{
-	return 1;
-}
-
 static void __init intel_cleanup_irq_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -958,7 +953,6 @@ static struct irq_domain *intel_get_irq_domain(struct irq_alloc_info *info)
 }
 
 struct irq_remap_ops intel_irq_remap_ops = {
-	.supported		= intel_irq_remapping_supported,
 	.prepare		= intel_prepare_irq_remapping,
 	.enable			= intel_enable_irq_remapping,
 	.disable		= disable_irq_remapping,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 66517e7d42f0..2d75f0d69b76 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -80,19 +80,11 @@ void set_irq_remapping_broken(void)
 	irq_remap_broken = 1;
 }
 
-int irq_remapping_supported(void)
+int __init irq_remapping_prepare(void)
 {
 	if (disable_irq_remap)
-		return 0;
-
-	if (!remap_ops || !remap_ops->supported)
-		return 0;
+		return -ENOSYS;
 
-	return remap_ops->supported();
-}
-
-int __init irq_remapping_prepare(void)
-{
 	remap_ops = &intel_irq_remap_ops;
 
 #ifdef CONFIG_AMD_IOMMU
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 4bd791d72e5e..961dc49305e1 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -36,9 +36,6 @@ extern int no_x2apic_optout;
 extern int irq_remapping_enabled;
 
 struct irq_remap_ops {
-	/* Check whether Interrupt Remapping is supported */
-	int (*supported)(void);
-
 	/* Initializes hardware and makes it ready for remapping interrupts */
 	int  (*prepare)(void);
 
-- 
1.7.10.4

