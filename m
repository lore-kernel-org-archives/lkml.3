Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616Ab3AQKod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:44:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40919 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759531Ab3AQKoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:44:30 -0500
Date: Thu, 17 Jan 2013 12:43:57 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-i2c@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>, <dirk.brandewie@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] i2c-designware: always set the STOP bit after last
 byte
Message-ID: <20130117104356.GM10814@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358418667-4533-3-git-send-email-mika.westerberg@linux.intel.com>
 <20130117103248.GL10814@arwen.pp.htv.fi>
 <20130117104247.GU2239@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYjWXklH5JTzT8n9"
Content-Disposition: inline
In-Reply-To: <20130117104247.GU2239@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TYjWXklH5JTzT8n9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 12:42:47PM +0200, Mika Westerberg wrote:
> On Thu, Jan 17, 2013 at 12:32:48PM +0200, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Jan 17, 2013 at 12:31:05PM +0200, Mika Westerberg wrote:
> > > If IC_EMPTYFIFO_HOLD_MASTER_EN is set to one, the DesignWare I2C cont=
roller
> > > doesn't generate STOP on the bus when the FIFO is empty. This violate=
s the
> > > rules of Linux I2C stack as it requires that the STOP is issued once =
the
> > > i2c_transfer() is finished.
> > >=20
> > > However, there is no way to detect this from the hardware registers, =
so we
> > > must make sure that the STOP bit is always set once the last byte of =
the
> > > last message is transferred.
> > >=20
> > > This patch is based on the work of Dirk Brandewie.
> > >=20
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > ---
> > >  drivers/i2c/busses/i2c-designware-core.c |   16 ++++++++++++++--
> > >  1 file changed, 14 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/b=
usses/i2c-designware-core.c
> > > index f5258c2..94fd818 100644
> > > --- a/drivers/i2c/busses/i2c-designware-core.c
> > > +++ b/drivers/i2c/busses/i2c-designware-core.c
> > > @@ -413,11 +413,23 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
> > >  		rx_limit =3D dev->rx_fifo_depth - dw_readl(dev, DW_IC_RXFLR);
> > > =20
> > >  		while (buf_len > 0 && tx_limit > 0 && rx_limit > 0) {
> > > +			u32 cmd =3D 0;
> > > +
> > > +			/*
> > > +			 * If IC_EMPTYFIFO_HOLD_MASTER_EN is set we must
> > > +			 * manually set the stop bit. However, it cannot be
> > > +			 * detected from the registers so we set it always
> > > +			 * when writing/reading the last byte.
> > > +			 */
> > > +			if (dev->msg_write_idx =3D=3D dev->msgs_num - 1 &&
> > > +			    buf_len =3D=3D 1)
> > > +				cmd |=3D BIT(9);
> > > +
> > >  			if (msgs[dev->msg_write_idx].flags & I2C_M_RD) {
> > > -				dw_writel(dev, 0x100, DW_IC_DATA_CMD);
> > > +				dw_writel(dev, cmd | 0x100, DW_IC_DATA_CMD);
> > >  				rx_limit--;
> > >  			} else
> > > -				dw_writel(dev, *buf++, DW_IC_DATA_CMD);
> > > +				dw_writel(dev, cmd | *buf++, DW_IC_DATA_CMD);
> >=20
> > also need to send STP bit if I2C_M_STOP is set.
>=20
> True but only if the driver exposes I2C_FUNC_PROTOCOL_MANGLING, which is
> not done in this driver.

right, didn't check the driver, my bad.

--=20
balbi

--TYjWXklH5JTzT8n9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ99XsAAoJEIaOsuA1yqREKV8P/1SuV7Y8uFxyitoaA5dOk5Xj
SmL3d4LCETwdW44m1Nknaxk2wuvLxUJ9QpCfB8dfMMyiedoA9GMhHSBtQVR2bKgl
CZqDw2Jp7VGzlY4PWAUCwtayJtPv/qvltg0tuw89Tj76rVL3JQKExi8r180k6zn0
T5XHGbkUEygFYzF0AWY/7QSrvk/ozHxLyVmXhieiMq8qVrl5KgVh9clNWK9Fs4nS
regXrYrU1J0L9XHe+l0ILBAMDR/BF3M55pWndWQC2vjZW7L0Q8dUQALkUQgC9nUI
bxAawggkBUOBfzHNVCrYqh65F7mJjVHCF2U+IEMTG7diPuGyz7Gn/VNoqFZnrTtR
UFoV6/yufiFJRUz3wLjhuUVnBtNng7nqKTO7bmG0LAkZpOX7Qhq4gZ8kJ9FRF+l+
+XMJ/oTkSyDM3d804/NK+cVYeaPoHmk8KmhXgthclSarP758Qw5+AYpOBJPX1YAp
MH3dHxN3B5pwx5oTEsWuSc9qJN45YIeoXjjkgusKSAixpWrfVYVxvst7xRlZUTpg
hbNCQkoQblYIeAwOM4mQf9NwCfVLAzIw6i8kuOUrmZox8so48Rh9Mcdvlo9PNV60
q/Ei87k5xeD//IdHavre5zqPwMEiz0G4STZuZfTQf6eIBWM0qdfbCl8GIxfckG0l
wE4eL15hpP58zJyOf60R
=lZvB
-----END PGP SIGNATURE-----

--TYjWXklH5JTzT8n9--
