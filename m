Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaJ0FVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:21:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:43523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaJ0FVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:21:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406497899"
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
Subject: [Patch v7 14/18] x86, irq, ACPI: Introduce a rwsem to protect IOAPIC operations from hotplug
Date: Mon, 27 Oct 2014 13:21:44 +0800
Message-Id: <1414387308-27148-15-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
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
index e077c080a519..3f6b665f5aa6 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -76,6 +76,19 @@ int acpi_fix_pin2_polarity __initdata;
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 #endif
 
+/*
+ * Locks related to IOAPIC hotplug
+ * Hotplug side:
+ * 	->lock_device_hotplug()	//device_hotplug_lock
+ *		->acpi_ioapic_rwsem
+ *			->ioapic_lock
+ * Interrupt mapping side:
+ *	->acpi_ioapic_rwsem
+ *		->ioapic_mutex
+ *			->ioapic_lock
+ */
+static DECLARE_RWSEM(acpi_ioapic_rwsem);
+
 /* --------------------------------------------------------------------------
                               Boot-time Configuration
    -------------------------------------------------------------------------- */
@@ -609,8 +622,10 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
 		*irqp = gsi;
 	} else {
+		down_read(&acpi_ioapic_rwsem);
 		irq = mp_map_gsi_to_irq(gsi,
 					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+		up_read(&acpi_ioapic_rwsem);
 		if (irq < 0)
 			return -1;
 		*irqp = irq;
@@ -651,7 +666,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 	int irq = gsi;
 
 #ifdef CONFIG_X86_IO_APIC
+	down_read(&acpi_ioapic_rwsem);
 	irq = mp_register_gsi(dev, gsi, trigger, polarity);
+	up_read(&acpi_ioapic_rwsem);
 #endif
 
 	return irq;
@@ -660,7 +677,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 static void acpi_unregister_gsi_ioapic(u32 gsi)
 {
 #ifdef CONFIG_X86_IO_APIC
+	down_read(&acpi_ioapic_rwsem);
 	mp_unregister_gsi(gsi);
+	up_read(&acpi_ioapic_rwsem);
 #endif
 }
 
@@ -1186,7 +1205,9 @@ static void __init acpi_process_madt(void)
 			/*
 			 * Parse MADT IO-APIC entries
 			 */
+			down_write(&acpi_ioapic_rwsem);
 			error = acpi_parse_madt_ioapic_entries();
+			up_write(&acpi_ioapic_rwsem);
 			if (!error) {
 				acpi_set_irq_model_ioapic();
 
-- 
1.7.10.4

