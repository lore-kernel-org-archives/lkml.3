Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaJ0K12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:27:28 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32638 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaJ0K10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:27:26 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-d8-544e1e0bba60
Message-id: <1414405641.1674.1.camel@AMDC1943>
Subject: Re: [PATCH v4 2/3] regulator: max77686: Implement suspend disable for
 some LDOs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Mon, 27 Oct 2014 11:27:21 +0100
In-reply-to: <544E19A4.6040603@collabora.co.uk>
References: <1414403066-7872-1-git-send-email-k.kozlowski@samsung.com>
 <1414403066-7872-3-git-send-email-k.kozlowski@samsung.com>
 <544E19A4.6040603@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xy7rccn4hBh0d3BYbZ6xntZi07gCT
	xdSHT9gsrn95zmox/8g5VoujvwssehdcZbM42/SG3eLblQ4mi02Pr7FaXN41h81ixvl9TBa3
	L/NarD1yl92Bz6OluYfN4+/z6ywef1e9YPbYOesuu8emVZ1sHpuX1Hv0bVnF6PF5k1wARxSX
	TUpqTmZZapG+XQJXxrFzU1kKrmlVbD7wn6WBcaJSFyMnh4SAicS92yeYIGwxiQv31rN1MXJx
	CAksZZSYseI6M0hCSOAzo8TKPU4gNq+AnsS+pVdZQWxhgSiJC1dPsYHYbALGEpuXLwGzRQTs
	JG6sfsgMMohZ4CezxKO2YywgCRYBVYmG001gNqeAvsS1U/9ZILatYJRYch0iwSygLjFp3iKg
	bg6gk5QlGvvdIBYLSvyYfA+qRF5i85q3zBMYBWYh6ZiFpGwWkrIFjMyrGEVTS5MLipPScw31
	ihNzi0vz0vWS83M3MUKi6MsOxsXHrA4xCnAwKvHw7pjmGyLEmlhWXJl7iFGCg1lJhNfxJ1CI
	NyWxsiq1KD++qDQntfgQIxMHp1QDY8bZv7+vPIk4P8sz84V5tzCv4e8v8oa3s07822whlmb5
	esovW+0l675fWZvKeufTheUrly+O+OvNt2xX5dY6z0bmuwWJPIk99mYZz+tuTK/9PWNe+sSM
	wNkTAwz5Z7ydJ7S6s/f9bjd269tV+3i787d+KXCRU6hcXGGf92WxwoH9PUZ/5ps8/qTEUpyR
	aKjFXFScCAAqBQLngAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-10-27 at 11:08 +0100, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/27/2014 10:44 AM, Krzysztof Kozlowski wrote:
