Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaAaOSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:18:50 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:34213 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbaAaOSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:18:42 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/10] watchdog: xilinx: Simplify probe and remove functions
Date: Fri, 31 Jan 2014 15:18:12 +0100
Message-Id: <578455fd630e70b5de8bae6091568f05e7769057.1391177880.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23095-1391177916-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23095-1391177916-0001

Use devm_ helper function to simplify probe and error path.
Move ioremap to the beginning of probe function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/watchdog/of_xilinx_wdt.c | 41 +++++++++-------------------------------
 1 file changed, 9 insertions(+), 32 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index aca9bab..7f371ed 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -12,6 +12,7 @@

 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -44,7 +45,6 @@
 #define PFX WATCHDOG_NAME ": "

 struct xwdt_device {
-	struct resource  res;
 	void __iomem *base;
 	u32 wdt_interval;
 };
@@ -159,9 +159,15 @@ static int xwdt_probe(struct platform_device *pdev)
 	int rc;
 	u32 *tmptr;
 	u32 *pfreq;
+	struct resource *res;

 	no_timeout = 0;

+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	xdev.base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(xdev.base))
+		return PTR_ERR(xdev.base);
+
 	pfreq = (u32 *)of_get_property(pdev->dev.of_node,
 					"clock-frequency", NULL);

@@ -170,12 +176,6 @@ static int xwdt_probe(struct platform_device *pdev)
 		no_timeout = 1;
 	}

-	rc = of_address_to_resource(pdev->dev.of_node, 0, &xdev.res);
-	if (rc) {
-		pr_warn("invalid address!\n");
-		return rc;
-	}
-
 	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
 					"xlnx,wdt-interval", NULL);
 	if (tmptr == NULL) {
@@ -199,50 +199,27 @@ static int xwdt_probe(struct platform_device *pdev)
 	if (!no_timeout)
 		timeout = 2 * ((1<<xdev.wdt_interval) / *pfreq);

-	if (!request_mem_region(xdev.res.start,
-			xdev.res.end - xdev.res.start + 1, WATCHDOG_NAME)) {
-		rc = -ENXIO;
-		pr_err("memory request failure!\n");
-		goto err_out;
-	}
-
-	xdev.base = ioremap(xdev.res.start, xdev.res.end - xdev.res.start + 1);
-	if (xdev.base == NULL) {
-		rc = -ENOMEM;
-		pr_err("ioremap failure!\n");
-		goto release_mem;
-	}
-
 	rc = xwdt_selftest();
 	if (rc == XWT_TIMER_FAILED) {
 		pr_err("SelfTest routine error!\n");
-		goto unmap_io;
+		return rc;
 	}

 	rc = watchdog_register_device(&xilinx_wdt_wdd);
 	if (rc) {
 		pr_err("cannot register watchdog (err=%d)\n", rc);
-		goto unmap_io;
+		return rc;
 	}

 	dev_info(&pdev->dev, "Xilinx Watchdog Timer at %p with timeout %ds\n",
 		 xdev.base, timeout);

 	return 0;
-
-unmap_io:
-	iounmap(xdev.base);
-release_mem:
-	release_mem_region(xdev.res.start, resource_size(&xdev.res));
-err_out:
-	return rc;
 }

 static int xwdt_remove(struct platform_device *dev)
 {
 	watchdog_unregister_device(&xilinx_wdt_wdd);
-	iounmap(xdev.base);
-	release_mem_region(xdev.res.start, resource_size(&xdev.res));

 	return 0;
 }
--
1.8.2.3


--=_mimegpg-monstr-desktop-23095-1391177916-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLrsLwACgkQykllyylKDCExhgCcDMnoW/I/1WUKucny/filj8L1
mn0AoJMRHfQn+RCkOuMrnFsljIUxKXuu
=D1Lq
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23095-1391177916-0001--
