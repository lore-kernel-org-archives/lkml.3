Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3KPABj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:01:39 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:37779 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3KPABe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:34 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 01/23] gpio/omap: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:04 +0200
Message-Id: <1384560086-11994-2-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 drivers/gpio/gpio-omap.c |  188 +++++++++++++++++++++++-----------------------
 1 file changed, 94 insertions(+), 94 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 89675f8..8f4ad0f 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -108,12 +108,12 @@ static void _set_gpio_direction(struct gpio_bank *bank, int gpio, int is_input)
 	u32 l;
 
 	reg += bank->regs->direction;
-	l = __raw_readl(reg);
+	l = readl_relaxed(reg);
 	if (is_input)
 		l |= 1 << gpio;
 	else
 		l &= ~(1 << gpio);
-	__raw_writel(l, reg);
+	writel_relaxed(l, reg);
 	bank->context.oe = l;
 }
 
@@ -132,7 +132,7 @@ static void _set_gpio_dataout_reg(struct gpio_bank *bank, int gpio, int enable)
 		bank->context.dataout &= ~l;
 	}
 
-	__raw_writel(l, reg);
+	writel_relaxed(l, reg);
 }
 
 /* set data out value using mask register */
@@ -142,12 +142,12 @@ static void _set_gpio_dataout_mask(struct gpio_bank *bank, int gpio, int enable)
 	u32 gpio_bit = GPIO_BIT(bank, gpio);
 	u32 l;
 
-	l = __raw_readl(reg);
+	l = readl_relaxed(reg);
 	if (enable)
 		l |= gpio_bit;
 	else
 		l &= ~gpio_bit;
-	__raw_writel(l, reg);
+	writel_relaxed(l, reg);
 	bank->context.dataout = l;
 }
 
@@ -155,26 +155,26 @@ static int _get_gpio_datain(struct gpio_bank *bank, int offset)
 {
 	void __iomem *reg = bank->base + bank->regs->datain;
 
-	return (__raw_readl(reg) & (1 << offset)) != 0;
+	return (readl_relaxed(reg) & (1 << offset)) != 0;
 }
 
 static int _get_gpio_dataout(struct gpio_bank *bank, int offset)
 {
 	void __iomem *reg = bank->base + bank->regs->dataout;
 
-	return (__raw_readl(reg) & (1 << offset)) != 0;
+	return (readl_relaxed(reg) & (1 << offset)) != 0;
 }
 
 static inline void _gpio_rmw(void __iomem *base, u32 reg, u32 mask, bool set)
 {
-	int l = __raw_readl(base + reg);
+	int l = readl_relaxed(base + reg);
 
 	if (set)
 		l |= mask;
 	else
 		l &= ~mask;
 
-	__raw_writel(l, base + reg);
+	writel_relaxed(l, base + reg);
 }
 
 static inline void _gpio_dbck_enable(struct gpio_bank *bank)
@@ -183,7 +183,7 @@ static inline void _gpio_dbck_enable(struct gpio_bank *bank)
 		clk_enable(bank->dbck);
 		bank->dbck_enabled = true;
 
-		__raw_writel(bank->dbck_enable_mask,
+		writel_relaxed(bank->dbck_enable_mask,
 			     bank->base + bank->regs->debounce_en);
 	}
 }
@@ -196,7 +196,7 @@ static inline void _gpio_dbck_disable(struct gpio_bank *bank)
 		 * enabled but the clock is not, GPIO module seems to be unable
 		 * to detect events and generate interrupts at least on OMAP3.
 		 */
-		__raw_writel(0, bank->base + bank->regs->debounce_en);
+		writel_relaxed(0, bank->base + bank->regs->debounce_en);
 
 		clk_disable(bank->dbck);
 		bank->dbck_enabled = false;
