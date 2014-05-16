Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaEPIFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:05:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:31551 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505AbaEPIE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:04:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1065,1389772800"; 
   d="scan'208";a="540106841"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org,
        Ingo Molnar <mingo@kernel.org>, iommu@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org
Subject: [RFC Patch Part1 V1 11/30] x86, ioapic: replace get_nr_irqs_gsi() with arch_dynirq_lower_bound(0)
Date: Fri, 16 May 2014 16:05:31 +0800
Message-Id: <1400227550-5935-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all callers use get_nr_irqs_gsi() to get the lowest dynamic
allocatable IRQ number, and arch_dynirq_lower_bound(0) achieves the same
goal with a better name. So replace get_nr_irqs_gsi() with
arch_dynirq_lower_bound(0). It will also help to support dynamic IRQ
allocation for IOAPIC by using arch_dynirq_lower_bound().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h   |    2 --
 arch/x86/kernel/apic/io_apic.c   |    5 -----
 drivers/iommu/irq_remapping.c    |    4 ++--
 drivers/xen/events/events_base.c |    2 +-
 4 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0c448ac14abf..de3d8b04cf64 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -160,8 +160,6 @@ extern int save_ioapic_entries(void);
 extern void mask_ioapic_entries(void);
 extern int restore_ioapic_entries(void);
 
-extern int get_nr_irqs_gsi(void);
-
 extern void setup_ioapic_ids_from_mpc(void);
 extern void setup_ioapic_ids_from_mpc_nocheck(void);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a338d9601841..2c91a7fc9915 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3417,11 +3417,6 @@ static void __init probe_nr_irqs_gsi(void)
 	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
-int get_nr_irqs_gsi(void)
-{
-	return nr_irqs_gsi;
-}
-
 unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
 	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 228632c99adb..f874344409df 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -62,7 +62,7 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 	WARN_ON(msidesc->nvec_used);
 
 	node = dev_to_node(&dev->dev);
-	irq = __create_irqs(get_nr_irqs_gsi(), nvec, node);
+	irq = __create_irqs(arch_dynirq_lower_bound(0), nvec, node);
 	if (irq == 0)
 		return -ENOSPC;
 
@@ -109,7 +109,7 @@ static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
 	unsigned int irq;
 
 	node		= dev_to_node(&dev->dev);
-	irq		= get_nr_irqs_gsi();
+	irq		= arch_dynirq_lower_bound(0);
 	sub_handle	= 0;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index dfa12a4a0a48..004e9bb293c6 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -402,7 +402,7 @@ static int __must_check xen_allocate_irqs_dynamic(int nvec)
 	 * collisions.
 	 */
 	if (xen_initial_domain() || xen_hvm_domain())
-		first = get_nr_irqs_gsi();
+		first = arch_dynirq_lower_bound(0);
 #endif
 
 	irq = irq_alloc_descs_from(first, nvec, -1);
-- 
1.7.10.4

