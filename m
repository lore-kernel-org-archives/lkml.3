Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaBLNf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:35:29 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:53728 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaBLNfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:35:24 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 03/11] watchdog: xilinx: Simplify probe and remove functions
Date: Wed, 12 Feb 2014 14:34:34 +0100
Message-Id: <619599eff39de3551d53c75dd6c95678d9a81df1.1392212059.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1392212059.git.michal.simek@xilinx.com>
References: <cover.1392212059.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392212059.git.michal.simek@xilinx.com>
References: <cover.1392212059.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-11861-1392212117-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-11861-1392212117-0001

Use devm_ helper function to simplify probe and error path.
Move ioremap to the beginning of probe function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v3: None
Changes in v2: None

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


--=_mimegpg-monstr-desktop-11861-1392212117-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL7eJUACgkQykllyylKDCFjGwCcDQ+/QD93s1vxAdWqhAxMQndG
sRAAnAhmxWZq7z78b9ZcOrdu7TuYELtz
=0OQD
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-11861-1392212117-0001--
