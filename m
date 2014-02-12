Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaBLNmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:42:12 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49267 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaBLNmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:42:09 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: linux@roeck-us.net, wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 07/11] watchdog: xilinx: Use of_property_read_u32
Date: Wed, 12 Feb 2014 14:41:21 +0100
Message-Id: <7cbb10853a343c9d488346596f604909ab0668b9.1392212059.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <bdd7c2c78dd491d02d1c1ae8a59b92b7a1a17ec6.1392212059.git.michal.simek@xilinx.com>
References: <bdd7c2c78dd491d02d1c1ae8a59b92b7a1a17ec6.1392212059.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392212059.git.michal.simek@xilinx.com>
References: <cover.1392212059.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12352-1392212509-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12352-1392212509-0001

Use of_property_read_u32 functions to clean probe function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v3:
- Remove one if checking and use variable directly

Changes in v2:
- Fix enable_once logic
- Change patch subject

 drivers/watchdog/of_xilinx_wdt.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index c229cc4..7deea21 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -147,8 +147,7 @@ static u32 xwdt_selftest(struct xwdt_device *xdev)
 static int xwdt_probe(struct platform_device *pdev)
 {
 	int rc;
-	u32 *tmptr;
-	u32 *pfreq;
+	u32 pfreq, enable_once = 0;
 	struct resource *res;
 	struct xwdt_device *xdev;
 	bool no_timeout = false;
@@ -168,32 +167,28 @@ static int xwdt_probe(struct platform_device *pdev)
 	if (IS_ERR(xdev->base))
 		return PTR_ERR(xdev->base);

-	pfreq = (u32 *)of_get_property(pdev->dev.of_node,
-					"clock-frequency", NULL);
-
-	if (pfreq == NULL) {
+	rc = of_property_read_u32(pdev->dev.of_node, "clock-frequency", &pfreq);
+	if (rc) {
 		dev_warn(&pdev->dev,
 			 "The watchdog clock frequency cannot be obtained\n");
 		no_timeout = true;
 	}

-	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
-					"xlnx,wdt-interval", NULL);
-	if (tmptr == NULL) {
+	rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-interval",
+				  &xdev->wdt_interval);
+	if (rc) {
 		dev_warn(&pdev->dev,
 			 "Parameter \"xlnx,wdt-interval\" not found\n");
 		no_timeout = true;
-	} else {
-		xdev->wdt_interval = *tmptr;
 	}

-	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
-					"xlnx,wdt-enable-once", NULL);
-	if (tmptr == NULL) {
+	rc = of_property_read_u32(pdev->dev.of_node, "xlnx,wdt-enable-once",
+				  &enable_once);
+	if (rc)
 		dev_warn(&pdev->dev,
 			 "Parameter \"xlnx,wdt-enable-once\" not found\n");
-		watchdog_set_nowayout(xilinx_wdt_wdd, true);
-	}
+
+	watchdog_set_nowayout(xilinx_wdt_wdd, enable_once);

 /*
  *  Twice of the 2^wdt_interval / freq  because the first wdt overflow is
@@ -201,7 +196,7 @@ static int xwdt_probe(struct platform_device *pdev)
  */
 	if (!no_timeout)
 		xilinx_wdt_wdd->timeout = 2 * ((1 << xdev->wdt_interval) /
-					  *pfreq);
+					  pfreq);

 	spin_lock_init(&xdev->spinlock);
 	watchdog_set_drvdata(xilinx_wdt_wdd, xdev);
--
1.8.2.3


--=_mimegpg-monstr-desktop-12352-1392212509-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL7eh0ACgkQykllyylKDCEyowCeLP4ttxivuVZUm0W6jbI/TnVF
6oQAoJT2q27RDzek5ktBznz9o9lzuffU
=rZNp
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12352-1392212509-0001--
