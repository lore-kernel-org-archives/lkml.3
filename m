Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaH2Lm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:42:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44838 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaH2Lmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:42:55 -0400
Date: Fri, 29 Aug 2014 04:40:14 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-9eabc99a635a77cbf0948ce17d3cbc2b51680d4a@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        grant.likely@linaro.org, amanual@openmailbox.org, yinghai@kernel.org,
        joro@8bytes.org, bp@alien8.de, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        grant.likely@linaro.org, amanual@openmailbox.org, yinghai@kernel.org,
        joro@8bytes.org, bp@alien8.de, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net
In-Reply-To: <1409304383-18806-1-git-send-email-jiang.liu@linux.intel.com>
References: <1409304383-18806-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, irq, PCI:
  Keep IRQ assignment for runtime power management
Git-Commit-ID: 9eabc99a635a77cbf0948ce17d3cbc2b51680d4a
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

Commit-ID:  9eabc99a635a77cbf0948ce17d3cbc2b51680d4a
Gitweb:     http://git.kernel.org/tip/9eabc99a635a77cbf0948ce17d3cbc2b51680d4a
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Fri, 29 Aug 2014 17:26:23 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 29 Aug 2014 13:38:00 +0200

x86, irq, PCI: Keep IRQ assignment for runtime power management

Now IOAPIC driver dynamically allocates IRQ numbers for IOAPIC pins.
We need to keep IRQ assignment for PCI devices during runtime power
management, otherwise it may cause failure of device wakeups.

Commit 3eec595235c17a7 "x86, irq, PCI: Keep IRQ assignment for PCI
devices during suspend/hibernation" has fixed the issue for suspend/
hibernation, we also need the same fix for runtime device sleep too.

Fix: https://bugzilla.kernel.org/show_bug.cgi?id=83271
Reported-and-Tested-by: EmanueL Czirai <amanual@openmailbox.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: EmanueL Czirai <amanual@openmailbox.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1409304383-18806-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |  2 ++
 arch/x86/kernel/apic/io_apic.c | 12 ++++++++++++
 arch/x86/pci/intel_mid_pci.c   |  2 +-
 arch/x86/pci/irq.c             |  2 +-
 drivers/acpi/pci_irq.c         |  4 ++++
 5 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 0aeed5c..478c490 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -227,6 +227,8 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
+extern bool mp_should_keep_irq(struct device *dev);
+
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 40a4aa3..337ce5a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3959,6 +3959,18 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
 	return ret;
 }
 
+bool mp_should_keep_irq(struct device *dev)
+{
+	if (dev->power.is_prepared)
+		return true;
+#ifdef	CONFIG_PM_RUNTIME
+	if (dev->power.runtime_status == RPM_SUSPENDING)
+		return true;
+#endif
+
+	return false;
+}
+
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 3865116..b9958c3 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -229,7 +229,7 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 
 static void intel_mid_pci_irq_disable(struct pci_dev *dev)
 {
-	if (!dev->dev.power.is_prepared && dev->irq > 0)
+	if (!mp_should_keep_irq(&dev->dev) && dev->irq > 0)
 		mp_unmap_irq(dev->irq);
 }
 
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index bc1a2c3..eb500c2 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1256,7 +1256,7 @@ static int pirq_enable_irq(struct pci_dev *dev)
 
 static void pirq_disable_irq(struct pci_dev *dev)
 {
-	if (io_apic_assign_pci_irqs && !dev->dev.power.is_prepared &&
+	if (io_apic_assign_pci_irqs && !mp_should_keep_irq(&dev->dev) &&
 	    dev->irq) {
 		mp_unmap_irq(dev->irq);
 		dev->irq = 0;
diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index c96887d..6e6b80e 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -484,6 +484,10 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
 	/* Keep IOAPIC pin configuration when suspending */
 	if (dev->dev.power.is_prepared)
 		return;
+#ifdef	CONFIG_PM_RUNTIME
+	if (dev->dev.power.runtime_status == RPM_SUSPENDING)
+		return;
+#endif
 
 	entry = acpi_pci_irq_lookup(dev, pin);
 	if (!entry)
