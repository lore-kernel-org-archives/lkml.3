Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3BRKTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 05:19:16 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50784 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab3BRKTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 05:19:13 -0500
Message-ID: <5122001C.4010008@gmail.com>
Date: Mon, 18 Feb 2013 11:19:08 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
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
References: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 09.02.2013 13:59, Sebastian Hesselbarth wrote:
> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
> i2c programmable clock generators. Currently, the driver supports
> DT kernels only and VXCO feature of si5351b is not implemented. DT
> bindings selectively allow to overwrite stored Si5351 configuration
> which is very helpful for clock generators with empty eeprom
> configuration. Corresponding device tree binding documentation is
> also added.

Thank you very much for your work! I had to wait for OMAP platforms to
move over to the common clock framework, but with that in place now, I
could finally give it a test.

Some comments below.

> - The driver has been frequency tested for some common video/audio
>   clocks and manages it to tune in every frequency successfully. A
>   comparison with silabs windows tool shows a different heuristic
>   for vco frequencies. The tests have been comfirmed by visual
>   check on an 500MHz oscilloscope but no jitter measurements have
>   been carried out. I will provide comparison by email on request.

I would be interested in more tests, yes. My first checks set up clkout1
to 32.768 KHz, and on my oscilloscope,  I measured some 1.04 KHz only.
Will do some debugging later.

> +/*
> + * Si5351 xtal clock input
> + */
> +static int si5351_xtal_prepare(struct clk_hw *hw)
> +{
> +	struct si5351_driver_data *drvdata =
> +		container_of(hw, struct si5351_driver_data, xtal);
> +	si5351_set_bits(drvdata, SI5351_FANOUT_ENABLE,
> +			SI5351_XTAL_ENABLE, SI5351_XTAL_ENABLE);
> +	return 0;
> +}
> +
> +static void si5351_xtal_unprepare(struct clk_hw *hw)
> +{
> +	struct si5351_driver_data *drvdata =
> +		container_of(hw, struct si5351_driver_data, xtal);
> +	si5351_set_bits(drvdata, SI5351_FANOUT_ENABLE,
> +			SI5351_XTAL_ENABLE, 0);
> +}
> +
> +static int si5351_xtal_is_enabled(struct clk_hw *hw)
> +{
> +	struct si5351_driver_data *drvdata =
> +		container_of(hw, struct si5351_driver_data, xtal);
> +	unsigned char reg;
> +	reg = si5351_reg_read(drvdata, SI5351_FANOUT_ENABLE);
> +	return (reg & SI5351_XTAL_ENABLE) ? 1 : 0;
> +}

On an AM33xx platform, I got tons of BUGs like this one:


