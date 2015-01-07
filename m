Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbbAGFx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:53:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50393 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbbAGFw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:52:29 -0500
From: Vignesh R <vigneshr@ti.com>
To: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Brad Griffis <bgriffis@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Jan Kardell <jan.kardell@telliq.com>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, Vignesh R <vigneshr@ti.com>
Subject: [PATCH v6 4/6] input: touchscreen: ti_am335x_tsc: Read charge delay from DT
Date: Wed, 7 Jan 2015 11:19:37 +0530
Message-ID: <1420609779-11156-5-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420609779-11156-1-git-send-email-vigneshr@ti.com>
References: <1420609779-11156-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reads charge delay from tsc DT node and writes to
REG_CHARGEDELAY register. If the charge delay is not specified in DT
then default value of 0x400(CHARGEDLY_OPENDLY) is used.

Signed-off-by: Vignesh R <vigneshr@ti.com>
---

v6:
 - Move Documentation from DT patch to 	driver code. 

v5:
 - print out a warning when ti,charge-delay is not specified

v4:
 - Set charge delay to 0x400 as default. Most devices function normally
   at this value

 .../devicetree/bindings/input/touchscreen/ti-tsc-adc.txt  | 15 +++++++++++++++
 drivers/input/touchscreen/ti_am335x_tsc.c                 | 14 +++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
index 878549ba814d..6c4fb34823d3 100644
--- a/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
+++ b/Documentation/devicetree/bindings/input/touchscreen/ti-tsc-adc.txt
@@ -28,6 +28,20 @@ Required properties:
 	ti,adc-channels: List of analog inputs available for ADC.
 			 AIN0 = 0, AIN1 = 1 and so on till AIN7 = 7.
 
+Optional properties:
+- child "tsc"
+	ti,charge-delay: Length of touch screen charge delay step in terms of
+			 ADC clock cycles. Charge delay value should be large
+			 in order to avoid false pen-up events. This value
+			 effects the overall sampling speed, hence need to be
+			 kept as low as possible, while avoiding false pen-up
+			 event. Start from a lower value, say 0x400, and
+			 increase value until false pen-up events are avoided.
+			 The pen-up detection happens immediately after the
+			 charge step, so this does in fact function as a
+			 hardware knob for adjusting the amount of "settling
+			 time".
+
 Example:
 	tscadc: tscadc@44e0d000 {
 		compatible = "ti,am3359-tscadc";
@@ -36,6 +50,7 @@ Example:
 			ti,x-plate-resistance = <200>;
 			ti,coordiante-readouts = <5>;
 			ti,wire-config = <0x00 0x11 0x22 0x33>;
+			ti,charge-delay = <0x400>;
 		};
 
 		adc {
diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 0625c102a1d0..7c0f6b21559d 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -52,6 +52,7 @@ struct titsc {
 	u32			bit_xp, bit_xn, bit_yp, bit_yn;
 	u32			inp_xp, inp_xn, inp_yp, inp_yn;
 	u32			step_mask;
+	u32			charge_delay;
 };
 
 static unsigned int titsc_readl(struct titsc *ts, unsigned int reg)
@@ -177,7 +178,7 @@ static void titsc_step_config(struct titsc *ts_dev)
 
 	config = titsc_readl(ts_dev, REG_IDLECONFIG);
 	titsc_writel(ts_dev, REG_CHARGECONFIG, config);
-	titsc_writel(ts_dev, REG_CHARGEDELAY, CHARGEDLY_OPENDLY);
+	titsc_writel(ts_dev, REG_CHARGEDELAY, ts_dev->charge_delay);
 
 	/* coordinate_readouts + 1 ... coordinate_readouts + 2 is for Z */
 	config = STEPCONFIG_MODE_HWSYNC |
@@ -368,6 +369,17 @@ static int titsc_parse_dt(struct platform_device *pdev,
 	if (err < 0)
 		return err;
 
+	err = of_property_read_u32(node, "ti,charge-delay",
+				   &ts_dev->charge_delay);
+	/*
+	 * If ti,charge-delay value is not specified, then use
+	 * CHARGEDLY_OPENDLY as the default value.
+	 */
+	if (err < 0) {
+		ts_dev->charge_delay = CHARGEDLY_OPENDLY;
+		dev_warn(&pdev->dev, "ti,charge-delay not specified\n");
+	}
+
 	return of_property_read_u32_array(node, "ti,wire-config",
 			ts_dev->config_inp, ARRAY_SIZE(ts_dev->config_inp));
 }
-- 
1.9.1

