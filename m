Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaBUKm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 05:42:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57947 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbaBUKm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 05:42:58 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-e3-53072db14a85
Message-id: <1392979375.19813.3.camel@AMDC1943>
Subject: Re: [PATCH] regulator: max14577: Fix invalid return value on DT parse
 success
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 21 Feb 2014 11:42:55 +0100
In-reply-to: <CAK9yfHxQOroe2JZVs8roBVGxLXMMKdtA21JVjVW7z6Ndf-mytg@mail.gmail.com>
References: <1392909541-10285-1-git-send-email-k.kozlowski@samsung.com>
 <CAK9yfHxQOroe2JZVs8roBVGxLXMMKdtA21JVjVW7z6Ndf-mytg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xa7obddmDDT5NFLGY+vAJm8W3Kx1M
	Fpd3zWGzOPmnl9GBxWPnrLvsHptWdbJ53Lm2h83j8ya5AJYoLpuU1JzMstQifbsEroy3a3+y
	F1zgq5jTvoa1gXEadxcjJ4eEgInE67+/GCFsMYkL99azdTFycQgJLGWUmHfmIDuE85lRovvc
	axaQKl4BfYnjp2+xgdjCAhESf+/tYQex2QSMJTYvXwIWFxHQknjZvZwJxGYWyJc4sq4TrIZF
	QFXiyJcXQDYHB6dAsMSP9WkQ8/sYJVZ9nc8GUa8uMWneImaIi5QkdrdD9DILyEtsXvOWGeIG
	QYkfk++xTGAUmIWkZRaSsllIyhYwMq9iFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAnfLzsY
	Fx+zOsQowMGoxMNbIMEWLMSaWFZcmXuIUYKDWUmEV1iZPViINyWxsiq1KD++qDQntfgQIxMH
	p1QDo3lrqInirfBfnRs2t17MeuCX8nvJnJmibyevCrnkYHpuB6O1/8Z5Qe75V1jYry3cMIH1
	xx3/ZX8N2WW4e6K4und8XDT17YwriXtCt3DPOajPpuwxL4j3dnqeYv/MI5E55Ups69KruBa3
	cHPZ9dQqfFbctfWM4daQA2r633+URbjO33r0j3DwfCWW4oxEQy3mouJEALYez7s9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 15:54 +0530, Sachin Kamat wrote:
> Hi Krzysztof,
> 
> On 20 February 2014 20:49, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> > This fixes bug introduced in 667a6b7a (regulator: max14577: Add missing
> > of_node_put). The DTS parsing function returned number of matched
> > regulators as success status which then was compared against 0 in probe.
> >
> > Result was a probe fail after successful parsing the DTS:
> > max14577-regulator: probe of max14577-regulator failed with error 2
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/regulator/max14577.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
> > index 186df8785a91..6ba11a8dd23d 100644
> > --- a/drivers/regulator/max14577.c
> > +++ b/drivers/regulator/max14577.c
> > @@ -168,11 +168,13 @@ static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev)
> >                         MAX14577_REG_MAX);
> >         if (ret < 0) {
> >                 dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
> > +               of_node_put(np);
> > +               return ret;
> >         }
> >
> >         of_node_put(np);
> >
> > -       return ret;
> > +       return 0;
> >  }
> 
> Instead of so many changes here, you could simply make the following change
> in the max14577_regulator_probe function.
> 
> ret = max14577_regulator_dt_parse_pdata(pdev);
> if (ret < 0)
>         return ret;

That still wouldn't be sufficient because later in probe() the 'ret' is
not reassigned (if devm_regulator_register succeeds) and it is directly
returned at the probe() end. So still the number of matched regulators
would be returned as probe result.

Best regards,
Krzysztof

