Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaBCTfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:35:15 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52586 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753256AbaBCTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:35:13 -0500
Date: Mon, 3 Feb 2014 20:31:08 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/8] clk: sunxi: Add Allwinner A20/A31 GMAC clock unit
Message-ID: <20140203193108.GC25625@lukather>
References: <1391398346-5094-1-git-send-email-wens@csie.org>
 <1391398346-5094-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c3bfwLpm8qysLVxt"
Content-Disposition: inline
In-Reply-To: <1391398346-5094-2-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c3bfwLpm8qysLVxt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 03, 2014 at 11:32:19AM +0800, Chen-Yu Tsai wrote:
> The Allwinner A20/A31 clock module controls the transmit clock source
> and interface type of the GMAC ethernet controller. Model this as
> a single clock for GMAC drivers to use.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt | 26 +++++++
>  drivers/clk/sunxi/clk-sunxi.c                     | 83 +++++++++++++++++=
++++++
>  2 files changed, 109 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Document=
ation/devicetree/bindings/clock/sunxi.txt
> index 0cf679b..f43b4c0 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -37,6 +37,7 @@ Required properties:
>  	"allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
>  	"allwinner,sun4i-mod0-clk" - for the module 0 family of clocks
>  	"allwinner,sun7i-a20-out-clk" - for the external output clocks
> +	"allwinner,sun7i-a20-gmac-clk" - for the GMAC clock module on A20/A31
> =20
>  Required properties for all clocks:
>  - reg : shall be the control register address for the clock.
> @@ -50,6 +51,9 @@ Required properties for all clocks:
>  	If the clock module only has one output, the name shall be the
>  	module name.
> =20
> +For "allwinner,sun7i-a20-gmac-clk", the parent clocks shall be fixed rate
> +dummy clocks at 25 MHz and 125 MHz, respectively. See example.
> +
>  Clock consumers should specify the desired clocks they use with a
>  "clocks" phandle cell. Consumers that are using a gated clock should
>  provide an additional ID in their clock property. This ID is the
> @@ -96,3 +100,25 @@ mmc0_clk: clk@01c20088 {
>  	clocks =3D <&osc24M>, <&pll6 1>, <&pll5 1>;
>  	clock-output-names =3D "mmc0";
>  };
> +
> +mii_phy_tx_clk: clk@2 {
> +	#clock-cells =3D <0>;
> +	compatible =3D "fixed-clock";
> +	clock-frequency =3D <25000000>;
> +	clock-output-names =3D "mii_phy_tx";
> +};
> +
> +gmac_int_tx_clk: clk@3 {
> +	#clock-cells =3D <0>;
> +	compatible =3D "fixed-clock";
> +	clock-frequency =3D <125000000>;
> +	clock-output-names =3D "gmac_int_tx";
> +};
> +
> +gmac_clk: clk@01c20164 {
> +	#clock-cells =3D <0>;
> +	compatible =3D "allwinner,sun7i-a20-gmac-clk";
> +	reg =3D <0x01c20164 0x4>;
> +	clocks =3D <&mii_phy_tx_clk>, <&gmac_int_tx_clk>;

You should also document in which order you expect the parents to
be. Or it will probably be easier to just use clock-names here.

> +	clock-output-names =3D "gmac";
> +};
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 736fb60..0b361d2 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -379,6 +379,89 @@ static void sun7i_a20_get_out_factors(u32 *freq, u32=
 parent_rate,
> =20
> =20
>  /**
> + * sun7i_a20_gmac_clk_setup - Setup function for A20/A31 GMAC clock modu=
le
> + *
> + * This clock looks something like this
> + *                               ________________________
> + *  MII TX clock from PHY >-----|___________    _________|----> to GMAC =
core
> + *  GMAC Int. RGMII TX clk >----|___________\__/__gate---|----> to PHY
> + *  Ext. 125MHz RGMII TX clk >--|__divider__/            |
> + *                              |________________________|
> + *
> + * The external 125 MHz reference is optional, i.e. GMAC can use its
> + * internal TX clock just fine. The A31 GMAC clock module does not have
> + * the divider controls for the external reference.
> + *
> + * To keep it simple, let the GMAC use either the MII TX clock for MII m=
ode,
> + * and its internal TX clock for GMII and RGMII modes. The GMAC driver s=
hould
> + * select the appropriate source and gate/ungate the output to the PHY.
> + *
> + * Only the GMAC should use this clock. Altering the clock so that it do=
esn't
> + * match the GMAC's operation parameters will result in the GMAC not bei=
ng
> + * able to send traffic out. The GMAC driver should set the clock rate a=
nd
> + * enable/disable this clock to configure the required state. The clock
> + * driver then responds by auto-reparenting the clock.
> + */
> +
> +#define SUN7I_A20_GMAC_GPIT	2
> +#define SUN7I_A20_GMAC_MASK	0x3
> +#define SUN7I_A20_GMAC_MAX_PARENTS	2
> +
> +static void __init sun7i_a20_gmac_clk_setup(struct device_node *node)
> +{
> +	struct clk *clk;
> +	struct clk_mux *mux;
> +	struct clk_gate *gate;
> +	const char *clk_name =3D node->name;
> +	const char *parents[SUN7I_A20_GMAC_MAX_PARENTS];
> +	void *reg;
> +	int i =3D 0;
> +
> +	/* allocate mux and gate clock structs */
> +	mux =3D kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
> +	if (!mux)
> +		return;

Newline.

> +	gate =3D kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
> +	if (!gate) {
> +		kfree(mux);
> +		return;
> +	}
> +
> +	reg =3D of_iomap(node, 0);

You should check for the return code here.

> +	of_property_read_string(node, "clock-output-names", &clk_name);

And here too, since you made the clock-output-names property mandatory

> +	while (i < SUN7I_A20_GMAC_MAX_PARENTS &&
> +			(parents[i] =3D of_clk_get_parent_name(node, i)) !=3D NULL)

You should check for an error here too, but if you switch to using
clock-names, that will probably be refactored anyway.

> +		i++;
> +
> +	/* set up gate and fixed rate properties */
> +	gate->reg =3D reg;
> +	gate->bit_idx =3D SUN7I_A20_GMAC_GPIT;
> +	gate->lock =3D &clk_lock;
> +	mux->reg =3D reg;
> +	mux->mask =3D SUN7I_A20_GMAC_MASK;
> +	mux->flags =3D CLK_MUX_INDEX_BIT;
> +	mux->lock =3D &clk_lock;
> +
> +	clk =3D clk_register_composite(NULL, clk_name,
> +			parents, i,
> +			&mux->hw, &clk_mux_ops,
> +			NULL, NULL,
> +			&gate->hw, &clk_gate_ops,
> +			0);
> +
> +	if (!IS_ERR(clk)) {
> +		of_clk_add_provider(node, of_clk_src_simple_get, clk);
> +		clk_register_clkdev(clk, clk_name, NULL);
> +	}
> +}
> +CLK_OF_DECLARE(sun7i_a20_gmac, "allwinner,sun7i-a20-gmac-clk",
> +		sun7i_a20_gmac_clk_setup);
> +
> +
> +
> +/**
>   * sunxi_factors_clk_setup() - Setup function for factor clocks
>   */
> =20
> --=20
> 1.9.rc1
>=20

It looks fine otherwise.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--c3bfwLpm8qysLVxt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS7+58AAoJEBx+YmzsjxAg+80QAKm5RHM04LjONq7RT4kXgPXr
G4CLOWNEFSZOcM/npUnG7TEnbRZFdD/JssOqPrlyrj6vWrTZaxLgbro4VRkoJtEq
e9uha5cikUzz5tJe+vyTSgQ5o47H5dGDhdPlhqBB4uHtBhwxsKsmiUdYlmGnj1fm
liIpTsW50O33kKAlf6CRsuhnBpmcrEjby3bahee6Mc5thJWArgjPTNAti5nIMAf3
SFC1MBKrC2gdRAch2h3/cThtfO+XtQJpBAePK+NMLA3bxdN84G4RPK9sAv1rEGvd
Xapo7ZJzYu36Aj2sDwXWgkLS9GaOtXpDqwfIzZ5S+kljPwat/H2D1gli5BfhRCPC
FIWwMy7kpCnqxS4P67nU2jYNT3Va878IujpdWLpXw6aQDWjSSy39CJxTE0a4ahU2
DlVzGqQ/eXjKBi1jPP0GNlGe2Zx8WhKBzvIV8zPYMCGvWPM0m26x2KH8UPODhI20
jjQiJK6pzeM16xZwT06xEbgpSm2gU7Zf4xc/YO1vSuiKFNj2fH1xu81EoeriFj4V
jgwaqmYJFpGuMc0Zf66aU1RiZhYVWvVkNmzY73SNcA/SFrslUL9EfqhfleV5xa8F
LBad7lJs6qK1/fq63XR7AhL7kZQoM365ejsVpsrq+t5/A2SFg2HsjWWTuRGKCUiT
1yRPl7Q2fOQHlSwSY8kP
=a+Wo
-----END PGP SIGNATURE-----

--c3bfwLpm8qysLVxt--
