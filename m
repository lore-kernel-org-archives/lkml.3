Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3F1VI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:08:56 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:34076 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3F1VIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:08:55 -0400
Date: Fri, 28 Jun 2013 23:08:53 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Emilio Lopez <emilio@elopez.com.ar>,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCHv2 4/8] clocksource: sun4i: Fix the next event code
Message-ID: <20130628210853.GB2756@lukather>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372449386-1334-5-git-send-email-maxime.ripard@free-electrons.com>
 <alpine.DEB.2.02.1306282204220.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306282204220.4013@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Fri, Jun 28, 2013 at 10:13:08PM +0200, Thomas Gleixner wrote:
> On Fri, 28 Jun 2013, Maxime Ripard wrote:
>=20
> > The next_event logic was setting the next interval to fire in the
> > current timer value instead of the interval value register, which is
> > obviously wrong.
>=20
> Ok.
>=20
> > Plus the logic to set the actual value was wrong as well, so this
> > code has always been broken.
>=20
> This lacks an explanation why the logic is wrong and what the actual
> fix is.

Right.

Actually, the interval register can only be modified when the timer is
disabled. So we first need, to disable it, change the interval, and then
enable it back.

> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/clocksource/sun4i_timer.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/su=
n4i_timer.c
> > index 84ace76..695c8c8 100644
> > --- a/drivers/clocksource/sun4i_timer.c
> > +++ b/drivers/clocksource/sun4i_timer.c
> > @@ -16,6 +16,7 @@
> > =20
> >  #include <linux/clk.h>
> >  #include <linux/clockchips.h>
> > +#include <linux/delay.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/irq.h>
> >  #include <linux/irqreturn.h>
> > @@ -61,9 +62,14 @@ static void sun4i_clkevt_mode(enum clock_event_mode =
mode,
> >  static int sun4i_clkevt_next_event(unsigned long evt,
> >  				   struct clock_event_device *unused)
> >  {
> > -	u32 u =3D readl(timer_base + TIMER_CTL_REG(0));
> > -	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
> > -	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
> > +	u32 val =3D readl(timer_base + TIMER_CTL_REG(0));
> > +	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
> > +	udelay(1);
>=20
> That udelay() is more than suspicious. Is there really no other way to
> deal with that hardware?
>=20
> If no, you really need to put a proper explanation for that into the code.

The datasheet states that you have to wait for two ticks of the timer
clock source (in that case, 24MHz, which makes it around 80-85ns) before
you can actually enable it back.

I didn't came up with a better solution.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzftlAAoJEBx+YmzsjxAgfN0QAIN23/uDswdhW4KdLP+SUu6c
OWqmu0ipWDCqlVhC/KTZGbXAHrde0oWO1LnVCpnXfXunY+zhmQmaEaUV9+/gdnK+
NGez4bPesOdw1fjG9jJ+If37M80OxULrdWpXyoB9Iv15KBIV1J+DOnb7B+1J23Bz
msbFWEgQv6siGg/mlSZaZeGn96grC38fpJu1HWzNo+AYZbRylf5cXPL20yYIvGJ/
clct4lhiIkKqG1uq9tcD4a5pI+udhdY476vR1mF7T0tjCFyzRWdtX1qfcuaKLSMv
1Kx32fbdx2CuZYlFqVA7HcMGNNcSq6arm2VcQRxUC/wruQP/Ph686v1fBl4+A7PF
GH+FUK3WbielzRwwOSPCkt6KOwBlRKUnzX46YyaPh4d2C7l8SR6rhKj4UnvRTJ7o
pOS2kibF6vEkOvuho7q4o8pXCrNnpdJbuGf+pUQ9LlbylfsKSekvL2zgHdvmVnY2
W7jzEmcDNJUw30x+Kb8WEa8qYK1fJx4hluXMHeQg5YcTKU8+bL//WyKuqNM/yEK+
ATZJZTQEns8Go8x/8qF25k77aHltZUZqLUXwsnaCLzDGlFWDHv4AJL50gzPvnKqV
otndJF1cn3BaDO3zF6CkCIak76GqVOAAY4krlGUYtwmrgdIfqGfty+2roAzTlEXv
R4r1JWKD7nCFTNt6l8Eg
=8VJ/
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
