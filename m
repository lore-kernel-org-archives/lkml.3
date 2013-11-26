Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3KZJp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:45:59 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:50132 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3KZJpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:45:51 -0500
Date: Tue, 26 Nov 2013 10:45:06 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches List <patches@linaro.org>
Subject: Re: [PATCH 2/5] pwm: kona: Introduce Kona PWM controller support
Message-ID: <20131126094505.GC27752@ulmo.nvidia.com>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
 <1384800901-21711-3-git-send-email-tim.kryger@linaro.org>
 <20131125110854.GI22043@ulmo.nvidia.com>
 <CAAYSxhr7=Pa8RdnEsD2MGTR4hvfHCcHQCP77GRjx1Fqb-=kRrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
Content-Disposition: inline
In-Reply-To: <CAAYSxhr7=Pa8RdnEsD2MGTR4hvfHCcHQCP77GRjx1Fqb-=kRrA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 05:38:44PM -0800, Tim Kryger wrote:
> On Mon, Nov 25, 2013 at 3:08 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Mon, Nov 18, 2013 at 10:54:58AM -0800, Tim Kryger wrote:
> > [...]
> >> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
[...]
> >> +#define PWM_CONTROL_INITIAL          (0x3f3f3f00)
> >
> > Can this not be expressed as a bitmask of values for the individual
> > fields.
> >
> >> +#define PWMOUT_POLARITY(chan)                (0x1 << (8 + chan))
> >
> > This seems to only account for bits 8-13, what about the others?
> >
> >> +#define PWMOUT_ENABLE(chan)          (0x1 << chan)
> >
> > Well, this accounts for bits 0-5, that still leaves 16-21 and 24-29.
>=20
> 29:24 - Configures each PWM channel for smooth transitions or glitches
> 21:16 - Configures each PWM channel for push/pull or open drain output

Excellent, now if you can turn that into bit definitions and define
PWM_CONTROL_INITIAL in terms of those, then I'll be very happy.

One other thing I didn't pay attention to before: while it's quite
unlikely ever to happen, you might want to spend an extra pair of
parentheses around "chan", just in case.

> >> +#define PRESCALE_OFFSET                      (0x00000004)
> >> +#define PRESCALE_SHIFT(chan)         (chan << 2)
> >
> > I'm confused. This allocates 2 bits for each channel...
> >
> >> +#define PRESCALE_MASK(chan)          (~(0x7 << (chan << 2)))
> >> +#define PRESCALE_MIN                 (0x00000000)
> >> +#define PRESCALE_MAX                 (0x00000007)
> >
> > ... but 0x7 requires at least 3 bits.
>=20
> Actually this is allocating 2^2 bits for each channel.

Doh! Indeed. Perhaps writing it as (~(0x7 << (chan * 4))) would make it
easier to digest for slow-witted people like myself.

> >> +#define PERIOD_COUNT_OFFSET(chan)    (0x00000008 + (chan << 3))
> >> +#define PERIOD_COUNT_MIN             (0x00000002)
> >> +#define PERIOD_COUNT_MAX             (0x00ffffff)
> >
> > Why PERIOD_COUNT? PERIOD is descriptive enough. Or is this the name as
> > found in the manual?
>=20
> I agree but as you suspected this name comes from the hardware docs.

Okay, that's fine then. Do you have a pointer to that documentation?

> >> +static int kona_pwmc_enable(struct pwm_chip *chip, struct pwm_device =
*pwm)
> >> +{
> >> +     return kona_pwmc_config(chip, pwm, pwm->duty_cycle, pwm->period);
> >> +}
> >
> > Why can't this just enable the channel? Why go through all the trouble
> > of running the whole computations again?
>=20
> The hardware is always enabled and at best can be be configured to
> operate at zero duty.

What good are the PWMOUT_ENABLE bits then? Is that really only used for
triggering updates? That's what another comment suggests, but if so, can
the comment in kona_pwmc_apply_settings() be extended to mention that?

> The settings in HW may have already been triggered and might not be
> what you want.
>=20
> For example:
>=20
> /sys/class/pwm/pwmchip0/pwm1# echo 1 > enable
> /sys/class/pwm/pwmchip0/pwm1# echo 5000 > period
> /sys/class/pwm/pwmchip0/pwm1# echo 2000 > duty_cycle
> /sys/class/pwm/pwmchip0/pwm1# echo 0 > enable
> /sys/class/pwm/pwmchip0/pwm1# echo 1 > enable

