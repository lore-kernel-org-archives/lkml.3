Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbaFIIY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:24:27 -0400
Received: from mga14.intel.com ([192.55.52.115]:36965 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbaFIIYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352321964"
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
Subject: [Patch V4 38/42] x86, irq, ACPI: release IOAPIC pin when PCI device is disabled
Date: Mon,  9 Jun 2014 16:20:07 +0800
Message-Id: <1402302011-23642-39-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release IOAPIC pin associated with PCI device when the PCI device
is disabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/acpi/boot.c |   27 +++++++++++++++++++++++++++
 drivers/acpi/pci_irq.c      |    3 ++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index ef3336ab6432..9306b4e87490 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -421,8 +421,24 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 	return irq;
 }
 
+static void mp_unregister_gsi(u32 gsi)
+{
+	int irq;
+
+	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
+		return;
+
+	if (acpi_gbl_FADT.sci_interrupt == gsi)
+		return;
+
+	irq = mp_map_gsi_to_irq(gsi, 0);
+	if (irq > 0)
+		mp_unmap_irq(irq);
+}
+
 static struct irq_domain_ops acpi_irqdomain_ops = {
 	.map = mp_irqdomain_map,
+	.unmap = mp_irqdomain_unmap,
 };
 
 static int __init
@@ -640,8 +656,16 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
 	return irq;
 }
 
+static void acpi_unregister_gsi_ioapic(u32 gsi)
+{
+#ifdef CONFIG_X86_IO_APIC
+	mp_unregister_gsi(gsi);
+#endif
+}
+
 int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
 			   int trigger, int polarity) = acpi_register_gsi_pic;
+void (*__acpi_unregister_gsi)(u32 gsi) = NULL;
 
 #ifdef CONFIG_ACPI_SLEEP
 int (*acpi_suspend_lowlevel)(void) = x86_acpi_suspend_lowlevel;
@@ -661,6 +685,8 @@ EXPORT_SYMBOL_GPL(acpi_register_gsi);
 
 void acpi_unregister_gsi(u32 gsi)
 {
+	if (__acpi_unregister_gsi)
+		(*__acpi_unregister_gsi)(gsi);
 }
 EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
 
@@ -668,6 +694,7 @@ static void __init acpi_set_irq_model_ioapic(void)
 {
 	acpi_irq_model = ACPI_IRQ_MODEL_IOAPIC;
 	__acpi_register_gsi = acpi_register_gsi_ioapic;
+	__acpi_unregister_gsi = acpi_unregister_gsi_ioapic;
 	acpi_ioapic = 1;
 }
 
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 9c62340c2360..6ba463ceccc6 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -498,5 +498,6 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	 */
 
 	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
-	acpi_unregister_gsi(gsi);
+	if (gsi >= 0 && dev->irq > 0)
+		acpi_unregister_gsi(gsi);
 }
-- 
1.7.10.4

