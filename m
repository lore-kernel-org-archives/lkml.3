Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaLIUX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:23:29 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46120 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaLIUX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:23:26 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 2/3] i8k: Autodetect maximal fan speed and fan RPM multiplier
Date: Tue, 9 Dec 2014 21:23:22 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1418155621-21644-3-git-send-email-pali.rohar@gmail.com> <20141209202023.GA22176@roeck-us.net>
In-Reply-To: <20141209202023.GA22176@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2823279.r0brVmb04h";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412092123.22271@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2823279.r0brVmb04h
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 09 December 2014 21:20:23 Guenter Roeck wrote:
> On Tue, Dec 09, 2014 at 09:07:00PM +0100, Pali Roh=C3=A1r wrote:
> > This patch adds new function i8k_get_fan_nominal_rpm() for
> > doing SMM call which will return nominal fan RPM for
> > specified fan speed. It returns nominal RPM value at which
> > fan operate when speed is set. It looks like RPM value is
> > not accurate, but still provides very useful information.
> >=20
> > First it can be used to validate if certain fan speed could
> > be accepted by SMM for setting fan speed and we can use
> > this routine to detect maximal fan speed.
> >=20
> > Second it returns RPM value, so we can check if value looks
> > correct with multiplier 30 or multiplier 1 (until now only
> > these two multiplier was used). If RPM value with
> > multiplier 30 is too high, then multiplier 1 is used.
> >=20
> > In case when SMM reports that new function is not supported
> > we will fallback to old hardcoded values. Maximal fan speed
> > would be 2 and RPM multiplier 30.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> > I tested this patch only on my Dell Latitude E6440 and
> > autodetection worked fine Before appying this patch it
> > should be tested on some other dell machines too but if
> > machine does not support i8k_get_fan_nominal_rpm() driver
> > should fallback to old values. So patch should be without
> > regressions.
>=20
> It looks like many of your error checks are unnecessary.
> Why did you add those ?
>=20
> Please refrain from adding unnecessary code.
>=20
> Guenter
>=20

Which error checks do you mean?

