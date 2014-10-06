Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaJFM3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:29:04 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40209 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaJFM3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:29:00 -0400
Date: Mon, 6 Oct 2014 14:28:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 03/11] pwm: add support for atmel-hlcdc-pwm device
Message-ID: <20141006122856.GB26833@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-4-git-send-email-boris.brezillon@free-electrons.com>
 <20141006104634.GE25202@ulmo>
 <20141006135009.6cd980a1@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <20141006135009.6cd980a1@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 06, 2014 at 01:50:09PM +0200, Boris Brezillon wrote:
> On Mon, 6 Oct 2014 12:46:35 +0200 Thierry Reding <thierry.reding@gmail.co=
m> wrote:
> > On Wed, Oct 01, 2014 at 04:53:00PM +0200, Boris Brezillon wrote:
[...]
> > > +	if (pres > ATMEL_HLCDC_PWMPS_MAX)
> > > +		return -EINVAL;
> >=20
> > I think the condition above needs to be "pres =3D=3D ATMEL_HLCDC_PWMPS_=
MAX",
> > otherwise this will never be true.
>=20
> Actually the previous loop is:
>=20
> 	for (pres =3D 0; pres *<=3D* ATMEL_HLCDC_PWMPS_MAX; pres++)
>=20
> thus pres will be equal to ATMEL_HLCDC_PWMPS_MAX + 1 when no
> appropriate prescaler is found.

Indeed so.

> > > +		regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(0),
> > > +				   ATMEL_HLCDC_CLKPWMSEL, gencfg);
> > > +	}
> > > +
> > > +	do_div(pwmcval, period_ns);
> > > +	if (pwmcval > 255)
> >=20
> > The PWM core already makes sure that duty_ns <=3D period_ns, so pwmcval
> > could be anywhere between 0 and 256 here. Where does the disconnect come
> > from? Why not make pwmcval =3D duty_ns * 255 if that's the maximum?
>=20
> Here is what the datasheet says:
>=20
> "Due to the comparison mechanism, the output pulse has a width between
> zero and 255 PWM counter cycles. Thus by adding a simple passive filter
> outside the chip, an analog voltage between 0 and (255/256) =C3=97 VDD can
> be obtained (for the positive polarity case, or between (1/256) =C3=97 VDD
> and VDD for the negative polarity case). Other voltage values can be
> obtained by adding active external circuitry."
>=20
> Given this explanation we should divide by 256, but 256/256 is a
> forbidden value, hence I just use the maximum available one (255) when
> I'm asked to configure a duty cycle occupying the whole period.

Okay, perhaps you can summarize the above explanation from the datasheet
in a comment to clarify.

> > > +		pwmcval =3D 255;
> > > +
> > > +	pwmcfg |=3D ATMEL_HLCDC_PWMCVAL(pwmcval);
> > > +
> > > +	regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(6),
> > > +			   ATMEL_HLCDC_PWMCVAL_MASK | ATMEL_HLCDC_PWMPS_MASK,
> > > +			   pwmcfg);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int atmel_hlcdc_pwm_set_polarity(struct pwm_chip *c,
> > > +					struct pwm_device *pwm,
> > > +					enum pwm_polarity polarity)
> > > +{
> > > +	struct atmel_hlcdc_pwm_chip *chip =3D
> > > +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> > > +	struct atmel_hlcdc *hlcdc =3D chip->hlcdc;
> > > +	u32 cfg =3D 0;
> > > +
> > > +	if (polarity =3D=3D PWM_POLARITY_NORMAL)
> > > +		cfg =3D ATMEL_HLCDC_PWMPOL;
> >=20
> > That's strange. Inverse polarity is the default on this hardware?
>=20
> Quote from the datasheet:
>=20
> "
> =E2=80=A2 PWMPOL: LCD Controller PWM Signal Polarity
> This bit defines the polarity of the PWM output signal. If set to one,
> the output pulses are high level (the output will be high when- ever
> the value in the counter is less than the value CVAL) If set to zero,
> the output pulses are low level.
> "
>=20
> My understanding is that ATMEL_HLCDC_PWMPOL should be set when using
> normal polarity (and my tests confirm that it works as expected ;-)).

Yes, sounds good then.

Thierry

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMosIAAoJEN0jrNd/PrOhipMQALRQNSCSyeBPiLC0t4MxuVqd
QCZFte0SHv0+ubzwx9NgF4VIG/3TmMB5zfqITh+38j/mIzaP/iLrEG6A++nwLUja
qfEGWmHpQJWYLZV/XTkhpFY2R7xiyVtKEJ5X2/ijneBnqPvRgTYH7dixBpgnk0iy
aHTXAFwKTxvSpz+hgk2HfQU+XKy92qwYJAdwq/xpoM1K4D0D4Q+mJqzzrhyMpk3u
8j7aLNfnRlM7vDclxRPuIWqczcIpRsxFlBMMNPtB2X1heoAE+yHhysMHrgYDAaLq
QLjKdWDpC3EOms9s5he6j0r0Yhr7lmG0W+qUPeurs5F1I1TyApBl9hVGZFDBrMkm
mkG/bambm3JVoQCFZ8gQ4dbPxUepvSTDpq94pELNkX5BAsaYJE7Qsl2nUXf3sSrF
dVKYDEOIYMHBumDCG0NjqC7pRYvB2XAD0KwcaSsaGOMZrGmR7rG+ataA+7zkASmN
vuRmP8IMq2Gw//Ty+tFeIiTlDylEqX6LpwliAoGJxSFZ0FJloVK1ObuXJ+9DoqkH
JCh5MP8UkbiYE/aa0Q/u/ce900YUHN5UPOh/gaENFsbZPmnC+Qcwtv5BQqfGCQOQ
eOVLFH+eFVXN2eu69sGETaVPu0M63DJrWeP7ilM8v+rKz337bLHVPrOH5WMdpjGz
xnwlNW8O+FZBWlYYSpL4
=fOLP
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
