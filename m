Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbbAOM7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:59:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49945 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbbAOM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:59:53 -0500
Date: Thu, 15 Jan 2015 04:58:23 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a1dafe857db56c35878c71560089a4694ac841fd@git.kernel.org>
Cc: JBeulich@suse.com, tony.luck@intel.com, jroedel@suse.de,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        rientjes@google.com, yinghai@kernel.org, hpa@zytor.com,
        benh@kernel.crashing.org, d.hatayama@jp.fujitsu.com, bp@alien8.de,
        hpa@linux.intel.com, richard@nod.at, tglx@linutronix.de,
        joro@8bytes.org, mingo@kernel.org, oren@scalemp.com
Reply-To: JBeulich@suse.com, jroedel@suse.de, tony.luck@intel.com,
        jiang.liu@linux.intel.com, rientjes@google.com,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        benh@kernel.crashing.org, hpa@zytor.com, oren@scalemp.com,
        mingo@kernel.org, tglx@linutronix.de, joro@8bytes.org,
        hpa@linux.intel.com, richard@nod.at, bp@alien8.de,
        d.hatayama@jp.fujitsu.com
In-Reply-To: <1420615903-28253-2-git-send-email-jiang.liu@linux.intel.com>
References: <20141205084147.232633738@linutronix.de>
	<1420615903-28253-2-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu, x86:
  Restructure setup of the irq remapping feature
Git-Commit-ID: a1dafe857db56c35878c71560089a4694ac841fd
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

Commit-ID:  a1dafe857db56c35878c71560089a4694ac841fd
Gitweb:     http://git.kernel.org/tip/a1dafe857db56c35878c71560089a4694ac841fd
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 Jan 2015 15:31:28 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Jan 2015 11:24:22 +0100

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
Acked-and-tested-by: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: Joerg Roedel <jroedel@suse.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Oren Twaig <oren@scalemp.com>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20141205084147.232633738@linutronix.de
Link: http://lkml.kernel.org/r/1420615903-28253-2-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irq_remapping.h |  2 --
 arch/x86/kernel/apic/apic.c          |  3 ---
 drivers/iommu/irq_remapping.c        | 19 +++++++------------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index b7747c4..f1b619e 100644
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
index 89c4846..91d5884d 100644
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
 
