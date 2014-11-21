Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaKUWIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:08:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaKUWIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:08:51 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/3] PCI/x86: Add arch_supports_multivector_msi() hook
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        iommu@lists.linux-foundation.org
Date: Fri, 21 Nov 2014 15:08:40 -0700
Message-ID: <20141121220839.31095.64245.stgit@gimli.home>
In-Reply-To: <20141121213752.31095.30735.stgit@gimli.home>
References: <20141121213752.31095.30735.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 does support multivector MSI, but only when using interrupt
remapping.  Extend x86_msi_ops to add an optional callback for
this and assume unsupported when not present.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/x86_init.c      |    6 ++++++
 drivers/iommu/irq_remapping.c   |    6 ++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index e45e4da..28951c6 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -185,6 +185,7 @@ struct x86_msi_ops {
 	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
 	u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
 	u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
+	bool (*supports_multivector)(struct pci_dev *dev);
 };
 
 struct IO_APIC_route_entry;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index e48b674..d917410 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -148,6 +148,12 @@ u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag)
 {
 	return x86_msi.msix_mask_irq(desc, flag);
 }
+bool arch_supports_multivector_msi(struct pci_dev *dev)
+{
+	if (x86_msi.supports_multivector)
+		return x86_msi.supports_multivector(dev);
+	return false;
+}
 #endif
 
 struct x86_io_apic_ops x86_io_apic_ops = {
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 74a1767..4310bfb 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -160,6 +160,11 @@ static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
 	io_apic_eoi(apic, pin);
 }
 
+static bool remapped_supports_multivector(struct pci_dev *dev)
+{
+	return true;
+}
+
 static void __init irq_remapping_modify_x86_ops(void)
 {
 	x86_io_apic_ops.disable		= irq_remapping_disable_io_apic;
@@ -169,6 +174,7 @@ static void __init irq_remapping_modify_x86_ops(void)
 	x86_msi.setup_msi_irqs		= irq_remapping_setup_msi_irqs;
 	x86_msi.setup_hpet_msi		= setup_hpet_msi_remapped;
 	x86_msi.compose_msi_msg		= compose_remapped_msi_msg;
+	x86_msi.supports_multivector	= remapped_supports_multivector;
 }
 
 static __init int setup_nointremap(char *str)