@@ -233,10 +233,10 @@ static void _set_gpio_debounce(struct gpio_bank *bank, unsigned gpio,
 
 	clk_enable(bank->dbck);
 	reg = bank->base + bank->regs->debounce;
-	__raw_writel(debounce, reg);
+	writel_relaxed(debounce, reg);
 
 	reg = bank->base + bank->regs->debounce_en;
-	val = __raw_readl(reg);
+	val = readl_relaxed(reg);
 
 	if (debounce)
 		val |= l;
@@ -244,7 +244,7 @@ static void _set_gpio_debounce(struct gpio_bank *bank, unsigned gpio,
 		val &= ~l;
 	bank->dbck_enable_mask = val;
 
-	__raw_writel(val, reg);
+	writel_relaxed(val, reg);
 	clk_disable(bank->dbck);
 	/*
 	 * Enable debounce clock per module.
@@ -283,12 +283,12 @@ static void _clear_gpio_debounce(struct gpio_bank *bank, unsigned gpio)
 
 	bank->dbck_enable_mask &= ~gpio_bit;
 	bank->context.debounce_en &= ~gpio_bit;
-	__raw_writel(bank->context.debounce_en,
+        writel_relaxed(bank->context.debounce_en,
 		     bank->base + bank->regs->debounce_en);
 
 	if (!bank->dbck_enable_mask) {
 		bank->context.debounce = 0;
-		__raw_writel(bank->context.debounce, bank->base +
+		writel_relaxed(bank->context.debounce, bank->base +
 			     bank->regs->debounce);
 		clk_disable(bank->dbck);
 		bank->dbck_enabled = false;
@@ -311,18 +311,18 @@ static inline void set_gpio_trigger(struct gpio_bank *bank, int gpio,
 		  trigger & IRQ_TYPE_EDGE_FALLING);
 
 	bank->context.leveldetect0 =
-			__raw_readl(bank->base + bank->regs->leveldetect0);
+			readl_relaxed(bank->base + bank->regs->leveldetect0);
 	bank->context.leveldetect1 =
-			__raw_readl(bank->base + bank->regs->leveldetect1);
+			readl_relaxed(bank->base + bank->regs->leveldetect1);
 	bank->context.risingdetect =
-			__raw_readl(bank->base + bank->regs->risingdetect);
+			readl_relaxed(bank->base + bank->regs->risingdetect);
 	bank->context.fallingdetect =
-			__raw_readl(bank->base + bank->regs->fallingdetect);
+			readl_relaxed(bank->base + bank->regs->fallingdetect);
 
 	if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
 		_gpio_rmw(base, bank->regs->wkup_en, gpio_bit, trigger != 0);
 		bank->context.wake_en =
-			__raw_readl(bank->base + bank->regs->wkup_en);
+			readl_relaxed(bank->base + bank->regs->wkup_en);
 	}
 
 	/* This part needs to be executed always for OMAP{34xx, 44xx} */
@@ -347,8 +347,8 @@ static inline void set_gpio_trigger(struct gpio_bank *bank, int gpio,
 
 exit:
 	bank->level_mask =
-		__raw_readl(bank->base + bank->regs->leveldetect0) |
-		__raw_readl(bank->base + bank->regs->leveldetect1);
+		readl_relaxed(bank->base + bank->regs->leveldetect0) |
+		readl_relaxed(bank->base + bank->regs->leveldetect1);
 }
 
 #ifdef CONFIG_ARCH_OMAP1
@@ -366,13 +366,13 @@ static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio)
 
 	reg += bank->regs->irqctrl;
 
-	l = __raw_readl(reg);
+	l = readl_relaxed(reg);
 	if ((l >> gpio) & 1)
 		l &= ~(1 << gpio);
 	else
 		l |= 1 << gpio;
 
-	__raw_writel(l, reg);
+	writel_relaxed(l, reg);
 }
 #else
 static void _toggle_gpio_edge_triggering(struct gpio_bank *bank, int gpio) {}
