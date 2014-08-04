Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaHDO3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:29:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40680 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaHDO3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:29:32 -0400
Message-ID: <53DF9865.9060407@pengutronix.de>
Date: Mon, 04 Aug 2014 16:27:49 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
References: <cover.1405428166.git.stefan@agner.ch> <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch> <53C5398F.2000005@pengutronix.de> <1b8a8ca03b4a160027a79b722f697e25@agner.ch> <601adb6fe47279c115c1cc607365a00e@agner.ch> <53D25C9D.5080803@pengutronix.de> <e88108c655e2c16dc9cf6c4194547e73@agner.ch> <53D67A46.3060202@pengutronix.de> <b815c5c1f7faed334d1ed5370d51c180@agner.ch> <53D8DB3D.7030403@pengutronix.de> <cd33e1b365502ec0cb3b5bee6dc4fb61@agner.ch>
In-Reply-To: <cd33e1b365502ec0cb3b5bee6dc4fb61@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tJgfE2X7QWStTT1sEo467AWFTmKMwOUi3"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tJgfE2X7QWStTT1sEo467AWFTmKMwOUi3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/04/2014 03:43 PM, Stefan Agner wrote:
[...]

>> Thanks for the test, so far looks promising :) With this setup the oth=
er
>> CAN node repeats the CAN frame until it's ACKed. Because there is no
>> node with a compatible bitrate, there is no ACking CAN node.
>>
>> Can you add a third CAN node to the network. The second and third node=

>> should use the same bitrate, while your vf610 uses a different one. Wi=
th
>> the new setup it should take more than one frame until the vf610 goes
>> into error warning and even more frames to error passive. This way we
>> can see it the error warning interrupt is connected or not. The error
>> counters should increase with each "wrong" bitrate frame it sees, you
>> can check with:
>>
>>     ip -details link show can0
>>
>> The output looks like this:
>>
>>> 4: can0: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNO=
WN mode DEFAULT qlen 10
>>>     link/can
>>>     can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0
>>                               ^^^^^^^^^^^^^^^^^^^^^^
>>>     bitrate 1000000 sample-point 0.750
>>>     tq 125 prop-seg 2 phase-seg1 3 phase-seg2 2 sjw 1
>>>     sja1000: tseg1 1..16 tseg2 1..8 sjw 1..4 brp 1..64 brp-inc 1
>>>     clock 8000000
>>
>> When one of the berr-counter crosses 96 (and stays below 128) a warnin=
g
>> interrupt should be generated.
>=20
> Ok, created this setup, could successfully communicate with all three
> nodes. I then set the Vybrid to half of the bitrate. When I send a fram=
e
> from Vybrid, the berr-counter tx immediately ends up at 128 and the
> device is in ERROR-PASSIVE:

This is expected.

> root@colibri-vf:~# ip -details link show can1
> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN=

> mode DEFAULT group default qlen 10
>     link/can  promiscuity 0=20
>     can state ERROR-ACTIVE (berr-counter tx 0 rx 0) restart-ms 0=20
>     bitrate 124990 sample-point 0.739=20
>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>     clock 83368421
            ^^^^^^^^

BTW: the can core has a really weird clock rate, have a look at the
datasheet if you manage to route a 24 MHz clock (or another multiple of
8MHz) to the flexcan core. I had a quick glance at the datasheet, if I
understand it correctly the Fast OSC clock runs with 24 MHz.

> root@colibri-vf:~# cansend can1 1F334455#1122334455667788
> interface =3D can1, family =3D 29, type =3D 3, proto =3D 1
> root@colibri-vf:~# [  818.886664] flexcan_irq, esr=3D00062242
> [  818.890365] flexcan_irq, ctrl=3D1c3dac57
>=20
> root@colibri-vf:~# ip -details link show can1
> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN=

> mode DEFAULT group default qlen 10
>     link/can  promiscuity 0=20
>     can state ERROR-PASSIVE (berr-counter tx 128 rx 0) restart-ms 0=20
>     bitrate 124990 sample-point 0.739=20
>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>     clock 83368421
>=20
>=20
> When I send the frames from another device on the bus, I can see the rx=

> count incrementing by one on each frame I send. As you expected, the
> device changes to ERROR-WARNING when crossing the 96 frame boundary:

This is correct

> root@colibri-vf:~# ip -details link show can1
> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN=

> mode DEFAULT group default qlen 10
>     link/can  promiscuity 0=20
>     can state ERROR-ACTIVE (berr-counter tx 0 rx 92) restart-ms 0=20
>     bitrate 124990 sample-point 0.739=20
>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>     clock 83368421
> root@colibri-vf:~# [  448.331150] flexcan_irq, esr=3D0005050a
> [  448.334851] flexcan_irq, ctrl=3D1c3dac57
> ip -details link show can1
> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN=

> mode DEFAULT group default qlen 10
>     link/can  promiscuity 0=20
>     can state ERROR-WARNING (berr-counter tx 0 rx 102) restart-ms 0=20
>     bitrate 124990 sample-point 0.739=20
>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>     clock 83368421

> However, once reaching 128, I don't get another interrupt and the devic=
e
> stays in ERROR-WARNING:

The contents of the esr reg would be interesting, especially the
FLT_CONF part.

> 3: can1: <NOARP,UP,LOWER_UP,ECHO> mtu 16 qdisc pfifo_fast state UNKNOWN=

> mode DEFAULT group default qlen 10
>     link/can  promiscuity 0=20
>     can state ERROR-WARNING (berr-counter tx 0 rx 128) restart-ms 0=20
>     bitrate 124990 sample-point 0.739=20
>     tq 347 prop-seg 8 phase-seg1 8 phase-seg2 6 sjw 1
>     flexcan: tseg1 4..16 tseg2 2..8 sjw 1..4 brp 1..256 brp-inc 1
>     clock 83368421
>=20
> Is this the expected behavior on receive?

No, it should go into error passive if one of the error counters have >
127. Maybe this is an error onthe vf610, maybe it's a general flexcan
problem.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--tJgfE2X7QWStTT1sEo467AWFTmKMwOUi3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPfmGUACgkQjTAFq1RaXHMnIgCgjzXvqCiZRIF9dachBnnzPkMw
x9EAnR0dNgTwcK+k2Zd5jOtYmu56nk5i
=r/U2
-----END PGP SIGNATURE-----

--tJgfE2X7QWStTT1sEo467AWFTmKMwOUi3--
