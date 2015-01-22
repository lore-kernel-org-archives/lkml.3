Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbbAVOp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:45:28 -0500
Received: from sauhun.de ([89.238.76.85]:41492 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbbAVOp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:45:27 -0500
Date: Thu, 22 Jan 2015 15:45:22 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-ocores: add common clock support
Message-ID: <20150122144522.GF3413@katana>
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Il7n/DHsA0sMLmDu"
Content-Disposition: inline
In-Reply-To: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Il7n/DHsA0sMLmDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> @@ -320,9 +322,23 @@ static int ocores_i2c_of_probe(struct platform_devic=
e *pdev,
>  	}
> =20
>  	if (of_property_read_u32(np, "clock-frequency", &val)) {
> -		dev_err(&pdev->dev,
> -			"Missing required parameter 'clock-frequency'\n");
> -		return -ENODEV;
> +		struct clk *clk =3D devm_clk_get(&pdev->dev, NULL);
> +
> +		if (!IS_ERR(clk)) {
> +			int ret =3D clk_prepare_enable(clk);
> +
> +			if (ret) {
> +				dev_err(&pdev->dev,
> +					"clk_prepare_enable failed: %d\n", ret);
> +				return ret;
> +			}
> +			i2c->clk =3D clk;
> +			val =3D clk_get_rate(clk);
> +		} else {
> +			dev_err(&pdev->dev,
> +				"Missing required parameter 'clock-frequency'\n");
> +			return -ENODEV;
> +		}

Either NAK or I don't understand the logic here :) If a dts does NOT
have the bus-speed set by 'clock-frequency', then we take the value of
the clock assigned to this platform_device?

The usual thing to do when 'clock-frequency' is not set is to default to
100kHz.


--Il7n/DHsA0sMLmDu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwQ0BAAoJEBQN5MwUoCm2KskP/0D6PCki5rw68rprNyaHhm05
blVUkm0iQ9xh4ftchbsWSPyXI5sD+c5lgJ6gYuIk1kLw0+ELtI7rGe99K2Gh2Zaz
6dy3m7Fa37HTs/t2oHBL0WlrDWEGxuKQqMAxiTpI3j+HVkPXN8BzYB1PJwWXpVh6
9cHcJ7o6arD/OZMUiUPpHihTNfx/WPAGel1laMaZ5SBKs74MLB6EGF/jz/dlyoum
iv4HCUQowrQiG8G+ASPpFtVPvqGHY0FH/1Wtzg9bYujfV4bYNH1xQGL7hBqaka8J
p/LOeAJEI+U0Wj3sJQAjwJXM7+mrsDhNcR6CGFq4uauDTw3AoZBFdfiSNrr6LvT7
3Ugr+b6ZRO8Nw8/O9KAbUGVkA2riW5l5ArzyyZBrRA/MaY31wdV5vEJHXogUlBr0
GXpgY1EawyqVeKbcjUh9sE7Zmh51fmUdOriE2w5Xb1rxCAmwlgg8cWBJVqJZHWrq
AAB65k4HfOXSjROS3NV5v05fdOd67FBjSNArxoTlNki3d0owsRHE7TkYMmaCTr7Q
LKxWZJAlc/0UDGW6bIpaaGW5v+ipfueWuxeh5SxeQHL3NBhhLAuYYM9Xpklu0o83
AMhi/vDYbLReShaG7qsU+XIPV5De5gL1svY7jvbCpFEskLpPW8wthOSvqQdRSWM+
14Fgri5DeJjwz7K2an1m
=LOwu
-----END PGP SIGNATURE-----

--Il7n/DHsA0sMLmDu--
