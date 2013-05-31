Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3EaM5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:57:30 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61927 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3EaM4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:56:06 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, Timur Tabi <timur@tabi.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH v3 5/8] video: xilinxfb: Group bus initialization
Date: Fri, 31 May 2013 14:55:35 +0200
Message-Id: <2d8626a5a15f7880c272ee5a2c7f8dee697ac0f3.1370004925.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1370004925.git.michal.simek@xilinx.com>
References: <cover.1370004925.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-8172-1370004961-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-8172-1370004961-0001

Move of_address_to_resource() to xilinxfb_assign()
which simplify driver probing.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3:
- New patch in this patchset

Changes in v2: None

 drivers/video/xilinxfb.c | 56 +++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 41 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 1b55f18..bd3b85d 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -227,33 +227,23 @@ static struct fb_ops xilinxfb_ops =
  * Bus independent setup/teardown
  */

-static int xilinxfb_assign(struct device *dev,
+static int xilinxfb_assign(struct platform_device *pdev,
 			   struct xilinxfb_drvdata *drvdata,
-			   unsigned long physaddr,
 			   struct xilinxfb_platform_data *pdata)
 {
 	int rc;
+	struct device *dev = &pdev->dev;
 	int fbsize = pdata->xvirt * pdata->yvirt * BYTES_PER_PIXEL;

 	if (drvdata->flags & BUS_ACCESS_FLAG) {
-		/*
-		 * Map the control registers in if the controller
-		 * is on direct BUS interface.
-		 */
-		if (!request_mem_region(physaddr, 8, DRIVER_NAME)) {
-			dev_err(dev, "Couldn't lock memory region at 0x%08lX\n",
-				physaddr);
-			rc = -ENODEV;
-			goto err_region;
-		}
+		struct resource *res;

-		drvdata->regs_phys = physaddr;
-		drvdata->regs = ioremap(physaddr, 8);
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		drvdata->regs_phys = res->start;
+		drvdata->regs = devm_request_and_ioremap(&pdev->dev, res);
 		if (!drvdata->regs) {
-			dev_err(dev, "Couldn't lock memory region at 0x%08lX\n",
-				physaddr);
-			rc = -ENODEV;
-			goto err_map;
+			rc = -EADDRNOTAVAIL;
+			goto err_region;
 		}
 	}

@@ -349,11 +339,7 @@ err_cmap:

 err_fbmem:
 	if (drvdata->flags & BUS_ACCESS_FLAG)
-		iounmap(drvdata->regs);
-
-err_map:
-	if (drvdata->flags & BUS_ACCESS_FLAG)
-		release_mem_region(drvdata->regs_phys, 8);
+		devm_iounmap(dev, drvdata->regs);

 err_region:
 	kfree(drvdata);
@@ -384,10 +370,8 @@ static int xilinxfb_release(struct device *dev)
 	xilinx_fb_out32(drvdata, REG_CTRL, 0);

 	/* Release the resources, as allocated based on interface */
-	if (drvdata->flags & BUS_ACCESS_FLAG) {
-		iounmap(drvdata->regs);
-		release_mem_region(drvdata->regs_phys, 8);
-	}
+	if (drvdata->flags & BUS_ACCESS_FLAG)
+		devm_iounmap(dev, drvdata->regs);
 #ifdef CONFIG_PPC_DCR
 	else
 		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
@@ -408,8 +392,7 @@ static int xilinxfb_of_probe(struct platform_device *op)
 	const u32 *prop;
 	u32 tft_access = 0;
 	struct xilinxfb_platform_data pdata;
-	struct resource res;
-	int size, rc;
+	int size;
 	struct xilinxfb_drvdata *drvdata;

 	/* Copy with the default pdata (not a ptr reference!) */
@@ -435,22 +418,17 @@ static int xilinxfb_of_probe(struct platform_device *op)
 	 */
 	if (tft_access) {
 		drvdata->flags |= BUS_ACCESS_FLAG;
-		rc = of_address_to_resource(op->dev.of_node, 0, &res);
-		if (rc) {
-			dev_err(&op->dev, "invalid address\n");
-			goto err;
-		}
 	}
 #ifdef CONFIG_PPC_DCR
 	else {
 		int start;
-		res.start = 0;
 		start = dcr_resource_start(op->dev.of_node, 0);
 		drvdata->dcr_len = dcr_resource_len(op->dev.of_node, 0);
 		drvdata->dcr_host = dcr_map(op->dev.of_node, start, drvdata->dcr_len);
 		if (!DCR_MAP_OK(drvdata->dcr_host)) {
 			dev_err(&op->dev, "invalid DCR address\n");
-			goto err;
+			kfree(drvdata);
+			return -ENODEV;
 		}
 	}
 #endif
@@ -477,11 +455,7 @@ static int xilinxfb_of_probe(struct platform_device *op)
 		pdata.rotate_screen = 1;

 	dev_set_drvdata(&op->dev, drvdata);
-	return xilinxfb_assign(&op->dev, drvdata, res.start, &pdata);
-
- err:
-	kfree(drvdata);
-	return -ENODEV;
+	return xilinxfb_assign(op, drvdata, &pdata);
 }

 static int xilinxfb_of_remove(struct platform_device *op)
--
1.8.2.3


--=_mimegpg-monstr-desktop-8172-1370004961-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGoneEACgkQykllyylKDCFx6gCfSrgNqM1VdLSsE4tw4KizMXmC
l4YAn2ZKhrc/aI5ING785MWEbAUOlNQa
=+G1y
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-8172-1370004961-0001--
