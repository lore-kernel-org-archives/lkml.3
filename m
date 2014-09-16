Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaIPMoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 08:44:30 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:38833 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaIPMo3 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 16 Sep 2014 08:44:29 -0400
Message-Id: <54184CC802000078000355EE@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 16 Sep 2014 13:44:24 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <jiang.liu@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: fix build failure when !CONFIG_X86_IO_APIC
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mp_should_keep_irq() isn't really IO-APIC related, and considering that
it's being used solely in arch/x86/pci/ likely both declaration and
definition got misplaced even without considering the resulting build
failure:

.../arch/x86/pci/irq.c: In function ‘pirq_disable_irq’:
.../arch/x86/pci/irq.c:1259: error: implicit declaration of function ‘mp_should_keep_irq’
make[3]: *** [arch/x86/pci/irq.o] Error 1

Move them to better places.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/io_apic.h |    2 --
 arch/x86/include/asm/pci_x86.h |    2 ++
 arch/x86/kernel/apic/io_apic.c |   12 ------------
 arch/x86/pci/irq.c             |   12 ++++++++++++
 4 files changed, 14 insertions(+), 14 deletions(-)

--- 3.17-rc5/arch/x86/include/asm/io_apic.h
+++ 3.17-rc5-ix86-build-no-IOAPIC/arch/x86/include/asm/io_apic.h
@@ -227,8 +227,6 @@ static inline void io_apic_modify(unsign
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
-extern bool mp_should_keep_irq(struct device *dev);
-
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
--- 3.17-rc5/arch/x86/include/asm/pci_x86.h
+++ 3.17-rc5-ix86-build-no-IOAPIC/arch/x86/include/asm/pci_x86.h
@@ -93,6 +93,8 @@ extern raw_spinlock_t pci_config_lock;
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
 
+extern bool mp_should_keep_irq(struct device *dev);
+
 struct pci_raw_ops {
 	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val);
--- 3.17-rc5/arch/x86/kernel/apic/io_apic.c
+++ 3.17-rc5-ix86-build-no-IOAPIC/arch/x86/kernel/apic/io_apic.c
@@ -3959,18 +3959,6 @@ int mp_set_gsi_attr(u32 gsi, int trigger
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
--- 3.17-rc5/arch/x86/pci/irq.c
+++ 3.17-rc5-ix86-build-no-IOAPIC/arch/x86/pci/irq.c
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