I'm not exactly sure what this is supposed to demonstrate.

> >> +
> >> +     writel(0, kp->base + DUTY_CYCLE_HIGH_OFFSET(chan));
> >> +     kona_pwmc_apply_settings(kp, chan);
> >> +}
> >> +
> >> +static const struct pwm_ops kona_pwm_ops =3D {
> >> +     .config =3D kona_pwmc_config,
> >> +     .owner =3D THIS_MODULE,
> >> +     .enable =3D kona_pwmc_enable,
> >> +     .disable =3D kona_pwmc_disable,
> >> +};
> >
> > Please move the .owner field to be the last field. Also you did define
> > the PWMOUT_POLARITY field, which indicates that the hardware supports
> > changing the signal's polarity, yet you don't implement the polarity
> > feature. Why not?
>=20
> I wanted to keep this driver simple for now.

Fair enough.

> > Do you really want the clock enabled all the time? Why not just
> > clk_enable() whenever a PWM is enabled? If you need the clock for
> > register access, you can also bracket register accesses with
> > clk_enable() and clk_disable(). Perhaps the power savings aren't worth
> > the added effort, so if you'd rather not do that, I'm fine with it, too.
>=20
> I intend to follow up with a patch to do exactly that but I want to
> establish the baseline functionality first.

Okay, that's fine.

> >> +MODULE_AUTHOR("Broadcom");
> >
> > I don't think Broadcom qualifies as author. This should be the name of
> > whoever wrote the code. There are a few drivers that contain the company
> > name in the MODULE_AUTHOR, but I don't think those are correct either.
>=20
> Would you be fine with two lines here?  Something like:
>=20
> MODULE_AUTHOR("Broadcom Corporation <bcm-kernel-feedback-list@broadcom.co=
m>");
> MODULE_AUTHOR("Tim Kryger <tkryger@broadcom.com>");

Not sure. That email address certainly doesn't look like it belongs to
the driver author. Neither did Broadcom actually write the driver, you
did, right? If you're concerned about your employer not being credited
you're listed with an @broadcom.com email address and there's the
copyright statement.

All of that said, I wasn't able to dig up a normative policy and either
of your proposed alternatives do exist in the kernel, so I withdraw any
objections regarding MODULE_AUTHOR. Take your pick.

Thierry

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlG2hAAoJEN0jrNd/PrOh6ogP/jjxSKLBGXycQEuVd8QRh6B6
tit2cjmsOvYjOkTFgfAXbQNaeH6XfUEYmbQ/wKcZ+Yo9hiMpEdYm7JGVdywG7k4F
ND1DxJ8uzYeBI3wRyKz+0Qpc8RujJdRBHR0/ft3m2aWfZBqFsTdhhiP7F54PVsZz
uDQT6tnNB1kvCzVEYWq15JriE+dehncnWaTzB41jDdQFoNpTfHlL2mxdP4LeUVLJ
H/tN1HI1T7UIKkGxcv3H4HXwX2PjvLRpp/W4e39/WAtOy4cvdRni62MJZFZXc5Af
7/4+4qF7Qh81JMF+vxCEbZWmup6icmIPo9xewK5ZwyWGIqH0JJVxeD6IWhZ6I+S6
INLhGURCd+omuXGuG8kDpsX4gn+rLcP6HhnN54ItPntiOhP+c+zKuDxuPGv8hpnU
NnIQGBYlyZlcgJTUcJ1817i2zl6hO6xb/E6hiY7ADszbsjNWZXSzx0/MPs0lIsrG
1BJ5K2yXPbKwlv50xSYTUO4RnRYWuQQDNfhmrnAMQENUKR8P8q1lwTC5TBFhnyG8
uQyVbntGmUIBJrpWvyijxk+0n0rq3G5q2sdqpgRWsxjcuhXOk0clFeBkZsYGOUJN
W397HbusUy+K553ZVZDREpAx4bfWBZVc6IbkIwyguBQIQlMRBSjI19eD3DWZe/Lv
enZv/zDz4k3F+9M/hnlh
=cDGi
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
