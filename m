Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbaEFGZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:25:24 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31594 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbaEFGZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:25:21 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-7a-5368804d72db
Message-id: <1399357529.5441.4.camel@AMDC1943>
Subject: Re: [PATCH 2/2] regulator: s2mpa01: Fix accidental enable of buck4
 ramp delay
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Date: Tue, 06 May 2014 08:25:29 +0200
In-reply-to: <CAFRkauDO4auf7E4LK4Ms0humK=aRr3496=vEd3FK5jxa3Am-+A@mail.gmail.com>
References: <1399302603-1427-1-git-send-email-k.kozlowski@samsung.com>
 <1399302603-1427-2-git-send-email-k.kozlowski@samsung.com>
 <CAFRkauDO4auf7E4LK4Ms0humK=aRr3496=vEd3FK5jxa3Am-+A@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7p+DRnBBmuyLY7M+cpsMfXhEzaL
	b1c6mCwu75rDZnHyTy+jxcUVX5gc2Dx2zrrL7tH2s8xj06pONo871/awefRtWcXo8XmTXABb
	FJdNSmpOZllqkb5dAlfG1SeP2As+C1ds6rjI3MA4UaCLkZNDQsBE4sKmHywQtpjEhXvr2boY
	uTiEBJYySjzcO50ZwvnMKPH/7E6wKl4BPYnpHfPAbGGBCIl3H16zgdhsAsYSm5cvAbNFBJQk
	Vt2/DFbDLHCTUWLtIwMQm0VAVeLXhk/sIDanQLDE73nHGSEWnGKUeH60hwmiQV1i0rxFzBAn
	KUvM23+MCWKxoMSPyfeghspLbF7zlnkCo8AsJC2zkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFi
	bnFpXrpecn7uJkZIkH/Zwbj4mNUhRgEORiUe3hfRGcFCrIllxZW5hxglOJiVRHjr84FCvCmJ
	lVWpRfnxRaU5qcWHGJk4OKUaGN3fTc76yzox0EZvuthZ/q1PFmz1TEpU3rVy5m2HiKnBiYtL
	lSWvTq689df68X3xQqf9ETZ1POvaZ+7tXie8hUX43OtJF761r56yamq4CreE2tIsz6iOvsrJ
	ektEPKZv+XbvXv1uh4QVdiuvLftb4D6lQ9pomU/K20zHTd1r72WceNP2xdM+9LcSS3FGoqEW
	c1FxIgBqadZWUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-05-05 at 23:27 +0800, Axel Lin wrote:
> 2014-05-05 23:10 GMT+08:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
> > S2MPA01 supports enabling/disabling ramp delay only for buck[1234].
> > Other bucks have ramp delay enabled always.
> >
> > However the bit shift for enabling buck4 ramp delay in register is equal
> > to 0. When ramp delay was set for these other bucks (buck[56789] and
> > buck10), the ramp delay for buck4 was also enabled.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Fixes: f7b1a8dc1c1c ("regulator: s2mpa01: Don't check enable_shift before setting enable ramp rate")
> > ---
> >  drivers/regulator/s2mpa01.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
> > index f19a30f0fb42..901504880ab6 100644
> > --- a/drivers/regulator/s2mpa01.c
> > +++ b/drivers/regulator/s2mpa01.c
> > @@ -99,7 +99,8 @@ static int s2mpa01_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
> >  {
> >         struct s2mpa01_info *s2mpa01 = rdev_get_drvdata(rdev);
> >         unsigned int ramp_val, ramp_shift, ramp_reg = S2MPA01_REG_RAMP2;
> > -       unsigned int ramp_enable = 1, enable_shift = 0;
> > +       unsigned int ramp_enable = 1;
> > +       int enable_shift = -1;
> Hi Krzysztof,
> This makes the meaning of enable_shift looks confusing.
> I think below change has better readability.
> 
> diff --git a/drivers/regulator/s2mpa01.c b/drivers/regulator/s2mpa01.c
> index f19a30f..eb5ce18 100644
> --- a/drivers/regulator/s2mpa01.c
> +++ b/drivers/regulator/s2mpa01.c
> @@ -192,11 +192,15 @@ static int s2mpa01_set_ramp_delay(struct
> regulator_dev *rdev, int ramp_delay)
>   if (!ramp_enable)
>   goto ramp_disable;
> 
> - ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
> - 1 << enable_shift, 1 << enable_shift);
> - if (ret) {
> - dev_err(&rdev->dev, "failed to enable ramp rate\n");
> - return ret;
> + /* S2MPA01 supports enabling/disabling ramp delay only for buck[1234] */
> + if (rdev->desc->id >= S2MPA01_BUCK1 &&
> +    rdev->desc->id <= S2MPA01_BUCK4) {
> + ret = regmap_update_bits(rdev->regmap, S2MPA01_REG_RAMP1,
> + 1 << enable_shift, 1 << enable_shift);
> + if (ret) {
> + dev_err(&rdev->dev, "failed to enable ramp rate\n");
> + return ret;
> + }
>   }
> 
>   ramp_val = get_ramp_delay(ramp_delay);

Yes, it looks better for S2MPA01. Thanks for idea, I'll send v2. 

Best regards,
Krzysztof

