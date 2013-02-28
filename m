Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab3B1OxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:53:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42568 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab3B1OvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 133/139] ARM: 7635/1: versatile: fix the PCI IRQ regression
Date: Thu, 28 Feb 2013 14:44:43 +0000
Message-Id: <1362062689-2567-134-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit e3e92a7be6936dff1de80e66b0b683d54e9e02d8 upstream.

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
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-versatile/core.c | 15 ++++++++++++++-
 arch/arm/mach-versatile/pci.c  | 11 ++++++-----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index cd8ea35..88070ab 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -35,6 +35,7 @@
 #include <linux/gfp.h>
 #include <linux/clkdev.h>
 #include <linux/mtd/physmap.h>
+#include <linux/bitops.h>
 
 #include <asm/irq.h>
 #include <asm/leds.h>
@@ -66,16 +67,28 @@
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
@@ -103,7 +116,7 @@ void __init versatile_init_irq(void)
 					      VERSATILE_SIC_BASE);
 
 	fpga_irq_init(VA_SIC_BASE, "SIC", IRQ_SIC_START,
-		IRQ_VICSOURCE31, ~PIC_MASK, np);
+		IRQ_VICSOURCE31, PIC_VALID, np);
 
 	/*
 	 * Interrupts on secondary controller from 0 to 8 are routed to
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index e95bf84..af94887 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
+#include <mach/irqs.h>
 #include <asm/irq.h>
 #include <asm/mach/pci.h>
 
@@ -341,12 +342,12 @@ static int __init versatile_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
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
1.8.1.2

