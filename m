Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaJ0LKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:10:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57615 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaJ0LK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:10:27 -0400
From: Vignesh R <vigneshr@ti.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jan Kardell <jan.kardell@telliq.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Brad Griffis <bgriffis@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, Vignesh R <vigneshr@ti.com>
Subject: [PATCH 2/4] input: touchscreen: ti_am335x_tsc: Remove udelay in interrupt handler
Date: Mon, 27 Oct 2014 16:38:29 +0530
Message-ID: <1414408111-2631-3-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brad Griffis <bgriffis@ti.com>

TSC interrupt handler had udelay to avoid reporting of false pen-up
interrupt to user space. This patch implements workaround suggesting in
Advisory 1.0.31 of silicon errata for am335x, thus eliminating udelay
and touchscreen lag. This also improves performance of touchscreen and
eliminates sudden jump of cursor at touch release.

IDLECONFIG and CHARGECONFIG registers are to be configured
with same values in order to eliminate false pen-up events. This
workaround may result in false pen-down to be detected, hence considerable
charge step delay needs to be added. The charge delay is set to 0xB000
(in terms of ADC clock cycles) by default.

TSC steps are disabled at the end of every sampling cycle and EOS bit is
set. Once the EOS bit is set, the TSC steps need to be re-enabled to begin
next sampling cycle.

In one shot mode, sequencer automatically disables all enabled steps at
the end of each cycle. (both ADC steps and TSC steps) Hence these steps
need not be saved in reg_se_cache for clearing these steps at a later
stage.

Signed-off-by: Brad Griffis <bgriffis@ti.com>
[vigneshr@ti.com: Ported patch from v3.12 to v3.18rc2]
Signed-off-by: Vignesh R <vigneshr@ti.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c | 56 ++++++++++++-------------------
 drivers/mfd/ti_am335x_tscadc.c            |  7 ++--
 include/linux/mfd/ti_am335x_tscadc.h      |  4 ++-
 3 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 1aeac9675fe7..483fd97c0e0c 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -173,11 +173,9 @@ static void titsc_step_config(struct titsc *ts_dev)
 		titsc_writel(ts_dev, REG_STEPDELAY(i), STEPCONFIG_OPENDLY);
 	}
 
-	/* Charge step configuration */
-	config = ts_dev->bit_xp | ts_dev->bit_yn |
-			STEPCHARGE_RFP_XPUL | STEPCHARGE_RFM_XNUR |
-			STEPCHARGE_INM_AN1 | STEPCHARGE_INP(ts_dev->inp_yp);
+	/* Make CHARGECONFIG same as IDLECONFIG */
 
+	config = titsc_readl(ts_dev, REG_IDLECONFIG);
 	titsc_writel(ts_dev, REG_CHARGECONFIG, config);
 	titsc_writel(ts_dev, REG_CHARGEDELAY, CHARGEDLY_OPENDLY);
 
@@ -264,9 +262,26 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	unsigned int status, irqclr = 0;
 	unsigned int x = 0, y = 0;
 	unsigned int z1, z2, z;
-	unsigned int fsm;
 
