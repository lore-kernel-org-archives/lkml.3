Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3KACsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:48:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab3KACso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:48:44 -0400
Date: Fri, 1 Nov 2013 13:48:33 +1100
From: NeilBrown <neilb@suse.de>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: check for devicetree early.
Message-ID: <20131101134833.7070a5c5@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ph.gjBA1=nHLWLNnHdHT42u"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ph.gjBA1=nHLWLNnHdHT42u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


The behaviour of regulator core with respect to device-tree and
CONFIG_REGULATOR_DUMMY is inconsistent.

If there is no device-tree, then a board file can call
regulator_has_full_constraints() and this will negate the effect of
CONFIG_REGULATOR_DUMMY.

If a device-tree is given, regulator_has_full_constraints() is called
automatically, but too late to effectively negate the effect of
CONFIG_REGULATOR_DUMMY.

So it makes sense for regulator/core to check for devicetree earlier and ca=
ll
regulator_has_full_constraints() before any call to regulator_get() can trip
up on CONFIG_REGULATOR_DUMMY.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a01b8b3b70ca..8cd457ae66bc 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3748,13 +3748,8 @@ static int __init regulator_init(void)
 /* init early to allow our consumers to complete system booting */
 core_initcall(regulator_init);
=20
-static int __init regulator_init_complete(void)
+static int __init regulator_init_early(void)
 {
-	struct regulator_dev *rdev;
-	struct regulator_ops *ops;
-	struct regulation_constraints *c;
-	int enabled, ret;
-
 	/*
 	 * Since DT doesn't provide an idiomatic mechanism for
 	 * enabling full constraints and since it's much more natural
@@ -3763,6 +3758,16 @@ static int __init regulator_init_complete(void)
 	 */
 	if (of_have_populated_dt())
 		has_full_constraints =3D true;
+	return 0;
+}
+early_initcall(regulator_init_early);
+
+static int __init regulator_init_complete(void)
+{
+	struct regulator_dev *rdev;
+	struct regulator_ops *ops;
+	struct regulation_constraints *c;
+	int enabled, ret;
=20
 	mutex_lock(&regulator_list_mutex);
=20

--Sig_/ph.gjBA1=nHLWLNnHdHT42u
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnMWgTnsnt1WYoG5AQKr/A//Xx7TcwHQPsbvZSDPLmYj8M3WId1P29Vu
YY/0LNM+TRCj3yUKHl0gMo7bwceV16dibb+H0UrAGExV7+1C4UhXKxFwWmru7r9d
uUUsK40ut3BsTgVcGBjeG3HXAxRGpkyWugcv3Qgys+mRYTPOQ80HRbY3LeX0IyIZ
egLQzhdKgz0hzrohaNiNe+0m/Qs8qC/8/KbuMIuphpUfBS4Fr1FzOqzCF1q3+Eox
oRBiYcpy2ABYWBnhscGAp2F2ImAk7oQCeKqq5NRM/Xe12xiJGYpTbhS70+Koi1JO
wOpp9y95Tuvvblr5ldbFE8GsffnJlbl5yE3v63IfThkAbIWpvHWwaaQ4mxknqlsC
+PZjlZm9SDZZNdVD//VXGbnabMDApwLagBUAjFDe2xkdy6drVACmdV/RXfnWV8/W
xSUIPGwFvzzBZMcwpxGuF3OqItR2t9BNvQjvW8K0S692T5uacfbxwKomUDw4ohV0
T7zhiv1hiA7cbifAENrsX7RKDU42uG6Vx2+CE10QxcPvQTRSq3B6RoQ/VWPKqCvQ
ukD6OcBoO7kTAsQxepLQastSc22s75R3bvnb+jTbhaq2NiFLrqhoaxf7H5hBZdmw
uf/HKyZ2VsdJXhEJtDfmHM+b3IebnfLmIGmm5LiF4FPWztdqJsEYR+go2fpT95jp
QwnlzuVGMfc=
=Lsk0
-----END PGP SIGNATURE-----

--Sig_/ph.gjBA1=nHLWLNnHdHT42u--
