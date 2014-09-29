Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaI2GjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 02:39:09 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:62952 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI2GjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 02:39:07 -0400
Message-ID: <5428FE7B.8060700@i2se.com>
Date: Mon, 29 Sep 2014 08:38:51 +0200
From: Stefan Wahren <stefan.wahren@i2se.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lgirdwood@gmail.com, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 2/2] regulator: add mxs regulator driver
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com> <1411779588-22031-3-git-send-email-stefan.wahren@i2se.com> <20140928101650.GL27755@sirena.org.uk>
In-Reply-To: <20140928101650.GL27755@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:pm+NgAbyANEHoG8UGzQx/OTl/Oqjong9pSFfBQGBxSL
 9fmoajy8QNVtQYsUjT90wGOsKMYz8n/tRlrH8lzj6nmHhdZIe6
 lkwZBxjUeErReoJRHvbcmdOxL8+3GNH6wEtdFkiz3fDlcLZ/EN
 sqLPCaGyn80YYMArG+CaCf8cgFp0z+eKIZoxXa7EE4kZzM3TJn
 NRCjz80xF5GQ53IR5MKox04E6rC+7kwCKgtkBSL81EYvaV3SIq
 4gepxlRMKyvzWr1pTzczh1fs1LXfUhuIEawtv7n5S9YqRPVK5U
 PSM/geqcCErqN0D8+lcJIaHJo4aKLBRA7FxdVARC72fsVxYvyo
 76m0Q/6gmP3QAbqnsGNA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

thanks for your comments. Now it looks to me, that i try to reinvent the
wheel.

I'm searching for a good regulator implementation example.

Does it apply to ti-abb-regulator.c and twl-regulator.c?

Am 28.09.2014 um 12:16 schrieb Mark Brown:
> On Sat, Sep 27, 2014 at 12:59:48AM +0000, Stefan Wahren wrote:
>
>> +	pr_debug("%s: min_uV %d, max_uV %d, min %d, max %d\n", __func__,
>> +		 min_uV, max_uV, con->min_uV, con->max_uV);
>> +
>> +	if (max_uV < con->min_uV || max_uV > con->max_uV)
>> +		return -EINVAL;
> This is replicating checks done by the core.
>
>> +	val = (max_uV - con->min_uV) * sreg->rdesc.n_voltages /
>> +			(con->max_uV - con->min_uV);
> Drivers should never look at their constraints, they should let the core
> do that and just do what they're asked.  In this case it is probably
> best to implement a get_voltage_sel() operation and have the conversion
> to voltage done by regulator_map_voltage_linear(), this will both make
> the code look better and mean the driver gets the benefit of all the
> error checking done by the core.

Okay, i will do that. For the list_voltage operation
regulator_list_voltage_linear()
should be the perfect candidate.

>> +	writel(val | regs, sreg->base_addr);
>> +	for (i = 20; i; i--) {
>> +		/* delay for fast mode */
>> +		if (readl(power_sts) & BM_POWER_STS_DC_OK)
>> +			return 0;
>> +
>> +		udelay(1);
>> +	}
>> +
>> +	writel(val | regs, sreg->base_addr);
>> +	start = jiffies;
>> +	while (1) {
>> +		/* delay for normal mode */
>> +		if (readl(power_sts) & BM_POWER_STS_DC_OK)
>> +			return 0;
> This really needs a comment to explain what on earth is going on here -
> the whole thing with writing the same thing twice with two delays is
> more than a little odd.  It looks like the driver is trying to busy wait
> in cases where the change happens quickly but the comments about "fast"
> and "normal" mode make this unclear.

The regulator driver polls for the DC_OK bit in the power status register.

Quote for reference manual (p. 935): "High when switching DC-DC
converter control loop has stabilized after a voltage target change."

The two loops comes from the different regulator modes
(REGULATOR_MODE_FAST, REGULATOR_MODE_NORMAL).

In REGULATOR_MODE_FAST the voltage steping is disabled and changing
voltage should be fast. In REGULATOR_MODE_NORMAL voltage steping is
enabled and it's take a while for reaching the target voltage.

Do you see more a problem with the two different loops or the redundant
register write?

Is it acceptable that the function blocks here?

>> +	pr_debug("%s: %s register val %d\n", __func__, sreg->name, val);
>> +
>> +	switch (sreg->rdesc.id) {
>> +	case MXS_VDDA:
>> +		val >>= 16;
>> +		break;
>> +	case MXS_VDDD:
>> +		val >>= 20;
>> +		break;
>> +	}
>> +
>> +	return val ? 1 : 0;
>> +}
> This seems buggy - it'll always return true for MXS_VDDD if MXS_VDDA
> enabled won't it?

Shame on me, i forgot to remove this function. mxs_is_enabled is never used.

>> +static unsigned int mxs_get_mode(struct regulator_dev *reg)
>> +{
>> +	struct mxs_regulator *sreg = rdev_get_drvdata(reg);
>> +	u32 val = readl(sreg->base_addr) & sreg->mode_mask;
>> +
>> +	return val ? REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
>> +}
> Please try to avoid the ternery operator, it does nothing for
> legibility.

if (readl(sreg->base_addr) & sreg->mode_mask)
    return REGULATOR_MODE_FAST;

return REGULATOR_MODE_NORMAL;

Better?

>> +	if (of_property_read_string(np, "regulator-name", &name)) {
>> +		dev_err(dev, "missing property regulator-name\n");
>> +		return -EINVAL;
>> +	}
> Use different compatibles to identify the regulators, regulator-name
> should never be mandatory.

I will remove this and use the compatibles.

>> +	switch (sreg->rdesc.id) {
>> +	case MXS_VDDIO:
>> +		sreg->mode_mask = BIT(17);
>> +		break;
>> +	case MXS_VDDA:
>> +		sreg->mode_mask = BIT(18);
>> +		break;
>> +	case MXS_VDDD:
>> +		sreg->mode_mask = BIT(22);
>> +		break;
>> +	}
> Why is this not looked up from the data structure like the rest of the
> data?

I was a little bit confused why there wasn't a mode_mask in the struct
regulator_desc. I will do it like the ti-abb-regulator in the matching
table.

>
>> +	dev_info(dev, "%s found\n", name);
> Don't add noise like this to the boot log, it provides no useful
> information.

Okay, i will remove this.

>> +	regulator_unregister(rdev);
>> +	iounmap(power_addr);
>> +	iounmap(base_addr);
> Use devm_ versions of functions.

As a result the remove function for the drivers becomes unnecessary. Am
i right?

>
>> +static int __init mxs_regulator_init(void)
>> +{
>> +	return platform_driver_register(&mxs_regulator_driver);
>> +}
>> +postcore_initcall(mxs_regulator_init);
> module_platform_driver().

I wasn't sure because of the postcore stuff. I will fix it.

Best regards

Stefan
