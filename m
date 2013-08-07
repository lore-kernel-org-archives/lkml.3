Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab3HGUX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:23:57 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43646 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3HGUX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:23:56 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] pinctrl: nomadik: delete ancient pin control API
Date: Wed,  7 Aug 2013 22:23:46 +0200
Message-Id: <1375907026-15075-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@stericsson.com>

The pin control subsystem was created to do away with custom pin
control APIs such as this one. It was kept for backward-compatibility
but is completely unused in the current kernel, so let's delete
it.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/pinctrl/pinctrl-nomadik.c             | 295 --------------------------
 include/linux/platform_data/pinctrl-nomadik.h |  24 ---
 2 files changed, 319 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 4a1cfdc..89280bc 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -337,97 +337,6 @@ static void nmk_prcm_altcx_set_mode(struct nmk_pinctrl *npct,
 	nmk_write_masked(npct->prcm_base + reg, BIT(bit), BIT(bit));
 }
 
-static void __nmk_config_pin(struct nmk_gpio_chip *nmk_chip, unsigned offset,
-			     pin_cfg_t cfg, bool sleep, unsigned int *slpmregs)
-{
-	static const char *afnames[] = {
-		[NMK_GPIO_ALT_GPIO]	= "GPIO",
-		[NMK_GPIO_ALT_A]	= "A",
-		[NMK_GPIO_ALT_B]	= "B",
-		[NMK_GPIO_ALT_C]	= "C"
-	};
-	static const char *pullnames[] = {
-		[NMK_GPIO_PULL_NONE]	= "none",
-		[NMK_GPIO_PULL_UP]	= "up",
-		[NMK_GPIO_PULL_DOWN]	= "down",
-		[3] /* illegal */	= "??"
-	};
-	static const char *slpmnames[] = {
-		[NMK_GPIO_SLPM_INPUT]		= "input/wakeup",
-		[NMK_GPIO_SLPM_NOCHANGE]	= "no-change/no-wakeup",
-	};
-
-	int pin = PIN_NUM(cfg);
-	int pull = PIN_PULL(cfg);
-	int af = PIN_ALT(cfg);
-	int slpm = PIN_SLPM(cfg);
-	int output = PIN_DIR(cfg);
-	int val = PIN_VAL(cfg);
-	bool glitch = af == NMK_GPIO_ALT_C;
-
-	dev_dbg(nmk_chip->chip.dev, "pin %d [%#lx]: af %s, pull %s, slpm %s (%s%s)\n",
-		pin, cfg, afnames[af], pullnames[pull], slpmnames[slpm],
-		output ? "output " : "input",
-		output ? (val ? "high" : "low") : "");
-
-	if (sleep) {
-		int slpm_pull = PIN_SLPM_PULL(cfg);
-		int slpm_output = PIN_SLPM_DIR(cfg);
-		int slpm_val = PIN_SLPM_VAL(cfg);
-
-		af = NMK_GPIO_ALT_GPIO;
-
-		/*
-		 * The SLPM_* values are normal values + 1 to allow zero to
-		 * mean "same as normal".
-		 */
-		if (slpm_pull)
-			pull = slpm_pull - 1;
-		if (slpm_output)
-			output = slpm_output - 1;
-		if (slpm_val)
-			val = slpm_val - 1;
-
-		dev_dbg(nmk_chip->chip.dev, "pin %d: sleep pull %s, dir %s, val %s\n",
-			pin,
-			slpm_pull ? pullnames[pull] : "same",
-			slpm_output ? (output ? "output" : "input") : "same",
-			slpm_val ? (val ? "high" : "low") : "same");
-	}
-
-	if (output)
-		__nmk_gpio_make_output(nmk_chip, offset, val);
-	else {
-		__nmk_gpio_make_input(nmk_chip, offset);
-		__nmk_gpio_set_pull(nmk_chip, offset, pull);
-	}
-
-	__nmk_gpio_set_lowemi(nmk_chip, offset, PIN_LOWEMI(cfg));
-
-	/*
-	 * If the pin is switching to altfunc, and there was an interrupt
-	 * installed on it which has been lazy disabled, actually mask the
-	 * interrupt to prevent spurious interrupts that would occur while the
-	 * pin is under control of the peripheral.  Only SKE does this.
-	 */
-	if (af != NMK_GPIO_ALT_GPIO)
-		nmk_gpio_disable_lazy_irq(nmk_chip, offset);
-
-	/*
-	 * If we've backed up the SLPM registers (glitch workaround), modify
-	 * the backups since they will be restored.
-	 */
-	if (slpmregs) {
-		if (slpm == NMK_GPIO_SLPM_NOCHANGE)
-			slpmregs[nmk_chip->bank] |= BIT(offset);
-		else
-			slpmregs[nmk_chip->bank] &= ~BIT(offset);
-	} else
-		__nmk_gpio_set_slpm(nmk_chip, offset, slpm);
-
-	__nmk_gpio_set_mode_safe(nmk_chip, offset, af, glitch);
-}
-
 /*
  * Safe sequence used to switch IOs between GPIO and Alternate-C mode:
  *  - Save SLPM registers
@@ -474,210 +383,6 @@ static void nmk_gpio_glitch_slpm_restore(unsigned int *slpm)
 	}
 }
 
-static int __nmk_config_pins(pin_cfg_t *cfgs, int num, bool sleep)
-{
-	static unsigned int slpm[NUM_BANKS];
-	unsigned long flags;
-	bool glitch = false;
-	int ret = 0;
-	int i;
-
-	for (i = 0; i < num; i++) {
-		if (PIN_ALT(cfgs[i]) == NMK_GPIO_ALT_C) {
-			glitch = true;
-			break;
-		}
-	}
-
-	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
-
-	if (glitch) {
-		memset(slpm, 0xff, sizeof(slpm));
-
-		for (i = 0; i < num; i++) {
-			int pin = PIN_NUM(cfgs[i]);
-			int offset = pin % NMK_GPIO_PER_CHIP;
-
-			if (PIN_ALT(cfgs[i]) == NMK_GPIO_ALT_C)
-				slpm[pin / NMK_GPIO_PER_CHIP] &= ~BIT(offset);
-		}
-
-		nmk_gpio_glitch_slpm_init(slpm);
-	}
-
-	for (i = 0; i < num; i++) {
-		struct nmk_gpio_chip *nmk_chip;
-		int pin = PIN_NUM(cfgs[i]);
-
-		nmk_chip = nmk_gpio_chips[pin / NMK_GPIO_PER_CHIP];
-		if (!nmk_chip) {
-			ret = -EINVAL;
-			break;
-		}
-
-		clk_enable(nmk_chip->clk);
-		spin_lock(&nmk_chip->lock);
-		__nmk_config_pin(nmk_chip, pin % NMK_GPIO_PER_CHIP,
-				 cfgs[i], sleep, glitch ? slpm : NULL);
-		spin_unlock(&nmk_chip->lock);
-		clk_disable(nmk_chip->clk);
-	}
-
-	if (glitch)
-		nmk_gpio_glitch_slpm_restore(slpm);
-
-	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
-
-	return ret;
-}
-
-/**
- * nmk_config_pin - configure a pin's mux attributes
- * @cfg: pin confguration
- * @sleep: Non-zero to apply the sleep mode configuration
- * Configures a pin's mode (alternate function or GPIO), its pull up status,
- * and its sleep mode based on the specified configuration.  The @cfg is
- * usually one of the SoC specific macros defined in mach/<soc>-pins.h.  These
- * are constructed using, and can be further enhanced with, the macros in
- * <linux/platform_data/pinctrl-nomadik.h>
- *
- * If a pin's mode is set to GPIO, it is configured as an input to avoid
- * side-effects.  The gpio can be manipulated later using standard GPIO API
- * calls.
- */
-int nmk_config_pin(pin_cfg_t cfg, bool sleep)
-{
-	return __nmk_config_pins(&cfg, 1, sleep);
-}
-EXPORT_SYMBOL(nmk_config_pin);
-
-/**
- * nmk_config_pins - configure several pins at once
- * @cfgs: array of pin configurations
- * @num: number of elments in the array
- *
- * Configures several pins using nmk_config_pin().  Refer to that function for
- * further information.
- */
-int nmk_config_pins(pin_cfg_t *cfgs, int num)
-{
-	return __nmk_config_pins(cfgs, num, false);
-}
-EXPORT_SYMBOL(nmk_config_pins);
-
-int nmk_config_pins_sleep(pin_cfg_t *cfgs, int num)
-{
-	return __nmk_config_pins(cfgs, num, true);
-}
-EXPORT_SYMBOL(nmk_config_pins_sleep);
-
-/**
- * nmk_gpio_set_slpm() - configure the sleep mode of a pin
- * @gpio: pin number
- * @mode: NMK_GPIO_SLPM_INPUT or NMK_GPIO_SLPM_NOCHANGE,
- *
- * This register is actually in the pinmux layer, not the GPIO block itself.
- * The GPIO1B_SLPM register defines the GPIO mode when SLEEP/DEEP-SLEEP
- * mode is entered (i.e. when signal IOFORCE is HIGH by the platform code).
- * Each GPIO can be configured to be forced into GPIO mode when IOFORCE is
- * HIGH, overriding the normal setting defined by GPIO_AFSELx registers.
- * When IOFORCE returns LOW (by software, after SLEEP/DEEP-SLEEP exit),
- * the GPIOs return to the normal setting defined by GPIO_AFSELx registers.
- *
- * If @mode is NMK_GPIO_SLPM_INPUT, the corresponding GPIO is switched to GPIO
- * mode when signal IOFORCE is HIGH (i.e. when SLEEP/DEEP-SLEEP mode is
- * entered) regardless of the altfunction selected. Also wake-up detection is
- * ENABLED.
- *
- * If @mode is NMK_GPIO_SLPM_NOCHANGE, the corresponding GPIO remains
- * controlled by NMK_GPIO_DATC, NMK_GPIO_DATS, NMK_GPIO_DIR, NMK_GPIO_PDIS
- * (for altfunction GPIO) or respective on-chip peripherals (for other
- * altfuncs) when IOFORCE is HIGH. Also wake-up detection DISABLED.
- *
- * Note that enable_irq_wake() will automatically enable wakeup detection.
- */
-int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode)
-{
-	struct nmk_gpio_chip *nmk_chip;
-	unsigned long flags;
-
-	nmk_chip = nmk_gpio_chips[gpio / NMK_GPIO_PER_CHIP];
-	if (!nmk_chip)
-		return -EINVAL;
-
-	clk_enable(nmk_chip->clk);
-	spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
-	spin_lock(&nmk_chip->lock);
-
-	__nmk_gpio_set_slpm(nmk_chip, gpio % NMK_GPIO_PER_CHIP, mode);
-
-	spin_unlock(&nmk_chip->lock);
-	spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
-	clk_disable(nmk_chip->clk);
-
-	return 0;
-}
-
-/**
- * nmk_gpio_set_pull() - enable/disable pull up/down on a gpio
- * @gpio: pin number
- * @pull: one of NMK_GPIO_PULL_DOWN, NMK_GPIO_PULL_UP, and NMK_GPIO_PULL_NONE
- *
- * Enables/disables pull up/down on a specified pin.  This only takes effect if
- * the pin is configured as an input (either explicitly or by the alternate
- * function).
- *
- * NOTE: If enabling the pull up/down, the caller must ensure that the GPIO is
- * configured as an input.  Otherwise, due to the way the controller registers
- * work, this function will change the value output on the pin.
- */
-int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull)
-{
-	struct nmk_gpio_chip *nmk_chip;
-	unsigned long flags;
-
-	nmk_chip = nmk_gpio_chips[gpio / NMK_GPIO_PER_CHIP];
-	if (!nmk_chip)
-		return -EINVAL;
-
-	clk_enable(nmk_chip->clk);
-	spin_lock_irqsave(&nmk_chip->lock, flags);
-	__nmk_gpio_set_pull(nmk_chip, gpio % NMK_GPIO_PER_CHIP, pull);
-	spin_unlock_irqrestore(&nmk_chip->lock, flags);
-	clk_disable(nmk_chip->clk);
-
-	return 0;
-}
-
-/* Mode functions */
-/**
- * nmk_gpio_set_mode() - set the mux mode of a gpio pin
- * @gpio: pin number
- * @gpio_mode: one of NMK_GPIO_ALT_GPIO, NMK_GPIO_ALT_A,
- *	       NMK_GPIO_ALT_B, and NMK_GPIO_ALT_C
- *
- * Sets the mode of the specified pin to one of the alternate functions or
- * plain GPIO.
- */
-int nmk_gpio_set_mode(int gpio, int gpio_mode)
-{
-	struct nmk_gpio_chip *nmk_chip;
-	unsigned long flags;
-
-	nmk_chip = nmk_gpio_chips[gpio / NMK_GPIO_PER_CHIP];
-	if (!nmk_chip)
-		return -EINVAL;
-
-	clk_enable(nmk_chip->clk);
-	spin_lock_irqsave(&nmk_chip->lock, flags);
-	__nmk_gpio_set_mode(nmk_chip, gpio % NMK_GPIO_PER_CHIP, gpio_mode);
-	spin_unlock_irqrestore(&nmk_chip->lock, flags);
-	clk_disable(nmk_chip->clk);
-
-	return 0;
-}
-EXPORT_SYMBOL(nmk_gpio_set_mode);
-
 static int __maybe_unused nmk_prcm_gpiocr_get_mode(struct pinctrl_dev *pctldev, int gpio)
 {
 	int i;
diff --git a/include/linux/platform_data/pinctrl-nomadik.h b/include/linux/platform_data/pinctrl-nomadik.h
index f73b2f0..abf5bed 100644
--- a/include/linux/platform_data/pinctrl-nomadik.h
+++ b/include/linux/platform_data/pinctrl-nomadik.h
@@ -226,30 +226,6 @@ enum nmk_gpio_slpm {
 	NMK_GPIO_SLPM_WAKEUP_DISABLE = NMK_GPIO_SLPM_NOCHANGE,
 };
 
-/* Older deprecated pin config API that should go away soon */
-extern int nmk_config_pin(pin_cfg_t cfg, bool sleep);
-extern int nmk_config_pins(pin_cfg_t *cfgs, int num);
-extern int nmk_config_pins_sleep(pin_cfg_t *cfgs, int num);
-extern int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode);
-extern int nmk_gpio_set_pull(int gpio, enum nmk_gpio_pull pull);
-#ifdef CONFIG_PINCTRL_NOMADIK
-extern int nmk_gpio_set_mode(int gpio, int gpio_mode);
-#else
-static inline int nmk_gpio_set_mode(int gpio, int gpio_mode)
-{
-	return -ENODEV;
-}
-#endif
-extern int nmk_gpio_get_mode(int gpio);
-
-extern void nmk_gpio_wakeups_suspend(void);
-extern void nmk_gpio_wakeups_resume(void);
-
-extern void nmk_gpio_clocks_enable(void);
-extern void nmk_gpio_clocks_disable(void);
-
-extern void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up);
-
 /*
  * Platform data to register a block: only the initial gpio/irq number.
  */
-- 
1.8.1.4

