Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaH2Wg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:36:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaH2WgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:36:25 -0400
Date: Fri, 29 Aug 2014 15:34:44 -0700
Message-Id: <201408292234.s7TMYiDA008369@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.17-rc3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: amanual@openmailbox.org, andriy.shevchenko@linux.intel.com,
        benh@kernel.crashing.org, bhelgaas@google.com, bp@alien8.de,
        david.a.cohen@linux.intel.com, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, hpa@zytor.com, jiang.liu@linux.intel.com,
        joro@8bytes.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        mika.westerberg@linux.intel.com, mingo@kernel.org, prarit@redhat.com,
        rdunlap@infradead.org, rjw@rjwysocki.net, tglx@linutronix.de,
        tony.luck@intel.com, yinghai@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One patch to avoid assigning interrupts we don't actually have on
non-PC platforms, and two patches that addresses bugs in the new
IOAPIC assignment code.

The following changes since commit 7be141d0554921751db103b54e9f794956aa4f65:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-08-24 16:17:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to 9eabc99a635a77cbf0948ce17d3cbc2b51680d4a:

  x86, irq, PCI: Keep IRQ assignment for runtime power management (2014-08-29 13:38:00 +0200)

----------------------------------------------------------------
Andy Shevchenko (1):
      x86: Fix non-PC platform kernel crash on boot due to NULL dereference

Jiang Liu (2):
      x86: irq: Fix bug in setting IOAPIC pin attributes
      x86, irq, PCI: Keep IRQ assignment for runtime power management

 arch/x86/include/asm/io_apic.h |  2 ++
 arch/x86/kernel/apic/io_apic.c | 27 ++++++++++++++++++++++++++-
 arch/x86/kernel/irqinit.c      |  2 +-
 arch/x86/kernel/time.c         |  2 ++
 arch/x86/pci/intel_mid_pci.c   |  2 +-
 arch/x86/pci/irq.c             |  2 +-
 drivers/acpi/pci_irq.c         |  4 ++++
 7 files changed, 37 insertions(+), 4 deletions(-)

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
index 29290f5..337ce5a 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1070,6 +1070,11 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
 	}
 
 	if (flags & IOAPIC_MAP_ALLOC) {
+		/* special handling for legacy IRQs */
+		if (irq < nr_legacy_irqs() && info->count == 1 &&
+		    mp_irqdomain_map(domain, irq, pin) != 0)
+			irq = -1;
+
 		if (irq > 0)
 			info->count++;
 		else if (info->count == 0)
@@ -3896,7 +3901,15 @@ int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
 			info->polarity = 1;
 		}
 		info->node = NUMA_NO_NODE;
-		info->set = 1;
+
+		/*
+		 * setup_IO_APIC_irqs() programs all legacy IRQs with default
+		 * trigger and polarity attributes. Don't set the flag for that
+		 * case so the first legacy IRQ user could reprogram the pin
+		 * with real trigger and polarity attributes.
+		 */
+		if (virq >= nr_legacy_irqs() || info->count)
+			info->set = 1;
 	}
 	set_io_apic_irq_attr(&attr, ioapic, hwirq, info->trigger,
 			     info->polarity);
@@ -3946,6 +3959,18 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
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
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 1e6cff5..44f1ed4 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -203,7 +203,7 @@ void __init native_init_IRQ(void)
 		set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
 
-	if (!acpi_ioapic && !of_ioapic)
+	if (!acpi_ioapic && !of_ioapic && nr_legacy_irqs())
 		setup_irq(2, &irq2);
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index bf7ef5c..0fa2960 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -68,6 +68,8 @@ static struct irqaction irq0  = {
 
 void __init setup_default_timer_irq(void)
 {
+	if (!nr_legacy_irqs())
+		return;
 	setup_irq(0, &irq0);
 }
 
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