> > ---
> >=20
> >  drivers/char/i8k.c       |  122
> >  ++++++++++++++++++++++++++++++++++++++--------
> >  include/uapi/linux/i8k.h |    4 +-
> >  2 files changed, 104 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> > index 31e4beb..8bdbed2 100644
> > --- a/drivers/char/i8k.c
> > +++ b/drivers/char/i8k.c
> > @@ -42,12 +42,14 @@
> >=20
> >  #define I8K_SMM_GET_FAN_SPEED	0x00a3
> >  #define I8K_SMM_SET_FAN_SPEED	0x01a3
> >  #define I8K_SMM_GET_FAN_RPM	0x02a3
> >=20
> > +#define I8K_SMM_GET_FAN_NOM_RPM	0x04a3
> >=20
> >  #define I8K_SMM_GET_TEMP	0x10a3
> >  #define I8K_SMM_GET_TEMP_TYPE	0x11a3
> >  #define I8K_SMM_GET_DELL_SIG1	0xfea3
> >  #define I8K_SMM_GET_DELL_SIG2	0xffa3
> >=20
> > -#define I8K_FAN_MULT		30
> > +#define I8K_FAN_DEFAULT_MULT	30
> > +#define I8K_FAN_MAX_RPM		30000
> >=20
> >  #define I8K_MAX_TEMP		127
> > =20
> >  #define I8K_FN_NONE		0x00
> >=20
> > @@ -64,9 +66,9 @@ static DEFINE_MUTEX(i8k_mutex);
> >=20
> >  static char bios_version[4];
> >  static struct device *i8k_hwmon_dev;
> >  static u32 i8k_hwmon_flags;
> >=20
> > -static int i8k_fan_mult;
> > -static int i8k_pwm_mult;
> > -static int i8k_fan_max =3D I8K_FAN_HIGH;
> > +static int i8k_fan_mult[I8K_FAN_COUNT];
> > +static int i8k_pwm_mult[I8K_FAN_COUNT];
> > +static int i8k_fan_max[I8K_FAN_COUNT];
> >=20
> >  #define I8K_HWMON_HAVE_TEMP1	(1 << 0)
> >  #define I8K_HWMON_HAVE_TEMP2	(1 << 1)
> >=20
> > @@ -95,13 +97,13 @@ static bool power_status;
> >=20
> >  module_param(power_status, bool, 0600);
> >  MODULE_PARM_DESC(power_status, "Report power status in
> >  /proc/i8k");
> >=20
> > -static int fan_mult =3D I8K_FAN_MULT;
> > +static int fan_mult;
> >=20
> >  module_param(fan_mult, int, 0);
> >=20
> > -MODULE_PARM_DESC(fan_mult, "Factor to multiply fan rpm
> > with"); +MODULE_PARM_DESC(fan_mult, "Factor to multiply fan
> > rpm with (default: autodetect)");
> >=20
> > -static int fan_max =3D I8K_FAN_HIGH;
> > +static int fan_max;
> >=20
> >  module_param(fan_max, int, 0);
> >=20
> > -MODULE_PARM_DESC(fan_max, "Maximum configurable fan
> > speed"); +MODULE_PARM_DESC(fan_max, "Maximum configurable
> > fan speed (default: autodetect)");
> >=20
> >  static int i8k_open_fs(struct inode *inode, struct file
> >  *file); static long i8k_ioctl(struct file *, unsigned int,
> >  unsigned long);
> >=20
> > @@ -271,8 +273,25 @@ static int i8k_get_fan_rpm(int fan)
> >=20
> >  {
> > =20
> >  	struct smm_regs regs =3D { .eax =3D I8K_SMM_GET_FAN_RPM, };
> >=20
> > +	if (fan < 0 || fan >=3D I8K_FAN_COUNT)
> > +		return -EINVAL;
> > +
> >=20
> >  	regs.ebx =3D fan & 0xff;
> >=20
> > -	return i8k_smm(&regs) ? : (regs.eax & 0xffff) *
> > i8k_fan_mult; +	return i8k_smm(&regs) ? : (regs.eax &
> > 0xffff) * i8k_fan_mult[fan]; +}
> > +
> > +/*
> > + * Read the fan nominal rpm for specific fan speed.
> > + */
> > +static int i8k_get_fan_nominal_rpm(int fan, int speed)
> > +{
> > +	struct smm_regs regs =3D { .eax =3D I8K_SMM_GET_FAN_NOM_RPM,
> > }; +
> > +	if (fan < 0 || fan >=3D I8K_FAN_COUNT)
> > +		return -EINVAL;
> > +
> > +	regs.ebx =3D (fan & 0xff) | (speed << 8);
> > +	return i8k_smm(&regs) ? : (regs.eax & 0xffff) *
> > i8k_fan_mult[fan];
> >=20
> >  }
> > =20
> >  /*
> >=20
> > @@ -282,9 +301,12 @@ static int i8k_set_fan_speed(int fan,
> > int speed)
> >=20
> >  {
> > =20
> >  	struct smm_regs regs =3D { .eax =3D I8K_SMM_SET_FAN_SPEED, };
> >=20
> > -	speed =3D (speed < 0) ? 0 : ((speed > i8k_fan_max) ?
> > i8k_fan_max : speed); -	regs.ebx =3D (fan & 0xff) | (speed <<
> > 8);
> > +	if (speed < 0)
> > +		speed =3D 0;
> > +	if (fan >=3D 0 && fan < I8K_FAN_COUNT && speed >
> > i8k_fan_max[fan]) +		speed =3D i8k_fan_max[fan];
> >=20
> > +	regs.ebx =3D (fan & 0xff) | (speed << 8);
> >=20
> >  	return i8k_smm(&regs) ? : i8k_get_fan_speed(fan);
> > =20
> >  }
> >=20
> > @@ -559,10 +581,14 @@ static ssize_t
> > i8k_hwmon_show_pwm(struct device *dev,
> >=20
> >  	int index =3D to_sensor_dev_attr(devattr)->index;
> >  	int fan_speed;
> >=20
> > +	if (index < 0 || index >=3D I8K_FAN_COUNT)
> > +		return -EINVAL;
> > +
> >=20
> >  	fan_speed =3D i8k_get_fan_speed(index);
> >  	if (fan_speed < 0)
> >  =09
> >  		return -EIO;
> >=20
> > -	return sprintf(buf, "%d\n", clamp_val(fan_speed *
> > i8k_pwm_mult, 0, 255)); +	return sprintf(buf, "%d\n",
> > clamp_val(fan_speed * i8k_pwm_mult[index], +				=09
      0,
> > 255));
> >=20
> >  }
> > =20
> >  static ssize_t i8k_hwmon_set_pwm(struct device *dev,
> >=20
> > @@ -573,10 +599,14 @@ static ssize_t
> > i8k_hwmon_set_pwm(struct device *dev,
> >=20
> >  	unsigned long val;
> >  	int err;
> >=20
> > +	if (index < 0 || index >=3D I8K_FAN_COUNT)
> > +		return -EINVAL;
> > +
> >=20
> >  	err =3D kstrtoul(buf, 10, &val);
> >  	if (err)
> >  =09
> >  		return err;
> >=20
> > -	val =3D clamp_val(DIV_ROUND_CLOSEST(val, i8k_pwm_mult), 0,
> > i8k_fan_max); +	val =3D clamp_val(DIV_ROUND_CLOSEST(val,
> > i8k_pwm_mult[index]), 0, +			i8k_fan_max[index]);
> >=20
> >  	mutex_lock(&i8k_mutex);
> >  	err =3D i8k_set_fan_speed(index, val);
> >=20
> > @@ -854,7 +884,9 @@ MODULE_DEVICE_TABLE(dmi, i8k_dmi_table);
> >=20
> >   */
> > =20
> >  static int __init i8k_probe(void)
> >  {
> >=20
> > +	const struct i8k_config_data *conf;
> >=20
> >  	const struct dmi_system_id *id;
> >=20
> > +	int fan, val, ret;
> >=20
> >  	/*
> >  =09
> >  	 * Get DMI information
> >=20
> > @@ -883,18 +915,66 @@ static int __init i8k_probe(void)
> >=20
> >  			return -ENODEV;
> >  =09
> >  	}
> >=20
> > -	i8k_fan_mult =3D fan_mult;
> > -	i8k_fan_max =3D fan_max ? : I8K_FAN_HIGH;	/* Must not be 0
> > */ +	/*
> > +	 * Autodetect fan multiplier and maximal fan speed from
> > dmi config +	 * Values specified in module parameters
> > override values from dmi +	 */
> >=20
> >  	id =3D dmi_first_match(i8k_dmi_table);
> >  	if (id && id->driver_data) {
> >=20
> > -		const struct i8k_config_data *conf =3D id->driver_data;
> > +		conf =3D id->driver_data;
> > +		if (fan_mult <=3D 0 && conf->fan_mult > 0)
> > +			fan_mult =3D conf->fan_mult;
> > +		if (fan_max <=3D 0 && conf->fan_max > 0)
> > +			fan_max =3D conf->fan_max;
> > +	}
> >=20
> > -		if (fan_mult =3D=3D I8K_FAN_MULT && conf->fan_mult)
> > -			i8k_fan_mult =3D conf->fan_mult;
> > -		if (fan_max =3D=3D I8K_FAN_HIGH && conf->fan_max)
> > -			i8k_fan_max =3D conf->fan_max;
> > +	if (fan_mult <=3D 0) {
> > +		/*
> > +		 * Autodetect fan multiplier for each fan based on
> > nominal rpm +		 * First set default fan multiplier for each
> > fan +		 * And if it reports rpm value too high then set
> > multiplier to 1 +		 */
> > +		for (fan =3D 0; fan < I8K_FAN_COUNT; ++fan) {
> > +			i8k_fan_mult[fan] =3D I8K_FAN_DEFAULT_MULT;
> > +			for (val =3D 0; val < 256; ++val) {
> > +				ret =3D i8k_get_fan_nominal_rpm(fan, val);
> > +				if (ret > I8K_FAN_MAX_RPM) {
> > +					i8k_fan_mult[fan] =3D 1;
> > +					break;
> > +				} else if (ret < 0) {
> > +					break;
> > +				}
> > +			}
> > +		}
> > +	} else {
> > +		/* Fan multiplier was specified in module param or in=20
dmi
> > */ +		for (fan =3D 0; fan < I8K_FAN_COUNT; ++fan)
> > +			i8k_fan_mult[fan] =3D fan_mult;
> >=20
> >  	}
> >=20
> > -	i8k_pwm_mult =3D DIV_ROUND_UP(255, i8k_fan_max);
> > +
> > +	if (fan_max <=3D 0) {
> > +		/*
> > +		 * Autodetect maximal fan speed value for each fan
> > +		 * Speed value is valid if i8k_get_fan_nominal_rpm()=20
not
> > fail +		 */
> > +		for (fan =3D 0; fan < I8K_FAN_COUNT; ++fan) {
> > +			for (val =3D 0; val < 256; ++val) {
> > +				if (i8k_get_fan_nominal_rpm(fan, val) < 0)
> > +					break;
> > +			}
> > +			--val; /* set last value which not failed */
> > +			if (val <=3D 0) /* Must not be 0 (and non negative)=20
*/
> > +				val =3D I8K_FAN_HIGH;
> > +			i8k_fan_max[fan] =3D val;
> > +		}
> > +	} else {
> > +		/* Maximal fan speed was specified in module param or=20
in
> > dmi */ +		for (fan =3D 0; fan < I8K_FAN_COUNT; ++fan)
> > +			i8k_fan_max[fan] =3D fan_max;
> > +	}
> > +
> > +	for (fan =3D 0; fan < I8K_FAN_COUNT; ++fan)
> > +		i8k_pwm_mult[fan] =3D DIV_ROUND_UP(255,=20
i8k_fan_max[fan]);
> >=20
> >  	return 0;
> > =20
> >  }
> >=20
> > diff --git a/include/uapi/linux/i8k.h
> > b/include/uapi/linux/i8k.h index 133d02f..60ef0ea 100644
> > --- a/include/uapi/linux/i8k.h
> > +++ b/include/uapi/linux/i8k.h
> > @@ -29,8 +29,10 @@
> >=20
> >  #define I8K_GET_FAN		_IOWR('i', 0x86, size_t)
> >  #define I8K_SET_FAN		_IOWR('i', 0x87, size_t)
> >=20
> > -#define I8K_FAN_LEFT		1
> >=20
> >  #define I8K_FAN_RIGHT		0
> >=20
> > +#define I8K_FAN_LEFT		1
> > +#define I8K_FAN_COUNT		(I8K_FAN_LEFT + 1)
> > +
> >=20
> >  #define I8K_FAN_OFF		0
> >  #define I8K_FAN_LOW		1
> >  #define I8K_FAN_HIGH		2

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2823279.r0brVmb04h
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSHWjoACgkQi/DJPQPkQ1IK7ACgnjRv9/2oV47dH+bLP+QEOUzP
kcEAoKY2C+7xto6GXCyVxhLHPD6SZX2n
=wR1u
-----END PGP SIGNATURE-----

--nextPart2823279.r0brVmb04h--