@@ -390,7 +390,7 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
 	} else if (bank->regs->irqctrl) {
 		reg += bank->regs->irqctrl;
 
-		l = __raw_readl(reg);
+		l = readl_relaxed(reg);
 		if ((trigger & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
 			bank->toggle_mask |= 1 << gpio;
 		if (trigger & IRQ_TYPE_EDGE_RISING)
@@ -400,7 +400,7 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
 		else
 			return -EINVAL;
 
-		__raw_writel(l, reg);
+		writel_relaxed(l, reg);
 	} else if (bank->regs->edgectrl1) {
 		if (gpio & 0x08)
 			reg += bank->regs->edgectrl2;
@@ -408,7 +408,7 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
 			reg += bank->regs->edgectrl1;
 
 		gpio &= 0x07;
-		l = __raw_readl(reg);
+		l = readl_relaxed(reg);
 		l &= ~(3 << (gpio << 1));
 		if (trigger & IRQ_TYPE_EDGE_RISING)
 			l |= 2 << (gpio << 1);
@@ -418,8 +418,8 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
 		/* Enable wake-up during idle for dynamic tick */
 		_gpio_rmw(base, bank->regs->wkup_en, 1 << gpio, trigger);
 		bank->context.wake_en =
-			__raw_readl(bank->base + bank->regs->wkup_en);
-		__raw_writel(l, reg);
+			readl_relaxed(bank->base + bank->regs->wkup_en);
+		writel_relaxed(l, reg);
 	}
 	return 0;
 }
@@ -430,17 +430,17 @@ static void _enable_gpio_module(struct gpio_bank *bank, unsigned offset)
 		void __iomem *reg = bank->base + bank->regs->pinctrl;
 
 		/* Claim the pin for MPU */
-		__raw_writel(__raw_readl(reg) | (1 << offset), reg);
+		writel_relaxed(readl_relaxed(reg) | (1 << offset), reg);
 	}
 
 	if (bank->regs->ctrl && !BANK_USED(bank)) {
 		void __iomem *reg = bank->base + bank->regs->ctrl;
 		u32 ctrl;
 
-		ctrl = __raw_readl(reg);
+		ctrl = readl_relaxed(reg);
 		/* Module is enabled, clocks are not gated */
 		ctrl &= ~GPIO_MOD_CTRL_BIT;
-		__raw_writel(ctrl, reg);
+		writel_relaxed(ctrl, reg);
 		bank->context.ctrl = ctrl;
 	}
 }
@@ -455,17 +455,17 @@ static void _disable_gpio_module(struct gpio_bank *bank, unsigned offset)
 		/* Disable wake-up during idle for dynamic tick */
 		_gpio_rmw(base, bank->regs->wkup_en, 1 << offset, 0);
 		bank->context.wake_en =
-			__raw_readl(bank->base + bank->regs->wkup_en);
+			readl_relaxed(bank->base + bank->regs->wkup_en);
 	}
 
 	if (bank->regs->ctrl && !BANK_USED(bank)) {
 		void __iomem *reg = bank->base + bank->regs->ctrl;
 		u32 ctrl;
 
-		ctrl = __raw_readl(reg);
+		ctrl = readl_relaxed(reg);
 		/* Module is disabled, clocks are gated */
 		ctrl |= GPIO_MOD_CTRL_BIT;
-		__raw_writel(ctrl, reg);
+		writel_relaxed(ctrl, reg);
 		bank->context.ctrl = ctrl;
 	}
 }
@@ -474,7 +474,7 @@ static int gpio_is_input(struct gpio_bank *bank, int mask)
 {
 	void __iomem *reg = bank->base + bank->regs->direction;
 
-	return __raw_readl(reg) & mask;
+	return readl_relaxed(reg) & mask;
 }
 
 static int gpio_irq_type(struct irq_data *d, unsigned type)
@@ -530,16 +530,16 @@ static void _clear_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
 	void __iomem *reg = bank->base;
 
 	reg += bank->regs->irqstatus;
-	__raw_writel(gpio_mask, reg);
+	writel_relaxed(gpio_mask, reg);
 
 	/* Workaround for clearing DSP GPIO interrupts to allow retention */
 	if (bank->regs->irqstatus2) {
 		reg = bank->base + bank->regs->irqstatus2;
-		__raw_writel(gpio_mask, reg);
+		writel_relaxed(gpio_mask, reg);
 	}
 
 	/* Flush posted write for the irq status to avoid spurious interrupts */
-	__raw_readl(reg);
+	readl_relaxed(reg);
 }
 
 static inline void _clear_gpio_irqstatus(struct gpio_bank *bank, int gpio)
@@ -554,7 +554,7 @@ static u32 _get_gpio_irqbank_mask(struct gpio_bank *bank)
 	u32 mask = (1 << bank->width) - 1;
 
 	reg += bank->regs->irqenable;
-	l = __raw_readl(reg);
+	l = readl_relaxed(reg);
 	if (bank->regs->irqenable_inv)
 		l = ~l;
 	l &= mask;
@@ -572,7 +572,7 @@ static void _enable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
 		bank->context.irqenable1 |= gpio_mask;
 	} else {
 		reg += bank->regs->irqenable;
-		l = __raw_readl(reg);
+		l = readl_relaxed(reg);
 		if (bank->regs->irqenable_inv)
 			l &= ~gpio_mask;
 		else
@@ -580,7 +580,7 @@ static void _enable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
 		bank->context.irqenable1 = l;
 	}
 
