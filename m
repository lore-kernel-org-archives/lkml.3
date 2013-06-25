Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325Ab3FYQj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:39:26 -0400
Received: from sauhun.de ([89.238.76.85]:59931 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab3FYQjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:39:24 -0400
Date: Tue, 25 Jun 2013 18:39:02 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v9] i2c-designware: make SDA hold time configurable
Message-ID: <20130625163902.GA2973@katana>
References: <20130620203716.GF2961@katana>
 <1371808422-27742-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <1371808422-27742-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 21, 2013 at 11:53:42AM +0200, Christian Ruppert wrote:
> This patch makes the SDA hold time configurable through device tree.
>=20
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> ---
>  .../devicetree/bindings/i2c/i2c-designware.txt     |   14 ++++++++++++++
>  arch/arc/boot/dts/abilis_tb100_dvk.dts             |   10 +++++-----
>  arch/arc/boot/dts/abilis_tb101_dvk.dts             |   10 +++++-----

Vineet, an ack for those would be nice since I think it is better if I
take all this via I2C.

>  drivers/i2c/busses/i2c-designware-core.c           |   13 +++++++++++++
>  drivers/i2c/busses/i2c-designware-core.h           |    1 +
>  drivers/i2c/busses/i2c-designware-platdrv.c        |   10 ++++++++++
>  6 files changed, 48 insertions(+), 10 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/D=
ocumentation/devicetree/bindings/i2c/i2c-designware.txt
> index e42a2ee..3266cc7 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> @@ -10,6 +10,9 @@ Recommended properties :
> =20
>   - clock-frequency : desired I2C bus clock frequency in Hz.
> =20
> +Optional properties :
> + - i2c-sda-hold-time-ns : should contain the SDA hold time in nanosecond=
s.

Not on all versions, should be mentioned here.

> +
>  Example :
> =20
>  	i2c@f0000 {
> @@ -20,3 +23,14 @@ Example :
>  		interrupts =3D <11>;
>  		clock-frequency =3D <400000>;
>  	};
> +
> +	i2c@1120000 {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +		compatible =3D "snps,designware-i2c";
> +		reg =3D <0x1120000 0x1000>;
> +		interrupt-parent =3D <&ictl>;
> +		interrupts =3D <12 1>;
> +		clock-frequency =3D <400000>;
> +		i2c-sda-hold-time-ns =3D <300>;
> +	};
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busse=
s/i2c-designware-core.c
> index c41ca63..66119e2 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -67,9 +67,12 @@
>  #define DW_IC_STATUS		0x70
>  #define DW_IC_TXFLR		0x74
>  #define DW_IC_RXFLR		0x78
> +#define DW_IC_SDA_HOLD		0x7c
>  #define DW_IC_TX_ABRT_SOURCE	0x80
>  #define DW_IC_ENABLE_STATUS	0x9c
>  #define DW_IC_COMP_PARAM_1	0xf4
> +#define DW_IC_COMP_VERSION	0xf8
> +#define DW_IC_SDA_HOLD_MIN_VERS	0x3131312A
>  #define DW_IC_COMP_TYPE		0xfc
>  #define DW_IC_COMP_TYPE_VALUE	0x44570140
> =20
> @@ -332,6 +335,16 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
>  	dw_writel(dev, lcnt, DW_IC_FS_SCL_LCNT);
>  	dev_dbg(dev->dev, "Fast-mode HCNT:LCNT =3D %d:%d\n", hcnt, lcnt);
> =20
> +	/* Configure SDA Hold Time if required */
> +	reg =3D dw_readl(dev, DW_IC_COMP_VERSION);

Why not reading reg inside the if-block?

Thanks,

   Wolfram


--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRycemAAoJEBQN5MwUoCm2hDQP/il6TfROvbnm1zZ2FMk58W5d
+4Nhlq9Zb5ZihCSiSKKwodv3TQKF891tM7JUmMUTn4AULBdNzM+ujVefBXforukm
U5qIagClPzodtvc413ZZHlMFwpYZ7jNpDN3hrVDlAPTIBghCp1+p6os1gOguZCEq
VOYQnlyfzYH2BuHU1bOkpQxdaT9mDPRtamylyp589PhXFkHSGGumSMHXN15dPtZk
0LYPpnMLTh1ZHqM1DjASaW60kqrib6Y57t3VBgv1BPY5j6inxrMq7IvnhBEs6GNq
g31GLQxaYsM2unXY5tJ4zb4kGtpKhxG/8Zt4efEYUo+zXjrgY2EjjlnweLIHftOh
61P5CWwMjXW1EjBoCHJVKirecYILLIMAoiAadNhoIYQTgHevLKTRa5sBRcGGeDZh
JbWgttJ75+OiCgaJOpMBBXAzHm3Hnb0Gr4d4ZgKSrzMWZddjDRRZC1LtTfIP8nQd
ARRSqZVTW3Yr88DittK8e0SPl92DqbgoarAOzUQ/ZkUTinisJj6GybQLW+6nMiXQ
e8RXD0qZsv4XAV/GjisSvLZeZigLGtiR4rJ4ho7d3KPenvojtY41ZQtglpR16QCF
E/3ou4MuGxsnmQdb/Q+Xcra+f1QXiEBcChudeg/QA7pIHrH9LTybuxnCvwedgHhZ
e35TBxjv6/qrzwyeMoCP
=KT5L
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
