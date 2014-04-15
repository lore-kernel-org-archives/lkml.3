Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaDOKdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:33:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39038 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754454AbaDOK2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:28:18 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 04/15] iio: adc: at91_adc: Add support for touchscreens without TSMR
Date: Tue, 15 Apr 2014 12:27:59 +0200
Message-Id: <1397557690-5650-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397557690-5650-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old ADCs, as present on the sam9rl and the sam9g45 don't have a TSMR register
and the touchscreen support should be handled differently.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
---
 arch/arm/mach-at91/include/mach/at91_adc.h |  13 ++
 drivers/iio/adc/at91_adc.c                 | 200 ++++++++++++++++++++++-------
 include/linux/platform_data/at91_adc.h     |   8 ++
 3 files changed, 174 insertions(+), 47 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/at91_adc.h b/arch/arm/mach-at91/include/mach/at91_adc.h
index c287307b9a3b..7d80396346b2 100644
--- a/arch/arm/mach-at91/include/mach/at91_adc.h
+++ b/arch/arm/mach-at91/include/mach/at91_adc.h
@@ -20,6 +20,9 @@
 #define		AT91_ADC_START		(1 << 1)	/* Start Conversion */
 
 #define AT91_ADC_MR		0x04		/* Mode Register */
+#define		AT91_ADC_TSAMOD		(3 << 0)	/* ADC mode */
+#define		AT91_ADC_TSAMOD_ADC_ONLY_MODE		(0 << 0)	/* ADC Mode */
+#define		AT91_ADC_TSAMOD_TS_ONLY_MODE		(1 << 0)	/* Touch Screen Only Mode */
 #define		AT91_ADC_TRGEN		(1 << 0)	/* Trigger Enable */
 #define		AT91_ADC_TRGSEL		(7 << 1)	/* Trigger Selection */
 #define			AT91_ADC_TRGSEL_TC0		(0 << 1)
@@ -28,6 +31,7 @@
 #define			AT91_ADC_TRGSEL_EXTERNAL	(6 << 1)
 #define		AT91_ADC_LOWRES		(1 << 4)	/* Low Resolution */
 #define		AT91_ADC_SLEEP		(1 << 5)	/* Sleep Mode */
+#define		AT91_ADC_PENDET		(1 << 6)	/* Pen contact detection enable */
 #define		AT91_ADC_PRESCAL_9260	(0x3f << 8)	/* Prescalar Rate Selection */
 #define		AT91_ADC_PRESCAL_9G45	(0xff << 8)
 #define			AT91_ADC_PRESCAL_(x)	((x) << 8)
@@ -37,6 +41,12 @@
 #define			AT91_ADC_STARTUP_(x)	((x) << 16)
 #define		AT91_ADC_SHTIM		(0xf  << 24)	/* Sample & Hold Time */
 #define			AT91_ADC_SHTIM_(x)	((x) << 24)
+#define		AT91_ADC_PENDBC		(0x0f << 28)	/* Pen Debounce time */
+#define			AT91_ADC_PENDBC_(x)	((x) << 28)
+
+#define AT91_ADC_TSR		0x0C
+#define		AT91_ADC_TSR_SHTIM	(0xf  << 24)	/* Sample & Hold Time */
+#define			AT91_ADC_TSR_SHTIM_(x)	((x) << 24)
 
 #define AT91_ADC_CHER		0x10		/* Channel Enable Register */
 #define AT91_ADC_CHDR		0x14		/* Channel Disable Register */
@@ -60,6 +70,8 @@
 #define AT91_ADC_IER		0x24		/* Interrupt Enable Register */
 #define AT91_ADC_IDR		0x28		/* Interrupt Disable Register */
 #define AT91_ADC_IMR		0x2C		/* Interrupt Mask Register */
+#define		AT91RL_ADC_IER_PEN	(1 << 20)
+#define		AT91RL_ADC_IER_NOPEN	(1 << 21)
 #define		AT91_ADC_IER_PEN	(1 << 29)
 #define		AT91_ADC_IER_NOPEN	(1 << 30)
 #define		AT91_ADC_IER_XRDY	(1 << 20)
@@ -102,6 +114,7 @@
 #define		AT91_ADC_TRGR_TRGPER	(0xffff << 16)
 #define			AT91_ADC_TRGR_TRGPER_(x)	((x) << 16)
 #define		AT91_ADC_TRGR_TRGMOD	(0x7 << 0)
