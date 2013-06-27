Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3F0RCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:02:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56075 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3F0RCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:02:30 -0400
Date: Thu, 27 Jun 2013 19:02:28 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Siarhei Siamashka <siarhei.siamashka@gmail.com>
Cc: linux-sunxi@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 2/8] clocksource: sun4i: Add clocksource
 and sched clock drivers
Message-ID: <20130627170228.GC4319@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
 <20130627131729.5fff8468@i7>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline
In-Reply-To: <20130627131729.5fff8468@i7>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Siarhei,

On Thu, Jun 27, 2013 at 01:17:29PM +0300, Siarhei Siamashka wrote:
> On Wed, 26 Jun 2013 23:16:55 +0200
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote:
>=20
> > The A10 and the A13 has a 64 bits free running counter that we can use
> > as a clocksource and a sched clock, that were both not used yet on these
> > platforms.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/clocksource/sun4i_timer.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >=20
> > diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/su=
n4i_timer.c
> > index bdf34d9..1d2eaa0 100644
> > --- a/drivers/clocksource/sun4i_timer.c
> > +++ b/drivers/clocksource/sun4i_timer.c
> > @@ -23,6 +23,8 @@
> >  #include <linux/of_address.h>
> >  #include <linux/of_irq.h>
> > =20
> > +#include <asm/sched_clock.h>
> > +
> >  #define TIMER_IRQ_EN_REG	0x00
> >  #define TIMER_IRQ_EN(val)		BIT(val)
> >  #define TIMER_IRQ_ST_REG	0x04
> > @@ -34,6 +36,11 @@
> >  #define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
> > =20
> >  #define TIMER_SCAL		16
> > +#define TIMER_CNT64_CTL_REG	0xa0
> > +#define TIMER_CNT64_CTL_CLR		BIT(0)
> > +#define TIMER_CNT64_CTL_RL		BIT(1)
> > +#define TIMER_CNT64_LOW_REG	0xa4
> > +#define TIMER_CNT64_HIGH_REG	0xa8
> > =20
> >  static void __iomem *timer_base;
> > =20
> > @@ -96,6 +103,20 @@ static struct irqaction sun4i_timer_irq =3D {
> >  	.dev_id =3D &sun4i_clockevent,
> >  };
> > =20
> > +static u32 sun4i_timer_sched_read(void)
> > +{
> > +	u32 reg =3D readl(timer_base + TIMER_CNT64_CTL_REG);
>=20
> If we can be absolutely sure that nothing else may ever change
> the TIMER_CNT64_CTL_REG, then its default value can be probably
> cached instead of doing expensive read from the hardware register
> each time?

Since it's a free-running counter, its value will always change, so the
caching will bring no additions at all, right?

> The gettimeofday() abusers will feel a bit less pain. ARM does not
> currently enjoy the VDSO optimized gettimeofday, so the software
> which has been only tested on x86 may get a nasty surprise (an order
> of magnitude higher gettimeofday overhead).
>=20
> > +	writel(reg | TIMER_CNT64_CTL_RL, timer_base + TIMER_CNT64_CTL_REG);
> > +	while (readl(timer_base + TIMER_CNT64_CTL_REG) & TIMER_CNT64_CTL_REG);
>=20
> Some may think that this particular loop looks like a performance
> bottleneck, but it is very rarely run for more than one iteration.
> In fact, most of the time it just happens to be a single HW register
> read.

Thanks for your insight on this.

It does make me more eager to merge the simpler approach first, and then
try to take some shortcuts if needed and safe enough.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzHAkAAoJEBx+YmzsjxAgF6sP/2djeS2A8DKV+TenVPsgQaRV
3mZQtP6HMwL51E9CM08+0tXty5mOI156idzpCnqZe/df1Gq8pEbVE2vkmQJ+lPxq
KovaeALxl1fViVKK3y90qdrNdUPVkjoEMyg6XC2uAaj4i/t9RNIgUsEcL5Dku0l1
K+9SiG3E1+gGJEKYdc2YCi7P8UH1BoV74ZCgA/88svCkNVuRmDisEulA97pTZ5mO
oDDLt0zEoI4LGY7ASV0yK/xyENNuGbN7n0GVvRfzw22sI/Q4sI2ZuWfVa9FDCIaN
LqPzRZu6Q7Hm20DhfAG6j24AxMkBqdxHfKFxnO/yfjbcllR2WN+k8jSylYWcO42K
m8C2qXG+GMmyLf3eAF1uvfsAUmj+/UEZOP4TuCRpo0v5/SXigpWxQXbBi4wt+jyr
w3C0MADGj5K5yaFm1WkipcXNNIUdd/UrP6e1WlsBIlSk+NJNad59C6pEvXmI2cEO
+6YZXvPNunPoDGIkB+lIm45L8I7c3vpi/OiaSS14EimIe4xwfR7yeZG2XjpuubK6
vrMv0+x2KE9HbgvsBOuEwEM3vpeqzDe/Z0kEdUb11Sroq/PAiiDaL/TTV2M5VLjS
STqN8pNcoiFJFGJr6PbAxyi9O2oqV1YGVBepD0ULTccGBtvHyiBgMl0xRNtAl8mD
hZuyxDtwZnzUoU10kW7i
=dK05
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
