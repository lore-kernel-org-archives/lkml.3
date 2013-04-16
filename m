Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3DPI7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:59:13 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:44912 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3DPI7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:59:07 -0400
From: Girish K S <girishks2000@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com
Subject: [PATCH 1/2] ARM: dts: enable spi for EXYNOS5440 SOC
Date: Tue, 16 Apr 2013 14:28:52 +0530
Message-Id: <1366102733-3570-1-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the SPI in EXYNOS5440 SoC. The NOR
Flash can be accessed by enabling the spi interface

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 arch/arm/boot/dts/exynos5440-ssdk5440.dts |   39 +++++++++++++++++++++++++++-
 arch/arm/boot/dts/exynos5440.dtsi         |   16 +++++++----
 2 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
index d55042b..a85ac0e 100644
--- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
+++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
@@ -20,8 +20,43 @@
 		bootargs = "root=/dev/sda2 rw rootwait ignore_loglevel early_printk no_console_suspend mem=2048M@0x80000000 console=ttySAC0,115200";
 	};
 
-	spi {
-		status = "disabled";
+	spi_0: spi@D0000 {
+
+		flash: w25q128@0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "winbond,w25q128";
+			spi-max-frequency = <15625000>;
+			reg = <0>;
+			controller-data {
+				samsung,spi-feedback-delay = <0>;
+			};
+
+			partition@00000 {
+				label = "BootLoader";
+				reg = <0x60000 0x80000>;
+				read-only;
+			};
+
+			partition@e0000 {
+				label = "Recovery-Kernel";
+				reg = <0xe0000 0x300000>;
+				read-only;
+			};
+
+			partition@3e0000 {
+				label = "CRAM-FS";
+				reg = <0x3e0000 0x700000>;
+				read-only;
+			};
+
+			partition@ae0000 {
+				label = "User-Data";
+				reg = <0xae0000 0x520000>;
+			};
+
+		};
+
 	};
 
 	fixed-rate-clocks {
diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index f6b1c89..7c5dc38 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -16,6 +16,10 @@
 
 	interrupt-parent = <&gic>;
 
+	aliases {
+		spi0 = &spi_0;
+	};
+
 	clock: clock-controller@0x160000 {
 		compatible = "samsung,exynos5440-clock";
 		reg = <0x160000 0x1000>;
@@ -101,15 +105,15 @@
 		clock-names = "uart", "clk_uart_baud0";
 	};
 
-	spi {
-		compatible = "samsung,exynos4210-spi";
-		reg = <0xD0000 0x1000>;
+	spi_0: spi@D0000 {
+		compatible = "samsung,exynos5440-spi";
+		reg = <0xD0000 0x100>;
 		interrupts = <0 4 0>;
-		tx-dma-channel = <&pdma0 5>; /* preliminary */
-		rx-dma-channel = <&pdma0 4>; /* preliminary */
 		#address-cells = <1>;
 		#size-cells = <0>;
-		clocks = <&clock 21>, <&clock 16>;
+		samsung,spi-src-clk = <0>;
+		num-cs = <1>;
+		clocks = <&clock 8>, <&clock 3>;
 		clock-names = "spi", "spi_busclk0";
 	};
 
-- 
1.7.5.4

