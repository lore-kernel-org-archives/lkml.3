Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbbA2CJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:09:14 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45679 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbbA2CJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:09:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-4e-54c896221540
Message-id: <1422431921.8854.4.camel@AMDC1943>
Subject: Re: [RFT PATCH 1/4] power_supply: twl4030_madc: Check return value of
 power_supply_register
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        Darren Hart <dvhart@infradead.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        stable@vger.kernel.org
Date: Wed, 28 Jan 2015 08:58:41 +0100
In-reply-to: <CAAfyv34YoUG8dyq10mFZRQ-uf6-oT_KAbwZ1UQQ0FvFrs10BrQ@mail.gmail.com>
References: <1422358221-13199-1-git-send-email-k.kozlowski@samsung.com>
 <1422358221-13199-2-git-send-email-k.kozlowski@samsung.com>
 <CAAfyv34YoUG8dyq10mFZRQ-uf6-oT_KAbwZ1UQQ0FvFrs10BrQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xK7pK006EGLzfw2Ox5EQ3i8WkJ++Z
	LboWGlhMXDmZ2eLyrjlsFp97jzBabG87ymKx8Yadxeo9L5gtTu8usViw8RGjA7fHzll32T2O
	XbvD4rF5hZbHplWdbB6fN8kFsEZx2aSk5mSWpRbp2yVwZbxf/Iy9oFWk4sjLZ4wNjE/4uxg5
	OSQETCT6p/1hg7DFJC7cWw9kc3EICSxllDjX0cwC4XxmlNiyaTsjSBWvgJ7ElrP7WEFsYYE0
	if4THWDdbALGEpuXLwGzRQS0JVo/PGICaWYWmMEs0Xf6I1iCRUBV4t6PRewgNqdAsMThR3uZ
	ITacYZTY+uQfWIJZQF1i0rxFQAkOoJuUJRr73SAWC0r8mHyPBaJEXmLzmrfMExgFZiHpmIWk
	bBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQiLhyw7GxcesDjEKcDAq8fC+MDsR
	IsSaWFZcmXuIUYKDWUmE960GUIg3JbGyKrUoP76oNCe1+BAjEwenVAOj9ZfDDfX5u97Unppc
	1GLMv/BLWEZGxYLL765WF7lIaqx9bPYtWKT6m5B/nqrNEiXXHCf7xf4rFlx1Ngo3CK0IXqgS
	M0vZe5fwkt2xR+ev5U2wlq5Ywn3Ve6eO1szLtbwr573ctffJhpupH267rdYRjBHeddvoevaW
	29riBz5u8n83z2Djmsl+SizFGYmGWsxFxYkA1pgVq2ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2015-01-27 at 22:06 +0100, Belisko Marek wrote:
> Hi Krzystof,
> 
> On Tue, Jan 27, 2015 at 12:30 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > The return value of power_supply_register() call was not checked and
> > even on error probe() function returned 0. If registering failed then
> > during unbind the driver tried to unregister power supply which was not
> > actually registered.
> >
> > This could lead to memory corruption because power_supply_unregister()
> > unconditionally cleans up given power supply.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Fixes: da0a00ebc239 ("power: Add twl4030_madc battery driver.")
> > Cc: <stable@vger.kernel.org>
> > ---
> >  drivers/power/twl4030_madc_battery.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/power/twl4030_madc_battery.c b/drivers/power/twl4030_madc_battery.c
> > index 7ef445a6cfa6..cf907609ec49 100644
> > --- a/drivers/power/twl4030_madc_battery.c
> > +++ b/drivers/power/twl4030_madc_battery.c
> > @@ -192,6 +192,7 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
> >  {
> >         struct twl4030_madc_battery *twl4030_madc_bat;
> >         struct twl4030_madc_bat_platform_data *pdata = pdev->dev.platform_data;
> > +       int ret = 0;
> >
> >         twl4030_madc_bat = kzalloc(sizeof(*twl4030_madc_bat), GFP_KERNEL);
> >         if (!twl4030_madc_bat)
> > @@ -216,9 +217,11 @@ static int twl4030_madc_battery_probe(struct platform_device *pdev)
> >
> >         twl4030_madc_bat->pdata = pdata;
> >         platform_set_drvdata(pdev, twl4030_madc_bat);
> > -       power_supply_register(&pdev->dev, &twl4030_madc_bat->psy);
> > +       ret = power_supply_register(&pdev->dev, &twl4030_madc_bat->psy);
> > +       if (ret < 0)
> > +               kfree(twl4030_madc_bat);
> I post update twl4030_madc to iio some time ago [1] where this change
> was incorporated.
> I plan to respin in next week so we can drop this one (or take and
> I'll rebase on top).

Hi,

I am fine with both solutions (especially that I am not able to test my
change). However there is one benefit of my fix: after applying it could
be backported to stable kernels (3.11+?).

Best regards,
Krzysztof

> >
> > -       return 0;
> > +       return ret;
> >  }
> >
> >  static int twl4030_madc_battery_remove(struct platform_device *pdev)
> > --
> > 1.9.1
> >
> 
> [1] - https://lkml.org/lkml/2014/3/5/284
> 
> BR,
> 
> marek
> 

