Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaKGXc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:32:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbaKGXc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:32:58 -0500
Date: Sat, 8 Nov 2014 10:32:49 +1100
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>
Subject: [PATCH] w1: support auto-load of w1_bq27000 module.
Message-ID: <20141108103249.4f86786c@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5K64Eh+R94GOCIh=ZN+=6LQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5K64Eh+R94GOCIh=ZN+=6LQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



1/ change request_module call to zero-pad single digit
   family numbers.  This appears to be the intention of
   the code, but not what it actually does.

   This means that the alias created for W1_FAMILY_SMEM_01
   might actually be useful.

2/ Define a family name for the BQ27000 battery charge monitor.
   Unfortunately this is the same number as W1_FAMILY_SMEM_01
   so if both a compiled on a system, one module might need to
   be blacklisted.

3/ Add a MODULE_ALIAS for the bq27000.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index afbefed5f2c9..caafb1722783 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -88,7 +88,7 @@ static struct w1_family_ops w1_bq27000_fops =3D {
 };
=20
 static struct w1_family w1_bq27000_family =3D {
-	.fid =3D 1,
+	.fid =3D W1_FAMILY_BQ27000,
 	.fops =3D &w1_bq27000_fops,
 };
=20
@@ -111,7 +111,7 @@ module_exit(w1_bq27000_exit);
=20
 module_param(F_ID, int, S_IRUSR);
 MODULE_PARM_DESC(F_ID, "1-wire slave FID for BQ device");
-
+MODULE_ALIAS("w1-family-" __stringify(W1_FAMILY_BQ27000));
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Texas Instruments Ltd");
 MODULE_DESCRIPTION("HDQ/1-wire slave driver bq27000 battery monitor chip");
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 592f7edc671e..181f41cb960b 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -727,7 +727,7 @@ int w1_attach_slave_device(struct w1_master *dev, struc=
t w1_reg_num *rn)
=20
 	/* slave modules need to be loaded in a context with unlocked mutex */
 	mutex_unlock(&dev->mutex);
-	request_module("w1-family-0x%0x", rn->family);
+	request_module("w1-family-0x%02x", rn->family);
 	mutex_lock(&dev->mutex);
=20
 	spin_lock(&w1_flock);
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 0d18365b61ad..ed5dcb80a1f7 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -27,6 +27,7 @@
 #include <linux/atomic.h>
=20
 #define W1_FAMILY_DEFAULT	0
+#define W1_FAMILY_BQ27000	0x01
 #define W1_FAMILY_SMEM_01	0x01
 #define W1_FAMILY_SMEM_81	0x81
 #define W1_THERM_DS18S20 	0x10

--Sig_/5K64Eh+R94GOCIh=ZN+=6LQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF1WoTnsnt1WYoG5AQK7TRAAp8p1G0OwaJf5n0dqoiTaXSShUgocaj7k
J6ulEZUC+zFCVn4gsSAHarfRrpPP4ioPSwt31Te6RxRDG7F1hTexuqSynI3kUf4R
9B5AeRJHf3nGI7js96OQJzPmdLuAKMEmmnOn9Hus72qwE6ZLCI2f7bCAVFPBQnaV
3jP9U9cLVEXYb/EfLGVBOjlYBxdiCS+HH+xQNoZjYNPhQrcxAaTVjZ866y1z0u8p
zWfB3gpsyDoKvUOQF6z4a+BFnCuBXFsABz8vBM3DO0Ab1+IlrW35Y8ASlu19RchJ
S4toeIIebVJmwAr7kMKLtjVqrALf6dDctKmC5PLQ3fo/kUe/UIfEDmBDBqjHmoJY
00iJqkxG0U4EUeltCiV2lTOkuK1lz2/BPpYJxI8rFX0tvaL2bMcnnZLOxPIBXGnO
SCwVLqNBdqJynGQbcElpaqvQvUlr5mZhpELaPSV3bDA+vqBMxXuWvP5YfyM5RGja
48lL1cCttlOua7AwXFf1CdXGWilfZm9NOkg/Q5RLXx+G0V702Ahe1Z3N5EmEtJgX
rQsL95gdkXyEhrVQ4z7H1OGc1YXCEe3J9YNTliunmKqmpz7O2N4SkQ+p0n4n8k9h
Hzi9MinHSM5XgLRCSvHL2s+M/vIj1Ga0xiAJWSDO7n8qCvOZOfQARaHDvjXlIvJC
Q3gjdESlmck=
=Dx7l
-----END PGP SIGNATURE-----

--Sig_/5K64Eh+R94GOCIh=ZN+=6LQ--