+#define			AT91_ADC_TRGR_NONE		(0 << 0)
 #define			AT91_ADC_TRGR_MOD_PERIOD_TRIG	(5 << 0)
 
 #endif
diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 1beae65aef2c..c0e4206e34e5 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -46,6 +46,10 @@
 #define TOUCH_SAMPLE_PERIOD_US		2000	/* 2ms */
 #define TOUCH_PEN_DETECT_DEBOUNCE_US	200
 
+#define MAX_RLPOS_BITS         10
+#define TOUCH_SAMPLE_PERIOD_US_RL      10000   /* 10ms, the SoC can't keep up with 2ms */
+#define TOUCH_SHTIM                    0xa
+
 /**
  * struct at91_adc_reg_desc - Various informations relative to registers
  * @channel_base:	Base offset for the channel data registers
@@ -83,12 +87,6 @@ struct at91_adc_caps {
 	struct at91_adc_reg_desc registers;
 };
 
-enum atmel_adc_ts_type {
-	ATMEL_ADC_TOUCHSCREEN_NONE = 0,
-	ATMEL_ADC_TOUCHSCREEN_4WIRE = 4,
-	ATMEL_ADC_TOUCHSCREEN_5WIRE = 5,
-};
-
 struct at91_adc_state {
 	struct clk		*adc_clk;
 	u16			*buffer;
@@ -133,6 +131,11 @@ struct at91_adc_state {
 
 	u16			ts_sample_period_val;
 	u32			ts_pressure_threshold;
+	u16			ts_pendbc;
+
+	bool			ts_bufferedmeasure;
+	u32			ts_prev_absx;
+	u32			ts_prev_absy;
 };
 
 static irqreturn_t at91_adc_trigger_handler(int irq, void *p)
@@ -239,7 +242,72 @@ static int at91_ts_sample(struct at91_adc_state *st)
 	return 0;
 }
 
-static irqreturn_t at91_adc_interrupt(int irq, void *private)
+static irqreturn_t at91_adc_rl_interrupt(int irq, void *private)
+{
+	struct iio_dev *idev = private;
+	struct at91_adc_state *st = iio_priv(idev);
+	u32 status = at91_adc_readl(st, st->registers->status_register);
+	unsigned int reg;
+
+	status &= at91_adc_readl(st, AT91_ADC_IMR);
+	if (status & st->registers->drdy_mask)
+		handle_adc_eoc_trigger(irq, idev);
+
+	if (status & AT91RL_ADC_IER_PEN) {
+		/* Disabling pen debounce is required to get a NOPEN irq */
+		reg = at91_adc_readl(st, AT91_ADC_MR);
+		reg &= ~AT91_ADC_PENDBC;
+		at91_adc_writel(st, AT91_ADC_MR, reg);
+
+		at91_adc_writel(st, AT91_ADC_IDR, AT91RL_ADC_IER_PEN);
+		at91_adc_writel(st, AT91_ADC_IER, AT91RL_ADC_IER_NOPEN
+				| AT91_ADC_EOC(3));
+		/* Set up period trigger for sampling */
+		at91_adc_writel(st, st->registers->trigger_register,
+			AT91_ADC_TRGR_MOD_PERIOD_TRIG |
+			AT91_ADC_TRGR_TRGPER_(st->ts_sample_period_val));
+	} else if (status & AT91RL_ADC_IER_NOPEN) {
+		reg = at91_adc_readl(st, AT91_ADC_MR);
+		reg |= AT91_ADC_PENDBC_(st->ts_pendbc) & AT91_ADC_PENDBC;
+		at91_adc_writel(st, AT91_ADC_MR, reg);
+		at91_adc_writel(st, st->registers->trigger_register,
+			AT91_ADC_TRGR_NONE);
+
+		at91_adc_writel(st, AT91_ADC_IDR, AT91RL_ADC_IER_NOPEN
+				| AT91_ADC_EOC(3));
+		at91_adc_writel(st, AT91_ADC_IER, AT91RL_ADC_IER_PEN);
+		st->ts_bufferedmeasure = false;
+		input_report_key(st->ts_input, BTN_TOUCH, 0);
+		input_sync(st->ts_input);
+	} else if (status & AT91_ADC_EOC(3)) {
+		/* Conversion finished */
+		if (st->ts_bufferedmeasure) {
+			/*
+			 * Last measurement is always discarded, since it can
+			 * be erroneous.
+			 * Always report previous measurement
+			 */
+			input_report_abs(st->ts_input, ABS_X, st->ts_prev_absx);
+			input_report_abs(st->ts_input, ABS_Y, st->ts_prev_absy);
+			input_report_key(st->ts_input, BTN_TOUCH, 1);
+			input_sync(st->ts_input);
+		} else
+			st->ts_bufferedmeasure = true;
+
+		/* Now make new measurement */
+		st->ts_prev_absx = at91_adc_readl(st, AT91_ADC_CHAN(st, 3))
+				   << MAX_RLPOS_BITS;
+		st->ts_prev_absx /= at91_adc_readl(st, AT91_ADC_CHAN(st, 2));
+
+		st->ts_prev_absy = at91_adc_readl(st, AT91_ADC_CHAN(st, 1))
+				   << MAX_RLPOS_BITS;
+		st->ts_prev_absy /= at91_adc_readl(st, AT91_ADC_CHAN(st, 0));
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t at91_adc_9x5_interrupt(int irq, void *private)
 {
 	struct iio_dev *idev = private;
 	struct at91_adc_state *st = iio_priv(idev);
@@ -672,6 +740,8 @@ static int at91_adc_probe_dt_ts(struct device_node *node,
 		return -EINVAL;
 	}
 
+	if (!st->caps->has_tsmr)
+		return 0;
 	prop = 0;
 	of_property_read_u32(node, "atmel,adc-ts-pressure-threshold", &prop);
 	st->ts_pressure_threshold = prop;
@@ -795,6 +865,7 @@ static int at91_adc_probe_pdata(struct at91_adc_state *st,
 	st->trigger_number = pdata->trigger_number;
 	st->trigger_list = pdata->trigger_list;
 	st->registers = &st->caps->registers;
+	st->touchscreen_type = pdata->touchscreen_type;
 
 	return 0;
 }
@@ -809,7 +880,10 @@ static int atmel_ts_open(struct input_dev *dev)
 {
 	struct at91_adc_state *st = input_get_drvdata(dev);
 
-	at91_adc_writel(st, AT91_ADC_IER, AT91_ADC_IER_PEN);
+	if (st->caps->has_tsmr)
+		at91_adc_writel(st, AT91_ADC_IER, AT91_ADC_IER_PEN);
+	else
+		at91_adc_writel(st, AT91_ADC_IER, AT91RL_ADC_IER_PEN);
 	return 0;
 }
 
@@ -817,45 +891,61 @@ static void atmel_ts_close(struct input_dev *dev)
 {
 	struct at91_adc_state *st = input_get_drvdata(dev);
 
-	at91_adc_writel(st, AT91_ADC_IDR, AT91_ADC_IER_PEN);
+	if (st->caps->has_tsmr)
+		at91_adc_writel(st, AT91_ADC_IDR, AT91_ADC_IER_PEN);
+	else
+		at91_adc_writel(st, AT91_ADC_IDR, AT91RL_ADC_IER_PEN);
 }
 
 static int at91_ts_hw_init(struct at91_adc_state *st, u32 adc_clk_khz)
 {
-	u32 reg = 0, pendbc;
+	u32 reg = 0;
 	int i = 0;
 
-	if (st->touchscreen_type == ATMEL_ADC_TOUCHSCREEN_4WIRE)
-		reg = AT91_ADC_TSMR_TSMODE_4WIRE_PRESS;
-	else
-		reg = AT91_ADC_TSMR_TSMODE_5WIRE;
-
 	/* a Pen Detect Debounce Time is necessary for the ADC Touch to avoid
 	 * pen detect noise.
 	 * The formula is : Pen Detect Debounce Time = (2 ^ pendbc) / ADCClock
 	 */
-	pendbc = round_up(TOUCH_PEN_DETECT_DEBOUNCE_US * adc_clk_khz / 1000, 1);
+	st->ts_pendbc = round_up(TOUCH_PEN_DETECT_DEBOUNCE_US * adc_clk_khz /
+				 1000, 1);
 
-	while (pendbc >> ++i)
+	while (st->ts_pendbc >> ++i)
 		;	/* Empty! Find the shift offset */
-	if (abs(pendbc - (1 << i)) < abs(pendbc - (1 << (i - 1))))
-		pendbc = i;
+	if (abs(st->ts_pendbc - (1 << i)) < abs(st->ts_pendbc - (1 << (i - 1))))
+		st->ts_pendbc = i;
 	else
-		pendbc = i - 1;
+		st->ts_pendbc = i - 1;
 
-	if (st->caps->has_tsmr) {
-		reg |= AT91_ADC_TSMR_TSAV_(st->caps->ts_filter_average)
-				& AT91_ADC_TSMR_TSAV;
-		reg |= AT91_ADC_TSMR_PENDBC_(pendbc) & AT91_ADC_TSMR_PENDBC;
-		reg |= AT91_ADC_TSMR_NOTSDMA;
-		reg |= AT91_ADC_TSMR_PENDET_ENA;
-		reg |= 0x03 << 8;	/* TSFREQ, need bigger than TSAV */
-
-		at91_adc_writel(st, AT91_ADC_TSMR, reg);
-	} else {
-		/* TODO: for 9g45 which has no TSMR */
+	if (!st->caps->has_tsmr) {
+		reg = at91_adc_readl(st, AT91_ADC_MR);
+		reg |= AT91_ADC_TSAMOD_TS_ONLY_MODE | AT91_ADC_PENDET;
+
+		reg |= AT91_ADC_PENDBC_(st->ts_pendbc) & AT91_ADC_PENDBC;
+		at91_adc_writel(st, AT91_ADC_MR, reg);
+
+		reg = AT91_ADC_TSR_SHTIM_(TOUCH_SHTIM) & AT91_ADC_TSR_SHTIM;
+		at91_adc_writel(st, AT91_ADC_TSR, reg);
+
+		st->ts_sample_period_val = round_up((TOUCH_SAMPLE_PERIOD_US_RL *
+						    adc_clk_khz / 1000) - 1, 1);
+
+		return 0;
 	}
 
+	if (st->touchscreen_type == ATMEL_ADC_TOUCHSCREEN_4WIRE)
+		reg = AT91_ADC_TSMR_TSMODE_4WIRE_PRESS;
+	else
+		reg = AT91_ADC_TSMR_TSMODE_5WIRE;
+
+	reg |= AT91_ADC_TSMR_TSAV_(st->caps->ts_filter_average)
+	       & AT91_ADC_TSMR_TSAV;
+	reg |= AT91_ADC_TSMR_PENDBC_(st->ts_pendbc) & AT91_ADC_TSMR_PENDBC;
+	reg |= AT91_ADC_TSMR_NOTSDMA;
+	reg |= AT91_ADC_TSMR_PENDET_ENA;
+	reg |= 0x03 << 8;	/* TSFREQ, needs to be bigger than TSAV */
+
+	at91_adc_writel(st, AT91_ADC_TSMR, reg);
+
 	/* Change adc internal resistor value for better pen detection,
 	 * default value is 100 kOhm.
 	 * 0 = 200 kOhm, 1 = 150 kOhm, 2 = 100 kOhm, 3 = 50 kOhm
@@ -864,7 +954,7 @@ static int at91_ts_hw_init(struct at91_adc_state *st, u32 adc_clk_khz)
 	at91_adc_writel(st, AT91_ADC_ACR, st->caps->ts_pen_detect_sensitivity
 			& AT91_ADC_ACR_PENDETSENS);
 
-	/* Sample Peroid Time = (TRGPER + 1) / ADCClock */
+	/* Sample Period Time = (TRGPER + 1) / ADCClock */
 	st->ts_sample_period_val = round_up((TOUCH_SAMPLE_PERIOD_US *
 			adc_clk_khz / 1000) - 1, 1);
 
@@ -893,17 +983,37 @@ static int at91_ts_register(struct at91_adc_state *st,
 	__set_bit(EV_ABS, input->evbit);
 	__set_bit(EV_KEY, input->evbit);
 	__set_bit(BTN_TOUCH, input->keybit);
-	input_set_abs_params(input, ABS_X, 0, (1 << MAX_POS_BITS) - 1, 0, 0);
-	input_set_abs_params(input, ABS_Y, 0, (1 << MAX_POS_BITS) - 1, 0, 0);
-	input_set_abs_params(input, ABS_PRESSURE, 0, 0xffffff, 0, 0);
+	if (st->caps->has_tsmr) {
+		input_set_abs_params(input, ABS_X, 0, (1 << MAX_POS_BITS) - 1,
+				     0, 0);
+		input_set_abs_params(input, ABS_Y, 0, (1 << MAX_POS_BITS) - 1,
+				     0, 0);
+		input_set_abs_params(input, ABS_PRESSURE, 0, 0xffffff, 0, 0);
+	} else {
+		if (st->touchscreen_type != ATMEL_ADC_TOUCHSCREEN_4WIRE) {
+			dev_err(&pdev->dev,
+				"This touchscreen controller only support 4 wires\n");
+			ret = -EINVAL;
+			goto err;
+		}
+
+		input_set_abs_params(input, ABS_X, 0, (1 << MAX_RLPOS_BITS) - 1,
+				     0, 0);
+		input_set_abs_params(input, ABS_Y, 0, (1 << MAX_RLPOS_BITS) - 1,
+				     0, 0);
+	}
 
 	st->ts_input = input;
 	input_set_drvdata(input, st);
 
 	ret = input_register_device(input);
 	if (ret)
-		input_free_device(st->ts_input);
+		goto err;
+
+	return ret;
 
+err:
+	input_free_device(st->ts_input);
 	return ret;
 }
 
@@ -962,11 +1072,13 @@ static int at91_adc_probe(struct platform_device *pdev)
 	 */
 	at91_adc_writel(st, AT91_ADC_CR, AT91_ADC_SWRST);
 	at91_adc_writel(st, AT91_ADC_IDR, 0xFFFFFFFF);
-	ret = request_irq(st->irq,
-			  at91_adc_interrupt,
-			  0,
-			  pdev->dev.driver->name,
-			  idev);
+
+	if (st->caps->has_tsmr)
+		ret = request_irq(st->irq, at91_adc_9x5_interrupt, 0,
+				  pdev->dev.driver->name, idev);
+	else
+		ret = request_irq(st->irq, at91_adc_rl_interrupt, 0,
+				  pdev->dev.driver->name, idev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to allocate IRQ.\n");
 		return ret;
@@ -1070,12 +1182,6 @@ static int at91_adc_probe(struct platform_device *pdev)
 			goto error_disable_adc_clk;
 		}
 	} else {
-		if (!st->caps->has_tsmr) {
-			dev_err(&pdev->dev, "We don't support non-TSMR adc\n");
-			ret = -ENODEV;
-			goto error_disable_adc_clk;
-		}
-
 		ret = at91_ts_register(st, pdev);
 		if (ret)
 			goto error_disable_adc_clk;
diff --git a/include/linux/platform_data/at91_adc.h b/include/linux/platform_data/at91_adc.h
index fcf73879dbfe..7819fc787731 100644
--- a/include/linux/platform_data/at91_adc.h
+++ b/include/linux/platform_data/at91_adc.h
@@ -7,6 +7,12 @@
 #ifndef _AT91_ADC_H_
 #define _AT91_ADC_H_
 
+enum atmel_adc_ts_type {
+	ATMEL_ADC_TOUCHSCREEN_NONE = 0,
+	ATMEL_ADC_TOUCHSCREEN_4WIRE = 4,
+	ATMEL_ADC_TOUCHSCREEN_5WIRE = 5,
+};
+
 /**
  * struct at91_adc_trigger - description of triggers
  * @name:		name of the trigger advertised to the user
@@ -28,6 +34,7 @@ struct at91_adc_trigger {
  * @trigger_number:		Number of triggers available in the ADC
  * @use_external_triggers:	does the board has external triggers availables
  * @vref:			Reference voltage for the ADC in millivolts
+ * @touchscreen_type:		If a touchscreen is connected, its type (4 or 5 wires)
  */
 struct at91_adc_data {
 	unsigned long			channels_used;
@@ -36,6 +43,7 @@ struct at91_adc_data {
 	u8				trigger_number;
 	bool				use_external_triggers;
 	u16				vref;
+	enum atmel_adc_ts_type		touchscreen_type;
 };
 
 extern void __init at91_add_device_adc(struct at91_adc_data *data);
-- 
1.8.3.2

