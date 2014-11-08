Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaKHASn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:18:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbaKHASm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:18:42 -0500
Date: Sat, 8 Nov 2014 11:18:33 +1100
From: NeilBrown <neilb@suse.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        GTA04 owners <gta04-owner@goldelico.com>
Subject: [PATCH] iio: gyro: itg3200: add suspend/resume support.
Message-ID: <20141108111833.3829480c@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YftDn7tZGhJa=b3B4A8.X3c"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YftDn7tZGhJa=b3B4A8.X3c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



Unless we put the device to sleep when not it use, it wastes
6mA.

If the device is asleep on probe, the 'id' register
sometimes mis-reads - so reset first.  If the device responds
at all a command sent to the address, it is almost certainly
the correct device already.

Signed-off-by: NeilBrown <neil@brown.name>

diff --git a/drivers/iio/gyro/itg3200_core.c b/drivers/iio/gyro/itg3200_cor=
e.c
index 6a8020d48140..394667fb23f9 100644
--- a/drivers/iio/gyro/itg3200_core.c
+++ b/drivers/iio/gyro/itg3200_core.c
@@ -223,6 +223,7 @@ static int itg3200_initial_setup(struct iio_dev *indio_=
dev)
 	int ret;
 	u8 val;
=20
+	ret =3D itg3200_reset(indio_dev);
 	ret =3D itg3200_read_reg_8(indio_dev, ITG3200_REG_ADDRESS, &val);
 	if (ret)
 		goto err_ret;
@@ -351,6 +352,35 @@ static int itg3200_remove(struct i2c_client *client)
 	return 0;
 }
=20
+#ifdef CONFIG_PM_SLEEP
+static int itg3200_suspend(struct device *dev)
+{
+	struct iio_dev *indio_dev =3D dev_get_drvdata(dev);
+	struct itg3200 *st =3D iio_priv(indio_dev);
+	int ret;
+
+	dev_dbg(&st->i2c->dev, "suspend device");
+
+	ret =3D itg3200_write_reg_8(indio_dev,
+			ITG3200_REG_POWER_MANAGEMENT,
+			ITG3200_SLEEP);
+	return ret;
+}
+
+static int itg3200_resume(struct device *dev)
+{
+	struct iio_dev *indio_dev =3D dev_get_drvdata(dev);
+
+	itg3200_reset(indio_dev);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(itg3200_pm_ops, itg3200_suspend, itg3200_resume);
+#define ITG3200_PM_OPS (&itg3200_pm_ops)
+#else
+#define ITG3200_PM_OPS NULL
+#endif
+
 static const struct i2c_device_id itg3200_id[] =3D {
 	{ "itg3200", 0 },
 	{ }
@@ -361,6 +391,7 @@ static struct i2c_driver itg3200_driver =3D {
 	.driver =3D {
 		.owner  =3D THIS_MODULE,
 		.name	=3D "itg3200",
+		.pm	=3D ITG3200_PM_OPS,
 	},
 	.id_table	=3D itg3200_id,
 	.probe		=3D itg3200_probe,

--Sig_/YftDn7tZGhJa=b3B4A8.X3c
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF1hWTnsnt1WYoG5AQLddw//YvZVpSn1k9U6CCvGV60RycJ+0C8N5SnW
4AFhuXgBcMQ3U5gynX/xeOmbBFvH0g7yDxd18VUQ0ckZ2j+SzzCSW70rlZoug6mI
41O4bIe36PkF4FvKVJFvf07OKvY+Ec591Sm/yzxQ/ZDw2X+DpH5qH1XyPBgssn0Q
7OnI7JcwhSfGibviEur14/kJJ4soYkkbKYujhFwidD0D0XUIazmbeDUq50R2cCd0
UQ+n+rcJ9nMjJzbeZWVr1fkq6oNNVxzjaLJgE93cNdkU3YaUrZyci5CEKeKBX0mb
Q6o6+XbV2rJcFZELIRhESP3oxFJbpEvRAM1wHeFgeHiDeUjuClyMheiWIqtCsEKy
15J9i4qylu8JI9j028NhxS5qSfKOOY7XKv7ZkZtR7UBfJQqqKhG3A1WI+C8sJj8K
TBSFsrxZTdMsMj5Dlp3rHVU5pwQ8wC6Vk8VHOt94Wl1udGWlLE/ytECn5MNZUIJ0
qO52JbqPk6+ifVsV4ppqoJpQIgT0WBcD4hxTCLFwVBZm5G6BLnPqq7M57jahN6pi
dbiJSyihI+ipnKULi9LjzBcokPuvtf6kFARXtPvHHdbOm348n+1FCWj+fvOVeTD6
zbC9DDHdjGOJ9OV3Eywaac2diZjanV35NQEOBdS1NJQMdlQebl9+t5Pst8yN6Dpi
Rr9MfJSMxoQ=
=nj0w
-----END PGP SIGNATURE-----

--Sig_/YftDn7tZGhJa=b3B4A8.X3c--
