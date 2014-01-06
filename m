Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaAFOho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:37:44 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:54592 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbaAFOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:37:39 -0500
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
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] ARM: zynq: Map I/O memory on clkc init
Date: Mon,  6 Jan 2014 15:36:40 +0100
Message-Id: <4bac17e1725877eb915079ff6085aa74ef8c0341.1389018985.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1389018985.git.michal.simek@xilinx.com>
References: <cover.1389018985.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-32354-1389019052-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-32354-1389019052-0001

The clkc has its registers in the range of the slcr.
Instead of passing around the slcr base address pointer, let the clkc get the
address from the DT.
This prepares the slcr to be a real driver with multiple memory ranges
(slcr, clocks, pinctrl,...)

Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 .../devicetree/bindings/clock/zynq-7000.txt        |  4 +-
 arch/arm/boot/dts/zynq-7000.dtsi                   | 40 +++++-----
 arch/arm/mach-zynq/common.c                        |  2 +-
 drivers/clk/zynq/clkc.c                            | 89 +++++++++++++++-------
 include/linux/clk/zynq.h                           |  2 +-
 5 files changed, 87 insertions(+), 50 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/zynq-7000.txt b/Documentation/devicetree/bindings/clock/zynq-7000.txt
index d99af87..401e26a 100644
--- a/Documentation/devicetree/bindings/clock/zynq-7000.txt
+++ b/Documentation/devicetree/bindings/clock/zynq-7000.txt
@@ -14,6 +14,7 @@ for all clock consumers of PS clocks.
 Required properties:
  - #clock-cells : Must be 1
  - compatible : "xlnx,ps7-clkc"
+ - reg : SLCR offset and size taken via syscon < 0x100 0x100 >
  - ps-clk-frequency : Frequency of the oscillator providing ps_clk in HZ
 		      (usually 33 MHz oscillators are used for Zynq platforms)
  - clock-output-names : List of strings used to name the clock outputs. Shall be
@@ -83,10 +84,11 @@ Clock outputs:
  47: dbg_apb

 Example:
