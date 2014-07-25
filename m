Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbaGYNdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:33:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52955 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaGYNd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:33:29 -0400
Message-ID: <53D25C9D.5080803@pengutronix.de>
Date: Fri, 25 Jul 2014 15:33:17 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
References: <cover.1405428166.git.stefan@agner.ch> <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch> <53C5398F.2000005@pengutronix.de> <1b8a8ca03b4a160027a79b722f697e25@agner.ch> <601adb6fe47279c115c1cc607365a00e@agner.ch>
In-Reply-To: <601adb6fe47279c115c1cc607365a00e@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pPnjE0bDvFk6fpRfxPEFe7RcU9PNtW3RO"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pPnjE0bDvFk6fpRfxPEFe7RcU9PNtW3RO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/25/2014 12:50 PM, Stefan Agner wrote:
> Am 2014-07-16 08:43, schrieb Stefan Agner:
>> Am 2014-07-15 16:24, schrieb Marc Kleine-Budde:
>> <snip>
>>>> @@ -150,18 +171,20 @@
>>>>   * FLEXCAN hardware feature flags
>>>>   *
>>>>   * Below is some version info we got:
>>>> - *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT
>>>> - *                                Filter?   connected?
>>>> - *   MX25  FlexCAN2  03.00.00.00     no         no
>>>> - *   MX28  FlexCAN2  03.00.04.00    yes        yes
>>>> - *   MX35  FlexCAN2  03.00.00.00     no         no
>>>> - *   MX53  FlexCAN2  03.00.00.00    yes         no
>>>> - *   MX6s  FlexCAN3  10.00.12.00    yes        yes
>>>> + *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT  Memory err
>>>> + *                                Filter?   connected?  detection
>>>> + *   MX25  FlexCAN2  03.00.00.00     no         no         no
>>>> + *   MX28  FlexCAN2  03.00.04.00    yes        yes         no
>>>> + *   MX35  FlexCAN2  03.00.00.00     no         no         no
>>>> + *   MX53  FlexCAN2  03.00.00.00    yes         no         no
>>>> + *   MX6s  FlexCAN3  10.00.12.00    yes        yes         no
>>>> + *   VF610 FlexCAN3  ?               no         no        yes
>>>                                         ^^         ^^
>>>
>>> Can you check the datasheet if the flexcan core has a "Glitch Filter
>>> Width Register (FLEXCANx_GFWR)"
>>
>>
>> There is no such register called GFWR/Glitch Filter or similar.
>>
>>> Can you check if the core generates a warning interrupt with the curr=
ent
>>> setup, if you don't switch on bus error reporting? This means interna=
lly
>>> the [TR]WRN_INT is connected and works as specified.
>>
>> Ok, so I disabled TWRNMSK (Bit 11) in the control register and printed=

>> out the error and status register (ESR1), this is what I get:
>> [  191.285295] flexcan_irq, esr=3D00040080
>> [  191.288996] flexcan_irq, ctrl=3D17092051
>>
>> Bit 17 (TWRNINT) is not set while TWRNMSK is disabled. Hence [TR]WRN_I=
NT
>> is not connected?
>=20
> Ping. Anything open/to do from my side?

Please keep the printing of esr and ctrl in the interrupt handler, add a
#define DEBUG in the driver, but do not change anything else. Then:

start the driver as usual:
- configure bitrate
- ifconfig can0 up
- _do_not_ enable bit error reporint
- start candump from gitorious with:
  candump -e any,0:0,#FFFFFFFF
- short circuit CAN-High and CAN-Low
- send a CAN frame

Another test is to setup a proper CAN bus, but configure the a second
CAN node with a different bitrate. Start the can0 on vf610 as usual,
then candump -e any,0:0,#FFFFFFFF, but do not send any CAN frames on the
vf610. Then on the other system keep sending CAN frames, you might have
to restart the CAN on the second system....

Please send the outputs of candump and demsg to the list. It should
generate a warning, error passive and finally a busoff message.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--pPnjE0bDvFk6fpRfxPEFe7RcU9PNtW3RO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPSXJ0ACgkQjTAFq1RaXHMUvACaAmVhIrTeaKFmIo1HBgticZZa
OIsAn1V3oBXR1eICI5zrteuR+mb4QrXg
=V+o+
-----END PGP SIGNATURE-----

--pPnjE0bDvFk6fpRfxPEFe7RcU9PNtW3RO--
