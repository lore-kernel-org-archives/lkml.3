Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbaFIIa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:30:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:14004 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbaFIIT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352320084"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
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
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: [Patch V4 12/42] x86, ioapic: kill static variable nr_irqs_gsi
Date: Mon,  9 Jun 2014 16:19:41 +0800
Message-Id: <1402302011-23642-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static variable nr_irqs_gsi is used to maintain the lowest dynamic
allocatable IRQ number. It may cause trouble when enabling dynamic
IRQ allocation for IOAPIC, so use arch_dynirq_lower_bound() to
avoid directly accessing nr_irqs_gsi and kill nr_irqs_gsi.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 94a56c233e87..e8cd0bf0ee82 100644
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
@@ -3322,20 +3319,11 @@ static int __init io_apic_get_redir_entries(int ioapic)
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
@@ -3345,12 +3333,12 @@ int __init arch_probe_nr_irqs(void)
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
@@ -3623,8 +3611,6 @@ fake_ioapic_page:
 		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
-
-	probe_nr_irqs_gsi();
 }
 
 void __init ioapic_insert_resources(void)
-- 
1.7.10.4

