Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbaFIUW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:22:56 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46072 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbaFIUWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:22:53 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, gabriel.fernandez@st.com,
        daniel.thompson@linaro.org
Subject: [PATCH] ARM: STi: DT: Properly define sti-ethclk & stmmaceth for stih415/6
Date: Mon,  9 Jun 2014 21:22:35 +0100
Message-Id: <1402345355-5682-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two problems: -

1) The device tree isn't currently providing sti-ethclk which is
required by the dwmac glue code to correctly configure the ethernet
PHY clock speed.

This means depending on what the bootloader/jtag has
configured this clock to, and what switch/hub the board is plugged
into you most likely will NOT successfully negotiate a ethernet link.

2) The stmmaceth clock was associated with the wrong clock. It was
referencing the PHY clock rather than the interconnect clock which
clocks the IP.

This patch also brings us closer to not having to boot the upstream
kernel with the clk_ignore_unused parameter.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih415.dtsi           | 8 ++++----
 arch/arm/boot/dts/stih416.dtsi           | 8 ++++----
 include/dt-bindings/clock/stih415-clks.h | 1 +
 include/dt-bindings/clock/stih416-clks.h | 1 +
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
index c81dce4..768bf27 100644
--- a/arch/arm/boot/dts/stih415.dtsi
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -169,8 +169,8 @@
 
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_mii0>;
-			clock-names	= "stmmaceth";
-			clocks		= <&clk_s_a1_ls CLK_GMAC0_PHY>;
+			clock-names	= "stmmaceth", "sti-ethclk";
+			clocks		= <&clk_s_a1_ls CLK_ICN_IF_2>, <&clk_s_a1_ls CLK_GMAC0_PHY>;
 		};
 
 		ethernet1: dwmac@fef08000 {
@@ -189,11 +189,11 @@
 			st,syscon		= <&syscfg_sbc>;
 
 			resets			= <&softreset STIH415_ETH1_SOFTRESET>;
-			reset-names		= "stmmaceth";
+			reset-names		= "stmmaceth", "sti-ethclk";
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_mii1>;
 			clock-names	= "stmmaceth";
-			clocks		= <&clk_s_a0_ls CLK_ETH1_PHY>;
+			clocks		= <&clk_s_a0_ls CLK_ICN_REG>, <&clk_s_a0_ls CLK_ETH1_PHY>;
 		};
 
 		rc: rc@fe518000 {
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 6473287..98c43cc 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -175,8 +175,8 @@
 			reset-names		= "stmmaceth";
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_mii0>;
-			clock-names	= "stmmaceth";
-			clocks		= <&clk_s_a1_ls CLK_GMAC0_PHY>;
+			clock-names	= "stmmaceth", "sti-ethclk";
+			clocks		= <&clk_s_a1_ls CLK_ICN_IF_2>, <&clk_s_a1_ls CLK_GMAC0_PHY>;
 		};
 
 		ethernet1: dwmac@fef08000 {
@@ -197,8 +197,8 @@
 			reset-names	= "stmmaceth";
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_mii1>;
-			clock-names	= "stmmaceth";
-			clocks		= <&clk_s_a0_ls CLK_ETH1_PHY>;
+			clock-names	= "stmmaceth", "sti-ethclk";
+			clocks		= <&clk_s_a0_ls CLK_ICN_REG>, <&clk_s_a0_ls CLK_ETH1_PHY>;
 		};
 
 		rc: rc@fe518000 {
diff --git a/include/dt-bindings/clock/stih415-clks.h b/include/dt-bindings/clock/stih415-clks.h
index 0d2c739..d80caa6 100644
--- a/include/dt-bindings/clock/stih415-clks.h
+++ b/include/dt-bindings/clock/stih415-clks.h
@@ -10,6 +10,7 @@
 #define CLK_ETH1_PHY		4
 
 /* CLOCKGEN A1 */
+#define CLK_ICN_IF_2		0
 #define CLK_GMAC0_PHY		3
 
 #endif
diff --git a/include/dt-bindings/clock/stih416-clks.h b/include/dt-bindings/clock/stih416-clks.h
index 552c779..f9bdbd1 100644
--- a/include/dt-bindings/clock/stih416-clks.h
+++ b/include/dt-bindings/clock/stih416-clks.h
@@ -10,6 +10,7 @@
 #define CLK_ETH1_PHY		4
 
 /* CLOCKGEN A1 */
+#define CLK_ICN_IF_2		0
 #define CLK_GMAC0_PHY		3
 
 #endif
-- 
1.9.1

