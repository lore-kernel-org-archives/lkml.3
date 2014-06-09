Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaFIIR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:17:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:35824 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbaFIIRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:17:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352319652"
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
Subject: [Patch V4 04/42] x86, acpi: reorganize code to avoid forward declaration in boot.c
Date: Mon,  9 Jun 2014 16:19:33 +0800
Message-Id: <1402302011-23642-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize code to avoid forward declaration in boot.c, no function
changes.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |  236 +++++++++++++++++++++----------------------
 1 file changed, 116 insertions(+), 120 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b41b47021f53..ceb3b36f2b2c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -345,10 +345,123 @@ acpi_parse_lapic_nmi(struct acpi_subtable_header * header, const unsigned long e
 #endif				/*CONFIG_X86_LOCAL_APIC */
 
 #ifdef CONFIG_X86_IO_APIC
-static void  mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
-				    u32 gsi);
+#define MP_ISA_BUS		0
+
+static void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
+					  u32 gsi)
+{
+	int ioapic;
+	int pin;
+	struct mpc_intsrc mp_irq;
+
+	/*
+	 * Convert 'gsi' to 'ioapic.pin'.
+	 */
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0)
+		return;
+	pin = mp_find_ioapic_pin(ioapic, gsi);
+
+	/*
+	 * TBD: This check is for faulty timer entries, where the override
+	 *      erroneously sets the trigger to level, resulting in a HUGE
+	 *      increase of timer interrupts!
+	 */
+	if ((bus_irq == 0) && (trigger == 3))
+		trigger = 1;
+
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (trigger << 2) | polarity;
+	mp_irq.srcbus = MP_ISA_BUS;
+	mp_irq.srcbusirq = bus_irq;	/* IRQ */
+	mp_irq.dstapic = mpc_ioapic_id(ioapic); /* APIC ID */
+	mp_irq.dstirq = pin;	/* INTIN# */
+
+	mp_save_irq(&mp_irq);
+
+	isa_irq_to_gsi[bus_irq] = gsi;
+}
+
+static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
+			int polarity)
+{
+#ifdef CONFIG_X86_MPPARSE
+	struct mpc_intsrc mp_irq;
+	struct pci_dev *pdev;
+	unsigned char number;
+	unsigned int devfn;
+	int ioapic;
+	u8 pin;
+
+	if (!acpi_ioapic)
+		return 0;
+	if (!dev || !dev_is_pci(dev))
+		return 0;
+
+	pdev = to_pci_dev(dev);
+	number = pdev->bus->number;
+	devfn = pdev->devfn;
+	pin = pdev->pin;
+	/* print the entry should happen on mptable identically */
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (trigger == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
+	mp_irq.srcbus = number;
+	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
+	ioapic = mp_find_ioapic(gsi);
+	mp_irq.dstapic = mpc_ioapic_id(ioapic);
+	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
+
+	mp_save_irq(&mp_irq);
+#endif
+	return 0;
+}
+
 static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
-			   int polarity);
+			   int polarity)
+{
+	int ioapic;
+	int ioapic_pin;
+	struct io_apic_irq_attr irq_attr;
+	int ret;
+
+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
+		return gsi;
+
+	/* Don't set up the ACPI SCI because it's already set up */
+	if (acpi_gbl_FADT.sci_interrupt == gsi)
+		return gsi;
+
+	ioapic = mp_find_ioapic(gsi);
+	if (ioapic < 0) {
+		printk(KERN_WARNING "No IOAPIC for GSI %u\n", gsi);
+		return gsi;
+	}
+
+	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
+
+	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
+		printk(KERN_ERR "Invalid reference to IOAPIC pin "
+		       "%d-%d\n", mpc_ioapic_id(ioapic),
+		       ioapic_pin);
+		return gsi;
+	}
+
+	if (enable_update_mptable)
+		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
+
+	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
+			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
+			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
+	ret = io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
+	if (ret < 0)
+		gsi = INT_MIN;
+
+	return gsi;
+}
+
 
 static int __init
 acpi_parse_ioapic(struct acpi_subtable_header * header, const unsigned long end)
