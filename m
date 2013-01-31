Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab3AaC5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 21:57:40 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:37973
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300Ab3AaC5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 21:57:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
From: Anson Huang <b20788@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <broonie@opensource.wolfsonmicro.com>, <shawn.guo@linaro.org>,
        Anson Huang <b20788@freescale.com>
Subject: [PATCH V2] regulators: anatop: add set_voltage_time_sel interface
Date: Thu, 31 Jan 2013 10:57:06 -0500
Message-ID: <1359647826-26239-1-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some of anatop's regulators(cpu, vddpu and vddsoc) have
register settings about LDO's step time, which will impact
the LDO ramp up speed, need to use set_voltage_time_sel
interface to add necessary delay everytime LDOs' voltage
is increased.

offset 0x170:
bit [24-25]: cpu
bit [26-27]: vddpu
bit [28-29]: vddsoc

field definition:
0'b00: 64 cycles of 24M clock;
0'b01: 128 cycles of 24M clock;
0'b02: 256 cycles of 24M clock;
0'b03: 512 cycles of 24M clock;

Signed-off-by: Anson Huang <b20788@freescale.com>
---
 .../bindings/regulator/anatop-regulator.txt        |    8 ++++
 drivers/regulator/anatop-regulator.c               |   42 ++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/anatop-regulator.txt b/Documentation/devicetree/bindings/regulator/anatop-regulator.txt
index 357758c..758eae2 100644
--- a/Documentation/devicetree/bindings/regulator/anatop-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/anatop-regulator.txt
@@ -9,6 +9,11 @@ Required properties:
 - anatop-min-voltage: Minimum voltage of this regulator
 - anatop-max-voltage: Maximum voltage of this regulator
 
+Optional properties:
+- anatop-delay-reg-offset: Anatop MFD step time register offset
+- anatop-delay-bit-shift: Bit shift for the step time register
+- anatop-delay-bit-width: Number of bits used in the step time register
+
 Any property defined as part of the core regulator
 binding, defined in regulator.txt, can also be used.
 
@@ -23,6 +28,9 @@ Example:
 		anatop-reg-offset = <0x140>;
 		anatop-vol-bit-shift = <9>;
 		anatop-vol-bit-width = <5>;
+		anatop-delay-reg-offset = <0x170>;
+		anatop-delay-bit-shift = <24>;
+		anatop-delay-bit-width = <2>;
 		anatop-min-bit-val = <1>;
 		anatop-min-voltage = <725000>;
 		anatop-max-voltage = <1300000>;
diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 8f39cac..fe79d24 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -31,12 +31,18 @@
 #include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
 
+#define LDO_RAMP_UP_UNIT_IN_CYCLES      64 /* 64 cycles per step */
+#define LDO_RAMP_UP_FREQ_IN_MHZ         24 /* cycle based on 24M OSC */
+
 struct anatop_regulator {
 	const char *name;
 	u32 control_reg;
 	struct regmap *anatop;
 	int vol_bit_shift;
 	int vol_bit_width;
+	u32 delay_reg;
+	int delay_bit_shift;
+	int delay_bit_width;
 	int min_bit_val;
 	int min_voltage;
 	int max_voltage;
@@ -55,6 +61,33 @@ static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
 	return regulator_set_voltage_sel_regmap(reg, selector);
 }
 
+static int anatop_regmap_set_voltage_time_sel(struct regulator_dev *reg,
+	unsigned int old_sel,
+	unsigned int new_sel)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	u32 val;
+	int ret = 0;
+
+	/* check whether need to care about LDO ramp up speed */
+	if (anatop_reg->delay_bit_width) {
+		/*
+		 * the delay for LDO ramp up time is
+		 * based on the register setting, we need
+		 * to calculate how many steps LDO need to
+		 * ramp up, and how much delay needed. (us)
+		 */
+		regmap_read(anatop_reg->anatop, anatop_reg->delay_reg, &val);
+		val = (val >> anatop_reg->delay_bit_shift) &
+			((1 << anatop_reg->delay_bit_width) - 1);
+		ret = new_sel > old_sel ? (new_sel - old_sel) *
+			((LDO_RAMP_UP_UNIT_IN_CYCLES << val) /
+			LDO_RAMP_UP_FREQ_IN_MHZ + 1) : 0;
+	}
+
+	return ret;
+}
+
 static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
@@ -67,6 +100,7 @@ static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 
 static struct regulator_ops anatop_rops = {
 	.set_voltage_sel = anatop_regmap_set_voltage_sel,
+	.set_voltage_time_sel = anatop_regmap_set_voltage_time_sel,
 	.get_voltage_sel = anatop_regmap_get_voltage_sel,
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
@@ -143,6 +177,14 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 		goto anatop_probe_end;
 	}
 
+	/* read LDO ramp up setting, only for core reg */
+	of_property_read_u32(np, "anatop-delay-reg-offset",
+			     &sreg->delay_reg);
+	of_property_read_u32(np, "anatop-delay-bit-width",
+			     &sreg->delay_bit_width);
+	of_property_read_u32(np, "anatop-delay-bit-shift",
+			     &sreg->delay_bit_shift);
+
 	rdesc->n_voltages = (sreg->max_voltage - sreg->min_voltage) / 25000 + 1
 			    + sreg->min_bit_val;
 	rdesc->min_uV = sreg->min_voltage;
-- 
1.7.9.5


