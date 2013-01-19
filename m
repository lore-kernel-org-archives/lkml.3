Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3ASSUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 13:20:33 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:44460 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3ASSUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 13:20:32 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH v2] power: bq27x00_battery: Export all battery registers via sysfs
Date: Sat, 19 Jan 2013 19:20:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-22-generic; KDE/4.9.4; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <1358604104-7667-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1358604104-7667-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart37762122.Tvbf0sy8NV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201301191920.27839@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart37762122.Tvbf0sy8NV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 19 January 2013 15:01:43 Pali Roh=C3=A1r wrote:
> bq27xxx batteries have a lot of properties, more than
> power_supply interface. Some of them can be usefull for
> userspace applications (like CI bit) but does not make sense
> to add bq specified property to power_supply interface. When
> bq27x00_battery is not loaded userspace application (like
> i2cget) can use /dev/i2c-* interface for raw access. But when
> kernel module is attached to i2c device, userspace
> applications cannot access it via /dev/i2c-*. Also it is not
> usefull for userspace to unload module before reading values
> form /dev/i2c-* and then load it again.
>=20
> This patch exporting all battery registers to sysfs entry
> "registers" in battery power_supply directory. Format is
> "register=3Dvalue" on separate line. Because length of
> registers are different for each bq battery more for loops
> are needed.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
>  drivers/power/bq27x00_battery.c |   98
> +++++++++++++++++++++++++++++++++++++-- 1 file changed, 95
> insertions(+), 3 deletions(-)
>=20

Opps, this patch causing null ptr derefernce. Here is new fixed version:

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_batter=
y.c
index 7087d0d..4f54ad3 100644
=2D-- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -690,6 +690,90 @@ static void bq27x00_external_power_changed(struct powe=
r_supply *psy)
 	schedule_delayed_work(&di->work, 0);
 }
=20
+/* code for register device access via sysfs */
+
+static ssize_t bq27x00_battery_sysfs_print_reg(struct bq27x00_device_info =
*di,
+					u8 reg, bool single, char *buf)
+{
+	int ret =3D bq27x00_read(di, reg, single);
+	if (ret < 0)
+		return sprintf(buf, "%#.2x=3Derror %d\n", reg, ret);
+	else
+		return sprintf(buf, "%#.2x=3D%#.2x\n", reg, ret);
+}
+
+static ssize_t bq27x00_battery_sysfs_show_registers(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct power_supply *psy =3D dev_get_drvdata(dev);
+	struct bq27x00_device_info *di =3D container_of(psy,
+						struct bq27x00_device_info,
+						bat);
+	u8 reg;
+	ssize_t ret =3D 0;
+
+	switch (di->chip) {
+
+	case BQ27000:
+		for (reg=3D0x00; reg<=3D0x01; reg+=3D1)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
+		for (reg=3D0x02; reg<=3D0x08; reg+=3D2)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
+		for (reg=3D0x0A; reg<=3D0x0B; reg+=3D1)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
+		for (reg=3D0x0C; reg<=3D0x2A; reg+=3D2)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
+		for (reg=3D0x2C; reg<=3D0x7F; reg+=3D1)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
+		break;
+
+	case BQ27500:
+		for (reg=3D0x00; reg<=3D0x2C; reg+=3D2)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
+		for (reg=3D0x2E; reg<=3D0x3B; reg+=3D1)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
+		for (reg=3D0x3C; reg<=3D0x3C; reg+=3D2)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
+		for (reg=3D0x3E; reg<=3D0x7F; reg+=3D1)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
+		break;
+
+	case BQ27425:
+		for (reg=3D0x00; reg<=3D0x3C; reg+=3D2)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, false, buf+ret);
+		for (reg=3D0x3E; reg<=3D0x7F; reg+=3D1)
+			ret +=3D bq27x00_battery_sysfs_print_reg(di, reg, true, buf+ret);
+		break;
+
+	}
+
+	return ret;
+}
+
+static DEVICE_ATTR(registers, S_IRUGO,
+		bq27x00_battery_sysfs_show_registers, NULL);
+
+static struct attribute *bq27x00_battery_sysfs_attributes[] =3D {
+	&dev_attr_registers.attr,
+	NULL,
+};
+
+static const struct attribute_group bq27x00_battery_sysfs_attr_group =3D {
+	.attrs =3D bq27x00_battery_sysfs_attributes,
+};
+
+static int bq27x00_battery_sysfs_init(struct bq27x00_device_info *di)
+{
+	return sysfs_create_group(&di->bat.dev->kobj,
+			&bq27x00_battery_sysfs_attr_group);
+}
+
+static void bq27x00_battery_sysfs_exit(struct bq27x00_device_info *di)
+{
+	sysfs_remove_group(&di->bat.dev->kobj,
+			&bq27x00_battery_sysfs_attr_group);
+}
+
 static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 {
 	int ret;
@@ -711,6 +795,15 @@ static int bq27x00_powersupply_init(struct bq27x00_dev=
ice_info *di)
 	ret =3D power_supply_register(di->dev, &di->bat);
 	if (ret) {
 		dev_err(di->dev, "failed to register battery: %d\n", ret);
+		mutex_destroy(&di->lock);
+		return ret;
+	}
+
+	ret =3D bq27x00_battery_sysfs_init(di);
+	if (ret) {
+		dev_err(di->dev, "failed to register battery: %d\n", ret);
+		power_supply_unregister(&di->bat);
+		mutex_destroy(&di->lock);
 		return ret;
 	}
=20
@@ -733,6 +826,7 @@ static void bq27x00_powersupply_unregister(struct bq27x=
00_device_info *di)
=20
 	cancel_delayed_work_sync(&di->work);
=20
+	bq27x00_battery_sysfs_exit(di);
 	power_supply_unregister(&di->bat);
=20
 	mutex_destroy(&di->lock);


=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart37762122.Tvbf0sy8NV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlD64+sACgkQi/DJPQPkQ1KuBACeIaUaGh9e0GO+yFd9XGkIgThs
I8sAn0gzh0oQRarkxMCovrnn8H2YYNy2
=cn9M
-----END PGP SIGNATURE-----

--nextPart37762122.Tvbf0sy8NV--
