Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaKBGDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 01:03:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:55188 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbaKBGDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 01:03:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="600464398"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [Patch v8 14/18] x86, irq, ACPI: Introduce a rwsem to protect IOAPIC operations from hotplug
Date: Sun,  2 Nov 2014 14:04:29 +0800
Message-Id: <1414908273-7552-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414908273-7552-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414908273-7552-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to support ACPI based IOAPIC hotplug, so introduce a rwsem
to protect IOAPIC data structures from IOAPIC hotplug. We choose to
serialize in ACPI instead of in the IOAPIC core because:
1) currently we are only plan to support ACPI based IOAPIC hotplug
2) it's much more cleaner and easier
3) It does't affect IOAPIC discovered by devicetree, SFI and mpparse.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index e077c080a519..96d775580821 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -76,6 +76,19 @@ int acpi_fix_pin2_polarity __initdata;
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 #endif
 
+/*
+ * Locks related to IOAPIC hotplug
+ * Hotplug side:
+ * 	->lock_device_hotplug()	//device_hotplug_lock
+ *		->acpi_ioapic_lock
+ *			->ioapic_lock
+ * Interrupt mapping side:
+ *	->acpi_ioapic_lock
+ *		->ioapic_mutex
+ *			->ioapic_lock
+ */
+static DEFINE_MUTEX(acpi_ioapic_lock);
+
 /* --------------------------------------------------------------------------
                               Boot-time Configuration
    -------------------------------------------------------------------------- */
@@ -609,8 +622,10 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
 		*irqp = gsi;
 	} else {
+		mutex_lock(&acpi_ioapic_lock);
 		irq = mp_map_gsi_to_irq(gsi,
 					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+		mutex_unlock(&acpi_ioapic_lock);
 		if (irq < 0)
 			return -1;
 		*irqp = irq;
@@ -651,7 +666,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 	int irq = gsi;
 
 #ifdef CONFIG_X86_IO_APIC
+	mutex_lock(&acpi_ioapic_lock);
 	irq = mp_register_gsi(dev, gsi, trigger, polarity);
+	mutex_unlock(&acpi_ioapic_lock);
 #endif
 
 	return irq;
@@ -660,7 +677,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 static void acpi_unregister_gsi_ioapic(u32 gsi)
 {
 #ifdef CONFIG_X86_IO_APIC
+	mutex_lock(&acpi_ioapic_lock);
 	mp_unregister_gsi(gsi);
+	mutex_unlock(&acpi_ioapic_lock);
 #endif
 }
 
@@ -1186,7 +1205,9 @@ static void __init acpi_process_madt(void)
 			/*
 			 * Parse MADT IO-APIC entries
 			 */
+			mutex_lock(&acpi_ioapic_lock);
 			error = acpi_parse_madt_ioapic_entries();
+			mutex_unlock(&acpi_ioapic_lock);
 			if (!error) {
 				acpi_set_irq_model_ioapic();
 
-- 
1.7.10.4

