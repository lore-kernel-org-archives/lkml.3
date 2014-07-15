Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaGON6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:58:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38973 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaGON55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:57:57 -0400
Message-ID: <53C5335A.8000000@pengutronix.de>
Date: Tue, 15 Jul 2014 15:57:46 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>,
        Stefan Agner <stefan@agner.ch>
CC: shawn.guo@freescale.com, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: flexcan: switch on clocks before accessing
 ecr register
References: <cover.1405428166.git.stefan@agner.ch>	<c80f9d2ec80d01088e51be61a4e7845cbfe58f6a.1405428166.git.stefan@agner.ch> <20140715155426.3c03f0d8@ipc1.ka-ro>
In-Reply-To: <20140715155426.3c03f0d8@ipc1.ka-ro>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gQlpRQJivDdsb50FwnCKnb94kx9WBgf73"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gQlpRQJivDdsb50FwnCKnb94kx9WBgf73
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/15/2014 03:54 PM, Lothar Wa=C3=9Fmann wrote:
> Hi,
>=20
> Stefan Agner wrote:
>> Reported-by: Ashutosh Singh <ashuleapyear@gmail.com>
>> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
>> [stefan@agner.ch: added return check for clk_enable_prepare]
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  drivers/net/can/flexcan.c | 18 ++++++++++++++++--
>>  1 file changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
>> index f425ec2..89745aa 100644
>> --- a/drivers/net/can/flexcan.c
>> +++ b/drivers/net/can/flexcan.c
>> @@ -383,12 +383,26 @@ static int flexcan_get_berr_counter(const struct=
 net_device *dev,
>>  {
>>  	const struct flexcan_priv *priv =3D netdev_priv(dev);
>>  	struct flexcan_regs __iomem *regs =3D priv->base;
>> -	u32 reg =3D flexcan_read(&regs->ecr);
>> +	u32 reg, err;
>> +
>> +	err =3D clk_prepare_enable(priv->clk_ipg);
>> +	if (err)
>> +		return err;
>> +
>> +	err =3D clk_prepare_enable(priv->clk_per);
>> +	if (err)
>> +		goto out_disable_ipg;
>> +
>> +	reg =3D flexcan_read(&regs->ecr);
>> =20
> flexcan_get_berr_counter() may be called from interrupt context and
> thus must not call any functions that can sleep.
> Compiling the driver with CONFIG_DEBUG_ATOMIC_SLEEP would catch this!

It's called from the NAPI softirq. I'll prepare a patch.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--gQlpRQJivDdsb50FwnCKnb94kx9WBgf73
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPFM1oACgkQjTAFq1RaXHPTYwCdEg/o1Jzknjj3JZtF02gvb7/I
k1kAoIQ7DpBU31w9Mnyf9idyzUY4Rua1
=9YI7
-----END PGP SIGNATURE-----

--gQlpRQJivDdsb50FwnCKnb94kx9WBgf73--
