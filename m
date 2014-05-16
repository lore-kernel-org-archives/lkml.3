Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaEPBwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 21:52:35 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.161]:18630 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbaEPBwe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 21:52:34 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-7.tower-39.messagelabs.com!1400205150!14624440!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [James Seong-Won Ban]" <James.Ban.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <Support.Opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [RESEND PATCH V1] regulator: DA9211 : new regulator driver
Thread-Topic: [RESEND PATCH V1] regulator: DA9211 : new regulator driver
Thread-Index: AQHPbyF453pPrZ4M6Ua5jim9lNYYRZtAdN+AgAH0gZA=
Date: Fri, 16 May 2014 01:52:27 +0000
Message-ID: <8494A6313F8C244E9D54EBA065DD5ACF5ACD3E6C@SW-EX-MBX02.diasemi.com>
References: <201405140306.s4E36COM023118@swsrvapps-01.diasemi.com>
 <20140514202029.GL12304@sirena.org.uk>
In-Reply-To: <20140514202029.GL12304@sirena.org.uk>
Accept-Language: en-GB, en-US
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
> Sent: Thursday, May 15, 2014 5:20 AM
> To: Opensource [James Seong-Won Ban]
> Cc: Liam Girdwood; Support Opensource; LKML; Guennadi Liakhovetski;
> David Dajun Chen
> Subject: Re: [RESEND PATCH V1] regulator: DA9211 : new regulator driver
> 
> On Wed, May 14, 2014 at 04:02:34AM +0100, James Ban wrote:
> > This is the driver for the Dialog DA9211 Multi-phase 12A DC-DC Buck
> > Converter regulator. It communicates via an I2C bus to the device.
> 
> This looks a lot like the DA9210 driver, is there really no opportunity for code
> sharing here?
> 
DA9210 has only one buck. But DA9211 has two buck configuration.
And the register map is different between two driver.
So it is not possible to share the code. 

> > +	/*
> > +	 * There are two voltage register set A & B for voltage ramping but
> > +	 * either one of then can be active therefore we first determine
> > +	 * the active register set.
> > +	 */
> 
> I see this but...
> 
> > +	/* Select register set B for suspend voltage ramping. */
> > +	if (regulator->reg_rselect == DA9211_RSEL_NO_GPIO) {
> > +		ret = regmap_update_bits(chip->regmap, info->conf.reg,
> > +					info->conf.sel_mask,
> > +					DA9211_VBUCKA_SEL_B);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> 
> ..this fairly clearly says that suspend mode is set B and normal mode is set A.
> 
This is a case with no gpio configuration.
If gpio is configured, the active voltage A/B will be controlled by gpio.
Function da9211_regulator_get/set_voltage_sel  is designed for covering both cases.

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
> This looks like it will immediately shift to the suspend voltage but what this
> should do is set the voltage which will be set in suspend mode - something
> else (usually a hardware signal during suspend) should actually enter it.
> 
The output voltage A/B of DA9211 could be selected by a hardware signal or register.
So if there is no gpio configuration, B voltage channel should be selected during suspend mode.
If user wants to stay same voltage level at suspend mode in case of no gpio configuration,
user must set same voltage level at A/B register.

> > +int da9211_enable_irq(struct da9211 *chip, int irq) {
> > +	enable_irq(irq);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(da9211_enable_irq);
> 
> > +int da9211_disable_irq(struct da9211 *chip, int irq) int
> > +da9211_mask_irq(struct da9211 *chip, int irq) int
> > +da9211_unmask_irq(struct da9211 *chip, int irq)
> 
> This looks bad...  similarly most of the rest of the interrupt code.
> What is it supposed to be doing?
Originally it is supposed for user to enable/disable various interrupt signal.
But indeed it seems a redundant code. The code will  be reorganized and submitted again. 
