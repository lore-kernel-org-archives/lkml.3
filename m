Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbaGII3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:29:12 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.163]:22216 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294AbaGII3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:29:08 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-7.tower-39.messagelabs.com!1404894545!26125309!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Date: Wed, 9 Jul 2014 17:28:59 +0900
Message-ID: <201407090828.s698SxPD017842@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Subject: Re: [PATCH V4] regulator: DA9211 : new regulator driver
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "David Dajun Chen" <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Wednesday, July 09, 2014 4:57 PM
> To: Opensource [James Seong-Won Ban]
> Cc: Liam Girdwood; Support Opensource; LKML; David Dajun Chen
> Subject: Re: your mail
> 
> On Wed, Jul 09, 2014 at 10:03:32AM +0900, James Ban wrote:
> 
> > > > +	ret = regmap_read(chip->regmap, DA9211_REG_EVENT_B, &reg_val);
> > > > +	if (ret < 0)
> > > > +		goto error_i2c;
> 
> > > > +	if (reg_val & DA9211_E_OV_CURR_A) {
> 
> > > > +	if (reg_val & DA9211_E_OV_CURR_B) {
> 
> > > > +	return IRQ_HANDLED;
> 
> > > This is buggy - the driver should only return IRQ_HANDLED if it
> > > handled the interrupt somehow, otherwise it should return IRQ_NONE
> > > and let the interrupt core handle things.  This is especially
> > > important since the device appears to require that interrupts are
> > > explicitly acknoweldged so if something is flagged but not handled the
> interrupt will just sit constantly asserted.
> 
> > Basically all interrupts are masked when the chip wakes up.
> > Only two interrupts are unmasked at the start of driver like below.
> 
> I know that's the intention but the code should still be written robustly -
> something might go wrong somewhere which causes another interrupt to be
> enabled, or we might even gain support for shared threaded interrupts in the
> interrupt core and someone could then try to use that in a system.
How about below code for proper handle of interrupt?
static irqreturn_t da9211_irq_handler(int irq, void *data)
{
	struct da9211 *chip = data;
	int reg_val, ret;

	ret = regmap_read(chip->regmap, DA9211_REG_EVENT_B, &reg_val);
	if (ret < 0)
		goto error_i2c;

	if (reg_val & DA9211_E_OV_CURR_A) {
		regulator_notifier_call_chain(chip->rdev[0],
			REGULATOR_EVENT_OVER_CURRENT,
			rdev_get_drvdata(chip->rdev[0]));

		ret = regmap_write(chip->regmap, DA9211_REG_EVENT_B,
			DA9211_E_OV_CURR_A);
		if (ret < 0)
			goto error_i2c;

		return IRQ_HANDLED;
	}
	else if (reg_val & DA9211_E_OV_CURR_B) {
		regulator_notifier_call_chain(chip->rdev[1],
			REGULATOR_EVENT_OVER_CURRENT,
			rdev_get_drvdata(chip->rdev[1]));

		ret = regmap_write(chip->regmap, DA9211_REG_EVENT_B,
			DA9211_E_OV_CURR_B);
		if (ret < 0)
			goto error_i2c;

		return IRQ_HANDLED;
	}
	else
		return IRQ_NONE;

error_i2c:
	dev_err(chip->dev, "I2C error : %d\n", ret);
	return IRQ_NONE;
}
