Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbaFEMbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:31:18 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10145 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaFEMbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:31:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Jun 2014 05:26:03 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] ARM: tegra: Add efuse and apbmisc bindings
Date: Thu, 5 Jun 2014 15:30:46 +0300
Message-ID: <1401971448-18448-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1401971448-18448-1-git-send-email-pdeschrijver@nvidia.com>
References: <1401971448-18448-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add efuse and apbmisc bindings for Tegra20, Tegra30, Tegra114 and Tegra124.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 .../bindings/fuse/nvidia,tegra20-fuse.txt          |   40 ++++++++++++++++++++
 .../bindings/misc/nvidia,tegra20-apbmisc.txt       |   13 ++++++
 arch/arm/boot/dts/tegra114.dtsi                    |   15 +++++++
 arch/arm/boot/dts/tegra124.dtsi                    |   15 +++++++
 arch/arm/boot/dts/tegra20.dtsi                     |   15 +++++++
 arch/arm/boot/dts/tegra30.dtsi                     |   15 +++++++
 6 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/fuse/nvidia,tegra20-fuse.txt
 create mode 100644 Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt

diff --git a/Documentation/devicetree/bindings/fuse/nvidia,tegra20-fuse.txt b/Documentation/devicetree/bindings/fuse/nvidia,tegra20-fuse.txt
new file mode 100644
index 0000000..d8c98c7
--- /dev/null
+++ b/Documentation/devicetree/bindings/fuse/nvidia,tegra20-fuse.txt
@@ -0,0 +1,40 @@
+NVIDIA Tegra20/Tegra30/Tegr114/Tegra124 fuse block.
+
+Required properties:
+- compatible : should be:
+	"nvidia,tegra20-efuse"
+	"nvidia,tegra30-efuse"
+	"nvidia,tegra114-efuse"
+	"nvidia,tegra124-efuse"
+  Details:
+  nvidia,tegra20-efuse: Tegra20 requires using APB DMA to read the fuse data
+	due to a hardware bug. Tegra20 also lacks certain information which is
+	available in later generations such as fab code, lot code, wafer id,..
+  nvidia,tegra30-efuse, nvidia,tegra114-efuse and nvidia,tegra124-efuse:
+	The differences between these SoCs are the size of the efuse array,
+	the location of the spare (OEM programmable) bits and the location of
+	the speedo data.
+- reg: Should contain 1 entry: the entry gives the physical address and length
+       of the fuse registers.
+- clocks: Must contain an entry for each entry in clock-names.
+  See ../clocks/clock-bindings.txt for details.
+- clock-names: Must include the following entries:
+  - fuse
+- resets: Must contain an entry for each entry in reset-names.
+  See ../reset/reset.txt for details.
+- reset-names: Must include the following entries:
+ - fuse
+
+Example:
+
+	fuse@7000f800 {
+		compatible = "nvidia,tegra20-efuse";
+		reg = <0x7000F800 0x400>,
+		      <0x70000000 0x400>;
+		clocks = <&tegra_car TEGRA20_CLK_FUSE>;
+		clock-names = "fuse";
+		resets = <&tegra_car 39>;
+		reset-names = "fuse";
+	};
+
+
diff --git a/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt b/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
new file mode 100644
index 0000000..b97b8be
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
@@ -0,0 +1,13 @@
+NVIDIA Tegra20/Tegra30/Tegr114/Tegra124 apbmisc block
+
+Required properties:
+- compatible : should be:
+       "nvidia,tegra20-apbmisc"
+       "nvidia,tegra30-apbmisc"
+       "nvidia,tegra114-apbmisc"
+       "nvidia,tegra124-apbmisc"
+- reg: Should contain 2 entries: the first entry gives the physical address
+       and length of the registers which contain revision and debug features.
+       The second entry gives the physical address and length of the
+       registers indicating the strapping options.
+
diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index fdc559a..335a1d8 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -220,6 +220,12 @@
 		interrupt-controller;
 	};
 
+	apbmisc@70000800 {
+		compatible = "nvidia,tegra114-apbmisc", "nvidia,tegra20-apbmisc";
+		reg = <0x70000800 0x64   /* Chip revision */
+		       0x70000008 0x04>; /* Strapping options */
+	};
+
 	pinmux: pinmux@70000868 {
 		compatible = "nvidia,tegra114-pinmux";
 		reg = <0x70000868 0x148		/* Pad control registers */
@@ -485,6 +491,15 @@
 		clock-names = "pclk", "clk32k_in";
 	};
 
