Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbaGII6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:58:46 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.145]:28537 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbaGII6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:58:44 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-7.tower-178.messagelabs.com!1404896282!36736930!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Date: Wed, 9 Jul 2014 17:57:56 +0900
Message-ID: <201407090857.s698vu4m031984@krsrvapps-01.diasemi.com>
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
> Sent: Wednesday, July 09, 2014 5:39 PM
> To: Opensource [James Seong-Won Ban]
> Cc: Liam Girdwood; Support Opensource; LKML; David Dajun Chen
> Subject: Re: [PATCH V4] regulator: DA9211 : new regulator driver
> 
> On Wed, Jul 09, 2014 at 05:28:59PM +0900, James Ban wrote:
> 
> > How about below code for proper handle of interrupt?
> 
> That's fine, or you could have a return value which defaults to IRQ_NONE and
> then set it to IRQ_HANDLED when you handle a particular bit - that is more
> common since that way if multiple things happen to flag simultaneously they
> can be handled in one call to the interrupt handler.
Thanks for your comment. Is below code O.K.?
static irqreturn_t da9211_irq_handler(int irq, void *data)
{
	struct da9211 *chip = data;
	int reg_val, err, ret = IRQ_NONE;

	err = regmap_read(chip->regmap, DA9211_REG_EVENT_B, &reg_val);
	if (err < 0)
		goto error_i2c;

	if (reg_val & DA9211_E_OV_CURR_A) {
		regulator_notifier_call_chain(chip->rdev[0],
			REGULATOR_EVENT_OVER_CURRENT,
			rdev_get_drvdata(chip->rdev[0]));

		err = regmap_write(chip->regmap, DA9211_REG_EVENT_B,
			DA9211_E_OV_CURR_A);
		if (err < 0)
			goto error_i2c;

		ret = IRQ_HANDLED;
	}

	if (reg_val & DA9211_E_OV_CURR_B) {
		regulator_notifier_call_chain(chip->rdev[1],
			REGULATOR_EVENT_OVER_CURRENT,
			rdev_get_drvdata(chip->rdev[1]));

		err = regmap_write(chip->regmap, DA9211_REG_EVENT_B,
			DA9211_E_OV_CURR_B);
		if (err < 0)
			goto error_i2c;

		ret = IRQ_HANDLED;
	}

	return ret;

error_i2c:
	dev_err(chip->dev, "I2C error : %d\n", err);
	return IRQ_NONE;
}
