Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3A0WJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 17:09:24 -0500
Received: from mail.df.lth.se ([194.47.250.12]:11004 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310Ab3A0WJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 17:09:23 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] ARM: versatile: fix the PCI IRQ regression
Date: Sun, 27 Jan 2013 23:09:15 +0100
Message-Id: <1359324555-26996-1-git-send-email-linus.walleij@linaro.org>
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

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-versatile/core.c |  2 +-
 arch/arm/mach-versatile/pci.c  | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 5d59294..d440481 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -102,7 +102,7 @@ void __init versatile_init_irq(void)
 					      VERSATILE_SIC_BASE);
 
 	fpga_irq_init(VA_SIC_BASE, "SIC", IRQ_SIC_START,
-		IRQ_VICSOURCE31, ~PIC_MASK, np);
+		IRQ_VICSOURCE31, PIC_MASK, np);
 
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

