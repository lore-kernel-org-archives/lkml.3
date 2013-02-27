Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3B0KBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:01:24 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55801 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3B0KBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:01:22 -0500
MIME-Version: 1.0
In-Reply-To: <5123CF5B.9060804@gmail.com>
References: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<5123CF5B.9060804@gmail.com>
Date: Wed, 27 Feb 2013 11:01:21 +0100
Message-ID: <CABJ1b_TaQ=AXCM9KKW-hJ0Rgdd+759ia+9P=bdnYbA_HcHP1wQ@mail.gmail.com>
Subject: Re: [PATCH] clk: add si5351 i2c common clock driver
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dom Cobley <popcornmix@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rabeeh Khoury <rabeeh@solid-run.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

first of all sorry for the late answer but thanks for testing the driver.

On 2/19/13, Daniel Mack <zonque@gmail.com> wrote:
> Hi Sebastian,
>
> I did some more tests today and it took me a while to dig for the root
> cause why things were not working for me in the first place - see below.
>
>
> On 09.02.2013 13:59, Sebastian Hesselbarth wrote:
>
>> +==Example==
>> +
>> +/* 25MHz reference crystal */
>> +ref25: ref25M {
>> +	compatible = "fixed-clock";
>> +	#clock-cells = <0>;
>> +	clock-frequency = <25000000>;
>> +};
>> +
>> +i2c-master-node {
>> +
>> +	/* Si5351a msop10 i2c clock generator */
>> +	si5351a: clock-generator@60 {
>> +		compatible = "silabs,si5351a-msop";
>> +		reg = <0x60>;
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		#clock-cells = <1>;
>> +
>> +		/* connect xtal input to 25MHz reference */
>> +		clocks = <&ref25>;
>
> As referred to in another thread, registering the ref25M clock that way
> didn't suffice for me on my platform - but that's a different story.

I guess "fixed-clock" isn't registered by OMAP's clock init code? I had
to do this on dove, too. Actually, I will come back to clock initialization for
dove later and was hoping that there will be some global way of registering
core common clock drivers (or at least fixed-clock) until then.

>> +static void si5351_read_parameters(struct si5351_driver_data *drvdata,
>> +	unsigned char reg, struct si5351_parameters *params)
>> +{
>> +	unsigned char buf[SI5351_PARAMETERS_LENGTH];
>
> On a general note, I think you can use u8 instead of unsigned char all
> over the place here, which will save you some indentation trouble.

Ok, I guess I was deriving "unsigned char" usage from other clock drivers
and never went to u8. But I ll reconsider using u8 when all issues are
worked out.

>> +static inline int _si5351_clkout_reparent(struct si5351_driver_data
>> *drvdata,
>> +				  unsigned char num, unsigned char parent)
>> +{
>> +	struct clk *pclk;
>> +
>> +	if (num > 8 ||
>> +	    (drvdata->variant == SI5351_VARIANT_A3 && num > 3))
>> +		return -EINVAL;
>> +
>> +	switch (parent) {
>> +	case 0:
>> +		pclk = drvdata->msynth[num].hw.clk;
>> +		break;
>> +	case 1:
>> +		pclk = drvdata->msynth[0].hw.clk;
>> +		if (num >= 4)
>> +			pclk = drvdata->msynth[4].hw.clk;
>> +		break;
>> +	case 2:
>> +		pclk = drvdata->xtal.clk;
>> +		break;
>> +	case 3:
>> +		if (drvdata->variant != SI5351_VARIANT_C)
>> +			return -EINVAL;
>> +		pclk = drvdata->clkin.clk;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +	return clk_set_parent(drvdata->clkout[num].hw.clk, pclk);
>> +}
>
> [...]
>
>> +static int si5351_clkout_set_parent(struct clk_hw *hw, u8 index)
>> +{
>> +	struct si5351_hw_data *hwdata =
>> +		container_of(hw, struct si5351_hw_data, hw);
>> +	unsigned val;
>> +
>> +	val = 0;
>> +	hw->clk->flags &= ~CLK_SET_RATE_PARENT;
>> +	switch (index) {
>> +	case 0:
>> +		hw->clk->flags |= CLK_SET_RATE_PARENT;
>> +		val = SI5351_CLK_INPUT_MULTISYNTH_N;
>> +		break;
>
> I fugured that _si5351_clkout_reparent() wouldn't actually call
> ->set_parent() on the clock, which leads to the fact that
> CLK_SET_RATE_PARENT is not set in the flags. That way, only the clkout
> end leaf is actually supplied with a new rate, which leads to incorrect
> effective clocks, depending on the current multisynth/pll configuration.

Yeah, true. Unfortunately, _clkout_reparent() is more like a dirty hack to
allow to reparent the clock output. At registration internal configuration of
si5351 is not known and when I parse the DT for clock configuration I might
have been already assigned to the same parent clk that you later explicitly
configure.

What I basically want for si5351 (or any other eeprom based programmable
clock gen) is that stored configuration is not touched. But it can be changed
after eeprom contents have been copied into device's sram - and this _is_
mandatory for the si5351 that I use on CuBox where there is no useful config
stored at all.

Anyway, there still seem to be some more issues with doing it right on current
common clk framwork - thanks for pointing it out.

> The reason for this is in clk_set_parent() itself, which bails if the
> parent is already set to the passed value:
>
> 	if (clk->parent == parent)
> 		goto out;
>
> I fixed that for now by explicitly setting the clock's parent to NULL
> before calling clk_set_parent() in _si5351_clkout_reparent(), so the
> calbacks are triggered. But there might be a nicer way, for example to
> factor out the CLK_SET_RATE_PARENT handling to some function called from
> _si5351_clkout_reparent() or so.
>
> Anyway, with this hack in place along with the other details I mentioned
> in my first mail, the driver seems to work for me now, which is great. I
> will do more extensive tests later that week when I have access to
> better scopes ...

I am happy to hear that you can reproduce different frequencies successfully!

But as you already pointed out before, it would be great to have some long-term
jitter measurements. I hope the heuristic taken from the referenced Silicon Labs
application note will still meet jitter requirements. Still, as stated
on my initial post,
the pll settings obtained for different frequencies differ from that
the provided
windows tool spits out.

Sebastian
