Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbaLWTLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 14:11:21 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58433 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaLWTLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 14:11:19 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v4] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Tue, 23 Dec 2014 20:11:11 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
References: <1419153618-6930-1-git-send-email-pali.rohar@gmail.com> <201412221607.34978@pali> <20141223135210.GA6245@roeck-us.net>
In-Reply-To: <20141223135210.GA6245@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1635850.9k3YoZ6W1i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412232011.11914@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1635850.9k3YoZ6W1i
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 23 December 2014 14:52:10 Guenter Roeck wrote:
> On Mon, Dec 22, 2014 at 04:07:34PM +0100, Pali Roh=C3=A1r wrote:
> > On Sunday 21 December 2014 20:51:14 Guenter Roeck wrote:
> > > On 12/21/2014 09:23 AM, Pali Roh=C3=A1r wrote:
> > > > This patch adds new function i8k_get_fan_nominal_speed()
> > > > for doing SMM call which will return nominal fan RPM
> > > > for specified fan speed. It returns nominal RPM value
> > > > at which fan operate when speed (0, 1, 2, 3) is set. It
> > > > looks like RPM value is not accurate, but still
> > > > provides very useful information.
> > > >=20
> > > > First it can be used to validate if certain fan speed
> > > > could be accepted by SMM for setting fan speed and we
> > > > can use this routine to detect maximal fan speed.
> > > >=20
> > > > Second it returns RPM value, so we can check if value
> > > > looks correct with multiplier 30 or multiplier 1 (until
> > > > now only these two multiplier were used). If RPM value
> > > > with multiplier 30 is too high, then multiplier 1 is
> > > > used.
> > > >=20
> > > > In case when SMM reports that new function is not
> > > > supported we will fallback to old hardcoded values.
> > > > Maximal fan speed would be 2 and RPM multiplier 30.
> > > >=20
> > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > Tested-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > >=20
> > > Auto-detection of both multiplier and maximum speed tested
> > > working on M140 (after removing its configuration entry).
> > >=20
> > > On Studio 1555, multiplier auto-detection works, but
> > > fan_max auto-detection fails. A speed value of '3' is
> > > accepted, but it does not set the fan speed to its
> > > maximum. Also, after setting the speed value to '3',
> > > reading it back returns to old value. No idea what it
> > > does or is expected to do. Reading the nominal speed does
> > > return a valid value.
> > >=20
> > > Given that, I think we should not try to auto-detect
> > > fan_max, but keep the current code (meaning either use 2
> > > or 3 depending on the configuration data, with 2 as
> > > default if nothing else is known).
> > >=20
> > > Thanks,
> > > Guenter
> >=20
> > Ok. In this case I will remove max fan speed detection code
> > and we will use config data for those some machines which
> > support TURBO speed. If multiplier detection on Studio is
> > working fine, I can send another patch which remove config
> > data for Studio (because default multiplier is 2).
> >=20
> > Can you check which nominal value Studio returns for speed
> > 3? Maybe it is some special?
>=20
> It was a bit higher than the value returned for speed 2.
> Nothing special as far as I could see, only that setting a
> value of 3 did not modify the fan speed.
>=20

Ok. I removed detection of maximal fan speed. Patch is below.

> Note that I won't be able to test further in the next two
> weeks; I am about 6,000 miles away from my Dell laptops right
> now.
>=20
> Guenter

Ok. When you will be back you can test new version:

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index d6e8a26..f0e21a0 100644
=2D-- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -6,6 +6,7 @@
  * Hwmon integration:
  * Copyright (C) 2011  Jean Delvare <jdelvare@suse.de>
  * Copyright (C) 2013, 2014  Guenter Roeck <linux@roeck-us.net>
+ * Copyright (C) 2014  Pali Roh=C3=A1r <pali.rohar@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -42,12 +43,14 @@
 #define I8K_SMM_SET_FAN		0x01a3
 #define I8K_SMM_GET_FAN		0x00a3
 #define I8K_SMM_GET_SPEED	0x02a3
+#define I8K_SMM_GET_NOM_SPEED	0x04a3
 #define I8K_SMM_GET_TEMP	0x10a3
 #define I8K_SMM_GET_TEMP_TYPE	0x11a3
 #define I8K_SMM_GET_DELL_SIG1	0xfea3
 #define I8K_SMM_GET_DELL_SIG2	0xffa3
=20
 #define I8K_FAN_MULT		30
+#define I8K_FAN_MAX_RPM		30000
 #define I8K_MAX_TEMP		127
=20
 #define I8K_FN_NONE		0x00
@@ -64,7 +67,7 @@ static DEFINE_MUTEX(i8k_mutex);
 static char bios_version[4];
 static struct device *i8k_hwmon_dev;
 static u32 i8k_hwmon_flags;
