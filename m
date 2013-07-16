Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3GPL2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:28:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33550 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab3GPL2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:28:14 -0400
Date: Tue, 16 Jul 2013 14:27:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: <balbi@ti.com>, Hein Tibosch <hein_tibosch@yahoo.es>,
        Tony Lindgren <tony@atomide.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
Message-ID: <20130716112746.GN8880@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <51E50217.1000507@yahoo.es>
 <20130716090300.GG8880@arwen.pp.htv.fi>
 <51E5137B.7000302@yahoo.es>
 <20130716094212.GL8880@arwen.pp.htv.fi>
 <51E527F7.4080007@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KM+e2hnYAO+MCJ5e"
Content-Disposition: inline
In-Reply-To: <51E527F7.4080007@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KM+e2hnYAO+MCJ5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 16, 2013 at 02:01:11PM +0300, Grygorii Strashko wrote:
> >>>>On a OMAP4460, i2c-bus-3:
> >>>>
> >>>>A driver (lm75) is causing many 'timeout waiting for bus ready' error=
s.
> >>>>SDA remains high (as it should), but SCL remains low after a NACK.
> >>>>The bus becomes _unusable for other clients_.
> >>>>
> >>>>While probing, "lm75" writes a command, followed by a read + stop,
> >>>>but the write command is NACK'd. The chip does accept other writes/re=
ads,
> >>>>it just refuses to ack invalid commands.
> >>>>
> >>>>Can you tell me if the patch below would make any sense? Or is it the
> >>>>responsibility of the client to reset the i2c_smbus?
> >>>patch below breaks repeated start.
> Felipe, I'd very appreciate if you'd be able to provide the use case
> which will fail with such solution?

can't you see how this would fail ?

assume omap_i2c_xfer() is called with its last argument (num) being
greater than one and you get the NAK before the last transfer.

Will you not be breaking a possible repeated start for the following
transfer ?

> >>No, after the NACK, no more commands are being processed,
> >>including a repeated start. omap_i2c_xfer() returns -EREMOTEIO
> >>without ever freeing the bus.
> >>
> >>The bus is left in an impossible state with SCL constantly low
> >>and all next commands (to different chips) will therefore get
> >>a -ETIMEDOUT
> >>
> >>With this patch, the bus will become idle again and new commands
> >>can be processed normally
> I think, this is valid fix, but it was done here already:)
> http://patchwork.ozlabs.org/patch/249790/
> "i2c: omap: query STP always when NACK is received"
>=20
> And nacked in the same way :(
> But! I've back-ported my patch on TI Android product kernel 3.4, did
> sanity test and I didn't see any issues with my patch :))

that's because you don't care about repeated start, but that's a valid
bus signal which needs to be supported.

> >but you mentioned that if you have IGNORE_NAK set, everything is fine,
> >since lm75 will get a return value of 0 and things will work just fine,
> >right ?
> >
> >Also, you also said that the chip 'refuses to ack invalid commands', why
> >are you sending invalid commands to start with ? This could be a bug in
> >i2c-omap.c, sure, but let's try to figure out why IGNORE_NAK helps and
> >why is lm75 driver sending invalid commands.
> >
>=20
> The problem is, that lm75 device is SmBus compatible and its driver has
> .detect() function implemented. During detection it tries to scan some
> registers which might be not present in current device - in my case
> it's tmp105.
>=20
> For example to read regA in tmp105 following is done:
> 1) do write in "Index" register (val RegA index) (I2C 1st message)
> 2) do read (I2C 2d message)
> the message 1 is Nacked by device in case if register index is wrong,
> but i2c-omap don't send NACK (or STP). As result, bus stack in Bus
> Busy state.

wait a minute, it's not i2c-omap which needs to send NAK, it's LM75,
and it does the NAK. The handling for NAK in the i2c framework is to
return -EREMOTEIO as we do. If our last message got a NAK, we send STOP
because there will be no other transfers following this one, namely, the
for loop in omap_i2c_xfer() will be finished.

> For SMBus devices the specification states (http://smbus.org/specs/)
> "4.2.Acknowledge (ACK) and not acknowledge (NACK)":
> - "The slave device detects an invalid command or invalid data. In this
> case the slave device must not acknowledge the received byte. The
> master upon detection of this condition must generate a STOP condition
> and retry the transaction"

hmm, but that's something that the OMAP I2C controller doesn't support
and is emulated by the i2c framework, right ?

If you look into the I2C specification, the one the OMAP controller is
compliant to, you'll see e.g. in Figure 13 that a repeated start is a
valid condition after a NAK.

Also it states that:

"This is indicated by the slave generating the not-acknowledge on the
first byte to follow. The slave leaves the data line HIGH and the master
generates a STOP or a repeated START condition."

Because the OMAP I2C controller is compliant to the I2C specification,
not the SMBus specification, we must follow through with the loop and
let the next message try to send a repeated start.

What you need here is a way to discriminate between SMBus message and
normal I2C message, that way you could have something like:

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 142b694d..571b160 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -618,7 +618,7 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
        if (dev->cmd_err & OMAP_I2C_STAT_NACK) {
                if (msg->flags & I2C_M_IGNORE_NAK)
                        return 0;
-               if (stop) {
+               if (stop || is_smbus) {
                        w =3D omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
                        w |=3D OMAP_I2C_CON_STP;
                        omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);

and, btw, this also means that I2C_M_IGNORE_NAK is invalid during SMBus
transfers, so you might want to patch the framework to prevent that case
altogether.

--=20
balbi

--KM+e2hnYAO+MCJ5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5S4yAAoJEIaOsuA1yqREVHAP/As7J/3TuiTkiJyTbzTATXDi
yFpYLEu3Qqe4iJC+dbihg9W2uVWgYer1nOCe/ILthyHwx+31IXFoz7cYYwwFVRAy
OHPQJPFFjTN1pEx6MemhHj7HRTRhGSi12Owxei6Rzs0MWN0dxT5B4q7KRq8ivJwx
K2Iqv/nctwHYnIOD3qWsYF21Tl0mqkhpge3DzUZpwHx35JFlPplJfzODz/Rw/+rO
S1bxHY13RkQ1tW1OODRNJCzPWIHkHDGkpXNz2rz0NvK2cgrC2P+uX0b6/UNiQuEI
094Ew6H5n4uf5eaChECL1fXz/+9bcmw1EhW70klhsN7X4sLERYWZimWiseRzFNxs
e2V2rzmgVVpB+/CLsZeSIj9DugDa+UOdVBpBXhdDL/GkBYWtdRzyZAaL9k0Qry+/
AGxmhs4wCZPmZIf135s/6fr9kJpK2duPIdNlYC+ACm774u6bahHvhVKxFc+JOt+A
NleoaI4ya1f/oHg7OGYtc3lbMlBHsvhvJeuf9zx332obiv4hS9MNK4q2uAjtJw7T
YkG5Bei+UvB4q5sJ5mFrWDMQ9A40z/b0Q2pKe7d49EKj94kJyKPvHpOFolEFA8/s
oKzpvg6nFQPDmWaBW0m62LBRzC8hD3n/VsSxcbbLFVhPxUQ8nrL34UN7CCLwFGXQ
zr5Xoq+lj9g2vZvLrACm
=+Zrq
-----END PGP SIGNATURE-----

--KM+e2hnYAO+MCJ5e--
