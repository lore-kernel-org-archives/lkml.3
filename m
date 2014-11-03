Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaKCLCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:02:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaKCLCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:02:19 -0500
Date: Mon, 3 Nov 2014 03:01:03 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-cf45268eceac09ff4af677f6e876b4d0397e1d3f@git.kernel.org>
Cc: jiang.liu@linux.intel.com, len.brown@intel.com, bhelgaas@google.com,
        rdunlap@infradead.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        grant.likely@linaro.org, joro@8bytes.org, tony.luck@intel.com,
        pavel@ucw.cz, mingo@kernel.org, gregkh@linuxfoundation.org,
        bp@alien8.de, tglx@linutronix.de, prarit@redhat.com, rjw@rjwysocki.net,
        yinghai@kernel.org, hpa@zytor.com
Reply-To: mingo@kernel.org, tony.luck@intel.com, pavel@ucw.cz, joro@8bytes.org,
        grant.likely@linaro.org, gregkh@linuxfoundation.org, rjw@rjwysocki.net,
        prarit@redhat.com, tglx@linutronix.de, bp@alien8.de, hpa@zytor.com,
        yinghai@kernel.org, rdunlap@infradead.org, bhelgaas@google.com,
        jiang.liu@linux.intel.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        konrad.wilk@oracle.com
In-Reply-To: <1414387308-27148-18-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-18-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq:
  Introduce helper to check whether an IOAPIC has been registered
Git-Commit-ID: cf45268eceac09ff4af677f6e876b4d0397e1d3f
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

Commit-ID:  cf45268eceac09ff4af677f6e876b4d0397e1d3f
Gitweb:     http://git.kernel.org/tip/cf45268eceac09ff4af677f6e876b4d0397e1d3f
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:47 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 11:56:08 +0100

x86, irq: Introduce helper to check whether an IOAPIC has been registered

Introduce acpi_ioapic_registered() to check whether an IOAPIC has already
been registered, it will be used when enabling IOAPIC hotplug.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
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
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414387308-27148-18-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  1 +
 arch/x86/kernel/acpi/boot.c    | 22 ++++++++++++++++++++++
 arch/x86/kernel/apic/io_apic.c | 11 +++++++++++
 include/linux/acpi.h           |  1 +
 4 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7c04b8e..ca742d5 100644
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
index 77107a9..1ae52e0 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -824,6 +824,28 @@ int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
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
+	mutex_lock(&acpi_ioapic_lock);
+	ret  = mp_ioapic_registered(gsi_base);
+	mutex_unlock(&acpi_ioapic_lock);
+#endif
+
+	return ret;
+}
+
 static int __init acpi_parse_sbf(struct acpi_table_header *table)
 {
 	struct acpi_table_boot *sb;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 011ebca..ff2709e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4026,6 +4026,17 @@ int mp_unregister_ioapic(u32 gsi_base)
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
index 77cecd0..be6be0f 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -152,6 +152,7 @@ int acpi_get_ioapic_id(acpi_handle handle, u32 gsi_base, u64 *phys_addr);
 
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
+int acpi_ioapic_registered(acpi_handle handle, u32 gsi_base);
 void acpi_irq_stats_init(void);
 extern u32 acpi_irq_handled;
 extern u32 acpi_irq_not_handled;
