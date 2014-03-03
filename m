Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaCCFX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 00:23:57 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64784 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaCCFXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 00:23:53 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: grant.likely@linaro.org, t.figa@samsung.com, b.zolnierkie@samsung.com,
        jg1.han@samsung.com, christoffer.dall@linaro.com, sander@humilis.net,
        swarren@wwwdotorg.org, mark.rutland@arm.com, joshi@samsung.com,
        ks.giri@samsung.com, Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [PATCH V9 2/2] ARM: dts: Enable ahci sata and sata phy
Date: Mon,  3 Mar 2014 10:52:40 +0530
Message-Id: <1393824160-27040-3-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393824160-27040-1-git-send-email-yuvaraj.cd@samsung.com>
References: <1393824160-27040-1-git-send-email-yuvaraj.cd@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dt entry for ahci sata controller and its
corresponding phy controller.phy node has been added w.r.t
new generic phy framework.

Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
---
Changes since V8:
	1.sata@122f0000 and sata_phy@12170000 disabled by default in 
	  SOC specific dts file and enabled the same in board dts file.

Changes since V7:
	1.syscon-phandle name updated.

Changes since V6:none

Changes since V5:none

Changes since V4:
	1.Used the new phandle "sata_phy_i2c" in the DT entry. 
	2.Updated binding document.

Changes since V3:
	1.Moved the binding info to the /bindings/phy/

Changes since V2:
	1.Used syscon interface to PMU handling.
	2.Changed "sata-phy-i2c" to "exynos-sataphy-i2c".

Changes since V1:
	1.Minor changes to node name convention.
	2.Updated binding document.


 .../devicetree/bindings/ata/exynos-sata-phy.txt    |   14 --------
 .../devicetree/bindings/ata/exynos-sata.txt        |   25 +++++++++-----
 .../devicetree/bindings/phy/samsung-phy.txt        |   36 ++++++++++++++++++++
 arch/arm/boot/dts/exynos5250-arndale.dts           |   21 ++++++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   17 +++++----
 arch/arm/boot/dts/exynos5250.dtsi                  |   18 +++++++---
 6 files changed, 98 insertions(+), 33 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/ata/exynos-sata-phy.txt

diff --git a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt b/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
deleted file mode 100644
index 37824fa..0000000
--- a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
+++ /dev/null
@@ -1,14 +0,0 @@
-* Samsung SATA PHY Controller
-
-SATA PHY nodes are defined to describe on-chip SATA Physical layer controllers.
-Each SATA PHY controller should have its own node.
-
-Required properties:
-- compatible        : compatible list, contains "samsung,exynos5-sata-phy"
-- reg               : <registers mapping>
-
-Example:
-        sata@ffe07000 {
-                compatible = "samsung,exynos5-sata-phy";
-                reg = <0xffe07000 0x1000>;
-        };
diff --git a/Documentation/devicetree/bindings/ata/exynos-sata.txt b/Documentation/devicetree/bindings/ata/exynos-sata.txt
index 0849f10..b2adb1f 100644
--- a/Documentation/devicetree/bindings/ata/exynos-sata.txt
+++ b/Documentation/devicetree/bindings/ata/exynos-sata.txt
@@ -4,14 +4,21 @@ SATA nodes are defined to describe on-chip Serial ATA controllers.
 Each SATA controller should have its own node.
 
 Required properties:
-- compatible        : compatible list, contains "samsung,exynos5-sata"
-- interrupts        : <interrupt mapping for SATA IRQ>
-- reg               : <registers mapping>
-- samsung,sata-freq : <frequency in MHz>
+- compatible		: compatible list, contains "samsung,exynos5-sata"
+- interrupts		: <interrupt mapping for SATA IRQ>
+- reg			: <registers mapping>
+- samsung,sata-freq	: <frequency in MHz>
+- phys			: as mentioned in phy-bindings.txt
+- phy-names		: as mentioned in phy-bindings.txt
 
 Example:
-        sata@ffe08000 {
-                compatible = "samsung,exynos5-sata";
-                reg = <0xffe08000 0x1000>;
-                interrupts = <115>;
-        };
+	sata@122f0000 {
+		compatible = "snps,dwc-ahci";
+		samsung,sata-freq = <66>;
+		reg = <0x122f0000 0x1ff>;
+		interrupts = <0 115 0>;
+		clocks = <&clock 277>, <&clock 143>;
+		clock-names = "sata", "sclk_sata";
+		phys = <&sata_phy>;
+		phy-names = "sata-phy";
+	};
diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index c0fccaa..a937f75 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -20,3 +20,39 @@ Required properties:
 - compatible : should be "samsung,exynos5250-dp-video-phy";
 - reg : offset and length of the Display Port PHY register set;
 - #phy-cells : from the generic PHY bindings, must be 0;
