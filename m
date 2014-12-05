Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaLEX0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:26:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaLEX0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:26:18 -0500
Date: Fri, 5 Dec 2014 15:25:52 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-e88edbd316eae8086b2afddbdd98b144ed692a32@git.kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiang.liu@linux.intel.com, joro@8bytes.org, tglx@linutronix.de,
        bp@alien8.de
Reply-To: joro@8bytes.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        hpa@zytor.com, jiang.liu@linux.intel.com, tglx@linutronix.de,
        bp@alien8.de
In-Reply-To: <20141205084147.232633738@linutronix.de>
References: <20141205084147.232633738@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu, x86:
  Restructure setup of the irq remapping feature
Git-Commit-ID: e88edbd316eae8086b2afddbdd98b144ed692a32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e88edbd316eae8086b2afddbdd98b144ed692a32
Gitweb:     http://git.kernel.org/tip/e88edbd316eae8086b2afddbdd98b144ed692a32
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 5 Dec 2014 08:48:31 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 6 Dec 2014 00:19:25 +0100

iommu, x86: Restructure setup of the irq remapping feature

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
---
 arch/x86/include/asm/irq_remapping.h |  2 --
 arch/x86/kernel/apic/apic.c          |  3 ---
 drivers/iommu/irq_remapping.c        | 19 +++++++------------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 6ba2431..ab3bd0f 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -31,7 +31,6 @@ struct irq_alloc_info;
 
 #ifdef CONFIG_IRQ_REMAP
 
-extern void setup_irq_remapping_ops(void);
 extern int irq_remapping_supported(void);
 extern void set_irq_remapping_broken(void);
 extern int irq_remapping_prepare(void);
@@ -58,7 +57,6 @@ static inline struct irq_domain *arch_get_ir_parent_domain(void)
 
 #else  /* CONFIG_IRQ_REMAP */
 
-static inline void setup_irq_remapping_ops(void) { }
 static inline int irq_remapping_supported(void) { return 0; }
 static inline void set_irq_remapping_broken(void) { }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 29b5b18..141f103 100644
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
index 3c3da04d..66517e7 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -75,16 +75,6 @@ static __init int setup_irqremap(char *str)
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
@@ -103,9 +93,14 @@ int irq_remapping_supported(void)
 
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
 
