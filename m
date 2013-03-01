Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab3CAPBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:01:32 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:37021 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAPBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:01:30 -0500
Message-ID: <5130C2C7.30400@gmail.com>
Date: Fri, 01 Mar 2013 16:01:27 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Stephen Warren <swarren@nvidia.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dom Cobley <popcornmix@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rabeeh Khoury <rabeeh@solid-run.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: add si5351 i2c common clock driver
References: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com> <5123CF5B.9060804@gmail.com> <CABJ1b_TaQ=AXCM9KKW-hJ0Rgdd+759ia+9P=bdnYbA_HcHP1wQ@mail.gmail.com>
In-Reply-To: <CABJ1b_TaQ=AXCM9KKW-hJ0Rgdd+759ia+9P=bdnYbA_HcHP1wQ@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/mixed;
 boundary="------------000707060609010105040207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000707060609010105040207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 27.02.2013 11:01, Sebastian Hesselbarth wrote:
> first of all sorry for the late answer but thanks for testing the driver.
> 
> On 2/19/13, Daniel Mack <zonque@gmail.com> wrote:
>> Hi Sebastian,
>>
>> I did some more tests today and it took me a while to dig for the root
>> cause why things were not working for me in the first place - see below.
>>
>>
>> On 09.02.2013 13:59, Sebastian Hesselbarth wrote:
>>
>>> +==Example==
>>> +
>>> +/* 25MHz reference crystal */
>>> +ref25: ref25M {
>>> +	compatible = "fixed-clock";
>>> +	#clock-cells = <0>;
>>> +	clock-frequency = <25000000>;
>>> +};
>>> +
>>> +i2c-master-node {
>>> +
>>> +	/* Si5351a msop10 i2c clock generator */
>>> +	si5351a: clock-generator@60 {
>>> +		compatible = "silabs,si5351a-msop";
>>> +		reg = <0x60>;
>>> +		#address-cells = <1>;
>>> +		#size-cells = <0>;
>>> +		#clock-cells = <1>;
>>> +
>>> +		/* connect xtal input to 25MHz reference */
>>> +		clocks = <&ref25>;
>>
>> As referred to in another thread, registering the ref25M clock that way
>> didn't suffice for me on my platform - but that's a different story.
> 
> I guess "fixed-clock" isn't registered by OMAP's clock init code? I had
> to do this on dove, too. Actually, I will come back to clock initialization for
> dove later and was hoping that there will be some global way of registering
> core common clock drivers (or at least fixed-clock) until then.
> 
>>> +static void si5351_read_parameters(struct si5351_driver_data *drvdata,
>>> +	unsigned char reg, struct si5351_parameters *params)
>>> +{
>>> +	unsigned char buf[SI5351_PARAMETERS_LENGTH];
>>
>> On a general note, I think you can use u8 instead of unsigned char all
>> over the place here, which will save you some indentation trouble.
> 
> Ok, I guess I was deriving "unsigned char" usage from other clock drivers
> and never went to u8. But I ll reconsider using u8 when all issues are
> worked out.
> 
>>> +static inline int _si5351_clkout_reparent(struct si5351_driver_data
>>> *drvdata,
>>> +				  unsigned char num, unsigned char parent)
>>> +{
>>> +	struct clk *pclk;
>>> +
>>> +	if (num > 8 ||
>>> +	    (drvdata->variant == SI5351_VARIANT_A3 && num > 3))
>>> +		return -EINVAL;
>>> +
>>> +	switch (parent) {
>>> +	case 0:
>>> +		pclk = drvdata->msynth[num].hw.clk;
>>> +		break;
>>> +	case 1:
>>> +		pclk = drvdata->msynth[0].hw.clk;
>>> +		if (num >= 4)
>>> +			pclk = drvdata->msynth[4].hw.clk;
>>> +		break;
>>> +	case 2:
>>> +		pclk = drvdata->xtal.clk;
>>> +		break;
>>> +	case 3:
>>> +		if (drvdata->variant != SI5351_VARIANT_C)
>>> +			return -EINVAL;
>>> +		pclk = drvdata->clkin.clk;
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +	return clk_set_parent(drvdata->clkout[num].hw.clk, pclk);
>>> +}
>>
>> [...]
>>
>>> +static int si5351_clkout_set_parent(struct clk_hw *hw, u8 index)
>>> +{
>>> +	struct si5351_hw_data *hwdata =
>>> +		container_of(hw, struct si5351_hw_data, hw);
>>> +	unsigned val;
>>> +
>>> +	val = 0;
>>> +	hw->clk->flags &= ~CLK_SET_RATE_PARENT;
>>> +	switch (index) {
>>> +	case 0:
>>> +		hw->clk->flags |= CLK_SET_RATE_PARENT;
>>> +		val = SI5351_CLK_INPUT_MULTISYNTH_N;
>>> +		break;
>>
>> I fugured that _si5351_clkout_reparent() wouldn't actually call
>> ->set_parent() on the clock, which leads to the fact that
>> CLK_SET_RATE_PARENT is not set in the flags. That way, only the clkout
>> end leaf is actually supplied with a new rate, which leads to incorrect
>> effective clocks, depending on the current multisynth/pll configuration.
> 
> Yeah, true. Unfortunately, _clkout_reparent() is more like a dirty hack to
> allow to reparent the clock output. At registration internal configuration of
> si5351 is not known and when I parse the DT for clock configuration I might
> have been already assigned to the same parent clk that you later explicitly
> configure.

Hmm, but then we need to either set the configuration on the chip to
match the internal state of the driver, or tell the clock framework that
the current state is not currently known (don't know if that's possible).

> What I basically want for si5351 (or any other eeprom based programmable
> clock gen) is that stored configuration is not touched. But it can be changed
> after eeprom contents have been copied into device's sram - and this _is_
> mandatory for the si5351 that I use on CuBox where there is no useful config
> stored at all.

Yes, same here. We set up the si5351 from the bootloader with some
binary blob via i2c to bring some components to live before the kernel
boots.

> Anyway, there still seem to be some more issues with doing it right on current
> common clk framwork - thanks for pointing it out.

I'd be happy to test more versions if you have any.

FWIW, attached is a patch for caching the 'prepared' states of the
clocks. This fixes the 'scheduling while atomic' bug I described earlier
in this thread. You can squash it into your patch if you want.



Thanks,
Daniel

--------------000707060609010105040207
Content-Type: text/x-patch;
 name="0001-si5351-cache-prepared-bits-of-clocks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-si5351-cache-prepared-bits-of-clocks.patch"

>From 3e7a1a8e1f3e472e473e5ab47329bb44a9ec24ba Mon Sep 17 00:00:00 2001
From: Daniel Mack <zonque@gmail.com>
Date: Sun, 17 Feb 2013 18:01:08 +0100
Subject: [PATCH] si5351: cache 'prepared' bits of clocks

---
 drivers/clk/clk-si5351.c | 47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index b526742..528f88a 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -54,6 +54,7 @@ struct si5351_hw_data {
 	struct si5351_driver_data	*drvdata;
 	struct si5351_parameters	params;
 	unsigned char			num;
+	bool				prepared;
 };
 
 struct si5351_driver_data {
@@ -70,6 +71,9 @@ struct si5351_driver_data {
 	struct si5351_hw_data	pll[2];
 	struct si5351_hw_data	*msynth;
 	struct si5351_hw_data	*clkout;
+
+	bool			xtal_prepared;
+	bool			clkin_prepared;
 };
 
 static const char const *si5351_input_names[] = {
@@ -223,6 +227,8 @@ static int si5351_xtal_prepare(struct clk_hw *hw)
 		container_of(hw, struct si5351_driver_data, xtal);
 	si5351_set_bits(drvdata, SI5351_FANOUT_ENABLE,
 			SI5351_XTAL_ENABLE, SI5351_XTAL_ENABLE);
+	drvdata->xtal_prepared  = true;
+
 	return 0;
 }
 
@@ -232,15 +238,14 @@ static void si5351_xtal_unprepare(struct clk_hw *hw)
 		container_of(hw, struct si5351_driver_data, xtal);
 	si5351_set_bits(drvdata, SI5351_FANOUT_ENABLE,
 			SI5351_XTAL_ENABLE, 0);
+	drvdata->xtal_prepared  = false;
 }
 
 static int si5351_xtal_is_enabled(struct clk_hw *hw)
 {
 	struct si5351_driver_data *drvdata =
 		container_of(hw, struct si5351_driver_data, xtal);
-	unsigned char reg;
-	reg = si5351_reg_read(drvdata, SI5351_FANOUT_ENABLE);
-	return (reg & SI5351_XTAL_ENABLE) ? 1 : 0;
+	return drvdata->xtal_prepared;
 }
 
 static const struct clk_ops si5351_xtal_ops = {
@@ -258,7 +263,8 @@ static int si5351_clkin_prepare(struct clk_hw *hw)
 		container_of(hw, struct si5351_driver_data, clkin);
 	si5351_set_bits(drvdata, SI5351_FANOUT_ENABLE,
 			SI5351_CLKIN_ENABLE, SI5351_CLKIN_ENABLE);
-	return 0;
+	drvdata->clkin_prepared  = true;
+	return 1;
 }
 
 static void si5351_clkin_unprepare(struct clk_hw *hw)
@@ -267,15 +273,14 @@ static void si5351_clkin_unprepare(struct clk_hw *hw)
 		container_of(hw, struct si5351_driver_data, clkin);
 	si5351_set_bits(drvdata, SI5351_FANOUT_ENABLE,
 			SI5351_CLKIN_ENABLE, 0);
+	drvdata->clkin_prepared  = false;
 }
 
 static int si5351_clkin_is_enabled(struct clk_hw *hw)
 {
 	struct si5351_driver_data *drvdata =
 		container_of(hw, struct si5351_driver_data, clkin);
-	unsigned char reg;
-	reg = si5351_reg_read(drvdata, SI5351_FANOUT_ENABLE);
-	return (reg & SI5351_CLKIN_ENABLE) ? 1 : 0;
+	return drvdata->clkin_prepared;
 }
 
 /*
@@ -660,6 +665,7 @@ static unsigned long si5351_msynth_recalc_rate(struct clk_hw *hw,
 		m += hwdata->params.p2;
 		m += 512 * hwdata->params.p3;
 	}
+printk(" XXXX m %d (%d)\n", m, hwdata->num);
 	do_div(rate, m);
 
 	dev_dbg(&hwdata->drvdata->client->dev,
@@ -887,6 +893,8 @@ static int si5351_clkout_prepare(struct clk_hw *hw)
 			SI5351_CLK_POWERDOWN, 0);
 	si5351_set_bits(hwdata->drvdata, SI5351_OUTPUT_ENABLE_CTRL,
 			(1 << hwdata->num), 0);
+	hwdata->prepared = true;
+
 	return 0;
 }
 
@@ -899,21 +907,28 @@ static void si5351_clkout_unprepare(struct clk_hw *hw)
 			SI5351_CLK_POWERDOWN, SI5351_CLK_POWERDOWN);
 	si5351_set_bits(hwdata->drvdata, SI5351_OUTPUT_ENABLE_CTRL,
 			(1 << hwdata->num), (1 << hwdata->num));
+	hwdata->prepared = false;
 }
 
-static int si5351_clkout_is_enabled(struct clk_hw *hw)
+static void __si5351_read_clkout_prepared(struct si5351_hw_data *hwdata)
 {
-	struct si5351_hw_data *hwdata =
-		container_of(hw, struct si5351_hw_data, hw);
 	unsigned char val;
 
 	val = si5351_reg_read(hwdata->drvdata, SI5351_CLK0_CTRL + hwdata->num);
 	if (val & SI5351_CLK_POWERDOWN)
-		return 0;
+		hwdata->prepared = false;
 	val = si5351_reg_read(hwdata->drvdata, SI5351_OUTPUT_ENABLE_CTRL);
 	if (val & (1 << hwdata->num))
-		return 0;
-	return 1;
+		hwdata->prepared = false;
+	hwdata->prepared = true;
+}
+
+static int si5351_clkout_is_enabled(struct clk_hw *hw)
+{
+	struct si5351_hw_data *hwdata =
+		container_of(hw, struct si5351_hw_data, hw);
+
+	return hwdata->prepared;
 }
 
 static u8 si5351_clkout_get_parent(struct clk_hw *hw)
@@ -1306,6 +1321,11 @@ static int si5351_i2c_probe(
 		return -EINVAL;
 	}
 
+	/* read current clock enable bits */
+	ret = si5351_reg_read(drvdata, SI5351_FANOUT_ENABLE);
+	drvdata->xtal_prepared = !!(ret & SI5351_XTAL_ENABLE);
+	drvdata->clkin_prepared  = !!(ret & SI5351_CLKIN_ENABLE);
+
 	/* register PLLB or VXCO (Si5351B) */
 	drvdata->pll[1].num = 1;
 	drvdata->pll[1].drvdata = drvdata;
@@ -1394,6 +1414,7 @@ static int si5351_i2c_probe(
 			return -EINVAL;
 		}
 		drvdata->onecell.clks[n] = clk;
+		__si5351_read_clkout_prepared(&drvdata->clkout[n]);
 	}
 
 	/* setup clock setup from DT */
-- 
1.8.1.2


--------------000707060609010105040207--
