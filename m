Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965512AbaH1CWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:22:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:51056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965297AbaH1CW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:22:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,415,1406617200"; 
   d="scan'208";a="582677070"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jiang Liu <jiang.liu@linux.intel.com>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [Patch v4 14/16] x86, irq: Introduce helper to check whether an IOAPIC has been registered
Date: Thu, 28 Aug 2014 10:22:39 +0800
Message-Id: <1409192561-19744-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
References: <1409192561-19744-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce acpi_ioapic_registered() to check whether an IOAPIC has already
been registered, it will be used when enabling IOAPIC hotplug.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/acpi/boot.c    |   11 +++++++++++
 arch/x86/kernel/apic/io_apic.c |   11 +++++++++++
 include/linux/acpi.h           |    1 +
 4 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index ce63cf34c93c..0db2b7037e4b 100644
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
index 560a6d1cb0f4..6aa796f77b71 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -810,6 +810,17 @@ int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
 }
 EXPORT_SYMBOL(acpi_unregister_ioapic);
 
+int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base)
+{
+	int ret;
+
+	down_write(&acpi_ioapic_rwsem);
+	ret  = mp_ioapic_registered(gsi_base);
+	up_write(&acpi_ioapic_rwsem);
+
+	return ret;
+}
+
 static int __init acpi_parse_sbf(struct acpi_table_header *table)
 {
 	struct acpi_table_boot *sb;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fc1e1f9567bc..e104993a2394 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4010,6 +4010,17 @@ int mp_unregister_ioapic(u32 gsi_base)
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
index b41c5aef5336..754d99d5f258 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -155,6 +155,7 @@ int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
+int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base);
 void acpi_irq_stats_init(void);
 extern u32 acpi_irq_handled;
 extern u32 acpi_irq_not_handled;
-- 
1.7.10.4

