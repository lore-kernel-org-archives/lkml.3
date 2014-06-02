Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaFBCnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:43:16 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.172]:39744 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730AbaFBCnP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:43:15 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-11.tower-38.messagelabs.com!1401676992!6590762!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [James Seong-Won Ban]" <James.Ban.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>,
        "Opensource [James Seong-Won Ban]" <James.Ban.opensource@diasemi.com>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <Support.Opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [PATCH V2] regulator: DA9211 : new regulator driver
Thread-Topic: [PATCH V2] regulator: DA9211 : new regulator driver
Thread-Index: AQHPcy9zfJ1t+oiz80O1iarHEVayYJtcoLWAgACH+sA=
Date: Mon, 2 Jun 2014 02:43:09 +0000
Message-ID: <0ACAE736BB7A70499F1D8D5E6AC1854C0196DD18DE@NB-EX-MBX01.diasemi.com>
References: <201405190656.s4J6uMCD015467@swsrvapps-01.diasemi.com>
 <20140601190141.GM5099@sirena.org.uk>
In-Reply-To: <20140601190141.GM5099@sirena.org.uk>
Accept-Language: ko-KR, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.95.27.226]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Monday, June 02, 2014 4:02 AM
> To: Opensource [James Seong-Won Ban]
> Cc: Liam Girdwood; Support Opensource; LKML; Guennadi Liakhovetski;
> David Dajun Chen
> Subject: Re: [PATCH V2] regulator: DA9211 : new regulator driver
> 
> On Mon, May 19, 2014 at 02:45:51AM +0100, Opensource [James Seong-Won
> Ban] wrote:
> 
> > This is the driver for the Dialog DA9211 Multi-phase 12A DC-DC Buck
> > Converter regulator. It communicates via an I2C bus to the device.
> 
> I'm still really not convinced that the whole handling of the A and B settings is
> doing what it's supposed to be doing.  Like I said before I know another one
> of your drivers is doing something similar (and not sharing the code!) but
> still...
> 
> It looks like the driver is basically written so that register set A must be used
> when Linux is running and set B must be used in suspend mode but not
> everything seems joined up and consistent.
> 
> > Signed-off-by: Opensource [James Seong-Won Ban]
> > <james.ban.opensource@diasemi.com>
> 
> Please just use your name in signoffs, the "Opensource []" garbage that your
> mail system inserts isn't helping.
it will be fixed in next PATCH.
> 
> > +static int da9211_regulator_get_voltage_sel(struct regulator_dev
> > +*rdev) {
> 
> > +	/*
> > +	 * There are two voltage register set A & B for voltage ramping but
> > +	 * either one of then can be active therefore we first determine
> > +	 * the active register set.
> > +	 */
> > +	ret = regmap_read(chip->regmap, info->conf.reg, &data);
> > +	if (ret < 0)
> > +		return ret;
> 
> This appears to be picking the active register set...
> 
> > +	/*
> > +	 * Regulator register set A/B is not selected through GPIO therefore
> > +	 * we use default register set A for voltage ramping.
> > +	 */
> > +	if (regulator->reg_rselect == DA9211_RSEL_NO_GPIO) {
> > +		/* Select register set A */
> > +		ret = regmap_update_bits(chip->regmap, info->conf.reg,
> > +					info->conf.sel_mask,
> > +					DA9211_VBUCKA_SEL_A);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		/* Set the voltage */
> > +		return regmap_update_bits(chip->regmap, info->volt.reg_a,
> > +					 info->volt.v_mask, selector);
> > +	}
> 
> This forces to register set A.
> 
> > +	/*
> > +	 * Here regulator register set A/B is selected through GPIO.
> > +	 * Therefore we first determine the selected register set A/B and
> > +	 * then set the desired voltage for that register set A/B.
> > +	 */
> > +	ret = regmap_read(chip->regmap, info->conf.reg, &data);
> > +	if (ret < 0)
> > +		return ret;
> 
> We don't appear to be controlling this GPIO - this then assumes that the
> GPIO can only be used for selecting suspend mode but doesn't impose any
> restrictions on this.
In this device, the values of selection register for A/B voltage are changed 
automatically  if the status of GPIO is changed.
So it is possible to know the status of GPIO through the value of register.
> 
> > +static int da9211_regulator_set_suspend_voltage(struct regulator_dev
> *rdev,
> > +						int uV)
> > +{
> > +	struct da9211_regulator *regulator = rdev_get_drvdata(rdev);
> > +	struct da9211_regulator_info *info = regulator->info;
> > +	struct da9211 *chip = regulator->da9211;
> > +	int ret;
> > +
> > +	/* Select register set B for suspend voltage ramping. */
> > +	if (regulator->reg_rselect == DA9211_RSEL_NO_GPIO) {
> > +		ret = regmap_update_bits(chip->regmap, info->conf.reg,
> > +					info->conf.sel_mask,
> > +					DA9211_VBUCKA_SEL_B);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> 
> This appears to immediately change the active register set to set B which as I
> said previously is broken; we may not be suspended yet and clearly we
> haven't actually applied the desired setting yet either.
Your suggestion is correct. The code for the change of the active register 
in the function should be removed. I will send PATCH again.
