Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaETNSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:18:38 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:50436 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051AbaETNS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:18:29 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Olof Johansson <olof@lixom.net>, Rob Landley <rob@landley.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v7 3/4] ARM: dts: Add STiH407 SoC support
Date: Tue, 20 May 2014 15:17:31 +0200
Message-Id: <1400591852-17577-4-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400591852-17577-1-git-send-email-maxime.coquelin@st.com>
References: <1400591852-17577-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-20_02:2014-05-20,2014-05-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STiH407 is advanced multi-HD AVC processor with 3D graphics acceleration
and 1.5-GHz ARM Cortex-A9 SMP CPU.

Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 arch/arm/boot/dts/stih407-clock.dtsi   |  39 +++
 arch/arm/boot/dts/stih407-pinctrl.dtsi | 615 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stih407.dtsi         | 263 ++++++++++++++
 3 files changed, 917 insertions(+)
 create mode 100644 arch/arm/boot/dts/stih407-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih407-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih407.dtsi

diff --git a/arch/arm/boot/dts/stih407-clock.dtsi b/arch/arm/boot/dts/stih407-clock.dtsi
new file mode 100644
index 0000000..800f46f
--- /dev/null
+++ b/arch/arm/boot/dts/stih407-clock.dtsi
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics R&D Limited
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/ {
+	clocks {
+		/*
+		 * Fixed 30MHz oscillator inputs to SoC
+		 */
+		clk_sysin: clk-sysin {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <30000000>;
+		};
+
+		/*
+		 * ARM Peripheral clock for timers
+		 */
+		arm_periph_clk: arm-periph-clk {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <600000000>;
+		};
+
+		/*
+		 * Bootloader initialized system infrastructure clock for
+		 * serial devices.
+		 */
+		clk_ext2f_a9: clockgen-c0@13 {
+			#clock-cells = <0>;
+			compatible = "fixed-clock";
+			clock-frequency = <200000000>;
+			clock-output-names = "clk-s-icn-reg-0";
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih407-pinctrl.dtsi b/arch/arm/boot/dts/stih407-pinctrl.dtsi
new file mode 100644
index 0000000..402844c
--- /dev/null
+++ b/arch/arm/boot/dts/stih407-pinctrl.dtsi
@@ -0,0 +1,615 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics Limited.
+ * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "st-pincfg.h"
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+/ {
+
+	aliases {
+		/* 0-5: PIO_SBC */
+		gpio0 = &pio0;
+		gpio1 = &pio1;
+		gpio2 = &pio2;
+		gpio3 = &pio3;
+		gpio4 = &pio4;
+		gpio5 = &pio5;
+		/* 10-19: PIO_FRONT0 */
+		gpio6 = &pio10;
+		gpio7 = &pio11;
+		gpio8 = &pio12;
+		gpio9 = &pio13;
+		gpio10 = &pio14;
+		gpio11 = &pio15;
+		gpio12 = &pio16;
+		gpio13 = &pio17;
+		gpio14 = &pio18;
+		gpio15 = &pio19;
+		/* 20: PIO_FRONT1 */
+		gpio16 = &pio20;
+		/* 30-35: PIO_REAR */
+		gpio17 = &pio30;
+		gpio18 = &pio31;
+		gpio19 = &pio32;
+		gpio20 = &pio33;
+		gpio21 = &pio34;
+		gpio22 = &pio35;
+		/* 40-42: PIO_FLASH */
+		gpio23 = &pio40;
+		gpio24 = &pio41;
+		gpio25 = &pio42;
+	};
+
+	soc {
+		pin-controller-sbc {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "st,stih407-sbc-pinctrl";
+			st,syscfg = <&syscfg_sbc>;
+			reg = <0x0961f080 0x4>;
+			reg-names = "irqmux";
+			interrupts = <GIC_SPI 188 IRQ_TYPE_NONE>;
+			interrupts-names = "irqmux";
+			ranges = <0 0x09610000 0x6000>;
+
+			pio0: gpio@09610000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x0 0x100>;
+				st,bank-name = "PIO0";
+			};
+			pio1: gpio@09611000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x1000 0x100>;
+				st,bank-name = "PIO1";
+			};
+			pio2: gpio@09612000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x2000 0x100>;
+				st,bank-name = "PIO2";
+			};
+			pio3: gpio@09613000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x3000 0x100>;
+				st,bank-name = "PIO3";
+			};
+			pio4: gpio@09614000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x4000 0x100>;
+				st,bank-name = "PIO4";
+			};
+
+			pio5: gpio@09615000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x5000 0x100>;
+				st,bank-name = "PIO5";
+			};
+
+			rc {
+				pinctrl_ir: ir0 {
+					st,pins {
+						ir = <&pio4 0 ALT2 IN>;
+					};
+				};
+			};
+
+			/* SBC_ASC0 - UART10 */
+			sbc_serial0 {
+				pinctrl_sbc_serial0: sbc_serial0-0 {
+					st,pins {
+						tx = <&pio3 4 ALT1 OUT>;
+						rx = <&pio3 5 ALT1 IN>;
+					};
+				};
+			};
+			/* SBC_ASC1 - UART11 */
+			sbc_serial1 {
+				pinctrl_sbc_serial1: sbc_serial1-0 {
+					st,pins {
+						tx = <&pio2 6 ALT3 OUT>;
+						rx = <&pio2 7 ALT3 IN>;
+					};
+				};
+			};
+
+			i2c10 {
+				pinctrl_i2c10_default: i2c10-default {
+					st,pins {
+						sda = <&pio4 6 ALT1 BIDIR>;
+						scl = <&pio4 5 ALT1 BIDIR>;
+					};
+				};
+			};
+
+			i2c11 {
+				pinctrl_i2c11_default: i2c11-default {
+					st,pins {
+						sda = <&pio5 1 ALT1 BIDIR>;
+						scl = <&pio5 0 ALT1 BIDIR>;
+					};
+				};
+			};
+
+			keyscan {
+				pinctrl_keyscan: keyscan {
+					st,pins {
+						keyin0 = <&pio4 0 ALT6 IN>;
+						keyin1 = <&pio4 5 ALT4 IN>;
+						keyin2 = <&pio0 4 ALT2 IN>;
+						keyin3 = <&pio2 6 ALT2 IN>;
+
+						keyout0 = <&pio4 6 ALT4 OUT>;
+						keyout1 = <&pio1 7 ALT2 OUT>;
+						keyout2 = <&pio0 6 ALT2 OUT>;
+						keyout3 = <&pio2 7 ALT2 OUT>;
+					};
+				};
+			};
+
+			gmac1 {
+				/*
+				 * Almost all the boards based on STiH407 SoC have an embedded
+				 * switch where the mdio/mdc have been used for managing the SMI
+				 * iface via I2C. For this reason these lines can be allocated
+				 * by using dedicated configuration (in case of there will be a
+				 * standard PHY transceiver on-board).
+				 */
+				pinctrl_rgmii1: rgmii1-0 {
+					st,pins {
+
+						txd0 = <&pio0 0 ALT1 OUT DE_IO 0 CLK_A>;
+						txd1 = <&pio0 1 ALT1 OUT DE_IO 0 CLK_A>;
+						txd2 = <&pio0 2 ALT1 OUT DE_IO 0 CLK_A>;
+						txd3 = <&pio0 3 ALT1 OUT DE_IO 0 CLK_A>;
+						txen = <&pio0 5 ALT1 OUT DE_IO 0 CLK_A>;
+						txclk = <&pio0 6 ALT1 IN NICLK 0 CLK_A>;
+						rxd0 = <&pio1 4 ALT1 IN DE_IO 0 CLK_A>;
+						rxd1 = <&pio1 5 ALT1 IN DE_IO 0 CLK_A>;
+						rxd2 = <&pio1 6 ALT1 IN DE_IO 0 CLK_A>;
+						rxd3 = <&pio1 7 ALT1 IN DE_IO 0 CLK_A>;
+						rxdv = <&pio2 0 ALT1 IN DE_IO 0 CLK_A>;
+						rxclk = <&pio2 2 ALT1 IN NICLK 500 CLK_A>;
+						clk125 = <&pio3 7 ALT4 IN NICLK 0 CLK_A>;
+						phyclk = <&pio2 3 ALT4 OUT NICLK 1750 CLK_B>;
+					};
+				};
+
+				pinctrl_rgmii1_mdio: rgmii1-mdio {
+					st,pins {
+						mdio = <&pio1 0 ALT1 OUT BYPASS 0>;
+						mdc = <&pio1 1 ALT1 OUT NICLK 0 CLK_A>;
+						mdint = <&pio1 3 ALT1 IN BYPASS 0>;
+					};
+				};
+
+				pinctrl_mii1: mii1 {
+					st,pins {
+						txd0 = <&pio0 0 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txd1 = <&pio0 1 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txd2 = <&pio0 2 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txd3 = <&pio0 3 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txer = <&pio0 4 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txen = <&pio0 5 ALT1 OUT SE_NICLK_IO 0 CLK_A>;
+						txclk = <&pio0 6 ALT1 IN NICLK 0 CLK_A>;
+						col = <&pio0 7 ALT1 IN BYPASS 1000>;
+
+						mdio = <&pio1 0 ALT1 OUT BYPASS 1500>;
+						mdc = <&pio1 1 ALT1 OUT NICLK 0 CLK_A>;
+						crs = <&pio1 2 ALT1 IN BYPASS 1000>;
+						mdint = <&pio1 3 ALT1 IN BYPASS 0>;
+						rxd0 = <&pio1 4 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxd1 = <&pio1 5 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxd2 = <&pio1 6 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxd3 = <&pio1 7 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+
+						rxdv = <&pio2 0 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rx_er = <&pio2 1 ALT1 IN SE_NICLK_IO 0 CLK_A>;
+						rxclk = <&pio2 2 ALT1 IN NICLK 0 CLK_A>;
+						phyclk = <&pio2 3 ALT1 OUT NICLK 0 CLK_A>;
+					};
+				};
+			};
+
+			pwm1 {
+				pinctrl_pwm1_chan0_default: pwm1-0-default {
+					st,pins {
+						pwm-out = <&pio3 0 ALT1 OUT>;
+					};
+				};
+				pinctrl_pwm1_chan1_default: pwm1-1-default {
+					st,pins {
+						pwm-out = <&pio4 4 ALT1 OUT>;
+					};
+				};
+				pinctrl_pwm1_chan2_default: pwm1-2-default {
+					st,pins {
+						pwm-out = <&pio4 6 ALT3 OUT>;
+					};
+				};
+				pinctrl_pwm1_chan3_default: pwm1-3-default {
+					st,pins {
+						pwm-out = <&pio4 7 ALT3 OUT>;
+					};
+				};
+			};
+		};
+
+		pin-controller-front0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "st,stih407-front-pinctrl";
+			st,syscfg = <&syscfg_front>;
+			reg = <0x0920f080 0x4>;
+			reg-names = "irqmux";
+			interrupts = <GIC_SPI 189 IRQ_TYPE_NONE>;
+			interrupts-names = "irqmux";
+			ranges = <0 0x09200000 0x10000>;
+
+			pio10: pio@09200000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x0 0x100>;
+				st,bank-name = "PIO10";
+			};
+			pio11: pio@09201000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x1000 0x100>;
+				st,bank-name = "PIO11";
+			};
+			pio12: pio@09202000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x2000 0x100>;
+				st,bank-name = "PIO12";
+			};
+			pio13: pio@09203000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x3000 0x100>;
+				st,bank-name = "PIO13";
+			};
+			pio14: pio@09204000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x4000 0x100>;
+				st,bank-name = "PIO14";
+			};
+			pio15: pio@09205000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x5000 0x100>;
+				st,bank-name = "PIO15";
+			};
+			pio16: pio@09206000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x6000 0x100>;
+				st,bank-name = "PIO16";
+			};
+			pio17: pio@09207000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x7000 0x100>;
+				st,bank-name = "PIO17";
+			};
+			pio18: pio@09208000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x8000 0x100>;
+				st,bank-name = "PIO18";
+			};
+			pio19: pio@09209000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x9000 0x100>;
+				st,bank-name = "PIO19";
+			};
+
+			/* Comms */
+			serial0 {
+				pinctrl_serial0: serial0-0 {
+					st,pins {
+						tx = <&pio17 0 ALT1 OUT>;
+						rx = <&pio17 1 ALT1 IN>;
+					};
+				};
+			};
+
+			serial1 {
+				pinctrl_serial1: serial1-0 {
+					st,pins {
+						tx = <&pio16 0 ALT1 OUT>;
+						rx = <&pio16 1 ALT1 IN>;
+					};
+				};
+			};
+
+			serial2 {
+				pinctrl_serial2: serial2-0 {
+					st,pins {
+						tx = <&pio15 0 ALT1 OUT>;
+						rx = <&pio15 1 ALT1 IN>;
+					};
+				};
+			};
+
+			mmc1 {
+				pinctrl_sd1: sd1-0 {
+					st,pins {
+						sd_clk = <&pio19 3 ALT5 BIDIR NICLK 0 CLK_B>;
+						sd_cmd = <&pio19 2 ALT5 BIDIR_PU BYPASS 0>;
+						sd_dat0 = <&pio19 4 ALT5 BIDIR_PU BYPASS 0>;
+						sd_dat1 = <&pio19 5 ALT5 BIDIR_PU BYPASS 0>;
+						sd_dat2 = <&pio19 6 ALT5 BIDIR_PU BYPASS 0>;
+						sd_dat3 = <&pio19 7 ALT5 BIDIR_PU BYPASS 0>;
+						sd_led = <&pio16 6 ALT6 OUT>;
+						sd_pwren = <&pio16 7 ALT6 OUT>;
+						sd_cd = <&pio19 0 ALT6 IN>;
+						sd_wp = <&pio19 1 ALT6 IN>;
+					};
+				};
+			};
+
+
+			i2c0 {
+				pinctrl_i2c0_default: i2c0-default {
+					st,pins {
+						sda = <&pio10 6 ALT2 BIDIR>;
+						scl = <&pio10 5 ALT2 BIDIR>;
+					};
+				};
+			};
+
+			i2c1 {
+				pinctrl_i2c1_default: i2c1-default {
+					st,pins {
+						sda = <&pio11 1 ALT2 BIDIR>;
+						scl = <&pio11 0 ALT2 BIDIR>;
+					};
+				};
+			};
+
+			i2c2 {
+				pinctrl_i2c2_default: i2c2-default {
+					st,pins {
+						sda = <&pio15 6 ALT2 BIDIR>;
+						scl = <&pio15 5 ALT2 BIDIR>;
+					};
+				};
+			};
+
+			i2c3 {
+				pinctrl_i2c3_default: i2c3-default {
+					st,pins {
+						sda = <&pio18 6 ALT1 BIDIR>;
+						scl = <&pio18 5 ALT1 BIDIR>;
+					};
+				};
+			};
+
+			spi0 {
+				pinctrl_spi0_default: spi0-default {
+					st,pins {
+						mtsr = <&pio12 6 ALT2 BIDIR>;
+						mrst = <&pio12 7 ALT2 BIDIR>;
+						scl = <&pio12 5 ALT2 BIDIR>;
+					};
+				};
+			};
+		};
+
+		pin-controller-front1 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "st,stih407-front-pinctrl";
+			st,syscfg = <&syscfg_front>;
+			reg = <0x0921f080 0x4>;
+			reg-names = "irqmux";
+			interrupts = <GIC_SPI 190 IRQ_TYPE_NONE>;
+			interrupts-names = "irqmux";
+			ranges = <0 0x09210000 0x10000>;
+
+			pio20: pio@09210000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x0 0x100>;
+				st,bank-name = "PIO20";
+			};
+		};
+
+		pin-controller-rear {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "st,stih407-rear-pinctrl";
+			st,syscfg = <&syscfg_rear>;
+			reg = <0x0922f080 0x4>;
+			reg-names = "irqmux";
+			interrupts = <GIC_SPI 191 IRQ_TYPE_NONE>;
+			interrupts-names = "irqmux";
+			ranges = <0 0x09220000 0x6000>;
+
+			pio30: gpio@09220000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x0 0x100>;
+				st,bank-name = "PIO30";
+			};
+			pio31: gpio@09221000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x1000 0x100>;
+				st,bank-name = "PIO31";
+			};
+			pio32: gpio@09222000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x2000 0x100>;
+				st,bank-name = "PIO32";
+			};
+			pio33: gpio@09223000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x3000 0x100>;
+				st,bank-name = "PIO33";
+			};
+			pio34: gpio@09224000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x4000 0x100>;
+				st,bank-name = "PIO34";
+			};
+			pio35: gpio@09225000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x5000 0x100>;
+				st,bank-name = "PIO35";
+			};
+
+			i2c4 {
+				pinctrl_i2c4_default: i2c4-default {
+					st,pins {
+						sda = <&pio30 1 ALT1 BIDIR>;
+						scl = <&pio30 0 ALT1 BIDIR>;
+					};
+				};
+			};
+
+			i2c5 {
+				pinctrl_i2c5_default: i2c5-default {
+					st,pins {
+						sda = <&pio34 4 ALT1 BIDIR>;
+						scl = <&pio34 3 ALT1 BIDIR>;
+					};
+				};
+			};
+
+			usb3 {
+				pinctrl_usb3: usb3-2 {
+					st,pins {
+						usb-oc-detect = <&pio35 4 ALT1 IN>;
+						usb-pwr-enable = <&pio35 5 ALT1 OUT>;
+						usb-vbus-valid = <&pio35 6 ALT1 IN>;
+					};
+				};
+			};
+
+			pwm0 {
+				pinctrl_pwm0_chan0_default: pwm0-0-default {
+					st,pins {
+						pwm-out = <&pio31 1 ALT1 OUT>;
+					};
+				};
+			};
+		};
+
+		pin-controller-flash {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "st,stih407-flash-pinctrl";
+			st,syscfg = <&syscfg_flash>;
+			reg = <0x0923f080 0x4>;
+			reg-names = "irqmux";
+			interrupts = <GIC_SPI 192 IRQ_TYPE_NONE>;
+			interrupts-names = "irqmux";
+			ranges = <0 0x09230000 0x3000>;
+
+			pio40: gpio@09230000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0 0x100>;
+				st,bank-name = "PIO40";
+			};
+			pio41: gpio@09231000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x1000 0x100>;
+				st,bank-name = "PIO41";
+			};
+			pio42: gpio@09232000 {
+				gpio-controller;
+				#gpio-cells = <1>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
+				reg = <0x2000 0x100>;
+				st,bank-name = "PIO42";
+			};
+
+			mmc0 {
+				pinctrl_mmc0: mmc0-0 {
+					st,pins {
+						emmc_clk = <&pio40 6 ALT1 BIDIR>;
+						emmc_cmd = <&pio40 7 ALT1 BIDIR_PU>;
+						emmc_d0 = <&pio41 0 ALT1 BIDIR_PU>;
+						emmc_d1 = <&pio41 1 ALT1 BIDIR_PU>;
+						emmc_d2 = <&pio41 2 ALT1 BIDIR_PU>;
+						emmc_d3 = <&pio41 3 ALT1 BIDIR_PU>;
+						emmc_d4 = <&pio41 4 ALT1 BIDIR_PU>;
+						emmc_d5 = <&pio41 5 ALT1 BIDIR_PU>;
+						emmc_d6 = <&pio41 6 ALT1 BIDIR_PU>;
+						emmc_d7 = <&pio41 7 ALT1 BIDIR_PU>;
+					};
+				};
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/stih407.dtsi b/arch/arm/boot/dts/stih407.dtsi
new file mode 100644
index 0000000..4f9024f
--- /dev/null
+++ b/arch/arm/boot/dts/stih407.dtsi
@@ -0,0 +1,263 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics Limited.
+ * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "stih407-clock.dtsi"
+#include "stih407-pinctrl.dtsi"
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		cpu@0 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0>;
+		};
+		cpu@1 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <1>;
+		};
+	};
+
+	intc: interrupt-controller@08761000 {
+		compatible = "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		interrupt-controller;
+		reg = <0x08761000 0x1000>, <0x08760100 0x100>;
+	};
+
+	scu@08760000 {
+		compatible = "arm,cortex-a9-scu";
+		reg = <0x08760000 0x1000>;
+	};
+
+	timer@08760200 {
+		interrupt-parent = <&intc>;
+		compatible = "arm,cortex-a9-global-timer";
+		reg = <0x08760200 0x100>;
+		interrupts = <GIC_PPI 11 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&arm_periph_clk>;
+	};
+
+	l2: cache-controller {
+		compatible = "arm,pl310-cache";
+		reg = <0x08762000 0x1000>;
+		arm,data-latency = <3 3 3>;
+		arm,tag-latency = <2 2 2>;
+		cache-unified;
+		cache-level = <2>;
+	};
+
+	soc {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		interrupt-parent = <&intc>;
+		ranges;
+		compatible = "simple-bus";
+
+		syscfg_sbc: sbc-syscfg@9620000 {
+			compatible = "st,stih407-sbc-syscfg", "syscon";
+			reg = <0x9620000 0x1000>;
+		};
+
+		syscfg_front: front-syscfg@9280000 {
+			compatible = "st,stih407-front-syscfg", "syscon";
+			reg = <0x9280000 0x1000>;
+		};
+
+		syscfg_rear: rear-syscfg@9290000 {
+			compatible = "st,stih407-rear-syscfg", "syscon";
+			reg = <0x9290000 0x1000>;
+		};
+
+		syscfg_flash: flash-syscfg@92a0000 {
+			compatible = "st,stih407-flash-syscfg", "syscon";
+			reg = <0x92a0000 0x1000>;
+		};
+
+		syscfg_sbc_reg: fvdp-lite-syscfg@9600000 {
+			compatible = "st,stih407-sbc-reg-syscfg", "syscon";
+			reg = <0x9600000 0x1000>;
+		};
+
+		syscfg_core: core-syscfg@92b0000 {
+			compatible = "st,stih407-core-syscfg", "syscon";
+			reg = <0x92b0000 0x1000>;
+		};
+
+		syscfg_lpm: lpm-syscfg@94b5100 {
+			compatible = "st,stih407-lpm-syscfg", "syscon";
+			reg = <0x94b5100 0x1000>;
+		};
+
+		serial@9830000 {
+			compatible = "st,asc";
+			reg = <0x9830000 0x2c>;
+			interrupts = <GIC_SPI 122 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_serial0>;
+			clocks = <&clk_ext2f_a9>;
+
+			status = "disabled";
+		};
+
+		serial@9831000 {
+			compatible = "st,asc";
+			reg = <0x9831000 0x2c>;
+			interrupts = <GIC_SPI 123 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_serial1>;
+			clocks = <&clk_ext2f_a9>;
+
+			status = "disabled";
+		};
+
+		serial@9832000 {
+			compatible = "st,asc";
+			reg = <0x9832000 0x2c>;
+			interrupts = <GIC_SPI 124 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_serial2>;
+			clocks = <&clk_ext2f_a9>;
+
+			status = "disabled";
+		};
+
+		/* SBC_ASC0 - UART10 */
+		sbc_serial0: serial@9530000 {
+			compatible = "st,asc";
+			reg = <0x9530000 0x2c>;
+			interrupts = <GIC_SPI 138 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_sbc_serial0>;
+			clocks = <&clk_sysin>;
+
+			status = "disabled";
+		};
+
+		serial@9531000 {
+			compatible = "st,asc";
+			reg = <0x9531000 0x2c>;
+			interrupts = <GIC_SPI 139 IRQ_TYPE_NONE>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_sbc_serial1>;
+			clocks = <&clk_sysin>;
+
+			status = "disabled";
+		};
+
+		i2c@9840000 {
+			compatible = "st,comms-ssc4-i2c";
+			interrupts = <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
+			reg = <0x9840000 0x110>;
+			clocks = <&clk_ext2f_a9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c0_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9841000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9841000 0x110>;
+			interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_ext2f_a9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c1_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9842000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9842000 0x110>;
+			interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_ext2f_a9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c2_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9843000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9843000 0x110>;
+			interrupts = <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_ext2f_a9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c3_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9844000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9844000 0x110>;
+			interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_ext2f_a9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c4_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9845000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9845000 0x110>;
+			interrupts = <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_ext2f_a9>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c5_default>;
+
+			status = "disabled";
+		};
+
+
+		/* SSCs on SBC */
+		i2c@9540000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9540000 0x110>;
+			interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_sysin>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c10_default>;
+
+			status = "disabled";
+		};
+
+		i2c@9541000 {
+			compatible = "st,comms-ssc4-i2c";
+			reg = <0x9541000 0x110>;
+			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk_sysin>;
+			clock-names = "ssc";
+			clock-frequency = <400000>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&pinctrl_i2c11_default>;
+
+			status = "disabled";
+		};
+	};
+};
-- 
1.9.1