-	__raw_writel(l, reg);
+	writel_relaxed(l, reg);
 }
 
 static void _disable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
@@ -594,7 +594,7 @@ static void _disable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
 		bank->context.irqenable1 &= ~gpio_mask;
 	} else {
 		reg += bank->regs->irqenable;
-		l = __raw_readl(reg);
+		l = readl_relaxed(reg);
 		if (bank->regs->irqenable_inv)
 			l |= gpio_mask;
 		else
@@ -602,7 +602,7 @@ static void _disable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
 		bank->context.irqenable1 = l;
 	}
 
-	__raw_writel(l, reg);
+	writel_relaxed(l, reg);
 }
 
 static inline void _set_gpio_irqenable(struct gpio_bank *bank, int gpio, int enable)
@@ -638,7 +638,7 @@ static int _set_gpio_wakeup(struct gpio_bank *bank, int gpio, int enable)
 	else
 		bank->context.wake_en &= ~gpio_bit;
 
-	__raw_writel(bank->context.wake_en, bank->base + bank->regs->wkup_en);
+	writel_relaxed(bank->context.wake_en, bank->base + bank->regs->wkup_en);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
@@ -740,7 +740,7 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 		u32 enabled;
 
 		enabled = _get_gpio_irqbank_mask(bank);
-		isr_saved = isr = __raw_readl(isr_reg) & enabled;
+		isr_saved = isr = readl_relaxed(isr_reg) & enabled;
 
 		if (bank->level_mask)
 			level_mask = bank->level_mask & enabled;
@@ -874,7 +874,7 @@ static int omap_mpuio_suspend_noirq(struct device *dev)
 	unsigned long		flags;
 
 	spin_lock_irqsave(&bank->lock, flags);
-	__raw_writel(0xffff & ~bank->context.wake_en, mask_reg);
+	writel_relaxed(0xffff & ~bank->context.wake_en, mask_reg);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
@@ -889,7 +889,7 @@ static int omap_mpuio_resume_noirq(struct device *dev)
 	unsigned long		flags;
 
 	spin_lock_irqsave(&bank->lock, flags);
-	__raw_writel(bank->context.wake_en, mask_reg);
+	writel_relaxed(bank->context.wake_en, mask_reg);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
@@ -1011,7 +1011,7 @@ static void __init omap_gpio_show_rev(struct gpio_bank *bank)
 	if (called || bank->regs->revision == USHRT_MAX)
 		return;
 
-	rev = __raw_readw(bank->base + bank->regs->revision);
+	rev = readw_relaxed(bank->base + bank->regs->revision);
 	pr_info("OMAP GPIO hardware version %d.%d\n",
 		(rev >> 4) & 0x0f, rev & 0x0f);
 
@@ -1032,20 +1032,20 @@ static void omap_gpio_mod_init(struct gpio_bank *bank)
 		l = 0xffff;
 
 	if (bank->is_mpuio) {
-		__raw_writel(l, bank->base + bank->regs->irqenable);
+		writel_relaxed(l, bank->base + bank->regs->irqenable);
 		return;
 	}
 
 	_gpio_rmw(base, bank->regs->irqenable, l, bank->regs->irqenable_inv);
 	_gpio_rmw(base, bank->regs->irqstatus, l, !bank->regs->irqenable_inv);
 	if (bank->regs->debounce_en)
-		__raw_writel(0, base + bank->regs->debounce_en);
+		writel_relaxed(0, base + bank->regs->debounce_en);
 
 	/* Save OE default value (0xffffffff) in the context */
-	bank->context.oe = __raw_readl(bank->base + bank->regs->direction);
+	bank->context.oe = readl_relaxed(bank->base + bank->regs->direction);
 	 /* Initialize interface clk ungated, module enabled */
 	if (bank->regs->ctrl)
-		__raw_writel(0, base + bank->regs->ctrl);
+		writel_relaxed(0, base + bank->regs->ctrl);
 
 	bank->dbck = clk_get(bank->dev, "dbclk");
 	if (IS_ERR(bank->dbck))
@@ -1282,11 +1282,11 @@ static int omap_gpio_runtime_suspend(struct device *dev)
 	 */
 	wake_low = bank->context.leveldetect0 & bank->context.wake_en;
 	if (wake_low)
