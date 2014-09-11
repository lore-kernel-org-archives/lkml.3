Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaIKIE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:04:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:48897 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbaIKIEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:04:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="601322641"
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
Subject: [Patch v5 14/15] x86, irq: Introduce helper to check whether an IOAPIC has been registered
Date: Thu, 11 Sep 2014 16:05:57 +0800
Message-Id: <1410422758-24942-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
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
index 0e67d792741d..132f98a2288b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -821,6 +821,28 @@ int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
 }
 EXPORT_SYMBOL(acpi_unregister_ioapic);
 
+/**
+ * acpi_ioapic_registered() - Check whether IOAPIC assoicatied with @gsi_base
+ *			      has been registered
+ * @handle: ACPI handle of the IOAPIC deivce
+ * @gsi_base: GSI base associated with the IOAPIC
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
index 27a7238418f7..f054c8803939 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4013,6 +4013,17 @@ int mp_unregister_ioapic(u32 gsi_base)
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
index 3574f137242e..e916cc9ca5a8 100644
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

