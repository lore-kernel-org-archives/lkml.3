Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbbAGHaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:30:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:2508 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbbAGHaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:30:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665634160"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Beulich <JBeulich@suse.com>, Richard Weinberger <richard@nod.at>,
        Oren Twaig <oren@scalemp.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [Patch v2 13/16] iommu/irq_remapping: Kill function irq_remapping_supported() and related code
Date: Wed,  7 Jan 2015 15:31:40 +0800
Message-Id: <1420615903-28253-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify irq_remapping code by killing irq_remapping_supported() and
related interfaces.

Joerg posted a similar patch at https://lkml.org/lkml/2014/12/15/490,
so assume an signed-off from Joerg.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
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
index f1b619e5a50d..6224d316c405 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -33,7 +33,6 @@ struct irq_cfg;
 
 #ifdef CONFIG_IRQ_REMAP
 
-extern int irq_remapping_supported(void);
 extern void set_irq_remapping_broken(void);
 extern int irq_remapping_prepare(void);
 extern int irq_remapping_enable(void);
@@ -59,7 +58,6 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
 #else  /* CONFIG_IRQ_REMAP */
 
-static inline int irq_remapping_supported(void) { return 0; }
 static inline void set_irq_remapping_broken(void) { }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
 static inline int irq_remapping_enable(void) { return -ENODEV; }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d714e72ed6d5..a526abd51c24 100644
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
index 98024856df07..59de6364a910 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4284,7 +4284,6 @@ static int alloc_hpet_msi(unsigned int irq, unsigned int id)
 }
 
 struct irq_remap_ops amd_iommu_irq_ops = {
-	.supported		= amd_iommu_supported,
 	.prepare		= amd_iommu_prepare,
 	.enable			= amd_iommu_enable,
 	.disable		= amd_iommu_disable,
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 0039f87f48b8..970979ecbebb 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2129,11 +2129,6 @@ int __init amd_iommu_prepare(void)
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
index 95ed6deae47f..861af9d8338a 100644
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
index 9d67c12c2ffb..fb72bd5f438c 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -567,11 +567,6 @@ static int __init dmar_x2apic_optout(void)
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
@@ -1216,7 +1211,6 @@ static int intel_alloc_hpet_msi(unsigned int irq, unsigned int id)
 }
 
 struct irq_remap_ops intel_irq_remap_ops = {
-	.supported		= intel_irq_remapping_supported,
 	.prepare		= intel_prepare_irq_remapping,
 	.enable			= intel_enable_irq_remapping,
 	.disable		= disable_irq_remapping,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 91d5884d3ed9..e7449b42504d 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -199,19 +199,11 @@ void set_irq_remapping_broken(void)
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
index fde250f86e60..a8edfea0ab5d 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -38,9 +38,6 @@ extern int no_x2apic_optout;
 extern int irq_remapping_enabled;
 
 struct irq_remap_ops {
-	/* Check whether Interrupt Remapping is supported */
-	int (*supported)(void);
-
 	/* Initializes hardware and makes it ready for remapping interrupts */
 	int  (*prepare)(void);
 
-- 
1.7.10.4

