Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaKCLCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:02:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaKCLCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:02:05 -0500
Date: Mon, 3 Nov 2014 03:00:48 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-5fcb864ef90df093d964171539c87ffa0ab49f0f@git.kernel.org>
Cc: rjw@rjwysocki.net, pavel@ucw.cz, hpa@zytor.com, mingo@kernel.org,
        gregkh@linuxfoundation.org, konrad.wilk@oracle.com,
        jiang.liu@linux.intel.com, yinghai@kernel.org, len.brown@intel.com,
        benh@kernel.crashing.org, bhelgaas@google.com, bp@alien8.de,
        grant.likely@linaro.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, prarit@redhat.com, tglx@linutronix.de,
        tony.luck@intel.com
Reply-To: yinghai@kernel.org, len.brown@intel.com, jiang.liu@linux.intel.com,
        mingo@kernel.org, hpa@zytor.com, konrad.wilk@oracle.com,
        gregkh@linuxfoundation.org, rjw@rjwysocki.net, pavel@ucw.cz,
        tglx@linutronix.de, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        prarit@redhat.com, rdunlap@infradead.org, bp@alien8.de,
        grant.likely@linaro.org, joro@8bytes.org, bhelgaas@google.com,
        benh@kernel.crashing.org
In-Reply-To: <1414387308-27148-17-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-17-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, ACPI:
  Implement interfaces to support ACPI based IOAPIC hot-removal
Git-Commit-ID: 5fcb864ef90df093d964171539c87ffa0ab49f0f
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

Commit-ID:  5fcb864ef90df093d964171539c87ffa0ab49f0f
Gitweb:     http://git.kernel.org/tip/5fcb864ef90df093d964171539c87ffa0ab49f0f
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:46 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 11:56:08 +0100

x86, irq, ACPI: Implement interfaces to support ACPI based IOAPIC hot-removal

Implement acpi_unregister_ioapic() to support ACPI based IOAPIC hot-removal.
An IOAPIC could only be removed when all its pins are unused.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414387308-27148-17-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  1 +
 arch/x86/kernel/acpi/boot.c    | 13 +++++++---
 arch/x86/kernel/apic/io_apic.c | 55 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 8741c1e..7c04b8e 100644
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
index ee7b311..77107a9 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -808,15 +808,20 @@ int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 
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
+	mutex_lock(&acpi_ioapic_lock);
+	ret  = mp_unregister_ioapic(gsi_base);
+	mutex_unlock(&acpi_ioapic_lock);
+#endif
 
+	return ret;
+}
 EXPORT_SYMBOL(acpi_unregister_ioapic);
 
 static int __init acpi_parse_sbf(struct acpi_table_header *table)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 830244d..011ebca 100644
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
@@ -2973,6 +2980,16 @@ static int mp_irqdomain_create(int ioapic)
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
@@ -3743,6 +3760,7 @@ static struct resource * __init ioapic_setup_resources(void)
 		snprintf(mem, IOAPIC_RESOURCE_NAME_SIZE, "IOAPIC %u", i);
 		mem += IOAPIC_RESOURCE_NAME_SIZE;
 		num++;
+		ioapics[i].iomem_res = res;
 	}
 
 	ioapic_resources = res;
@@ -3971,6 +3989,43 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
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
