Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3DWOgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:36:01 -0400
Received: from multi.imgtec.com ([194.200.65.239]:40821 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab3DWOee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:34:34 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>, Rob Landley <rob@landley.net>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH 5/8] pinctrl-tz1090: add TZ1090 pinctrl driver
Date: Tue, 23 Apr 2013 15:33:24 +0100
Message-ID: <1366727607-27444-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_04_23_15_34_27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a pin control driver for the main pins on the TZ1090 SoC. This
doesn't include the low-power pins as they're controlled separately via
the Powerdown Controller (PDC) registers.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-doc@vger.kernel.org
---
 .../bindings/pinctrl/img,tz1090-pinctrl.txt        |  214 +++
 arch/metag/Kconfig.soc                             |    2 +
 arch/metag/boot/dts/tz1090.dtsi                    |    6 +
 drivers/pinctrl/Kconfig                            |    6 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-tz1090.c                   | 2018 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-tz1090.h                   |   58 +
 7 files changed, 2305 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-tz1090.c
 create mode 100644 drivers/pinctrl/pinctrl-tz1090.h

diff --git a/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
new file mode 100644
index 0000000..4751795
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
@@ -0,0 +1,214 @@
+ImgTec TZ1090 pin controller
+
+Required properties:
+- compatible: "img,tz1090-pinctrl"
+- reg: Should contain the register physical address and length of the pad
+  configuration registers (CR_PADS_* and CR_IF_CTL0).
+
+Please refer to pinctrl-bindings.txt in this directory for details of the
+common pinctrl bindings used by client devices, including the meaning of the
+phrase "pin configuration node".
+
+TZ1090's pin configuration nodes act as a container for an abitrary number of
+subnodes. Each of these subnodes represents some desired configuration for a
+pin, a group, or a list of pins or groups. This configuration can include the
+mux function to select on those pin(s)/group(s), and various pin configuration
+parameters, such as pull-up, drive strength, etc.
+
+The name of each subnode is not important; all subnodes should be enumerated
+and processed purely based on their content.
+
+Each subnode only affects those parameters that are explicitly listed. In
+other words, a subnode that lists a mux function but no pin configuration
+parameters implies no information about any pin configuration parameters.
+Similarly, a pin subnode that describes a pullup parameter implies no
+information about e.g. the mux function. For this reason, even seemingly boolean
+values are actually tristates in this binding: unspecified, off, or on.
+Unspecified is represented as an absent property, and off/on are represented as
+integer values 0 and 1.
+
+The exception to that rule is the select config. The CR_PADS_GPIO_SELECT{0,1,2}
+registers select between the serial interface (where an internal peripheral such
+as the SPI block controls the pin) and the GPIO interface (where the pin can be
+controlled by the other GPIO registers). This defaults to the GPIO interface for
+all pins, so muxing a function onto a pin group will set all pins to the serial
+interface. This can be overridden by claiming one of the pins as a GPIO, or
+explicitly setting the select config to override this behaviour (see below).
+
+Required subnode-properties:
+- pins : An array of strings. Each string contains the name of a pin or group.
+    Valid values for these names are listed below.
+
+Optional subnode-properties:
+- function: A string containing the name of the function to mux to the pin or
+  group. Valid values for function names are listed below, including which
+  pingroups can be muxed to them.
+- select: Integer, force the pin(s) to the GPIO interface so they cannot be
+  controlled by internal peripherals.
+    0: don't force (internal peripheral will have control of the pin(s) if
+       they're muxed and not selected for GPIO use).
+    1: force gpio mode (internal peripheral will not control the pin(s))
+- pull: Integer, representing the pull-down/up to apply to the pin(s).
+    0: tri-state
+    1: pull-up
+    2: pull-down
+    3: repeater
+- schmitt: Integer, enable or disable Schmitt trigger mode for the pins.
+    0: no hysteresis
+    1: schmitt trigger
+- slew-rate: Integer, control slew rate of pins.
+    0: slow (half frequency)
+    1: fast
+- drive-strength: Integer, control drive strength of pins.
+    0: 2mA
+    1: 4mA
+    2: 8mA
+    4: 12mA
+
+Note that many of these properties are only valid for certain specific pins
+or groups. See the TZ1090 TRM for complete details regarding which groups
+support which functionality. The Linux pinctrl driver may also be a useful
+reference.
+
+Valid values for pin and group names are:
+
+  gpio pins:
+
+    These all support select and pull (which can also be provided to any of the
+    groups below to set it for all gpio pins in that group).
+
+    They also all support the "default" function (if they cannot be individually
+    muxed, see pdm_d and spi1_cs2 mux groups below).
+
+    ant_sel0, ant_sel1, gain0, gain1, gain2, gain3, gain4, gain5, gain6, gain7,
+    i2s_bclk_out, i2s_din, i2s_dout0, i2s_dout1, i2s_dout2, i2s_lrclk_out,
+    i2s_mclk, pa_on, pdm_a, pdm_b, pdm_c, pdm_d, pll_on, rx_hp, rx_on,
+    scb0_sclk, scb0_sdat, scb1_sclk, scb1_sdat, scb2_sclk, scb2_sdat, sdh_cd,
+    sdh_clk_in, sdh_wp, sdio_clk, sdio_cmd, sdio_d0, sdio_d1, sdio_d2, sdio_d3,
+    spi0_cs0, spi0_cs1, spi0_cs2, spi0_din, spi0_dout, spi0_mclk, spi1_cs0,
+    spi1_cs1, spi1_cs2, spi1_din, spi1_dout, spi1_mclk, tft_blank_ls, tft_blue0,
+    tft_blue1, tft_blue2, tft_blue3, tft_blue4, tft_blue5, tft_blue6, tft_blue7,
+    tft_green0, tft_green1, tft_green2, tft_green3, tft_green4, tft_green5,
+    tft_green6, tft_green7, tft_hsync_nr, tft_panelclk, tft_pwrsave, tft_red0,
+    tft_red1, tft_red2, tft_red3, tft_red4, tft_red5, tft_red6, tft_red7,
+    tft_vd12acb, tft_vdden_gd, tft_vsync_ns, tx_on, uart0_cts, uart0_rts,
+    uart0_rxd, uart0_txd, uart1_rxd, uart1_txd.
+
+  other pins:
+
+    These other pins are part of various pin groups below, but can't be
+    individually configured.
+
+    clk_out0, clk_out1, tck, tdi, tdo, tms, trst.
+
+  mux groups:
+
+    These all support function, and some support drive configs.
+
+    afe
+        pins:           tx_on, rx_on, pll_on, pa_on, rx_hp, ant_sel0, ant_sel1,
+                        gain0, gain1, gain2, gain3, gain4, gain5, gain6, gain7.
+        function:       afe, ts_out_0.
+        schmitt:        supported.
+        slew-rate:      supported.
+        drive-strength: supported.
+    pdm_d
+        pins:           pdm_d.
+        function:       pdm_dac, usb_vbus.
+    sdh
+        pins:           sdh_cd, sdh_wp, sdh_clk_in.
+        function:       sdh, sdio.
+    sdio
+        pins:           sdio_clk, sdio_cmd, sdio_d0, sdio_d1, sdio_d2, sdio_d3.
+        function:       sdio, sdh.
+    spi1_cs2
+        pins:           spi1_cs2.
+        function:       spi1_cs2, usb_vbus.
+    tft
+        pins:           tft_red0, tft_red1, tft_red2, tft_red3,
+                        tft_red4, tft_red5, tft_red6, tft_red7,
+                        tft_green0, tft_green1, tft_green2, tft_green3,
+                        tft_green4, tft_green5, tft_green6, tft_green7,
+                        tft_blue0, tft_blue1, tft_blue2, tft_blue3,
+                        tft_blue4, tft_blue5, tft_blue6, tft_blue7,
+                        tft_vdden_gd, tft_panelclk, tft_blank_ls, tft_vsync_ns,
+                        tft_hsync_nr, tft_vd12acb, tft_pwrsave.
+        function:       tft, ext_dac, not_iqadc_stb, iqdac_stb, ts_out_1,
+                        lcd_trace, phy_ringosc.
+        schmitt:        supported.
+        slew-rate:      supported.
+        drive-strength: supported.
+
+  drive groups:
+
+    These all support schmitt, slew-rate, and drive-strength.
+
+    jtag
+        pins:   tck, trst, tdi, tdo, tms.
+    scb1
+        pins:   scb1_sdat, scb1_sclk.
+    scb2
+        pins:   scb2_sdat, scb2_sclk.
+    spi0
+        pins:   spi0_mclk, spi0_cs0, spi0_cs1, spi0_cs2, spi0_dout, spi0_din.
+    spi1
+        pins:   spi1_mclk, spi1_cs0, spi1_cs1, spi1_cs2, spi1_dout, spi1_din.
+    uart
+        pins:   uart0_txd, uart0_rxd, uart0_rts, uart0_cts,
+                uart1_txd, uart1_rxd.
+    drive_i2s
+        pins:   clk_out1, i2s_din, i2s_dout0, i2s_dout1, i2s_dout2,
+                i2s_lrclk_out, i2s_bclk_out, i2s_mclk.
+    drive_pdm
+        pins:   clk_out0, pdm_b, pdm_a.
+    drive_scb0
+        pins:   scb0_sclk, scb0_sdat, pdm_d, pdm_c.
+    drive_sdio
+        pins:   sdio_clk, sdio_cmd, sdio_d0, sdio_d1, sdio_d2, sdio_d3,
+                sdh_wp, sdh_cd, sdh_clk_in.
+
+  convenience groups:
+
+    These are just convenient groupings of pins and don't support any drive
+    configs.
+
+    uart0
+        pins:   uart0_cts, uart0_rts, uart0_rxd, uart0_txd.
+    uart1
+        pins:   uart1_rxd, uart1_txd.
+    scb0
+        pins:   scb0_sclk, scb0_sdat.
+    i2s
+        pins:   i2s_bclk_out, i2s_din, i2s_dout0, i2s_dout1, i2s_dout2,
+                i2s_lrclk_out, i2s_mclk.
+
+Example:
+
+	pinctrl@02005800 {
+		#gpio-range-cells = <2>;
+		compatible = "img,tz1090-pinctrl";
+		reg = <0x02005800 0xe4>;
+	};
+
+Example board file extract:
+
+	pinctrl@02005800 {
+		uart0_default: uart0 {
+			uart0_cfg {
+				pins =	"uart0_rxd",
+					"uart0_txd";
+				function = "default";
+			};
+		};
+		tft_default: tft {
+			tft_cfg {
+				pins =	"tft";
+				function = "tft";
+			};
+		};
+	};
+
+	uart@02004b00 {
+		pinctrl-names = "default";
+		pinctrl-0 = <&uart0_default>;
+	};
diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index 433befd..944dc30 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -20,6 +20,8 @@ config SOC_TZ1090
 	select METAG_LNKGET_AROUND_CACHE
 	select METAG_META21
 	select METAG_SMP_WRITE_REORDERING
+	select PINCTRL
+	select PINCTRL_TZ1090
 	help
 	  This is a Toumaz Technology Xenif TZ1090 (A.K.A. Comet) SoC containing
 	  a 2-threaded HTP.
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index 12d671c..ccbcbf1 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -41,5 +41,11 @@
 			             <29 4 /* level */>, /* Perip 1 (IR) */
 			             <31 4 /* level */>; /* Perip 2 (WDT) */
 		};
+
+		pinctrl: pinctrl@02005800 {
+			#gpio-range-cells = <2>;
+			compatible = "img,tz1090-pinctrl";
+			reg = <0x02005800 0xe4>;
+		};
 	};
 };
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 34f51d2..5f8bfa8 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -196,6 +196,12 @@ config PINCTRL_TEGRA114
 	bool
 	select PINCTRL_TEGRA
 
+config PINCTRL_TZ1090
+	bool "Toumaz Xenif TZ1090 pin control driver"
+	depends on SOC_TZ1090
+	select PINMUX
+	select PINCONF
+
 config PINCTRL_U300
 	bool "U300 pin controller driver"
 	depends on ARCH_U300
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index f82cc5b..1ae5596 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_PINCTRL_TEGRA)	+= pinctrl-tegra.o
 obj-$(CONFIG_PINCTRL_TEGRA20)	+= pinctrl-tegra20.o
 obj-$(CONFIG_PINCTRL_TEGRA30)	+= pinctrl-tegra30.o
 obj-$(CONFIG_PINCTRL_TEGRA114)	+= pinctrl-tegra114.o
+obj-$(CONFIG_PINCTRL_TZ1090)	+= pinctrl-tz1090.o
 obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
 obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
 obj-$(CONFIG_PINCTRL_SAMSUNG)	+= pinctrl-samsung.o
