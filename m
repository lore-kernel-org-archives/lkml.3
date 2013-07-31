Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab3GaKOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:14:39 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46844 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756116Ab3GaKOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:14:38 -0400
Date: Wed, 31 Jul 2013 12:14:33 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] clk: sunxi: Add A31 clocks support
Message-ID: <20130731101433.GC2911@lukather>
References: <1375195462-19566-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375195462-19566-4-git-send-email-maxime.ripard@free-electrons.com>
 <51F861E5.7010909@elopez.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Content-Disposition: inline
In-Reply-To: <51F861E5.7010909@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emilio,

On Tue, Jul 30, 2013 at 10:01:25PM -0300, Emilio L=F3pez wrote:
> Hi Maxime,
>=20
> El 30/07/13 11:44, Maxime Ripard escribi=F3:
> > The A31 has a mostly different clock set compared to the other older
> > SoCs currently supported in the Allwinner clock driver.
> >=20
> > Add support for the basic useful clocks. The other ones will come in
> > eventually.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/clk/sunxi/clk-sunxi.c | 120 ++++++++++++++++++++++++++++++++++=
++++++++
> >  1 file changed, 120 insertions(+)
> >=20
> > diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunx=
i.c
> > index 6e9cbc9..8cd69e6 100644
> > --- a/drivers/clk/sunxi/clk-sunxi.c
> > +++ b/drivers/clk/sunxi/clk-sunxi.c
> > @@ -124,7 +124,67 @@ static void sun4i_get_pll1_factors(u32 *freq, u32 =
parent_rate,
> >  	*n =3D div / 4;
> >  }
> > =20
> > +/**
> > + * sun6i_get_pll1_factors() - calculates n, k and m factors for PLL1
> > + * PLL1 rate is calculated as follows
> > + * rate =3D parent_rate * (n + 1) * (k + 1) / (m + 1);
> > + * parent_rate should always be 24MHz
> > + */
> > +static void sun6i_get_pll1_factors(u32 *freq, u32 parent_rate,
> > +				   u8 *n, u8 *k, u8 *m, u8 *p)
> > +{
> > +	/*
> > +	 * We can operate only on MHz, this will make our life easier
> > +	 * later.
> > +	 */
> > +	u32 freq_mhz =3D *freq / 1000000;
> > +	u32 parent_freq_mhz =3D parent_rate / 1000000;
> > +
> > +	/* If the frequency is a multiple of 32 MHz, k is always 3 */
> > +	if (!(freq_mhz % 32))
> > +		*k =3D 3;
> > +	/* If the frequency is a multiple of 9 MHz, k is always 2 */
> > +	else if (!(freq_mhz % 9))
> > +		*k =3D 2;
> > +	/* If the frequency is a multiple of 8 MHz, k is always 1 */
> > +	else if (!(freq_mhz % 8))
> > +		*k =3D 1;
> > +	/* Otherwise, we don't use the k factor */
> > +	else
> > +		*k =3D 0;
> > =20
> > +	/*
> > +	 * If the frequency is a multiple of 2 but not a multiple of
> > +	 * 3, m is 3. This is the first time we use 6 here, yet we
> > +	 * will use it on several other places.
> > +	 * We use this number because it's the lowest frequency we can
> > +	 * generate (with n =3D 0, k =3D 0, m =3D 3), so every other frequency
> > +	 * somehow relates to this frequency.
> > +	 */
> > +	if ((freq_mhz % 6) =3D=3D 2 || (freq_mhz % 6) =3D=3D 4)
> > +		*m =3D 2;
> > +	/*
> > +	 * If the frequency is a multiple of 6MHz, but the factor is
> > +	 * odd, m will be 3
> > +	 */
> > +	else if ((freq_mhz / 6) & 1)
> > +		*m =3D 3;
> > +	/* Otherwise, we end up with m =3D 1 */
> > +	else
> > +		*m =3D 1;
> > +
> > +	/* Calculate n thanks to the above factors we already got */
> > +	*n =3D freq_mhz * (*m + 1) / ((*k + 1) * parent_freq_mhz) - 1;
> > +
> > +	/*
> > +	 * If n end up being outbound, and that we can still decrease
> > +	 * m, do it.
> > +	 */
> > +	if ((*n + 1) > 31 && (*m + 1) > 1) {
> > +		*n =3D (*n + 1) / 2 - 1;
> > +		*m =3D (*m + 1) / 2 - 1;
> > +	}
> > +}
>=20
> Nice! My rate-to-factors functions pale in comparison :) Remember that
> n/k/m/p may be NULL when the caller just wants you to round freq to an
> achievable value (see clk_factors_round_rate(...) in clk-factors.c).