> > Some LDOs of Maxim 77686 PMIC support disabling during system suspend
> > (LDO{2,6,7,8,10,11,12,14,15,16}). This was already implemented as part
> > of set_suspend_mode function. In that case the mode was one of:
> >  - disable,
> >  - normal mode,
> >  - low power mode.
> > However there are no bindings for setting the mode during suspend.
> > 
> > Add suspend disable for LDO regulators supporting this to the existing
> > max77686_buck_set_suspend_disable() function. This helps reducing
> > energy consumption during system sleep.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/regulator/max77686.c | 75 ++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 66 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> > index 3d0922051488..4b35c19c9286 100644
> > --- a/drivers/regulator/max77686.c
> > +++ b/drivers/regulator/max77686.c
> > @@ -87,18 +87,31 @@ struct max77686_data {
> >  	unsigned int opmode[MAX77686_REGULATORS];
> >  };
> >  
> > -/* Some BUCKS supports Normal[ON/OFF] mode during suspend */
> > -static int max77686_buck_set_suspend_disable(struct regulator_dev *rdev)
> > +/* Some BUCKs and LDOs supports Normal[ON/OFF] mode during suspend */
> > +static int max77686_set_suspend_disable(struct regulator_dev *rdev)
> >  {
> >  	unsigned int val;
> >  	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
> >  	int ret, id = rdev_get_id(rdev);
> >  
> > -	if (id == MAX77686_BUCK1)
> > +	switch (id) {
> > +	case MAX77686_BUCK1:
> >  		val = MAX77686_BUCK_OFF_PWRREQ;
> > -	else
> > -		val = MAX77686_BUCK_OFF_PWRREQ
> > -			<< MAX77686_OPMODE_BUCK234_SHIFT;
> > +		break;
> > +	case MAX77686_BUCK2 ...	MAX77686_BUCK4:
> > +		val = MAX77686_BUCK_OFF_PWRREQ << MAX77686_OPMODE_BUCK234_SHIFT;
> > +		break;
> > +	case MAX77686_LDO2:
> > +	case MAX77686_LDO6 ... MAX77686_LDO8:
> > +	case MAX77686_LDO10 ... MAX77686_LDO12:
> > +	case MAX77686_LDO14 ... MAX77686_LDO16:
> > +		val = MAX77686_LDO_OFF_PWRREQ << MAX77686_OPMODE_SHIFT;
> > +		break;
> > +	default:
> > +		pr_warn("%s: regulator_suspend_disable not supported\n",
> > +			rdev->desc->name);
> > +		return -EINVAL;
> > +	}
> >  
> >  	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> >  				 rdev->desc->enable_mask, val);
> > @@ -176,13 +189,53 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
> >  	return 0;
> >  }
> >  
> > +/*
> > + * For regulators supporting disabled in suspend it checks if opmode
> > + * is 'off_pwrreq' mode (disabled in suspend) and changes it to 'enable'.
> > + * For other regulators does nothing.
> > + */
> > +static void max77686_set_opmode_enable(struct max77686_data *max77686, int id)
> > +{
> > +	unsigned int opmode_shift;
> > +
> > +	/*
> > +	 * Same enable function is used for LDO and bucks. Assuming
> > +	 * the same values are used for enable registers.
> > +	 */
> > +	BUILD_BUG_ON(MAX77686_LDO_OFF_PWRREQ != MAX77686_BUCK_OFF_PWRREQ);
> > +	BUILD_BUG_ON(MAX77686_LDO_NORMAL != MAX77686_BUCK_NORMAL);
> > +
> > +	switch (id) {
> > +	case MAX77686_BUCK1:
> > +		opmode_shift = 0;
> > +		break;
> > +	case MAX77686_BUCK2 ...	MAX77686_BUCK4:
> > +		opmode_shift = MAX77686_OPMODE_BUCK234_SHIFT;
> > +		break;
> > +	case MAX77686_LDO2:
> > +	case MAX77686_LDO6 ... MAX77686_LDO8:
> > +	case MAX77686_LDO10 ... MAX77686_LDO12:
> > +	case MAX77686_LDO14 ... MAX77686_LDO16:
> > +		opmode_shift = MAX77686_OPMODE_SHIFT;
> > +		break;
> > +	default:
> > +		return;
> > +	}
> > +
> > +	if (max77686->opmode[id] == (MAX77686_LDO_OFF_PWRREQ << opmode_shift))
> > +		max77686->opmode[id] = MAX77686_LDO_NORMAL << opmode_shift;
> > +}
> > +
> >  static int max77686_enable(struct regulator_dev *rdev)
> >  {
> >  	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
> > +	int id = rdev_get_id(rdev);
> > +
> > +	max77686_set_opmode_enable(max77686, id);
> >  
> >  	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> >  				  rdev->desc->enable_mask,
> > -				  max77686->opmode[rdev_get_id(rdev)]);
> > +				  max77686->opmode[id]);
> >  }
> 
> the max77802 driver handles this slightly differently. It stores in opmode[id]
> just the value without the shift and there is a max77802_get_opmode_shift() to
> obtain the shift that is used before updating the register, e.g:
> 
> int shift = max77802_get_opmode_shift(id);
> return regmap_update_bits(..., max77802->opmode[id] << shift);
> 
> I think the max77802 driver approach is better since it avoids duplicating the
> switch statement to get the shift for each regulator. Just look how the max77802
> enable and disable functions are easier to read. Looking at the max77686 driver,
> I see that there are assumptions that opmode[id] has the value shifted so your
> changes are consistent with the rest of the driver but I would consider changing
> this.

Storing opmode in non-shifted form is intuitive also to me. That's way I
slipped the bug in previous version.

I'll change this to non-shifted opmode. The patch will grow bigger but
the code should be more readable.

Thanks!
Krzysztof


> Best regards,
> Javier
> 

