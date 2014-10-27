Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaJ0FV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:21:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:42286 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbaJ0FVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:21:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406497973"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [Patch v7 17/18] x86, irq: Introduce helper to check whether an IOAPIC has been registered
Date: Mon, 27 Oct 2014 13:21:47 +0800
Message-Id: <1414387308-27148-18-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce acpi_ioapic_registered() to check whether an IOAPIC has already
been registered, it will be used when enabling IOAPIC hotplug.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/acpi/boot.c    |   22 ++++++++++++++++++++++
 arch/x86/kernel/apic/io_apic.c |   11 +++++++++++
 include/linux/acpi.h           |    1 +
 4 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7c04b8ec22a4..ca742d5249db 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -191,6 +191,7 @@ extern void mp_unmap_irq(int irq);
 extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 			      struct ioapic_domain_cfg *cfg);
 extern int mp_unregister_ioapic(u32 gsi_base);
+extern int mp_ioapic_registered(u32 gsi_base);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			    irq_hw_number_t hwirq);
 extern void mp_irqdomain_unmap(struct irq_domain *domain, unsigned int virq);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index bc61a5c0e7b6..f27b33194e06 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -825,6 +825,28 @@ int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
 }
 EXPORT_SYMBOL(acpi_unregister_ioapic);
 
+/**
+ * acpi_ioapic_registered - Check whether IOAPIC assoicatied with @gsi_base
+ *			    has been registered
+ * @handle:	ACPI handle of the IOAPIC deivce
+ * @gsi_base:	GSI base associated with the IOAPIC
+ *
+ * Assume caller holds some type of lock to serialize acpi_ioapic_registered()
+ * with acpi_register_ioapic()/acpi_unregister_ioapic().
+ */
+int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base)
+{
+	int ret = 0;
+
+#ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
+	down_read(&acpi_ioapic_rwsem);
+	ret  = mp_ioapic_registered(gsi_base);
+	up_read(&acpi_ioapic_rwsem);
+#endif
+
+	return ret;
+}
+
 static int __init acpi_parse_sbf(struct acpi_table_header *table)
 {
 	struct acpi_table_boot *sb;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9e5432ee2070..df3858de3031 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4018,6 +4018,17 @@ int mp_unregister_ioapic(u32 gsi_base)
 	return 0;
 }
 
+int mp_ioapic_registered(u32 gsi_base)
+{
+	int ioapic;
+
+	for_each_ioapic(ioapic)
+		if (ioapics[ioapic].gsi_config.gsi_base == gsi_base)
+			return 1;
+
+	return 0;
+}
+
 int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 		     irq_hw_number_t hwirq)
 {
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 77cecd0350e7..be6be0f91337 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -152,6 +152,7 @@ int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
+int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base);
 void acpi_irq_stats_init(void);
 extern u32 acpi_irq_handled;
 extern u32 acpi_irq_not_handled;
-- 
1.7.10.4