Ah, right, I forgot that usecase.

> >  /**
> >   * sun4i_get_apb1_factors() - calculates m, p factors for APB1
> > @@ -189,6 +249,15 @@ static struct clk_factors_config sun4i_pll1_config=
 =3D {
> >  	.pwidth =3D 2,
> >  };
> > =20
> > +static struct clk_factors_config sun6i_pll1_config =3D {
> > +	.nshift	=3D 8,
> > +	.nwidth =3D 5,
> > +	.kshift =3D 4,
> > +	.kwidth =3D 2,
> > +	.mshift =3D 0,
> > +	.mwidth =3D 2,
> > +};
> > +
> >  static struct clk_factors_config sun4i_apb1_config =3D {
> >  	.mshift =3D 0,
> >  	.mwidth =3D 5,
> > @@ -201,6 +270,11 @@ static const __initconst struct factors_data sun4i=
_pll1_data =3D {
> >  	.getter =3D sun4i_get_pll1_factors,
> >  };
> > =20
> > +static const __initconst struct factors_data sun6i_pll1_data =3D {
> > +	.table =3D &sun6i_pll1_config,
> > +	.getter =3D sun6i_get_pll1_factors,
> > +};
> > +
> >  static const __initconst struct factors_data sun4i_apb1_data =3D {
> >  	.table =3D &sun4i_apb1_config,
> >  	.getter =3D sun4i_get_apb1_factors,
> > @@ -243,6 +317,10 @@ static const __initconst struct mux_data sun4i_cpu=
_mux_data =3D {
> >  	.shift =3D 16,
> >  };
> > =20
> > +static const __initconst struct mux_data sun6i_ahb1_mux_data =3D {
> > +	.shift =3D 12,
> > +};
> > +
> >  static const __initconst struct mux_data sun4i_apb1_mux_data =3D {
> >  	.shift =3D 24,
> >  };
> > @@ -301,6 +379,12 @@ static const __initconst struct div_data sun4i_apb=
0_data =3D {
> >  	.width	=3D 2,
> >  };
> > =20
> > +static const __initconst struct div_data sun6i_apb2_div_data =3D {
> > +	.shift	=3D 0,
> > +	.pow	=3D 0,
> > +	.width	=3D 4,
> > +};
> > +
> >  static void __init sunxi_divider_clk_setup(struct device_node *node,
> >  					   struct div_data *data)
> >  {
> > @@ -347,6 +431,10 @@ static const __initconst struct gates_data sun5i_a=
13_ahb_gates_data =3D {
> >  	.mask =3D {0x107067e7, 0x185111},
> >  };
> > =20
> > +static const __initconst struct gates_data sun6i_a31_ahb1_gates_data =
=3D {
> > +	.mask =3D { 0xedfe7f62, 0x794f931 },
> > +};
> > +
> >  static const __initconst struct gates_data sun4i_apb0_gates_data =3D {
> >  	.mask =3D {0x4EF},
> >  };
> > @@ -363,6 +451,14 @@ static const __initconst struct gates_data sun5i_a=
13_apb1_gates_data =3D {
> >  	.mask =3D {0xa0007},
> >  };
> > =20
> > +static const __initconst struct gates_data sun6i_a31_apb1_gates_data =
=3D {
> > +	.mask =3D { 0x3031 },
> > +};
> > +
> > +static const __initconst struct gates_data sun6i_a31_apb2_gates_data =
=3D {
> > +	.mask =3D { 0x3f000f },
> > +};
> > +
>=20
> We should decide on a style here and use it across the board, so far we
> have definitions with and without spaces between constants and braces,
> and constants both with upper and lower case A-F. Personally I don't
> feel strongly about the spacing and prefer upper-case constants, but if
> the style guide suggests otherwise, I can live with it (as long as we
> use it consistently, that is)

Hmmm, like you probably noticed, I prefer the { 0xdeadbeef } way, and
that's what is used everywhere else for sunxi I believe. There's no
strong convention on this one, but it's true that we have to remain
consistent.

I'll stick with your convention already in use in the clocks driver for
the time being, and we'll see later to unify the drivers on this
convention later on.

> >  static void __init sunxi_gates_clk_setup(struct device_node *node,
> >  					 struct gates_data *data)
> >  {
> > @@ -420,6 +516,10 @@ static const __initconst struct of_device_id clk_f=
actors_match[] =3D {
> >  		.data =3D &sun4i_pll1_data,
> >  	},
> >  	{
> > +		.compatible =3D "allwinner,sun6i-pll1-clk",
> > +		.data =3D &sun6i_pll1_data,
> > +	},
> > +	{
> >  		.compatible =3D "allwinner,sun4i-apb1-clk",
> >  		.data =3D &sun4i_apb1_data,
> >  	},
> > @@ -440,6 +540,10 @@ static const __initconst struct of_device_id clk_d=
iv_match[] =3D {
> >  		.compatible =3D "allwinner,sun4i-apb0-clk",
> >  		.data =3D &sun4i_apb0_data,
> >  	},
> > +	{
> > +		.compatible =3D "allwinner,sun6i-apb2-div-clk",
> > +		.data =3D &sun6i_apb2_div_data,
> > +	},
> >  	{}
> >  };
> > =20
> > @@ -453,6 +557,10 @@ static const __initconst struct of_device_id clk_m=
ux_match[] =3D {
> >  		.compatible =3D "allwinner,sun4i-apb1-mux-clk",
> >  		.data =3D &sun4i_apb1_mux_data,
> >  	},
> > +	{
> > +		.compatible =3D "allwinner,sun6i-ahb1-mux-clk",
> > +		.data =3D &sun6i_ahb1_mux_data,
> > +	},
> >  	{}
> >  };
> > =20
> > @@ -471,6 +579,10 @@ static const __initconst struct of_device_id clk_g=
ates_match[] =3D {
> >  		.data =3D &sun5i_a13_ahb_gates_data,
> >  	},
> >  	{
> > +		.compatible =3D "allwinner,sun6i-a31-ahb1-gates-clk",
> > +		.data =3D &sun6i_a31_ahb1_gates_data,
> > +	},
> > +	{
> >  		.compatible =3D "allwinner,sun4i-apb0-gates-clk",
> >  		.data =3D &sun4i_apb0_gates_data,
> >  	},
> > @@ -486,6 +598,14 @@ static const __initconst struct of_device_id clk_g=
ates_match[] =3D {
> >  		.compatible =3D "allwinner,sun5i-a13-apb1-gates-clk",
> >  		.data =3D &sun5i_a13_apb1_gates_data,
> >  	},
> > +	{
> > +		.compatible =3D "allwinner,sun6i-a31-apb1-gates-clk",
> > +		.data =3D &sun6i_a31_apb1_gates_data,
> > +	},
> > +	{
> > +		.compatible =3D "allwinner,sun6i-a31-apb2-gates-clk",
> > +		.data =3D &sun6i_a31_apb2_gates_data,
> > +	},
>=20
> Please see my comments on the first patch regarding these.

Yes, that will be fixed.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+OOJAAoJEBx+YmzsjxAg4JQP/joony/XRFtQ2Pns2MAbYBNp
P3cjeos3Y8yL4c8T7xEKpl2H4pV69ciAS/Dp0IHg4Vo9US/BUYPm6cWbhA8Z7f0M
DBZ/8uQswfaIZUf/KSI3LitpCAm5tl9YA0SHtgd8NV7ZujeihbMvU70ycFvIIHux
ag4rehGdxTPEItkMfqPKmR5PP25DfSFjaILeZYR66RLbHV4+kvyoeaf94bRbBWKD
Rz2StFiu0ThtTAaxkRhidqg3V/xKGmEKAkenQASQcXsU2tj6OmQnf1cQzIYg329C
16uf5FpJ2nXEtOcf8oZnDFuDmVMBAvNt2J45qQ7xU52pp+ABMo/R8yQ3hARx7AgP
B1cUgHjWBTsCh4P//srGRjPeceVXtkrH3BdbvDqLtLDyCVkxETm9wg4m/T/oTUBf
ogcUW81Lri6bMorA1uCu3krO6M+0+71OQA1xcdT9Kqp5ycsz/YNFDXwDm7BEiL1p
Dyxyfdn5qa6s9WhTwi4ZdMB3JaSx/dcUNxfz1KoS9wic1J8xZuOursD7V+PfRDrC
N3L0fQEi/4FAVuwL/Gser/vBp4bTn3hsZ9cOV/gHuMZGM8KFsQCUDiJxU2IU1QwP
aUDEuoYNmbX/aiScMJseGFq7yPTspFu7BRus/Er8fS94vaD+Olz6/W3xp2sxg7z1
9fVI7lI82/F9kQW4+J5A
=sBrD
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
