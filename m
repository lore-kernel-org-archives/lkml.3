Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3AaEzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:55:09 -0500
Received: from [65.55.88.13] ([65.55.88.13]:6976 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754414Ab3AaEzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:55:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I103dK1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839h944hd25hd2bhf0ah107ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14afh1504h1537h153bh162dh1631h1758h18e1h1946h1155h)
Date: Thu, 31 Jan 2013 12:53:20 -0500
From: Anson Huang <b20788@freescale.com>
To: Troy Kisky <troy.kisky@boundarydevices.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dong.aisheng@linaro.org>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/2] regulators: anatop: add set_voltage_time_sel
 interface
Message-ID: <20130131175320.GA22977@ubuntu>
References: <1359585461-11377-1-git-send-email-b20788@freescale.com>
 <51099107.3070705@boundarydevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51099107.3070705@boundarydevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 02:30:47PM -0700, Troy Kisky wrote:
> On 1/30/2013 3:37 PM, Anson Huang wrote:
> >some of anatop's regulators(vppcpu, vddpu and vddsoc) have
> >register settings about LDO's step time, which will impact
> >the LDO ramp up speed, need to use set_voltage_time_sel
> >interface to add necessary delay everytime LDOs' voltage
> >is increased.
> >
> >offset 0x170:
> >bit [24-25]: vddcpu
> >bit [26-27]: vddpu
> >bit [28-29]: vddsoc
> >
> >field definition:
> >0'b00: 64 cycles of 24M clock;
> >0'b01: 128 cycles of 24M clock;
> >0'b02: 256 cycles of 24M clock;
> >0'b03: 512 cycles of 24M clock;
> >
> >Signed-off-by: Anson Huang <b20788@freescale.com>
> >---
> >  drivers/regulator/anatop-regulator.c |   42 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> >
> >diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
> >index 8f39cac..a857b9c 100644
> >--- a/drivers/regulator/anatop-regulator.c
> >+++ b/drivers/regulator/anatop-regulator.c
> >@@ -31,12 +31,18 @@
> >  #include <linux/regulator/driver.h>
> >  #include <linux/regulator/of_regulator.h>
> >+#define LDO_RAMP_UP_UNIT_IN_CYCLES      64 /* 64 cycles per step */
> >+#define LDO_RAMP_UP_FREQ_IN_MHZ         24 /* cycle based on 24M OSC */
> >+
> >  struct anatop_regulator {
> >  	const char *name;
> >  	u32 control_reg;
> >  	struct regmap *anatop;
> >  	int vol_bit_shift;
> >  	int vol_bit_width;
> >+	u32 delay_reg;
> >+	int delay_bit_shift;
> >+	int delay_bit_width;
> >  	int min_bit_val;
> >  	int min_voltage;
> >  	int max_voltage;
> >@@ -55,6 +61,33 @@ static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
> >  	return regulator_set_voltage_sel_regmap(reg, selector);
> >  }
> >+static int anatop_regmap_set_voltage_time_sel(struct regulator_dev *reg,
> >+	unsigned int old_sel,
> >+	unsigned int new_sel)
> >+{
> >+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
> >+	u32 val;
> >+	int ret = 0;
> >+
> >+	/* check whether need to care about LDO ramp up speed */
> >+	if (anatop_reg->delay_reg) {
> >+		/*
> >+		 * the delay for LDO ramp up time is
> >+		 * based on the register setting, we need
> >+		 * to calculate how many steps LDO need to
> >+		 * ramp up, and how much delay needed. (us)
> >+		 */
> >+		regmap_read(anatop_reg->anatop, anatop_reg->delay_reg, &val);
> >+		val = (val >> anatop_reg->delay_bit_shift) &
> >+			((1 << anatop_reg->delay_bit_width) - 1);
> >+		ret = new_sel > old_sel ? (new_sel - old_sel) *
> 
> The (new_sel > old_sel) could be part of the above if.
> 
> if (anatop_reg->delay_reg && new_sel > old_sel)
[Anson Huang]Good point, accepted. Please help review my v3 patch,thanks!
> 
> >+			((LDO_RAMP_UP_UNIT_IN_CYCLES << val) /
> >+			LDO_RAMP_UP_FREQ_IN_MHZ + 1) : 0;
> >+	}
> >+
> >+	return ret;
> >+}
> >+
> >  static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
> >  {
> >  	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
> >@@ -67,6 +100,7 @@ static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
> >  static struct regulator_ops anatop_rops = {
> >  	.set_voltage_sel = anatop_regmap_set_voltage_sel,
> >+	.set_voltage_time_sel = anatop_regmap_set_voltage_time_sel,
> >  	.get_voltage_sel = anatop_regmap_get_voltage_sel,
> >  	.list_voltage = regulator_list_voltage_linear,
> >  	.map_voltage = regulator_map_voltage_linear,
> >@@ -143,6 +177,14 @@ static int anatop_regulator_probe(struct platform_device *pdev)
> >  		goto anatop_probe_end;
> >  	}
> >+	/* read LDO ramp up setting, only for core reg */
> >+	of_property_read_u32(np, "anatop-delay-reg-offset",
> >+			     &sreg->delay_reg);
> >+	of_property_read_u32(np, "anatop-delay-bit-width",
> >+			     &sreg->delay_bit_width);
> >+	of_property_read_u32(np, "anatop-delay-bit-shift",
> >+			     &sreg->delay_bit_shift);
> >+
> >  	rdesc->n_voltages = (sreg->max_voltage - sreg->min_voltage) / 25000 + 1
> >  			    + sreg->min_bit_val;
> >  	rdesc->min_uV = sreg->min_voltage;
> 
> 

