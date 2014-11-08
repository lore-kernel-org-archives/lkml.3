Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaKHSNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:13:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:64161 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaKHSNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:13:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533613"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part3 v3 12/38] x86, irq: Kill x86_io_apic_ops.print_entries and related interfaces
Date: Sun,  9 Nov 2014 02:13:12 +0800
Message-Id: <1415470418-10874-13-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user of x86_io_apic_ops.print_entries anymore, so kill
it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h      |    3 --
 arch/x86/include/asm/x86_init.h     |    1 -
 arch/x86/kernel/apic/io_apic.c      |   55 -----------------------------------
 arch/x86/kernel/x86_init.c          |    1 -
 drivers/iommu/intel_irq_remapping.c |    7 -----
 5 files changed, 67 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 3162a91f2b3d..8b4fc2d94bc1 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -225,8 +225,6 @@ extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
 extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_disable_io_apic(void);
-extern void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
-extern void intel_ir_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
 extern int native_ioapic_set_affinity(struct irq_data *,
 				      const struct cpumask *,
 				      bool);
@@ -290,7 +288,6 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_write		NULL
 #define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
-#define native_io_apic_print_entries	NULL
 #define native_ioapic_set_affinity	NULL
 #define native_setup_ioapic_entry	NULL
 #define native_eoi_ioapic_pin		NULL
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 9b53cb2acfbb..d49791d2aacf 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -194,7 +194,6 @@ struct x86_io_apic_ops {
 	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
-	void		(*print_entries)(unsigned int apic, unsigned int nr_entries);
 	int		(*set_affinity)(struct irq_data *data,
 					const struct cpumask *mask,
 					bool force);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 551108e35cf0..42dc3ee37e89 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1332,61 +1332,6 @@ static void __init setup_IO_APIC_irqs(void)
 	}
 }
 
-void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
-{
-	int i;
-
-	pr_debug(" NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:\n");
-
-	for (i = 0; i <= nr_entries; i++) {
-		struct IO_APIC_route_entry entry;
-
-		entry = ioapic_read_entry(apic, i);
-
-		pr_debug(" %02x %02X  ", i, entry.dest);
-		pr_cont("%1d    %1d    %1d   %1d   %1d    "
-			"%1d    %1d    %02X\n",
-			entry.mask,
-			entry.trigger,
-			entry.irr,
-			entry.polarity,
-			entry.delivery_status,
-			entry.dest_mode,
-			entry.delivery_mode,
-			entry.vector);
-	}
-}
-
-void intel_ir_io_apic_print_entries(unsigned int apic,
-				    unsigned int nr_entries)
-{
-	int i;
-
-	pr_debug(" NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:\n");
-
-	for (i = 0; i <= nr_entries; i++) {
-		struct IR_IO_APIC_route_entry *ir_entry;
-		struct IO_APIC_route_entry entry;
-
-		entry = ioapic_read_entry(apic, i);
-
-		ir_entry = (struct IR_IO_APIC_route_entry *)&entry;
-
-		pr_debug(" %02x %04X ", i, ir_entry->index);
-		pr_cont("%1d   %1d    %1d    %1d   %1d   "
-			"%1d    %1d     %X    %02X\n",
-			ir_entry->format,
-			ir_entry->mask,
-			ir_entry->trigger,
-			ir_entry->irr,
-			ir_entry->polarity,
-			ir_entry->delivery_status,
-			ir_entry->index2,
-			ir_entry->zero,
-			ir_entry->vector);
-	}
-}
-
 void ioapic_zap_locks(void)
 {
 	raw_spin_lock_init(&ioapic_lock);
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 814fcbadaad1..ba5ab975bb5b 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -154,7 +154,6 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.write			= native_io_apic_write,
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
-	.print_entries		= native_io_apic_print_entries,
 	.set_affinity		= native_ioapic_set_affinity,
 	.setup_entry		= native_setup_ioapic_entry,
 	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index d32e3699a55e..b0c8113e7a9b 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -660,13 +660,6 @@ static int __init intel_enable_irq_remapping(void)
 
 	irq_remapping_enabled = 1;
 
-	/*
-	 * VT-d has a different layout for IO-APIC entries when
-	 * interrupt remapping is enabled. So it needs a special routine
-	 * to print IO-APIC entries for debugging purposes too.
-	 */
-	x86_io_apic_ops.print_entries = intel_ir_io_apic_print_entries;
-
 	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
 
 	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;
-- 
1.7.10.4

