Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbaIKIEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:04:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:48897 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbaIKIEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:04:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="601322597"
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
Subject: [Patch v5 13/15] x86, irq, ACPI: Implement interfaces to support ACPI based IOAPIC hot-removal
Date: Thu, 11 Sep 2014 16:05:56 +0800
Message-Id: <1410422758-24942-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement acpi_unregister_ioapic() to support ACPI based IOAPIC hot-removal.
An IOAPIC could only be removed when all its pins are unused.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/acpi/boot.c    |   13 +++++++---
 arch/x86/kernel/apic/io_apic.c |   55 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 8741c1ea33c3..7c04b8ec22a4 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -190,6 +190,7 @@ extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
 extern void mp_unmap_irq(int irq);
 extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 			      struct ioapic_domain_cfg *cfg);
+extern int mp_unregister_ioapic(u32 gsi_base);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 238962e7de70..0e67d792741d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -805,15 +805,20 @@ int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(acpi_register_ioapic);
 
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
 {
-	/* TBD */
-	return -EINVAL;
-}
+	int ret = -ENOSYS;
+
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+	down_write(&acpi_ioapic_rwsem);
+	ret  = mp_unregister_ioapic(gsi_base);
+	up_write(&acpi_ioapic_rwsem);
+#endif
 
+	return ret;
+}
 EXPORT_SYMBOL(acpi_unregister_ioapic);
 
 static int __init acpi_parse_sbf(struct acpi_table_header *table)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 77c9cc4e8198..27a7238418f7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -112,6 +112,7 @@ static struct ioapic {
 	struct ioapic_domain_cfg irqdomain_cfg;
 	struct irq_domain *irqdomain;
 	struct mp_pin_info *pin_info;
+	struct resource *iomem_res;
 } ioapics[MAX_IO_APICS];
 
 #define mpc_ioapic_ver(ioapic_idx)	ioapics[ioapic_idx].mp_config.apicver
@@ -250,6 +251,12 @@ static void alloc_ioapic_saved_registers(int idx)
 		pr_err("IOAPIC %d: suspend/resume impossible!\n", idx);
 }
 
+static void free_ioapic_saved_registers(int idx)
+{
+	kfree(ioapics[idx].saved_registers);
+	ioapics[idx].saved_registers = NULL;
+}
+
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
@@ -2972,6 +2979,16 @@ static int mp_irqdomain_create(int ioapic)
 	return 0;
 }
 
+static void ioapic_destroy_irqdomain(int idx)
+{
+	if (ioapics[idx].irqdomain) {
+		irq_domain_remove(ioapics[idx].irqdomain);
+		ioapics[idx].irqdomain = NULL;
+	}
+	kfree(ioapics[idx].pin_info);
+	ioapics[idx].pin_info = NULL;
+}
+
 void __init setup_IO_APIC(void)
 {
 	int ioapic;
@@ -3730,6 +3747,7 @@ static struct resource * __init ioapic_setup_resources(void)
 		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
 		mem += IOAPIC_RESOURCE_NAME_SIZE;
 		num++;
+		ioapics[i].iomem_res = res;
 	}
 
 	ioapic_resources = res;
@@ -3958,6 +3976,43 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 	return 0;
 }
 
+int mp_unregister_ioapic(u32 gsi_base)
+{
+	int ioapic, pin;
+	int found = 0;
+	struct mp_pin_info *pin_info;
+
+	for_each_ioapic(ioapic)
+		if (ioapics[ioapic].gsi_config.gsi_base == gsi_base) {
+			found = 1;
+			break;
+		}
+	if (!found) {
+		pr_warn("can't find IOAPIC for GSI %d\n", gsi_base);
+		return -ENODEV;
+	}
+
+	for_each_pin(ioapic, pin) {
+		pin_info = mp_pin_info(ioapic, pin);
+		if (pin_info->count) {
+			pr_warn("pin%d on IOAPIC%d is still in use.\n",
+				pin, ioapic);
+			return -EBUSY;
+		}
+	}
+
+	/* Mark entry not present */
+	ioapics[ioapic].nr_registers  = 0;
+	ioapic_destroy_irqdomain(ioapic);
+	free_ioapic_saved_registers(ioapic);
+	if (ioapics[ioapic].iomem_res)
+		release_resource(ioapics[ioapic].iomem_res);
+	clear_fixmap(FIX_IO_APIC_BASE_0 + ioapic);
+	memset(&ioapics[ioapic], 0, sizeof(ioapics[ioapic]));
+
+	return 0;
+}
+
 int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 		     irq_hw_number_t hwirq)
 {
-- 
1.7.10.4

