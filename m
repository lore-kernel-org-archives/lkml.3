Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaIZO4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:56:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:47872 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbaIZO4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:56:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292099"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 07/28] x86, irq: Kill x86_io_apic_ops.print_entries and related interfaces
Date: Fri, 26 Sep 2014 22:57:37 +0800
Message-Id: <1411743478-31435-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user of x86_io_apic_ops.print_entries anymore, so kill
it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h      |    3 ---
 arch/x86/include/asm/x86_init.h     |    1 -
 arch/x86/kernel/apic/io_apic.c      |    8 ++++----
 arch/x86/kernel/x86_init.c          |    1 -
 drivers/iommu/intel_irq_remapping.c |    7 -------
 5 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 051011adff9b..fb501ec46ee8 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -226,8 +226,6 @@ extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
 extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_disable_io_apic(void);
-extern void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
-extern void intel_ir_io_apic_print_entries(unsigned int apic, unsigned int nr_entries);
 extern int native_ioapic_set_affinity(struct irq_data *,
 				      const struct cpumask *,
 				      bool);
@@ -292,7 +290,6 @@ static inline void disable_ioapic_support(void) { }
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
index b0121560f05d..d6df6da203f6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1331,7 +1331,8 @@ static void __init setup_IO_APIC_irqs(void)
 	}
 }
 
-void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
+static void native_io_apic_print_entries(unsigned int apic,
+					 unsigned int nr_entries)
 {
 	int i;
 
@@ -1356,8 +1357,7 @@ void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 	}
 }
 
-void intel_ir_io_apic_print_entries(unsigned int apic,
-				    unsigned int nr_entries)
+static void ir_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 {
 	int i;
 
@@ -1448,7 +1448,7 @@ static void __init print_IO_APIC(int ioapic_idx)
 
 	domain = mp_ioapic_irqdomain(ioapic_idx);
 	if (domain && irq_remapping_domain_is_remapped(domain))
-		intel_ir_io_apic_print_entries(ioapic_idx, reg_01.bits.entries);
+		ir_io_apic_print_entries(ioapic_idx, reg_01.bits.entries);
 	else
 		native_io_apic_print_entries(ioapic_idx, reg_01.bits.entries);
 }
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
index 8be4f924cb7c..07705d2bf48e 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -663,13 +663,6 @@ static int __init intel_enable_irq_remapping(void)
 
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

