Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbaCTPsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:48:36 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35737 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759158AbaCTPse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:48:34 -0400
Date: Thu, 20 Mar 2014 15:48:27 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, broonie@kernel.org, kernel@stlinux.com
Subject: Re: [PATCH 1/1] regulator: Add new driver for ST's PWM controlled
 voltage regulators
Message-ID: <20140320154827.GE8207@lee--X1>
References: <1395324654-8235-1-git-send-email-lee.jones@linaro.org>
 <20140320152837.GW18529@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140320152837.GW18529@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On some STMicroelectronics hardware reside regulators consisting
> > partly of a PWM input connected to the feedback loop. As the PWM
> > duty-cycle is varied the output voltage adapts. This driver
> > allows us to vary the output voltage by adapting the PWM input
> > duty-cycle.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > --- /dev/null
> > +++ b/drivers/regulator/st-pwm.c
> > +static int st_pwm_regulator_set_voltage(struct regulator_dev *dev,
> > +					int min_uV, int max_uV,
> > +					unsigned *selector)
> > +{
> > +	struct st_pwm_regulator_data *drvdata = rdev_get_drvdata(dev);
> > +	int dutycycle, best_val = INT_MAX;
> > +	int sel, ret;
> > +
> > +	for (sel = 0; sel < dev->desc->n_voltages; sel++) {
> > +		if (drvdata->duty_cycle_table[sel].uV < best_val &&
> > +		    drvdata->duty_cycle_table[sel].uV >= min_uV &&
> > +		    drvdata->duty_cycle_table[sel].uV <= max_uV) {
> > +			best_val = drvdata->duty_cycle_table[sel].uV;
> > +			if (selector)
> > +				*selector = sel;
> > +		}
> > +	}
> 
> If you implement .set_voltage_sel() instead and set map_voltage to
> regulator_map_voltage_iterate, the core can take care of this.

I'll do that, thanks.

> > +
> > +	if (best_val == INT_MAX)
> > +		return -EINVAL;
> > +
> > +	dutycycle = (ST_PWM_REG_PERIOD / 100) *
> > +		drvdata->duty_cycle_table[sel].dutycycle;
> 
> Considering (ST_PWM_REG_PERIOD / 100) is constant, could you get away
> with dropping this calculation by just putting the already-adjusted
> values into your duty cycle table?

I thought about this, but I settled on this way for clarity. Also,
this is only a constant if no one decides to change the period, so the
calculation needs to be done somewhere. Did you have something better
in mind?

[...] 

> > +static struct st_pwm_voltages b2105_duty_cycle_table[] = {
> > +	{ .uV = 1114000, .dutycycle = 0,  },
> > +	{ .uV = 1095000, .dutycycle = 10, },
> > +	{ .uV = 1076000, .dutycycle = 20, },
> > +	{ .uV = 1056000, .dutycycle = 30, },
> > +	{ .uV = 1036000, .dutycycle = 40, },
> > +	{ .uV =  996000, .dutycycle = 50, },
> > +	/* WARNING: Values above 50% duty-cycle cause boot failures. */
> > +};
> > +
> > +static struct regulator_desc b2105_desc = {
> > +	.name		= "b2105-pwm-regulator",
> > +	.ops		= &st_pwm_regulator_voltage_ops,
> > +	.type		= REGULATOR_VOLTAGE,
> > +	.owner		= THIS_MODULE,
> > +	.n_voltages	= ARRAY_SIZE(b2105_duty_cycle_table),
> > +	.supply_name    = "pwm",
> > +};
> > +
> > +static struct st_pwm_regulator_data b2105_info = {
> > +	.desc		  = &b2105_desc,
> > +	.duty_cycle_table = b2105_duty_cycle_table,
> > +};
> > +
> > +static struct of_device_id st_pwm_of_match[] = {
> 
> const.  At least the regulator_desc and duty cycle table should be const
> as well. (see my comments below about b2105_info).
> 
> > +	{ .compatible = "st,b2105-pwm-regulator", .data = &b2105_info, },
> > +	{ },
> > +};
> 
> You may want a MODULE_DEVICE_TABLE(of, ...); here if you want to be able
> to be autoloaded.

Right, good catch.

> > +static int st_pwm_regulator_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct st_pwm_regulator_data *drvdata;
> > +	const struct of_device_id *of_match;
> > +	struct regulator_dev *regulator;
> > +	struct regulator_config config = { };
> > +
> > +	if (!np) {
> > +		dev_err(&pdev->dev, "Device Tree node missing\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	of_match = of_match_device(st_pwm_of_match, &pdev->dev);
> > +	if (!of_match) {
> > +		dev_err(&pdev->dev, "failed to match of device\n");
> > +		return -ENODEV;
> > +	}
> > +	drvdata =  (struct st_pwm_regulator_data *) of_match->data;
> 
> Hrm, I typed "cast not necessary here", but then I realized it is
> necessary since you using it to cast away constness.

This is remnant from when I was doing something unessersariy
complcated in a previous (unpublished/personal) revision. I'll take a
look at this too, thanks.

> Are you safe assuming that there will only be one of these devices in a
> system?  It doesn't seem like much a burden to just allocate a new
> object and use it instead of a statically allocated one.

I have written this driver to be expandable. We have new systems
coming out which contain more than one of these regulators. Unless I'm
missing your meaning?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
