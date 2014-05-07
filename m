Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaEGPnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:43:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:48488 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaEGPnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:50 -0400
Message-Id: <20140507154333.809210026@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 01/32] arm: iop13xx: Use sparse irqs for MSI
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=arm-iop13xx-use-sparse-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for a private allocator. The core code handles it
already. 

Allocate the non MSI irqs right at boot time via machine_desc->nr_irqs
and let the sparse core handle the MSI space.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/Kconfig                          |    1 
 arch/arm/mach-iop13xx/include/mach/irqs.h |    2 -
 arch/arm/mach-iop13xx/include/mach/time.h |    3 +
 arch/arm/mach-iop13xx/iq81340mc.c         |    1 
 arch/arm/mach-iop13xx/iq81340sc.c         |    1 
 arch/arm/mach-iop13xx/msi.c               |   51 ++++++------------------------
 arch/arm/mach-iop13xx/setup.c             |    1 
 arch/arm/mach-iop13xx/tpmi.c              |    1 
 8 files changed, 19 insertions(+), 42 deletions(-)

Index: tip/arch/arm/Kconfig
===================================================================
--- tip.orig/arch/arm/Kconfig
+++ tip/arch/arm/Kconfig
@@ -480,6 +480,7 @@ config ARCH_IOP13XX
 	select PCI
 	select PLAT_IOP
 	select VMSPLIT_1G
+	select SPARSE_IRQ
 	help
 	  Support for Intel's IOP13XX (XScale) family of processors.
 
Index: tip/arch/arm/mach-iop13xx/include/mach/irqs.h
===================================================================
--- tip.orig/arch/arm/mach-iop13xx/include/mach/irqs.h
+++ tip/arch/arm/mach-iop13xx/include/mach/irqs.h
@@ -191,6 +191,4 @@ static inline u32 read_intpnd_3(void)
 #define NR_IOP13XX_IRQS	(IRQ_IOP13XX_HPI + 1)
 #endif
 
-#define NR_IRQS		NR_IOP13XX_IRQS
-
 #endif /* _IOP13XX_IRQ_H_ */
Index: tip/arch/arm/mach-iop13xx/include/mach/time.h
===================================================================
--- tip.orig/arch/arm/mach-iop13xx/include/mach/time.h
+++ tip/arch/arm/mach-iop13xx/include/mach/time.h
@@ -1,5 +1,8 @@
 #ifndef _IOP13XX_TIME_H_
 #define _IOP13XX_TIME_H_
+
+#include <mach/irqs.h>
+
 #define IRQ_IOP_TIMER0 IRQ_IOP13XX_TIMER0
 
 #define IOP_TMR_EN	    0x02
Index: tip/arch/arm/mach-iop13xx/iq81340mc.c
===================================================================
--- tip.orig/arch/arm/mach-iop13xx/iq81340mc.c
+++ tip/arch/arm/mach-iop13xx/iq81340mc.c
@@ -93,4 +93,5 @@ MACHINE_START(IQ81340MC, "Intel IQ81340M
 	.init_time	= iq81340mc_timer_init,
 	.init_machine   = iq81340mc_init,
 	.restart	= iop13xx_restart,
+	.nr_irqs	= NR_IOP13XX_IRQS,
 MACHINE_END
Index: tip/arch/arm/mach-iop13xx/iq81340sc.c
===================================================================
--- tip.orig/arch/arm/mach-iop13xx/iq81340sc.c
+++ tip/arch/arm/mach-iop13xx/iq81340sc.c
@@ -95,4 +95,5 @@ MACHINE_START(IQ81340SC, "Intel IQ81340S
 	.init_time	= iq81340sc_timer_init,
 	.init_machine   = iq81340sc_init,
 	.restart	= iop13xx_restart,
+	.nr_irqs	= NR_IOP13XX_IRQS,
 MACHINE_END
Index: tip/arch/arm/mach-iop13xx/msi.c
===================================================================
--- tip.orig/arch/arm/mach-iop13xx/msi.c
+++ tip/arch/arm/mach-iop13xx/msi.c
@@ -24,10 +24,6 @@
 #include <asm/mach/irq.h>
 #include <asm/irq.h>
 
-
-#define IOP13XX_NUM_MSI_IRQS 128
-static DECLARE_BITMAP(msi_irq_in_use, IOP13XX_NUM_MSI_IRQS);
-
 /* IMIPR0 CP6 R8 Page 1
  */
 static u32 read_imipr_0(void)
@@ -121,41 +117,6 @@ void __init iop13xx_msi_init(void)
 	irq_set_chained_handler(IRQ_IOP13XX_INBD_MSI, iop13xx_msi_handler);
 }
 
-/*
- * Dynamic irq allocate and deallocation
- */
-int create_irq(void)
-{
-	int irq, pos;
-
-again:
-	pos = find_first_zero_bit(msi_irq_in_use, IOP13XX_NUM_MSI_IRQS);
-	irq = IRQ_IOP13XX_MSI_0 + pos;
-	if (irq > NR_IRQS)
-		return -ENOSPC;
-	/* test_and_set_bit operates on 32-bits at a time */
-	if (test_and_set_bit(pos, msi_irq_in_use))
-		goto again;
-
-	dynamic_irq_init(irq);
-
-	return irq;
-}
-
-void destroy_irq(unsigned int irq)
-{
-	int pos = irq - IRQ_IOP13XX_MSI_0;
-
-	dynamic_irq_cleanup(irq);
-
-	clear_bit(pos, msi_irq_in_use);
-}
-
-void arch_teardown_msi_irq(unsigned int irq)
-{
-	destroy_irq(irq);
-}
-
 static void iop13xx_msi_nop(struct irq_data *d)
 {
 	return;
@@ -172,12 +133,17 @@ static struct irq_chip iop13xx_msi_chip
 
 int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 {
-	int id, irq = create_irq();
+	int id, irq = irq_alloc_desc_from(IRQ_IOP13XX_MSI_0, -1);
 	struct msi_msg msg;
 
 	if (irq < 0)
 		return irq;
 
+	if (irq >= NR_IOP13XX_IRQS) {
+		irq_free_desc(irq);
+		return -ENOSPC;
+	}
+
 	irq_set_msi_desc(irq, desc);
 
 	msg.address_hi = 0x0;
@@ -191,3 +157,8 @@ int arch_setup_msi_irq(struct pci_dev *p
 
 	return 0;
 }
+
+void arch_teardown_msi_irq(unsigned int irq)
+{
+	irq_free_desc(irq);
+}
Index: tip/arch/arm/mach-iop13xx/setup.c
===================================================================
--- tip.orig/arch/arm/mach-iop13xx/setup.c
+++ tip/arch/arm/mach-iop13xx/setup.c
@@ -27,6 +27,7 @@
 #include <mach/hardware.h>
 #include <asm/irq.h>
 #include <asm/hardware/iop_adma.h>
+#include <mach/irqs.h>
 
 #define IOP13XX_UART_XTAL 33334000
 #define IOP13XX_SETUP_DEBUG 0
Index: tip/arch/arm/mach-iop13xx/tpmi.c
===================================================================
--- tip.orig/arch/arm/mach-iop13xx/tpmi.c
+++ tip/arch/arm/mach-iop13xx/tpmi.c
@@ -24,6 +24,7 @@
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/sizes.h>
+#include <mach/irqs.h>
 
 /* assumes CONTROLLER_ONLY# is never asserted in the ESSR register */
 #define IOP13XX_TPMI_MMR(dev) 	IOP13XX_REG_ADDR32_PHYS(0x48000 + (dev << 12))


