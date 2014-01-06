Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaAFOhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:37:35 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64762 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaAFOhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:37:25 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] ARM: zynq: Split slcr in two parts
Date: Mon,  6 Jan 2014 15:36:38 +0100
Message-Id: <a350cc21baf4ab36c96b7f21e9507d6390b01de0.1389018985.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32332-1389019031-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32332-1389019031-0001

Split the slcr into an early part for unlocking and cpu starting
and a later syscon driver.
Also add "syscon" compatible property for slcr.

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/boot/dts/zynq-7000.dtsi |  2 +-
 arch/arm/mach-zynq/Kconfig       |  1 +
 arch/arm/mach-zynq/common.c      |  4 +++-
 arch/arm/mach-zynq/common.h      |  1 +
 arch/arm/mach-zynq/slcr.c        | 20 ++++++++++++++++++++
 5 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 93d1980..81e5677 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -123,7 +123,7 @@
 		} ;

 		slcr: slcr@f8000000 {
-			compatible = "xlnx,zynq-slcr";
+			compatible = "xlnx,zynq-slcr", "syscon";
 			reg = <0xF8000000 0x1000>;

 			clocks {
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index 6b04260..323e505 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -14,5 +14,6 @@ config ARCH_ZYNQ
 	select SPARSE_IRQ
 	select CADENCE_TTC_TIMER
 	select ARM_GLOBAL_TIMER
+	select MFD_SYSCON
 	help
 	  Support for Xilinx Zynq ARM Cortex A9 Platform
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index bf6717f..38401cf 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -59,11 +59,13 @@ static void __init zynq_init_machine(void)
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);

 	platform_device_register(&zynq_cpuidle_device);
+
+	zynq_slcr_init();
 }

 static void __init zynq_timer_init(void)
 {
-	zynq_slcr_init();
+	zynq_early_slcr_init();

 	zynq_clock_init(zynq_slcr_base);
 	clocksource_of_init();
diff --git a/arch/arm/mach-zynq/common.h b/arch/arm/mach-zynq/common.h
index c22c92c..1548b85 100644
--- a/arch/arm/mach-zynq/common.h
+++ b/arch/arm/mach-zynq/common.h
@@ -20,6 +20,7 @@
 void zynq_secondary_startup(void);

 extern int zynq_slcr_init(void);
+extern int zynq_early_slcr_init(void);
 extern void zynq_slcr_system_reset(void);
 extern void zynq_slcr_cpu_stop(int cpu);
 extern void zynq_slcr_cpu_start(int cpu);
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index 59ad09f..9746de7 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -15,7 +15,9 @@
  */

 #include <linux/io.h>
+#include <linux/mfd/syscon.h>
 #include <linux/of_address.h>
+#include <linux/regmap.h>
 #include <linux/clk/zynq.h>
 #include "common.h"

@@ -30,6 +32,7 @@
 #define SLCR_A9_CPU_RST			0x1

 void __iomem *zynq_slcr_base;
+static struct regmap *zynq_slcr_regmap;

 /**
  * zynq_slcr_system_reset - Reset the entire system.
@@ -87,6 +90,23 @@ void zynq_slcr_cpu_stop(int cpu)
  */
 int __init zynq_slcr_init(void)
 {
+	zynq_slcr_regmap = syscon_regmap_lookup_by_compatible("xlnx,zynq-slcr");
+	if (IS_ERR(zynq_slcr_regmap)) {
+		pr_err("%s: failed to find zynq-slcr\n", __func__);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/**
+ * zynq_early_slcr_init
+ * Returns 0 on success, negative errno otherwise.
+ *
+ * Called very early during boot from platform code to unlock SLCR.
+ */
+int __init zynq_early_slcr_init(void)
+{
 	struct device_node *np;

 	np = of_find_compatible_node(NULL, NULL, "xlnx,zynq-slcr");
--
1.8.2.3


--=_mimegpg-monstr-desktop-32332-1389019031-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLKv5cACgkQykllyylKDCFACQCbBrxt5WE6fn3zLJkT+IkK1YAx
qpkAn22chEv2kxCcgWq7O0E6T9Hq/S7g
=XbOx
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32332-1389019031-0001--
