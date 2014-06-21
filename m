Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbaFUVLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:11:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaFUVLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:11:04 -0400
Date: Sat, 21 Jun 2014 14:10:01 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-8d7cdcb9d8f366c0567b66cce0d5ce37d3311aaf@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-5-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-5-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, acpi:
  Reorganize code to avoid forward declaration in boot.c
Git-Commit-ID: 8d7cdcb9d8f366c0567b66cce0d5ce37d3311aaf
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

Commit-ID:  8d7cdcb9d8f366c0567b66cce0d5ce37d3311aaf
Gitweb:     http://git.kernel.org/tip/8d7cdcb9d8f366c0567b66cce0d5ce37d3311aaf
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:33 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:40 +0200

x86, acpi: Reorganize code to avoid forward declaration in boot.c

Reorganize code to avoid forward declaration in boot.c, no function
changes.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Link: http://lkml.kernel.org/r/1402302011-23642-5-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 236 ++++++++++++++++++++++----------------------
 1 file changed, 116 insertions(+), 120 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b41b470..ceb3b36 100644
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
