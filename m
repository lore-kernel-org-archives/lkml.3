Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaEPIFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:05:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:21774 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574AbaEPIFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1065,1389772800"; 
   d="scan'208";a="540106913"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, sfi-devel@simplefirmware.org,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC Patch Part1 V1 12/30] x86, ioapic: kill static variable nr_irqs_gsi
Date: Fri, 16 May 2014 16:05:32 +0800
Message-Id: <1400227550-5935-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
References: <1400227550-5935-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static variable nr_irqs_gsi is used to maintain the lowest dynamic
allocatable IRQ number. It may cause trouble when enabling dynamic
IRQ allocation for IOAPIC, so use arch_dynirq_lower_bound() to
avoid directly accessing nr_irqs_gsi and kill nr_irqs_gsi.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2c91a7fc9915..fe515583a927 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -118,9 +118,6 @@ struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 /* # of MP IRQ source entries */
 int mp_irq_entries;
 
-/* GSI interrupts */
-static int nr_irqs_gsi = NR_IRQS_LEGACY;
-
 #ifdef CONFIG_EISA
 int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
@@ -2921,9 +2918,7 @@ unsigned int __create_irqs(unsigned int from, unsigned int count, int node)
 	unsigned long flags;
 	int irq, i;
 
-	if (from < nr_irqs_gsi)
-		from = nr_irqs_gsi;
-
+	from = arch_dynirq_lower_bound(from);
 	cfg = kzalloc_node(count * sizeof(cfg[0]), GFP_KERNEL, node);
 	if (!cfg)
 		return 0;
@@ -2972,12 +2967,9 @@ unsigned int create_irq_nr(unsigned int from, int node)
 int create_irq(void)
 {
 	int node = cpu_to_node(0);
-	unsigned int irq_want;
 	int irq;
 
-	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want, node);
-
+	irq = create_irq_nr(arch_dynirq_lower_bound(0), node);
 	if (irq == 0)
 		irq = -1;
 
@@ -3142,7 +3134,7 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		return 1;
 
 	node = dev_to_node(&dev->dev);
-	irq_want = nr_irqs_gsi;
+	irq_want = arch_dynirq_lower_bound(0);
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 		irq = create_irq_nr(irq_want, node);
 		if (irq == 0)
@@ -3406,20 +3398,11 @@ static int __init io_apic_get_redir_entries(int ioapic)
 	return reg_01.bits.entries + 1;
 }
 
-static void __init probe_nr_irqs_gsi(void)
-{
-	int nr;
-
-	nr = gsi_top + NR_IRQS_LEGACY;
-	if (nr > nr_irqs_gsi)
-		nr_irqs_gsi = nr;
-
-	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
-}
-
 unsigned int arch_dynirq_lower_bound(unsigned int from)
 {
-	return from < nr_irqs_gsi ? nr_irqs_gsi : from;
+	unsigned int min = gsi_top + NR_IRQS_LEGACY;
+
+	return from < min ? min : from;
 }
 
 int __init arch_probe_nr_irqs(void)
@@ -3429,12 +3412,12 @@ int __init arch_probe_nr_irqs(void)
 	if (nr_irqs > (NR_VECTORS * nr_cpu_ids))
 		nr_irqs = NR_VECTORS * nr_cpu_ids;
 
-	nr = nr_irqs_gsi + 8 * nr_cpu_ids;
+	nr = (gsi_top + NR_IRQS_LEGACY) + 8 * nr_cpu_ids;
 #if defined(CONFIG_PCI_MSI) || defined(CONFIG_HT_IRQ)
 	/*
 	 * for MSI and HT dyn irq
 	 */
-	nr += nr_irqs_gsi * 16;
+	nr += (gsi_top + NR_IRQS_LEGACY) * 16;
 #endif
 	if (nr < nr_irqs)
 		nr_irqs = nr;
@@ -3707,8 +3690,6 @@ fake_ioapic_page:
 		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
-
-	probe_nr_irqs_gsi();
 }
 
 void __init ioapic_insert_resources(void)
-- 
1.7.10.4

