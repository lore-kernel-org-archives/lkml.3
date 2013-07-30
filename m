Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3G3Mo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:44:57 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41313 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750767Ab3G3Mo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:44:56 -0400
Date: Tue, 30 Jul 2013 14:44:53 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "albert.u.boot@aribaud.net" <albert.u.boot@aribaud.net>,
        Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 04/10] ARM: sun6i: Add restart code for the A31
Message-ID: <20130730124453.GA12562@lukather>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618312-19001-5-git-send-email-maxime.ripard@free-electrons.com>
 <20130729140430.GA25264@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20130729140430.GA25264@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, Jul 29, 2013 at 03:04:31PM +0100, Mark Rutland wrote:
> On Tue, Jul 23, 2013 at 11:25:06PM +0100, Maxime Ripard wrote:
> > The Allwinner A31 has a sligthly different watchdog that requires a
> > different restart code.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  arch/arm/mach-sunxi/sunxi.c | 37 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >=20
> > diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> > index 11326d9..c18ef3a 100644
> > --- a/arch/arm/mach-sunxi/sunxi.c
> > +++ b/arch/arm/mach-sunxi/sunxi.c
> > @@ -32,6 +32,15 @@
> >  #define SUN4I_WATCHDOG_MODE_ENABLE		(1 << 0)
> >  #define SUN4I_WATCHDOG_MODE_RESET_ENABLE	(1 << 1)
> > =20
> > +#define SUN6I_WATCHDOG1_IRQ_REG		0x00
> > +#define SUN6I_WATCHDOG1_CTRL_REG	0x10
> > +#define SUN6I_WATCHDOG1_CTRL_RESTART		(1 << 0)
> > +#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
> > +#define SUN6I_WATCHDOG1_CONFIG_RESTART		(1 << 0)
> > +#define SUN6I_WATCHDOG1_CONFIG_IRQ		(1 << 1)
> > +#define SUN6I_WATCHDOG1_MODE_REG	0x18
> > +#define SUN6I_WATCHDOG1_MODE_ENABLE		(1 << 0)
> > +
> >  static void __iomem *wdt_base;
> > =20
> >  static void sun4i_restart(enum reboot_mode mode, const char *cmd)
> > @@ -56,8 +65,36 @@ static void sun4i_restart(enum reboot_mode mode, con=
st char *cmd)
> >  	}
> >  }
> > =20
> > +static void sun6i_restart(char mode, const char *cmd)
> > +{
> > +	if (!wdt_base)
> > +		return;
> > +
> > +	/* Disable interrupts */
> > +	writel(0, wdt_base + SUN6I_WATCHDOG1_IRQ_REG);
> > +
> > +	/* We want to disable the IRQ and just reset the whole system */
> > +	writel(SUN6I_WATCHDOG1_CONFIG_RESTART,
> > +		wdt_base + SUN6I_WATCHDOG1_CONFIG_REG);
> > +
> > +	/* Enable timer. The default and lowest interval value is 0.5s */
> > +	writel(SUN6I_WATCHDOG1_MODE_ENABLE,
> > +		wdt_base + SUN6I_WATCHDOG1_MODE_REG);
> > +
> > +	/* Restart the watchdog. */
> > +	writel(SUN6I_WATCHDOG1_CTRL_RESTART,
> > +		wdt_base + SUN6I_WATCHDOG1_CTRL_REG);
> > +
> > +	while (1) {
> > +		mdelay(5);
> > +		writel(SUN6I_WATCHDOG1_MODE_ENABLE,
> > +			wdt_base + SUN6I_WATCHDOG1_MODE_REG);
> > +	}
> > +}
> > +
> >  static struct of_device_id sunxi_restart_ids[] =3D {
> >  	{ .compatible =3D "allwinner,sun4i-wdt", .data =3D sun4i_restart },
> > +	{ .compatible =3D "allwinner,sun6i-wdt", .data =3D sun6i_restart },
>=20
> Is there a corresponding binding document addition?=20
>=20
> sun4i-wdt.txt could be turned into a more general sunxi-wdt.txt.

Ah, right, thanks!

I'll fix it in the v2.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR97VFAAoJEBx+YmzsjxAg4rsP+wfjVAb6z7jaUTnY4UFJMAEM
abDUTjBYB83517zc41aCPCnbjFgB307/Qu2PTe7Rd6cD+LA8jAHeOfmViU1umGEW
Tenx41rv4ZQml8EUXuzW16jk+FosUMZK5a9OfJTFd0uKB/cmZXXY5JYm3glTzb5H
iVot3BMo/ki5j+56TBEKESSPucjaI1CIM68L2ywzwNvxU/fPsNTYN1vWMNxWzOrM
rJjbsk+MASRb+Eciqvd2D3dOCxR+Dx4gtNbjS/3TJMZ+4DRQ88L04R7fs3X1nL21
hjvGKpEd4cdWbSNSfltSB7DEs0IpWuFrjfBOIlgcTT9lngiVYQcPXe2VBzvqR5JU
mYvyK14a2c9Se2gBklV9I26BsIVndwQZpv9OMrMwusMb/vWUB4uR4SUs6jdgRuFO
hmTiDoOPhPl5slbKGWjwgceenV1G+zWhaqOc6uPuN3878Cd+OJiynyl+P7vdcCdY
cnfAHHAc25wsRy7niNlpgsqtYp269J3srgb9gainGSW3TMs52aUOgGUxSB0DG3cJ
JeuAieLocWGTOUDrIlCV38Sea9tSgk/aY+nzxNSL1MBzDRmoFa7MXqN53vgMiiet
7Z+1SrrprGikN7yNJ8j0u0yFtFU/LPNzDhBOiFgrKlVlwmvK01FrCViLo5T9oIFH
s6Zb1/sK9qoe0E/qm8LJ
=JSeH
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
