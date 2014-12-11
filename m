Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaLKKqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:46:21 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60842 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaLKKqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:46:19 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: zynq: Simplify SLCR initialization
Date: Thu, 11 Dec 2014 11:46:15 +0100
Message-Id: <ecea997783301834c1bd39ea32e3ac3f3141620f.1418294772.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-31721-1418294775-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-31721-1418294775-0001

Based on
"mfd: syscon: Decouple syscon interface from platform devices"
(sha1: bdb0066df96e74a4002125467ebe459feff1ebef)
SLCR driver can use syscon/regmap drivers directly.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 arch/arm/mach-zynq/common.c |  2 --
 arch/arm/mach-zynq/slcr.c   | 35 +++++++----------------------------
 2 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 26f92c28d22b..c887196cfdbe 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -146,8 +146,6 @@ out:

 	platform_device_register(&zynq_cpuidle_device);
 	platform_device_register_full(&devinfo);
-
-	zynq_slcr_init();
 }

 static void __init zynq_timer_init(void)
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index d4cb50cf97c0..c3c24fd8b306 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -47,11 +47,6 @@ static struct regmap *zynq_slcr_regmap;
  */
 static int zynq_slcr_write(u32 val, u32 offset)
 {
-	if (!zynq_slcr_regmap) {
-		writel(val, zynq_slcr_base + offset);
-		return 0;
-	}
-
 	return regmap_write(zynq_slcr_regmap, offset, val);
 }

@@ -65,12 +60,7 @@ static int zynq_slcr_write(u32 val, u32 offset)
  */
 static int zynq_slcr_read(u32 *val, u32 offset)
 {
-	if (zynq_slcr_regmap)
-		return regmap_read(zynq_slcr_regmap, offset, val);
-
-	*val = readl(zynq_slcr_base + offset);
-
-	return 0;
+	return regmap_read(zynq_slcr_regmap, offset, val);
 }

 /**
@@ -196,23 +186,6 @@ void zynq_slcr_cpu_state_write(int cpu, bool die)
 }

 /**
- * zynq_slcr_init - Regular slcr driver init
- * Return:	0 on success, negative errno otherwise.
- *
- * Called early during boot from platform code to remap SLCR area.
- */
-int __init zynq_slcr_init(void)
-{
-	zynq_slcr_regmap = syscon_regmap_lookup_by_compatible("xlnx,zynq-slcr");
-	if (IS_ERR(zynq_slcr_regmap)) {
-		pr_err("%s: failed to find zynq-slcr\n", __func__);
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-/**
  * zynq_early_slcr_init - Early slcr init function
  *
  * Return:	0 on success, negative errno otherwise.
@@ -237,6 +210,12 @@ int __init zynq_early_slcr_init(void)

 	np->data = (__force void *)zynq_slcr_base;

+	zynq_slcr_regmap = syscon_regmap_lookup_by_compatible("xlnx,zynq-slcr");
+	if (IS_ERR(zynq_slcr_regmap)) {
+		pr_err("%s: failed to find zynq-slcr\n", __func__);
+		return -ENODEV;
+	}
+
 	/* unlock the SLCR so that registers can be changed */
 	zynq_slcr_unlock();

--
1.8.2.3


--=_mimegpg-monstr-desktop-31721-1418294775-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlSJdfcACgkQykllyylKDCFaHwCeIim7HE87N1gEsu+rnDAYUrHg
opoAn2/hzph3p8mryY7xuexy4CP6sIEL
=yi3b
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-31721-1418294775-0001--