-	clkc: clkc {
+	clkc: clkc@100 {
 		#clock-cells = <1>;
 		compatible = "xlnx,ps7-clkc";
 		ps-clk-frequency = <33333333>;
+		reg = <0x100 0x100>;
 		clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x",
 				"cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x",
 				"dci", "lqspi", "smc", "pcap", "gem0", "gem1",
diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 81e5677..1d942e2 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -123,30 +123,28 @@
 		} ;

 		slcr: slcr@f8000000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
 			compatible = "xlnx,zynq-slcr", "syscon";
 			reg = <0xF8000000 0x1000>;

-			clocks {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				clkc: clkc {
-					#clock-cells = <1>;
-					compatible = "xlnx,ps7-clkc";
-					ps-clk-frequency = <33333333>;
-					fclk-enable = <0>;
-					clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x",
-							"cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x",
-							"dci", "lqspi", "smc", "pcap", "gem0", "gem1",
-							"fclk0", "fclk1", "fclk2", "fclk3", "can0", "can1",
-							"sdio0", "sdio1", "uart0", "uart1", "spi0", "spi1",
-							"dma", "usb0_aper", "usb1_aper", "gem0_aper",
-							"gem1_aper", "sdio0_aper", "sdio1_aper",
-							"spi0_aper", "spi1_aper", "can0_aper", "can1_aper",
-							"i2c0_aper", "i2c1_aper", "uart0_aper", "uart1_aper",
-							"gpio_aper", "lqspi_aper", "smc_aper", "swdt",
-							"dbg_trc", "dbg_apb";
-				};
+			clkc: clkc@100 {
+				#clock-cells = <1>;
+				compatible = "xlnx,ps7-clkc";
+				ps-clk-frequency = <33333333>;
+				fclk-enable = <0>;
+				clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x",
+						"cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x",
+						"dci", "lqspi", "smc", "pcap", "gem0", "gem1",
+						"fclk0", "fclk1", "fclk2", "fclk3", "can0", "can1",
+						"sdio0", "sdio1", "uart0", "uart1", "spi0", "spi1",
+						"dma", "usb0_aper", "usb1_aper", "gem0_aper",
+						"gem1_aper", "sdio0_aper", "sdio1_aper",
+						"spi0_aper", "spi1_aper", "can0_aper", "can1_aper",
+						"i2c0_aper", "i2c1_aper", "uart0_aper", "uart1_aper",
+						"gpio_aper", "lqspi_aper", "smc_aper", "swdt",
+						"dbg_trc", "dbg_apb";
+				reg = <0x100 0x100>;
 			};
 		};

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 38401cf..93ea19b 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -67,7 +67,7 @@ static void __init zynq_timer_init(void)
 {
 	zynq_early_slcr_init();

-	zynq_clock_init(zynq_slcr_base);
+	zynq_clock_init();
 	clocksource_of_init();
 }

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index 10772aa..088b8fb 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -21,34 +21,35 @@
 #include <linux/clk/zynq.h>
 #include <linux/clk-provider.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/io.h>

-static void __iomem *zynq_slcr_base_priv;
-
-#define SLCR_ARMPLL_CTRL		(zynq_slcr_base_priv + 0x100)
-#define SLCR_DDRPLL_CTRL		(zynq_slcr_base_priv + 0x104)
-#define SLCR_IOPLL_CTRL			(zynq_slcr_base_priv + 0x108)
-#define SLCR_PLL_STATUS			(zynq_slcr_base_priv + 0x10c)
-#define SLCR_ARM_CLK_CTRL		(zynq_slcr_base_priv + 0x120)
-#define SLCR_DDR_CLK_CTRL		(zynq_slcr_base_priv + 0x124)
-#define SLCR_DCI_CLK_CTRL		(zynq_slcr_base_priv + 0x128)
-#define SLCR_APER_CLK_CTRL		(zynq_slcr_base_priv + 0x12c)
-#define SLCR_GEM0_CLK_CTRL		(zynq_slcr_base_priv + 0x140)
-#define SLCR_GEM1_CLK_CTRL		(zynq_slcr_base_priv + 0x144)
-#define SLCR_SMC_CLK_CTRL		(zynq_slcr_base_priv + 0x148)
-#define SLCR_LQSPI_CLK_CTRL		(zynq_slcr_base_priv + 0x14c)
-#define SLCR_SDIO_CLK_CTRL		(zynq_slcr_base_priv + 0x150)
-#define SLCR_UART_CLK_CTRL		(zynq_slcr_base_priv + 0x154)
-#define SLCR_SPI_CLK_CTRL		(zynq_slcr_base_priv + 0x158)
-#define SLCR_CAN_CLK_CTRL		(zynq_slcr_base_priv + 0x15c)
-#define SLCR_CAN_MIOCLK_CTRL		(zynq_slcr_base_priv + 0x160)
-#define SLCR_DBG_CLK_CTRL		(zynq_slcr_base_priv + 0x164)
-#define SLCR_PCAP_CLK_CTRL		(zynq_slcr_base_priv + 0x168)
-#define SLCR_FPGA0_CLK_CTRL		(zynq_slcr_base_priv + 0x170)
-#define SLCR_621_TRUE			(zynq_slcr_base_priv + 0x1c4)
-#define SLCR_SWDT_CLK_SEL		(zynq_slcr_base_priv + 0x304)
+static void __iomem *zynq_clkc_base;
+
+#define SLCR_ARMPLL_CTRL		(zynq_clkc_base + 0x00)
+#define SLCR_DDRPLL_CTRL		(zynq_clkc_base + 0x04)
+#define SLCR_IOPLL_CTRL			(zynq_clkc_base + 0x08)
+#define SLCR_PLL_STATUS			(zynq_clkc_base + 0x0c)
+#define SLCR_ARM_CLK_CTRL		(zynq_clkc_base + 0x20)
+#define SLCR_DDR_CLK_CTRL		(zynq_clkc_base + 0x24)
+#define SLCR_DCI_CLK_CTRL		(zynq_clkc_base + 0x28)
+#define SLCR_APER_CLK_CTRL		(zynq_clkc_base + 0x2c)
+#define SLCR_GEM0_CLK_CTRL		(zynq_clkc_base + 0x40)
+#define SLCR_GEM1_CLK_CTRL		(zynq_clkc_base + 0x44)
+#define SLCR_SMC_CLK_CTRL		(zynq_clkc_base + 0x48)
+#define SLCR_LQSPI_CLK_CTRL		(zynq_clkc_base + 0x4c)
+#define SLCR_SDIO_CLK_CTRL		(zynq_clkc_base + 0x50)
+#define SLCR_UART_CLK_CTRL		(zynq_clkc_base + 0x54)
+#define SLCR_SPI_CLK_CTRL		(zynq_clkc_base + 0x58)
+#define SLCR_CAN_CLK_CTRL		(zynq_clkc_base + 0x5c)
+#define SLCR_CAN_MIOCLK_CTRL		(zynq_clkc_base + 0x60)
+#define SLCR_DBG_CLK_CTRL		(zynq_clkc_base + 0x64)
+#define SLCR_PCAP_CLK_CTRL		(zynq_clkc_base + 0x68)
+#define SLCR_FPGA0_CLK_CTRL		(zynq_clkc_base + 0x70)
+#define SLCR_621_TRUE			(zynq_clkc_base + 0xc4)
+#define SLCR_SWDT_CLK_SEL		(zynq_clkc_base + 0x204)

 #define NUM_MIO_PINS	54

@@ -557,8 +558,44 @@ static void __init zynq_clk_setup(struct device_node *np)

 CLK_OF_DECLARE(zynq_clkc, "xlnx,ps7-clkc", zynq_clk_setup);

-void __init zynq_clock_init(void __iomem *slcr_base)
+void __init zynq_clock_init(void)
 {
-	zynq_slcr_base_priv = slcr_base;
+	struct device_node *np;
+	struct device_node *slcr;
+	struct resource res;
+
+	np = of_find_compatible_node(NULL, NULL, "xlnx,ps7-clkc");
+	if (!np) {
+		pr_err("%s: clkc node not found\n", __func__);
+		goto np_err;
+	}
+
+	if (of_address_to_resource(np, 0, &res)) {
+		pr_err("%s: failed to get resource\n", np->name);
+		goto np_err;
+	}
+
+	slcr = of_get_parent(np);
+
+	if (slcr->data) {
+		zynq_clkc_base = (void __iomem *)slcr->data + res.start;
+	} else {
+		pr_err("%s: Unable to get I/O memory\n", np->name);
+		of_node_put(slcr);
+		goto np_err;
+	}
+
+	pr_info("%s: clkc starts at %p\n", __func__, zynq_clkc_base);
+
+	of_node_put(slcr);
+	of_node_put(np);
+
 	of_clk_init(NULL);
+
+	return;
+
+np_err:
+	of_node_put(np);
+	BUG();
+	return;
 }
diff --git a/include/linux/clk/zynq.h b/include/linux/clk/zynq.h
index e062d31..7a5633b 100644
--- a/include/linux/clk/zynq.h
+++ b/include/linux/clk/zynq.h
@@ -22,7 +22,7 @@

 #include <linux/spinlock.h>

-void zynq_clock_init(void __iomem *slcr);
+void zynq_clock_init(void);

 struct clk *clk_register_zynq_pll(const char *name, const char *parent,
 		void __iomem *pll_ctrl, void __iomem *pll_status, u8 lock_index,
--
1.8.2.3


--=_mimegpg-monstr-desktop-32354-1389019052-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLKv6wACgkQykllyylKDCHg7wCeN87P+6/8VqMGElspzjtZpiFR
M0UAnA9C9jSevHaS/WfQabGhhoyXUuib
=csRx
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-32354-1389019052-0001--
