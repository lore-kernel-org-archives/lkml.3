Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3F0Jb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:31:29 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54033 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3F0Jb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:31:27 -0400
Date: Thu, 27 Jun 2013 11:31:25 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/8] clocksource: sun4i: Add clocksource and sched clock
 drivers
Message-ID: <20130627093125.GA8437@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
 <51CB5CC7.7000308@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <51CB5CC7.7000308@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Wed, Jun 26, 2013 at 11:27:35PM +0200, Daniel Lezcano wrote:
> On 06/26/2013 11:16 PM, Maxime Ripard wrote:
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
> > +	writel(reg | TIMER_CNT64_CTL_RL, timer_base + TIMER_CNT64_CTL_REG);
> > +	while (readl(timer_base + TIMER_CNT64_CTL_REG) & TIMER_CNT64_CTL_REG);
>=20
> Isn't a cpu_relax missing here ?

Right.

The AND is wrong as well, it should be TIMER_CNT64_CTL_RL, not the reg
offset.

> > =20
> > +	writel(TIMER_CNT64_CTL_CLR, timer_base + TIMER_CNT64_CTL_REG);
> > +	setup_sched_clock(sun4i_timer_sched_read, 32, clk_get_rate(clk));
> > +	clocksource_mmio_init(timer_base + TIMER_CNT64_LOW_REG, node->name,
> > +			      clk_get_rate(clk), 300, 32,
> > +			      sun4i_timer_clksrc_read);
> > +
> >  	writel(rate / (TIMER_SCAL * HZ),
>=20
> DIV_ROUND_CLOSEST(rate, (TIMER_SCAL * HZ)), ?

It's actually fixed in a later patch, but yes.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzAZtAAoJEBx+YmzsjxAgCaEP/izskmjm3Bm2oOiby9zfhAZZ
sfqQoGt9uX+2fPVCgV8iRYBu8N464t7bKQClI2CRiGh+65t7ucBiQBecnr/pFrWP
WQMzUGe4gVWiJX5s2spIMp5RatOLaXWAihM3XkWwpMqMo7bdmez/Hfumjqz6lQav
8olS44TebSVTBn61CBHrlHW15YoxmLgH4WiXe1YMpPBpyyyo3S9y0pfETm9et+se
xzr+eLk4AGc+l6xkknGcNbM21A2v733RWDAMiKiyFcyrbTfItXPgZMW3uVn2f7YZ
U13uiJZ83qkLFLhpgxLH1olpF+H/BuIf8TsSV+ENI/3hRePcFZ3oLre3KZg5ebpf
W0r8oMlIsdDYlMKpA18iC5cGn/jmv9a/p65qQ2g/vpRuRnmnLBuNlGU8HfDUQAWl
zqPfQiVX/CeUXCaXXjybjGIROPdfYmNYFZOUwN/bmEDmn0VqVURfKRH2As6+f3bZ
MGd5b0LupND5voT6IrR1RUjC/IFYaACA594VaZL9XvS/lsTyShTlB5o/XwNSoqE9
csFieCKZWUHwx8fQXNGXrtIcd1uoighY8RMYTHdtbYqGQh/5FtNbK04O+uu4y0hw
AZmumS2SEiVluIk3ZZpwiw7HEXA1pWfvn6UGQfrPBt+k16fnUd8uQzrDKbd2OftL
ag5wowcWSZX5301Zdk8j
=b80L
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
