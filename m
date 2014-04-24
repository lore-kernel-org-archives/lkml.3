Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaDXUgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:36:35 -0400
Received: from mout.gmx.net ([212.227.17.22]:61139 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaDXUge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:36:34 -0400
Date: Thu, 24 Apr 2014 22:35:56 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: coelho@ti.com
Cc: linville@tuxdriver.com, peterhuewe@gmx.de, s.jegen@gmail.com,
        jg1.han@samsung.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: fix usage of platform_device_add_data()
Message-ID: <20140424223556.34beb0c5@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/i36mhlZS2B6vjOWZbiUPOxj"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:FV/5TSncInCkFTQAxeRmS2nM2OOvdyrMjinNgg7ikozMaR64evr
 3yTUusJihBHihJnbPieQggFmRRlEsZ+KDLhsInY2MVUBHpH890K6Sboc/9C1rcSUOZP/p9j
 88YMR1CNzfqM9yC09yZLgmgutwtwCB/rz26IWvO5giCYbUMfkTNIaQncN9Jj57+HjTv2T3a
 DwhfWYiLnCVopxsigQXew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/i36mhlZS2B6vjOWZbiUPOxj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Coverity CID 986698 reports leakage of struct wlcore_platdev_data in the
probe functions of both the SPI/SDIO interfaces. The structure passed to
platform_device_add_data() is dynamically allocated and only freed in the
error paths, however, platform_device_add_data() adds a copy of the platform
specific data to the device. Move the temporary struct that is kmemdup'ed
to the stack. This issue exists since afb43e6d (wlcore: remove if_ops from
platform_data).

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
Applies against v3.15-rc2 as well as branch master in tree
git.kernel.org/pub/scm/linux/kernel/git/linville/wireless.git and is compile
tested only.
---
 drivers/net/wireless/ti/wlcore/sdio.c | 28 +++++++++++-----------------
 drivers/net/wireless/ti/wlcore/spi.c  | 23 +++++++++--------------
 2 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/t=
i/wlcore/sdio.c
index 29ef249..d3dd7bf 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -217,7 +217,7 @@ static struct wl1271_if_operations sdio_ops =3D {
 static int wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
-	struct wlcore_platdev_data *pdev_data;
+	struct wlcore_platdev_data pdev_data;
 	struct wl12xx_sdio_glue *glue;
 	struct resource res[1];
 	mmc_pm_flag_t mmcflags;
@@ -228,16 +228,13 @@ static int wl1271_probe(struct sdio_func *func,
 	if (func->num !=3D 0x02)
 		return -ENODEV;
=20
-	pdev_data =3D kzalloc(sizeof(*pdev_data), GFP_KERNEL);
-	if (!pdev_data)
-		goto out;
-
-	pdev_data->if_ops =3D &sdio_ops;
+	memset(&pdev_data, 0x00, sizeof(pdev_data));
+	pdev_data.if_ops =3D &sdio_ops;
=20
 	glue =3D kzalloc(sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&func->dev, "can't allocate glue\n");
-		goto out_free_pdev_data;
+		goto out;
 	}
=20
 	glue->dev =3D &func->dev;
@@ -248,9 +245,9 @@ static int wl1271_probe(struct sdio_func *func,
 	/* Use block mode for transferring over one block size of data */
 	func->card->quirks |=3D MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
=20
-	pdev_data->pdata =3D wl12xx_get_platform_data();
-	if (IS_ERR(pdev_data->pdata)) {
-		ret =3D PTR_ERR(pdev_data->pdata);
+	pdev_data.pdata =3D wl12xx_get_platform_data();
+	if (IS_ERR(pdev_data.pdata)) {
+		ret =3D PTR_ERR(pdev_data.pdata);
 		dev_err(glue->dev, "missing wlan platform data: %d\n", ret);
 		goto out_free_glue;
 	}
@@ -260,7 +257,7 @@ static int wl1271_probe(struct sdio_func *func,
 	dev_dbg(glue->dev, "sdio PM caps =3D 0x%x\n", mmcflags);
=20
 	if (mmcflags & MMC_PM_KEEP_POWER)
-		pdev_data->pdata->pwr_in_suspend =3D true;
+		pdev_data.pdata->pwr_in_suspend =3D true;
=20
 	sdio_set_drvdata(func, glue);
=20
@@ -289,7 +286,7 @@ static int wl1271_probe(struct sdio_func *func,
=20
 	memset(res, 0x00, sizeof(res));
=20
-	res[0].start =3D pdev_data->pdata->irq;
+	res[0].start =3D pdev_data.pdata->irq;
 	res[0].flags =3D IORESOURCE_IRQ;
 	res[0].name =3D "irq";
=20
@@ -299,8 +296,8 @@ static int wl1271_probe(struct sdio_func *func,
 		goto out_dev_put;
 	}
=20
-	ret =3D platform_device_add_data(glue->core, pdev_data,
-				       sizeof(*pdev_data));
+	ret =3D platform_device_add_data(glue->core, &pdev_data,
+				       sizeof(pdev_data));
 	if (ret) {
 		dev_err(glue->dev, "can't add platform data\n");
 		goto out_dev_put;
@@ -319,9 +316,6 @@ out_dev_put:
 out_free_glue:
 	kfree(glue);
=20
-out_free_pdev_data:
-	kfree(pdev_data);
-
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti=
/wlcore/spi.c
index dbe826d..5f3a389 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -327,27 +327,25 @@ static struct wl1271_if_operations spi_ops =3D {
 static int wl1271_probe(struct spi_device *spi)
 {
 	struct wl12xx_spi_glue *glue;
-	struct wlcore_platdev_data *pdev_data;
+	struct wlcore_platdev_data pdev_data;
 	struct resource res[1];
 	int ret =3D -ENOMEM;
=20
-	pdev_data =3D kzalloc(sizeof(*pdev_data), GFP_KERNEL);
-	if (!pdev_data)
-		goto out;
+	memset(&pdev_data, 0x00, sizeof(pdev_data));
=20
-	pdev_data->pdata =3D dev_get_platdata(&spi->dev);
-	if (!pdev_data->pdata) {
+	pdev_data.pdata =3D dev_get_platdata(&spi->dev);
+	if (!pdev_data.pdata) {
 		dev_err(&spi->dev, "no platform data\n");
 		ret =3D -ENODEV;
-		goto out_free_pdev_data;
+		goto out;
 	}
=20
-	pdev_data->if_ops =3D &spi_ops;
+	pdev_data.if_ops =3D &spi_ops;
=20
 	glue =3D kzalloc(sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&spi->dev, "can't allocate glue\n");
-		goto out_free_pdev_data;
+		goto out;
 	}
=20
 	glue->dev =3D &spi->dev;
@@ -385,8 +383,8 @@ static int wl1271_probe(struct spi_device *spi)
 		goto out_dev_put;
 	}
=20
-	ret =3D platform_device_add_data(glue->core, pdev_data,
-				       sizeof(*pdev_data));
+	ret =3D platform_device_add_data(glue->core, &pdev_data,
+				       sizeof(pdev_data));
 	if (ret) {
 		dev_err(glue->dev, "can't add platform data\n");
 		goto out_dev_put;
@@ -406,9 +404,6 @@ out_dev_put:
 out_free_glue:
 	kfree(glue);
=20
-out_free_pdev_data:
-	kfree(pdev_data);
-
 out:
 	return ret;
 }
--=20
1.9.1

--Sig_/i36mhlZS2B6vjOWZbiUPOxj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWXWsAAoJEKssnEpaPQKEy5cP/2rbP8nErYEGMOt0JbgCtUJF
NvNfUleJmwYOiwh0xkyvEeRdeYu4ZBz30rk/RfS3URcqPKUPFpemVQgPwh+OISKf
NA/t63meCsc2pJ7WD0fHReJk6MQZ0QlulV2h7ih751iQ7nYbSsARaHIc42HnDkUl
fqsRVd5+7u/LyciRSv4WH7o/PWRjRPT0TKMt3ieO0vppJ+U1PeY20cu+QtlDfdUk
r3cp71t4vU0p037buMxLb0wnD7aSM08Fin6u6ZUTql9TuGcXjKJx3tzdiYeCTjrZ
QmC2sG1wnH55bHjQT2PspGRhWdEYeG66ogP8tWe9Gl8VUzCPFvq1YIq0EYM0mO1c
QeJLRkcZ9P2NXzroS9PNJtpm1yOpNwOEqN+dhvu63hUOGDMMjD7GOOxY+C95z/DU
vMmzE7lrR8Wq5LZ5vnplUC/XyQMGQ/rcQ+HGJXRT4n8HGl0T5v/JItuxLS3TvdNT
9H9h7PvdtFk4SmmKvtT95MjRnbuwPxEYxxNnwkigmDNQ/IR8NEuhiChTMPhe39Cx
BPGgetC8DdZKdo1vpPcAhJho4ujEgx1tmxFeEbMryTXwP9X+isi3HtCuSmxjLhYA
epPowm/mbkw+Hy84XmFBPVCcqH3azC3qolh8Qt4oUMPt4gJe+2w2XODGo/jE7eCH
ISBQarcO0ID3Mni3TfqM
=qK2y
-----END PGP SIGNATURE-----

--Sig_/i36mhlZS2B6vjOWZbiUPOxj--