@@ -905,44 +1018,6 @@ static int __init acpi_parse_madt_lapic_entries(void)
 #endif				/* CONFIG_X86_LOCAL_APIC */
 
 #ifdef	CONFIG_X86_IO_APIC
-#define MP_ISA_BUS		0
-
-static void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
-					  u32 gsi)
-{
-	int ioapic;
-	int pin;
-	struct mpc_intsrc mp_irq;
-
-	/*
-	 * Convert 'gsi' to 'ioapic.pin'.
-	 */
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0)
-		return;
-	pin = mp_find_ioapic_pin(ioapic, gsi);
-
-	/*
-	 * TBD: This check is for faulty timer entries, where the override
-	 *      erroneously sets the trigger to level, resulting in a HUGE
-	 *      increase of timer interrupts!
-	 */
-	if ((bus_irq == 0) && (trigger == 3))
-		trigger = 1;
-
-	mp_irq.type = MP_INTSRC;
-	mp_irq.irqtype = mp_INT;
-	mp_irq.irqflag = (trigger << 2) | polarity;
-	mp_irq.srcbus = MP_ISA_BUS;
-	mp_irq.srcbusirq = bus_irq;	/* IRQ */
-	mp_irq.dstapic = mpc_ioapic_id(ioapic); /* APIC ID */
-	mp_irq.dstirq = pin;	/* INTIN# */
-
-	mp_save_irq(&mp_irq);
-
-	isa_irq_to_gsi[bus_irq] = gsi;
-}
-
 static void __init mp_config_acpi_legacy_irqs(void)
 {
 	int i;
@@ -1009,85 +1084,6 @@ static void __init mp_config_acpi_legacy_irqs(void)
 	}
 }
 
-static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
-			int polarity)
-{
-#ifdef CONFIG_X86_MPPARSE
-	struct mpc_intsrc mp_irq;
-	struct pci_dev *pdev;
-	unsigned char number;
-	unsigned int devfn;
-	int ioapic;
-	u8 pin;
-
-	if (!acpi_ioapic)
-		return 0;
-	if (!dev || !dev_is_pci(dev))
-		return 0;
-
-	pdev = to_pci_dev(dev);
-	number = pdev->bus->number;
-	devfn = pdev->devfn;
-	pin = pdev->pin;
-	/* print the entry should happen on mptable identically */
-	mp_irq.type = MP_INTSRC;
-	mp_irq.irqtype = mp_INT;
-	mp_irq.irqflag = (trigger == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
-				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
-	mp_irq.srcbus = number;
-	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
-	ioapic = mp_find_ioapic(gsi);
-	mp_irq.dstapic = mpc_ioapic_id(ioapic);
-	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
-
-	mp_save_irq(&mp_irq);
-#endif
-	return 0;
-}
-
-static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
-			   int polarity)
-{
-	int ioapic;
-	int ioapic_pin;
-	struct io_apic_irq_attr irq_attr;
-	int ret;
-
-	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
-		return gsi;
-
-	/* Don't set up the ACPI SCI because it's already set up */
-	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return gsi;
-
-	ioapic = mp_find_ioapic(gsi);
-	if (ioapic < 0) {
-		printk(KERN_WARNING "No IOAPIC for GSI %u\n", gsi);
-		return gsi;
-	}
-
-	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
-
-	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
-		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mpc_ioapic_id(ioapic),
-		       ioapic_pin);
-		return gsi;
-	}
-
-	if (enable_update_mptable)
-		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
-
-	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
-			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
-			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	ret = io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
-	if (ret < 0)
-		gsi = INT_MIN;
-
-	return gsi;
-}
-
 /*
  * Parse IOAPIC related entries in MADT
  * returns 0 on success, < 0 on error
-- 
1.7.10.4

