Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaK2Rts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:49:48 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48416 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaK2Rtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:49:47 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sat, 29 Nov 2014 18:49:43 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <20141129174315.GA32132@kroah.com>
In-Reply-To: <20141129174315.GA32132@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1887839.FMIpbgcSRK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411291849.44032@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1887839.FMIpbgcSRK
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 29 November 2014 18:43:15 Greg Kroah-Hartman wrote:
> On Sat, Nov 29, 2014 at 05:04:07PM +0100, Pali Roh=C3=A1r wrote:
> > This patch adds labels for temperature sensors if SMM
> > function with EAX register 0x11a3 reports it. These
> > informations was taken from DOS binary NBSVC.MDM.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >  drivers/char/i8k.c |  110
> >  +++++++++++++++++++++++++++++++++++++++++----------- 1
> >  file changed, 88 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> > index e34a019..77af46b 100644
> > --- a/drivers/char/i8k.c
> > +++ b/drivers/char/i8k.c
> > @@ -42,6 +42,7 @@
> >=20
> >  #define I8K_SMM_GET_FAN		0x00a3
> >  #define I8K_SMM_GET_SPEED	0x02a3
> >  #define I8K_SMM_GET_TEMP	0x10a3
> >=20
> > +#define I8K_SMM_GET_TEMP_TYPE	0x11a3
> >=20
> >  #define I8K_SMM_GET_DELL_SIG1	0xfea3
> >  #define I8K_SMM_GET_DELL_SIG2	0xffa3
> >=20
> > @@ -288,6 +289,14 @@ static int i8k_set_fan(int fan, int
> > speed)
> >=20
> >  	return i8k_smm(&regs) ? : i8k_get_fan_status(fan);
> > =20
> >  }
> >=20
> > +static int i8k_get_temp_type(int sensor)
> > +{
> > +	struct smm_regs regs =3D { .eax =3D I8K_SMM_GET_TEMP_TYPE, };
> > +
> > +	regs.ebx =3D sensor & 0xff;
> > +	return i8k_smm(&regs) ? : regs.eax & 0xff;
> > +}
> > +
> >=20
> >  /*
> > =20
> >   * Read the cpu temperature.
> >   */
> >=20
> > @@ -493,6 +502,29 @@ static int i8k_open_fs(struct inode
> > *inode, struct file *file)
> >=20
> >   * Hwmon interface
> >   */
> >=20
> > +static ssize_t i8k_hwmon_show_temp_label(struct device
> > *dev, +				   struct device_attribute *devattr,
> > +				   char *buf)
> > +{
> > +	static const char * const labels[] =3D {
> > +		"CPU",
> > +		"GPU",
> > +		"SODIMM",
> > +		"Other",
> > +		"Ambient",
> > +		"Other",
> > +	};
> > +	int index =3D to_sensor_dev_attr(devattr)->index;
> > +	int type;
> > +
> > +	type =3D i8k_get_temp_type(index);
> > +	if (type < 0)
> > +		return type;
> > +	if (type >=3D ARRAY_SIZE(labels))
> > +		type =3D ARRAY_SIZE(labels) - 1;
> > +	return sprintf(buf, "%s\n", labels[type]);
> > +}
>=20
> No Documentation/ABI/ entry for your new sysfs file?

It is standard hwmon sysfs entry which is used by other hwmon=20
drivers... It is not i8k.ko driver specific.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1887839.FMIpbgcSRK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR6BzgACgkQi/DJPQPkQ1IjIgCbBp+GNAiKBbM1p9Px3/5GCh4z
hXkAoIuj9OgLziuQF9j5suhEL76Yb76X
=VUkF
-----END PGP SIGNATURE-----

--nextPart1887839.FMIpbgcSRK--
