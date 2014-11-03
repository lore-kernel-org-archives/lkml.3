Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaKCIPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:15:51 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:36106 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaKCIPr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 3 Nov 2014 03:15:47 -0500
Message-Id: <545747BE020000780004436E@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Mon, 03 Nov 2014 08:15:42 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <jiang.liu@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: fix placement of mp_should_keep_irq()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While f3761db164 ("x86, irq: Fix build error caused by
9eabc99a635a77cbf09") addressed the original build problem,
declaration, inline stub, and definition still seem misplaced: It isn't
really IO-APIC related, and it's being used solely in arch/x86/pci/.
This also means stubbing it out when !CONFIG_X86_IO_APIC was at least
questionable.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
---
Note: This replaces (rather than fixes) the previously sent "ix86: fix
build failure when !CONFIG_X86_IO_APIC" (which conflicts with the
commit mentioned above).
---
 arch/x86/include/asm/io_apic.h |    3 ---
 arch/x86/include/asm/pci_x86.h |    2 ++
 arch/x86/kernel/apic/io_apic.c |   12 ------------
 arch/x86/pci/irq.c             |   12 ++++++++++++
 4 files changed, 14 insertions(+), 15 deletions(-)

--- 3.18-rc3/arch/x86/include/asm/io_apic.h
+++ 3.18-rc3-ix86-build-no-ioapic/arch/x86/include/asm/io_apic.h
@@ -227,8 +227,6 @@ static inline void io_apic_modify(unsign
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
-extern bool mp_should_keep_irq(struct device *dev);
-
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
@@ -239,7 +237,6 @@ static inline int mp_find_ioapic(u32 gsi
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
 static inline void mp_unmap_irq(int irq) { }
-static inline bool mp_should_keep_irq(struct device *dev) { return 1; }
 
 static inline int save_ioapic_entries(void)
 {
--- 3.18-rc3/arch/x86/include/asm/pci_x86.h
+++ 3.18-rc3-ix86-build-no-ioapic/arch/x86/include/asm/pci_x86.h
@@ -93,6 +93,8 @@ extern raw_spinlock_t pci_config_lock;
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
 
+extern bool mp_should_keep_irq(struct device *dev);
+
 struct pci_raw_ops {
 	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val);
--- 3.18-rc3/arch/x86/kernel/apic/io_apic.c
+++ 3.18-rc3-ix86-build-no-ioapic/arch/x86/kernel/apic/io_apic.c
@@ -3964,18 +3964,6 @@ int mp_set_gsi_attr(u32 gsi, int trigger
 	return ret;
 }
 
-bool mp_should_keep_irq(struct device *dev)
-{
-	if (dev->power.is_prepared)
-		return true;
-#ifdef	CONFIG_PM_RUNTIME
-	if (dev->power.runtime_status == RPM_SUSPENDING)
-		return true;
-#endif
-
-	return false;
-}
-
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
--- 3.18-rc3/arch/x86/pci/irq.c
+++ 3.18-rc3-ix86-build-no-ioapic/arch/x86/pci/irq.c
@@ -1254,6 +1254,18 @@ static int pirq_enable_irq(struct pci_de
 	return 0;
 }
 
+bool mp_should_keep_irq(struct device *dev)
+{
+	if (dev->power.is_prepared)
+		return true;
+#ifdef CONFIG_PM_RUNTIME
+	if (dev->power.runtime_status == RPM_SUSPENDING)
+		return true;
+#endif
+
+	return false;
+}
+
 static void pirq_disable_irq(struct pci_dev *dev)
 {
 	if (io_apic_assign_pci_irqs && !mp_should_keep_irq(&dev->dev) &&



