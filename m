Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaJUJg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:36:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41757 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbaJUJg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:36:27 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-49-544629174765
Message-id: <1413884182.26980.12.camel@AMDC1943>
Subject: Re: [PATCH 1/2] regulator: max77686: Implement suspend disable for
 some LDOs
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 21 Oct 2014 11:36:22 +0200
In-reply-to: <54462304.8050602@collabora.co.uk>
References: <1413879912-26606-1-git-send-email-k.kozlowski@samsung.com>
 <1413879912-26606-2-git-send-email-k.kozlowski@samsung.com>
 <54462304.8050602@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xq7rimm4hBr/fW1psnLGe1WLSugNM
	FlMfPmGzuP7lOavF0d8FFr0LrrJZnG16w27x7UoHk8Wmx9dYLS7vmsNmMeP8PiaL25d5LdYe
	uctusWrXH0YHPo+W5h42j7/Pr7N4/F31gtlj56y77B6bVnWyeWxeUu/Rt2UVo8fnTXIBHFFc
	NimpOZllqUX6dglcGY/nz2EsuKpcMeXfVMYGxjMyXYwcHBICJhJHbsZ0MXICmWISF+6tZ+ti
	5OIQEljKKPHo+xZmCOczo8T+r03sIFW8AgYSM/++YgaxhQXCJSY/ucgIYrMJGEtsXr6EDcQW
	EbCTuLH6IVgzs0ATi8TPf1vBilgEVCV2NnYzgdicAvoST899YIHYsIpR4vTiTrBuZgF1iUnz
	FjFDnKcs0djvBrFYUOLH5HssECXyEpvXvGWewCgwC0nHLCRls5CULWBkXsUomlqaXFCclJ5r
	qFecmFtcmpeul5yfu4kREkVfdjAuPmZ1iFGAg1GJh3fDMtcQIdbEsuLK3EOMEhzMSiK8ucJu
	IUK8KYmVValF+fFFpTmpxYcYmTg4pRoYq6QNz1qXf2pwi9qgVn6/aVuWwrt183P9ZLW+J13L
	z+ycxx/R9bTK9I+qMYvI+8fyv9keBzkv+PwxV0BC8vf9uS+udT4yDy4qMHY5FLnNYGUGf9ec
	FN2T5pFOr1fGKfQz1KdY/Dc74Cshy9L4PSbyFb91Yu8vV9EfsVMFUuae6pi04PfN3z5KLMUZ
	iYZazEXFiQCVQK1LgAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-21 at 11:10 +0200, Javier Martinez Canillas wrote:
> Hello Krzysztof,
> 
> On 10/21/2014 10:25 AM, Krzysztof Kozlowski wrote:
> > Some LDOs of Maxim 77686 PMIC support disabling during system suspend
> > (LDO{2,6,7,8,10,11,12,14,15,16}). This was already implemented as part
> 
> You should also document what each regulator support in the max77686 DT binding
> doc, which btw I see is in Documentation/devicetree/bindings/mfd/max77686.txt
> while I think it should be in Documentation/devicetree/bindings/regulators/
> I just posted a patch to add this information to the max77802 DT binding doc [0]
> so maybe you can add something along those lines?

Sure, I'll document this.

> > of set_suspend_mode function. In that case the mode was one of:
> >  - disable,
> >  - normal mode,
> >  - low power mode.
> > However there are no bindings for setting the mode during suspend.
> > 
> > Implement a set_suspend_disable function for regulators supporting this.
> > This helps reducing energy consumption during system sleep.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/regulator/max77686.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> > 
> > diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> > index ef1af2debbd2..84603051f24d 100644
> > --- a/drivers/regulator/max77686.c
> > +++ b/drivers/regulator/max77686.c
> > @@ -123,6 +123,24 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
> >  	return 0;
> >  }
> >  
> > +static int max77686_ldo_set_suspend_disable(struct regulator_dev *rdev,
> > +				     unsigned int mode)
> > +{
> > +	unsigned int val;
> > +	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
> > +	int ret;
> > +
> > +	val = 0x1 << MAX77686_OPMODE_SHIFT;
> 
> Maybe instead of using magic numbers you can document what 0x1 means here.
> I don't have access to the max77686 data-sheet but I do have for the max77802
> so my educated guess is that 0x1 means "Output ON/OFF Controlled by PWRREQ"
> and that the Exynos 4412 XPWRRGTON pin is connected to the max77686 PWRREQ in
> the Trats2 board.

OK.

> 
> > +
> > +	ret = regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
> > +				 rdev->desc->enable_mask, val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	max77686->opmode[rdev_get_id(rdev)] = val;
> > +	return 0;
> > +}
> > +
> 
> There is already a max77686_buck_set_suspend_disable() that is used by BUCK 1-4.
> 
> At least in the max77802, all regulators expect LDO 1, 3, 20 and 21 support OFF
> by PWRREQ so with some refactoring (using a function to get the opmode shift)
> you can use the same function for all regulators that support this instead of
> having separate .set_suspend_disable function handlers.

OK, I can merge this into one suspend_disable.

> 
> >  /* Some LDOs supports LPM-ON/OFF/Normal-ON mode during suspend state */
> >  static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
> >  				     unsigned int mode)
> > @@ -212,6 +230,7 @@ static struct regulator_ops max77686_ldo_ops = {
> >  	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
> >  	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
> >  	.set_suspend_mode	= max77686_ldo_set_suspend_mode,
> > +	.set_suspend_disable	= max77686_ldo_set_suspend_disable,
> 
> You probably want add .set_suspend_enable as well.

Yes, I'll add it.

> 
> >  };
> >  
> >  static struct regulator_ops max77686_buck1_ops = {
> > 
> 
> In general, could you please take a look to the latest patches I posted for the
> max77802? They are in a topic branch in Mark's regulator tree [1]. I would like
> both 77686 and 77802 drivers to handle things similarly even though I know that
> the PMICs don't behave identically and that's why we decided to have different
> drivers (although maybe that was a mistake and makes more sense to merge them).

I looked at them. In this patchset I didn't want to implement fully the
whole suspend-mode-thing. Just the first, easier part - set suspend
disable.

In general I would like to do it similar to your solution but that is
work for future. Especially as I would like to wait for merging your
"Add max77802 regulator operating mode support".

Best regards,
Krzysztof

> 
> Thanks a lot and best regards,
> Javier
> 
> [0]: https://lkml.org/lkml/2014/10/20/320
> [1]: https://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/log/?h=topic/max77802

