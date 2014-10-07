Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaJGMuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:50:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30880 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaJGMuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:50:09 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-86-5433e17eff85
Content-transfer-encoding: 8BIT
Message-id: <1412686205.15309.1.camel@AMDC1943>
Subject: Re: [PATCH] power: charger-manager: Avoid recursive thermal get_temp
 call
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: jonghwa3.lee@samsung.com
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 14:50:05 +0200
In-reply-to: <5433BE0D.6000306@samsung.com>
References: <1412611212-24803-1-git-send-email-k.kozlowski@samsung.com>
 <54334E00.9030403@samsung.com> <1412665994.11780.3.camel@AMDC1943>
 <5433BE0D.6000306@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xK7p1D41DDFomSVoc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi8u75rBZfO49wmhxu3EFm8Xp3SUOnB4T+j8xeuycdZfdY/MKLY9N
	qzrZPPq2rGL0+LxJLoAtissmJTUnsyy1SN8ugStjdY9LwTvxiquLeRsYO4W7GDk5JARMJE79
	7GaCsMUkLtxbz9bFyMUhJLCUUWLpxg1gCV4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8R
	M0T9Z0aJ5TfOMILU8AroS2y8ZANSIywQIrF75iVmEJtNwFhi8/IlbCC2iICMxMqrP5lAepkF
	NjFJrHs5hwUkwSKgKnF78ySwBk4BbYljP56yQyxYyygx5+RGdpAFEgLKEo39bhMYBWYhOW8W
	wnmzkJy3gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZI2H/dwbj0mNUhRgEORiUe3hVa
	xiFCrIllxZW5hxglOJiVRHhPXwQK8aYkVlalFuXHF5XmpBYfYmTi4JRqYDxY8GvZ0bStMyN6
	X1tuq9v8lct+0/td+Q7TVQR/bdS9utgnQX9fqFpBE5fyhfbSBfe7zyq2xq+dLloUy/Hkb1XL
	DNMWRYmWA6tPym1RXu2gv+CgItPm5uvTV7PmZ9Wujfk+94bN42/KfMvPen67d+TmIx+7vW+n
	7ZtmlZGotFKgXX1PjN7BY+eUWIozEg21mIuKEwHM9QgmWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-07 at 19:18 +0900, jonghwa3.lee@samsung.com wrote:
> On 2014년 10월 07일 16:13, Krzysztof Kozlowski wrote:
> 
> > 
> > On wto, 2014-10-07 at 11:20 +0900, jonghwa3.lee@samsung.com wrote:
> >> Hi,
> >> On 2014년 10월 07일 01:00, Krzysztof Kozlowski wrote:
> >>
> >>> The charger manager supports POWER_SUPPLY_PROP_TEMP property and acts
> >>> as a thermal zone if any of these conditions match:
> >>> 1. Fuel gauge used by charger manager supports POWER_SUPPLY_PROP_TEMP.
> >>> 2. 'cm-thermal-zone' property is present in DTS (then it will supersede
> >>>    the fuel gauge temperature property).
> >>>
> >>> However in case 1 (fuel gauge reports temperature and 'cm-thermal-zone'
> >>> is not set) the charger manager forwards its get_temp calls to fuel
> >>> gauge thermal zone.
> >>>
> >>> This leads to reporting by lockdep a false positive deadlock for thermal
> >>> zone's mutex because of nested calls to thermal_zone_get_temp(). This is
> >>> false positive because these are different mutexes: one for charger
> >>> manager thermal zone and second for fuel gauge thermal zone.
> >>>
> >>
> >>
> >> Yes, this happens because power_supply_subsystem automatically creates
> >> thermal_zone when POWER_SUPPLY_PROP_TEMP is available at the time of
> >> power_supply registering. And as you point out, it makes duplicate thermal_zone
> >> when some power_supply references other power_supply's. I hope it would become
> >> to be a selectable option or change the manner of charger-manager itself (if the
> >> charger-manager is only one who references other power_supply's temperature
> >> sensing ability).
> >>
> >> Anyway, the code looks fine to me.
> >>
> >> Acked-by : Jonghwa Lee <jonghwa3.lee@samsung.com>
> > 
> > Thank you for looking at patch. However later I started to wonder
> > whether my fix is sufficient. For the case when fuel gauge is used as
> > source of temperature it is. But for the case when external sensor is
> > used it is not - still there will be recursive call and false positive
> > from lockdep.
> > 
> > Also minor fix is needed in my patch - s/IS_ENABLED/config_enabled/.
> > 
> > I can send a v2 fixing this but first question - what about second
> > recursive issue (when external sensor is used instead of fuel gauge)?
> > 
> 
> 
> Yes, you're right, it still had problem for external temperature sensor case.
> How about we change the core not to make duplicate thermal zone if it already
> existed. It's not the common case, but it looks worthy.
> 
> like as below,
> 
> static int psy_register_thermal(struct power_supply *psy)
> {
> ...
> +	if (psy->tzd)
> +		return 0;
> ...
> 
> We also needs some modification at charger-manager driver, however we can avoid
> recursive call problem with this way :)

Yes, that would remove recursive call but this would also remove thermal
zone for charger manager's power supply. Does anyone (user space?)
depend and use charger managers thermal zone?

Best regards,
Krzysztof

