Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaGIBDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:03:42 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.168]:23992 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947AbaGIBDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:03:40 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-16.tower-39.messagelabs.com!1404867818!24401424!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Date: Wed, 9 Jul 2014 10:03:32 +0900
Message-ID: <201407090103.s6913Wwl035701@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Re: [PATCH V4] regulator: DA9211 : new regulator driver
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Tuesday, July 08, 2014 4:36 PM
> To: Opensource [James Seong-Won Ban]
> Cc: Liam Girdwood; Support Opensource; LKML; David Dajun Chen
> Subject: Re: [PATCH V4] regulator: DA9211 : new regulator driver
> 
> On Thu, Jul 03, 2014 at 04:29:03PM +0900, James Ban wrote:
> 
> This is greatly improved, thanks, however there are still a few issues which
> should be addressed:
> 
> > +static irqreturn_t da9211_irq_handler(int irq, void *data) {
> > +	struct da9211 *chip = data;
> > +	int reg_val, ret;
> > +
> > +	ret = regmap_read(chip->regmap, DA9211_REG_EVENT_B, &reg_val);
> > +	if (ret < 0)
> > +		goto error_i2c;
> > +
> > +	if (reg_val & DA9211_E_OV_CURR_A) {
> 
> > +	if (reg_val & DA9211_E_OV_CURR_B) {
> 
> > +
> > +	return IRQ_HANDLED;
> 
> This is buggy - the driver should only return IRQ_HANDLED if it handled the
> interrupt somehow, otherwise it should return IRQ_NONE and let the interrupt
> core handle things.  This is especially important since the device appears to
> require that interrupts are explicitly acknoweldged so if something is flagged
> but not handled the interrupt will just sit constantly asserted.
Basically all interrupts are masked when the chip wakes up. 
Only two interrupts are unmasked at the start of driver like below.
-------------
if (chip->chip_irq != 0) {
			ret = regmap_update_bits(chip->regmap,
				DA9211_REG_MASK_B, DA9211_M_OV_CURR_A << i, 1);
-----------------
So constant assertion which you are worry about could not happen.
Please let me know if you think other case.
> 
> > +static int da9211_regulator_init(struct da9211 *chip) {
> > +	struct regulator_config config = { };
> > +	int i, ret;
> > +	unsigned int data;
> > +
> > +	ret = regmap_update_bits(chip->regmap, DA9211_REG_PAGE_CON,
> > +			DA9211_REG_PAGE_MASK, DA9211_REG_PAGE2);
> > +	if (ret < 0) {
> > +		dev_err(chip->dev, "Failed to update PAGE reg: %d\n", ret);
> > +		goto err;
> > +	}
> 
> It would be better to model the paging in the register map in the regmap
> - the API has support for this, it's going to be more robust to use it.
I will change the code for the usage of the API.
> 
> > +		dev_info(chip->dev, "# IRQ configured [%d]\n", chip->chip_irq);
> 
> > +	for (i = 0; i < chip->num_regulator; i++)
> > +		regulator_unregister(chip->rdev[i]);
> 
> Use devm_regulator_register().
I will do it.
> 
> > +	if (chip->chip_irq != 0)
> > +		free_irq(chip->chip_irq, chip);
> 
> devm_request_threaded_irq().
I will use devm_request_threaded_irq and remove free_irq.
