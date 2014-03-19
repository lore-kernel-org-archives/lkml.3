Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965037AbaCSNEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:04:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42197 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933895AbaCSNEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:04:12 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-leds@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 16/16] misc: atmel_pwm: remove obsolete driver
Date: Wed, 19 Mar 2014 14:03:29 +0100
Message-Id: <1395234209-15546-17-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395234209-15546-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The misc/atmel_pwm is not used by any mainlined boards and has been replaced by
the pwm-driver using the generic PWM framework.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/misc/Kconfig      |   9 --
 drivers/misc/Makefile     |   1 -
 drivers/misc/atmel_pwm.c  | 402 ----------------------------------------------
 include/linux/atmel_pwm.h |  70 --------
 4 files changed, 482 deletions(-)
 delete mode 100644 drivers/misc/atmel_pwm.c
 delete mode 100644 include/linux/atmel_pwm.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 6cb388e8fb7d..64ab12b8de9e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -51,15 +51,6 @@ config AD525X_DPOT_SPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called ad525x_dpot-spi.
 
-config ATMEL_PWM
-	tristate "Atmel AT32/AT91 PWM support"
-	depends on HAVE_CLK
-	help
-	  This option enables device driver support for the PWM channels
-	  on certain Atmel processors.  Pulse Width Modulation is used for
-	  purposes including software controlled power-efficient backlights
-	  on LCD displays, motor control, and waveform generation.
-
 config ATMEL_TCLIB
 	bool "Atmel AT32/AT91 Timer/Counter Library"
 	depends on (AVR32 || ARCH_AT91)
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 99b9424ce31d..8dd44f924cb0 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_AD525X_DPOT)	+= ad525x_dpot.o
 obj-$(CONFIG_AD525X_DPOT_I2C)	+= ad525x_dpot-i2c.o
 obj-$(CONFIG_AD525X_DPOT_SPI)	+= ad525x_dpot-spi.o
 obj-$(CONFIG_INTEL_MID_PTI)	+= pti.o
-obj-$(CONFIG_ATMEL_PWM)		+= atmel_pwm.o
 obj-$(CONFIG_ATMEL_SSC)		+= atmel-ssc.o
 obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
 obj-$(CONFIG_BMP085)		+= bmp085.o
diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
deleted file mode 100644
index a6dc56e1bc58..000000000000
--- a/drivers/misc/atmel_pwm.c
+++ /dev/null
@@ -1,402 +0,0 @@
-#include <linux/module.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
-#include <linux/atmel_pwm.h>
-
-
-/*
- * This is a simple driver for the PWM controller found in various newer
- * Atmel SOCs, including the AVR32 series and the AT91sam9263.
- *
- * Chips with current Linux ports have only 4 PWM channels, out of max 32.
- * AT32UC3A and AT32UC3B chips have 7 channels (but currently no Linux).
- * Docs are inconsistent about the width of the channel counter registers;
- * it's at least 16 bits, but several places say 20 bits.
- */
-#define	PWM_NCHAN	4		/* max 32 */
-
-struct pwm {
-	spinlock_t		lock;
-	struct platform_device	*pdev;
-	u32			mask;
-	int			irq;
-	void __iomem		*base;
-	struct clk		*clk;
-	struct pwm_channel	*channel[PWM_NCHAN];
-	void			(*handler[PWM_NCHAN])(struct pwm_channel *);
-};
-
-
-/* global PWM controller registers */
-#define PWM_MR		0x00
-#define PWM_ENA		0x04
-#define PWM_DIS		0x08
-#define PWM_SR		0x0c
-#define PWM_IER		0x10
-#define PWM_IDR		0x14
-#define PWM_IMR		0x18
-#define PWM_ISR		0x1c
-
-static inline void pwm_writel(const struct pwm *p, unsigned offset, u32 val)
-{
-	__raw_writel(val, p->base + offset);
-}
-
-static inline u32 pwm_readl(const struct pwm *p, unsigned offset)
-{
-	return __raw_readl(p->base + offset);
-}
-
-static inline void __iomem *pwmc_regs(const struct pwm *p, int index)
-{
-	return p->base + 0x200 + index * 0x20;
-}
-
-static struct pwm *pwm;
-
-static void pwm_dumpregs(struct pwm_channel *ch, char *tag)
-{
-	struct device	*dev = &pwm->pdev->dev;
-
-	dev_dbg(dev, "%s: mr %08x, sr %08x, imr %08x\n",
-		tag,
-		pwm_readl(pwm, PWM_MR),
-		pwm_readl(pwm, PWM_SR),
-		pwm_readl(pwm, PWM_IMR));
-	dev_dbg(dev,
-		"pwm ch%d - mr %08x, dty %u, prd %u, cnt %u\n",
-		ch->index,
-		pwm_channel_readl(ch, PWM_CMR),
-		pwm_channel_readl(ch, PWM_CDTY),
-		pwm_channel_readl(ch, PWM_CPRD),
-		pwm_channel_readl(ch, PWM_CCNT));
-}
-
-
-/**
- * pwm_channel_alloc - allocate an unused PWM channel
- * @index: identifies the channel
- * @ch: structure to be initialized
- *
- * Drivers allocate PWM channels according to the board's wiring, and
- * matching board-specific setup code.  Returns zero or negative errno.
- */
-int pwm_channel_alloc(int index, struct pwm_channel *ch)
-{
-	unsigned long	flags;
-	int		status = 0;
-
-	if (!pwm)
-		return -EPROBE_DEFER;
-
-	if (!(pwm->mask & 1 << index))
-		return -ENODEV;
-
-	if (index < 0 || index >= PWM_NCHAN || !ch)
-		return -EINVAL;
-	memset(ch, 0, sizeof *ch);
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	if (pwm->channel[index])
-		status = -EBUSY;
-	else {
-		clk_enable(pwm->clk);
-
-		ch->regs = pwmc_regs(pwm, index);
-		ch->index = index;
-
-		/* REVISIT: ap7000 seems to go 2x as fast as we expect!! */
-		ch->mck = clk_get_rate(pwm->clk);
-
-		pwm->channel[index] = ch;
-		pwm->handler[index] = NULL;
-
-		/* channel and irq are always disabled when we return */
-		pwm_writel(pwm, PWM_DIS, 1 << index);
-		pwm_writel(pwm, PWM_IDR, 1 << index);
-	}
-	spin_unlock_irqrestore(&pwm->lock, flags);
-	return status;
-}
-EXPORT_SYMBOL(pwm_channel_alloc);
-
-static int pwmcheck(struct pwm_channel *ch)
-{
-	int		index;
-
-	if (!pwm)
-		return -ENODEV;
-	if (!ch)
-		return -EINVAL;
-	index = ch->index;
-	if (index < 0 || index >= PWM_NCHAN || pwm->channel[index] != ch)
-		return -EINVAL;
-
-	return index;
-}
-
-/**
- * pwm_channel_free - release a previously allocated channel
- * @ch: the channel being released
- *
- * The channel is completely shut down (counter and IRQ disabled),
- * and made available for re-use.  Returns zero, or negative errno.
- */
-int pwm_channel_free(struct pwm_channel *ch)
-{
-	unsigned long	flags;
-	int		t;
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	t = pwmcheck(ch);
-	if (t >= 0) {
-		pwm->channel[t] = NULL;
-		pwm->handler[t] = NULL;
-
-		/* channel and irq are always disabled when we return */
-		pwm_writel(pwm, PWM_DIS, 1 << t);
-		pwm_writel(pwm, PWM_IDR, 1 << t);
-
-		clk_disable(pwm->clk);
-		t = 0;
-	}
-	spin_unlock_irqrestore(&pwm->lock, flags);
-	return t;
-}
-EXPORT_SYMBOL(pwm_channel_free);
-
-int __pwm_channel_onoff(struct pwm_channel *ch, int enabled)
-{
-	unsigned long	flags;
-	int		t;
-
-	/* OMITTED FUNCTIONALITY:  starting several channels in synch */
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	t = pwmcheck(ch);
-	if (t >= 0) {
-		pwm_writel(pwm, enabled ? PWM_ENA : PWM_DIS, 1 << t);
-		t = 0;
-		pwm_dumpregs(ch, enabled ? "enable" : "disable");
-	}
-	spin_unlock_irqrestore(&pwm->lock, flags);
-
-	return t;
-}
-EXPORT_SYMBOL(__pwm_channel_onoff);
-
-/**
- * pwm_clk_alloc - allocate and configure CLKA or CLKB
- * @prescale: from 0..10, the power of two used to divide MCK
- * @div: from 1..255, the linear divisor to use
- *
- * Returns PWM_CPR_CLKA, PWM_CPR_CLKB, or negative errno.  The allocated
- * clock will run with a period of (2^prescale * div) / MCK, or twice as
- * long if center aligned PWM output is used.  The clock must later be
- * deconfigured using pwm_clk_free().
- */
-int pwm_clk_alloc(unsigned prescale, unsigned div)
-{
-	unsigned long	flags;
-	u32		mr;
-	u32		val = (prescale << 8) | div;
-	int		ret = -EBUSY;
-
-	if (prescale >= 10 || div == 0 || div > 255)
-		return -EINVAL;
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	mr = pwm_readl(pwm, PWM_MR);
-	if ((mr & 0xffff) == 0) {
-		mr |= val;
-		ret = PWM_CPR_CLKA;
-	} else if ((mr & (0xffff << 16)) == 0) {
-		mr |= val << 16;
-		ret = PWM_CPR_CLKB;
-	}
-	if (ret > 0)
-		pwm_writel(pwm, PWM_MR, mr);
-	spin_unlock_irqrestore(&pwm->lock, flags);
-	return ret;
-}
-EXPORT_SYMBOL(pwm_clk_alloc);
-
-/**
- * pwm_clk_free - deconfigure and release CLKA or CLKB
- *
- * Reverses the effect of pwm_clk_alloc().
- */
-void pwm_clk_free(unsigned clk)
-{
-	unsigned long	flags;
-	u32		mr;
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	mr = pwm_readl(pwm, PWM_MR);
-	if (clk == PWM_CPR_CLKA)
-		pwm_writel(pwm, PWM_MR, mr & ~(0xffff << 0));
-	if (clk == PWM_CPR_CLKB)
-		pwm_writel(pwm, PWM_MR, mr & ~(0xffff << 16));
-	spin_unlock_irqrestore(&pwm->lock, flags);
-}
-EXPORT_SYMBOL(pwm_clk_free);
-
-/**
- * pwm_channel_handler - manage channel's IRQ handler
- * @ch: the channel
- * @handler: the handler to use, possibly NULL
- *
- * If the handler is non-null, the handler will be called after every
- * period of this PWM channel.  If the handler is null, this channel
- * won't generate an IRQ.
- */
-int pwm_channel_handler(struct pwm_channel *ch,
-		void (*handler)(struct pwm_channel *ch))
-{
-	unsigned long	flags;
-	int		t;
-
-	spin_lock_irqsave(&pwm->lock, flags);
-	t = pwmcheck(ch);
-	if (t >= 0) {
-		pwm->handler[t] = handler;
-		pwm_writel(pwm, handler ? PWM_IER : PWM_IDR, 1 << t);
-		t = 0;
-	}
-	spin_unlock_irqrestore(&pwm->lock, flags);
-
-	return t;
-}
-EXPORT_SYMBOL(pwm_channel_handler);
-
-static irqreturn_t pwm_irq(int id, void *_pwm)
-{
-	struct pwm	*p = _pwm;
-	irqreturn_t	handled = IRQ_NONE;
-	u32		irqstat;
-	int		index;
-
-	spin_lock(&p->lock);
-
-	/* ack irqs, then handle them */
-	irqstat = pwm_readl(pwm, PWM_ISR);
-
-	while (irqstat) {
-		struct pwm_channel *ch;
-		void (*handler)(struct pwm_channel *ch);
-
-		index = ffs(irqstat) - 1;
-		irqstat &= ~(1 << index);
-		ch = pwm->channel[index];
-		handler = pwm->handler[index];
-		if (handler && ch) {
-			spin_unlock(&p->lock);
-			handler(ch);
-			spin_lock(&p->lock);
-			handled = IRQ_HANDLED;
-		}
-	}
-
-	spin_unlock(&p->lock);
-	return handled;
-}
-
-static int __init pwm_probe(struct platform_device *pdev)
-{
-	struct resource *r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int irq = platform_get_irq(pdev, 0);
-	u32 *mp = pdev->dev.platform_data;
-	struct pwm *p;
-	int status = -EIO;
-
-	if (pwm)
-		return -EBUSY;
-	if (!r || irq < 0 || !mp || !*mp)
-		return -ENODEV;
-	if (*mp & ~((1<<PWM_NCHAN)-1)) {
-		dev_warn(&pdev->dev, "mask 0x%x ... more than %d channels\n",
-			*mp, PWM_NCHAN);
-		return -EINVAL;
-	}
-
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	spin_lock_init(&p->lock);
-	p->pdev = pdev;
-	p->mask = *mp;
-	p->irq = irq;
-	p->base = ioremap(r->start, resource_size(r));
-	if (!p->base)
-		goto fail;
-	p->clk = clk_get(&pdev->dev, "pwm_clk");
-	if (IS_ERR(p->clk)) {
-		status = PTR_ERR(p->clk);
-		p->clk = NULL;
-		goto fail;
-	}
-
-	status = request_irq(irq, pwm_irq, 0, pdev->name, p);
-	if (status < 0)
-		goto fail;
-
-	pwm = p;
-	platform_set_drvdata(pdev, p);
-
-	return 0;
-
-fail:
-	if (p->clk)
-		clk_put(p->clk);
-	if (p->base)
-		iounmap(p->base);
-
-	kfree(p);
-	return status;
-}
-
-static int __exit pwm_remove(struct platform_device *pdev)
-{
-	struct pwm *p = platform_get_drvdata(pdev);
-
-	if (p != pwm)
-		return -EINVAL;
-
-	clk_enable(pwm->clk);
-	pwm_writel(pwm, PWM_DIS, (1 << PWM_NCHAN) - 1);
-	pwm_writel(pwm, PWM_IDR, (1 << PWM_NCHAN) - 1);
-	clk_disable(pwm->clk);
-
-	pwm = NULL;
-
-	free_irq(p->irq, p);
-	clk_put(p->clk);
-	iounmap(p->base);
-	kfree(p);
-
-	return 0;
-}
-
-static struct platform_driver atmel_pwm_driver = {
-	.driver = {
-		.name = "atmel_pwm",
-		.owner = THIS_MODULE,
-	},
-	.remove = __exit_p(pwm_remove),
-
-	/* NOTE: PWM can keep running in AVR32 "idle" and "frozen" states;
-	 * and all AT91sam9263 states, albeit at reduced clock rate if
-	 * MCK becomes the slow clock (i.e. what Linux labels STR).
-	 */
-};
-
-module_platform_driver_probe(atmel_pwm_driver, pwm_probe);
-
-MODULE_DESCRIPTION("Driver for AT32/AT91 PWM module");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:atmel_pwm");
diff --git a/include/linux/atmel_pwm.h b/include/linux/atmel_pwm.h
deleted file mode 100644
index ea04abb3db8e..000000000000
--- a/include/linux/atmel_pwm.h
+++ /dev/null
@@ -1,70 +0,0 @@
-#ifndef __LINUX_ATMEL_PWM_H
-#define __LINUX_ATMEL_PWM_H
-
-/**
- * struct pwm_channel - driver handle to a PWM channel
- * @regs: base of this channel's registers
- * @index: number of this channel (0..31)
- * @mck: base clock rate, which can be prescaled and maybe subdivided
- *
- * Drivers initialize a pwm_channel structure using pwm_channel_alloc().
- * Then they configure its clock rate (derived from MCK), alignment,
- * polarity, and duty cycle by writing directly to the channel registers,
- * before enabling the channel by calling pwm_channel_enable().
- *
- * After emitting a PWM signal for the desired length of time, drivers
- * may then pwm_channel_disable() or pwm_channel_free().  Both of these
- * disable the channel, but when it's freed the IRQ is deconfigured and
- * the channel must later be re-allocated and reconfigured.
- *
- * Note that if the period or duty cycle need to be changed while the
- * PWM channel is operating, drivers must use the PWM_CUPD double buffer
- * mechanism, either polling until they change or getting implicitly
- * notified through a once-per-period interrupt handler.
- */
-struct pwm_channel {
-	void __iomem	*regs;
-	unsigned	index;
-	unsigned long	mck;
-};
-
-extern int pwm_channel_alloc(int index, struct pwm_channel *ch);
-extern int pwm_channel_free(struct pwm_channel *ch);
-
-extern int pwm_clk_alloc(unsigned prescale, unsigned div);
-extern void pwm_clk_free(unsigned clk);
-
-extern int __pwm_channel_onoff(struct pwm_channel *ch, int enabled);
-
-#define pwm_channel_enable(ch)	__pwm_channel_onoff((ch), 1)
-#define pwm_channel_disable(ch)	__pwm_channel_onoff((ch), 0)
-
-/* periodic interrupts, mostly for CUPD changes to period or cycle */
-extern int pwm_channel_handler(struct pwm_channel *ch,
-		void (*handler)(struct pwm_channel *ch));
-
-/* per-channel registers (banked at pwm_channel->regs) */
-#define PWM_CMR		0x00		/* mode register */
-#define		PWM_CPR_CPD	(1 << 10)	/* set: CUPD modifies period */
-#define		PWM_CPR_CPOL	(1 << 9)	/* set: idle high */
-#define		PWM_CPR_CALG	(1 << 8)	/* set: center align */
-#define		PWM_CPR_CPRE	(0xf << 0)	/* mask: rate is mck/(2^pre) */
-#define		PWM_CPR_CLKA	(0xb << 0)	/* rate CLKA */
-#define		PWM_CPR_CLKB	(0xc << 0)	/* rate CLKB */
-#define PWM_CDTY	0x04		/* duty cycle (max of CPRD) */
-#define PWM_CPRD	0x08		/* period (count up from zero) */
-#define PWM_CCNT	0x0c		/* counter (20 bits?) */
-#define PWM_CUPD	0x10		/* update CPRD (or CDTY) next period */
-
-static inline void
-pwm_channel_writel(struct pwm_channel *pwmc, unsigned offset, u32 val)
-{
-	__raw_writel(val, pwmc->regs + offset);
-}
-
-static inline u32 pwm_channel_readl(struct pwm_channel *pwmc, unsigned offset)
-{
-	return __raw_readl(pwmc->regs + offset);
-}
-
-#endif /* __LINUX_ATMEL_PWM_H */
-- 
1.8.3.2

