Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbaGPHoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:44:16 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35695 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbaGPHoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:44:14 -0400
Date: Wed, 16 Jul 2014 09:44:10 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] clk: tegra: Add support for Tegra132 CAR clocks
Message-ID: <20140716074410.GF7978@ulmo>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-6-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="65ImJOski3p8EhYV"
Content-Disposition: inline
In-Reply-To: <1405437890-6468-6-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--65ImJOski3p8EhYV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 06:24:35PM +0300, Peter De Schrijver wrote:
> Tegra132 CAR supports almost the same clocks as Tegra124 CAR. This patch
> deals with the small differences.
>=20
> --
> I'm not entirely sure why the soc_therm clock needs to be enabled on Tegr=
a132,
> but turning it off results in a system hang. I presume this might be beca=
use
> of fastboot initializing soc_therm.
>=20
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  drivers/clk/tegra/clk-tegra124.c |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-teg=
ra124.c
> index 80efe51..b857aab 100644
> --- a/drivers/clk/tegra/clk-tegra124.c
> +++ b/drivers/clk/tegra/clk-tegra124.c
> @@ -1369,6 +1369,7 @@ static struct tegra_clk_init_table init_table[] __i=
nitdata =3D {
>  	{TEGRA124_CLK_XUSB_HS_SRC, TEGRA124_CLK_PLL_U_60M, 60000000, 0},
>  	{TEGRA124_CLK_XUSB_FALCON_SRC, TEGRA124_CLK_PLL_RE_OUT, 224000000, 0},
>  	{TEGRA124_CLK_XUSB_HOST_SRC, TEGRA124_CLK_PLL_RE_OUT, 112000000, 0},
> +	{TEGRA124_CLK_SOC_THERM, TEGRA124_CLK_PLL_P, 51000000, 0},
>  	/* This MUST be the last entry. */
>  	{TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0},
>  };
> @@ -1378,9 +1379,25 @@ static void __init tegra124_clock_apply_init_table=
(void)
>  	tegra_init_from_table(init_table, clks, TEGRA124_CLK_CLK_MAX);
>  }
> =20
> +enum {
> +	TEGRA124_CLK,
> +	TEGRA132_CLK,
> +};

I'd prefer this to be something like:

	struct tegra_car_soc {
		bool has_ccplex_clk;
	};

	static const struct tegra_car_soc tegra124_car_soc =3D {
		.has_ccplex_clk =3D false,
	};

	static const struct tegra_car_soc tegra132_car_soc =3D {
		.has_ccplex_clk =3D true,
	};

> +static const struct of_device_id tegra_clock_of_match[] =3D {
> +	{ .compatible =3D "nvidia,tegra124-car", .data =3D (void *)TEGRA124_CLK=
 },

	                                       .data =3D &tegra124_car_soc,

> +	{ .compatible =3D "nvidia,tegra132-car", .data =3D (void *)TEGRA132_CLK=
 },

	                                       .data =3D &tegra132_car_soc,

>  static void __init tegra124_clock_init(struct device_node *np)
>  {
>  	struct device_node *node;
> +	const struct of_device_id *match;

	const struct tegra_car_soc *soc;

> +	uintptr_t id;

> +	match =3D of_match_node(tegra_clock_of_match, np);
> +	id =3D (uintptr_t)match->data;

	soc =3D match->data;

> =20
>  	clk_base =3D of_iomap(np, 0);
>  	if (!clk_base) {
> @@ -1416,6 +1433,20 @@ static void __init tegra124_clock_init(struct devi=
ce_node *np)
>  	tegra_audio_clk_init(clk_base, pmc_base, tegra124_clks, &pll_a_params);
>  	tegra_pmc_clk_init(pmc_base, tegra124_clks);
> =20
> +	if (id =3D=3D TEGRA132_CLK) {

	if (soc->has_ccplex_clk) {

That's somewhat more explicit and avoids a lot of ugly casting.

> +		int i;
> +
> +		tegra124_clks[tegra_clk_cclk_g].present =3D false;
> +		tegra124_clks[tegra_clk_cclk_lp].present =3D false;
> +		tegra124_clks[tegra_clk_pll_x].present =3D false;
> +		tegra124_clks[tegra_clk_pll_x_out0].present =3D false;
> +
> +		/* Tegra132 requires the soc_therm clock to be always on */
> +		for (i =3D 0; i < ARRAY_SIZE(init_table); i++) {
> +			if (init_table[i].clk_id =3D=3D TEGRA124_CLK_SOC_THERM)
> +				init_table[i].state =3D 1;

I wonder if we could do this someplace else. If we could, then we'd have
the opportunity to make the init_table const.

> +		}
> +	}
>  	tegra_super_clk_gen4_init(clk_base, pmc_base, tegra124_clks,

Could use a blank line after the closing } above.

Thierry

--65ImJOski3p8EhYV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxi1JAAoJEN0jrNd/PrOhxWEP/RMExt+SxkJo+Ak93ELZHlsL
xjXKFvIN6bnI1zDm1icO6w6A+EM0HFOwdjpFJALdhaDR6mCfaYq3RA54dCFTwG9X
w/OplnN3Wm2bb5PrlA5dl/0fWgJeElJe+SVQZ3asnFNfxi/vOxH+XJzGP+YVqO/2
llgMkD509XY7006qTI3FrG4bAb1LVUyu24lR3E7Rz8D5d6jjAIoamzHfI0ckqHkg
MMoGMHgqGvkN798657QvUUuuDvWQeJVfYN5lz2JJFK1cbjw6Tk34DFSSvJDGIxJk
XviKyDf1K6/rx0TnlOyjMuA7B0WcREpwoECEk29LaFsQthcpikJx/2V8KJyho/oD
jw0RDy1njsIQuzyh8ATxH3b9HQ5/719aACpFbG2YoceVnN0ItwEC04jQ2cdFkxj2
rQqTIZ9XbFaoFksBskEqrCjmLEHrPDK1krT3nOrSMm1Rmswxo1zDSQMA/5SybXc+
1xbq5RdDnzJ5+a72lX99eUZKW264hbUQpOs8TpPAwjD8V5mNFNVMRaeF6M0MhRme
s0jOzzyCSsqNcbHsnj2Dq/r2aek9usnTt8+80Igj2FRYKOCHVwgOcCku3dDR75h/
p+DaYYeq93K5JELfWOjSyOnZaIrzQFe7tgwmrFYvGTme+5sqiH78D0bZdtmceLfD
ZnPFmezOr3qL2mSjwTK6
=FARf
-----END PGP SIGNATURE-----

--65ImJOski3p8EhYV--
