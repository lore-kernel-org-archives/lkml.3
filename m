Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3KACeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:34:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34886 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab3KACd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:33:59 -0400
Date: Fri, 1 Nov 2013 13:33:45 +1100
From: NeilBrown <neilb@suse.de>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH 1/2] LEDS: tca6507 - fix bugs in parsing of device-tree
 configuration.
Message-ID: <20131101133345.03db24ec@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8jZqc8GGKo7RkSEz=K1uMUw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8jZqc8GGKo7RkSEz=K1uMUw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



1/ The led_info array must be allocated to allow the full number
  of LEDs even if not all are present.  The array maybe be sparsely
  filled but it is indexed by device address so we must at least
  allocate as many slots as the highest address used.  It is easiest
  just to allocate all 7.

2/ range check the 'reg' value properly.

3/ led.flags must be initialised to zero, else all leds could
   be treated as GPIOs (depending on what happens to be on the stack).

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 8cc304f36728..f5063f447463 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -682,7 +682,7 @@ tca6507_led_dt_init(struct i2c_client *client)
 		return ERR_PTR(-ENODEV);
=20
 	tca_leds =3D devm_kzalloc(&client->dev,
-			sizeof(struct led_info) * count, GFP_KERNEL);
+			sizeof(struct led_info) * NUM_LEDS, GFP_KERNEL);
 	if (!tca_leds)
 		return ERR_PTR(-ENOMEM);
=20
@@ -695,9 +695,9 @@ tca6507_led_dt_init(struct i2c_client *client)
 			of_get_property(child, "label", NULL) ? : child->name;
 		led.default_trigger =3D
 			of_get_property(child, "linux,default-trigger", NULL);
-
+		led.flags =3D 0;
 		ret =3D of_property_read_u32(child, "reg", &reg);
-		if (ret !=3D 0)
+		if (ret !=3D 0 || reg < 0 || reg >=3D NUM_LEDS)
 			continue;
=20
 		tca_leds[reg] =3D led;
@@ -708,7 +708,7 @@ tca6507_led_dt_init(struct i2c_client *client)
 		return ERR_PTR(-ENOMEM);
=20
 	pdata->leds.leds =3D tca_leds;
-	pdata->leds.num_leds =3D count;
+	pdata->leds.num_leds =3D NUM_LEDS;
=20
 	return pdata;
 }

--Sig_/8jZqc8GGKo7RkSEz=K1uMUw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnMTCTnsnt1WYoG5AQIMXA//Z3LE5msVq/1wka707oAQFWJZ2eM+xUFa
XPCi8xuc7CutpgV26lTfGkFA4nVQyATImJmCWgDucjsRU8mEBWg/dVFooFZ8+oMJ
5m+UjFXD536LtkmOo/pKnRPSMaD/SzN7mI04gK3nJ1JngFnRXDSTg4xIfUJ17hn+
aHJ+R67mlqYrA/VorncyWg0M/dU+rR6Rmr8GyX2Z3upEV05zZ1QcbkiRv5EJPJdC
+ft/W+1FqD1VwUyvpdWPNcwXU2B1Ju2jd5vwvVlUaeI6OawoxOV6wVKCBSlfBjJd
gHqMQicQmwZy+EyH3Om10nj8IhAubu3jF92P+GIM7EonxbM4KVqj55gKWKN2IQLI
BpgFXuRe0SjvxftXS4Ktm59pz0CpZyZsZgq3UoHR3oqAc326iAgxUvPE1B5GtUG2
MDZe9jN3MQSQ16Vf/3O4M4LNg8lhlo6iQ3WtF/fftzi6T4VGV8jNIj2ToMDy7acp
p1esB/rtnxozjUpSp8N/HhI3UUwrso0jEYzNA+eCAHdYtg123+n1j8b0iJ0wYgpj
ZRUKJ/XFRQ1HEc9mR30dlO9iZymcIKq1gTbr+RlrFiuDyPuKOFOUErWHO+XocznV
G9rFbOmNwebklT9E4opIdEm5TKj5sdskDMKTMs+DWR6EdN96gI30ZjYyT1fEL65p
P2PTpuNQf8E=
=BY91
-----END PGP SIGNATURE-----

--Sig_/8jZqc8GGKo7RkSEz=K1uMUw--
