Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaAUTnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:43:45 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:53575 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaAUTnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:43:43 -0500
Date: Tue, 21 Jan 2014 20:43:39 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chew Kean Ho <kean.ho.chew@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: Re: [PATCH] pwm: add support for Intel Low Power Subsystem PWM
Message-ID: <20140121194338.GA12085@ulmo.nvidia.com>
References: <1390240808-18582-1-git-send-email-chiau.ee.chew@intel.com>
 <20140120132814.212929bd@alan.etchedpixels.co.uk>
 <20140121085236.GI18029@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20140121085236.GI18029@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 10:52:36AM +0200, Mika Westerberg wrote:
> On Mon, Jan 20, 2014 at 01:28:14PM +0000, One Thousand Gnomes wrote:
> > > +static int pwm_lpss_config(struct pwm_chip *chip, struct pwm_device =
*pwm,
> > > +	int duty_ns, int period_ns)
> > > +{
> > > +	struct pwm_lpss_chip *lpwm =3D to_lpwm(chip);
> > > +	u8 on_time_div;
> > > +	unsigned long c =3D clk_get_rate(lpwm->clk);
> > > +	unsigned long long base_unit, hz =3D 1000000000UL;
> > > +	u32 ctrl;
> > > +
> > > +	do_div(hz, period_ns);
> > > +
> > > +	/* The equation is: base_unit =3D ((hz / c) * 65536) + correction */
> > > +	base_unit =3D hz * 65536;
> > > +	do_div(base_unit, c);
> > > +	base_unit +=3D PWM_DIVISION_CORRECTION;
> > > +	if (base_unit > PWM_LIMIT)
> > > +		return -EINVAL;
> > > +
> > > +	if (duty_ns <=3D 0)
> > > +		duty_ns =3D 1;
> > > +	on_time_div =3D 255 - (255 * duty_ns / period_ns);
> > > +
> > > +	ctrl =3D readl(lpwm->regs + PWM);
> > > +	ctrl &=3D ~(PWM_BASE_UNIT_MASK | PWM_ON_TIME_DIV_MASK);
> > > +	ctrl |=3D (u16) base_unit << PWM_BASE_UNIT_SHIFT;
> > > +	ctrl |=3D on_time_div;
> > > +	/* request PWM to update on next cycle */
> > > +	ctrl |=3D PWM_SW_UPDATE;
> > > +	writel(ctrl, lpwm->regs + PWM);
> > > +
> >=20
> > Who handles the locking on all these functions. The pwm layer doesn't b=
ut
> > simnply exports stuff like pwm_config() directly to other bits of the
> > kernel so you are not guaranteed to be called via sysfs.
> >=20
> > (This btw looks to be a problem with a pile of the other pwm drivers, a=
nd
> > with the pwm core code which doesn't properly lock its own handling of
> > pwm->duty_cycle and pwm->period in pwm_config(), nor pwm->polarity in
> > pwm_set_polarity).
>=20
> Good point. I checked few PWM drivers as well and none of them (including
> this one) does any locking around ->config().
>=20
> > I think the core config methods need some kind of locking ?
>=20
> Thierry, any comments on this?

The idea behind this is that only a single user can have access to a
given PWM device at a time. The PWM device's PWMF_REQUESTED flag is set
(and cleared) under the pwm_lock and any subsequent users will not be
able to use that specific device (pwm_request() return -EBUSY).

There is obviously an assumption here that each user knows what they are
doing and aren't calling any of the public pwm_*() functions
concurrently. I haven't come across a situation where this is actually a
problem because typically these functions are called either via sysfs or
some other higher-level where synchronization is already properly
handled.

So the only thing that drivers should be taking care of is synchronizing
access to registers common to multiple PWM devices.

Does that clarify things?

Thierry

--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3s3qAAoJEN0jrNd/PrOharQP/3n4K56FUjsUYZUSw1XnZGXu
5ar+edYofrSAbXJqqUhONddVOCqJBPWZ8fil6MesM9URKBdygczZSViPuj9KrMvn
kOh+8swpN7uMmBnDvfawYlp4bh/rCszYK+X1JuXWNZgqN+EqWycRrLgLi/LUwEUv
R0izF8UVQawuxtAN8pPHk8L289yV/qBUZsWCwxTEiR81+OYuBNtNzkOeWKzOlmkM
dFRSr7LjFRahj1z9lCEdM4r7SQqB6fP9181uKa2okzXKaqtBaWBMCulGRzMuKKe+
u6VtSwiJfultWWkvAPgjmljYdiVc2uQHH+TS6gx/95T/2A4d02UhY52RwhGNK+vS
RxTAHnyvSx+uJhidn+cVlZNxUBaZvQcZ5dBqp9+/Nyjwim6/RmGSOwlvkQkkDFMJ
XvcMT1W0o+QkVkfIRVQDcjVaFCwkQXLbxvWiRkxZbb6GTbajuRRNRp7E6B3f1sjb
lwfGaITNthYbwylGL01RW9wAx4NZknkX9fgloS6sxRwz+Q5uyAfI5cYUkqt+xyBW
M2cPKfZYtHt6LNIcKPY8gGyYNz0hauZHm2gzCqqpmbw2+um4UPAPQob8goriwrsE
JXeVmNULZeb4o1hJf4e+N74tpkVO9aYgX9ijERJHy+kT0fvHK2ytSR5UzNHjDe4B
KPNf7nooLY8qIqY1ELaO
=c/y3
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
