Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaIKIHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:07:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:35740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbaIKIEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:04:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="601322555"
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
Subject: [Patch v5 11/15] x86, irq, ACPI: Introduce a rwsem to protect IOAPIC operations from hotplug
Date: Thu, 11 Sep 2014 16:05:54 +0800
Message-Id: <1410422758-24942-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410422758-24942-1-git-send-email-jiang.liu@linux.intel.com>
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
 arch/x86/kernel/acpi/boot.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b436fc735aa4..c598fd7604d5 100644
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
@@ -604,8 +617,11 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	int irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+	int irq;
 
+	down_read(&acpi_ioapic_rwsem);
+	irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+	up_read(&acpi_ioapic_rwsem);
 	if (irq >= 0) {
 		*irqp = irq;
 		return 0;
@@ -646,7 +662,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 	int irq = gsi;
 
 #ifdef CONFIG_X86_IO_APIC
+	down_read(&acpi_ioapic_rwsem);
 	irq = mp_register_gsi(dev, gsi, trigger, polarity);
+	up_read(&acpi_ioapic_rwsem);
 #endif
 
 	return irq;
@@ -655,7 +673,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 static void acpi_unregister_gsi_ioapic(u32 gsi)
 {
 #ifdef CONFIG_X86_IO_APIC
+	down_read(&acpi_ioapic_rwsem);
 	mp_unregister_gsi(gsi);
+	up_read(&acpi_ioapic_rwsem);
 #endif
 }
 
@@ -1181,7 +1201,9 @@ static void __init acpi_process_madt(void)
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

