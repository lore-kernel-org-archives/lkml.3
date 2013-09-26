Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab3IZM0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:26:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44972 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3IZM0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:26:37 -0400
Message-ID: <524427E5.50403@ti.com>
Date: Thu, 26 Sep 2013 15:26:13 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mike Dunn <mikedunn@newsguy.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <linux-pwm@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: add support for device tree gpio control
References: <1378236372-15711-1-git-send-email-mikedunn@newsguy.com> <20130910172130.GC22111@ulmo> <523056A6.5060000@newsguy.com> <524408BE.40402@ti.com> <20130926120248.GB1680@ulmo>
In-Reply-To: <20130926120248.GB1680@ulmo>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="UJNc4luPBjkKhjtEhfIh1jvrTTtsENfJ4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UJNc4luPBjkKhjtEhfIh1jvrTTtsENfJ4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26/09/13 15:02, Thierry Reding wrote:
> On Thu, Sep 26, 2013 at 01:13:18PM +0300, Tomi Valkeinen wrote:
>> On 11/09/13 14:40, Mike Dunn wrote:
>>> On 09/10/2013 10:21 AM, Thierry Reding wrote:
>>
>>>> Do you have a real setup that actually needs multiple GPIOs? Usually=

>>>> such a setup requires some kind of timing or other additional constr=
aint
>>>> which can't be represented by this simple binding.
>>>>
>>>> Looking at the Palm Treo code it seems like the reason why multiple
>>>> GPIOs are needed is because one is to enable the backlight, while th=
e
>>>> other is in fact used to enable the LCD panel.=20
>>>
>>>
>>> There are actually four GPIOs involved!  (There is an embarrasingly h=
orrible
>>> hack in arch/arm/mach-pxa/palmtreo.c that handles the others.)  One i=
s almost
>>> certainly simply backlight power.  The other three are probably LCD r=
elated.
>>
>> When you say "power", do you mean the gpio enables a regulator to feed=

>> power to the backlight? If so, wouldn't that be a regulator, not gpio,=

>> from the bl driver's point of view?
>>
>> Generally speaking, this same problem appears in many places, but for
>> some reason especially in display. I'm a bit hesitant in adding "free
>> form" gpio/regulator support for drivers, as, as Thierry pointed out,
>> there are often timing requirements, or sometimes the gpios are
>> inverted, or sometimes the gpio is, in fact, a reset gpio, where you'l=
l
>> assert the gpio for a short moment only.
>=20
> I sent out another series a few days ago that somewhat obsoletes this
> patch. What it does is basically add a single enable GPIO that can be
> used to turn the backlight on and off. In a separate patch, support is
> added for a power regulator. The combination of both should be able to
> cover the majority of use-cases.

But Mike's case required 4 GPIOs? Or can that be reduced to one gpio and
one regulator?

> That series doesn't handle any timing requirements, but again, for the
> majority of the setups supported by a power supply and enable GPIO the
> timing doesn't matter.
>=20
>> I haven't seen new versions for the power sequences framework (without=

>> DT support), I think it could help us here a bit by simplifying how we=

>> present the sequences inside the driver. But we still need multiple
>> drivers or the same driver supporting multiple devices.
>=20
> I'm not sure if power sequences will be very helpful here. There was an=

> attempt to get those merged, but the patches were NAKed in the end. I'm=

> not aware of any work currently being done on them.

I thought the NAK was for the DT parts, not for the sequences as such. I
don't remember anyone shooting down the idea of defining power sequences
inside a driver.

> But as I said above, the combination of an enable GPIO and power supply=

> should be enough to get a lot of use-cases supported.

Yep.

>> And I also think that the model where we have just one driver for, say=
,
>> backlight may not be enough. There may be multiple hardware components=
,
>> that used together will generate the backlight. And each component
>> requires specific management.
>=20
> I'm not sure what other components you are talking about here. Can you
> elaborate?

I don't have any specific case in mind, and maybe these are quite rare.
But there could be some kind of mix of muxes, regulators, gpios and
whatnot that need to be managed in certain way to make backlight (or
display) work.

I'm making this up, so I'm not sure if this is sensible, but consider a
board where there's a mux to select where a backlight gets its PWM
input, and the mux is controlled via i2c. And maybe insert some kind of
level shifter in between, enabled with a GPIO. And some third component,
as this hypothetical board is a development board, and hardware people
seem to love to make bizarre designs, that work in theory but the SW is
almost impossible to design...

So to enable the backlight, we might need to do multiple different
things, depending on which components this particular board has.
Especially for a mux controlled via i2c it would make sense to have a
separate driver. Having just a single backlight driver might not be enoug=
h.

Sometimes, or hopefully often, that kind of complexity can be hidden
behind common frameworks. For example, enabling a gpio could result in
the gpio driver enabling a regulator, sending i2c messages, or whatever.
But I don't think that's possible in all cases.

Anyway, this was really more of "thinking out loud" than any suggestion.

 Tomi



--UJNc4luPBjkKhjtEhfIh1jvrTTtsENfJ4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSRCflAAoJEPo9qoy8lh71Bf0P/3mKJ28JGsVN/IdxkB/bQEF0
DWuQSi4eJjBW6jWCQhV8HvTNz4su+77x6uZbfYsGweAMP8Bbxm9mIVBxeAjQyys/
brWK6qKMIIkghDnhAyiqpmTArkQaqS5pHR+/8IA4bmR0X8KcdrtMii2kaaKJbN0P
DkX4ZXcfVQZMYS7UJXYNscmsgghy17gbquw6c3dBM4Fqs4di2So320a/lzozI7mq
WxlIqz4+IyAOA6vaCoqG/bbFGstGAK/oRY7sKMt42laqeRKVaDovgTOEBsLRX6O0
9hDzoibfeQd9FNhezRLrhex82abUX3/YPMT5S0qzzmI4Nxu3wfPj07EhV6fb8/yc
SRGSn6aJPje5qSYMnBuJcBXJvTqtzprX2mC4nmsJ/R/TVVwheUAg/FJKdmmlrj09
XCbxnc7YDUHIlwGAnKcfHF782lt6sCIFQ0/S8rj9Q2S3PkH7w72eXHyJJqYG94Vh
VSh8kFxTg5ehy2pgFzjf+4CUbjyg2THqF5uern/omor7BsdcccgXQxcu8In0UtWa
LhRY1T1TeEQOXSnSDJUcXSr5paznZEZ6nt0UleDvoQxphQ0UuyJKxOOhkxDdYOJI
LCEzchmHzsWW1lj/DGNCrSIKJsJ29bSX/BrrtqqJonTbR2Wyhf6V17behiqJJvqV
+mWFDgo4iF9LNqYJ377n
=NHsJ
-----END PGP SIGNATURE-----

--UJNc4luPBjkKhjtEhfIh1jvrTTtsENfJ4--
