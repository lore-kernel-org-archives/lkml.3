Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab3FSToW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:44:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50987 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3FSToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:44:19 -0400
Date: Wed, 19 Jun 2013 22:44:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 3/5] i2c: omap: handle all irqs befor unblocking
 omap_i2c_xfer_msg()
Message-ID: <20130619194414.GF4779@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
 <1370630768-4077-4-git-send-email-grygorii.strashko@ti.com>
 <20130607190543.GD15295@arwen.pp.htv.fi>
 <51C1FBB8.4090600@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GV0iVqYguTV4Q9ER"
Content-Disposition: inline
In-Reply-To: <51C1FBB8.4090600@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GV0iVqYguTV4Q9ER
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 09:43:04PM +0300, Grygorii Strashko wrote:
> Hi Felipe,
> On 06/07/2013 10:05 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Fri, Jun 07, 2013 at 09:46:06PM +0300, Grygorii Strashko wrote:
> >>ARDY|NACK and ARDY|AL are set together in OMAP_I2C_STAT_REG, which will=
 be
> >Have you seen that happen ever ? AL is Arbitration Lost, we never put
> >OMAP in a multi-master environment before.
> This is an example from real life:
> [    0.271942] omap_i2c omap_i2c.1: bus 1 rev2.4.0 at 400 kHz
> [    1.283416] omap_i2c omap_i2c.1: timeout waiting for bus ready
> [    1.300109] OMAP_I2C DEBUG: stat=3D1001
> [    1.300140] omap_i2c omap_i2c.1: Arbitration lost
> [    1.300140] OMAP_I2C DEBUG: IE=3D601F
> [    1.300140] OMAP_I2C DEBUG: STAT=3D1000
> [    1.300170] OMAP_I2C DEBUG: IV=3D636F
> [    1.300170] OMAP_I2C DEBUG: WE=3D636F
> [    1.300170] OMAP_I2C DEBUG: SYSS=3D1
> [    1.300170] OMAP_I2C DEBUG: BUF=3D707
> [    1.300201] OMAP_I2C DEBUG: CNT=3D1
> [    1.300201] OMAP_I2C DEBUG: DATA=3D1
> [    1.300201] OMAP_I2C DEBUG: SYSC=3D215
> [    1.300201] OMAP_I2C DEBUG: CON=3D8200
> [    1.300231] OMAP_I2C DEBUG: OA=3D0
> [    1.300231] OMAP_I2C DEBUG: SA=3D49
> [    1.300231] OMAP_I2C DEBUG: PSC=3D9
> [    1.300262] OMAP_I2C DEBUG: SCLL=3D9
> [    1.300262] OMAP_I2C DEBUG: SCLH=3D3
> [    1.300262] OMAP_I2C DEBUG: SYSTEST=3D1E0
> [    1.300262] OMAP_I2C DEBUG: BUFSTAT=3D4000
>=20
> and my headache now :..(

have you looked for erratas around that ? Maybe you just found a silicon
issue. Why is AL bit being set ? Have you tried to reach the IP owner ?

If there are no other I2C masters in the system, there will be no
arbitration, hence we would never loose the arbitration.

> >ARDY | NACK I also find it a bit hard for those two to happen together
> >since ARDY will be set when you can change controller's register
> >*again*, mening that a transfer has completed.
> There are examples:
> [    3.544952] omap_i2c 48060000.i2c: IRQ (ISR =3D 0x0006)
>=20
> [   25.574523] omap_i2c 48350000.i2c: IRQ (ISR =3D 0x0014)
> [   25.579925] omap_i2c 48350000.i2c: IRQ (ISR =3D 0x0012)
>=20
> to see it - enable debug output in omap_i2c_isr_thread:
>         dev_dbg(dev->dev, "IRQ (ISR =3D 0x%04x)\n", stat);

then you need to figure out why that's happening, right ? What do you do
to trigger that particular condition, have you looked in the wire to see
if you find a real NACK or is the OMAP I2C controller misbehaving ?

> >Also, we need to follow what the programming model says. And, I don't
> >have docs with me right now, but IIRC it tells us to bail out if any of
> >the error conditions are met.
> >
> yep, but first of all - all IRQs need to be acked before exit.

that's alright, then fix only that... OTOH, you don't want to ack a
read while data is still sitting in the FIFO, data you haven't read out
of the FIFO, I mean. Not sure if that could happen though.

--=20
balbi

--GV0iVqYguTV4Q9ER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwgoOAAoJEIaOsuA1yqREHy0P/3p6Rau2fPlfSbINn3EBc9hr
OY4e7n10+BBSkHyxbMR+/HktmXAB9pyaNZsnOvq4c/G+CFYOH3h0iNOMiyyZBpJt
AmKfbDCHoZM36vT5RdJNd5+8TnW7iktSQPCH0YbGXC8eP6MFic9alBWktpGuefw+
NgX0n55nE8NLBui2amn+DLw/LLoyLLpi+yMrMZWyszwzCifMQIoc8darJWd+GpSd
ZL0jDQeZX4b/hi3kM1zGGRdh+3Nn2zomvfcMk1Z2YgwQK3cs0OL7dQiDllCR2iJG
v65mIrpvkZ+i7NpWBMoo2RKlfimLErClfSdQaU1TI0fQ0d2hSvhlKEZ33IuK5KVE
QCe0hXvgZ4hPD4Bg71Sg0kiMSpIjNrhPXBBYyd0ai5GyDnnyFFIOzG9mtQbGPY8N
N3MLTTGNMHW5FUMNq0zpmeql1dJ+oMe7eyCArWOpsvqekLDuOMjJkf4P5guVIKrO
GV8VC5lpPvWF+mhlkrVgyI0isOV1ToxDjAShj+Fs6HQq4OCfZ3XHvAafrLTyfkVJ
hPWDzkqFy8Z4A3kLiFGkw+GHUQlfJAEXgoWpdz5SrEM3uoVHHcM9ZPAVSfbMM6qN
N1ARmNyAO53b0jButudBzSJuRz1CJmuQrFoW3yiQf40NdW0z+1pu8qhaEuJDd+UJ
dgraehmw2829flCJNZEM
=1MXA
-----END PGP SIGNATURE-----

--GV0iVqYguTV4Q9ER--
