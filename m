Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3JAUvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:51:16 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:60058 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3JAUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:51:13 -0400
Date: Tue, 1 Oct 2013 22:49:26 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] pwm-backlight: Use new enable_gpio field
Message-ID: <20131001204925.GC9201@ulmo.nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
 <1379972467-11243-9-git-send-email-treding@nvidia.com>
 <524B16E8.5080506@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
Content-Disposition: inline
In-Reply-To: <524B16E8.5080506@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 01, 2013 at 12:39:36PM -0600, Stephen Warren wrote:
> On 09/23/2013 03:41 PM, Thierry Reding wrote:
> > Make use of the new enable_gpio field and allow it to be set from DT as
> > well. Now that all legacy users of platform data have been converted to
> > initialize this field to an invalid value, it is safe to use the field
> > from the driver.
>=20
> > diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-back=
light.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight=
=2Etxt
>=20
> >  Optional properties:
>=20
> > +  - enable-gpios: a list of GPIOs to enable and disable the backlight
>=20
> That seems to imply that multiple GPIOs are legal. Was that intended? If
> not, I would suggest:
>=20
> - enable-gpios: contains a single GPIO specifier for the GPIO which
> 		enables/disables the backlight. See [1] for the format.
>=20
> > =20
> >  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
> + [1]: Documentation/devicetree/bindings/gpio/gpio.txt

Yes, that sounds better. Indeed only a single GPIO is supported. Adding
more than one would require representing the timing between the two and
that will take us back to where we left off with the power sequences.

> > diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight=
/pwm_bl.c
>=20
> > @@ -51,12 +55,27 @@ static void pwm_backlight_power_on(struct pwm_bl_da=
ta *pb, int brightness,
> >  		     pb->lth_brightness;
> > =20
> >  	pwm_config(pb->pwm, duty_cycle, pb->period);
> > +
> > +	if (gpio_is_valid(pb->enable_gpio)) {
> > +		if (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW)
> > +			gpio_set_value(pb->enable_gpio, 0);
> > +		else
> > +			gpio_set_value(pb->enable_gpio, 1);
> > +	}
>=20
> Feel completely free to ignore this, but when the difference in two
> code-paths is solely in function parameters, I prefer to calculate the
> parameter inside the if statement, then call the function outside the
> conditional code, to highlight the common/different parts:
>=20
> int value;
>=20
> /* or an if statement for the next 1 line, if you don't like ?: */
> value =3D (pb->enable_gpio_flags & PWM_BACKLIGHT_GPIO_ACTIVE_LOW) ? 0 : 1;
> gpio_set_value((pb->enable_gpio, value);

I actually tried that, but it looked cluttered, so I opted for the
alternative. Not that this matters all that much, because beginning with
3.13 the GPIO subsystem should be able to handle the active low flag
internally using the new gpiod_*() API. I plan on converting the driver
to use that during the next cycle.

> > @@ -148,11 +168,10 @@ static int pwm_backlight_parse_dt(struct device *=
dev,
>=20
> > +	data->enable_gpio =3D of_get_named_gpio_flags(node, "enable-gpios", 0,
> > +						    &flags);
> > +	if (gpio_is_valid(data->enable_gpio) && (flags & OF_GPIO_ACTIVE_LOW))
> > +		data->enable_gpio_flags |=3D PWM_BACKLIGHT_GPIO_ACTIVE_LOW;
>=20
> This doesn't seem to handle deferred probe correctly; I would expect
> something more like:
>=20
> 	data->enable_gpio =3D of_get_named_gpio_flags(...);
> 	if (data->enable_gpio =3D=3D -EPROBE_DEFERRED)
> 		return data->enable_gpio;
> 	if (gpio_is_valid(...))
> 		...
> 	return 0;
>=20
> I suppose it's possible that the value filters down to
> gpio_request_one() and this actually does work out OK, but that feels
> very accidental/implicit to me.

Yes, I think it does indeed propagate to gpio_request_one(), but you're
right, it should be caught explicitly.

Thierry

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSzVVAAoJEN0jrNd/PrOhNh0P/iIzsxuvFEo9B4ZEhLN7DYDh
vX/9LIfVXFZIwrx8ID8HDPG2LbSnZ+Z4pxVvPdYS99Buci2Qb9q8CtoZW02E7SZd
7cW++UrdnDShub81afs3M+39IwLfqdAIGjmlbCx19fVEeoZbm53K/bOQkNRGNPke
N4akydvbuzA71RBIQd2oadwPezmVCo9RuVr1S299VgSp8zYPOGpmpqc9UWpxMnay
xj20eCy+WHCslBs7AL6rI+lYtQT0sK1XrxuwnjXAsXD5XBRe7PRD+Qy36hJL/KzZ
OuXeoZMOyE0wG/fDSTQpqn/lvYXvi0wSrf8SLhkU9gHFPHQ28pn91/vf4ow5oeW/
oYdUNb28xJTDbzsUaemy0SzENRLNK2ri/b70pWNLs/hrQ3fIwenaQI/6rOvdQ1P8
fGTrRB69fbQGpiUSTh5zWSpNmovhdU9SG98wQvGFswQ9CPYE/uCnofet106dDSQc
81pho5bZWVuQ9LCITP03b9w6s4DrzEiFBcC6BKXUE19w+Z0/i3GAbTGkkztSyrCu
y+0YSkXqvwmdComtBV5oIgkSI48+NAyYcpE7SaWdwI+arkru/c1aTvsfNvQyqsXA
FWZuwO+oe3ArV32vM59i58gJwpkeJ1Hw1ZJeYelIWsFUBRQmNS7tSRRflCDB0uyw
6UFVAxfserLZmKPQi2Vl
=4zYP
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
