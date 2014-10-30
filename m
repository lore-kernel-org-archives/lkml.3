Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbaJ3O2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:28:03 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55525 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737AbaJ3O2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:28:00 -0400
Date: Thu, 30 Oct 2014 15:27:54 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Delay I2C OF IRQ mapping until probe time
Message-ID: <20141030142752.GB20072@ulmo.nvidia.com>
References: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <1414677578-27412-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 03:59:35PM +0200, Laurent Pinchart wrote:
> Hello,
>=20
> I recently ran into an issue with the OF IRQ parsing code in the I2C core
> (of_i2c_register_devices in drivers/i2c/i2c-core.c).
>=20
> My DT contains the following nodes.
>=20
>         gpio1: gpio@e6051000 {
>                 ...
>                 #interrupt-cells =3D <2>;
>                 interrupt-controller;
>                 clocks =3D <&mstp9_clks R8A7790_CLK_GPIO1>;
>         };
>=20
>         iic2: i2c@e6520000 {
>                 #address-cells =3D <1>;
>                 #size-cells =3D <0>;
>                 ...
>                 hdmi@39 {
>                         compatible =3D "adi,adv7511w";
>                         reg =3D <0x39>;
>                         interrupt-parent =3D <&gpio1>;
>                         interrupts =3D <15 IRQ_TYPE_EDGE_FALLING>;
>                         ...
>                 };
>         };
>=20
>         mstp9_clks: mstp9_clks@e6150994 {
>                 ...
>         };
>=20
> The i2c@e6520000 node is probed before the gpio@e6051000 node. The
> of_i2c_register_devices() function tries to register all children, includ=
ing
> hdmi@39. It tries to parse and map the I2C client IRQ by calling
> irq_of_parse_and_map(), which returns 0 as the interrupt controller isn't
> probed yet. The adv7511 driver later probes the hdmi@39 device and gets
> client->irq set to 0.
>=20
> As we can't control the probe order in the general case we need to rely on
> deferred probing. This patch series is an attempt to do so, by moving IRQ
> mapping from device registration time to device probe time were probing c=
an be
> deferred.
>=20
> Laurent Pinchart (3):
>   of/irq: Export of_irq_get()
>   i2c: core: Dispose OF IRQ mapping at client removal time
>   i2c: core: Map OF IRQ at probe time
>=20
>  drivers/i2c/i2c-core.c | 14 ++++++++++++--
>  drivers/of/irq.c       |  1 +
>  2 files changed, 13 insertions(+), 2 deletions(-)

The series:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUkroAAoJEN0jrNd/PrOhAzoP/2WuRKqgArHTXF77nL2ZfHbq
eRJAJff/uKi7MzgBLOlNuEfxxReQR005tUKRozHfR3m/+Sqxo2b4SFkF0Q2Ps6OR
Szzb2gOVw2UGE6uLturZXs3R09mPGbhj+mJtKzvD3hvQslL39u8ybhf57/6NQTMB
lbV3bKzAVoS+r1CxEn/FcNQm1Ossx0sXY6PgR9pquybGuRyeBCsmdALY+sa2lH6E
JJl+Hh5C0BEQRODRLJsCQufvJoO5Veoa9KVelhMPkBx/hCj50x/Mgyye84YXhAcO
0ON/pRgPzL9uyfs8V3ELHi7UWyMjF1s0sNdn03BBrzMpFra6Ti63Hlem66eOoja+
hJdNflAgQ7aZQQRmM9p5bEhwu0H6hO9QTjrc/CrECO0T4UINru0iy2AcFFE7CnSh
3D1p/xFcBfG1UCJ8iZKoHbT2czrPB3xtpeW2/OE57q9Lk7acHQn4wv0eqY4YXsG4
lv4jDsZOmwW2CFB86fflu5W8mBPcfx+w/2sqwtzx6pWuzz46OzsvoLbcJ8AIBpQc
ecs86r+MOIhxP2C/4TEOj+FeQ1woAD1lMf04riV5+YR/Q52uJDDdF1elkC5SLjBl
/PC8kGT8igShadx1FSUMGXZwHYmbmZDjQWqTrFFS4cvNzHAnk5pTyGfqPnU4ffc+
df5ty2bMoNeMpoejKorA
=ayYQ
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
