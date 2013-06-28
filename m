Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3F1VUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:20:24 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:34105 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3F1VUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:20:22 -0400
Date: Fri, 28 Jun 2013 23:20:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        kevin@allwinnertech.com
Subject: Re: [PATCHv2 4/8] clocksource: sun4i: Fix the next event code
Message-ID: <20130628212019.GC2756@lukather>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372449386-1334-5-git-send-email-maxime.ripard@free-electrons.com>
 <alpine.DEB.2.02.1306282204220.4013@ionos.tec.linutronix.de>
 <7300725.devmrYGi4t@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <7300725.devmrYGi4t@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 10:35:29PM +0200, Tomasz Figa wrote:
> On Friday 28 of June 2013 22:13:08 Thomas Gleixner wrote:
> > On Fri, 28 Jun 2013, Maxime Ripard wrote:
> > > The next_event logic was setting the next interval to fire in the
> > > current timer value instead of the interval value register, which is
> > > obviously wrong.
> >=20
> > Ok.
> >=20
> > > Plus the logic to set the actual value was wrong as well, so this
> > > code has always been broken.
> >=20
> > This lacks an explanation why the logic is wrong and what the actual
> > fix is.
> >=20
> > > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > ---
> > >=20
> > >  drivers/clocksource/sun4i_timer.c | 12 +++++++++---
> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/drivers/clocksource/sun4i_timer.c
> > > b/drivers/clocksource/sun4i_timer.c index 84ace76..695c8c8 100644
> > > --- a/drivers/clocksource/sun4i_timer.c
> > > +++ b/drivers/clocksource/sun4i_timer.c
> > > @@ -16,6 +16,7 @@
> > >=20
> > >  #include <linux/clk.h>
> > >  #include <linux/clockchips.h>
> > >=20
> > > +#include <linux/delay.h>
> > >=20
> > >  #include <linux/interrupt.h>
> > >  #include <linux/irq.h>
> > >  #include <linux/irqreturn.h>
> > >=20
> > > @@ -61,9 +62,14 @@ static void sun4i_clkevt_mode(enum clock_event_mode
> > > mode,>=20
> > >  static int sun4i_clkevt_next_event(unsigned long evt,
> > > =20
> > >  				   struct clock_event_device *unused)
> > > =20
> > >  {
> > >=20
> > > -	u32 u =3D readl(timer_base + TIMER_CTL_REG(0));
> > > -	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
> > > -	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
> > > +	u32 val =3D readl(timer_base + TIMER_CTL_REG(0));
> > > +	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
> > > +	udelay(1);
> >=20
> > That udelay() is more than suspicious.
>=20
> Not only it is suspicious, but also delays the event by 1 microsecond. No=
t=20
> much, given usual usage of clock events, but still.
>=20
> From what I understand from this code, you keep this timer running and=20
> just stop it to set new event. Can you simply disable autoreload and just=
=20
> program this timer to start counting from evt down to 0 when it generates=
=20
> interrupt and just stops itself?

Something like that, but not completely, because the timer actually
stops.

To reprogram a new interval to a running timer, you have to:
  - Disable it
  - Program the new interval
  - Propagates the new interval and start the timer by setting the bits
    ENABLE and (AUTO)RELOAD (AUTORELOAD is probably a bad name here
    actually). That is, wether or not it's a oneshot or periodic timer.

Now, between the time you disable the timer and enable it back, you have
to wait at least 2 timer clock source cycles (which is around 85ns).

It's the ONESHOT (BIT(7)) that actually controls wether or not the timer
is periodic.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzf4TAAoJEBx+YmzsjxAgEXsP/ipgR0ILSkO5eGbSlwJvbDpX
IvXHJGHPbx9Tg/y+XDRfTNHWTUoSc7TJHjxBnUhNDKDr8D4DVe1mY1rtttpRGy5x
Bfqf4UdnCdzQfpMgvHoFjMwKaXdPu1eUBgxVoATuSaoiTHOHAomMMbyB/u5BIg/3
kD64NJMcguYUXPN9FzBDBEv6R3NT0K2B3VOmrjaiC+4fPMJVNfa9n4K5s35APX6p
yv94QPhAvgVcjhIJ8OMFweQtFDNIJNj4xlydruCa/qZGALXEF9Cw3E12fPl1i9Mx
EiJ4kGHHLx+ULBYcsbuhmMeYmqXumM73jUKkEWKERl84wpy03lYJ5r1CursJgbJ/
nXkZqZLub61fmGipvAxD2dYVjCDEcpqOGUKGhDnpE57G5twhnlALTy8cYwTheLXe
8Atf7Zf36+F8sUx1ul29TrjRCI6gMCaIaWtjfx6yGCVfT9J9lwXEgJIzZ+kpSdfB
aqaVtQ/pbwEIpU50uh0EUifZij39BEScJRWKdBKvB4KnF+7GvbDIqdEU1DaPjsIx
thd9EbU4qrBeimymPScuOMTOwKkn1Ks7DvqQ7mfit26x2LXCio943AmFo3otHssq
DGCObFI1dFGDcXtSbGVglHLVuI7+f3pKiozSoxqnXJv7JU2UZaEzHFgeY300dqRp
4YjFzs4v+o6y5E5Q/mx5
=16Xw
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
