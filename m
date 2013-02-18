Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3BRHlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 02:41:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34988 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab3BRHlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 02:41:11 -0500
Date: Mon, 18 Feb 2013 09:40:56 +0200
From: Felipe Balbi <balbi@ti.com>
To: Simon Glass <sjg@chromium.org>
CC: <balbi@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: Re: [PATCH v4 3/6] mfd: Add ChromeOS EC I2C driver
Message-ID: <20130218074056.GB29848@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360988172-15380-1-git-send-email-sjg@chromium.org>
 <1360988172-15380-4-git-send-email-sjg@chromium.org>
 <20130216090637.GB19639@arwen.pp.htv.fi>
 <CAPnjgZ201Pcq3EshTkEU8YgLNVby=d6xjjss_Rh5Kfrwnc0Mrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <CAPnjgZ201Pcq3EshTkEU8YgLNVby=d6xjjss_Rh5Kfrwnc0Mrg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Feb 16, 2013 at 06:46:53AM -0800, Simon Glass wrote:
> Hi,
>=20
> On Sat, Feb 16, 2013 at 1:06 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Fri, Feb 15, 2013 at 08:16:09PM -0800, Simon Glass wrote:
> >> This uses an I2C bus to talk to the ChromeOS EC. The protocol
> >> is defined by the EC and is fairly simple, with a length byte,
> >> checksum, command byte and version byte (to permit easy creation
> >> of new commands).
> >>
> >> Signed-off-by: Simon Glass <sjg@chromium.org>
> >> Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
> >
> > the driver you're adding here is no where near being an MFD device. MFD
> > children shouldn't be under drivers/mfd/. Please find a proper location
> > for this driver.
>=20
> I think you might be misunderstanding the intent here. This driver is
> actually not an MFD child, but a real MFD device. The children are
> things like the cros_ec_keyb which use this device to access to the EC
> and provide a function to the kernel (such as keyboard, EC flash
> access and so on). They are indeed somewhere else in the tree.
>=20
> This driver sits in MFD for that reason, and provides a way to talk to
> the EC over I2C. Rather than duplicate the code in each bus driver
> (I2C, SPI, LPC) we have chosen to put that core code in a common file,
> cros_ec, So one way to think of it is that we have several transports
> which each provides an abstracted interface to an EC.
>=20
> There are several examples in drivers/mfd where this is done. For example:
>=20
> da9052_i2c.c and da9052_spi.c each provide an MFD driver, which calls
> da9052_device_init() in da50542-core.c.
>=20
> and there are many others in MFD which use this approach, for example:
>=20
> drivers/mfd/wm831x-core.c
> drivers/mfd/wm831x-i2c.c
> drivers/mfd/wm831x-spi.c
>=20
> and
>=20
> drivers/mfd/tps65912-core.c
> drivers/mfd/tps65912-i2c.c
> drivers/mfd/tps65912-spi.c
>=20
> The intent is to keep the communications separate from the function
> provided by the device.

fair enough.

> >> +/* Since I2C can be unreliable, we retry commands */
> >> +#define COMMAND_MAX_TRIES 3
> >
> > unreliable in what way ? Are you sure you haven't found a bug on your
> > embedded controller or your i2c controller driver ?
>=20
> Well those bugs were fixed. I think this is here for safety just in
> case is this bad?

I guess it looks a bit weird, specially since that retry mechanism
should be on the i2c bus driver.

> >> +static const char *cros_ec_get_phys_name(struct cros_ec_device *ec_de=
v)
> >> +{
> >> +     struct i2c_client *client =3D ec_dev->priv;
> >> +
> >> +     return client->adapter->name;
> >> +}
> >> +
> >> +static struct device *cros_ec_get_parent(struct cros_ec_device *ec_de=
v)
> >> +{
> >> +     struct i2c_client *client =3D ec_dev->priv;
> >> +
> >> +     return &client->dev;
> >> +}
> >
> > not sure you should allow other layers to fiddle with these. Specially
> > the parent device ointer.
>=20
> This is the parent device for any children. Some MFD children will
> want to know their parent. I can just add it to the structure I think.

they can know their parent by using "dev->parent". Also you should be
creating your children with proper mfd_add_devices() call.

--=20
balbi

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIdsHAAoJEIaOsuA1yqREBR8P/25DJEMJzuuFgeCJEI/YUaKF
Sn0Jh7G84Kg7msyC5eMMnHdAeQIbR1+QZpZyGxLKSnsqNUxQFKRC/iaJ14F+Ip6Y
HyqG61DjXN9d8ogDW0wJFS9r+5Oowlcbh+Npo8LSERweR9RcG6dWF7XIwWva58Lc
kNF2WFOpVMF/kqGvA0J4/uQ/NY+2H/LqPBQpw48fDlE74Sw0qqNySsAOwi87Vt8l
6b1EOzRIyVJswaasRTDdMhi55SN80tPo8ksCll0uyH1BIdwhmmt+RY/aDPWCdOwE
FiVHAB66BzDejRBlcmhaKuJishCG8kUFx33issMnSYT6m2gm9/CutxXT4285DleR
vL/OAy9qrWT6pHCJkjy7WaTnuR08azsrb6pDRUI5iBKMvLpI5RWpWNOCoEMtAge0
TEIgEbbE2JOLVDJfKWsZ6X0xC3PjStVhGCwUdVGUBryzDdu+hFlPz28PyaHy8aQI
sDqEdy/PIRrwm0DJmtLDbhjWxVmIk+TVaK8ZrieVhWwCGACPDPfrfchE6TP4zkh7
MekqKy3tBDZstN515+JmPd+Zn2DMlomquxYs+9/joQhghZ2IipH+dSZOdUynJgSD
kuB85+5fDxea+M1h44Q8IeSXHkJ4yysAIvaov+eMjKVo5cM2HDljJvAzfl2DIIVW
MObuVqELOGIUsNwKs8dE
=NcsL
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
