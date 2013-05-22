Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3EVST3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:19:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55109 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab3EVST0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:19:26 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH 4/4] HACK: OMAP4460/TPS/TWL/PandaBoardES - Enable VP regulator for cpufreq
Date: Wed, 22 May 2013 13:18:37 -0500
Message-ID: <1369246717-4167-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369246717-4167-1-git-send-email-nm@ti.com>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just an example patch - Tested on PandaBoard-ES OMAP4460
Connectivity is as follows:
VP_MPU -> VC_CH_MPU -> VC -> TPS62361
TPS62631 Voltage register selection is done using GPIO (GPIO_WK 7)
VP_IVA -> VC_CH_IVA -> VC -> TWL6030/vcore2
VP_CORE -> VC_CH_CORE -> VC -> TWL6030/vcore1

NOT-Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/omap4-panda-es.dts |   55 +++++++++++++++++++--
 arch/arm/boot/dts/omap4.dtsi         |   84 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap4460.dtsi      |    1 +
 arch/arm/boot/dts/tps62361.dtsi      |   90 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/twl6030.dtsi       |   68 +++++++++++++++++++++++++
 5 files changed, 294 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/boot/dts/tps62361.dtsi

diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index 08d2e38..71aa5f3 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -43,10 +43,18 @@
 	};
 };
 
-&led_wkgpio_pins {
-	pinctrl-single,pins = <
-		0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
-	>;
+&omap4_pmx_wkup {
+	led_wkgpio_pins: pinmux_leds_wkpins {
+		pinctrl-single,pins = <
+			0x1c 0x3	/* gpio_wk8 OUTPUT | MODE 3 */
+		>;
+	};
+
+	tps62361_wkgpio_pins: pinmux_tps62361_wkpins {
+		pinctrl-single,pins = <
+			0x1a 0xa03	/* gpio_wk7 OUTPUT | MODE 3 |OFF_HI */
+		>;
+	};
 };
 
 &leds {
@@ -68,3 +76,42 @@
 		linux,default-trigger = "mmc0";
 	};
 };
+
+#define TPS62361_PD_VSEL0
+#include "tps62361.dtsi"
+
+/* Board Specific configuration */
+&omap_tps62361 {
+	pinctrl-names = "default";
+	pinctrl-0 = <
+		&tps62361_wkgpio_pins
+	>;
+	gpios = <&gpio1 7 1>;	/* gpio_wk7 Set to HIGH */
+
+	ti,boot-voltage-micro-volts=<1203000>;
+	ti,vp=<&vp_mpu>;
+};
+
+&omap_twl6030_vcore1 {
+	ti,boot-voltage-micro-volts=<1200000>;
+	ti,vp=<&vp_core>;
+};
+
+&omap_twl6030_vcore2 {
+	ti,boot-voltage-micro-volts=<1200000>;
+	ti,vp = <&vp_iva>;
+};
+
+&omap_twl6030_vcore3 {
+	status = "disabled";
+};
+
+&vc_mpu {
+	/* Due to potential lifetime impact, OFF voltage is set to RET V: TPS*/
+	ti,off-micro-volts = <750000>;
+};
+
+&vc {
+	ti,i2c-high-speed;
+	ti,i2c-pad-load=<3>;
+};
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 1c6d969..b9fd360 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -108,6 +108,11 @@
 			ti,hwmods = "counter_32k";
 		};
 
+		sysclk_in: sys_clkin {
+			#clock-cells = <0>;
+			compatible = "ti,omap-clock";
+		};
+
 		dpll_mpu: dpll_mpu {
 			#clock-cells = <0>;
 			compatible = "ti,omap-clock";
@@ -667,5 +672,84 @@
 			ram-bits = <12>;
 			ti,has-mailbox;
 		};
