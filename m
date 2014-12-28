Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaL1IqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 03:46:25 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48019 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaL1IqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 03:46:23 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Sun, 28 Dec 2014 09:46:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412280922.30389@pali> <20141228082820.GB31346@roeck-us.net>
In-Reply-To: <20141228082820.GB31346@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7762717.FFmmFeUdX1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412280946.19550@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7762717.FFmmFeUdX1
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Ok, here are new patches for testing... Those you are still reading this em=
ail thread and have your Dell=20
machines near, can you test them (ideally with disabling dmi config data)?

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 8ec4c37..d6e8a26 100644
=2D-- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -64,9 +64,9 @@ static DEFINE_MUTEX(i8k_mutex);
 static char bios_version[4];
 static struct device *i8k_hwmon_dev;
 static u32 i8k_hwmon_flags;
=2Dstatic int i8k_fan_mult;
=2Dstatic int i8k_pwm_mult;
=2Dstatic int i8k_fan_max =3D I8K_FAN_HIGH;
+static uint i8k_fan_mult;
+static uint i8k_pwm_mult;
+static uint i8k_fan_max =3D I8K_FAN_HIGH;
=20
 #define I8K_HWMON_HAVE_TEMP1	(1 << 0)
 #define I8K_HWMON_HAVE_TEMP2	(1 << 1)
@@ -95,12 +95,12 @@ static bool power_status;
 module_param(power_status, bool, 0600);
 MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
=20
=2Dstatic int fan_mult =3D I8K_FAN_MULT;
=2Dmodule_param(fan_mult, int, 0);
+static uint fan_mult =3D I8K_FAN_MULT;
+module_param(fan_mult, uint, 0);
 MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
=20
=2Dstatic int fan_max =3D I8K_FAN_HIGH;
=2Dmodule_param(fan_max, int, 0);
+static uint fan_max =3D I8K_FAN_HIGH;
+module_param(fan_max, uint, 0);
 MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed");
=20
 static int i8k_open_fs(struct inode *inode, struct file *file);
@@ -696,8 +696,8 @@ static int __init i8k_init_hwmon(void)
 }
=20
 struct i8k_config_data {
=2D	int fan_mult;
=2D	int fan_max;
+	uint fan_mult;
+	uint fan_max;
 };
=20
 enum i8k_configs {



diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index d6e8a26..6ad0872 100644
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
@@ -891,19 +906,40 @@ static int __init i8k_probe(void)
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
+		 */
+		for (fan =3D 0; fan < 2; ++fan) {
+			ret =3D i8k_get_fan_nominal_speed(fan, i8k_fan_max);
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

--nextPart7762717.FFmmFeUdX1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSfw1sACgkQi/DJPQPkQ1J09gCfdK07hd7uB45yc8PEjmaHsju5
/SYAn07SDFihBtlsWrd8mFbrjX54okiq
=wBgA
-----END PGP SIGNATURE-----

--nextPart7762717.FFmmFeUdX1--