[    5.028525] BUG: scheduling while atomic: swapper/1/0x00000002
[    5.034600] INFO: lockdep is turned off.
[    5.038682] Modules linked in:
[    5.041866] irq event stamp: 136090
[    5.045496] hardirqs last  enabled at (136089): [<c04ae9bc>]
_raw_spin_unlock_irqrestore+0x60/0x68
[    5.054843] hardirqs last disabled at (136090): [<c04ae1f4>]
_raw_spin_lock_irqsave+0x1c/0x60
[    5.063733] softirqs last  enabled at (135026): [<c0039d84>]
__do_softirq+0x150/0x1b4
[    5.071907] softirqs last disabled at (135019): [<c003a18c>]
irq_exit+0x98/0xa0
[    5.079541] [<c0013610>] (unwind_backtrace+0x0/0xf8) from
[<c0058ec8>] (__schedule_bug+0x58/0x78)
[    5.088793] [<c0058ec8>] (__schedule_bug+0x58/0x78) from [<c04ad50c>]
(__schedule+0x3c8/0x45c)
[    5.097773] [<c04ad50c>] (__schedule+0x3c8/0x45c) from [<c04ab3f0>]
(schedule_timeout+0x120/0x1d4)
[    5.107114] [<c04ab3f0>] (schedule_timeout+0x120/0x1d4) from
[<c003f780>] (msleep+0x14/0x20)
[    5.115912] [<c003f780>] (msleep+0x14/0x20) from [<c033dd08>]
(omap_i2c_wait_for_bb+0x68/0xb0)
[    5.124890] [<c033dd08>] (omap_i2c_wait_for_bb+0x68/0xb0) from
[<c033e528>] (omap_i2c_xfer+0x3c/0xfc)
[    5.134503] [<c033e528>] (omap_i2c_xfer+0x3c/0xfc) from [<c033a550>]
(__i2c_transfer+0x44/0x80)
[    5.143575] [<c033a550>] (__i2c_transfer+0x44/0x80) from [<c033bab8>]
(i2c_transfer+0x5c/0xbc)
[    5.152555] [<c033bab8>] (i2c_transfer+0x5c/0xbc) from [<c02b4458>]
(regmap_i2c_read+0x4c/0x6c)
[    5.161625] [<c02b4458>] (regmap_i2c_read+0x4c/0x6c) from
[<c02b1840>] (_regmap_raw_read+0x98/0xdc)
[    5.171056] [<c02b1840>] (_regmap_raw_read+0x98/0xdc) from
[<c02b18e8>] (_regmap_read+0x64/0x9c)
[    5.180215] [<c02b18e8>] (_regmap_read+0x64/0x9c) from [<c02b1964>]
(regmap_read+0x44/0x5c)
[    5.188923] [<c02b1964>] (regmap_read+0x44/0x5c) from [<c036d45c>]
(si5351_clkout_is_enabled+0x74/0xb8)
[    5.198720] [<c036d45c>] (si5351_clkout_is_enabled+0x74/0xb8) from
[<c036a9f4>] (clk_disable_unused_subtree+0x68/0xac)
[    5.209873] [<c036a9f4>] (clk_disable_unused_subtree+0x68/0xac) from
[<c036a9ac>] (clk_disable_unused_subtree+0x20/0xac)

This is because clk_disable_unused_subtree() calls ->is_enabled() with a
spinlock held, but si5351_xtal_is_enabled() will be sleeping, either by
acquiring a mutex in the regmap core, or in the OMAP's i2c transfer
routine. So bottom line is to make this callback atomic, and I did that
locally for now by caching the 'prepare' state of xtal, clkin and the
individual clocks. I can share a patch if you like.

> +static unsigned long si5351_msynth_recalc_rate(struct clk_hw *hw,
> +					       unsigned long parent_rate)
> +{
> +	struct si5351_hw_data *hwdata =
> +		container_of(hw, struct si5351_hw_data, hw);
> +	unsigned char reg = SI5351_CLK0_PARAMETERS +
> +		(SI5351_PARAMETERS_LENGTH * hwdata->num);
> +	unsigned long long rate;
> +	unsigned long m;
> +
> +	if (!hwdata->params.valid)
> +		si5351_read_parameters(hwdata->drvdata, reg, &hwdata->params);
> +
> +	if (hwdata->params.p3 == 0)
> +		return parent_rate;
> +
> +	/*
> +	 * multisync0-5: fOUT = (128 * P3 * fIN) / (P1*P3 + P2 + 512*P3)
> +	 * multisync6-7: fOUT = fIN / P1
> +	 */
> +	rate = parent_rate;
> +	if (hwdata->num > 5)
> +		m = hwdata->params.p1;
> +	else if ((si5351_reg_read(hwdata->drvdata, reg + 2) &
> +		  SI5351_OUTPUT_CLK_DIVBY4) == SI5351_OUTPUT_CLK_DIVBY4)
> +		m = 4;
> +	else {
> +		rate *= 128 * hwdata->params.p3;
> +		m = hwdata->params.p1 * hwdata->params.p3;
> +		m += hwdata->params.p2;
> +		m += 512 * hwdata->params.p3;
> +	}
> +	do_div(rate, m);

For p1 == p2 == p3, this will be a DIV0. I encountered this here by not
specifying the clkout2 node. I think it's safe to just bail if m == 0?


Again, thanks a lot for working on this!


Daniel