+
+	vc: vc@0x4A307B88 {
+			compatible = "ti,omap4-vc";
+			clocks = <&sysclk_in>;
+			reg = <0x4A307B88 0x40>;
+			reg-names = "base-address";
+
+			ti,i2c-high-speed; /* belongs to board file */
+			vc_mpu: vc_mpu {
+				compatible = "ti,omap4-vc-channel-mpu";
+				ti,master-channel;
+				ti,retention-micro-volts = <750000>;
+				ti,off-micro-volts = <0>;
+			};
+
+			vc_iva: vc_iva {
+				compatible = "ti,omap4-vc-channel-iva";
+				ti,retention-micro-volts = <750000>;
+				ti,off-micro-volts = <0>;
+			};
+
+			vc_core: vc_core {
+				compatible = "ti,omap4-vc-channel-core";
+				ti,retention-micro-volts = <750000>;
+				ti,off-micro-volts = <0>;
+			};
+		};
+
+		vp_mpu: vp@0x4a307b58 {
+			compatible = "ti,omap4-vp";
+
+			reg = <0x4a307b58 0x18>, <0x4A306014 0x4>;
+			reg-names = "base-address", "int-address";
+			ti,tranxdone-status-mask=<0x20>;
+
+			clocks = <&sysclk_in>;
+
+			ti,vc-channel = <&vc_mpu>;
+			ti,min-step-micro-volts = <10000>;
+			ti,max-step-micro-volts = <50000>;
+			/* HACKs: belongs to SoC specific file */
+			ti,min-micro-volts = <750000>;
+			ti,max-micro-volts = <1410000>;
+		};
+
+		vp_iva: vp@0x4a307b70 {
+			compatible = "ti,omap4-vp";
+
+			reg = <0x4a307b70 0x18>, <0x4A306010 0x4>;
+			reg-names = "base-address", "int-address";
+			ti,tranxdone-status-mask=<0x20000000>;
+
+			clocks = <&sysclk_in>;
+
+			ti,vc-channel = <&vc_iva>;
+			/* HACKs: belongs to SoC specific file */
+			ti,min-step-micro-volts = <10000>;
+			ti,max-step-micro-volts = <50000>;
+			ti,min-micro-volts = <750000>;
+			ti,max-micro-volts = <1260000>;
+		};
+
+		vp_core: vp@0x4a307b40 {
+			compatible = "ti,omap4-vp";
+
+			reg = <0x4a307b40 0x18>, <0x4A306010 0x4>;
+			reg-names = "base-address", "int-address";
+			ti,tranxdone-status-mask=<0x200000>;
+
+			clocks = <&sysclk_in>;
+
+			regulator_name = "vdd_core";
+			ti,vc-channel = <&vc_core>;
+			/* HACKs: belongs to SoC specific file */
+			ti,min-step-micro-volts = <10000>;
+			ti,max-step-micro-volts = <50000>;
+			ti,min-micro-volts = <830000>;
+			ti,max-micro-volts = <1200000>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
index 2cf227c..6937d92 100644
--- a/arch/arm/boot/dts/omap4460.dtsi
+++ b/arch/arm/boot/dts/omap4460.dtsi
@@ -20,6 +20,7 @@
 				920000  1313000
 			>;
 			clock-latency = <300000>; /* From legacy driver */
+			cpu0-supply = <&omap_tps62361>; /* HACK: belongs to board file */
 		};
 	};
 
diff --git a/arch/arm/boot/dts/tps62361.dtsi b/arch/arm/boot/dts/tps62361.dtsi
new file mode 100644
index 0000000..b82a50f
--- /dev/null
+++ b/arch/arm/boot/dts/tps62361.dtsi
@@ -0,0 +1,90 @@
+
+/* Add blah blah */
+
+/* Register set definitions */
+#define REG_TPS6236X_SET_0		0x00
+#define REG_TPS6236X_SET_1		0x01
+#define REG_TPS6236X_SET_2		0x02
+#define REG_TPS6236X_SET_3		0x03
+#define REG_TPS6236X_CTRL		0x04
+#define REG_TPS6236X_TEMP		0x05
+#define REG_TPS6236X_RAMP_CTRL		0x06
+#define REG_TPS6236X_CHIP_ID0		0x08
+#define REG_TPS6236X_CHIP_ID1		0x09
+
+/* Register field definitions for REG_TPS6236X_CTRL */
+#define REG_TPS6236X_CTRL_PD_EN		(1 << 7)
+#define REG_TPS6236X_CTRL_PD_VSEL0	(1 << 6)
+#define REG_TPS6236X_CTRL_PD_VSEL1	(1 << 5)
+
+/* Register field definitions for REG_TPS6236X_RAMP_CTRL */
+#define REG_TPS6236X_RAMP_CTRL_RMP_SHIFT 5
+#define REG_TPS6236X_RAMP_CTRL_EN_DISC	(1 << 2)
+#define REG_TPS6236X_RAMP_CTRL_RAMP_PFM	(1 << 1)
+
+/* Value definitions for REG_TPS6236X_RAMP_CTRL::RMP field */
+#define RMP_32MV_USEC			0x0
+#define RMP_16MV_USEC			0x1
+#define RMP_8MV_USEC			0x2
+#define RMP_4MV_USEC			0x3
+#define RMP_2MV_USEC			0x4
+#define RMP_1MV_USEC			0x5
+
+/* Selected values */
+#define RMP_VALUE			(RMP_32MV_USEC << REG_TPS6236X_RAMP_CTRL_RMP_SHIFT | REG_TPS6236X_RAMP_CTRL_EN_DISC | REG_TPS6236X_RAMP_CTRL_RAMP_PFM)
+
+#ifdef TPS62361_PD_VSEL0
+#define _CTRL_VALUE0			(REG_TPS6236X_CTRL_PD_EN | REG_TPS6236X_CTRL_PD_VSEL0)
+#else
+#define _CTRL_VALUE0			0x0
+#endif
+#ifdef TPS62361_PD_VSEL1
+#define _CTRL_VALUE1			(REG_TPS6236X_CTRL_PD_EN | REG_TPS6236X_CTRL_PD_VSEL0)
+#else
+#define _CTRL_VALUE1			0x0
+#endif
+
+#if defined(TPS62361_PD_VSEL0) || defined(TPS62361_PD_VSEL1)
+#define _CTRL_VALUE			(_CTRL_VALUE0 | _CTRL_VALUE0)
+#endif
+
+/ {
+	omap_tps62361: tps62361 {
+		compatible = "ti,omap-pmic";
+		ti,non-zero-voltage-selector;
+
+		/* Slave address */
+		ti,i2c-slave-address = <0x60>;
+		/* I2C register address */
+		ti,i2c-voltage-register = <0x01>; /* Set 1 */
+		ti,i2c-command-register = <0x01>; /* Set 1 */
+
+		/* Slew rate in uV */
+		ti,slew-rate-microvolt = <32000>;
+		/* Step size in uV */
+		ti,step-size-microvolt = <10000>;
+		regulator-min-microvolt= <500000>;
+		regulator-max-microvolt= <1770000>;
+
+		/* Optional - any voltage selector offset to care about */
+		ti,voltage-selector-offset = <0x0>;
+		/* Optional - what mask to apply on vsel value before doing operations on it */
+		ti,voltage-selector-mask =<0x7F>;
+		/* Optional - what bits to always set on voltage selector when sending to PMIC */
+		ti,voltage-selector-set-bits =<0x80>; /* PFM mode */
+
+		/* Optional - Any access to be done over I2C SR to setup registers */
+		ti,setup_commands=<
+			/* register_addr value */
+			/* Setup Slew (ramp) rate */
+			REG_TPS6236X_RAMP_CTRL RMP_VALUE
+			/* Setup PMIC internal pull if needed */
+#ifdef _CTRL_VALUE
+			REG_TPS6236X_CTRL  _CTRL_VALUE
+#endif
+			/* Enable thermal shutdown - 0 is enable :) */
+			REG_TPS6236X_TEMP	0x0
+			/* Setup the internal pulls */
+		>;
+	};
+};
diff --git a/arch/arm/boot/dts/twl6030.dtsi b/arch/arm/boot/dts/twl6030.dtsi
index 2e3bd31..5e1f4ed 100644
--- a/arch/arm/boot/dts/twl6030.dtsi
+++ b/arch/arm/boot/dts/twl6030.dtsi
@@ -103,4 +103,72 @@
 		compatible = "ti,twl6030-pwmled";
 		#pwm-cells = <2>;
 	};