+
+Samsung SATA PHY Controller
+---------------------------
+
+SATA PHY nodes are defined to describe on-chip SATA Physical layer controllers.
+Each SATA PHY controller should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains "samsung,exynos5250-sata-phy"
+- reg : offset and length of the SATA PHY register set;
+- #phy-cells : from the generic phy bindings;
+
+Example:
+	sata_phy: sata-phy@12170000 {
+		compatible = "samsung,exynos5250-sata-phy";
+		reg = <0x12170000 0x1ff>;
+		clocks = <&clock 287>;
+		clock-names = "sata_phyctrl";
+		#phy-cells = <0>;
+		samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
+		samsung,syscon-phandle = <&pmu_syscon>;
+	};
+
+Device-Tree bindings for sataphy i2c client driver
+--------------------------------------------------
+
+Required properties:
+compatible: Should be "samsung,exynos-sataphy-i2c"
+- reg: I2C address of the sataphy i2c device.
+
+Example:
+
+	sata_phy_i2c:sata-phy@38 {
+		compatible = "samsung,exynos-sataphy-i2c";
+		reg = <0x38>;
+	};
diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index 38b96a4..97eef40 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -375,6 +375,27 @@
 		};
 	};
 
+	i2c@121D0000 {
+		status = "okay";
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-max-bus-freq = <40000>;
+		samsung,i2c-slave-addr = <0x38>;
+
+		sata_phy_i2c:sata-phy@38 {
+			compatible = "samsung,exynos-sataphy-i2c";
+			reg = <0x38>;
+		};
+	};
+
+	sata@122F0000 {
+		status = "okay";
+	};
+
+	sata-phy@12170000 {
+		status = "okay";
+		samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
+	};
+
 	mmc_0: mmc@12200000 {
 		status = "okay";
 		num-slots = <1>;
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 0837dd8..e0da05b 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -100,16 +100,12 @@
 		samsung,i2c-slave-addr = <0x38>;
 		status = "okay";
 
-		sata-phy {
-			compatible = "samsung,sata-phy";
+		sata_phy_i2c:sata-phy@38 {
+			compatible = "samsung,exynos-sataphy-i2c";
 			reg = <0x38>;
 		};
 	};
 
-	sata@122F0000 {
-		samsung,sata-freq = <66>;
-	};
-
 	i2c@12C80000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-max-bus-freq = <66000>;
@@ -132,6 +128,15 @@
 		};
 	};
 
+	sata@122F0000 {
+		status = "okay";
+	};
+
+	sata-phy@12170000 {
+		status = "okay";
+		samsung,exynos-sataphy-i2c-phandle = <&sata_phy_i2c>;
+	};
+
 	mmc@12200000 {
 		status = "okay";
 		num-slots = <1>;
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 8f6300f..31f7cab 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -46,6 +46,7 @@
 		i2c6 = &i2c_6;
 		i2c7 = &i2c_7;
 		i2c8 = &i2c_8;
+		i2c9 = &i2c_9;
 		pinctrl0 = &pinctrl_0;
 		pinctrl1 = &pinctrl_1;
 		pinctrl2 = &pinctrl_2;
@@ -233,16 +234,25 @@
 	};
 
 	sata@122F0000 {
-		compatible = "samsung,exynos5-sata-ahci";
+		compatible = "snps,dwc-ahci";
+		samsung,sata-freq = <66>;
 		reg = <0x122F0000 0x1ff>;
 		interrupts = <0 115 0>;
 		clocks = <&clock 277>, <&clock 143>;
 		clock-names = "sata", "sclk_sata";
+		phys = <&sata_phy>;
+		phy-names = "sata-phy";
+		status = "disabled";
 	};
 
-	sata-phy@12170000 {
-		compatible = "samsung,exynos5-sata-phy";
+	sata_phy: sata-phy@12170000 {
+		compatible = "samsung,exynos5250-sata-phy";
 		reg = <0x12170000 0x1ff>;
+		clocks = <&clock 287>;
+		clock-names = "sata_phyctrl";
+		#phy-cells = <0>;
+		samsung,syscon-phandle = <&pmu_system_controller>;
+		status = "disabled";
 	};
 
 	i2c_0: i2c@12C60000 {
@@ -360,7 +370,7 @@
 		status = "disabled";
 	};
 
-	i2c@121D0000 {
+	i2c_9: i2c@121D0000 {
                 compatible = "samsung,exynos5-sata-phy-i2c";
                 reg = <0x121D0000 0x100>;
                 #address-cells = <1>;
-- 
1.7.10.4

