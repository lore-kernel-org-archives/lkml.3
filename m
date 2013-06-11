Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3FKLdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:33:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:33413 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3FKLbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:31:42 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, "Patil, Rachna" <rachna@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 04/22] input/ti_am33x_tsc: Order of TSC wires, made configurable
Date: Tue, 11 Jun 2013 13:30:50 +0200
Message-Id: <1370950268-7224-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

The current driver expected touchscreen input
wires(XP,XN,YP,YN) to be connected in a particular order.
Making changes to accept this as platform data.

Signed-off-by: Patil, Rachna <rachna@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[bigeasy: larger rework of the patch, no config[4][4] array, smaller
          sized config_inp, no regbit_map(), shrinked
	  titsc_config_wires(), no config redo on resume, config_inp and
	  friends are now u32]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |  102 ++++++++++++++++++++++++-----
 include/linux/input/ti_am335x_tsc.h       |   12 ++++
 include/linux/mfd/ti_am335x_tscadc.h      |   10 ++-
 3 files changed, 105 insertions(+), 19 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 23d6a4d..56c6220 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -33,6 +33,13 @@
 #define SEQ_SETTLE		275
 #define MAX_12BIT		((1 << 12) - 1)
 
+static const int config_pins[] = {
+	XPP,
+	XNN,
+	YPP,
+	YNN,
+};
+
 struct titsc {
 	struct input_dev	*input;
 	struct ti_tscadc_dev	*mfd_tscadc;
@@ -41,6 +48,9 @@ struct titsc {
 	unsigned int		x_plate_resistance;
 	bool			pen_down;
 	int			steps_to_configure;
+	u32			config_inp[4];
+	u32			bit_xp, bit_xn, bit_yp, bit_yn;
+	u32			inp_xp, inp_xn, inp_yp, inp_yn;
 };
 
 static unsigned int titsc_readl(struct titsc *ts, unsigned int reg)
@@ -54,6 +64,58 @@ static void titsc_writel(struct titsc *tsc, unsigned int reg,
 	writel(val, tsc->mfd_tscadc->tscadc_base + reg);
 }
 
+static int titsc_config_wires(struct titsc *ts_dev)
+{
+	u32 analog_line[4];
+	u32 wire_order[4];
+	int i, bit_cfg;
+
+	for (i = 0; i < 4; i++) {
+		/*
+		 * Get the order in which TSC wires are attached
+		 * w.r.t. each of the analog input lines on the EVM.
+		 */
+		analog_line[i] = (ts_dev->config_inp[i] & 0xF0) >> 4;
+		wire_order[i] = ts_dev->config_inp[i] & 0x0F;
+		if (WARN_ON(analog_line[i] > 7))
+			return -EINVAL;
+		if (WARN_ON(wire_order[i] > ARRAY_SIZE(config_pins)))
+			return -EINVAL;
+	}
+
+	for (i = 0; i < 4; i++) {
+		int an_line;
+		int wi_order;
+
+		an_line = analog_line[i];
+		wi_order = wire_order[i];
+		bit_cfg = config_pins[wi_order];
+		if (bit_cfg == 0)
+			return -EINVAL;
+		switch (wi_order) {
+		case 0:
+			ts_dev->bit_xp = bit_cfg;
+			ts_dev->inp_xp = an_line;
+			break;
+
+		case 1:
+			ts_dev->bit_xn = bit_cfg;
+			ts_dev->inp_xn = an_line;
+			break;
+
+		case 2:
+			ts_dev->bit_yp = bit_cfg;
+			ts_dev->inp_yp = an_line;
+			break;
+		case 3:
+			ts_dev->bit_yn = bit_cfg;
+			ts_dev->inp_yn = an_line;
+			break;
+		}
+	}
+	return 0;
+}
+
 static void titsc_step_config(struct titsc *ts_dev)
 {
 	unsigned int	config;
@@ -64,18 +126,18 @@ static void titsc_step_config(struct titsc *ts_dev)
 	total_steps = 2 * ts_dev->steps_to_configure;
 
 	config = STEPCONFIG_MODE_HWSYNC |
-			STEPCONFIG_AVG_16 | STEPCONFIG_XPP;
+			STEPCONFIG_AVG_16 | ts_dev->bit_xp;
 	switch (ts_dev->wires) {
 	case 4:
-		config |= STEPCONFIG_INP_AN2 | STEPCONFIG_XNN;
+		config |= STEPCONFIG_INP(ts_dev->inp_yp) | ts_dev->bit_xn;
 		break;
 	case 5:
-		config |= STEPCONFIG_YNN |
-				STEPCONFIG_INP_AN4 | STEPCONFIG_XNN |
-				STEPCONFIG_YPP;
+		config |= ts_dev->bit_yn |
+				STEPCONFIG_INP_AN4 | ts_dev->bit_xn |
+				ts_dev->bit_yp;
 		break;
 	case 8:
-		config |= STEPCONFIG_INP_AN2 | STEPCONFIG_XNN;
+		config |= STEPCONFIG_INP(ts_dev->inp_yp) | ts_dev->bit_xn;
 		break;
 	}
 
@@ -86,18 +148,18 @@ static void titsc_step_config(struct titsc *ts_dev)
 
 	config = 0;
 	config = STEPCONFIG_MODE_HWSYNC |
-			STEPCONFIG_AVG_16 | STEPCONFIG_YNN |
+			STEPCONFIG_AVG_16 | ts_dev->bit_yn |
 			STEPCONFIG_INM_ADCREFM | STEPCONFIG_FIFO1;
 	switch (ts_dev->wires) {
 	case 4:
-		config |= STEPCONFIG_YPP;
+		config |= ts_dev->bit_yp | STEPCONFIG_INP(ts_dev->inp_xp);
 		break;
 	case 5:
-		config |= STEPCONFIG_XPP | STEPCONFIG_INP_AN4 |
-				STEPCONFIG_XNP | STEPCONFIG_YPN;
+		config |= ts_dev->bit_xp | STEPCONFIG_INP_AN4 |
+				ts_dev->bit_xn | ts_dev->bit_yp;
 		break;
 	case 8:
-		config |= STEPCONFIG_YPP;
+		config |= ts_dev->bit_yp | STEPCONFIG_INP(ts_dev->inp_xp);
 		break;
 	}
 
@@ -108,9 +170,9 @@ static void titsc_step_config(struct titsc *ts_dev)
 
 	config = 0;
 	/* Charge step configuration */
-	config = STEPCONFIG_XPP | STEPCONFIG_YNN |
+	config = ts_dev->bit_xp | ts_dev->bit_yn |
 			STEPCHARGE_RFP_XPUL | STEPCHARGE_RFM_XNUR |
-			STEPCHARGE_INM_AN1 | STEPCHARGE_INP_AN1;
+			STEPCHARGE_INM_AN1 | STEPCHARGE_INP(ts_dev->inp_yp);
 
 	titsc_writel(ts_dev, REG_CHARGECONFIG, config);
 	titsc_writel(ts_dev, REG_CHARGEDELAY, CHARGEDLY_OPENDLY);
@@ -118,13 +180,14 @@ static void titsc_step_config(struct titsc *ts_dev)
 	config = 0;
 	/* Configure to calculate pressure */
 	config = STEPCONFIG_MODE_HWSYNC |
-			STEPCONFIG_AVG_16 | STEPCONFIG_YPP |
-			STEPCONFIG_XNN | STEPCONFIG_INM_ADCREFM;
+			STEPCONFIG_AVG_16 | ts_dev->bit_yp |
+			ts_dev->bit_xn | STEPCONFIG_INM_ADCREFM |
+			STEPCONFIG_INP(ts_dev->inp_xp);
 	titsc_writel(ts_dev, REG_STEPCONFIG(total_steps + 1), config);
 	titsc_writel(ts_dev, REG_STEPDELAY(total_steps + 1),
 			STEPCONFIG_OPENDLY);
 
-	config |= STEPCONFIG_INP_AN3 | STEPCONFIG_FIFO1;
+	config |= STEPCONFIG_INP(ts_dev->inp_yn) | STEPCONFIG_FIFO1;
 	titsc_writel(ts_dev, REG_STEPCONFIG(total_steps + 2), config);
 	titsc_writel(ts_dev, REG_STEPDELAY(total_steps + 2),
 			STEPCONFIG_OPENDLY);
@@ -292,6 +355,8 @@ static int titsc_probe(struct platform_device *pdev)
 	ts_dev->wires = pdata->tsc_init->wires;
 	ts_dev->x_plate_resistance = pdata->tsc_init->x_plate_resistance;
 	ts_dev->steps_to_configure = pdata->tsc_init->steps_to_configure;
+	memcpy(ts_dev->config_inp, pdata->tsc_init->wire_config,
+			sizeof(pdata->tsc_init->wire_config));
 
 	err = request_irq(ts_dev->irq, titsc_irq,
 			  0, pdev->dev.driver->name, ts_dev);
@@ -301,6 +366,11 @@ static int titsc_probe(struct platform_device *pdev)
 	}
 
 	titsc_writel(ts_dev, REG_IRQENABLE, IRQENB_FIFO0THRES);
+	err = titsc_config_wires(ts_dev);
+	if (err) {
+		dev_err(&pdev->dev, "wrong i/p wire configuration\n");
+		goto err_free_irq;
+	}
 	titsc_step_config(ts_dev);
 	titsc_writel(ts_dev, REG_FIFO0THR, ts_dev->steps_to_configure);
 
diff --git a/include/linux/input/ti_am335x_tsc.h b/include/linux/input/ti_am335x_tsc.h
index 49269a2..6a66b4d 100644
--- a/include/linux/input/ti_am335x_tsc.h
+++ b/include/linux/input/ti_am335x_tsc.h
@@ -12,12 +12,24 @@
  *			A step configured to read a single
  *			co-ordinate value, can be applied
  *			more number of times for better results.
+ * @wire_config:	Different EVM's could have a different order
+ *			for connecting wires on touchscreen.
+ *			We need to provide an 8 bit number where in
+ *			the 1st four bits represent the analog lines
+ *			and the next 4 bits represent positive/
+ *			negative terminal on that input line.
+ *			Notations to represent the input lines and
+ *			terminals resoectively is as follows:
+ *			AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
+ *			XP  = 0, XN = 1, YP = 2, YN = 3.
+ *
  */
 
 struct tsc_data {
 	int wires;
 	int x_plate_resistance;
 	int steps_to_configure;
+	int wire_config[10];
 };
 
 #endif
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index eeead15..2d78af8 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -71,8 +71,6 @@
 #define STEPCONFIG_INM_ADCREFM	STEPCONFIG_INM(8)
 #define STEPCONFIG_INP_MASK	(0xF << 19)
 #define STEPCONFIG_INP(val)	((val) << 19)
-#define STEPCONFIG_INP_AN2	STEPCONFIG_INP(2)
-#define STEPCONFIG_INP_AN3	STEPCONFIG_INP(3)
 #define STEPCONFIG_INP_AN4	STEPCONFIG_INP(4)
 #define STEPCONFIG_INP_ADCREFM	STEPCONFIG_INP(8)
 #define STEPCONFIG_FIFO1	BIT(26)
@@ -94,7 +92,6 @@
 #define STEPCHARGE_INM_AN1	STEPCHARGE_INM(1)
 #define STEPCHARGE_INP_MASK	(0xF << 19)
 #define STEPCHARGE_INP(val)	((val) << 19)
-#define STEPCHARGE_INP_AN1	STEPCHARGE_INP(1)
 #define STEPCHARGE_RFM_MASK	(3 << 23)
 #define STEPCHARGE_RFM(val)	((val) << 23)
 #define STEPCHARGE_RFM_XNUR	STEPCHARGE_RFM(1)
@@ -116,6 +113,13 @@
 #define CNTRLREG_8WIRE		CNTRLREG_AFE_CTRL(3)
 #define CNTRLREG_TSCENB		BIT(7)
 
+#define XPP			STEPCONFIG_XPP
+#define XNP			STEPCONFIG_XNP
+#define XNN			STEPCONFIG_XNN
+#define YPP			STEPCONFIG_YPP
+#define YPN			STEPCONFIG_YPN
+#define YNN			STEPCONFIG_YNN
+
 #define ADC_CLK			3000000
 #define	MAX_CLK_DIV		7
 #define TOTAL_STEPS		16
-- 
1.7.10.4

