Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbaAaOTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:19:11 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62257 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaAaOSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:18:54 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Wim Van Sebroeck <wim@iguana.be>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH 07/10] watchdog: xilinx: Fix OF binding
Date: Fri, 31 Jan 2014 15:18:16 +0100
Message-Id: <26d172891694e4041e73b7dae85a1848adf38034.1391177880.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23148-1391177928-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23148-1391177928-0001

Use of_property_read_u32 functions to clean OF probing.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/watchdog/of_xilinx_wdt.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index c229cc4..475440a6 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -147,8 +147,7 @@ static u32 xwdt_selftest(struct xwdt_device *xdev)
 static int xwdt_probe(struct platform_device *pdev)
 {
 	int rc;
-	u32 *tmptr;
-	u32 *pfreq;
+	u32 pfreq, enable_once;
 	struct resource *res;
 	struct xwdt_device *xdev;
 	bool no_timeout = false;
@@ -168,28 +167,24 @@ static int xwdt_probe(struct platform_device *pdev)
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
+	if (!rc && enable_once) {
 		dev_warn(&pdev->dev,
 			 "Parameter \"xlnx,wdt-enable-once\" not found\n");
 		watchdog_set_nowayout(xilinx_wdt_wdd, true);
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


--=_mimegpg-monstr-desktop-23148-1391177928-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLrsMgACgkQykllyylKDCE2agCffpz8z7kK8Ip6ol0OI3dGmDMq
WmwAnjRwdVNI/5IL2uX6U5skoxGR4Idf
=kCzG
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23148-1391177928-0001--
