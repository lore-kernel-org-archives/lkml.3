Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaBSLE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:04:28 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56634 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaBSLEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:04:24 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stephen Warren <swarren@nvidia.com>,
        James Hogan <james.hogan@imgtec.com>,
        Felipe Pena <felipensp@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 2/2] ARM: zynq: Use early syscon initialization
Date: Wed, 19 Feb 2014 12:04:05 +0100
Message-Id: <2cf433e070759e1cb2b0e74eb3d702def738214d.1392807832.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1392807832.git.michal.simek@xilinx.com>
References: <cover.1392807832.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392807832.git.michal.simek@xilinx.com>
References: <cover.1392807832.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32465-1392807858-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32465-1392807858-0001

Use early syscon initialization to simplify slcr code.
- Remove two slcr inits (zynq_slcr_init, zynq_early_slcr_init)
- Directly use regmap accesses in zynq_slcr_read/write
- Remove zynq_clock_init() and use addresses from syscon
  (This is the most problematic part now because clock
  doesn't support regmap accesses that's why reading
  slcr base is ugly. There are some attempts to get
  clk regmap to work - for example:
  https://lkml.org/lkml/2013/10/16/112)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

Changes in v2: None

Especially look at slcr.c which is much simpler than was before.
clkc.c will be simpler when regmap support is added because then
syscon_early_regmap_lookup_by_phandle() will be called
without zynq_slcr_base search.

---
 arch/arm/boot/dts/zynq-7000.dtsi |  1 +
 arch/arm/mach-zynq/common.c      |  6 ++---
 arch/arm/mach-zynq/slcr.c        | 42 ++---------------------------
 drivers/clk/zynq/clkc.c          | 57 ++++++++++++----------------------------
 4 files changed, 23 insertions(+), 83 deletions(-)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 7284499..e414489 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -135,6 +135,7 @@
 			compatible = "xlnx,zynq-slcr", "syscon";
 			reg = <0xF8000000 0x1000>;
 			ranges;
+			syscon = <&slcr>;
 			clkc: clkc@100 {
 				#clock-cells = <1>;
 				compatible = "xlnx,ps7-clkc";
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 9d3c88e..78589e3 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -28,6 +28,7 @@
 #include <linux/of.h>
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/mfd/syscon.h>
 #include <linux/slab.h>
 #include <linux/sys_soc.h>

@@ -130,15 +131,14 @@ out:
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, parent);

 	platform_device_register(&zynq_cpuidle_device);
-
-	zynq_slcr_init();
 }

 static void __init zynq_timer_init(void)
 {
+	early_syscon_init();
+
 	zynq_early_slcr_init();

-	zynq_clock_init();
 	of_clk_init(NULL);
 	clocksource_of_init();
 }
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index 594b280..a89b082 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -35,7 +35,6 @@
 #define SLCR_PSS_IDCODE_DEVICE_SHIFT	12
 #define SLCR_PSS_IDCODE_DEVICE_MASK	0x1F

-static void __iomem *zynq_slcr_base;
 static struct regmap *zynq_slcr_regmap;

 /**
@@ -48,11 +47,6 @@ static struct regmap *zynq_slcr_regmap;
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

@@ -66,12 +60,7 @@ static int zynq_slcr_write(u32 val, u32 offset)
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
@@ -169,24 +158,6 @@ void zynq_slcr_cpu_stop(int cpu)
 }

 /**
- * zynq_slcr_init - Regular slcr driver init
- *
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
@@ -202,20 +173,11 @@ int __init zynq_early_slcr_init(void)
 		pr_err("%s: no slcr node found\n", __func__);
 		BUG();
 	}
-
-	zynq_slcr_base = of_iomap(np, 0);
-	if (!zynq_slcr_base) {
-		pr_err("%s: Unable to map I/O memory\n", __func__);
-		BUG();
-	}
-
-	np->data = (__force void *)zynq_slcr_base;
+	zynq_slcr_regmap = syscon_early_regmap_lookup_by_phandle(np, "syscon");

 	/* unlock the SLCR so that registers can be changed */
 	zynq_slcr_unlock();

-	pr_info("%s mapped to %p\n", np->name, zynq_slcr_base);
-
 	of_node_put(np);

 	return 0;
diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index c812b93..b2fd160 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -214,6 +214,10 @@ err:
 		clks[clk1] = ERR_PTR(-ENOMEM);
 }

+struct syscon {
+	void __iomem *base;
+};
+
 static void __init zynq_clk_setup(struct device_node *np)
 {
 	int i;
@@ -227,6 +231,19 @@ static void __init zynq_clk_setup(struct device_node *np)
 	const char *periph_parents[4];
 	const char *swdt_ext_clk_mux_parents[2];
 	const char *can_mio_mux_parents[NUM_MIO_PINS];
+	struct resource res;
+	void __iomem *zynq_slcr_base;
+
+	struct device_node *slcr = of_get_parent(np);
+	struct syscon *syscon = slcr->data;
+	zynq_slcr_base = syscon->base;
+
+	if (of_address_to_resource(np, 0, &res)) {
+		pr_err("%s: failed to get resource\n", np->name);
+		return;
+	}
+
+	zynq_clkc_base = zynq_slcr_base + res.start;

 	pr_info("Zynq clock init\n");

@@ -569,43 +586,3 @@ static void __init zynq_clk_setup(struct device_node *np)
 }

 CLK_OF_DECLARE(zynq_clkc, "xlnx,ps7-clkc", zynq_clk_setup);
-
-void __init zynq_clock_init(void)
-{
-	struct device_node *np;
-	struct device_node *slcr;
-	struct resource res;
-
-	np = of_find_compatible_node(NULL, NULL, "xlnx,ps7-clkc");
-	if (!np) {
-		pr_err("%s: clkc node not found\n", __func__);
-		goto np_err;
-	}
-
-	if (of_address_to_resource(np, 0, &res)) {
-		pr_err("%s: failed to get resource\n", np->name);
-		goto np_err;
-	}
-
-	slcr = of_get_parent(np);
-
-	if (slcr->data) {
-		zynq_clkc_base = (__force void __iomem *)slcr->data + res.start;
-	} else {
-		pr_err("%s: Unable to get I/O memory\n", np->name);
-		of_node_put(slcr);
-		goto np_err;
-	}
-
-	pr_info("%s: clkc starts at %p\n", __func__, zynq_clkc_base);
-
-	of_node_put(slcr);
-	of_node_put(np);
-
-	return;
-
-np_err:
-	of_node_put(np);
-	BUG();
-	return;
-}
--
1.8.2.3


--=_mimegpg-monstr-desktop-32465-1392807858-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlMEj7IACgkQykllyylKDCGQ1ACfbuI9pgsv2OiTwRWH5JBcItrp
6zwAn26v9/LrCttLNZZCSfsL3iKtV3+p
=J3ZU
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32465-1392807858-0001--
