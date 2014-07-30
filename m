Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaG3Lrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:47:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47383 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaG3Lrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:47:49 -0400
Message-ID: <53D8DB3D.7030403@pengutronix.de>
Date: Wed, 30 Jul 2014 13:47:09 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
References: <cover.1405428166.git.stefan@agner.ch> <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch> <53C5398F.2000005@pengutronix.de> <1b8a8ca03b4a160027a79b722f697e25@agner.ch> <601adb6fe47279c115c1cc607365a00e@agner.ch> <53D25C9D.5080803@pengutronix.de> <e88108c655e2c16dc9cf6c4194547e73@agner.ch> <53D67A46.3060202@pengutronix.de> <b815c5c1f7faed334d1ed5370d51c180@agner.ch>
In-Reply-To: <b815c5c1f7faed334d1ed5370d51c180@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="EBHREmTE9hk3Sc9v2BAQ4CrwIAAScgr20"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EBHREmTE9hk3Sc9v2BAQ4CrwIAAScgr20
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/29/2014 09:29 AM, Stefan Agner wrote:
> Am 2014-07-28 18:28, schrieb Marc Kleine-Budde:
>> On 07/28/2014 06:20 PM, Stefan Agner wrote:
>>> I'm not sure whether you really want to keep the FLEXCAN_CTRL_ERR_STA=
TE
>>> commented out...
>>
>> No, please remove this change and redo the test.
>>
>=20
> Ok, removed that change and did the tests again:
>=20
> =3D=3D Wrong Bitrate test
>=20
> [  146.485022] flexcan 40020000.flexcan can0: bitrate error 0.7%
> [  148.401793] flexcan 40020000.flexcan can0: writing ctrl=3D0x17092001=

> [  148.408263] flexcan 40020000.flexcan can0: flexcan_set_bittiming:
> mcr=3D0x5980000f ctrl=3D0x17092001
> [  148.408298] flexcan 40020000.flexcan can0: flexcan_chip_start:
> writing mcr=3D0x79a20208
> [  148.408328] flexcan 40020000.flexcan can0: flexcan_chip_start:
> writing ctrl=3D0x1709ac51
> [  148.414373] flexcan 40020000.flexcan can0: flexcan_chip_start:
> reading mcr=3D0x60a20208 ctrl=3D0x1709ac51
> ^---- Initialization
> [  152.968685] flexcan_irq, esr=3D00040080
> [  152.972386] flexcan_irq, ctrl=3D1709ac51
> [  155.488623] flexcan_irq, esr=3D00040080
> [  155.492326] flexcan_irq, ctrl=3D1709ac51
> ^---- Two messages with right bitrate
> [  171.014124] flexcan_irq, esr=3D00058d0a
> [  171.017823] flexcan_irq, ctrl=3D1709ac51
> ^---- One message with wrong bitrate
> [  171.021631] flexcan 40020000.flexcan can0: Error Warning IRQ
> [  171.021660] flexcan 40020000.flexcan can0: Error Passive IRQ

Thanks for the test, so far looks promising :) With this setup the other
CAN node repeats the CAN frame until it's ACKed. Because there is no
node with a compatible bitrate, there is no ACking CAN node.

Can you add a third CAN node to the network. The second and third node
should use the same bitrate, while your vf610 uses a different one. With
the new setup it should take more than one frame until the vf610 goes
into error warning and even more frames to error passive. This way we
can see it the error warning interrupt is connected or not. The error
counters should increase with each "wrong" bitrate frame it sees, you
can check with:

    ip -details link show can0

The output looks like this:

> 4: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN=
 mode DEFAULT qlen 10
>     link/can
>     can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
                              ^^^^^^^^^^^^^^^^^^^^^^
>     bitrate 1000000 sample-point 0.750
>     tq 125 prop-seg 2 phase-seg1 3 phase-seg2 2 sjw 1
>     sja1000: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..64 brp-inc 1
>     clock 8000000

When one of the berr-counter crosses 96 (and stays below 128) a warning
interrupt should be generated.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--EBHREmTE9hk3Sc9v2BAQ4CrwIAAScgr20
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPY2z0ACgkQjTAFq1RaXHNpmgCcDJ/4wFxUcXv9bsx2/Fi60ezF
YP0AnRKWDhvmaCOthoWfKPGGaNwYEHb5
=f9UO
-----END PGP SIGNATURE-----

--EBHREmTE9hk3Sc9v2BAQ4CrwIAAScgr20--
