Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaE0IWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:22:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:45445 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbaE0IWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:22:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="scan'208";a="545380807"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: [RFC Patch V1 4/4] x86, irq, ACPI: implement interface to support ACPI based IOAPIC hot-removal
Date: Tue, 27 May 2014 16:24:37 +0800
Message-Id: <1401179077-2020-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401179077-2020-1-git-send-email-jiang.liu@linux.intel.com>
References: <1401179077-2020-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement acpi_unregister_ioapic() to support ACPI based IOAPIC hot-removal.
An IOAPIC could only be removed when all its pins are unused.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    1 +
 arch/x86/kernel/acpi/boot.c    |   13 ++++++++----
 arch/x86/kernel/apic/io_apic.c |   46 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 64379c285435..256ec8d9050c 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -183,6 +183,7 @@ extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
 extern void mp_unmap_irq(int irq);
 extern int mp_register_ioapic(int id, u32 address, u32 gsi_base,
 			      ioapic_create_domain_fn cb, void *arg);
+extern int mp_unregister_ioapic(u32 gsi_base);
 extern struct irq_domain *mp_irqdomain_create(int ioapic,
 		struct device_node *np, const struct irq_domain_ops *ops);
 extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d807e16f8fec..c17cc0510040 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -672,15 +672,20 @@ int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
 
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
+#ifdef CONFIG_X86_IO_APIC
+	down_write(&acpi_ioapic_rwsem);
+	ret  = mp_unregister_ioapic(gsi_base);
+	up_write(&acpi_ioapic_rwsem);
+#endif
 
+	return ret;
+}
 EXPORT_SYMBOL(acpi_unregister_ioapic);
 
 static int __init acpi_parse_sbf(struct acpi_table_header *table)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4bddff760ff4..4343247d15b1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2949,6 +2949,18 @@ static int ioapic_create_irqdomain(int idx)
 	return 0;
 }
 
+static void ioapic_destroy_irqdomain(int idx)
+{
+	if (ioapics[idx].irqdomain) {
+		irq_domain_remove(ioapics[idx].irqdomain);
+		ioapics[idx].irqdomain = NULL;
+	}
+	if (ioapics[idx].pin_info) {
+		kfree(ioapics[idx].pin_info);
+		ioapics[idx].pin_info = NULL;
+	}
+}
+
 static void ioapic_create_irqdomains(void)
 {
 	int idx;
@@ -3904,6 +3916,40 @@ int mp_register_ioapic(int id, u32 address, u32 gsi_base,
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
+	clear_fixmap(FIX_IO_APIC_BASE_0 + ioapic);
+	memset(&ioapics[ioapic], 0, sizeof(ioapics[ioapic]));
+
+	return 0;
+}
+
 struct irq_domain *mp_irqdomain_create(int ioapic, struct device_node *np,
 				       const struct irq_domain_ops *ops)
 {
-- 
1.7.10.4

