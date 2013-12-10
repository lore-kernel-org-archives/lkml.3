Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab3LJKGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:06:01 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:61965 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3LJKFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:05:34 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: grant.likely@linaro.org, rob.herring@calxeda.com, swarren@wwwdotorg.org,
        mark.rutland@arm.com, sachin.kamat@linaro.org,
        b.zolnierkie@samsung.com, jg1.han@samsung.com, t.figa@samsung.com,
        christoffer.dall@linaro.org, joshi@samsung.com,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [PATCH V3 2/2] ARM: dts: Enable ahci sata and sata phy
Date: Tue, 10 Dec 2013 15:35:10 +0530
Message-Id: <1386669911-17319-3-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386669911-17319-1-git-send-email-yuvaraj.cd@samsung.com>
References: <1386669911-17319-1-git-send-email-yuvaraj.cd@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dt entry for ahci sata controller and its
corresponding phy controller.phy node has been added w.r.t
new generic phy framework.

Changes since V2:
	1.Used syscon interface to PMU handling.
	2.Changed "sata-phy-i2c" to "exynos-sataphy-i2c".

Changes since V1:
	1.Minor changes to node name convention.
	2.Updated binding document.

Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
---
 .../devicetree/bindings/ata/exynos-sata-phy.txt    |   19 ++++++++++++++-----
 .../devicetree/bindings/ata/exynos-sata.txt        |   17 ++++++++++++-----
 .../devicetree/bindings/ata/exynos_sataphy_i2c.txt |   12 ++++++++++++
 arch/arm/boot/dts/exynos5250-arndale.dts           |    9 ++++++++-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |    8 ++------
 arch/arm/boot/dts/exynos5250.dtsi                  |   16 ++++++++++++----
 6 files changed, 60 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/exynos_sataphy_i2c.txt

diff --git a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt b/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
index 37824fa..a679e17 100644
--- a/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
+++ b/Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
@@ -4,11 +4,20 @@ SATA PHY nodes are defined to describe on-chip SATA Physical layer controllers.
 Each SATA PHY controller should have its own node.
 
 Required properties:
-- compatible        : compatible list, contains "samsung,exynos5-sata-phy"
+- compatible        : compatible list, contains "samsung,exynos5250-sata-phy"
 - reg               : <registers mapping>
 
 Example:
-        sata@ffe07000 {
-                compatible = "samsung,exynos5-sata-phy";
-                reg = <0xffe07000 0x1000>;
-        };
+	sata_phy: sata-phy@12170000 {
+		compatible = "samsung,exynos5250-sata-phy";
+		reg = <0x12170000 0x1ff>;
+		clocks = <&clock 287>;
+		clock-names = "sata_phyctrl";
+		#phy-cells = <0>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		sataphy-pmu {
+			reg = <0x10040724 0x4>;
+			};
+	};
diff --git a/Documentation/devicetree/bindings/ata/exynos-sata.txt b/Documentation/devicetree/bindings/ata/exynos-sata.txt
index 0849f10..918bff8 100644
--- a/Documentation/devicetree/bindings/ata/exynos-sata.txt
+++ b/Documentation/devicetree/bindings/ata/exynos-sata.txt
@@ -8,10 +8,17 @@ Required properties:
 - interrupts        : <interrupt mapping for SATA IRQ>
 - reg               : <registers mapping>
 - samsung,sata-freq : <frequency in MHz>
+- phys              : as mentioned in phy-bindings.txt
+- phy-names         : as mentioned in phy-bindings.txt
 
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
diff --git a/Documentation/devicetree/bindings/ata/exynos_sataphy_i2c.txt b/Documentation/devicetree/bindings/ata/exynos_sataphy_i2c.txt
new file mode 100644
index 0000000..deabba9
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/exynos_sataphy_i2c.txt
@@ -0,0 +1,12 @@
+Device-Tree bindings for sataphy i2c client driver
+
+Required properties:
+compatible: Should be "samsung,exynos-sataphy-i2c"
+- reg: I2C address of the sataphy i2c device.
+
+Example:
+
+	sata-phy@38 {
+		compatible = "samsung,exynos-sataphy-i2c";
+		reg = <0x38>;
+	};
diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index b77a37e..dca74bb 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -381,7 +381,14 @@
 	};
 
 	i2c@121D0000 {
-		status = "disabled";
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-max-bus-freq = <40000>;
+		samsung,i2c-slave-addr = <0x38>;
+
+		sata-phy@38 {
+			compatible = "samsung,exynos-sataphy-i2c";
+			reg = <0x38>;
+		};
 	};
 
 	mmc_0: mmc@12200000 {
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 13746df..b3c359a4 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -90,16 +90,12 @@
 		samsung,i2c-max-bus-freq = <40000>;
 		samsung,i2c-slave-addr = <0x38>;
 
-		sata-phy {
-			compatible = "samsung,sata-phy";
+		sata-phy@38 {
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
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 5d5d3d0..5d4c8fa 100644
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
@@ -229,16 +230,23 @@
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
 	};
 
-	sata-phy@12170000 {
-		compatible = "samsung,exynos5-sata-phy";
+	sata_phy: sata-phy@12170000 {
+		compatible = "samsung,exynos5250-sata-phy";
 		reg = <0x12170000 0x1ff>;
+		clocks = <&clock 287>;
+		clock-names = "sata_phyctrl";
+		#phy-cells = <0>;
+		samsung,syscon-phandle = <&pmu_syscon>;
 	};
 
 	i2c_0: i2c@12C60000 {
@@ -347,7 +355,7 @@
 		clock-names = "i2c";
 	};
 
-	i2c@121D0000 {
+	i2c_9: i2c@121D0000 {
                 compatible = "samsung,exynos5-sata-phy-i2c";
                 reg = <0x121D0000 0x100>;
                 #address-cells = <1>;
-- 
1.7.9.5

