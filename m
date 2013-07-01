Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab3GAGRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 02:17:30 -0400
Received: from sauhun.de ([89.238.76.85]:43703 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab3GAGR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 02:17:28 -0400
Date: Mon, 1 Jul 2013 08:17:22 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        taeggyun.ko@samsung.com, balbi@ti.com, thomas.abraham@linaro.org
Subject: Re: [PATCH v10] i2c: exynos5: add High Speed I2C controller driver
Message-ID: <20130701061722.GB2976@katana>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1371638905-30633-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <1371638905-30633-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 04:18:25PM +0530, Naveen Krishna Chatradhi wrote:
> Adds support for High Speed I2C driver found in Exynos5 and
> later SoCs from Samsung.
>=20
> Driver only supports Device Tree method.
>=20
> Changes since v1:
> 1. Added FIFO functionality
> 2. Added High speed mode functionality
> 3. Remove SMBUS_QUICK
> 4. Remove the debugfs functionality
> 5. Use devm_* functions where ever possible
> 6. Driver is free from GPIO configs
> 7. Use OF data string "clock-frequency" to get the bus operating frequenc=
ies
> 8. Split the clock divisor calculation function
> 9. Add resets for the failed transacton cases
> 10. Removed retries as core does retries if -EAGAIN is returned
> 11. Removed mode from device tree info (use speed to distinguish
>     the mode of operation)
> 12. Use wait_for_completion_timeout as the interruptible case is not test=
ed well
> 13. few other bug fixes and cosmetic changes
>=20
> Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Simon Glass <sjg@google.com>
> Tested-by: Andrew Bresticker <abrestic@google.com>
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> Signed-off-by: Andrew Bresticker <abrestic@google.com>
> ---
>=20
> +Optional properties:
> +  - clock-frequency: Desired operating frequency in Hz of the bus.
> +    -> If not specified, the default value is 100khz in fast-speed mode =
and
> +       1Mhz in high-speed mode.

? If not specified, the default is 100kHz. There is no way to get 1MHz,
or?

=2E..

> +static int exynos5_i2c_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct exynos5_i2c *i2c;
> +	struct resource *mem;
> +	unsigned int op_clock;

My compiler says:

drivers/i2c/busses/i2c-exynos5.c: In function =E2=80=98exynos5_i2c_probe=E2=
=80=99:
drivers/i2c/busses/i2c-exynos5.c:687:5: warning: =E2=80=98op_clock=E2=80=99=
 may be used uninitialized in this function [-Wuninitialized]

so...

> +	int ret;
> +
> +	if (!np) {
> +		dev_err(&pdev->dev, "no device node\n");
> +		return -ENOENT;
> +	}
> +
> +	i2c =3D devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL=
);
> +	if (!i2c) {
> +		dev_err(&pdev->dev, "no memory for state\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (of_property_read_u32(np, "clock-frequency", &op_clock)) {
> +		i2c->speed_mode =3D HSI2C_FAST_SPD;
> +		i2c->fs_clock =3D HSI2C_FS_TX_CLOCK;
> +	}
> +
> +	if (op_clock >=3D HSI2C_HS_TX_CLOCK) {

=2E.. this should be 'else if'

> +		i2c->speed_mode =3D HSI2C_HIGH_SPD;
> +		i2c->fs_clock =3D HSI2C_FS_TX_CLOCK;
> +		i2c->hs_clock =3D op_clock;
> +	} else {
> +		i2c->speed_mode =3D HSI2C_FAST_SPD;
> +		i2c->fs_clock =3D op_clock;
> +	}

=2E..

> +	i2c->bus_id =3D of_alias_get_id(i2c->adap.dev.of_node, "hsi2c");

Huh, the core already gets an alias for you. Can't you use 'adap.nr'?

Rest looks good.

Thanks!

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0R7yAAoJEBQN5MwUoCm2PxgP/Rx/YuLk8HofVWX1RIHerQ6v
Tp3Lx4H1OTBSMkXGKViz6mBtj7aOoBh5GiXC/tUgsInuMngU7q+ldZ0utYcR80Xo
Oewjzxh4qjjdOM7Ga+sH8u/SLRHU6gSSW//MS2911MoVe4qPgLpS7ACz9sgjlIeX
j4bBU3liKaJcm6VDTx0O6jeqcE2M4dzCsoFnBJmwnkpx0lmqbf6/XDS9aip4zA7Q
FscfNie9H8zVywJJb65YgjK5yniGS6H2wRPCxopx5mkl5zACIOOXYWaozz2G2svd
6Uv3YWe1OkzOrLaAWxU4Yu2uLzPH90E14DOyMfBqYMRAljOc66vgcA7yJGsTxF/p
ZUoufxo1iiX+myOywzytaxslLitVTD9DwHVHCAJcoM22dSMAGvPLxbivkdLAQywM
FSZQyLMc6EXjgDiWx8DGKMW7UmtyG64RcdwksWBeXs8/U4AR7Q7kUZcGZT7bh7cm
mZ8cXJuXWNLtfShIweJwNYW4og62tlcQPMJ/RGE/1RaYI2tlqyXlJi0ox9HIvaes
hvnrk5hNpXC26k2SjpjUArlBiSehuqHq1Wb63mFjBB/z0QSdhFB2kLg7XylM0wFc
SAqgmSLb01qGl6/aKSQyNndX2sRzmypXGXSAw7n69+1546wKA8CeeKnuzKvP+lRY
H1ep49GncAJ6epQOJUvO
=aJgi
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