=2Dstatic uint i8k_fan_mult;
+static uint i8k_fan_mult =3D I8K_FAN_MULT;
 static uint i8k_pwm_mult;
 static uint i8k_fan_max =3D I8K_FAN_HIGH;
=20
@@ -95,13 +98,13 @@ static bool power_status;
 module_param(power_status, bool, 0600);
 MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
=20
=2Dstatic uint fan_mult =3D I8K_FAN_MULT;
+static uint fan_mult;
 module_param(fan_mult, uint, 0);
=2DMODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
+MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with (default: au=
todetect)");
=20
=2Dstatic uint fan_max =3D I8K_FAN_HIGH;
+static uint fan_max;
 module_param(fan_max, uint, 0);
=2DMODULE_PARM_DESC(fan_max, "Maximum configurable fan speed");
+MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed (default: autode=
tect)");
=20
 static int i8k_open_fs(struct inode *inode, struct file *file);
 static long i8k_ioctl(struct file *, unsigned int, unsigned long);
@@ -276,6 +279,17 @@ static int i8k_get_fan_speed(int fan)
 }
=20
 /*
+ * Read the fan nominal rpm for specific fan speed.
+ */
+static int i8k_get_fan_nominal_speed(int fan, int speed)
+{
+	struct smm_regs regs =3D { .eax =3D I8K_SMM_GET_NOM_SPEED, };
+
+	regs.ebx =3D (fan & 0xff) | (speed << 8);
+	return i8k_smm(&regs) ? : (regs.eax & 0xffff) * i8k_fan_mult;
+}
+
+/*
  * Set the fan speed (off, low, high). Returns the new fan status.
  */
 static int i8k_set_fan(int fan, int speed)
@@ -863,6 +877,7 @@ MODULE_DEVICE_TABLE(dmi, i8k_dmi_table);
 static int __init i8k_probe(void)
 {
 	const struct dmi_system_id *id;
+	int fan, ret;
=20
 	/*
 	 * Get DMI information
@@ -891,19 +906,47 @@ static int __init i8k_probe(void)
 			return -ENODEV;
 	}
=20
=2D	i8k_fan_mult =3D fan_mult;
=2D	i8k_fan_max =3D fan_max ? : I8K_FAN_HIGH;	/* Must not be 0 */
+	/*
+	 * Set fan multiplier and maximal fan speed from dmi config
+	 * Values specified in module parameters override values from dmi
+	 */
 	id =3D dmi_first_match(i8k_dmi_table);
 	if (id && id->driver_data) {
 		const struct i8k_config_data *conf =3D id->driver_data;
=2D
=2D		if (fan_mult =3D=3D I8K_FAN_MULT && conf->fan_mult)
=2D			i8k_fan_mult =3D conf->fan_mult;
=2D		if (fan_max =3D=3D I8K_FAN_HIGH && conf->fan_max)
=2D			i8k_fan_max =3D conf->fan_max;
+		if (!fan_mult && conf->fan_mult)
+			fan_mult =3D conf->fan_mult;
+		if (!fan_max && conf->fan_max)
+			fan_max =3D conf->fan_max;
 	}
+
+	i8k_fan_max =3D fan_max ? : I8K_FAN_HIGH;	/* Must not be 0 */
 	i8k_pwm_mult =3D DIV_ROUND_UP(255, i8k_fan_max);
=20
+	if (!fan_mult) {
+		/*
+		 * Autodetect fan multiplier based on nominal rpm
+		 * If fan reports rpm value too high then set multiplier to 1
+		 *
+		 * Try also setting multiplier from current rpm, but this will
+		 * work only in case when fan is not turned off. It is better
+		 * then nothing for machines which does not support nominal rpm
+		 * SMM function.
+		 */
+		for (fan =3D 0; fan < 2; ++fan) {
+			ret =3D i8k_get_fan_nominal_speed(fan, i8k_fan_max);
+			if (ret < 0)
+				ret =3D i8k_get_fan_speed(fan);
+			if (ret < 0)
+				continue;
+			if (ret > I8K_FAN_MAX_RPM)
+				i8k_fan_mult =3D 1;
+			break;
+		}
+	} else {
+		/* Fan multiplier was specified in module param or in dmi */
+		i8k_fan_mult =3D fan_mult;
+	}
+
 	return 0;
 }
=20

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1635850.9k3YoZ6W1i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSZvk8ACgkQi/DJPQPkQ1LdhwCeMjNPdUvgFY8wiRbc7tMLYf2F
/x8AmwUcxnbStyFJxzQh5W4UEfJx+gkm
=sZ9q
-----END PGP SIGNATURE-----

--nextPart1635850.9k3YoZ6W1i--