diff --git a/drivers/pinctrl/pinctrl-tz1090.c b/drivers/pinctrl/pinctrl-tz1090.c
new file mode 100644
index 0000000..5ec36b8
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-tz1090.c
@@ -0,0 +1,2018 @@
+/*
+ * Pinctrl driver for the Toumaz Xenif TZ1090 SoC
+ *
+ * Copyright (c) 2013, Imagination Technologies Ltd.
+ *
+ * Derived from Tegra code:
+ * Copyright (c) 2011-2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Derived from code:
+ * Copyright (C) 2010 Google, Inc.
+ * Copyright (C) 2010 NVIDIA Corporation
+ * Copyright (C) 2009-2011 ST-Ericsson AB
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <asm/global_lock.h>
+#include <asm/soc-tz1090/gpio.h>
+
+#include "core.h"
+#include "pinctrl-tz1090.h"
+
+/* Register offsets from bank base address */
+#define REG_PINCTRL_SELECT	0x10
+#define REG_PINCTRL_SCHMITT	0x90
+#define REG_PINCTRL_PU_PD	0xa0
+#define REG_PINCTRL_SR		0xc0
+#define REG_PINCTRL_DR		0xd0
+#define REG_PINCTRL_IF_CTL	0xe0
+
+/**
+ * struct tz1090_function - TZ1090 pinctrl mux function
+ * @name:	The name of the function, exported to pinctrl core.
+ * @groups:	An array of pin groups that may select this function.
+ * @ngroups:	The number of entries in @groups.
+ */
+struct tz1090_function {
+	const char		*name;
+	const char * const	*groups;
+	unsigned		ngroups;
+};
+
+/**
+ * struct tz1090_muxdesc - TZ1090 individual mux description
+ * @funcs:	Function for each mux value.
+ * @reg:	Mux register offset. 0 if unsupported.
+ * @bit:	Mux register bit. 0 if unsupported.
+ * @width:	Mux field width. 0 if unsupported.
+ *
+ * A representation of a group of signals (possibly just one signal) in the
+ * TZ1090 which can be muxed to a set of functions or sub muxes.
+ */
+struct tz1090_muxdesc {
+	int	funcs[5];
+	u16	reg;
+	u32	bit:5;
+	u32	width:5;
+};
+
+/**
+ * struct tz1090_pingroup - TZ1090 pin group
+ * @name:	Name of pin group.
+ * @pins:	Array of pin numbers in this pin group.
+ * @npins:	Number of pins in this pin group.
+ * @mux:	Top level mux.
+ * @drv:	Drive control supported, 0 if unsupported.
+ *		This means Schmitt, Slew, and Drive strength.
+ * @slw_bit:	Slew register bit. 0 if unsupported.
+ *		The same bit is used for Schmitt, and Drive (*2).
+ *
+ * A representation of a group of pins (possibly just one pin) in the TZ1090
+ * pin controller. Each group allows some parameter or parameters to be
+ * configured. The most common is mux function selection.
+ */
+struct tz1090_pingroup {
+	const char		*name;
+	const unsigned int	*pins;
+	unsigned int		npins;
+	struct tz1090_muxdesc	mux;
+
+	u32			drv:1;
+	u32			slw_bit:5;
+};
+
+/*
+ * Most pins affected by the pinmux can also be GPIOs. Define these first.
+ * These must match how the GPIO driver names/numbers its pins.
+ */
+#define _GPIO(offset)			(GPIO_##offset)
+
+#define TZ1090_PIN_SDIO_CLK		_GPIO(SDIO_CLK)
+#define TZ1090_PIN_SDIO_CMD		_GPIO(SDIO_CMD)
+#define TZ1090_PIN_SDIO_D0		_GPIO(SDIO_D0)
+#define TZ1090_PIN_SDIO_D1		_GPIO(SDIO_D1)
+#define TZ1090_PIN_SDIO_D2		_GPIO(SDIO_D2)
+#define TZ1090_PIN_SDIO_D3		_GPIO(SDIO_D3)
+#define TZ1090_PIN_SDH_CD		_GPIO(SDH_CD)
+#define TZ1090_PIN_SDH_WP		_GPIO(SDH_WP)
+#define TZ1090_PIN_SPI0_MCLK		_GPIO(SPI0_MCLK)
+#define TZ1090_PIN_SPI0_CS0		_GPIO(SPI0_CS0)
+#define TZ1090_PIN_SPI0_CS1		_GPIO(SPI0_CS1)
+#define TZ1090_PIN_SPI0_CS2		_GPIO(SPI0_CS2)
+#define TZ1090_PIN_SPI0_DOUT		_GPIO(SPI0_DOUT)
+#define TZ1090_PIN_SPI0_DIN		_GPIO(SPI0_DIN)
+#define TZ1090_PIN_SPI1_MCLK		_GPIO(SPI1_MCLK)
+#define TZ1090_PIN_SPI1_CS0		_GPIO(SPI1_CS0)
+#define TZ1090_PIN_SPI1_CS1		_GPIO(SPI1_CS1)
+#define TZ1090_PIN_SPI1_CS2		_GPIO(SPI1_CS2)
+#define TZ1090_PIN_SPI1_DOUT		_GPIO(SPI1_DOUT)
+#define TZ1090_PIN_SPI1_DIN		_GPIO(SPI1_DIN)
+#define TZ1090_PIN_UART0_RXD		_GPIO(UART0_RXD)
+#define TZ1090_PIN_UART0_TXD		_GPIO(UART0_TXD)
+#define TZ1090_PIN_UART0_CTS		_GPIO(UART0_CTS)
+#define TZ1090_PIN_UART0_RTS		_GPIO(UART0_RTS)
+#define TZ1090_PIN_UART1_RXD		_GPIO(UART1_RXD)
+#define TZ1090_PIN_UART1_TXD		_GPIO(UART1_TXD)
+#define TZ1090_PIN_SCB0_SDAT		_GPIO(SCB0_SDAT)
+#define TZ1090_PIN_SCB0_SCLK		_GPIO(SCB0_SCLK)
+#define TZ1090_PIN_SCB1_SDAT		_GPIO(SCB1_SDAT)
+#define TZ1090_PIN_SCB1_SCLK		_GPIO(SCB1_SCLK)
+#define TZ1090_PIN_SCB2_SDAT		_GPIO(SCB2_SDAT)
+#define TZ1090_PIN_SCB2_SCLK		_GPIO(SCB2_SCLK)
+#define TZ1090_PIN_I2S_MCLK		_GPIO(I2S_MCLK)
+#define TZ1090_PIN_I2S_BCLK_OUT		_GPIO(I2S_BCLK_OUT)
+#define TZ1090_PIN_I2S_LRCLK_OUT	_GPIO(I2S_LRCLK_OUT)
+#define TZ1090_PIN_I2S_DOUT0		_GPIO(I2S_DOUT0)
+#define TZ1090_PIN_I2S_DOUT1		_GPIO(I2S_DOUT1)
+#define TZ1090_PIN_I2S_DOUT2		_GPIO(I2S_DOUT2)
+#define TZ1090_PIN_I2S_DIN		_GPIO(I2S_DIN)
+#define TZ1090_PIN_PDM_A		_GPIO(PDM_A)
+#define TZ1090_PIN_PDM_B		_GPIO(PDM_B)
+#define TZ1090_PIN_PDM_C		_GPIO(PDM_C)
+#define TZ1090_PIN_PDM_D		_GPIO(PDM_D)
+#define TZ1090_PIN_TFT_RED0		_GPIO(TFT_RED0)
+#define TZ1090_PIN_TFT_RED1		_GPIO(TFT_RED1)
+#define TZ1090_PIN_TFT_RED2		_GPIO(TFT_RED2)
+#define TZ1090_PIN_TFT_RED3		_GPIO(TFT_RED3)
+#define TZ1090_PIN_TFT_RED4		_GPIO(TFT_RED4)
+#define TZ1090_PIN_TFT_RED5		_GPIO(TFT_RED5)
+#define TZ1090_PIN_TFT_RED6		_GPIO(TFT_RED6)
+#define TZ1090_PIN_TFT_RED7		_GPIO(TFT_RED7)
+#define TZ1090_PIN_TFT_GREEN0		_GPIO(TFT_GREEN0)
+#define TZ1090_PIN_TFT_GREEN1		_GPIO(TFT_GREEN1)
+#define TZ1090_PIN_TFT_GREEN2		_GPIO(TFT_GREEN2)
+#define TZ1090_PIN_TFT_GREEN3		_GPIO(TFT_GREEN3)
+#define TZ1090_PIN_TFT_GREEN4		_GPIO(TFT_GREEN4)
+#define TZ1090_PIN_TFT_GREEN5		_GPIO(TFT_GREEN5)
+#define TZ1090_PIN_TFT_GREEN6		_GPIO(TFT_GREEN6)
+#define TZ1090_PIN_TFT_GREEN7		_GPIO(TFT_GREEN7)
+#define TZ1090_PIN_TFT_BLUE0		_GPIO(TFT_BLUE0)
+#define TZ1090_PIN_TFT_BLUE1		_GPIO(TFT_BLUE1)
+#define TZ1090_PIN_TFT_BLUE2		_GPIO(TFT_BLUE2)
+#define TZ1090_PIN_TFT_BLUE3		_GPIO(TFT_BLUE3)
+#define TZ1090_PIN_TFT_BLUE4		_GPIO(TFT_BLUE4)
+#define TZ1090_PIN_TFT_BLUE5		_GPIO(TFT_BLUE5)
+#define TZ1090_PIN_TFT_BLUE6		_GPIO(TFT_BLUE6)
+#define TZ1090_PIN_TFT_BLUE7		_GPIO(TFT_BLUE7)
+#define TZ1090_PIN_TFT_VDDEN_GD		_GPIO(TFT_VDDEN_GD)
+#define TZ1090_PIN_TFT_PANELCLK		_GPIO(TFT_PANELCLK)
+#define TZ1090_PIN_TFT_BLANK_LS		_GPIO(TFT_BLANK_LS)
+#define TZ1090_PIN_TFT_VSYNC_NS		_GPIO(TFT_VSYNC_NS)
+#define TZ1090_PIN_TFT_HSYNC_NR		_GPIO(TFT_HSYNC_NR)
+#define TZ1090_PIN_TFT_VD12ACB		_GPIO(TFT_VD12ACB)
+#define TZ1090_PIN_TFT_PWRSAVE		_GPIO(TFT_PWRSAVE)
+#define TZ1090_PIN_TX_ON		_GPIO(TX_ON)
+#define TZ1090_PIN_RX_ON		_GPIO(RX_ON)
+#define TZ1090_PIN_PLL_ON		_GPIO(PLL_ON)
+#define TZ1090_PIN_PA_ON		_GPIO(PA_ON)
+#define TZ1090_PIN_RX_HP		_GPIO(RX_HP)
+#define TZ1090_PIN_GAIN0		_GPIO(GAIN0)
+#define TZ1090_PIN_GAIN1		_GPIO(GAIN1)
+#define TZ1090_PIN_GAIN2		_GPIO(GAIN2)
+#define TZ1090_PIN_GAIN3		_GPIO(GAIN3)
+#define TZ1090_PIN_GAIN4		_GPIO(GAIN4)
+#define TZ1090_PIN_GAIN5		_GPIO(GAIN5)
+#define TZ1090_PIN_GAIN6		_GPIO(GAIN6)
+#define TZ1090_PIN_GAIN7		_GPIO(GAIN7)
+#define TZ1090_PIN_ANT_SEL0		_GPIO(ANT_SEL0)
+#define TZ1090_PIN_ANT_SEL1		_GPIO(ANT_SEL1)
+#define TZ1090_PIN_SDH_CLK_IN		_GPIO(SDH_CLK_IN)
+
+/* Non-GPIO pins follow */
+#define NUM_GPIOS			NR_BUILTIN_GPIO
+#define _PIN(offset)			(NUM_GPIOS + (offset))
+
+#define TZ1090_PIN_TCK			_PIN(0)
+#define TZ1090_PIN_TRST			_PIN(1)
+#define TZ1090_PIN_TDI			_PIN(2)
+#define TZ1090_PIN_TDO			_PIN(3)
+#define TZ1090_PIN_TMS			_PIN(4)
+#define TZ1090_PIN_CLK_OUT0		_PIN(5)
+#define TZ1090_PIN_CLK_OUT1		_PIN(6)
+
+/* Pin names */
+
+static const struct pinctrl_pin_desc tz1090_pins[] = {
+	/* Normal GPIOs */
+	PINCTRL_PIN(TZ1090_PIN_SDIO_CLK,	"sdio_clk"),
+	PINCTRL_PIN(TZ1090_PIN_SDIO_CMD,	"sdio_cmd"),
+	PINCTRL_PIN(TZ1090_PIN_SDIO_D0,		"sdio_d0"),
+	PINCTRL_PIN(TZ1090_PIN_SDIO_D1,		"sdio_d1"),
+	PINCTRL_PIN(TZ1090_PIN_SDIO_D2,		"sdio_d2"),
+	PINCTRL_PIN(TZ1090_PIN_SDIO_D3,		"sdio_d3"),
+	PINCTRL_PIN(TZ1090_PIN_SDH_CD,		"sdh_cd"),
+	PINCTRL_PIN(TZ1090_PIN_SDH_WP,		"sdh_wp"),
+	PINCTRL_PIN(TZ1090_PIN_SPI0_MCLK,	"spi0_mclk"),
+	PINCTRL_PIN(TZ1090_PIN_SPI0_CS0,	"spi0_cs0"),
+	PINCTRL_PIN(TZ1090_PIN_SPI0_CS1,	"spi0_cs1"),
+	PINCTRL_PIN(TZ1090_PIN_SPI0_CS2,	"spi0_cs2"),
+	PINCTRL_PIN(TZ1090_PIN_SPI0_DOUT,	"spi0_dout"),
+	PINCTRL_PIN(TZ1090_PIN_SPI0_DIN,	"spi0_din"),
+	PINCTRL_PIN(TZ1090_PIN_SPI1_MCLK,	"spi1_mclk"),
+	PINCTRL_PIN(TZ1090_PIN_SPI1_CS0,	"spi1_cs0"),
+	PINCTRL_PIN(TZ1090_PIN_SPI1_CS1,	"spi1_cs1"),
+	PINCTRL_PIN(TZ1090_PIN_SPI1_CS2,	"spi1_cs2"),
+	PINCTRL_PIN(TZ1090_PIN_SPI1_DOUT,	"spi1_dout"),
+	PINCTRL_PIN(TZ1090_PIN_SPI1_DIN,	"spi1_din"),
+	PINCTRL_PIN(TZ1090_PIN_UART0_RXD,	"uart0_rxd"),
+	PINCTRL_PIN(TZ1090_PIN_UART0_TXD,	"uart0_txd"),
+	PINCTRL_PIN(TZ1090_PIN_UART0_CTS,	"uart0_cts"),
+	PINCTRL_PIN(TZ1090_PIN_UART0_RTS,	"uart0_rts"),
+	PINCTRL_PIN(TZ1090_PIN_UART1_RXD,	"uart1_rxd"),
+	PINCTRL_PIN(TZ1090_PIN_UART1_TXD,	"uart1_txd"),
+	PINCTRL_PIN(TZ1090_PIN_SCB0_SDAT,	"scb0_sdat"),
+	PINCTRL_PIN(TZ1090_PIN_SCB0_SCLK,	"scb0_sclk"),
+	PINCTRL_PIN(TZ1090_PIN_SCB1_SDAT,	"scb1_sdat"),
+	PINCTRL_PIN(TZ1090_PIN_SCB1_SCLK,	"scb1_sclk"),
+	PINCTRL_PIN(TZ1090_PIN_SCB2_SDAT,	"scb2_sdat"),
+	PINCTRL_PIN(TZ1090_PIN_SCB2_SCLK,	"scb2_sclk"),
+	PINCTRL_PIN(TZ1090_PIN_I2S_MCLK,	"i2s_mclk"),
+	PINCTRL_PIN(TZ1090_PIN_I2S_BCLK_OUT,	"i2s_bclk_out"),
+	PINCTRL_PIN(TZ1090_PIN_I2S_LRCLK_OUT,	"i2s_lrclk_out"),
+	PINCTRL_PIN(TZ1090_PIN_I2S_DOUT0,	"i2s_dout0"),
+	PINCTRL_PIN(TZ1090_PIN_I2S_DOUT1,	"i2s_dout1"),
+	PINCTRL_PIN(TZ1090_PIN_I2S_DOUT2,	"i2s_dout2"),
+	PINCTRL_PIN(TZ1090_PIN_I2S_DIN,		"i2s_din"),
+	PINCTRL_PIN(TZ1090_PIN_PDM_A,		"pdm_a"),
+	PINCTRL_PIN(TZ1090_PIN_PDM_B,		"pdm_b"),
+	PINCTRL_PIN(TZ1090_PIN_PDM_C,		"pdm_c"),
+	PINCTRL_PIN(TZ1090_PIN_PDM_D,		"pdm_d"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_RED0,	"tft_red0"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_RED1,	"tft_red1"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_RED2,	"tft_red2"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_RED3,	"tft_red3"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_RED4,	"tft_red4"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_RED5,	"tft_red5"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_RED6,	"tft_red6"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_RED7,	"tft_red7"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_GREEN0,	"tft_green0"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_GREEN1,	"tft_green1"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_GREEN2,	"tft_green2"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_GREEN3,	"tft_green3"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_GREEN4,	"tft_green4"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_GREEN5,	"tft_green5"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_GREEN6,	"tft_green6"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_GREEN7,	"tft_green7"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_BLUE0,	"tft_blue0"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_BLUE1,	"tft_blue1"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_BLUE2,	"tft_blue2"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_BLUE3,	"tft_blue3"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_BLUE4,	"tft_blue4"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_BLUE5,	"tft_blue5"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_BLUE6,	"tft_blue6"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_BLUE7,	"tft_blue7"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_VDDEN_GD,	"tft_vdden_gd"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_PANELCLK,	"tft_panelclk"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_BLANK_LS,	"tft_blank_ls"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_VSYNC_NS,	"tft_vsync_ns"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_HSYNC_NR,	"tft_hsync_nr"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_VD12ACB,	"tft_vd12acb"),
+	PINCTRL_PIN(TZ1090_PIN_TFT_PWRSAVE,	"tft_pwrsave"),
+	PINCTRL_PIN(TZ1090_PIN_TX_ON,		"tx_on"),
+	PINCTRL_PIN(TZ1090_PIN_RX_ON,		"rx_on"),
+	PINCTRL_PIN(TZ1090_PIN_PLL_ON,		"pll_on"),
+	PINCTRL_PIN(TZ1090_PIN_PA_ON,		"pa_on"),
+	PINCTRL_PIN(TZ1090_PIN_RX_HP,		"rx_hp"),
+	PINCTRL_PIN(TZ1090_PIN_GAIN0,		"gain0"),
+	PINCTRL_PIN(TZ1090_PIN_GAIN1,		"gain1"),
+	PINCTRL_PIN(TZ1090_PIN_GAIN2,		"gain2"),
+	PINCTRL_PIN(TZ1090_PIN_GAIN3,		"gain3"),
+	PINCTRL_PIN(TZ1090_PIN_GAIN4,		"gain4"),
+	PINCTRL_PIN(TZ1090_PIN_GAIN5,		"gain5"),
+	PINCTRL_PIN(TZ1090_PIN_GAIN6,		"gain6"),
+	PINCTRL_PIN(TZ1090_PIN_GAIN7,		"gain7"),
+	PINCTRL_PIN(TZ1090_PIN_ANT_SEL0,	"ant_sel0"),
+	PINCTRL_PIN(TZ1090_PIN_ANT_SEL1,	"ant_sel1"),
+	PINCTRL_PIN(TZ1090_PIN_SDH_CLK_IN,	"sdh_clk_in"),
+
+	/* Non-GPIOs */
+	PINCTRL_PIN(TZ1090_PIN_TCK,		"tck"),
+	PINCTRL_PIN(TZ1090_PIN_TRST,		"trst"),
+	PINCTRL_PIN(TZ1090_PIN_TDI,		"tdi"),
+	PINCTRL_PIN(TZ1090_PIN_TDO,		"tdo"),
+	PINCTRL_PIN(TZ1090_PIN_TMS,		"tms"),
+	PINCTRL_PIN(TZ1090_PIN_CLK_OUT0,	"clk_out0"),
+	PINCTRL_PIN(TZ1090_PIN_CLK_OUT1,	"clk_out1"),
+};
+
+/* Pin group pins */
+
+static const unsigned spi1_cs2_pins[] = {
+	TZ1090_PIN_SPI1_CS2,
+};
+
+static const unsigned pdm_d_pins[] = {
+	TZ1090_PIN_PDM_D,
+};
+
+static const unsigned tft_pins[] = {
+	TZ1090_PIN_TFT_RED0,
+	TZ1090_PIN_TFT_RED1,
+	TZ1090_PIN_TFT_RED2,
+	TZ1090_PIN_TFT_RED3,
+	TZ1090_PIN_TFT_RED4,
+	TZ1090_PIN_TFT_RED5,
+	TZ1090_PIN_TFT_RED6,
+	TZ1090_PIN_TFT_RED7,
+	TZ1090_PIN_TFT_GREEN0,
+	TZ1090_PIN_TFT_GREEN1,
+	TZ1090_PIN_TFT_GREEN2,
+	TZ1090_PIN_TFT_GREEN3,
+	TZ1090_PIN_TFT_GREEN4,
+	TZ1090_PIN_TFT_GREEN5,
+	TZ1090_PIN_TFT_GREEN6,
+	TZ1090_PIN_TFT_GREEN7,
+	TZ1090_PIN_TFT_BLUE0,
+	TZ1090_PIN_TFT_BLUE1,
+	TZ1090_PIN_TFT_BLUE2,
+	TZ1090_PIN_TFT_BLUE3,
+	TZ1090_PIN_TFT_BLUE4,
+	TZ1090_PIN_TFT_BLUE5,
+	TZ1090_PIN_TFT_BLUE6,
+	TZ1090_PIN_TFT_BLUE7,
+	TZ1090_PIN_TFT_VDDEN_GD,
+	TZ1090_PIN_TFT_PANELCLK,
+	TZ1090_PIN_TFT_BLANK_LS,
+	TZ1090_PIN_TFT_VSYNC_NS,
+	TZ1090_PIN_TFT_HSYNC_NR,
+	TZ1090_PIN_TFT_VD12ACB,
+	TZ1090_PIN_TFT_PWRSAVE,
+};
+
+static const unsigned afe_pins[] = {
+	TZ1090_PIN_TX_ON,
+	TZ1090_PIN_RX_ON,
+	TZ1090_PIN_PLL_ON,
+	TZ1090_PIN_PA_ON,
+	TZ1090_PIN_RX_HP,
+	TZ1090_PIN_ANT_SEL0,
+	TZ1090_PIN_ANT_SEL1,
+	TZ1090_PIN_GAIN0,
+	TZ1090_PIN_GAIN1,
+	TZ1090_PIN_GAIN2,
+	TZ1090_PIN_GAIN3,
+	TZ1090_PIN_GAIN4,
+	TZ1090_PIN_GAIN5,
+	TZ1090_PIN_GAIN6,
+	TZ1090_PIN_GAIN7,
+};
+
+static const unsigned sdio_pins[] = {
+	TZ1090_PIN_SDIO_CLK,
+	TZ1090_PIN_SDIO_CMD,
+	TZ1090_PIN_SDIO_D0,
+	TZ1090_PIN_SDIO_D1,
+	TZ1090_PIN_SDIO_D2,
+	TZ1090_PIN_SDIO_D3,
+};
+
+static const unsigned sdh_pins[] = {
+	TZ1090_PIN_SDH_CD,
+	TZ1090_PIN_SDH_WP,
+	TZ1090_PIN_SDH_CLK_IN,
+};
+
+static const unsigned spi0_pins[] = {
+	TZ1090_PIN_SPI0_MCLK,
+	TZ1090_PIN_SPI0_CS0,
+	TZ1090_PIN_SPI0_CS1,
+	TZ1090_PIN_SPI0_CS2,
+	TZ1090_PIN_SPI0_DOUT,
+	TZ1090_PIN_SPI0_DIN,
+};
+
+static const unsigned spi1_pins[] = {
+	TZ1090_PIN_SPI1_MCLK,
+	TZ1090_PIN_SPI1_CS0,
+	TZ1090_PIN_SPI1_CS1,
+	TZ1090_PIN_SPI1_CS2,
+	TZ1090_PIN_SPI1_DOUT,
+	TZ1090_PIN_SPI1_DIN,
+};
+
+static const unsigned uart0_pins[] = {
+	TZ1090_PIN_UART0_RTS,
+	TZ1090_PIN_UART0_CTS,
+	TZ1090_PIN_UART0_TXD,
+	TZ1090_PIN_UART0_RXD,
+};
+
+static const unsigned uart1_pins[] = {
+	TZ1090_PIN_UART1_TXD,
+	TZ1090_PIN_UART1_RXD,
+};
+
+static const unsigned uart_pins[] = {
+	TZ1090_PIN_UART1_TXD,
+	TZ1090_PIN_UART1_RXD,
+	TZ1090_PIN_UART0_RTS,
+	TZ1090_PIN_UART0_CTS,
+	TZ1090_PIN_UART0_TXD,
+	TZ1090_PIN_UART0_RXD,
+};
+
+static const unsigned scb0_pins[] = {
+	TZ1090_PIN_SCB0_SDAT,
+	TZ1090_PIN_SCB0_SCLK,
+};
+
+static const unsigned scb1_pins[] = {
+	TZ1090_PIN_SCB1_SDAT,
+	TZ1090_PIN_SCB1_SCLK,
+};
+
+static const unsigned scb2_pins[] = {
+	TZ1090_PIN_SCB2_SDAT,
+	TZ1090_PIN_SCB2_SCLK,
+};
+
+static const unsigned i2s_pins[] = {
+	TZ1090_PIN_I2S_MCLK,
+	TZ1090_PIN_I2S_BCLK_OUT,
+	TZ1090_PIN_I2S_LRCLK_OUT,
+	TZ1090_PIN_I2S_DOUT0,
+	TZ1090_PIN_I2S_DOUT1,
+	TZ1090_PIN_I2S_DOUT2,
+	TZ1090_PIN_I2S_DIN,
+};
+
+static const unsigned jtag_pins[] = {
+	TZ1090_PIN_TCK,
+	TZ1090_PIN_TRST,
+	TZ1090_PIN_TDI,
+	TZ1090_PIN_TDO,
+	TZ1090_PIN_TMS,
+};
+
+/* Drive pin group pins */
+
+static const unsigned drive_tft_pins[] = {
+	TZ1090_PIN_TFT_RED0,
+	TZ1090_PIN_TFT_RED1,
+	TZ1090_PIN_TFT_RED2,
+	TZ1090_PIN_TFT_RED3,
+	TZ1090_PIN_TFT_RED4,
+	TZ1090_PIN_TFT_RED5,
+	TZ1090_PIN_TFT_RED6,
+	TZ1090_PIN_TFT_RED7,
+	TZ1090_PIN_TFT_GREEN0,
+	TZ1090_PIN_TFT_GREEN1,
+	TZ1090_PIN_TFT_GREEN2,
+	TZ1090_PIN_TFT_GREEN3,
+	TZ1090_PIN_TFT_GREEN4,
+	TZ1090_PIN_TFT_GREEN5,
+	TZ1090_PIN_TFT_GREEN6,
+	TZ1090_PIN_TFT_GREEN7,
+	TZ1090_PIN_TFT_BLUE0,
+	TZ1090_PIN_TFT_BLUE1,
+	TZ1090_PIN_TFT_BLUE2,
+	TZ1090_PIN_TFT_BLUE3,
+	TZ1090_PIN_TFT_BLUE4,
+	TZ1090_PIN_TFT_BLUE5,
+	TZ1090_PIN_TFT_BLUE6,
+	TZ1090_PIN_TFT_BLUE7,
+	TZ1090_PIN_TFT_VDDEN_GD,
+	TZ1090_PIN_TFT_PANELCLK,
+	TZ1090_PIN_TFT_BLANK_LS,
+	TZ1090_PIN_TFT_VSYNC_NS,
+	TZ1090_PIN_TFT_HSYNC_NR,
+	TZ1090_PIN_TFT_VD12ACB,
+	TZ1090_PIN_TFT_PWRSAVE,
+};
+
+static const unsigned drive_sdio_pins[] = {
+	TZ1090_PIN_SDIO_CLK,
+	TZ1090_PIN_SDIO_CMD,
+	TZ1090_PIN_SDIO_D0,
+	TZ1090_PIN_SDIO_D1,
+	TZ1090_PIN_SDIO_D2,
+	TZ1090_PIN_SDIO_D3,
+	TZ1090_PIN_SDH_WP,
+	TZ1090_PIN_SDH_CD,
+	TZ1090_PIN_SDH_CLK_IN,
+};
+
+static const unsigned drive_i2s_pins[] = {
+	TZ1090_PIN_CLK_OUT1,
+	TZ1090_PIN_I2S_DIN,
+	TZ1090_PIN_I2S_DOUT0,
+	TZ1090_PIN_I2S_DOUT1,
+	TZ1090_PIN_I2S_DOUT2,
+	TZ1090_PIN_I2S_LRCLK_OUT,
+	TZ1090_PIN_I2S_BCLK_OUT,
+	TZ1090_PIN_I2S_MCLK,
+};
+
+static const unsigned drive_scb0_pins[] = {
+	TZ1090_PIN_SCB0_SCLK,
+	TZ1090_PIN_SCB0_SDAT,
+	TZ1090_PIN_PDM_D,
+	TZ1090_PIN_PDM_C,
+};
+
+static const unsigned drive_pdm_pins[] = {
+	TZ1090_PIN_CLK_OUT0,
+	TZ1090_PIN_PDM_B,
+	TZ1090_PIN_PDM_A,
+};
+
+/* Mux functions */
+
+enum tz1090_mux {
+	/* internal placeholder */
+	TZ1090_MUX_NA = -1,
+	/* default function for an unmuxed pin */
+	TZ1090_MUX_DEFAULT,
+	/* SDH/SDIO mux */
+	TZ1090_MUX_SDH,
+	TZ1090_MUX_SDIO,
+	/* USB_VBUS muxes */
+	TZ1090_MUX_SPI1_CS2,
+	TZ1090_MUX_PDM_DAC,
+	TZ1090_MUX_USB_VBUS,
+	/* AFE mux */
+	TZ1090_MUX_AFE,
+	TZ1090_MUX_TS_OUT_0,
+	/* EXT_DAC mux */
+	TZ1090_MUX_DAC,
+	TZ1090_MUX_NOT_IQADC_STB,
+	TZ1090_MUX_IQDAC_STB,
+	/* TFT mux */
+	TZ1090_MUX_TFT,
+	TZ1090_MUX_EXT_DAC,
+	TZ1090_MUX_TS_OUT_1,
+	TZ1090_MUX_LCD_TRACE,
+	TZ1090_MUX_PHY_RINGOSC,
+};
+
+/* Pin groups a function can be muxed to */
+
+static const char * const default_groups[] = {
+	/* non-muxing convenient gpio pingroups */
+	"uart",
+	"uart0",
+	"uart1",
+	"spi0",
+	"spi1",
+	"scb0",
+	"scb1",
+	"scb2",
+	"i2s",
+	/* pingroups of individual pins without a (non gpio select) mux */
+	"sdio_clk",
+	"sdio_cmd",
+	"sdio_d0",
+	"sdio_d1",
+	"sdio_d2",
+	"sdio_d3",
+	"sdh_cd",
+	"sdh_wp",
+	"spi0_mclk",
+	"spi0_cs0",
+	"spi0_cs1",
+	"spi0_cs2",
+	"spi0_dout",
+	"spi0_din",
+	"spi1_mclk",
+	"spi1_cs0",
+	"spi1_cs1",
+	/* spi1_cs2 can be muxed individually */
+	"spi1_dout",
+	"spi1_din",
+	"uart0_rxd",
+	"uart0_txd",
+	"uart0_cts",
+	"uart0_rts",
+	"uart1_rxd",
+	"uart1_txd",
+	"scb0_sdat",
+	"scb0_sclk",
+	"scb1_sdat",
+	"scb1_sclk",
+	"scb2_sdat",
+	"scb2_sclk",
+	"i2s_mclk",
+	"i2s_bclk_out",
+	"i2s_lrclk_out",
+	"i2s_dout0",
+	"i2s_dout1",
+	"i2s_dout2",
+	"i2s_din",
+	"pdm_a",
+	"pdm_b",
+	"pdm_c",
+	/* pdm_d can be muxed individually */
+	"tft_red0",
+	"tft_red1",
+	"tft_red2",
+	"tft_red3",
+	"tft_red4",
+	"tft_red5",
+	"tft_red6",
+	"tft_red7",
+	"tft_green0",
+	"tft_green1",
+	"tft_green2",
+	"tft_green3",
+	"tft_green4",
+	"tft_green5",
+	"tft_green6",
+	"tft_green7",
+	"tft_blue0",
+	"tft_blue1",
+	"tft_blue2",
+	"tft_blue3",
+	"tft_blue4",
+	"tft_blue5",
+	"tft_blue6",
+	"tft_blue7",
+	"tft_vdden_gd",
+	"tft_panelclk",
+	"tft_blank_ls",
+	"tft_vsync_ns",
+	"tft_hsync_nr",
+	"tft_vd12acb",
+	"tft_pwrsave",
+	"tx_on",
+	"rx_on",
+	"pll_on",
+	"pa_on",
+	"rx_hp",
+	"gain0",
+	"gain1",
+	"gain2",
+	"gain3",
+	"gain4",
+	"gain5",
+	"gain6",
+	"gain7",
+	"ant_sel0",
+	"ant_sel1",
+	"sdh_clk_in",
+};
+
+static const char * const sdh_sdio_groups[] = {
+	"sdh",
+	"sdio",
+};
+
+static const char * const spi1_cs2_groups[] = {
+	"spi1_cs2",
+};
+
+static const char * const pdm_dac_groups[] = {
+	"pdm_d",
+};
+
+static const char * const usb_vbus_groups[] = {
+	"spi1_cs2",
+	"pdm_d",
+};
+
+static const char * const afe_groups[] = {
+	"afe",
+};
+
+static const char * const tft_groups[] = {
+	"tft",
+};
+
+#define FUNCTION(mux, fname, group)			\
+	[(TZ1090_MUX_ ## mux)] = {			\
+		.name = #fname,				\
+		.groups = group##_groups,		\
+		.ngroups = ARRAY_SIZE(group##_groups),	\
+	}
+/* For intermediate functions with submuxes */
+#define NULL_FUNCTION(mux, fname)			\
+	[(TZ1090_MUX_ ## mux)] = {			\
+		.name = #fname,				\
+	}
+
+/* Must correlate with enum tz1090_mux */
+static const struct tz1090_function tz1090_functions[] = {
+	/*	 MUX		fn		pingroups */
+	FUNCTION(DEFAULT,	default,	default),
+	FUNCTION(SDH,		sdh,		sdh_sdio),
+	FUNCTION(SDIO,		sdio,		sdh_sdio),
+	FUNCTION(SPI1_CS2,	spi1_cs2,	spi1_cs2),
+	FUNCTION(PDM_DAC,	pdm_dac,	pdm_dac),
+	FUNCTION(USB_VBUS,	usb_vbus,	usb_vbus),
+	FUNCTION(AFE,		afe,		afe),
+	FUNCTION(TS_OUT_0,	ts_out_0,	afe),
+	FUNCTION(DAC,		ext_dac,	tft),
+	FUNCTION(NOT_IQADC_STB,	not_iqadc_stb,	tft),
+	FUNCTION(IQDAC_STB,	iqdac_stb,	tft),
+	FUNCTION(TFT,		tft,		tft),
+	NULL_FUNCTION(EXT_DAC,	_ext_dac),
+	FUNCTION(TS_OUT_1,	ts_out_1,	tft),
+	FUNCTION(LCD_TRACE,	lcd_trace,	tft),
+	FUNCTION(PHY_RINGOSC,	phy_ringosc,	tft),
+};
+
+/* Sub muxes */
+
+#define MUX(f0, f1, f2, f3, f4, mux_r, mux_b, mux_w)		\
+	{							\
+		.funcs = {					\
+			TZ1090_MUX_ ## f0,			\
+			TZ1090_MUX_ ## f1,			\
+			TZ1090_MUX_ ## f2,			\
+			TZ1090_MUX_ ## f3,			\
+			TZ1090_MUX_ ## f4,			\
+		},						\
+		.reg = (REG_PINCTRL_ ## mux_r),			\
+		.bit = (mux_b),					\
+		.width = (mux_w),				\
+	}
+
+#define DEFINE_SUBMUX(mux, f0, f1, f2, f3, f4, mux_r, mux_b, mux_w)	\
+	static struct tz1090_muxdesc mux ## _submux =			\
+		MUX(f0, f1, f2, f3, f4, mux_r, mux_b, mux_w)
+
+#define SUBMUX(f, submux)	[(TZ1090_MUX_ ## f)] = &(submux ## _submux)
+
+/* Pin group with mux control */
+#define MUX_PG(pg_name, f0, f1, f2, f3, f4,			\
+	       mux_r, mux_b, mux_w, slw_b)			\
+	{							\
+		.name = #pg_name,				\
+		.pins = pg_name##_pins,				\
+		.npins = ARRAY_SIZE(pg_name##_pins),		\
+		.mux = MUX(f0, f1, f2, f3, f4,			\
+			   mux_r, mux_b, mux_w),		\
+		.drv = ((slw_b) >= 0),				\
+		.slw_bit = (slw_b),				\
+	}
+
+#define SIMPLE_PG(pg_name)					\
+	{							\
+		.name = #pg_name,				\
+		.pins = pg_name##_pins,				\
+		.npins = ARRAY_SIZE(pg_name##_pins),		\
+	}
+
+#define SIMPLE_DRV_PG(pg_name, slw_b)				\
+	{							\
+		.name = #pg_name,				\
+		.pins = pg_name##_pins,				\
+		.npins = ARRAY_SIZE(pg_name##_pins),		\
+		.drv = 1,					\
+		.slw_bit = (slw_b),				\
+	}
+
+#define DRV_PG(pg_name, slw_b)					\
+	{							\
+		.name = "drive_"#pg_name,			\
+		.pins = drive_##pg_name##_pins,			\
+		.npins = ARRAY_SIZE(drive_##pg_name##_pins),	\
+		.drv = 1,					\
+		.slw_bit = (slw_b),				\
+	}
+
+/*            name     f0,  f1,            f2,        f3, f4, mux r/b/w */
+DEFINE_SUBMUX(ext_dac, DAC, NOT_IQADC_STB, IQDAC_STB, NA, NA, IF_CTL, 6, 2);
+
+static struct tz1090_muxdesc *tz1090_submux[] = {
+	SUBMUX(EXT_DAC, ext_dac),
+};
+
+static const struct tz1090_pingroup tz1090_groups[] = {
+	/* Muxing pin groups */
+	/*     pg_name,  f0,       f1,       f2,       f3,        f4,          mux r/b/w,    slw/schmitt/drv b */
+	MUX_PG(sdh,      SDH,      SDIO,     NA,       NA,        NA,          IF_CTL, 20, 2,  -1),
+	MUX_PG(sdio,     SDIO,     SDH,      NA,       NA,        NA,          IF_CTL, 16, 2,  -1),
+	MUX_PG(spi1_cs2, SPI1_CS2, USB_VBUS, NA,       NA,        NA,          IF_CTL, 10, 2,  -1),
+	MUX_PG(pdm_d,    PDM_DAC,  USB_VBUS, NA,       NA,        NA,          IF_CTL,  8, 2,  -1),
+	MUX_PG(afe,      AFE,      TS_OUT_0, NA,       NA,        NA,          IF_CTL,  4, 2,   0 /*  0,  0 */),
+	MUX_PG(tft,      TFT,      EXT_DAC,  TS_OUT_1, LCD_TRACE, PHY_RINGOSC, IF_CTL,  0, 3,  10 /* 10, 20 */),
+
+	/* Simple pin groups with drive control */
+	/*            pg_name,	slw/schmitt/drv b */
+	SIMPLE_DRV_PG(jtag,	11 /* 11, 22 */),
+	SIMPLE_DRV_PG(scb2,	9  /*  9, 18 */),
+	SIMPLE_DRV_PG(spi0,	7  /*  7, 14 */),
+	SIMPLE_DRV_PG(uart,	5  /*  5, 10 */),
+	SIMPLE_DRV_PG(scb1,	4  /*  4,  8 */),
+	SIMPLE_DRV_PG(spi1,	3  /*  3,  6 */),
+
+	/* Drive specific pin groups (drive_*) */
+	/*     pg_name,		slw/schmitt/drv b */
+	DRV_PG(sdio,		8  /*  8, 16 */), /* sdio_* + sdh_* */
+	DRV_PG(i2s,		6  /*  6, 12 */), /* i2s_* + clk_out1 */
+	DRV_PG(scb0,		2  /*  2,  4 */), /* scb0_* + pdm_{c,d} */
+	DRV_PG(pdm,		1  /*  1,  2 */), /* pdm_{a,b} + clk_out0 */
+
+	/* Convenience pin groups */
+	/*        pg_name */
+	SIMPLE_PG(uart0),
+	SIMPLE_PG(uart1),
+	SIMPLE_PG(scb0),
+	SIMPLE_PG(i2s),
+
+	/* pseudo-pingroups for each GPIO pin follow */
+};
+
+/**
+ * struct tz1090_pmx - Private pinctrl data
+ * @dev:	Platform device
+ * @pctl:	Pin control device
+ * @regs:	Register region
+ * @lock:	Lock protecting coherency of pin_en, gpio_en, select_en, and
+ *		SELECT regs
+ * @pin_en:	Pins that have been enabled (32 pins packed into each element)
+ * @gpio_en:	GPIOs that have been enabled (32 pins packed into each element)
+ * @select_en:	Pins that have been force seleced by pinconf (32 pins packed
+ *		into each element)
+ */
+struct tz1090_pmx {
+	struct device		*dev;
+	struct pinctrl_dev	*pctl;
+	void __iomem		*regs;
+	spinlock_t		lock;
+	u32			pin_en[3];
+	u32			gpio_en[3];
+	u32			select_en[3];
+};
+
+static inline u32 pmx_read(struct tz1090_pmx *pmx, u32 reg)
+{
+	return ioread32(pmx->regs + reg);
+}
+
+static inline void pmx_write(struct tz1090_pmx *pmx, u32 val, u32 reg)
+{
+	iowrite32(val, pmx->regs + reg);
+}
+
+/*
+ * Pin control operations
+ */
+
+/* each GPIO pin has it's own pseudo pingroup containing only itself */
+
+static int tz1090_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	return ARRAY_SIZE(tz1090_groups) + NUM_GPIOS;
+}
+
+static const char *tz1090_pinctrl_get_group_name(struct pinctrl_dev *pctldev,
+						 unsigned group)
+{
+	if (group < ARRAY_SIZE(tz1090_groups)) {
+		/* normal pingroup */
+		return tz1090_groups[group].name;
+	} else {
+		/* individual gpio pin pseudo-pingroup */
+		unsigned int pin = group - ARRAY_SIZE(tz1090_groups);
+		return tz1090_pins[pin].name;
+	}
+}
+
+static int tz1090_pinctrl_get_group_pins(struct pinctrl_dev *pctldev,
+					 unsigned group,
+					 const unsigned **pins,
+					 unsigned *num_pins)
+{
+	if (group < ARRAY_SIZE(tz1090_groups)) {
+		/* normal pingroup */
+		*pins = tz1090_groups[group].pins;
+		*num_pins = tz1090_groups[group].npins;
+	} else {
+		/* individual gpio pin pseudo-pingroup */
+		unsigned int pin = group - ARRAY_SIZE(tz1090_groups);
+		*pins = &tz1090_pins[pin].number;
+		*num_pins = 1;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void tz1090_pinctrl_pin_dbg_show(struct pinctrl_dev *pctldev,
+					struct seq_file *s,
+					unsigned offset)
+{
+	seq_printf(s, " %s", dev_name(pctldev->dev));
+}
+#endif
+
+static int reserve_map(struct device *dev, struct pinctrl_map **map,
+		       unsigned *reserved_maps, unsigned *num_maps,
+		       unsigned reserve)
+{
+	unsigned old_num = *reserved_maps;
+	unsigned new_num = *num_maps + reserve;
+	struct pinctrl_map *new_map;
+
+	if (old_num >= new_num)
+		return 0;
+
+	new_map = krealloc(*map, sizeof(*new_map) * new_num, GFP_KERNEL);
+	if (!new_map) {
+		dev_err(dev, "krealloc(map) failed\n");
+		return -ENOMEM;
+	}
+
+	memset(new_map + old_num, 0, (new_num - old_num) * sizeof(*new_map));
+
+	*map = new_map;
+	*reserved_maps = new_num;
+
+	return 0;
+}
+
+static int add_map_mux(struct pinctrl_map **map, unsigned *reserved_maps,
+		       unsigned *num_maps, const char *group,
+		       const char *function)
+{
+	if (WARN_ON(*num_maps == *reserved_maps))
+		return -ENOSPC;
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_MUX_GROUP;
+	(*map)[*num_maps].data.mux.group = group;
+	(*map)[*num_maps].data.mux.function = function;
+	(*num_maps)++;
+
+	return 0;
+}
+
+static int add_map_configs(struct device *dev,
+			   struct pinctrl_map **map,
+			   unsigned *reserved_maps, unsigned *num_maps,
+			   const char *group, unsigned long *configs,
+			   unsigned num_configs)
+{
+	unsigned long *dup_configs;
+
+	if (WARN_ON(*num_maps == *reserved_maps))
+		return -ENOSPC;
+
+	dup_configs = kmemdup(configs, num_configs * sizeof(*dup_configs),
+			      GFP_KERNEL);
+	if (!dup_configs) {
+		dev_err(dev, "kmemdup(configs) failed\n");
+		return -ENOMEM;
+	}
+
+	(*map)[*num_maps].type = PIN_MAP_TYPE_CONFIGS_GROUP;
+	(*map)[*num_maps].data.configs.group_or_pin = group;
+	(*map)[*num_maps].data.configs.configs = dup_configs;
+	(*map)[*num_maps].data.configs.num_configs = num_configs;
+	(*num_maps)++;
+
+	return 0;
+}
+
+static int add_config(struct device *dev, unsigned long **configs,
+		      unsigned *num_configs, unsigned long config)
+{
+	unsigned old_num = *num_configs;
+	unsigned new_num = old_num + 1;
+	unsigned long *new_configs;
+
+	new_configs = krealloc(*configs, sizeof(*new_configs) * new_num,
+			       GFP_KERNEL);
+	if (!new_configs) {
+		dev_err(dev, "krealloc(configs) failed\n");
+		return -ENOMEM;
+	}
+
+	new_configs[old_num] = config;
+
+	*configs = new_configs;
+	*num_configs = new_num;
+
+	return 0;
+}
+
+void tz1090_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
+				struct pinctrl_map *map, unsigned num_maps)
+{
+	int i;
+
+	for (i = 0; i < num_maps; i++)
+		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
+			kfree(map[i].data.configs.configs);
+
+	kfree(map);
+}
+
+static const struct cfg_param {
+	const char *property;
+	enum tz1090_pinconf_param param;
+} cfg_params[] = {
+	{"select",		TZ1090_PINCONF_PARAM_SELECT},
+	{"pull",		TZ1090_PINCONF_PARAM_PULL},
+	{"schmitt",		TZ1090_PINCONF_PARAM_SCHMITT},
+	{"slew-rate",		TZ1090_PINCONF_PARAM_SLEW_RATE},
+	{"drive-strength",	TZ1090_PINCONF_PARAM_DRIVE_STRENGTH},
+};
+
+int tz1090_pinctrl_dt_subnode_to_map(struct device *dev,
+				     struct device_node *np,
+				     struct pinctrl_map **map,
+				     unsigned *reserved_maps,
+				     unsigned *num_maps)
+{
+	int ret, i;
+	const char *function;
+	u32 val;
+	unsigned long config;
+	unsigned long *configs = NULL;
+	unsigned num_configs = 0;
+	unsigned reserve;
+	struct property *prop;
+	const char *group;
+
+	ret = of_property_read_string(np, "function", &function);
+	if (ret < 0) {
+		/* EINVAL=missing, which is fine since it's optional */
+		if (ret != -EINVAL)
+			dev_err(dev, "could not parse property function\n");
+		function = NULL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+		ret = of_property_read_u32(np, cfg_params[i].property, &val);
+		if (!ret) {
+			config = TZ1090_PINCONF_PACK(cfg_params[i].param, val);
+			ret = add_config(dev, &configs, &num_configs, config);
+			if (ret < 0)
+				goto exit;
+		/* EINVAL=missing, which is fine since it's optional */
+		} else if (ret != -EINVAL) {
+			dev_err(dev, "could not parse property %s\n",
+				cfg_params[i].property);
+		}
+	}
+
+	reserve = 0;
+	if (function != NULL)
+		reserve++;
+	if (num_configs)
+		reserve++;
+	ret = of_property_count_strings(np, "pins");
+	if (ret < 0) {
+		dev_err(dev, "could not parse property pins\n");
+		goto exit;
+	}
+	reserve *= ret;
+
+	ret = reserve_map(dev, map, reserved_maps, num_maps, reserve);
+	if (ret < 0)
+		goto exit;
+
+	of_property_for_each_string(np, "pins", prop, group) {
+		if (function) {
+			ret = add_map_mux(map, reserved_maps, num_maps,
+					  group, function);
+			if (ret < 0)
+				goto exit;
+		}
+
+		if (num_configs) {
+			ret = add_map_configs(dev, map, reserved_maps,
+					      num_maps, group, configs,
+					      num_configs);
+			if (ret < 0)
+				goto exit;
+		}
+	}
+
+	ret = 0;
+
+exit:
+	kfree(configs);
+	return ret;
+}
+
+int tz1090_pinctrl_dt_node_to_map(struct pinctrl_dev *pctldev,
+				  struct device_node *np_config,
+				  struct pinctrl_map **map, unsigned *num_maps)
+{
+	unsigned reserved_maps;
+	struct device_node *np;
+	int ret;
+
+	reserved_maps = 0;
+	*map = NULL;
+	*num_maps = 0;
+
+	for_each_child_of_node(np_config, np) {
+		ret = tz1090_pinctrl_dt_subnode_to_map(pctldev->dev, np, map,
+						       &reserved_maps,
+						       num_maps);
+		if (ret < 0) {
+			tz1090_pinctrl_dt_free_map(pctldev, *map, *num_maps);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct pinctrl_ops tz1090_pinctrl_ops = {
+	.get_groups_count	= tz1090_pinctrl_get_groups_count,
+	.get_group_name		= tz1090_pinctrl_get_group_name,
+	.get_group_pins		= tz1090_pinctrl_get_group_pins,
+#ifdef CONFIG_DEBUG_FS
+	.pin_dbg_show		= tz1090_pinctrl_pin_dbg_show,
+#endif
+	.dt_node_to_map		= tz1090_pinctrl_dt_node_to_map,
+	.dt_free_map		= tz1090_pinctrl_dt_free_map,
+};
+
+/*
+ * Pin mux operations
+ */
+
+static int tz1090_pinctrl_get_funcs_count(struct pinctrl_dev *pctldev)
+{
+	return ARRAY_SIZE(tz1090_functions);
+}
+
+static const char *tz1090_pinctrl_get_func_name(struct pinctrl_dev *pctldev,
+						unsigned function)
+{
+	return tz1090_functions[function].name;
+}
+
+static int tz1090_pinctrl_get_func_groups(struct pinctrl_dev *pctldev,
+					  unsigned function,
+					  const char * const **groups,
+					  unsigned * const num_groups)
+{
+	*groups = tz1090_functions[function].groups;
+	*num_groups = tz1090_functions[function].ngroups;
+
+	return 0;
+}
+
+/**
+ * tz1090_pinctrl_select() - update bit in SELECT register
+ * @pmx:		Pinmux data
+ * @pin:		Pin number (must be within GPIO range)
+ */
+static void tz1090_pinctrl_select(struct tz1090_pmx *pmx,
+				  unsigned int pin)
+{
+	u32 reg, reg_shift, select, val;
+	unsigned int pmx_index, pmx_shift;
+	unsigned long flags;
+
+	/* uses base 32 instead of base 30 */
+	pmx_index = pin >> 5;
+	pmx_shift = pin & 0x1f;
+
+	/* select = !serial || gpio || force */
+	select = ((~pmx->pin_en[pmx_index] |
+		   pmx->gpio_en[pmx_index] |
+		   pmx->select_en[pmx_index]) >> pmx_shift) & 1;
+
+	/* find register and bit offset (base 30) */
+	reg = REG_PINCTRL_SELECT + 4*(pin / 30);
+	reg_shift = pin % 30;
+
+	/* modify gpio select bit */
+	__global_lock2(flags);
+	val = pmx_read(pmx, reg);
+	val &= ~(1 << reg_shift);
+	val |= select << reg_shift;
+	pmx_write(pmx, val, reg);
+	__global_unlock2(flags);
+}
+
+/**
+ * tz1090_pinctrl_gpio_select() - enable/disable GPIO usage for a pin
+ * @pmx:		Pinmux data
+ * @pin:		Pin number
+ * @gpio_select:	1 to enable pin as GPIO,
+ *			0 to leave control to whatever function is enabled
+ *
+ * Records that GPIO usage is enabled/disabled so that enabling a function
+ * doesn't override the SELECT register bit.
+ */
+static void tz1090_pinctrl_gpio_select(struct tz1090_pmx *pmx,
+				       unsigned int pin,
+				       unsigned int gpio_select)
+{
+	unsigned int index, shift;
+	u32 gpio_en;
+
+	if (pin >= NUM_GPIOS)
+		return;
+
+	/* uses base 32 instead of base 30 */
+	index = pin >> 5;
+	shift = pin & 0x1f;
+
+	spin_lock(&pmx->lock);
+
+	/* keep a record whether gpio is selected */
+	gpio_en = pmx->gpio_en[index];
+	gpio_en &= ~(1 << shift);
+	gpio_en |= (gpio_select << shift);
+	pmx->gpio_en[index] = gpio_en;
+
+	/* update the select bit */
+	tz1090_pinctrl_select(pmx, pin);
+
+	spin_unlock(&pmx->lock);
+}
+
+/**
+ * tz1090_pinctrl_serial_select() - enable/disable serial interface for a pin
+ * @pmx:		Pinmux data
+ * @pin:		Pin number
+ * @gpio_select:	1 to enable serial interface (devices) when not GPIO,
+ *			0 to leave pin in GPIO mode
+ *
+ * Records that serial usage is enabled/disabled so that SELECT register can be
+ * set appropriately when GPIO is disabled.
+ */
+static void tz1090_pinctrl_serial_select(struct tz1090_pmx *pmx,
+					 unsigned int pin,
+					 unsigned int serial_select)
+{
+	unsigned int index, shift;
+	u32 pin_en;
+
+	if (pin >= NUM_GPIOS)
+		return;
+
+	/* uses base 32 instead of base 30 */
+	index = pin >> 5;
+	shift = pin & 0x1f;
+
+	spin_lock(&pmx->lock);
+
+	/* keep a record whether serial is selected */
+	pin_en = pmx->pin_en[index];
+	pin_en &= ~(1 << shift);
+	pin_en |= (serial_select << shift);
+	pmx->pin_en[index] = pin_en;
+
+	/* update the select bit */
+	tz1090_pinctrl_select(pmx, pin);
+
+	spin_unlock(&pmx->lock);
+}
+
+/**
+ * tz1090_pinctrl_force_select() - enable/disable force gpio select for a pin
+ * @pmx:		Pinmux data
+ * @pin:		Pin number
+ * @gpio_select:	1 to force GPIO select,
+ *			0 to unforce GPIO select
+ *
+ * Records that the GPIO is force selected and serial interface shouldn't be
+ * enabled.
+ */
+static void tz1090_pinctrl_force_select(struct tz1090_pmx *pmx,
+					unsigned int pin,
+					unsigned int force_select)
+{
+	unsigned int index, shift;
+	u32 select_en;
+
+	if (pin >= NUM_GPIOS)
+		return;
+
+	/* uses base 32 instead of base 30 */
+	index = pin >> 5;
+	shift = pin & 0x1f;
+
+	spin_lock(&pmx->lock);
+
+	/* keep a record whether serial is selected */
+	select_en = pmx->select_en[index];
+	select_en &= ~(1 << shift);
+	select_en |= (force_select << shift);
+	pmx->select_en[index] = select_en;
+
+	/* update the select bit */
+	tz1090_pinctrl_select(pmx, pin);
+
+	spin_unlock(&pmx->lock);
+}
+
+static int tz1090_pinctrl_enable_mux(struct tz1090_pmx *pmx,
+				     const struct tz1090_muxdesc *desc,
+				     unsigned int function)
+{
+	const int *fit;
+	unsigned long flags;
+	int mux;
+	unsigned int func, ret;
+	u32 reg, mask;
+
+	/* find the mux value for this function, searching recursively */
+	for (mux = 0, fit = desc->funcs;
+	     mux < ARRAY_SIZE(desc->funcs); ++mux, ++fit) {
+		func = *fit;
+		if (func == function)
+			goto found_mux;
+
+		/* maybe it's a sub-mux */
+		if (func < ARRAY_SIZE(tz1090_submux) && tz1090_submux[func]) {
+			ret = tz1090_pinctrl_enable_mux(pmx,
+							tz1090_submux[func],
+							function);
+			if (!ret)
+				goto found_mux;
+		}
+	}
+
+	return -EINVAL;
+found_mux:
+
+	/* Set up the mux */
+	if (desc->width) {
+		mask = ((1 << desc->width) - 1) << desc->bit;
+		__global_lock2(flags);
+		reg = pmx_read(pmx, desc->reg);
+		reg &= ~mask;
+		reg |= (mux << desc->bit) & mask;
+		pmx_write(pmx, reg, desc->reg);
+		__global_unlock2(flags);
+	}
+
+	return 0;
+}
+
+static int tz1090_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
+				 unsigned group)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pingroup *grp;
+	int ret;
+	const unsigned int *pit;
+	unsigned int i, pin;
+
+	if (group >= ARRAY_SIZE(tz1090_groups)) {
+		pin = group - ARRAY_SIZE(tz1090_groups);
+		dev_dbg(pctldev->dev, "%s(func=%u (%s), pin=%u (%s))\n",
+			__func__,
+			function, tz1090_functions[function].name,
+			pin,
+			tz1090_pins[pin].name);
+
+		/* no muxing necessary */
+		if (function != TZ1090_MUX_DEFAULT)
+			return -EINVAL;
+		tz1090_pinctrl_serial_select(pmx, pin, 1);
+		return 0;
+	}
+
+	grp = &tz1090_groups[group];
+	dev_dbg(pctldev->dev, "%s(func=%u (%s), group=%u (%s))\n",
+		__func__,
+		function, tz1090_functions[function].name,
+		group, grp->name);
+
+	ret = tz1090_pinctrl_enable_mux(pmx, &grp->mux, function);
+	if (ret)
+		return ret;
+
+	/* set up each pin in group to serial interface */
+	for (i = 0, pit = grp->pins; i < grp->npins; ++i, ++pit)
+		tz1090_pinctrl_serial_select(pmx, *pit, 1);
+
+	return 0;
+}
+
+static void tz1090_pinctrl_disable(struct pinctrl_dev *pctldev,
+				   unsigned function, unsigned group)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pingroup *grp;
+	const unsigned int *pit;
+	unsigned int i, pin;
+
+	if (group >= ARRAY_SIZE(tz1090_groups)) {
+		pin = group - ARRAY_SIZE(tz1090_groups);
+		dev_dbg(pctldev->dev, "%s(func=%u (%s), pin=%u (%s))\n",
+			__func__,
+			function, tz1090_functions[function].name,
+			pin,
+			tz1090_pins[pin].name);
+
+		tz1090_pinctrl_serial_select(pmx, pin, 0);
+		return;
+	}
+
+	grp = &tz1090_groups[group];
+	dev_dbg(pctldev->dev, "%s(func=%u (%s), group=%u (%s))\n",
+		__func__,
+		function, tz1090_functions[function].name,
+		group, grp->name);
+
+	/* set up each pin in group to serial interface */
+	for (i = 0, pit = grp->pins; i < grp->npins; ++i, ++pit)
+		tz1090_pinctrl_serial_select(pmx, *pit, 0);
+}
+
+static int tz1090_pinctrl_gpio_request_enable(struct pinctrl_dev *pctldev,
+					      struct pinctrl_gpio_range *range,
+					      unsigned int pin)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	tz1090_pinctrl_gpio_select(pmx, pin, 1);
+	return 0;
+}
+
+static void tz1090_pinctrl_gpio_disable_free(struct pinctrl_dev *pctldev,
+					     struct pinctrl_gpio_range *range,
+					     unsigned int pin)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	tz1090_pinctrl_gpio_select(pmx, pin, 0);
+}
+
+static struct pinmux_ops tz1090_pinmux_ops = {
+	.get_functions_count	= tz1090_pinctrl_get_funcs_count,
+	.get_function_name	= tz1090_pinctrl_get_func_name,
+	.get_function_groups	= tz1090_pinctrl_get_func_groups,
+	.enable			= tz1090_pinctrl_enable,
+	.disable		= tz1090_pinctrl_disable,
+	.gpio_request_enable	= tz1090_pinctrl_gpio_request_enable,
+	.gpio_disable_free	= tz1090_pinctrl_gpio_disable_free,
+};
+
+/*
+ * Pin config operations
+ */
+
+struct tz1090_pinconf_pullup {
+	unsigned char index;
+	unsigned char shift;
+};
+
+/* The mapping of pin to pull up/down register index and shift */
+static struct tz1090_pinconf_pullup tz1090_pinconf_pullup[] = {
+	{5, 22}, /*  0 - TZ1090_PIN_SDIO_CLK */
+	{0, 14}, /*  1 - TZ1090_PIN_SDIO_CMD */
+	{0,  6}, /*  2 - TZ1090_PIN_SDIO_D0 */
+	{0,  8}, /*  3 - TZ1090_PIN_SDIO_D1 */
+	{0, 10}, /*  4 - TZ1090_PIN_SDIO_D2 */
+	{0, 12}, /*  5 - TZ1090_PIN_SDIO_D3 */
+	{0,  2}, /*  6 - TZ1090_PIN_SDH_CD */
+	{0,  4}, /*  7 - TZ1090_PIN_SDH_WP */
+	{0, 16}, /*  8 - TZ1090_PIN_SPI0_MCLK */
+	{0, 18}, /*  9 - TZ1090_PIN_SPI0_CS0 */
+	{0, 20}, /* 10 - TZ1090_PIN_SPI0_CS1 */
+	{0, 22}, /* 11 - TZ1090_PIN_SPI0_CS2 */
+	{0, 24}, /* 12 - TZ1090_PIN_SPI0_DOUT */
+	{0, 26}, /* 13 - TZ1090_PIN_SPI0_DIN */
+	{0, 28}, /* 14 - TZ1090_PIN_SPI1_MCLK */
+	{0, 30}, /* 15 - TZ1090_PIN_SPI1_CS0 */
+	{1,  0}, /* 16 - TZ1090_PIN_SPI1_CS1 */
+	{1,  2}, /* 17 - TZ1090_PIN_SPI1_CS2 */
+	{1,  4}, /* 18 - TZ1090_PIN_SPI1_DOUT */
+	{1,  6}, /* 19 - TZ1090_PIN_SPI1_DIN */
+	{1,  8}, /* 20 - TZ1090_PIN_UART0_RXD */
+	{1, 10}, /* 21 - TZ1090_PIN_UART0_TXD */
+	{1, 12}, /* 22 - TZ1090_PIN_UART0_CTS */
+	{1, 14}, /* 23 - TZ1090_PIN_UART0_RTS */
+	{1, 16}, /* 24 - TZ1090_PIN_UART1_RXD */
+	{1, 18}, /* 25 - TZ1090_PIN_UART1_TXD */
+	{1, 20}, /* 26 - TZ1090_PIN_SCB0_SDAT */
+	{1, 22}, /* 27 - TZ1090_PIN_SCB0_SCLK */
+	{1, 24}, /* 28 - TZ1090_PIN_SCB1_SDAT */
+	{1, 26}, /* 29 - TZ1090_PIN_SCB1_SCLK */
+
+	{1, 28}, /* 30 - TZ1090_PIN_SCB2_SDAT */
+	{1, 29}, /* 31 - TZ1090_PIN_SCB2_SCLK */
+	{2,  0}, /* 32 - TZ1090_PIN_I2S_MCLK */
+	{2,  2}, /* 33 - TZ1090_PIN_I2S_BCLK_OUT */
+	{2,  4}, /* 34 - TZ1090_PIN_I2S_LRCLK_OUT */
+	{2,  6}, /* 35 - TZ1090_PIN_I2S_DOUT0 */
+	{2,  8}, /* 36 - TZ1090_PIN_I2S_DOUT1 */
+	{2, 10}, /* 37 - TZ1090_PIN_I2S_DOUT2 */
+	{2, 12}, /* 38 - TZ1090_PIN_I2S_DIN */
+	{4, 12}, /* 39 - TZ1090_PIN_PDM_A */
+	{4, 14}, /* 40 - TZ1090_PIN_PDM_B */
+	{4, 18}, /* 41 - TZ1090_PIN_PDM_C */
+	{4, 20}, /* 42 - TZ1090_PIN_PDM_D */
+	{2, 14}, /* 43 - TZ1090_PIN_TFT_RED0 */
+	{2, 16}, /* 44 - TZ1090_PIN_TFT_RED1 */
+	{2, 18}, /* 45 - TZ1090_PIN_TFT_RED2 */
+	{2, 20}, /* 46 - TZ1090_PIN_TFT_RED3 */
+	{2, 22}, /* 47 - TZ1090_PIN_TFT_RED4 */
+	{2, 24}, /* 48 - TZ1090_PIN_TFT_RED5 */
+	{2, 26}, /* 49 - TZ1090_PIN_TFT_RED6 */
+	{2, 28}, /* 50 - TZ1090_PIN_TFT_RED7 */
+	{2, 30}, /* 51 - TZ1090_PIN_TFT_GREEN0 */
+	{3,  0}, /* 52 - TZ1090_PIN_TFT_GREEN1 */
+	{3,  2}, /* 53 - TZ1090_PIN_TFT_GREEN2 */
+	{3,  4}, /* 54 - TZ1090_PIN_TFT_GREEN3 */
+	{3,  6}, /* 55 - TZ1090_PIN_TFT_GREEN4 */
+	{3,  8}, /* 56 - TZ1090_PIN_TFT_GREEN5 */
+	{3, 10}, /* 57 - TZ1090_PIN_TFT_GREEN6 */
+	{3, 12}, /* 58 - TZ1090_PIN_TFT_GREEN7 */
+	{3, 14}, /* 59 - TZ1090_PIN_TFT_BLUE0 */
+
+	{3, 16}, /* 60 - TZ1090_PIN_TFT_BLUE1 */
+	{3, 18}, /* 61 - TZ1090_PIN_TFT_BLUE2 */
+	{3, 20}, /* 62 - TZ1090_PIN_TFT_BLUE3 */
+	{3, 22}, /* 63 - TZ1090_PIN_TFT_BLUE4 */
+	{3, 24}, /* 64 - TZ1090_PIN_TFT_BLUE5 */
+	{3, 26}, /* 65 - TZ1090_PIN_TFT_BLUE6 */
+	{3, 28}, /* 66 - TZ1090_PIN_TFT_BLUE7 */
+	{3, 30}, /* 67 - TZ1090_PIN_TFT_VDDEN_GD */
+	{4,  0}, /* 68 - TZ1090_PIN_TFT_PANELCLK */
+	{4,  2}, /* 69 - TZ1090_PIN_TFT_BLANK_LS */
+	{4,  4}, /* 70 - TZ1090_PIN_TFT_VSYNC_NS */
+	{4,  6}, /* 71 - TZ1090_PIN_TFT_HSYNC_NR */
+	{4,  8}, /* 72 - TZ1090_PIN_TFT_VD12ACB */
+	{4, 10}, /* 73 - TZ1090_PIN_TFT_PWRSAVE */
+	{4, 24}, /* 74 - TZ1090_PIN_TX_ON */
+	{4, 26}, /* 75 - TZ1090_PIN_RX_ON */
+	{4, 28}, /* 76 - TZ1090_PIN_PLL_ON */
+	{4, 30}, /* 77 - TZ1090_PIN_PA_ON */
+	{5,  0}, /* 78 - TZ1090_PIN_RX_HP */
+	{5,  6}, /* 79 - TZ1090_PIN_GAIN0 */
+	{5,  8}, /* 80 - TZ1090_PIN_GAIN1 */
+	{5, 10}, /* 81 - TZ1090_PIN_GAIN2 */
+	{5, 12}, /* 82 - TZ1090_PIN_GAIN3 */
+	{5, 14}, /* 83 - TZ1090_PIN_GAIN4 */
+	{5, 16}, /* 84 - TZ1090_PIN_GAIN5 */
+	{5, 18}, /* 85 - TZ1090_PIN_GAIN6 */
+	{5, 20}, /* 86 - TZ1090_PIN_GAIN7 */
+	{5,  2}, /* 87 - TZ1090_PIN_ANT_SEL0 */
+	{5,  4}, /* 88 - TZ1090_PIN_ANT_SEL1 */
+	{0,  0}, /* 89 - TZ1090_PIN_SDH_CLK_IN */
+};
+
+static int tz1090_pinconf_reg(struct pinctrl_dev *pctldev,
+			      unsigned int pin,
+			      enum tz1090_pinconf_param param,
+			      bool report_err,
+			      u32 *reg, u32 *width, u32 *mask, u32 *shift)
+{
+	struct tz1090_pinconf_pullup *pu;
+
+	/* Only core GPIO'able pins */
+	if (pin >= NUM_GPIOS)
+		return -EINVAL;
+
+	/* Find information about parameter's register */
+	switch (param) {
+	case TZ1090_PINCONF_PARAM_SELECT:
+		*reg = REG_PINCTRL_SELECT + 4*(pin / 30);
+		*shift = pin % 30;
+		*width = 1;
+		break;
+	case TZ1090_PINCONF_PARAM_PULL:
+		pu = &tz1090_pinconf_pullup[pin];
+		*reg = REG_PINCTRL_PU_PD + 4*pu->index;
+		*shift = pu->shift;
+		*width = 2;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	/* Calculate field information */
+	*mask = ((1 << *width) - 1) << *shift;
+
+	return 0;
+}
+
+static int tz1090_pinconf_get(struct pinctrl_dev *pctldev,
+			      unsigned pin, unsigned long *config)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	enum tz1090_pinconf_param param = TZ1090_PINCONF_UNPACK_PARAM(*config);
+	int ret;
+	u32 reg, width, mask, shift, val, arg;
+
+	/* Get register information */
+	ret = tz1090_pinconf_reg(pctldev, pin, param, true,
+				 &reg, &width, &mask, &shift);
+	if (ret < 0)
+		return ret;
+
+	/* Extract field from register */
+	val = pmx_read(pmx, reg);
+	arg = (val & mask) >> shift;
+
+	/* And pack config */
+	*config = TZ1090_PINCONF_PACK(param, arg);
+
+	return 0;
+}
+
+static int tz1090_pinconf_set(struct pinctrl_dev *pctldev,
+			      unsigned pin, unsigned long config)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	enum tz1090_pinconf_param param = TZ1090_PINCONF_UNPACK_PARAM(config);
+	unsigned int arg = TZ1090_PINCONF_UNPACK_ARG(config);
+	int ret;
+	u32 reg, width, mask, shift, val;
+	unsigned long flags;
+
+	dev_dbg(pctldev->dev, "%s(pin=%s, config=%#lx)\n",
+		__func__, tz1090_pins[pin].name, config);
+
+	/* Select is a special case for writing */
+	if (param == TZ1090_PINCONF_PARAM_SELECT) {
+		if (arg > 1) {
+			dev_dbg(pctldev->dev, "%s: select larger than 1\n",
+				__func__);
+			return -EINVAL;
+		}
+		tz1090_pinctrl_force_select(pmx, pin, arg);
+		return 0;
+	}
+
+	/* Get register information */
+	ret = tz1090_pinconf_reg(pctldev, pin, param, true,
+				 &reg, &width, &mask, &shift);
+	if (ret < 0)
+		return ret;
+
+	/* Unpack argument and range check it */
+	if (arg >= (1 << width)) {
+		dev_dbg(pctldev->dev, "%s: arg %u larger than %u bits\n",
+			__func__, arg, width);
+		return -EINVAL;
+	}
+
+	/* Write register field */
+	__global_lock2(flags);
+	val = pmx_read(pmx, reg);
+	val &= ~mask;
+	val |= arg << shift;
+	pmx_write(pmx, val, reg);
+	__global_unlock2(flags);
+
+	return 0;
+}
+
+static int tz1090_pinconf_group_reg(struct pinctrl_dev *pctldev,
+				    const struct tz1090_pingroup *g,
+				    enum tz1090_pinconf_param param,
+				    bool report_err,
+				    u32 *reg, u32 *width, u32 *mask, u32 *shift)
+{
+	/* Drive configuration applies in groups, but not to all groups. */
+	if (!g->drv) {
+		if (report_err)
+			dev_dbg(pctldev->dev,
+				"%s: group %s has no drive control\n",
+				__func__, g->name);
+		return -EINVAL;
+	}
+
+	/* Find information about drive parameter's register */
+	switch (param) {
+	case TZ1090_PINCONF_PARAM_SCHMITT:
+		*reg = REG_PINCTRL_SCHMITT;
+		*width = 1;
+		break;
+	case TZ1090_PINCONF_PARAM_SLEW_RATE:
+		*reg = REG_PINCTRL_SR;
+		*width = 1;
+		break;
+	case TZ1090_PINCONF_PARAM_DRIVE_STRENGTH:
+		*reg = REG_PINCTRL_DR;
+		*width = 2;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	/* Calculate field information */
+	*shift = g->slw_bit * *width;
+	*mask = ((1 << *width) - 1) << *shift;
+
+	return 0;
+}
+
+static int tz1090_pinconf_group_get(struct pinctrl_dev *pctldev,
+				    unsigned group,
+				    unsigned long *config)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pingroup *g;
+	enum tz1090_pinconf_param param = TZ1090_PINCONF_UNPACK_PARAM(*config);
+	int ret;
+	unsigned int pin;
+	u32 reg, width, mask, shift, val, arg;
+
+	if (group >= ARRAY_SIZE(tz1090_groups)) {
+		pin = group - ARRAY_SIZE(tz1090_groups);
+		return tz1090_pinconf_get(pctldev, pin, config);
+	}
+
+	g = &tz1090_groups[group];
+
+	/* We can't really get a per-pin configuration of a group. */
+	if (param < TZ1090_PINCONF_PARAM_GROUPED) {
+		dev_dbg(pctldev->dev,
+			"%s: Can't get per-pin param %u of group %s\n",
+			__func__, param, g->name);
+		return -EINVAL;
+	}
+
+	/* Get register information */
+	ret = tz1090_pinconf_group_reg(pctldev, g, param, true,
+				       &reg, &width, &mask, &shift);
+	if (ret < 0)
+		return ret;
+
+	/* Extract field from register */
+	val = pmx_read(pmx, reg);
+	arg = (val & mask) >> shift;
+
+	/* And pack config */
+	*config = TZ1090_PINCONF_PACK(param, arg);
+
+	return 0;
+}
+
+static int tz1090_pinconf_group_set(struct pinctrl_dev *pctldev,
+				    unsigned group, unsigned long config)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pingroup *g;
+	enum tz1090_pinconf_param param = TZ1090_PINCONF_UNPACK_PARAM(config);
+	unsigned int arg, pin, i;
+	const unsigned int *pit;
+	int ret;
+	u32 reg, width, mask, shift, val;
+	unsigned long flags;
+
+	if (group >= ARRAY_SIZE(tz1090_groups)) {
+		pin = group - ARRAY_SIZE(tz1090_groups);
+		return tz1090_pinconf_set(pctldev, pin, config);
+	}
+
+	g = &tz1090_groups[group];
+	dev_dbg(pctldev->dev, "%s(group=%s, config=%#lx)\n",
+		__func__, g->name, config);
+
+	/*
+	 * If we're trying to set a per-pin configuration of a group, do the
+	 * pins one by one. This is mainly as a convenience.
+	 */
+	if (param < TZ1090_PINCONF_PARAM_GROUPED) {
+		for (i = 0, pit = g->pins; i < g->npins; ++i, ++pit) {
+			ret = tz1090_pinconf_set(pctldev, *pit, config);
+			if (ret)
+				return ret;
+		}
+		return 0;
+	}
+
+	/* Get register information */
+	ret = tz1090_pinconf_group_reg(pctldev, g, param, true,
+				       &reg, &width, &mask, &shift);
+	if (ret < 0)
+		return ret;
+
+	/* Unpack argument and range check it */
+	arg = TZ1090_PINCONF_UNPACK_ARG(config);
+	if (arg >= (1 << width)) {
+		dev_dbg(pctldev->dev, "%s: arg %u larger than %u bits\n",
+			__func__, arg, width);
+		return -EINVAL;
+	}
+
+	/* Write register field */
+	__global_lock2(flags);
+	val = pmx_read(pmx, reg);
+	val &= ~mask;
+	val |= arg << shift;
+	pmx_write(pmx, val, reg);
+	__global_unlock2(flags);
+
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void tz1090_pinconf_dbg_show(struct pinctrl_dev *pctldev,
+				    struct seq_file *s, unsigned pin)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	int i, ret;
+	u32 reg, width, mask, shift, val;
+
+	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+		/* Get register information */
+		ret = tz1090_pinconf_reg(pctldev, pin, cfg_params[i].param,
+					 false, &reg, &width, &mask, &shift);
+		if (ret < 0)
+			continue;
+
+		/* Extract field from register */
+		val = pmx_read(pmx, reg);
+		val = (val & mask) >> shift;
+
+		seq_printf(s, "\n\t%s=%u",
+			   cfg_params[i].property, val);
+	}
+}
+
+static const char *strip_prefix(const char *s)
+{
+	const char *comma = strchr(s, ',');
+	if (!comma)
+		return s;
+
+	return comma + 1;
+}
+
+static void tz1090_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
+					  struct seq_file *s, unsigned group)
+{
+	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
+	const struct tz1090_pingroup *g;
+	int i, ret;
+	u32 reg, width, mask, shift, val;
+
+	/* don't show pin configs in group dbg */
+	if (group >= ARRAY_SIZE(tz1090_groups))
+		return;
+
+	g = &tz1090_groups[group];
+	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+		/* Get register information */
+		ret = tz1090_pinconf_group_reg(pctldev, g, cfg_params[i].param,
+					       false, &reg, &width, &mask,
+					       &shift);
+		if (ret < 0)
+			continue;
+
+		/* Extract field from register */
+		val = pmx_read(pmx, reg);
+		val = (val & mask) >> shift;
+
+		seq_printf(s, "\n\t%s=%u",
+			   strip_prefix(cfg_params[i].property), val);
+	}
+}
+
+static void tz1090_pinconf_config_dbg_show(struct pinctrl_dev *pctldev,
+					   struct seq_file *s,
+					   unsigned long config)
+{
+	enum tz1090_pinconf_param param = TZ1090_PINCONF_UNPACK_PARAM(config);
+	u16 arg = TZ1090_PINCONF_UNPACK_ARG(config);
+	const char *pname = "unknown";
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cfg_params); i++) {
+		if (cfg_params[i].param == param) {
+			pname = cfg_params[i].property;
+			break;
+		}
+	}
+
+	seq_printf(s, "%s=%d", strip_prefix(pname), arg);
+}
+#endif
+
+struct pinconf_ops tz1090_pinconf_ops = {
+	.pin_config_get		= tz1090_pinconf_get,
+	.pin_config_set		= tz1090_pinconf_set,
+	.pin_config_group_get	= tz1090_pinconf_group_get,
+	.pin_config_group_set	= tz1090_pinconf_group_set,
+#ifdef CONFIG_DEBUG_FS
+	.pin_config_dbg_show		= tz1090_pinconf_dbg_show,
+	.pin_config_group_dbg_show	= tz1090_pinconf_group_dbg_show,
+	.pin_config_config_dbg_show	= tz1090_pinconf_config_dbg_show,
+#endif
+};
+
+/*
+ * Pin control driver setup
+ */
+
+static struct pinctrl_desc tz1090_pinctrl_desc = {
+	.pctlops	= &tz1090_pinctrl_ops,
+	.pmxops		= &tz1090_pinmux_ops,
+	.confops	= &tz1090_pinconf_ops,
+	.owner		= THIS_MODULE,
+};
+
+static struct pinctrl_gpio_range tz1090_pinctrl_gpio_range = {
+	.name		= "TZ1090 GPIOs",
+	.base		= GPIO_0_BASE,
+	.npins		= NUM_GPIOS,
+};
+
+static int tz1090_pinctrl_probe(struct platform_device *pdev)
+{
+	struct tz1090_pmx *pmx;
+	struct resource *res;
+
+	pmx = devm_kzalloc(&pdev->dev, sizeof(*pmx), GFP_KERNEL);
+	if (!pmx) {
+		dev_err(&pdev->dev, "Can't alloc tz1090_pmx\n");
+		return -ENOMEM;
+	}
+	pmx->dev = &pdev->dev;
+	spin_lock_init(&pmx->lock);
+
+	tz1090_pinctrl_desc.name = dev_name(&pdev->dev);
+	tz1090_pinctrl_desc.pins = tz1090_pins;
+	tz1090_pinctrl_desc.npins = ARRAY_SIZE(tz1090_pins);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "Missing MEM resource\n");
+		return -ENODEV;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+				     resource_size(res),
+				     dev_name(&pdev->dev))) {
+		dev_err(&pdev->dev,
+			"Couldn't request MEM resource\n");
+		return -ENODEV;
+	}
+
+	pmx->regs = devm_ioremap(&pdev->dev, res->start,
+				 resource_size(res));
+	if (!pmx->regs) {
+		dev_err(&pdev->dev, "Couldn't ioremap regs\n");
+		return -ENODEV;
+	}
+
+	pmx->pctl = pinctrl_register(&tz1090_pinctrl_desc, &pdev->dev, pmx);
+	if (!pmx->pctl) {
+		dev_err(&pdev->dev, "Couldn't register pinctrl driver\n");
+		return -ENODEV;
+	}
+
+	pinctrl_add_gpio_range(pmx->pctl, &tz1090_pinctrl_gpio_range);
+
+	platform_set_drvdata(pdev, pmx);
+
+	dev_info(&pdev->dev, "TZ1090 pinctrl driver initialised\n");
+
+	return 0;
+}
+
+static int tz1090_pinctrl_remove(struct platform_device *pdev)
+{
+	struct tz1090_pmx *pmx = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(pmx->pctl);
+
+	return 0;
+}
+
+static struct of_device_id tz1090_pinctrl_of_match[] = {
+	{ .compatible = "img,tz1090-pinctrl", },
+	{ },
+};
+
+static struct platform_driver tz1090_pinctrl_driver = {
+	.driver = {
+		.name		= "tz1090-pinctrl",
+		.owner		= THIS_MODULE,
+		.of_match_table	= tz1090_pinctrl_of_match,
+	},
+	.probe	= tz1090_pinctrl_probe,
+	.remove	= tz1090_pinctrl_remove,
+};
+
+static int __init tz1090_pinctrl_init(void)
+{
+	return platform_driver_register(&tz1090_pinctrl_driver);
+}
+postcore_initcall(tz1090_pinctrl_init);
+
+static void __exit tz1090_pinctrl_exit(void)
+{
+	platform_driver_unregister(&tz1090_pinctrl_driver);
+}
+module_exit(tz1090_pinctrl_exit);
+
+MODULE_AUTHOR("Imagination Technologies Ltd.");
+MODULE_DESCRIPTION("Toumaz Xenif TZ1090 pinctrl driver");
+MODULE_LICENSE("GPL v2");
+MODULE_DEVICE_TABLE(of, tz1090_pinctrl_of_match);
diff --git a/drivers/pinctrl/pinctrl-tz1090.h b/drivers/pinctrl/pinctrl-tz1090.h
new file mode 100644
index 0000000..b2553b0
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-tz1090.h
@@ -0,0 +1,58 @@
+#ifndef __PINCTRL_TZ1090_H__
+#define __PINCTRL_TZ1090_H__
+
+enum tz1090_pinconf_param {
+	/* per-gpio parameters */
+	TZ1090_PINCONF_PARAM_PERGPIO = 0,
+
+	/* argument: tz1090_pinconf_select */
+	TZ1090_PINCONF_PARAM_SELECT,
+	/* argument: tz1090_pinconf_pull */
+	TZ1090_PINCONF_PARAM_PULL,
+
+
+	/* grouped drive parameters */
+	TZ1090_PINCONF_PARAM_GROUPED,
+
+	/* argument: tz1090_pinconf_schmitt */
+	TZ1090_PINCONF_PARAM_SCHMITT,
+	/* argument: tz1090_pinconf_slew */
+	TZ1090_PINCONF_PARAM_SLEW_RATE,
+	/* argument: tz1090_pinconf_drive */
+	TZ1090_PINCONF_PARAM_DRIVE_STRENGTH,
+};
+
+enum tz1090_pinconf_select {
+	TZ1090_PINCONF_SELECT_SERIAL,
+	TZ1090_PINCONF_SELECT_GPIO,
+};
+
+enum tz1090_pinconf_pull {
+	TZ1090_PINCONF_PULL_TRISTATE,
+	TZ1090_PINCONF_PULL_UP,
+	TZ1090_PINCONF_PULL_DOWN,
+	TZ1090_PINCONF_PULL_REPEATER,
+};
+
+enum tz1090_pinconf_schmitt {
+	TZ1090_PINCONF_SCHMITT_OFF,	/* no hysteresis */
+	TZ1090_PINCONF_SCHMITT_ON,	/* schmitt trigger */
+};
+
+enum tz1090_pinconf_slew {
+	TZ1090_PINCONF_SLEW_SLOW,	/* half frequency */
+	TZ1090_PINCONF_SLEW_FAST,
+};
+
+enum tz1090_pinconf_drive {
+	TZ1090_PINCONF_DRIVE_2mA,
+	TZ1090_PINCONF_DRIVE_4mA,
+	TZ1090_PINCONF_DRIVE_8mA,
+	TZ1090_PINCONF_DRIVE_12mA,
+};
+
+#define TZ1090_PINCONF_PACK(_param_, _arg_)	((_param_) << 16 | (_arg_))
+#define TZ1090_PINCONF_UNPACK_PARAM(_conf_)	((_conf_) >> 16)
+#define TZ1090_PINCONF_UNPACK_ARG(_conf_)	((_conf_) & 0xffff)
+
+#endif /* __PINCTRL_TZ1090_H__ */
-- 
1.8.1.2


