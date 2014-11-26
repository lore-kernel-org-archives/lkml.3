Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaKZXIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:08:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58151 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaKZXIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:08:19 -0500
Date: Wed, 26 Nov 2014 15:07:29 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-7f35ca7e7693ae7eb049a83a116065784d73a2f2@git.kernel.org>
Cc: tony.luck@intel.com, mingo@kernel.org, gregkh@linuxfoundation.org,
        joro@8bytes.org, rjw@rjwysocki.net, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, rdunlap@infradead.org,
        konrad.wilk@oracle.com, bp@alien8.de, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, yinghai@kernel.org, tglx@linutronix.de
Reply-To: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, hpa@zytor.com, gregkh@linuxfoundation.org,
        mingo@kernel.org, tony.luck@intel.com, rjw@rjwysocki.net,
        joro@8bytes.org, yinghai@kernel.org, benh@kernel.crashing.org,
        jiang.liu@linux.intel.com, tglx@linutronix.de, konrad.wilk@oracle.com,
        bp@alien8.de
In-Reply-To: <1416894816-23245-8-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-8-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, dmar:
  Use new irqdomain interfaces to allocate/free IRQ
Git-Commit-ID: 7f35ca7e7693ae7eb049a83a116065784d73a2f2
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

Commit-ID:  7f35ca7e7693ae7eb049a83a116065784d73a2f2
Gitweb:     http://git.kernel.org/tip/7f35ca7e7693ae7eb049a83a116065784d73a2f2
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:16 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:24 +0100

x86, dmar: Use new irqdomain interfaces to allocate/free IRQ

Use new irqdomain interfaces to allocate/free IRQ for DMAR and interrupt
remapping, so we could kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ later.

The private definition of irq_alloc_hwirqs()/irq_free_hwirqs() are
temporary solution, it will be removed once we have converted interrupt
remapping driver to use irqdomain framework.

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
Link: http://lkml.kernel.org/r/1416894816-23245-8-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irq_remapping.h |  4 ++--
 arch/x86/kernel/apic/msi.c           | 10 ++++++++++
 drivers/iommu/irq_remapping.c        | 17 +++++++++++++++--
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index b7747c4..230dde9 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -103,7 +103,7 @@ static inline bool setup_remapped_irq(int irq,
 }
 #endif /* CONFIG_IRQ_REMAP */
 
-#define dmar_alloc_hwirq()	irq_alloc_hwirq(-1)
-#define dmar_free_hwirq		irq_free_hwirq
+extern int dmar_alloc_hwirq(void);
+extern void dmar_free_hwirq(int irq);
 
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 76cc2c9..9be7d6d 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -223,6 +223,16 @@ int arch_setup_dmar_msi(unsigned int irq)
 				      "edge");
 	return 0;
 }
+
+int dmar_alloc_hwirq(void)
+{
+	return irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
+}
+
+void dmar_free_hwirq(int irq)
+{
+	irq_domain_free_irqs(irq, 1);
+}
 #endif
 
 /*
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 89c4846..d29a53e 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -6,6 +6,7 @@
 #include <linux/msi.h>
 #include <linux/irq.h>
 #include <linux/pci.h>
+#include <linux/irqdomain.h>
 
 #include <asm/hw_irq.h>
 #include <asm/irq_remapping.h>
@@ -50,6 +51,18 @@ static void irq_remapping_disable_io_apic(void)
 		disconnect_bsp_APIC(0);
 }
 
+#ifndef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
+static unsigned int irq_alloc_hwirqs(int cnt, int node)
+{
+	return irq_domain_alloc_irqs(NULL, -1, cnt, node, NULL);
+}
+
+static void irq_free_hwirqs(unsigned int from, int cnt)
+{
+	irq_domain_free_irqs(from, cnt);
+}
+#endif
+
 static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 {
 	int ret, sub_handle, nvec_pow2, index = 0;
@@ -105,7 +118,7 @@ static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 
-		irq = irq_alloc_hwirq(node);
+		irq = irq_alloc_hwirqs(1, node);
 		if (irq == 0)
 			return -1;
 
@@ -128,7 +141,7 @@ static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
 	return 0;
 
 error:
-	irq_free_hwirq(irq);
+	irq_free_hwirqs(irq, 1);
 	return ret;
 }
 