+	fuse@7000f800 {
+		compatible = "nvidia,tegra114-efuse";
+		reg = <0x7000f800 0x400>;
+		clocks = <&tegra_car TEGRA114_CLK_FUSE>;
+		clock-names = "fuse";
+		resets = <&tegra_car 39>;
+		reset-names = "fuse";
+	};
+
 	iommu@70019010 {
 		compatible = "nvidia,tegra114-smmu", "nvidia,tegra30-smmu";
 		reg = <0x70019010 0x02c
diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi
index 6d540a0..9739a13 100644
--- a/arch/arm/boot/dts/tegra124.dtsi
+++ b/arch/arm/boot/dts/tegra124.dtsi
@@ -167,6 +167,12 @@
 		#dma-cells = <1>;
 	};
 
+	apbmisc@0,70000800 {
+		compatible = "nvidia,tegra124-apbmisc", "nvidia,tegra20-apbmisc";
+		reg = <0x0 0x70000800 0x0 0x64>,   /* Chip revision */
+		      <0x0 0x7000E864 0x0 0x04>;   /* Strapping options */
+	};
+
 	pinmux: pinmux@0,70000868 {
 		compatible = "nvidia,tegra124-pinmux";
 		reg = <0x0 0x70000868 0x0 0x164>, /* Pad control registers */
@@ -437,6 +443,15 @@
 		clock-names = "pclk", "clk32k_in";
 	};
 
+	fuse@0,7000f800 {
+		compatible = "nvidia,tegra124-efuse";
+		reg = <0x0 0x7000f800 0x0 0x400>;
+		clocks = <&tegra_car TEGRA124_CLK_FUSE>;
+		clock-names = "fuse";
+		resets = <&tegra_car 39>;
+		reset-names = "fuse";
+	};
+
 	sdhci@0,700b0000 {
 		compatible = "nvidia,tegra124-sdhci";
 		reg = <0x0 0x700b0000 0x0 0x200>;
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index a7ddf70..243d84c 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -236,6 +236,12 @@
 		interrupt-controller;
 	};
 
+	apbmisc@70000800 {
+		compatible = "nvidia,tegra20-apbmisc";
+		reg = <0x70000800 0x64   /* Chip revision */
+		       0x70000008 0x04>; /* Strapping options */
+	};
+
 	pinmux: pinmux@70000014 {
 		compatible = "nvidia,tegra20-pinmux";
 		reg = <0x70000014 0x10   /* Tri-state registers */
@@ -545,6 +551,15 @@
 		#size-cells = <0>;
 	};
 
+	fuse@7000f800 {
+		compatible = "nvidia,tegra20-efuse";
+		reg = <0x7000F800 0x400>;
+		clocks = <&tegra_car TEGRA20_CLK_FUSE>;
+		clock-names = "fuse";
+		resets = <&tegra_car 39>;
+		reset-names = "fuse";
+	};
+
 	pcie-controller@80003000 {
 		compatible = "nvidia,tegra20-pcie";
 		device_type = "pci";
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index dec4fc8..0b1ede9 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -335,6 +335,12 @@
 		interrupt-controller;
 	};
 
+	apbmisc@70000800 {
+		compatible = "nvidia,tegra30-apbmisc", "nvidia,tegra20-apbmisc";
+		reg = <0x70000800 0x64   /* Chip revision */
+		       0x70000008 0x04>; /* Strapping options */
+	};
+
 	pinmux: pinmux@70000868 {
 		compatible = "nvidia,tegra30-pinmux";
 		reg = <0x70000868 0xd4    /* Pad control registers */
@@ -631,6 +637,15 @@
 		nvidia,ahb = <&ahb>;
 	};
 
+	fuse@7000f800 {
+		compatible = "nvidia,tegra30-efuse";
+		reg = <0x7000f800 0x400>;
+		clocks = <&tegra_car TEGRA30_CLK_FUSE>;
+		clock-names = "fuse";
+		resets = <&tegra_car 39>;
+		reset-names = "fuse";
+	};
+
 	ahub@70080000 {
 		compatible = "nvidia,tegra30-ahub";
 		reg = <0x70080000 0x200
-- 
1.7.7.rc0.72.g4b5ea.dirty

