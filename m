Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3LGKfK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 05:35:10 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57201 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752838Ab3LGKfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 05:35:07 -0500
Date: Sat, 7 Dec 2013 11:33:35 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 01/10] net: stmmac: Enable stmmac main clock when probing
 hardware
Message-ID: <20131207103335.GL24519@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eWbcAUUbgrfSEG1c"
Content-Disposition: inline
In-Reply-To: <1386350983-13281-2-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eWbcAUUbgrfSEG1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Dec 07, 2013 at 01:29:34AM +0800, Chen-Yu Tsai wrote:
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>=20
> Guiseppe previously stated that the "stmmaceth" clock is the
> main clock that drives the IP. The stmmac driver does not
> enable this clock during the probe phase. When the driver is
> built in to the kernel, this is fine because the clock maybe
> on by default, or the boot loader had enabled it.
>=20
> If stmmac is built as a module, when the module is loaded,
> the clock may be found unused and disabled by the kernel.

This should be your commit log.

And this is actually not related to the fact that we are building it
as a module or not. You'd face the same issue with a statically built
kernel if the bootloader didn't enable it.

>=20
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 24 +++++++++++++----=
------
>  1 file changed, 14 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/=
net/ethernet/stmicro/stmmac/stmmac_main.c
> index 8d4ccd3..7da71ed 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2688,10 +2688,17 @@ struct stmmac_priv *stmmac_dvr_probe(struct devic=
e *device,
>  	if ((phyaddr >=3D 0) && (phyaddr <=3D 31))
>  		priv->plat->phy_addr =3D phyaddr;
> =20
> +	priv->stmmac_clk =3D clk_get(priv->device, STMMAC_RESOURCE_NAME);

You can probably use devm_clk_get to make the exit path smaller.

> +	if (IS_ERR(priv->stmmac_clk)) {
> +		pr_warn("%s: warning: cannot get CSR clock\n", __func__);

And dev_warn here.

> +		goto error_clk_get;
> +	}
> +	clk_prepare_enable(priv->stmmac_clk);
> +
>  	/* Init MAC and get the capabilities */
>  	ret =3D stmmac_hw_init(priv);
>  	if (ret)
> -		goto error_free_netdev;
> +		goto error_hw_init;
>  	ndev->netdev_ops =3D &stmmac_netdev_ops;
> =20
> @@ -2729,12 +2736,6 @@ struct stmmac_priv *stmmac_dvr_probe(struct device=
 *device,
>  		goto error_netdev_register;
>  	}
> =20
> -	priv->stmmac_clk =3D clk_get(priv->device, STMMAC_RESOURCE_NAME);
> -	if (IS_ERR(priv->stmmac_clk)) {
> -		pr_warn("%s: warning: cannot get CSR clock\n", __func__);
> -		goto error_clk_get;
> -	}
> -
>  	/* If a specific clk_csr value is passed from the platform
>  	 * this means that the CSR Clock Range selection cannot be
>  	 * changed at run-time and it is fixed. Viceversa the driver'll try to
> @@ -2759,15 +2760,18 @@ struct stmmac_priv *stmmac_dvr_probe(struct devic=
e *device,
>  		}
>  	}
> =20
> +	clk_disable_unprepare(priv->stmmac_clk);
> +

Hu? Why do you disable the clock? don't you need it afterwards?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--eWbcAUUbgrfSEG1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSovl/AAoJEBx+YmzsjxAg4IMP/0a6ZjbG+/bFr5lURTXqytO1
Cl6bdgZafg0esKykQ/w8PDfArBmVnSwKOydrVTQ5j6Hyr7HwdvKgboxG2Vzas1oT
i0Besj+nwJskNNKD+KSuARQtz0bKfS8EkWhicj4D8209tMCYvroB0Z1Lj79dIJOm
O+t6o1+vrr78y37n7UbKFVhtOXqIgCQ5kjf5BZJOC5gDuwFunjitDaWfsrfADe9R
i8RuI6R5UKDGmxKIGXbFxAyH1g7lrMHgr2WBz3QdjWSEmtHQp+ihEvZzpjEk7sxo
HzmgT8HSrwOqIHuPaP0dSYGktjdaIbO7AAnAyahJpQz4I8YHnjGBUVtaJLcOHvFp
LnZ8ZqZYT+bGGn2jyxS2M6mTwff+vkc/+zq8pRbeTpmbCN0m7wcfJ19PiLfDgG6b
+mB7KC124f2cBI5oJSm+2/escvUvrvRk1OY4ibEVvVRm3tTxP0efoF1B6LyBZFnL
EX5hTjB/P2XTaZ591B8IQ839c98JPHpFwqCiDZfRdh53wpE9YjUxWA9qLcN7JSVh
4kwOYwdsuiRhA/kn51Np9UsZxPgeSEK3u6PV1vVp+4X/MlFx4dVM//3CBll8Fa81
IQcl0/rQt/qHUGqQ4FHLkMb2O8dJSlT1bpZqffs4MFGegyYgsD5slX1SGIpeTxKm
+Nxb+FwMupJ9qHbTj/nz
=H37h
-----END PGP SIGNATURE-----

--eWbcAUUbgrfSEG1c--
