Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbaFUVU2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:20:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbaFUVUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:20:24 -0400
Date: Sat, 21 Jun 2014 14:17:23 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-6a38fa0e3c94dfd1394a71a2d47c9c4d47367374@git.kernel.org>
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
In-Reply-To: <1402380987-32577-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402380987-32577-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq, ACPI:
  Release IOAPIC pin when PCI device is disabled
Git-Commit-ID: 6a38fa0e3c94dfd1394a71a2d47c9c4d47367374
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

Commit-ID:  6a38fa0e3c94dfd1394a71a2d47c9c4d47367374
Gitweb:     http://git.kernel.org/tip/6a38fa0e3c94dfd1394a71a2d47c9c4d47367374
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 10 Jun 2014 14:16:27 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:44 +0200

x86, irq, ACPI: Release IOAPIC pin when PCI device is disabled

Release IOAPIC pin associated with PCI device when the PCI device
is disabled.

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
Link: http://lkml.kernel.org/r/1402380987-32577-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 27 +++++++++++++++++++++++++++
 drivers/acpi/pci_irq.c      |  3 ++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index fd4b6d2..8c28023 100644
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
+		__acpi_unregister_gsi(gsi);
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
index 9c62340..6ba463c 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -498,5 +498,6 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	 */
 
 	dev_dbg(&dev->dev, "PCI INT %c disabled\n", pin_name(pin));
-	acpi_unregister_gsi(gsi);
+	if (gsi >= 0 && dev->irq > 0)
+		acpi_unregister_gsi(gsi);
 }
