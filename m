Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3AKAjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:39:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60770 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3AKAjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:39:15 -0500
Date: Fri, 11 Jan 2013 11:39:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20130111113904.251f5fb5587446dbb10694e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_11_39_04_+1100_6YWA1dO9UnwYL.+4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_11_39_04_+1100_6YWA1dO9UnwYL.+4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/platform/sh_veu.c:1146:22: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'sh_veu_probe'
drivers/media/platform/sh_veu.c:1228:22: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'sh_veu_remove'
drivers/media/platform/sh_veu.c:1244:2: error: implicit declaration of func=
tion '__devexit_p' [-Werror=3Dimplicit-function-declaration]
drivers/media/platform/sh_veu.c:1244:25: error: 'sh_veu_remove' undeclared =
here (not in a function)
drivers/media/platform/sh_veu.c: In function 'sh_veu_init':
drivers/media/platform/sh_veu.c:1253:45: error: 'sh_veu_probe' undeclared (=
first use in this function)
drivers/media/platform/sh_veu.c:1253:45: note: each undeclared identifier i=
s reported only once for each function it appears in
drivers/media/platform/sh_veu.c: At top level:
drivers/media/platform/sh_veu.c:1095:20: warning: 'sh_veu_bh' defined but n=
ot used [-Wunused-function]
drivers/media/platform/sh_veu.c:1109:20: warning: 'sh_veu_isr' defined but =
not used [-Wunused-function]
drivers/media/platform/sh_veu.c: In function 'sh_veu_init':
drivers/media/platform/sh_veu.c:1254:1: warning: control reaches end of non=
-void function [-Wreturn-type]

Caused by commit 05efa71bdc0e ("[media] media: add a VEU MEM2MEM format
conversion and scaling driver") interacting with commit 54b956b90360
("Remove __dev* markings from init.h") from the driver-core.current tree.

I have applied the following merge fix patch which could be applied
directly to the v4l-dvb tree (please):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 11 Jan 2013 11:35:34 +1100
Subject: [PATCH] [media] media: remove __dev* annotations

CONFIG_HOTPLUG is always true now and the __dev* macros have meen removed.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/media/platform/sh_veu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_ve=
u.c
index a018676..cb54c69 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -1143,7 +1143,7 @@ static irqreturn_t sh_veu_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
=20
-static int __devinit sh_veu_probe(struct platform_device *pdev)
+static int sh_veu_probe(struct platform_device *pdev)
 {
 	struct sh_veu_dev *veu;
 	struct resource *reg_res;
@@ -1225,7 +1225,7 @@ einitctx:
 	return ret;
 }
=20
-static int __devexit sh_veu_remove(struct platform_device *pdev)
+static int sh_veu_remove(struct platform_device *pdev)
 {
 	struct v4l2_device *v4l2_dev =3D platform_get_drvdata(pdev);
 	struct sh_veu_dev *veu =3D container_of(v4l2_dev,
@@ -1241,7 +1241,7 @@ static int __devexit sh_veu_remove(struct platform_de=
vice *pdev)
 }
=20
 static struct platform_driver __refdata sh_veu_pdrv =3D {
-	.remove		=3D __devexit_p(sh_veu_remove),
+	.remove		=3D sh_veu_remove,
 	.driver		=3D {
 		.name	=3D "sh_veu",
 		.owner	=3D THIS_MODULE,
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_Jan_2013_11_39_04_+1100_6YWA1dO9UnwYL.+4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ718oAAoJEECxmPOUX5FEllgP/jtGzpYHnBm+ZGsmVsc9/adE
ZT6XzhpIrtwnjZigFZdF9/oY7YP+bJCaeXV/5tMEzgspQ6hWw3D4qYqi3o06Cqwf
q65I4B2vTvGRh4aKJdbT8DdAikNtPyYUAprNf+PExvl9fBd70bi0VAxNJOx0XUam
jKkayYhd46ZwRHbRRn3HEZ6rPMyPmlWshHs4lbdVjaNtPNzl7eP03tXZ9Bk7vjQk
6G/3TmWD42kmAzYXpwSmwKbe2FW7j05zVRz48ByYsS9NuMGln0gBN1Skke33Dz7b
BDGI5h/ctdw8dVv949czsT5KvS5dJGJY5SGFuLihSWLolw6vYUxK+u8giulWK+yo
l3UOxga65NM4LJkwTtA9eQXs6S78JpMt9gJaQwKEslGIAFIspJzqUMTebb+hfBxm
mOqF1akfPPfw8rdJtdyGfXwB5opNxTCbXUOnNykk8ACBSQh1oBIWhJIHjDvm5zQk
V67872V3j32oTlZSZ8sCDOLHt27LR4HpRsO+sy4f1/pq8RW7B25CagppFjgaMYx2
j1KvbMMHULSr1cW5oNSV24Qc6YYNT99jEkFptuYkFlnKTrcyxJFUVT79ljKOMoUj
0FIVaJh5Y+LK5bDmmK5piDHDXedEcUO5zsao/ZsZBuJfMkyTlMgwmPKPEbvd++8Z
rXKIIa/Jtnq8A9g/g10A
=3enB
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_11_39_04_+1100_6YWA1dO9UnwYL.+4--
