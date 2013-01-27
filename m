Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3A0XTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:19:17 -0500
Received: from mail.df.lth.se ([194.47.250.12]:11151 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab3A0XTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:19:15 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] ARM: versatile: fix the PCI IRQ regression
Date: Mon, 28 Jan 2013 00:19:10 +0100
Message-Id: <1359328750-28046-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI IRQs were regressing due to two things:

- The PCI glue layer was using an hard-coded IRQ 27 offset.
  This caused the immediate regression.

- The SIC IRQ mask was inverted (i.e. a bit was indeed set to
  one for each valid IRQ on the SIC, but accidentally inverted
  in the init call). This has been around forever, but we have
  been saved by some other forgiving code that would reserve
  IRQ descriptors in this range, as the versatile is
  non-sparse.

When the IRQs were bumped up 32 steps so as to avoid using IRQ
zero and avoid touching the 16 legacy IRQs, things broke.

Introduce an explicit valid mask for the IRQs that are active
on the PIC/SIC, and pass that. Use the BIT() macro from
<linux/bitops.h> to make sure we hit the right bits, readily
defined in <mach/platform.h>.

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Got the PIC/SIC valid mask wrong again, take a deep breath
  and use the foolproof method of defining each bit so that
  nobody will get caught by this again. Didn't see this first
  because the SCSI layer takes for ever to time out.
---
 arch/arm/mach-versatile/core.c | 15 ++++++++++++++-
 arch/arm/mach-versatile/pci.c  | 11 ++++++-----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 5d59294..a78827b 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -36,6 +36,7 @@
 #include <linux/gfp.h>
 #include <linux/clkdev.h>
 #include <linux/mtd/physmap.h>
+#include <linux/bitops.h>
 
 #include <asm/irq.h>
 #include <asm/hardware/arm_timer.h>
@@ -65,16 +66,28 @@
 #define VA_VIC_BASE		__io_address(VERSATILE_VIC_BASE)
 #define VA_SIC_BASE		__io_address(VERSATILE_SIC_BASE)
 
+/* These PIC IRQs are valid in each configuration */
+#define PIC_VALID_ALL	BIT(SIC_INT_KMI0) | BIT(SIC_INT_KMI1) | \
+			BIT(SIC_INT_SCI3) | BIT(SIC_INT_UART3) | \
+			BIT(SIC_INT_CLCD) | BIT(SIC_INT_TOUCH) | \
+			BIT(SIC_INT_KEYPAD) | BIT(SIC_INT_DoC) | \
+			BIT(SIC_INT_USB) | BIT(SIC_INT_PCI0) | \
+			BIT(SIC_INT_PCI1) | BIT(SIC_INT_PCI2) | \
+			BIT(SIC_INT_PCI3)
 #if 1
 #define IRQ_MMCI0A	IRQ_VICSOURCE22
 #define IRQ_AACI	IRQ_VICSOURCE24
 #define IRQ_ETH		IRQ_VICSOURCE25
 #define PIC_MASK	0xFFD00000
+#define PIC_VALID	PIC_VALID_ALL
 #else
 #define IRQ_MMCI0A	IRQ_SIC_MMCI0A
 #define IRQ_AACI	IRQ_SIC_AACI
 #define IRQ_ETH		IRQ_SIC_ETH
 #define PIC_MASK	0
+#define PIC_VALID	PIC_VALID_ALL | BIT(SIC_INT_MMCI0A) | \
+			BIT(SIC_INT_MMCI1A) | BIT(SIC_INT_AACI) | \
+			BIT(SIC_INT_ETH)
 #endif
 
 /* Lookup table for finding a DT node that represents the vic instance */
@@ -102,7 +115,7 @@ void __init versatile_init_irq(void)
 					      VERSATILE_SIC_BASE);
 
 	fpga_irq_init(VA_SIC_BASE, "SIC", IRQ_SIC_START,
-		IRQ_VICSOURCE31, ~PIC_MASK, np);
+		IRQ_VICSOURCE31, PIC_VALID, np);
 
 	/*
 	 * Interrupts on secondary controller from 0 to 8 are routed to
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index 2f84f40..e92e5e0 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
+#include <mach/irqs.h>
 #include <asm/irq.h>
 #include <asm/mach/pci.h>
 
@@ -327,12 +328,12 @@ static int __init versatile_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	int irq;
 
 	/* slot,  pin,	irq
-	 *  24     1     27
-	 *  25     1     28
-	 *  26     1     29
-	 *  27     1     30
+	 *  24     1     IRQ_SIC_PCI0
+	 *  25     1     IRQ_SIC_PCI1
+	 *  26     1     IRQ_SIC_PCI2
+	 *  27     1     IRQ_SIC_PCI3
 	 */
-	irq = 27 + ((slot - 24 + pin - 1) & 3);
+	irq = IRQ_SIC_PCI0 + ((slot - 24 + pin - 1) & 3);
 
 	return irq;
 }
-- 
1.8.1

