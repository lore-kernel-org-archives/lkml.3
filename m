Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaJOOKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:10:05 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11107 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJOOKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:10:01 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-40-543e8037a018
Content-transfer-encoding: 8BIT
Message-id: <1413382197.9555.0.camel@AMDC1943>
Subject: Re: [RFT PATCH] power: bq2415x_charger: Properly handle ENODEV from
 power_supply_get_by_phandle
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 15 Oct 2014 16:09:57 +0200
In-reply-to: <20141015135806.GA5152@earth.universe>
References: <1413275573-23014-1-git-send-email-k.kozlowski@samsung.com>
 <20141015090512.GA26651@earth.universe> <1413371491.26771.15.camel@AMDC1943>
 <20141015135806.GA5152@earth.universe>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xK7rmDXYhBv+aRS0mPXnPbDFx5WRm
	i8u75rBZfO49wmhxeneJxYKNjxgd2Dx2zrrL7rF5hZbHplWdbB6fN8kFsERx2aSk5mSWpRbp
	2yVwZaybKFswh6/i2YJNbA2MP7m6GDk5JARMJCZ1HmCDsMUkLtxbD2RzcQgJLGWUuDVxHhNI
	gldAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvEDFH/mVFiXWcLWA2vgJ5ER0cmSI2wQJZE
	9+9LzCA2m4CxxOblS8B2iQioSby/9JQFpJdZYC2jxP7vt5hBelkEVCWWLfYBqeEEqp+16T8L
	xPz9jBLXnv8Dmy8hoCzR2O82gVFgFpLrZiFcNwvJdQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al
	6yXn525ihITxlx2Mi49ZHWIU4GBU4uHlOGAbIsSaWFZcmXuIUYKDWUmEd36CXYgQb0piZVVq
	UX58UWlOavEhRiYOTqkGxgLO2K60uJJDW/+Xb9vtwn3VjKPwtrNkpmJCmuReZXOGy3orzv1W
	EHsSVn9iYpiKFc88Bn3hG1w8fhYa69OX6urMOnydVVDcQu3hsYJvVlZbLnH48J1Van/enX6V
	5/eni9Mmbn1zSqrf/OjWWIXO+SznJOMTLUUr/r+W3tEw69viF1svPdwVr8RSnJFoqMVcVJwI
	AEZ28vJBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-15 at 15:58 +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Wed, Oct 15, 2014 at 01:11:31PM +0200, Krzysztof Kozlowski wrote:
> > > [...] I guess something as the following is needed:
> > > 
> > > if (IS_ERR_OR_NULL(bq->notify_psy)) {
> > >     if (bq->notify_psy)
> > >         dev_err(&client->dev, "no 'ti,usb-charger-detection' property\n");
> > >     ret = PTR_ERR(bq->notify_psy);
> > >     goto error_2;
> > > }
> > 
> > So you do not want to defer the probe? What if notified charger will
> > come online after this probe?
> 
> No, but resources must be freed fore the EPROBE_DEFER case, too.
> You are right, though, that my snipped does not setup the
> EPROBE_DEFER return value correctly.
> 
> > Second idea - now I think my change is not compatible with bindings
> > (documentation) and could break booting of existing boards which do not
> > provide the "ti,usb-charger-detection" property. For example
> > arch/arm/boot/dts/omap3-n900.dts
> >
> > The "ti,usb-charger-detection" property is marked as optional but my
> > patch actually makes it required.
> > 
> > It should be rather like this:
> > 
> > if (IS_ERR(bq->notify_psy)) {
> >     bq->notify_psy = NULL;
> >     dev_info(&client->dev, "no 'ti,usb-charger-detection' property \n");
> > } else if (!bq->notify_psy) {
> >     ret = -EPROBE_DEFER;
> >     goto error_2;
> > }
> >
> > What do you think?
> 
> I thing the dev_info call should include the error code returned,
> since its not propagated further:
> 
> dev_info(&client->dev, "no 'ti,usb-charger-detection' property (err=%d)\n",
>          PTR_ERR(by->notify_psy));
> 
> Apart from that it looks fine to me. Can you send a v2?

Sure, I'll send fixed version.

Best regards,
Krzysztof
> 
> > [...]
> 
> -- Sebastian