-	status = titsc_readl(ts_dev, REG_IRQSTATUS);
+	status = titsc_readl(ts_dev, REG_RAWIRQSTATUS);
+	if (status & IRQENB_HW_PEN) {
+		ts_dev->pen_down = true;
+		titsc_writel(ts_dev, REG_IRQWAKEUP, 0x00);
+		titsc_writel(ts_dev, REG_IRQCLR, IRQENB_HW_PEN);
+		irqclr |= IRQENB_HW_PEN;
+	}
+
+	if (status & IRQENB_PENUP) {
+		ts_dev->pen_down = false;
+		input_report_key(input_dev, BTN_TOUCH, 0);
+		input_report_abs(input_dev, ABS_PRESSURE, 0);
+		input_sync(input_dev);
+		irqclr |= IRQENB_PENUP;
+	}
+
+	if (status & IRQENB_EOS)
+		irqclr |= IRQENB_EOS;
+
 	/*
 	 * ADC and touchscreen share the IRQ line.
 	 * FIFO1 interrupts are used by ADC. Handle FIFO0 IRQs here only
@@ -297,34 +312,6 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 		}
 		irqclr |= IRQENB_FIFO0THRES;
 	}
-
-	/*
-	 * Time for sequencer to settle, to read
-	 * correct state of the sequencer.
-	 */
-	udelay(SEQ_SETTLE);
-
-	status = titsc_readl(ts_dev, REG_RAWIRQSTATUS);
-	if (status & IRQENB_PENUP) {
-		/* Pen up event */
-		fsm = titsc_readl(ts_dev, REG_ADCFSM);
-		if (fsm == ADCFSM_STEPID) {
-			ts_dev->pen_down = false;
-			input_report_key(input_dev, BTN_TOUCH, 0);
-			input_report_abs(input_dev, ABS_PRESSURE, 0);
-			input_sync(input_dev);
-		} else {
-			ts_dev->pen_down = true;
-		}
-		irqclr |= IRQENB_PENUP;
-	}
-
-	if (status & IRQENB_HW_PEN) {
-
-		titsc_writel(ts_dev, REG_IRQWAKEUP, 0x00);
-		titsc_writel(ts_dev, REG_IRQCLR, IRQENB_HW_PEN);
-	}
-
 	if (irqclr) {
 		titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
 		am335x_tsc_se_set_cache(ts_dev->mfd_tscadc, ts_dev->step_mask);
@@ -417,6 +404,7 @@ static int titsc_probe(struct platform_device *pdev)
 	}
 
 	titsc_writel(ts_dev, REG_IRQENABLE, IRQENB_FIFO0THRES);
+	titsc_writel(ts_dev, REG_IRQENABLE, IRQENB_EOS);
 	err = titsc_config_wires(ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "wrong i/p wire configuration\n");
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index d877e777cce6..94ef8992f46b 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -86,8 +86,12 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
 		spin_lock_irq(&tsadc->reg_lock);
 		finish_wait(&tsadc->reg_se_wait, &wait);
 
+		/*
+		 * Sequencer should either be idle or
+		 * busy applying the charge step.
+		 */
 		reg = tscadc_readl(tsadc, REG_ADCFSM);
-		WARN_ON(reg & SEQ_STATUS);
+		WARN_ON(reg & SEQ_STATUS & (!CHARGE_STEP));
 		tsadc->adc_waiting = false;
 	}
 	tsadc->adc_in_use = true;
@@ -96,7 +100,6 @@ static void am335x_tscadc_need_adc(struct ti_tscadc_dev *tsadc)
 void am335x_tsc_se_set_once(struct ti_tscadc_dev *tsadc, u32 val)
 {
 	spin_lock_irq(&tsadc->reg_lock);
-	tsadc->reg_se_cache |= val;
 	am335x_tscadc_need_adc(tsadc);
 
 	tscadc_writel(tsadc, REG_SE, val);
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index e2e70053470e..fcce182e4a35 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -52,6 +52,7 @@
 
 /* IRQ enable */
 #define IRQENB_HW_PEN		BIT(0)
+#define IRQENB_EOS		BIT(1)
 #define IRQENB_FIFO0THRES	BIT(2)
 #define IRQENB_FIFO0OVRRUN	BIT(3)
 #define IRQENB_FIFO0UNDRFLW	BIT(4)
@@ -107,7 +108,7 @@
 /* Charge delay */
 #define CHARGEDLY_OPEN_MASK	(0x3FFFF << 0)
 #define CHARGEDLY_OPEN(val)	((val) << 0)
-#define CHARGEDLY_OPENDLY	CHARGEDLY_OPEN(1)
+#define CHARGEDLY_OPENDLY	CHARGEDLY_OPEN(0xB000)
 
 /* Control register */
 #define CNTRLREG_TSCSSENB	BIT(0)
@@ -127,6 +128,7 @@
 
 /* Sequencer Status */
 #define SEQ_STATUS BIT(5)
+#define CHARGE_STEP		0x11
 
 #define ADC_CLK			3000000
 #define TOTAL_STEPS		16
-- 
1.9.1

