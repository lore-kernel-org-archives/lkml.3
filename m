Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaJOLLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:11:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:24996 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaJOLLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:11:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-30-543e56657242
Content-transfer-encoding: 8BIT
Message-id: <1413371491.26771.15.camel@AMDC1943>
Subject: Re: [RFT PATCH] power: bq2415x_charger: Properly handle ENODEV from
 power_supply_get_by_phandle
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 15 Oct 2014 13:11:31 +0200
In-reply-to: <20141015090512.GA26651@earth.universe>
References: <1413275573-23014-1-git-send-email-k.kozlowski@samsung.com>
 <20141015090512.GA26651@earth.universe>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xK7qpYXYhBi+OalhMevKe2WLiysnM
	Fpd3zWGz+Nx7hNHi9O4SiwUbHzE6sHnsnHWX3WPzCi2PTas62Tw+b5ILYInisklJzcksSy3S
	t0vgyli36Q9rwWXRiuVd+9gaGNcLdjFyckgImEjM6XzIDmGLSVy4t56ti5GLQ0hgKaPE9M+z
	WUASvAKCEj8m3wOyOTiYBeQljlzKBgkzC6hLTJq3iBmi/jOjxLVr05kh6g0kFvZBDBUWyJLo
	/n0JLM4mYCyxefkSNhBbREBN4v2lpywgzcwCaxkl9n+/BVbEIqAq8frCBrAiTqDrjs2dxAyy
	WEigUGLiv0AQU0JAWaKx320Co8AsJNfNQrhuFpLrFjAyr2IUTS1NLihOSs810itOzC0uzUvX
	S87P3cQICeSvOxiXHrM6xCjAwajEw8txwDZEiDWxrLgy9xCjBAezkghvor9diBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQbGJR6NQUV+vYYXMh8tdDr73Kj/jdRKhu+db8+FXT736fPvVx+K3p5l
	a3V8FlRZ+EdcMeT70ZbcxlDvHF6PbbxSrxJmqi9hFEveL7Il90Dk/Y9ej9ceVr1+q+fUnC0s
	URPe63KevNPeqivCHXD89GR3HVGXquYWN4W3dbPft4qtV1MP0GXZ2a2txFKckWioxVxUnAgA
	Tt4KSEICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-15 at 11:05 +0200, Sebastian Reichel wrote:
> Hi Krzysztof,
> 
> On Tue, Oct 14, 2014 at 10:32:53AM +0200, Krzysztof Kozlowski wrote:
> > The power_supply_get_by_phandle() on error returns ENODEV or NULL.
> > The driver later expects obtained pointer to power supply to be
> > valid or NULL. If it is not NULL then it dereferences it in
> > bq2415x_notifier_call() which would lead to dereferencing ENODEV-value
> > pointer.
> > 
> > Properly handle the power_supply_get_by_phandle() error case and abort probe.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Fixes: faffd234cf85 ("bq2415x_charger: Add DT support")
> > Cc: <stable@vger.kernel.org>
> 
> That looks valid, but I guess this should change one more thing:
> 
> > ---
> >  drivers/power/bq2415x_charger.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
> > index e384844a1ae1..d9c457217b6a 100644
> > --- a/drivers/power/bq2415x_charger.c
> > +++ b/drivers/power/bq2415x_charger.c
> > @@ -1579,8 +1579,13 @@ static int bq2415x_probe(struct i2c_client *client,
> >  	if (np) {
> >  		bq->notify_psy = power_supply_get_by_phandle(np, "ti,usb-charger-detection");
> >  
> > -		if (!bq->notify_psy)
> > +		if (!bq->notify_psy) {
> >  			return -EPROBE_DEFER;
> 
> this also needs to goto error_2. I guess something as the following
> is needed:
> 
> if (IS_ERR_OR_NULL(bq->notify_psy)) {
>     if (bq->notify_psy)
>         dev_err(&client->dev, "no 'ti,usb-charger-detection' property\n");
>     ret = PTR_ERR(bq->notify_psy);
>     goto error_2;
> }

So you do not want to defer the probe? What if notified charger will
come online after this probe?

Second idea - now I think my change is not compatible with bindings
(documentation) and could break booting of existing boards which do not
provide the "ti,usb-charger-detection" property. For example
arch/arm/boot/dts/omap3-n900.dts

The "ti,usb-charger-detection" property is marked as optional but my
patch actually makes it required.

It should be rather like this:

if (IS_ERR(bq->notify_psy)) {
    bq->notify_psy = NULL;
    dev_info(&client->dev, "no 'ti,usb-charger-detection' property \n");
} else if (!bq->notify_psy) {
    ret = -EPROBE_DEFER;
    goto error_2;
}

What do you think?

Krzysztof

> > +		} else if (IS_ERR(bq->notify_psy)) {
> > +			dev_err(&client->dev, "no 'ti,usb-charger-detection' property\n");
> > +			ret = PTR_ERR(bq->notify_psy);
> > +			goto error_2;
> > +		}
> >  	}
> >  	else if (pdata->notify_device)
> >  		bq->notify_psy = power_supply_get_by_name(pdata->notify_device);
> 
> -- Sebastian

