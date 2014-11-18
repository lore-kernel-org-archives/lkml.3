Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaKRQjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:39:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49716 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbaKRQjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:39:18 -0500
Date: Tue, 18 Nov 2014 10:39:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
CC: <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH] Fixes: 1d7afc9 i2c: omap: ack IRQ in parts
Message-ID: <20141118163921.GB6179@saruman>
Reply-To: <balbi@ti.com>
References: <1416242517-29885-1-git-send-email-al.kochet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <1416242517-29885-1-git-send-email-al.kochet@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 08:41:57PM +0400, Alexander Kochetkov wrote:
> commit 1d7afc95946487945cc7f5019b41255b72224b70 (i2c: omap: ack IRQ in pa=
rts)
> changed the interrupt handler to complete transfers without clearing
> XRDY (AL case) and ARDY (NACK case) flags. XRDY or ARDY interrupts will be
> fired again. As a result, ISR keep processing transfer after it was alrea=
dy
> complete (from the driver code point of view).
>=20
> A didn't see real impacts of the 1d7afc9, but it is really bad idea to
> have ISR running on user data after transfer was complete.
>=20
> It looks, what 1d7afc9 violate TI specs in what how AL and NACK should be
> handled (see Note 1, sprugn4r, Figure 17-31 and Figure 17-32).
>=20
> According to specs (if I understood correctly), in case of NACK and AL dr=
iver
> must reset NACK, AL, ARDY, RDR, and RRDY (Master Receive Mode), and
> NACK, AL, ARDY, and XDR (Master Transmitter Mode).
>=20
> All that is done down the code under the if condition:
> if (stat & (OMAP_I2C_STAT_ARDY | OMAP_I2C_STAT_NACK | OMAP_I2C_STAT_AL)) =
=2E..
>=20
> The patch restore pre 1d7afc9 logic of handling NACK and AL interrupts, so
> no interrupts is fired after ISR informs the rest of driver what transfer
> complete.
>=20
> Note: instead of removing break under NACK case, we could just replace 'b=
reak'
> with 'continue' and allow NACK transfer to finish using ARDY event. I fou=
nd
> that NACK and ARDY bits usually set together. That case confirm TI wiki:
> http://processors.wiki.ti.com/index.php/I2C_Tips#Detecting_and_handling_N=
ACK
>=20
> In order if someone interested in the event traces for NACK and AL cases,
> I sent them to mailing list.
>=20
> Tested on Beagleboard XM C.
>=20
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> Cc: <stable@vger.kernel.org> # v3.7+

This is good, but subject is wrong. That fixes line should not be the
subject, it should be here after Cc :-)

Other than that, I'd just ask for Aaro to test on his legacy systems.

> ---
>  drivers/i2c/busses/i2c-omap.c |    2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index 90dcc2e..9af7095 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -926,14 +926,12 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
>  		if (stat & OMAP_I2C_STAT_NACK) {
>  			err |=3D OMAP_I2C_STAT_NACK;
>  			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
> -			break;
>  		}
> =20
>  		if (stat & OMAP_I2C_STAT_AL) {
>  			dev_err(dev->dev, "Arbitration lost\n");
>  			err |=3D OMAP_I2C_STAT_AL;
>  			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_AL);
> -			break;
>  		}
> =20
>  		/*
> --=20
> 1.7.9.5
>=20

--=20
balbi

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa3Y5AAoJEIaOsuA1yqREPxgP/1+MSBUF3bHMkD9fmaqJ1z2C
BVWsNXhVtNyjzHhCRiJRgRy+F6GV0qGHi11YdmRpI86Qx5SLzLcY36LJt/9zU6rS
E1tT/uIX/FHyEaAbNnZmQjrV/4mRJLmVEcARskzTOQzIyosMrlD5z70KqvkVlJ6N
n/mL9arYlufYibYGZCXmxhjCw26wZuvvanq9qGALWDrX6uzS06OzJYzygC8c9a1v
mcqrwjgtgWvk8UbNfKLXnEX9Wo98s4ArTMd05oy29TINiEbtjyDCUnFpJNYgfmKe
B5nLnDzIc5HOocZjUWCZiRNTqFnesep//bLta7hV0UFSNnCWKY/XQ7/qIkZfGkxU
1ib+tMkDRoAIG9C/3KZOB/I/CFBklzszY6X8BB6Lbet5pz6BjdMShoaf6mYBfgDO
v8YFeum8QCptFcHgH2uyAu5qeMx5vArW8XuIzd9Z1ek2lMUYKDZ+GBC1JEhyGW6/
upr0B28B3rgCNpKQHtIVxGwFmkfM7hFV3WLo9XAnjaps613ezPjvMLM2GDfmaYQz
7be0ywgpA8g+iP9zN1valQqDhS8l/gMWLDLoL79WBS9fwc8uXaRxlQm5FcNT9k27
9Zk6odD+xckjmH60DknsEH296vMeZA63rxTTqKTAx88ARM9EFLXRqzSjZzfuJlJj
E79TQZThRXqjTIzn88I8
=IiW9
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
