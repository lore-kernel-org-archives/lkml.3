Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3IJAOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:14:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32769 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3IJAOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:14:31 -0400
Message-Id: <5350fa5571d24b68d6bb27959d3ef761ccb95b00.1378771874.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Mon, 9 Sep 2013 18:56:08 -0500
Subject: [PATCH 1/2] ARM: msm: trout: fix 'pointer from integer' warnings
To: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix several errors, all in the following form:

arch/arm/mach-msm/board-trout-gpio.c: In function 'trout_gpio_irq_ack':
arch/arm/mach-msm/board-trout-gpio.c:120:2: warning: passing argument 2 of '__raw_writeb' makes pointer from integer without a cast [enabled by default]
  writeb(mask, TROUT_CPLD_BASE + reg);
  ^
In file included from include/linux/io.h:22:0,
                 from arch/arm/mach-msm/board-trout-gpio.c:16:
arch/arm/include/asm/io.h:81:20: note: expected 'volatile void *' but argument is of type 'unsigned int'
 static inline void __raw_writeb(u8 val, volatile void __iomem *addr)
                    ^
arch/arm/mach-msm/board-trout-gpio.c: In function 'trout_gpio_irq_mask':
arch/arm/mach-msm/board-trout-gpio.c:135:2: warning: passing argument 2 of '__raw_writeb' makes pointer from integer without a cast [enabled by default]
  writeb(reg_val, TROUT_CPLD_BASE + reg);
  ^

Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 arch/arm/mach-msm/board-trout-gpio.c | 8 ++++----
 arch/arm/mach-msm/board-trout.h      | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-msm/board-trout-gpio.c b/arch/arm/mach-msm/board-trout-gpio.c
index 87e1d01..af47465 100644
--- a/arch/arm/mach-msm/board-trout-gpio.c
+++ b/arch/arm/mach-msm/board-trout-gpio.c
@@ -115,7 +115,7 @@ static void trout_gpio_irq_ack(struct irq_data *d)
 {
 	int bank = TROUT_INT_TO_BANK(d->irq);
 	uint8_t mask = TROUT_INT_TO_MASK(d->irq);
-	int reg = TROUT_BANK_TO_STAT_REG(bank);
+	void __iomem *reg = TROUT_BANK_TO_STAT_REG(bank);
 	/*printk(KERN_INFO "trout_gpio_irq_ack irq %d\n", d->irq);*/
 	writeb(mask, TROUT_CPLD_BASE + reg);
 }
@@ -126,7 +126,7 @@ static void trout_gpio_irq_mask(struct irq_data *d)
 	uint8_t reg_val;
 	int bank = TROUT_INT_TO_BANK(d->irq);
 	uint8_t mask = TROUT_INT_TO_MASK(d->irq);
-	int reg = TROUT_BANK_TO_MASK_REG(bank);
+	void __iomem *reg = TROUT_BANK_TO_MASK_REG(bank);
 
 	local_irq_save(flags);
 	reg_val = trout_int_mask[bank] |= mask;
@@ -142,7 +142,7 @@ static void trout_gpio_irq_unmask(struct irq_data *d)
 	uint8_t reg_val;
 	int bank = TROUT_INT_TO_BANK(d->irq);
 	uint8_t mask = TROUT_INT_TO_MASK(d->irq);
-	int reg = TROUT_BANK_TO_MASK_REG(bank);
+	void __iomem *reg = TROUT_BANK_TO_MASK_REG(bank);
 
 	local_irq_save(flags);
 	reg_val = trout_int_mask[bank] &= ~mask;
@@ -172,7 +172,7 @@ static void trout_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	int j, m;
 	unsigned v;
 	int bank;
-	int stat_reg;
+	void __iomem *stat_reg;
 	int int_base = TROUT_INT_START;
 	uint8_t int_mask;
 
diff --git a/arch/arm/mach-msm/board-trout.h b/arch/arm/mach-msm/board-trout.h
index b2379ed..82326ca 100644
--- a/arch/arm/mach-msm/board-trout.h
+++ b/arch/arm/mach-msm/board-trout.h
@@ -67,10 +67,10 @@
 
 #define TROUT_GPIO_START (128)
 
-#define TROUT_GPIO_INT_MASK0_REG            (0x0c)
-#define TROUT_GPIO_INT_STAT0_REG            (0x0e)
-#define TROUT_GPIO_INT_MASK1_REG            (0x14)
-#define TROUT_GPIO_INT_STAT1_REG            (0x10)
+#define TROUT_GPIO_INT_MASK0_REG            IOMEM(0x0c)
+#define TROUT_GPIO_INT_STAT0_REG            IOMEM(0x0e)
+#define TROUT_GPIO_INT_MASK1_REG            IOMEM(0x14)
+#define TROUT_GPIO_INT_STAT1_REG            IOMEM(0x10)
 
 #define TROUT_GPIO_HAPTIC_PWM               (28)
 #define TROUT_GPIO_PS_HOLD                  (25)
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