+
+	omap_twl6030_vcore1: vcore1 {
+		compatible = "ti,omap-pmic";
+
+		/* Slave address */
+		ti,i2c-slave-address = <0x12>;
+		/* I2C register address */
+		ti,i2c-voltage-register = <0x55>;
+		ti,i2c-command-register = <0x56>;
+
+		/* Slew rate in uV */
+		ti,slew-rate-microvolt = <9000>;
+		/* Step size in uV */
+		ti,step-size-microvolt = <12660>;
+		regulator-min-microvolt= <709000>;
+		regulator-max-microvolt= <1418000>;
+
+		/* Optional - any voltage selector offset to care about */
+		ti,voltage-selector-offset = <0x1>;
+		/* Optional - what mask to apply on vsel value before doing operations on it */
+		ti,voltage-selector-mask =<0x7F>;
+	};
+
+	omap_twl6030_vcore2: vcore2 {
+		compatible = "ti,omap-pmic";
+
+		/* Slave address */
+		ti,i2c-slave-address = <0x12>;
+		/* I2C register address */
+		ti,i2c-voltage-register = <0x5b>;
+		ti,i2c-command-register = <0x5c>;
+
+		/* Slew rate in uV */
+		ti,slew-rate-microvolt = <9000>;
+		/* Step size in uV */
+		ti,step-size-microvolt = <12660>;
+		/* Min voltage in uV for continous operational range at step size */
+		regulator-min-microvolt= <709000>;
+		regulator-max-microvolt= <1418000>;
+
+		/* Optional - any voltage selector offset to care about */
+		ti,voltage-selector-offset = <0x1>;
+		/* Optional - what mask to apply on vsel value before doing operations on it */
+		ti,voltage-selector-mask =<0x7F>;
+	};
+
+	omap_twl6030_vcore3: vcore3 {
+		compatible = "ti,omap-pmic";
+
+		/* Slave address */
+		ti,i2c-slave-address = <0x12>;
+		/* I2C register address */
+		ti,i2c-voltage-register = <0x61>;
+		ti,i2c-command-register = <0x62>;
+
+
+		/* Slew rate in uV */
+		ti,slew-rate-microvolt = <9000>;
+		/* Step size in uV */
+		ti,step-size-microvolt = <12660>;
+		regulator-min-microvolt= <709000>;
+		regulator-max-microvolt= <1418000>;
+
+		/* Optional - any voltage selector offset to care about */
+		ti,voltage-selector-offset = <0x1>;
+		/* Optional - what mask to apply on vsel value before doing operations on it */
+		ti,voltage-selector-mask =<0x7F>;
+	};
 };
-- 
1.7.9.5

