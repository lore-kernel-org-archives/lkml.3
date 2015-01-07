Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbbAGH26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:28:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:61533 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbbAGH24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:28:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665633565"
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
Subject: [Patch v2 01/16] iommu, x86: Restructure setup of the irq remapping feature
Date: Wed,  7 Jan 2015 15:31:28 +0800
Message-Id: <1420615903-28253-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

enable_IR_x2apic() calls setup_irq_remapping_ops() which by default
installs the intel dmar remapping ops and then calls the amd iommu irq
remapping prepare callback to figure out whether we are running on an
AMD machine with irq remapping hardware.

Right after that it calls irq_remapping_prepare() which pointlessly
checks:
	if (!remap_ops || !remap_ops->prepare)
               return -ENODEV;
and then calls

    remap_ops->prepare()

which is silly in the AMD case as it got called from
setup_irq_remapping_ops() already a few microseconds ago.

Simplify this and just collapse everything into
irq_remapping_prepare().

The irq_remapping_prepare() remains still silly as it assigns blindly
the intel ops, but that's not scope of this patch.

The scope here is to move the preperatory work, i.e. memory
allocations out of the atomic section which is required to enable irq
remapping.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Borislav Petkov <bp@alien8.de>
Acked-by: Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141205084147.232633738@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |    2 --
 arch/x86/kernel/apic/apic.c          |    3 ---
 drivers/iommu/irq_remapping.c        |   19 +++++++------------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index b7747c4c2cf2..f1b619e5a50d 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -33,7 +33,6 @@ struct irq_cfg;
 
 #ifdef CONFIG_IRQ_REMAP
 
-extern void setup_irq_remapping_ops(void);
 extern int irq_remapping_supported(void);
 extern void set_irq_remapping_broken(void);
 extern int irq_remapping_prepare(void);
@@ -60,7 +59,6 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip);
 
 #else  /* CONFIG_IRQ_REMAP */
 
-static inline void setup_irq_remapping_ops(void) { }
 static inline int irq_remapping_supported(void) { return 0; }
 static inline void set_irq_remapping_broken(void) { }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 71b8a6cb7f0e..36249c715da0 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1597,9 +1597,6 @@ void __init enable_IR_x2apic(void)
 	int ret, x2apic_enabled = 0;
 	int hardware_init_ret;
 
-	/* Make sure irq_remap_ops are initialized */
-	setup_irq_remapping_ops();
-
 	hardware_init_ret = irq_remapping_prepare();
 	if (hardware_init_ret && !x2apic_supported())
 		return;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 89c4846683be..91d5884d3ed9 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -194,16 +194,6 @@ static __init int setup_irqremap(char *str)
 }
 early_param("intremap", setup_irqremap);
 
-void __init setup_irq_remapping_ops(void)
-{
-	remap_ops = &intel_irq_remap_ops;
-
-#ifdef CONFIG_AMD_IOMMU
-	if (amd_iommu_irq_ops.prepare() == 0)
-		remap_ops = &amd_iommu_irq_ops;
-#endif
-}
-
 void set_irq_remapping_broken(void)
 {
 	irq_remap_broken = 1;
@@ -222,9 +212,14 @@ int irq_remapping_supported(void)
 
 int __init irq_remapping_prepare(void)
 {
-	if (!remap_ops || !remap_ops->prepare)
-		return -ENODEV;
+	remap_ops = &intel_irq_remap_ops;
 
+#ifdef CONFIG_AMD_IOMMU
+	if (amd_iommu_irq_ops.prepare() == 0) {
+		remap_ops = &amd_iommu_irq_ops;
+		return 0;
+	}
+#endif
 	return remap_ops->prepare();
 }
 
-- 
1.7.10.4

