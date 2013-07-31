Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab3GaHhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:37:31 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46155 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759091Ab3GaHh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:37:27 -0400
Date: Wed, 31 Jul 2013 09:37:24 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: sun6i: Enable clock support in the DTSI
Message-ID: <20130731073724.GA24439@lukather>
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375195462-19566-5-git-send-email-maxime.ripard@free-electrons.com>
 <51F86A2E.10505@elopez.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <51F86A2E.10505@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emilio,

On Tue, Jul 30, 2013 at 10:36:46PM -0300, Emilio L=F3pez wrote:
> Hi Maxime,
>=20
> Overall this looks good to me, but I have some small comments:
>=20
> El 30/07/13 11:44, Maxime Ripard escribi=F3:
> > Now that the clock driver has support for the A31 clocks, we can add
> > them to the DTSI and start using them in the relevant hardware blocks.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  arch/arm/boot/dts/sun6i-a31.dtsi | 137 +++++++++++++++++++++++++++++++=
+++++---
> >  1 file changed, 127 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i=
-a31.dtsi
> > index 0d13dc6..c6a3a91 100644
> > --- a/arch/arm/boot/dts/sun6i-a31.dtsi
> > +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
> > @@ -51,13 +51,130 @@
> > =20
> >  	clocks {
> >  		#address-cells =3D <1>;
> > -		#size-cells =3D <0>;
> > +		#size-cells =3D <1>;
> > +		ranges;
> > =20
> > -		osc: oscillator {
> > +		osc24M: hosc {
>=20
> Please use osc24M and osc32k instead of hosc and losc, respectively.

The problem is a bit more complex than that.

On the A31, the losc clock is actually a mux between an external
oscillator running at 32kHz, and the internal oscillator running at
667MHz, that would be scaled down.

Support for this mux is not quite there yet, since I've not seen any
documentation for it, but this would allow to just rearrange losc
parents and compatible when we will had such support.

Hence why I chose these names.

> >  			#clock-cells =3D <0>;
> >  			compatible =3D "fixed-clock";
> >  			clock-frequency =3D <24000000>;
>=20
> Is osc24M not gatable on A31?

Nope.

> >  		};
> > +
> > +		osc32k: losc {
> > +			#clock-cells =3D <0>;
> > +			compatible =3D "fixed-clock";
> > +			clock-frequency =3D <32768>;
> > +		};
> > +
> > +		pll1: pll1@01c20000 {
> > +			#clock-cells =3D <0>;
> > +			compatible =3D "allwinner,sun6i-pll1-clk";
> > +			reg =3D <0x01c20000 0x4>;
> > +			clocks =3D <&osc24M>;
> > +		};
> > +
> > +		/*
> > +		 * This is a dummy clock, to be used as placeholder on
> > +		 * other mux clocks when a specific parent clock is not
> > +		 * yet implemented. It should be dropped when the driver
> > +		 * is complete.
> > +		 */
> > +		pll6: pll6 {
> > +			#clock-cells =3D <0>;
> > +			compatible =3D "fixed-clock";
> > +			clock-frequency =3D <0>;
> > +		};
> > +
> > +		cpu: cpu@01c20050 {
> > +			#clock-cells =3D <0>;
> > +			compatible =3D "allwinner,sun4i-cpu-clk";
> > +			reg =3D <0x01c20050 0x4>;
> > +			clocks =3D <&osc32k>, <&osc24M>, <&pll1>, <&pll1>;
>=20
> Listing pll1 twice doesn't sound correct, but vendor code seems to
> indicate so. A comment to clarify it's not a typo would be good I think.

Yes, I suspect an error in the datasheet, but until proven otherwise,
it's that way.

I'll add a comment.

> > +		};
> > +
> > +		axi: axi@01c20050 {
> > +			#clock-cells =3D <0>;
> > +			compatible =3D "allwinner,sun4i-axi-clk";
> > +			reg =3D <0x01c20050 0x4>;
> > +			clocks =3D <&cpu>;
> > +		};
> > +
> > +		ahb1_mux: ahb1_mux@01c20054 {
> > +			#clock-cells =3D <0>;
> > +			compatible =3D "allwinner,sun6i-ahb1-mux-clk";
> > +			reg =3D <0x01c20054 0x4>;
> > +			clocks =3D <&osc32k>, <&osc24M>, <&axi>, <&pll6>;
> > +		};
> > +
> > +		ahb1: ahb1@01c20054 {
> > +			#clock-cells =3D <0>;
> > +			compatible =3D "allwinner,sun4i-ahb-clk";
> > +			reg =3D <0x01c20054 0x4>;
> > +			clocks =3D <&ahb1_mux>;
> > +		};
>=20
> Depending on when this lands, I believe these two above could be merged
> into one with the refactoring introduced on my patchset.

Since your patchset is still in RFC and we had no comments from Mike so
far, while this one looks pretty similar to the one we had before, I
guess the safest thing to do would be to rebase your patches on top of
this ones.

But it's right those clocks (AHB1 and APB2) will benefit from your work
as well :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+L60AAoJEBx+YmzsjxAg8goP/1gsgjcr8klKmbw9GjuuxmMI
yGN+NzpJvVuoqXq6by1IDx8q5i2ucwWI/qfqewht2DxJ4TspMcLDQQEIHiNEBm8L
Wmy5yywl6ID276zi+d8kpS/8BgXusk1OD5+vmQAvr76Cr2xJ67ubYQKIWGcMcQXs
e0DkXb71oBdJZU3hCtD38ha9XyoGTWd2A0ySCa+vO9akOQIsdh2lfwSXH7n4z5xv
w93roWH4gFVuGfqU0Ysqh4CBsxG+v1dSJ5s2cQd+Zv9oVPUU37ErQCQgqpZtzYud
YKbudjByeVJero2q+C2J2bnCt0uP1QDfp6K5J+WOzS9Jcvx4NUIuvzasbo6Djvui
wF1vfAjUS/VpsCu3RLFEYejyWClq84x37MOIu2pn+4hwjyACHCmGtxWji0KjzJDh
300I6BWVBLIGae49zB0XWiuiBrMWgue+pNnF2w8L5qtVUxLYp9TfnfEjP76pj4Hr
QOHirJ/ADqq9hkyynrSAEgU7dkEebOowrKzxAxOpSTuek2pRRR5qZggufVzc44Dc
qz/omIOekHS/oM+Rgetjb71F9BxvyF5OVkc/ggEWynRrXzO9gkXQ8snVoyqAhqE5
KE4xN7Qm48de56s1bRb41UgZyyaE4JHaZHNddUnZgM15topi9jMOQn6g3qyRqTBG
duLr7LYMpZ7hYLOzV0NK
=PKJ0
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
