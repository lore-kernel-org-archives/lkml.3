Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbaF3HR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:17:59 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.147]:49345 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894AbaF3HR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:17:57 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2014 03:17:57 EDT
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-11.tower-179.messagelabs.com!1404112303!34275464!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Date: Mon, 30 Jun 2014 16:11:36 +0900
From: <james.ban.opensource@diasemi.com>
Message-ID: <201406300711.s5U7BaUl024301@krsrvapps-01.diasemi.com>
Subject: RE: [PATCH V3] regulator: DA9211 : new regulator driver
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Saturday, June 28, 2014 12:01 AM
> To: Opensource [James Seong-Won Ban]
> Cc: Liam Girdwood; Support Opensource; LKML; David Dajun Chen
> Subject: Re: [PATCH V3] regulator: DA9211 : new regulator driver
> 
> On Mon, Jun 02, 2014 at 08:17:03AM +0100, James Ban wrote:
> 
> > This is the driver for the Dialog DA9211 Multi-phase 12A DC-DC Buck
> > Converter regulator. It communicates via an I2C bus to the device.
> 
> This *still* seems to have all the same problems with inconsistent handling of
> the A and B register sets
> 
> > +	/* Make sure to exit from suspend mode on enable */
> > +	if (regulator->reg_rselect == DA9211_RSEL_NO_GPIO) {
> > +		ret = regmap_update_bits(chip->regmap, info->conf.reg,
> > +					info->conf.sel_mask,
> > +					DA9211_VBUCKA_SEL_A);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> 
> Here it forces set A if and only if in no GPIO mode but...
> 
> > +static int da9211_regulator_set_suspend_voltage(struct regulator_dev *rdev,
> > +						int uV)
> > +{
> > +	struct da9211_regulator *regulator = rdev_get_drvdata(rdev);
> > +	struct da9211_regulator_info *info = regulator->info;
> > +	struct da9211 *chip = regulator->da9211;
> > +	int ret;
> > +
> > +	ret = regulator_map_voltage_linear(rdev, uV, uV);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return regmap_update_bits(chip->regmap, info->volt.reg_b,
> > +				 info->volt.v_mask, ret);
> > +}
> 
> ...this unconditionally uses set B and...
> 
> > +static int da9211_suspend_enable(struct regulator_dev *rdev) {
> > +	struct da9211_regulator *regulator = rdev_get_drvdata(rdev);
> > +	struct da9211_regulator_info *info = regulator->info;
> > +	struct da9211 *chip = regulator->da9211;
> > +
> > +	/* Select register set B for voltage ramping. */
> > +	if (regulator->reg_rselect == DA9211_RSEL_NO_GPIO)
> > +		return regmap_update_bits(chip->regmap, info->conf.reg,
> > +					info->conf.sel_mask,
> > +					DA9211_VBUCKA_SEL_B);
> > +	else
> > +		return 0;
> > +}
> 
> ...this uses B if not using a GPIO and otherwise reports success without actually
> doing anything (which seems buggy).  These behaviours aren't compatible with
> each other, set_suspend_voltage() will break if set B is selected by GPIO for
> example.
> 
> Please either go through and try to make these things all consistent or
> (probably better) strip out the suspend and probably GPIO handling for now, get
> the bulk of the driver merged, and then come back and try to deal with those
> tricky bits.
Though the GPIO control and suspend was introduced for more usability of user,
You seems to want more strict compatibility at any case.
As your suggestion, I will strip out the suspend and GPIO handling.
