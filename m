Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbaD1XaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:30:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54134 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752461AbaD1XaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:30:06 -0400
Date: Mon, 28 Apr 2014 16:27:54 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH 2/7] reset: sunxi: allow MFD subdevices probe
Message-ID: <20140428232754.GQ3134@lukather>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
 <1398697130-8338-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K9fy5ol1Oes4Q/ix"
Content-Disposition: inline
In-Reply-To: <1398697130-8338-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K9fy5ol1Oes4Q/ix
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 04:58:45PM +0200, Boris BREZILLON wrote:
> The current implementation uses sunxi_reset_init function for both early
> init and platform device probe.
>=20
> The sunxi_reset_init function uses DT to retrieve device resources, which
> will be an issue if reset controllers are registered from an MFD device
> that define resources from mfd_cell definition.
>=20
> Moreover, we can make use of devm functions when we're in probe context.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/reset/reset-sunxi.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/reset/reset-sunxi.c b/drivers/reset/reset-sunxi.c
> index 695bd34..115fbb1 100644
> --- a/drivers/reset/reset-sunxi.c
> +++ b/drivers/reset/reset-sunxi.c
> @@ -145,7 +145,24 @@ MODULE_DEVICE_TABLE(of, sunxi_reset_dt_ids);
> =20
>  static int sunxi_reset_probe(struct platform_device *pdev)
>  {
> -	return sunxi_reset_init(pdev->dev.of_node);
> +	struct sunxi_reset_data *data;
> +	struct resource *res;
> +
> +	data =3D devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	data->membase =3D devm_request_and_ioremap(&pdev->dev, res);
> +	if (!data->membase)
> +		return -ENOMEM;
> +
> +	data->rcdev.owner =3D THIS_MODULE;
> +	data->rcdev.nr_resets =3D resource_size(res) * 32;
> +	data->rcdev.ops =3D &sunxi_reset_ops;
> +	data->rcdev.of_node =3D pdev->dev.of_node;
> +
> +	return reset_controller_register(&data->rcdev);
>  }
> =20
>  static int sunxi_reset_remove(struct platform_device *pdev)

If you're switching to devm_ functions, you'll also have to remove the
iounmap and kfree in the _remove.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--K9fy5ol1Oes4Q/ix
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTXuP6AAoJEBx+YmzsjxAghkQP/2HNZ9/2psG+7WcEfBvofxV3
9F0sYdlryt2J105YIJoImB6pYPia0yuni6GBg95IBd+nQ8ieS/34U/UegesARPXM
XrK9fxtburtARaFyxKvVJoUD0B0r3m4Ua6xPZH3NCHTxMOAu2XByCQQKaIihIONC
WTpWv/TGB4PD7LxyfPLsKD1md7NJiowdYN+0Y8dR8wfVKEn4qt+1D2/xkWjO5Wvi
qGbJE7QXx0Q6fgrmddvdbPwHeljBQysK7BgjdvGQPXBkJ63Rekyk6SCcsLKwWHTV
b9AjkdyzxC+Q62VU1vhh550nTrtj/sf8e+IZSsPl7zHboUZxMNWLrb9Yq1zBRJ6x
Rjxl4Rkq9Atn4Pzrj+o6luMWlOMM+jFmcUt/eYyaOlosUHDK6Vd9izGZlL+wQ9jM
oxFsduNMe4YVjfM2WNiUN77TnOSSYzJgicXVHsewcqQLssIEO119UBzOFI9iEiy8
UyjEbxyIBNyEPqGRm1/FSchy0+50n1QwCuASN4pGIrZb3szCATstDHLNT51gyJOF
kJcO0UHXewlYafalPXzY4RcjQPUPJwuv8FxvpNAlM1Ibh27Z32uYzmoggVV1ZChb
MIPKjN0WM55itsPzsDJ2hh1RNH7PYqn+9llOG1wn7CWdkqnlD3SOGfETdstvySKm
9iHTnS8L0f93gLaQNl5U
=g962
-----END PGP SIGNATURE-----

--K9fy5ol1Oes4Q/ix--
