Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbaEPNdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:33:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54059 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaEPNdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:33:01 -0400
Date: Fri, 16 May 2014 06:31:21 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-37ebbcff78375bfa69eb69748ef00f577b7c1c6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, dan.j.williams@intel.com, peterz@infradead.org,
        tony.luck@intel.com, linux@arm.linux.org.uk, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        peterz@infradead.org, tony.luck@intel.com, linux@arm.linux.org.uk,
        tglx@linutronix.de
In-Reply-To: <20140507154333.809210026@linutronix.de>
References: <20140507154333.809210026@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] arm: iop13xx: Use sparse irqs for MSI
Git-Commit-ID: 37ebbcff78375bfa69eb69748ef00f577b7c1c6c
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

Commit-ID:  37ebbcff78375bfa69eb69748ef00f577b7c1c6c
Gitweb:     http://git.kernel.org/tip/37ebbcff78375bfa69eb69748ef00f577b7c1c6c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:04 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:18 +0200

arm: iop13xx: Use sparse irqs for MSI

No need for a private allocator. The core code handles it
already. 

Allocate the non MSI irqs right at boot time via machine_desc->nr_irqs
and let the sparse core handle the MSI space.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/20140507154333.809210026@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/Kconfig                          |  1 +
 arch/arm/mach-iop13xx/include/mach/irqs.h |  2 --
 arch/arm/mach-iop13xx/include/mach/time.h |  3 ++
 arch/arm/mach-iop13xx/iq81340mc.c         |  1 +
 arch/arm/mach-iop13xx/iq81340sc.c         |  1 +
 arch/arm/mach-iop13xx/msi.c               | 51 +++++++------------------------
 arch/arm/mach-iop13xx/setup.c             |  1 +
 arch/arm/mach-iop13xx/tpmi.c              |  1 +
 8 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index db3c541..a2c1a18 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -480,6 +480,7 @@ config ARCH_IOP13XX
 	select PCI
 	select PLAT_IOP
 	select VMSPLIT_1G
+	select SPARSE_IRQ
 	help
 	  Support for Intel's IOP13XX (XScale) family of processors.
 
diff --git a/arch/arm/mach-iop13xx/include/mach/irqs.h b/arch/arm/mach-iop13xx/include/mach/irqs.h
index 054e7ac..e8d24d3 100644
--- a/arch/arm/mach-iop13xx/include/mach/irqs.h
+++ b/arch/arm/mach-iop13xx/include/mach/irqs.h
@@ -191,6 +191,4 @@ static inline u32 read_intpnd_3(void)
 #define NR_IOP13XX_IRQS	(IRQ_IOP13XX_HPI + 1)
 #endif
 
-#define NR_IRQS		NR_IOP13XX_IRQS
-
 #endif /* _IOP13XX_IRQ_H_ */
diff --git a/arch/arm/mach-iop13xx/include/mach/time.h b/arch/arm/mach-iop13xx/include/mach/time.h
index f1c00d6..15bc9bb 100644
--- a/arch/arm/mach-iop13xx/include/mach/time.h
+++ b/arch/arm/mach-iop13xx/include/mach/time.h
@@ -1,5 +1,8 @@
 #ifndef _IOP13XX_TIME_H_
 #define _IOP13XX_TIME_H_
+
+#include <mach/irqs.h>
+
 #define IRQ_IOP_TIMER0 IRQ_IOP13XX_TIMER0
 
 #define IOP_TMR_EN	    0x02
diff --git a/arch/arm/mach-iop13xx/iq81340mc.c b/arch/arm/mach-iop13xx/iq81340mc.c
index 02a8228..9cd07d3 100644
--- a/arch/arm/mach-iop13xx/iq81340mc.c
+++ b/arch/arm/mach-iop13xx/iq81340mc.c
@@ -93,4 +93,5 @@ MACHINE_START(IQ81340MC, "Intel IQ81340MC")
 	.init_time	= iq81340mc_timer_init,
 	.init_machine   = iq81340mc_init,
 	.restart	= iop13xx_restart,
+	.nr_irqs	= NR_IOP13XX_IRQS,
 MACHINE_END
diff --git a/arch/arm/mach-iop13xx/iq81340sc.c b/arch/arm/mach-iop13xx/iq81340sc.c
index 1b80f10..b3ec11c 100644
--- a/arch/arm/mach-iop13xx/iq81340sc.c
+++ b/arch/arm/mach-iop13xx/iq81340sc.c
@@ -95,4 +95,5 @@ MACHINE_START(IQ81340SC, "Intel IQ81340SC")
 	.init_time	= iq81340sc_timer_init,
 	.init_machine   = iq81340sc_init,
 	.restart	= iop13xx_restart,
+	.nr_irqs	= NR_IOP13XX_IRQS,
 MACHINE_END
diff --git a/arch/arm/mach-iop13xx/msi.c b/arch/arm/mach-iop13xx/msi.c
index 560d5b2..655072d 100644
--- a/arch/arm/mach-iop13xx/msi.c
+++ b/arch/arm/mach-iop13xx/msi.c
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
@@ -172,12 +133,17 @@ static struct irq_chip iop13xx_msi_chip = {
 
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
@@ -191,3 +157,8 @@ int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 
 	return 0;
 }
+
+void arch_teardown_msi_irq(unsigned int irq)
+{
+	irq_free_desc(irq);
+}
diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index 96e6c7a..bca96f4 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -27,6 +27,7 @@
 #include <mach/hardware.h>
 #include <asm/irq.h>
 #include <asm/hardware/iop_adma.h>
+#include <mach/irqs.h>
 
 #define IOP13XX_UART_XTAL 33334000
 #define IOP13XX_SETUP_DEBUG 0
diff --git a/arch/arm/mach-iop13xx/tpmi.c b/arch/arm/mach-iop13xx/tpmi.c
index 6fdad7a..db511ec 100644
--- a/arch/arm/mach-iop13xx/tpmi.c
+++ b/arch/arm/mach-iop13xx/tpmi.c
@@ -24,6 +24,7 @@
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/sizes.h>
+#include <mach/irqs.h>
 
 /* assumes CONTROLLER_ONLY# is never asserted in the ESSR register */
 #define IOP13XX_TPMI_MMR(dev) 	IOP13XX_REG_ADDR32_PHYS(0x48000 + (dev << 12))
