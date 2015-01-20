Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbbATFtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:49:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:65464 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbbATFts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:49:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664446694"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part2 v4 03/33] x86/irq: Kill x86_io_apic_ops.print_entries and related interfaces
Date: Tue, 20 Jan 2015 13:51:23 +0800
Message-Id: <1421733113-15704-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user of x86_io_apic_ops.print_entries anymore, so kill
it.

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
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-13-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h      |    3 --
 arch/x86/include/asm/x86_init.h     |    1 -
 arch/x86/kernel/apic/io_apic.c      |   55 -----------------------------------
 arch/x86/kernel/x86_init.c          |    1 -
 drivers/iommu/intel_irq_remapping.c |    7 -----
 5 files changed, 67 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 705c425c9c3d..47af5a7af358 100644
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
index 1649bb9ca27c..2924bc88034a 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -191,7 +191,6 @@ struct x86_io_apic_ops {
 	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
-	void		(*print_entries)(unsigned int apic, unsigned int nr_entries);
 	int		(*set_affinity)(struct irq_data *data,
 					const struct cpumask *mask,
 					bool force);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index eceb2f947975..3d7ac5f82b8d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1337,61 +1337,6 @@ static void __init setup_IO_APIC_irqs(void)
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
index b094d691f2fe..d6f36c7594d7 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -144,7 +144,6 @@ struct x86_io_apic_ops x86_io_apic_ops = {
 	.write			= native_io_apic_write,
 	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
-	.print_entries		= native_io_apic_print_entries,
 	.set_affinity		= native_ioapic_set_affinity,
 	.setup_entry		= native_setup_ioapic_entry,
 	.eoi_ioapic_pin		= native_eoi_ioapic_pin,
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 91c0fc65713d..05941118a179 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -696,13 +696,6 @@ static int __init intel_enable_irq_remapping(void)
 
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

