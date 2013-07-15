Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3GOHlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 03:41:37 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:58673 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab3GOHlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 03:41:36 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: bin.gao@linux.intel.com, gregkh@linuxfoundation.org, bhelgaas@google.com,
        x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH v2] x86/pci: checkpatch.pl cleanup
Date: Mon, 15 Jul 2013 10:40:48 +0300
Message-Id: <1373874048-20258-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes warning and errors found by checkpatch.pl:

* replace asm/acpi.h, asm/io.h and asm/smp.h with linux/acpi.h,
linux/io.h and linux/smp.h respectively
* remove explicit initialization to 0 of a static global variable
* replace printk(KERN_INFO ...) with pr_info
* use tabs instead of spaces for indentation
* arrange comments so that they adhere to Documentation/CodingStyle

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
Changes since v1:
* cleaned up all checkpatch.pl errors according to Ingo's review

 arch/x86/pci/mrst.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 6eb18c4..b0333cb 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -23,11 +23,11 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
+#include <linux/acpi.h>
+#include <linux/io.h>
+#include <linux/smp.h>
 
-#include <asm/acpi.h>
 #include <asm/segment.h>
-#include <asm/io.h>
-#include <asm/smp.h>
 #include <asm/pci_x86.h>
 #include <asm/hw_irq.h>
 #include <asm/io_apic.h>
@@ -43,7 +43,7 @@
 #define PCI_FIXED_BAR_4_SIZE	0x14
 #define PCI_FIXED_BAR_5_SIZE	0x1c
 
-static int pci_soc_mode = 0;
+static int pci_soc_mode;
 
 /**
  * fixed_bar_cap - return the offset of the fixed BAR cap if found
@@ -141,7 +141,8 @@ static int pci_device_update_fixed(struct pci_bus *bus, unsigned int devfn,
  */
 static bool type1_access_ok(unsigned int bus, unsigned int devfn, int reg)
 {
-	/* This is a workaround for A0 LNC bug where PCI status register does
+	/*
+	 * This is a workaround for A0 LNC bug where PCI status register does
 	 * not have new CAP bit set. can not be written by SW either.
 	 *
 	 * PCI header type in real LNC indicates a single function device, this
@@ -172,7 +173,8 @@ static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
 {
 	int offset;
 
-	/* On MRST, there is no PCI ROM BAR, this will cause a subsequent read
+	/*
+	 * On MRST, there is no PCI ROM BAR, this will cause a subsequent read
 	 * to ROM BAR return 0 then being ignored.
 	 */
 	if (where == PCI_ROM_ADDRESS)
@@ -210,7 +212,8 @@ static int mrst_pci_irq_enable(struct pci_dev *dev)
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 
-	/* MRST only have IOAPIC, the PCI irq lines are 1:1 mapped to
+	/*
+	 * MRST only have IOAPIC, the PCI irq lines are 1:1 mapped to
 	 * IOAPIC RTE entries, so we just enable RTE for the device.
 	 */
 	irq_attr.ioapic = mp_find_ioapic(dev->irq);
@@ -235,7 +238,7 @@ struct pci_ops pci_mrst_ops = {
  */
 int __init pci_mrst_init(void)
 {
-	printk(KERN_INFO "Intel MID platform detected, using MID PCI ops\n");
+	pr_info("Intel MID platform detected, using MID PCI ops\n");
 	pci_mmcfg_late_init();
 	pcibios_enable_irq = mrst_pci_irq_enable;
 	pci_root_ops = pci_mrst_ops;
@@ -244,16 +247,20 @@ int __init pci_mrst_init(void)
 	return 1;
 }
 
-/* Langwell devices are not true pci devices, they are not subject to 10 ms
+/*
+ * Langwell devices are not true pci devices, they are not subject to 10 ms
  * d3 to d0 delay required by pci spec.
  */
 static void pci_d3delay_fixup(struct pci_dev *dev)
 {
-	/* PCI fixups are effectively decided compile time. If we have a dual
-	   SoC/non-SoC kernel we don't want to mangle d3 on non SoC devices */
-        if (!pci_soc_mode)
-            return;
-	/* true pci devices in lincroft should allow type 1 access, the rest
+	/*
+	 * PCI fixups are effectively decided compile time. If we have a dual
+	 * SoC/non-SoC kernel we don't want to mangle d3 on non SoC devices.
+	 */
+	if (!pci_soc_mode)
+		return;
+	/*
+	 * True pci devices in lincroft should allow type 1 access, the rest
 	 * are langwell fake pci devices.
 	 */
 	if (type1_access_ok(dev->bus->number, dev->devfn, PCI_DEVICE_ID))
-- 
1.7.10.4