-		__raw_writel(wake_low | bank->context.fallingdetect,
+		writel_relaxed(wake_low | bank->context.fallingdetect,
 			     bank->base + bank->regs->fallingdetect);
 	wake_hi = bank->context.leveldetect1 & bank->context.wake_en;
 	if (wake_hi)
-		__raw_writel(wake_hi | bank->context.risingdetect,
+		writel_relaxed(wake_hi | bank->context.risingdetect,
 			     bank->base + bank->regs->risingdetect);
 
 	if (!bank->enabled_non_wakeup_gpios)
@@ -1301,7 +1301,7 @@ static int omap_gpio_runtime_suspend(struct device *dev)
 	 * non-wakeup GPIOs.  Otherwise spurious IRQs will be
 	 * generated.  See OMAP2420 Errata item 1.101.
 	 */
-	bank->saved_datain = __raw_readl(bank->base +
+	bank->saved_datain = readl_relaxed(bank->base +
 						bank->regs->datain);
 	l1 = bank->context.fallingdetect;
 	l2 = bank->context.risingdetect;
@@ -1309,8 +1309,8 @@ static int omap_gpio_runtime_suspend(struct device *dev)
 	l1 &= ~bank->enabled_non_wakeup_gpios;
 	l2 &= ~bank->enabled_non_wakeup_gpios;
 
-	__raw_writel(l1, bank->base + bank->regs->fallingdetect);
-	__raw_writel(l2, bank->base + bank->regs->risingdetect);
+	writel_relaxed(l1, bank->base + bank->regs->fallingdetect);
+	writel_relaxed(l2, bank->base + bank->regs->risingdetect);
 
 	bank->workaround_enabled = true;
 
@@ -1358,9 +1358,9 @@ static int omap_gpio_runtime_resume(struct device *dev)
 	 * generate a PRCM wakeup.  Here we restore the
 	 * pre-runtime_suspend() values for edge triggering.
 	 */
-	__raw_writel(bank->context.fallingdetect,
+	writel_relaxed(bank->context.fallingdetect,
 		     bank->base + bank->regs->fallingdetect);
-	__raw_writel(bank->context.risingdetect,
+	writel_relaxed(bank->context.risingdetect,
 		     bank->base + bank->regs->risingdetect);
 
 	if (bank->loses_context) {
@@ -1382,7 +1382,7 @@ static int omap_gpio_runtime_resume(struct device *dev)
 		return 0;
 	}
 
-	l = __raw_readl(bank->base + bank->regs->datain);
+	l = readl_relaxed(bank->base + bank->regs->datain);
 
 	/*
 	 * Check if any of the non-wakeup interrupt GPIOs have changed
@@ -1412,24 +1412,24 @@ static int omap_gpio_runtime_resume(struct device *dev)
 	if (gen) {
 		u32 old0, old1;
 
-		old0 = __raw_readl(bank->base + bank->regs->leveldetect0);
-		old1 = __raw_readl(bank->base + bank->regs->leveldetect1);
+		old0 = readl_relaxed(bank->base + bank->regs->leveldetect0);
+		old1 = readl_relaxed(bank->base + bank->regs->leveldetect1);
 
 		if (!bank->regs->irqstatus_raw0) {
-			__raw_writel(old0 | gen, bank->base +
+			writel_relaxed(old0 | gen, bank->base +
 						bank->regs->leveldetect0);
-			__raw_writel(old1 | gen, bank->base +
+			writel_relaxed(old1 | gen, bank->base +
 						bank->regs->leveldetect1);
 		}
 
 		if (bank->regs->irqstatus_raw0) {
-			__raw_writel(old0 | l, bank->base +
+			writel_relaxed(old0 | l, bank->base +
 						bank->regs->leveldetect0);
-			__raw_writel(old1 | l, bank->base +
+			writel_relaxed(old1 | l, bank->base +
 						bank->regs->leveldetect1);
 		}
-		__raw_writel(old0, bank->base + bank->regs->leveldetect0);
-		__raw_writel(old1, bank->base + bank->regs->leveldetect1);
+		writel_relaxed(old0, bank->base + bank->regs->leveldetect0);
+		writel_relaxed(old1, bank->base + bank->regs->leveldetect1);
 	}
 
 	bank->workaround_enabled = false;
@@ -1471,55 +1471,55 @@ static void omap_gpio_init_context(struct gpio_bank *p)
 	struct omap_gpio_reg_offs *regs = p->regs;
 	void __iomem *base = p->base;
 
-	p->context.ctrl		= __raw_readl(base + regs->ctrl);
-	p->context.oe		= __raw_readl(base + regs->direction);
-	p->context.wake_en	= __raw_readl(base + regs->wkup_en);
-	p->context.leveldetect0	= __raw_readl(base + regs->leveldetect0);
-	p->context.leveldetect1	= __raw_readl(base + regs->leveldetect1);
-	p->context.risingdetect	= __raw_readl(base + regs->risingdetect);
-	p->context.fallingdetect = __raw_readl(base + regs->fallingdetect);
-	p->context.irqenable1	= __raw_readl(base + regs->irqenable);
-	p->context.irqenable2	= __raw_readl(base + regs->irqenable2);
+	p->context.ctrl		= readl_relaxed(base + regs->ctrl);
+	p->context.oe		= readl_relaxed(base + regs->direction);
+	p->context.wake_en	= readl_relaxed(base + regs->wkup_en);
+	p->context.leveldetect0	= readl_relaxed(base + regs->leveldetect0);
+	p->context.leveldetect1	= readl_relaxed(base + regs->leveldetect1);
+	p->context.risingdetect	= readl_relaxed(base + regs->risingdetect);
+	p->context.fallingdetect = readl_relaxed(base + regs->fallingdetect);
+	p->context.irqenable1	= readl_relaxed(base + regs->irqenable);
+	p->context.irqenable2	= readl_relaxed(base + regs->irqenable2);
 
 	if (regs->set_dataout && p->regs->clr_dataout)
-		p->context.dataout = __raw_readl(base + regs->set_dataout);
+		p->context.dataout = readl_relaxed(base + regs->set_dataout);
 	else
-		p->context.dataout = __raw_readl(base + regs->dataout);
+		p->context.dataout = readl_relaxed(base + regs->dataout);
 
 	p->context_valid = true;
 }
 
 static void omap_gpio_restore_context(struct gpio_bank *bank)
 {
-	__raw_writel(bank->context.wake_en,
+	writel_relaxed(bank->context.wake_en,
 				bank->base + bank->regs->wkup_en);
-	__raw_writel(bank->context.ctrl, bank->base + bank->regs->ctrl);
-	__raw_writel(bank->context.leveldetect0,
+	writel_relaxed(bank->context.ctrl, bank->base + bank->regs->ctrl);
+	writel_relaxed(bank->context.leveldetect0,
 				bank->base + bank->regs->leveldetect0);
-	__raw_writel(bank->context.leveldetect1,
+	writel_relaxed(bank->context.leveldetect1,
 				bank->base + bank->regs->leveldetect1);
-	__raw_writel(bank->context.risingdetect,
+	writel_relaxed(bank->context.risingdetect,
 				bank->base + bank->regs->risingdetect);
-	__raw_writel(bank->context.fallingdetect,
+	writel_relaxed(bank->context.fallingdetect,
 				bank->base + bank->regs->fallingdetect);
 	if (bank->regs->set_dataout && bank->regs->clr_dataout)
-		__raw_writel(bank->context.dataout,
+		writel_relaxed(bank->context.dataout,
 				bank->base + bank->regs->set_dataout);
 	else
-		__raw_writel(bank->context.dataout,
+		writel_relaxed(bank->context.dataout,
 				bank->base + bank->regs->dataout);
-	__raw_writel(bank->context.oe, bank->base + bank->regs->direction);
+	writel_relaxed(bank->context.oe, bank->base + bank->regs->direction);
 
 	if (bank->dbck_enable_mask) {
-		__raw_writel(bank->context.debounce, bank->base +
+		writel_relaxed(bank->context.debounce, bank->base +
 					bank->regs->debounce);
-		__raw_writel(bank->context.debounce_en,
+		writel_relaxed(bank->context.debounce_en,
 					bank->base + bank->regs->debounce_en);
 	}
 
-	__raw_writel(bank->context.irqenable1,
+	writel_relaxed(bank->context.irqenable1,
 				bank->base + bank->regs->irqenable);
-	__raw_writel(bank->context.irqenable2,
+	writel_relaxed(bank->context.irqenable2,
 				bank->base + bank->regs->irqenable2);
 }
 #endif /* CONFIG_PM_RUNTIME */
-- 
1.7.9.5

