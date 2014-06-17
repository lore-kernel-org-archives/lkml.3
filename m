Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbaFQF2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:28:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:43830 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750AbaFQF2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:28:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,492,1400050800"; 
   d="scan'208";a="549015314"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [RFC Patch V2 11/16] x86, irq, ACPI: introduce a rwsem to protect IOAPIC operations from hotplug
Date: Tue, 17 Jun 2014 13:29:50 +0800
Message-Id: <1402982995-13747-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to support ACPI based IOAPIC hotplug, so introduce a rwsem
to protect IOAPIC data structures from IOAPIC hotplug. We choose to
serialize in ACPI instead of in the IOAPIC core because:
1) currently we are only plan to support ACPI based IOAPIC hotplug
2) it's much more clean and easy
3) It does't affect IOAPIC discovered by devicetree, SFI and mppparse.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 8c28023924bf..120b573f1e96 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -76,6 +76,8 @@ int acpi_fix_pin2_polarity __initdata;
 static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 #endif
 
+static DECLARE_RWSEM(acpi_ioapic_rwsem);
+
 #ifndef __HAVE_ARCH_CMPXCHG
 #warning ACPI uses CMPXCHG, i486 and later hardware
 #endif
@@ -608,8 +610,11 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
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
@@ -650,7 +655,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 	int irq = gsi;
 
 #ifdef CONFIG_X86_IO_APIC
+	down_read(&acpi_ioapic_rwsem);
 	irq = mp_register_gsi(dev, gsi, trigger, polarity);
+	up_read(&acpi_ioapic_rwsem);
 #endif
 
 	return irq;
@@ -659,7 +666,9 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 static void acpi_unregister_gsi_ioapic(u32 gsi)
 {
 #ifdef CONFIG_X86_IO_APIC
+	down_read(&acpi_ioapic_rwsem);
 	mp_unregister_gsi(gsi);
+	up_read(&acpi_ioapic_rwsem);
 #endif
 }
 
@@ -1185,7 +1194,9 @@ static void __init acpi_process_madt(void)
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

