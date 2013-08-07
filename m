Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3HGKWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:22:33 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56264 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab3HGKWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:22:30 -0400
Date: Wed, 7 Aug 2013 12:22:04 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 26/26] pinctrl: add support for sta2x11 (via
 pinctrl-nomadik)
Message-ID: <b719237403781b77732bb59078ca6f1eb3d76639.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 .../devicetree/bindings/pinctrl/ste,nomadik.txt    |    2 +-
 drivers/pinctrl/Kconfig                            |    6 +-
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-nomadik-sta2x11.c          |  578 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-nomadik.c                  |    7 +
 drivers/pinctrl/pinctrl-nomadik.h                  |   14 +
 6 files changed, 606 insertions(+), 2 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-nomadik-sta2x11.c

diff --git a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
index 9a2f3f4..3361894 100644
--- a/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
+++ b/Documentation/devicetree/bindings/pinctrl/ste,nomadik.txt
@@ -2,7 +2,7 @@ ST Ericsson Nomadik pinmux controller
 
 Required properties:
 - compatible: "stericsson,nmk-pinctrl", "stericsson,nmk-pinctrl-db8540",
-              "stericsson,nmk-pinctrl-stn8815"
+              "stericsson,nmk-pinctrl-stn8815", "stericsson,nmk-pinctrl-sta2x11"
 - reg: Should contain the register physical address and length of the PRCMU.
 
 Please refer to pinctrl-bindings.txt in this directory for details of the
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index bc830af..be2977f 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -154,7 +154,7 @@ config PINCTRL_IMX28
 
 config PINCTRL_NOMADIK
 	bool "Nomadik pin controller driver"
-	depends on ARCH_U8500 || ARCH_NOMADIK
+	depends on ARCH_U8500 || ARCH_NOMADIK || STA2X11
 	select PINMUX
 	select PINCONF
 
@@ -176,6 +176,10 @@ config PINCTRL_ROCKCHIP
 	select GENERIC_PINCONF
 	select GENERIC_IRQ_CHIP
 
+config PINCTRL_STA2X11
+       bool "STA2X11 pin controller driver"
+       depends on PINCTRL_NOMADIK && STA2X11
+
 config PINCTRL_SINGLE
 	tristate "One-register-per-pin type device tree based pinctrl driver"
 	depends on OF
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index d64563bf..24efd71 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_PINCTRL_NOMADIK)	+= pinctrl-nomadik.o
 obj-$(CONFIG_PINCTRL_STN8815)	+= pinctrl-nomadik-stn8815.o
 obj-$(CONFIG_PINCTRL_DB8500)	+= pinctrl-nomadik-db8500.o
 obj-$(CONFIG_PINCTRL_DB8540)	+= pinctrl-nomadik-db8540.o
+obj-$(CONFIG_PINCTRL_STA2X11)	+= pinctrl-nomadik-sta2x11.o
 obj-$(CONFIG_PINCTRL_ROCKCHIP)	+= pinctrl-rockchip.o
 obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
 obj-$(CONFIG_PINCTRL_SIRF)	+= sirf/
diff --git a/drivers/pinctrl/pinctrl-nomadik-sta2x11.c b/drivers/pinctrl/pinctrl-nomadik-sta2x11.c
new file mode 100644
index 0000000..0a4e3c7
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-nomadik-sta2x11.c
@@ -0,0 +1,578 @@
+#include <linux/kernel.h>
+#include <linux/pinctrl/pinctrl.h>
+#include "pinctrl-nomadik.h"
+
+/* All the pins that can be used for GPIO and some other functions */
+#define _GPIO(offset)		(offset)
+
+#define STA2X11_PIN_F6		_GPIO(0)
+#define STA2X11_PIN_D5		_GPIO(1)
+#define STA2X11_PIN_E6		_GPIO(2)
+#define STA2X11_PIN_E7		_GPIO(3)
+#define STA2X11_PIN_E9		_GPIO(4)
+#define STA2X11_PIN_F7		_GPIO(5)
+#define STA2X11_PIN_E8		_GPIO(6)
+#define STA2X11_PIN_F8		_GPIO(7)
+#define STA2X11_PIN_D14		_GPIO(8)
+#define STA2X11_PIN_E13		_GPIO(9)
+#define STA2X11_PIN_D13		_GPIO(10)
+#define STA2X11_PIN_E12		_GPIO(11)
+#define STA2X11_PIN_C15		_GPIO(12)
+#define STA2X11_PIN_E14		_GPIO(13)
+#define STA2X11_PIN_D15		_GPIO(14)
+#define STA2X11_PIN_E15		_GPIO(15)
+#define STA2X11_PIN_A17		_GPIO(16)
+#define STA2X11_PIN_C16		_GPIO(17)
+#define STA2X11_PIN_C18		_GPIO(18)
+#define STA2X11_PIN_B19		_GPIO(19)
+#define STA2X11_PIN_C17		_GPIO(20)
+#define STA2X11_PIN_D16		_GPIO(21)
+#define STA2X11_PIN_B18		_GPIO(22)
+#define STA2X11_PIN_A18		_GPIO(23)
+#define STA2X11_PIN_G13		_GPIO(24)
+#define STA2X11_PIN_F14		_GPIO(25)
+#define STA2X11_PIN_F13		_GPIO(26)
+#define STA2X11_PIN_D18		_GPIO(27)
+#define STA2X11_PIN_D19		_GPIO(28)
+#define STA2X11_PIN_G14		_GPIO(29)
+#define STA2X11_PIN_E17		_GPIO(30)
+#define STA2X11_PIN_C19		_GPIO(31)
+#define STA2X11_PIN_E19		_GPIO(32)
+#define STA2X11_PIN_E16		_GPIO(33)
+#define STA2X11_PIN_H14		_GPIO(34)
+#define STA2X11_PIN_L13		_GPIO(35)
+#define STA2X11_PIN_N16		_GPIO(36)
+#define STA2X11_PIN_M16		_GPIO(37)
+#define STA2X11_PIN_N13		_GPIO(38)
+#define STA2X11_PIN_M14		_GPIO(39)
+#define STA2X11_PIN_N14		_GPIO(40)
+#define STA2X11_PIN_M15		_GPIO(41)
+#define STA2X11_PIN_P17		_GPIO(42)
+#define STA2X11_PIN_P15		_GPIO(43)
+#define STA2X11_PIN_R18		_GPIO(44)
+#define STA2X11_PIN_R17		_GPIO(45)
+#define STA2X11_PIN_T19		_GPIO(46)
+#define STA2X11_PIN_R16		_GPIO(47)
+#define STA2X11_PIN_T18		_GPIO(48)
+#define STA2X11_PIN_U17		_GPIO(49)
+#define STA2X11_PIN_T17		_GPIO(50)
+#define STA2X11_PIN_U16		_GPIO(51)
+#define STA2X11_PIN_T15		_GPIO(52)
+#define STA2X11_PIN_T16		_GPIO(53)
+#define STA2X11_PIN_R15		_GPIO(54)
+#define STA2X11_PIN_T14		_GPIO(55)
+#define STA2X11_PIN_U18		_GPIO(56)
+#define STA2X11_PIN_U19		_GPIO(57)
+#define STA2X11_PIN_V19		_GPIO(58)
+#define STA2X11_PIN_V18		_GPIO(59)
+#define STA2X11_PIN_P18		_GPIO(60)
+#define STA2X11_PIN_R19		_GPIO(61)
+#define STA2X11_PIN_V17		_GPIO(62)
+#define STA2X11_PIN_V16		_GPIO(63)
+#define STA2X11_PIN_W17		_GPIO(64)
+#define STA2X11_PIN_W16		_GPIO(65)
+#define STA2X11_PIN_P13		_GPIO(66)
+#define STA2X11_PIN_P14		_GPIO(67)
+#define STA2X11_PIN_R9		_GPIO(68)
+#define STA2X11_PIN_R8		_GPIO(69)
+#define STA2X11_PIN_P11		_GPIO(70)
+#define STA2X11_PIN_R7		_GPIO(71)
+#define STA2X11_PIN_P10		_GPIO(72)
+#define STA2X11_PIN_P9		_GPIO(73)
+#define STA2X11_PIN_P8		_GPIO(74)
+#define STA2X11_PIN_N6		_GPIO(75)
+#define STA2X11_PIN_P5		_GPIO(76)
+#define STA2X11_PIN_N5		_GPIO(77)
+#define STA2X11_PIN_P6		_GPIO(78)
+#define STA2X11_PIN_R5		_GPIO(79)
+#define STA2X11_PIN_R6		_GPIO(80)
+#define STA2X11_PIN_T6		_GPIO(81)
+#define STA2X11_PIN_T5		_GPIO(82)
+#define STA2X11_PIN_W6		_GPIO(83)
+#define STA2X11_PIN_V6		_GPIO(84)
+#define STA2X11_PIN_W5		_GPIO(85)
+#define STA2X11_PIN_V5		_GPIO(86)
+#define STA2X11_PIN_V4		_GPIO(87)
+#define STA2X11_PIN_U4		_GPIO(88)
+#define STA2X11_PIN_U3		_GPIO(89)
+#define STA2X11_PIN_T4		_GPIO(90)
+#define STA2X11_PIN_W4		_GPIO(91)
+#define STA2X11_PIN_W3		_GPIO(92)
+#define STA2X11_PIN_W2		_GPIO(93)
+#define STA2X11_PIN_V3		_GPIO(94)
+#define STA2X11_PIN_V2		_GPIO(95)
+#define STA2X11_PIN_R4		_GPIO(96)
+#define STA2X11_PIN_V1		_GPIO(97)
+#define STA2X11_PIN_M5		_GPIO(98)
+#define STA2X11_PIN_U2		_GPIO(99)
+#define STA2X11_PIN_T2		_GPIO(100)
+#define STA2X11_PIN_U1		_GPIO(101)
+#define STA2X11_PIN_T3		_GPIO(102)
+#define STA2X11_PIN_R3		_GPIO(103)
+#define STA2X11_PIN_M7		_GPIO(104)
+#define STA2X11_PIN_P4		_GPIO(105)
+#define STA2X11_PIN_R2		_GPIO(106)
+#define STA2X11_PIN_P2		_GPIO(107)
+#define STA2X11_PIN_M6		_GPIO(108)
+#define STA2X11_PIN_T1		_GPIO(109)
+#define STA2X11_PIN_L5		_GPIO(110)
+#define STA2X11_PIN_N3		_GPIO(111)
+#define STA2X11_PIN_P1		_GPIO(112)
+#define STA2X11_PIN_N2		_GPIO(113)
+#define STA2X11_PIN_R1		_GPIO(114)
+#define STA2X11_PIN_N4		_GPIO(115)
+#define STA2X11_PIN_P3		_GPIO(116)
+#define STA2X11_PIN_M4		_GPIO(117)
+#define STA2X11_PIN_K5		_GPIO(118)
+#define STA2X11_PIN_H2		_GPIO(119)
+#define STA2X11_PIN_H1		_GPIO(120)
+#define STA2X11_PIN_J3		_GPIO(121)
+#define STA2X11_PIN_H3		_GPIO(122)
+#define STA2X11_PIN_J4		_GPIO(123)
+#define STA2X11_PIN_J5		_GPIO(124)
+#define STA2X11_PIN_D3		_GPIO(125)
+#define STA2X11_PIN_F4		_GPIO(126)
+#define STA2X11_PIN_D4		_GPIO(127)
+
+/*
+ * The names of the pins are denoted by GPIO number and ball name, even
+ * though they can be used for other things than GPIO, this is the first
+ * column in the table of the data sheet and often used on schematics and
+ * such.
+ */
+static const struct pinctrl_pin_desc nmk_sta2x11_pins[] = {
+	PINCTRL_PIN(STA2X11_PIN_F6, "GPIO0_F6"),
+	PINCTRL_PIN(STA2X11_PIN_D5, "GPIO1_D5"),
+	PINCTRL_PIN(STA2X11_PIN_E6, "GPIO2_E6"),
+	PINCTRL_PIN(STA2X11_PIN_E7, "GPIO3_E7"),
+	PINCTRL_PIN(STA2X11_PIN_E9, "GPIO4_E9"),
+	PINCTRL_PIN(STA2X11_PIN_F7, "GPIO5_F7"),
+	PINCTRL_PIN(STA2X11_PIN_E8, "GPIO6_E8"),
+	PINCTRL_PIN(STA2X11_PIN_F8, "GPIO7_F8"),
+	PINCTRL_PIN(STA2X11_PIN_D14, "GPIO8_D14"),
+	PINCTRL_PIN(STA2X11_PIN_E13, "GPIO9_E13"),
+	PINCTRL_PIN(STA2X11_PIN_D13, "GPIO10_D13"),
+	PINCTRL_PIN(STA2X11_PIN_E12, "GPIO11_E12"),
+	PINCTRL_PIN(STA2X11_PIN_C15, "GPIO12_C15"),
+	PINCTRL_PIN(STA2X11_PIN_E14, "GPIO13_E14"),
+	PINCTRL_PIN(STA2X11_PIN_D15, "GPIO14_D15"),
+	PINCTRL_PIN(STA2X11_PIN_E15, "GPIO15_E15"),
+	PINCTRL_PIN(STA2X11_PIN_A17, "GPIO16_A17"),
+	PINCTRL_PIN(STA2X11_PIN_C16, "GPIO17_C16"),
+	PINCTRL_PIN(STA2X11_PIN_C18, "GPIO18_C18"),
+	PINCTRL_PIN(STA2X11_PIN_B19, "GPIO19_B19"),
+	PINCTRL_PIN(STA2X11_PIN_C17, "GPIO20_C17"),
+	PINCTRL_PIN(STA2X11_PIN_D16, "GPIO21_D16"),
+	PINCTRL_PIN(STA2X11_PIN_B18, "GPIO22_B18"),
+	PINCTRL_PIN(STA2X11_PIN_A18, "GPIO23_A18"),
+	PINCTRL_PIN(STA2X11_PIN_G13, "GPIO24_G13"),
+	PINCTRL_PIN(STA2X11_PIN_F14, "GPIO25_F14"),
+	PINCTRL_PIN(STA2X11_PIN_F13, "GPIO26_F13"),
+	PINCTRL_PIN(STA2X11_PIN_D18, "GPIO27_D18"),
+	PINCTRL_PIN(STA2X11_PIN_D19, "GPIO28_D19"),
+	PINCTRL_PIN(STA2X11_PIN_G14, "GPIO29_G14"),
+	PINCTRL_PIN(STA2X11_PIN_E17, "GPIO30_E17"),
+	PINCTRL_PIN(STA2X11_PIN_C19, "GPIO31_C19"),
+	PINCTRL_PIN(STA2X11_PIN_E19, "GPIO32_E19"),
+	PINCTRL_PIN(STA2X11_PIN_E16, "GPIO33_E16"),
+	PINCTRL_PIN(STA2X11_PIN_H14, "GPIO34_H14"),
+	PINCTRL_PIN(STA2X11_PIN_L13, "GPIO35_L13"),
+	PINCTRL_PIN(STA2X11_PIN_N16, "GPIO36_N16"),
+	PINCTRL_PIN(STA2X11_PIN_M16, "GPIO37_M16"),
+	PINCTRL_PIN(STA2X11_PIN_N13, "GPIO38_N13"),
+	PINCTRL_PIN(STA2X11_PIN_M14, "GPIO39_M14"),
+	PINCTRL_PIN(STA2X11_PIN_N14, "GPIO40_N14"),
+	PINCTRL_PIN(STA2X11_PIN_M15, "GPIO41_M15"),
+	PINCTRL_PIN(STA2X11_PIN_P17, "GPIO42_P17"),
+	PINCTRL_PIN(STA2X11_PIN_P15, "GPIO43_P15"),
+	PINCTRL_PIN(STA2X11_PIN_R18, "GPIO44_R18"),
+	PINCTRL_PIN(STA2X11_PIN_R17, "GPIO45_R17"),
+	PINCTRL_PIN(STA2X11_PIN_T19, "GPIO46_T19"),
+	PINCTRL_PIN(STA2X11_PIN_R16, "GPIO47_R16"),
+	PINCTRL_PIN(STA2X11_PIN_T18, "GPIO48_T18"),
+	PINCTRL_PIN(STA2X11_PIN_U17, "GPIO49_U17"),
+	PINCTRL_PIN(STA2X11_PIN_T17, "GPIO50_T17"),
+	PINCTRL_PIN(STA2X11_PIN_U16, "GPIO51_U16"),
+	PINCTRL_PIN(STA2X11_PIN_T15, "GPIO52_T15"),
+	PINCTRL_PIN(STA2X11_PIN_T16, "GPIO53_T16"),
+	PINCTRL_PIN(STA2X11_PIN_R15, "GPIO54_R15"),
+	PINCTRL_PIN(STA2X11_PIN_T14, "GPIO55_T14"),
+	PINCTRL_PIN(STA2X11_PIN_U18, "GPIO56_U18"),
+	PINCTRL_PIN(STA2X11_PIN_U19, "GPIO57_U19"),
+	PINCTRL_PIN(STA2X11_PIN_V19, "GPIO58_V19"),
+	PINCTRL_PIN(STA2X11_PIN_V18, "GPIO59_V18"),
+	PINCTRL_PIN(STA2X11_PIN_P18, "GPIO60_P18"),
+	PINCTRL_PIN(STA2X11_PIN_R19, "GPIO61_R19"),
+	PINCTRL_PIN(STA2X11_PIN_V17, "GPIO62_V17"),
+	PINCTRL_PIN(STA2X11_PIN_V16, "GPIO63_V16"),
+	PINCTRL_PIN(STA2X11_PIN_W17, "GPIO64_W17"),
+	PINCTRL_PIN(STA2X11_PIN_W16, "GPIO65_W16"),
+	PINCTRL_PIN(STA2X11_PIN_P13, "GPIO66_P13"),
+	PINCTRL_PIN(STA2X11_PIN_P14, "GPIO67_P14"),
+	PINCTRL_PIN(STA2X11_PIN_R9, "GPIO68_R9"),
+	PINCTRL_PIN(STA2X11_PIN_R8, "GPIO69_R8"),
+	PINCTRL_PIN(STA2X11_PIN_P11, "GPIO70_P11"),
+	PINCTRL_PIN(STA2X11_PIN_R7, "GPIO71_R7"),
+	PINCTRL_PIN(STA2X11_PIN_P10, "GPIO72_P10"),
+	PINCTRL_PIN(STA2X11_PIN_P9, "GPIO73_P9"),
+	PINCTRL_PIN(STA2X11_PIN_P8, "GPIO74_P8"),
+	PINCTRL_PIN(STA2X11_PIN_N6, "GPIO75_N6"),
+	PINCTRL_PIN(STA2X11_PIN_P5, "GPIO76_P5"),
+	PINCTRL_PIN(STA2X11_PIN_N5, "GPIO77_N5"),
+	PINCTRL_PIN(STA2X11_PIN_P6, "GPIO78_P6"),
+	PINCTRL_PIN(STA2X11_PIN_R5, "GPIO79_R5"),
+	PINCTRL_PIN(STA2X11_PIN_R6, "GPIO80_R6"),
+	PINCTRL_PIN(STA2X11_PIN_T6, "GPIO81_T6"),
+	PINCTRL_PIN(STA2X11_PIN_T5, "GPIO82_T5"),
+	PINCTRL_PIN(STA2X11_PIN_W6, "GPIO83_W6"),
+	PINCTRL_PIN(STA2X11_PIN_V6, "GPIO84_V6"),
+	PINCTRL_PIN(STA2X11_PIN_W5, "GPIO85_W5"),
+	PINCTRL_PIN(STA2X11_PIN_V5, "GPIO86_V5"),
+	PINCTRL_PIN(STA2X11_PIN_V4, "GPIO87_V4"),
+	PINCTRL_PIN(STA2X11_PIN_U4, "GPIO88_U4"),
+	PINCTRL_PIN(STA2X11_PIN_U3, "GPIO89_U3"),
+	PINCTRL_PIN(STA2X11_PIN_T4, "GPIO90_T4"),
+	PINCTRL_PIN(STA2X11_PIN_W4, "GPIO91_W4"),
+	PINCTRL_PIN(STA2X11_PIN_W3, "GPIO92_W3"),
+	PINCTRL_PIN(STA2X11_PIN_W2, "GPIO93_W2"),
+	PINCTRL_PIN(STA2X11_PIN_V3, "GPIO94_V3"),
+	PINCTRL_PIN(STA2X11_PIN_V2, "GPIO95_V2"),
+	PINCTRL_PIN(STA2X11_PIN_R4, "GPIO96_R4"),
+	PINCTRL_PIN(STA2X11_PIN_V1, "GPIO97_V1"),
+	PINCTRL_PIN(STA2X11_PIN_M5, "GPIO98_M5"),
+	PINCTRL_PIN(STA2X11_PIN_U2, "GPIO99_U2"),
+	PINCTRL_PIN(STA2X11_PIN_T2, "GPIO100_T2"),
+	PINCTRL_PIN(STA2X11_PIN_U1, "GPIO101_U1"),
+	PINCTRL_PIN(STA2X11_PIN_T3, "GPIO102_T3"),
+	PINCTRL_PIN(STA2X11_PIN_R3, "GPIO103_R3"),
+	PINCTRL_PIN(STA2X11_PIN_M7, "GPIO104_M7"),
+	PINCTRL_PIN(STA2X11_PIN_P4, "GPIO105_P4"),
+	PINCTRL_PIN(STA2X11_PIN_R2, "GPIO106_R2"),
+	PINCTRL_PIN(STA2X11_PIN_P2, "GPIO107_P2"),
+	PINCTRL_PIN(STA2X11_PIN_M6, "GPIO108_M6"),
+	PINCTRL_PIN(STA2X11_PIN_T1, "GPIO109_T1"),
+	PINCTRL_PIN(STA2X11_PIN_L5, "GPIO110_L5"),
+	PINCTRL_PIN(STA2X11_PIN_N3, "GPIO111_N3"),
+	PINCTRL_PIN(STA2X11_PIN_P1, "GPIO112_P1"),
+	PINCTRL_PIN(STA2X11_PIN_N2, "GPIO113_N2"),
+	PINCTRL_PIN(STA2X11_PIN_R1, "GPIO114_R1"),
+	PINCTRL_PIN(STA2X11_PIN_N4, "GPIO115_N4"),
+	PINCTRL_PIN(STA2X11_PIN_P3, "GPIO116_P3"),
+	PINCTRL_PIN(STA2X11_PIN_M4, "GPIO117_M4"),
+	PINCTRL_PIN(STA2X11_PIN_K5, "GPIO118_K5"),
+	PINCTRL_PIN(STA2X11_PIN_H2, "GPIO119_H2"),
+	PINCTRL_PIN(STA2X11_PIN_H1, "GPIO120_H1"),
+	PINCTRL_PIN(STA2X11_PIN_J3, "GPIO121_J3"),
+	PINCTRL_PIN(STA2X11_PIN_H3, "GPIO122_H3"),
+	PINCTRL_PIN(STA2X11_PIN_J4, "GPIO123_J4"),
+	PINCTRL_PIN(STA2X11_PIN_J5, "GPIO124_J5"),
+	PINCTRL_PIN(STA2X11_PIN_D3, "GPIO125_D3"),
+	PINCTRL_PIN(STA2X11_PIN_F4, "GPIO126_F4"),
+	PINCTRL_PIN(STA2X11_PIN_D4, "GPIO127_D4"),
+};
+
+#define STA2X11_GPIO_RANGE(a, b, c) { .name = "STA2X11", .id = a, .base = b, \
+			.pin_base = b, .npins = c }
+
+/*
+ * This matches the 32-pin gpio chips registered by the GPIO portion. This
+ * cannot be const since we assign the struct gpio_chip * pointer at runtime.
+ */
+static struct pinctrl_gpio_range nmk_sta2x11_ranges[] = {
+	STA2X11_GPIO_RANGE(0, 0, 32),
+	STA2X11_GPIO_RANGE(1, 32, 32),
+	STA2X11_GPIO_RANGE(2, 64, 32),
+	STA2X11_GPIO_RANGE(3, 96, 32),
+};
+
+/*
+ * Read the pin group names like this:
+ * u0_a_1    = first groups of pins for uart0 on alt function a
+ * i2c2_b_2  = second group of pins for i2c2 on alt function b
+ */
+
+/* Altfunction A */
+static const unsigned gpio07_a_1_pins[] = { STA2X11_PIN_F6, STA2X11_PIN_D5,
+	STA2X11_PIN_E6, STA2X11_PIN_E7, STA2X11_PIN_E9, STA2X11_PIN_F7,
+	STA2X11_PIN_E8, STA2X11_PIN_F8 };
+
+static const unsigned rgbout_a_1_pins[] = {
+	STA2X11_PIN_D14,
+	STA2X11_PIN_E13,
+	STA2X11_PIN_D13,
+	STA2X11_PIN_E12,
+	STA2X11_PIN_C15,
+	STA2X11_PIN_E14,
+	STA2X11_PIN_D15,
+	STA2X11_PIN_E15,
+	STA2X11_PIN_A17,
+	STA2X11_PIN_C16,
+	STA2X11_PIN_C18,
+	STA2X11_PIN_B19,
+	STA2X11_PIN_C17,
+	STA2X11_PIN_D16,
+	STA2X11_PIN_B18,
+	STA2X11_PIN_A18,
+	STA2X11_PIN_G13,
+	STA2X11_PIN_F14,
+	STA2X11_PIN_F13,
+	STA2X11_PIN_D18,
+	STA2X11_PIN_D19,
+	STA2X11_PIN_G14,
+	STA2X11_PIN_E17,
+	STA2X11_PIN_C19,
+	STA2X11_PIN_E19,
+	STA2X11_PIN_E16,
+	STA2X11_PIN_H14,
+};
+
+static const unsigned eth_a_1_pins[] = {
+	STA2X11_PIN_L13,
+	STA2X11_PIN_N16,
+	STA2X11_PIN_M16,
+	STA2X11_PIN_N13,
+	STA2X11_PIN_M14,
+	STA2X11_PIN_N14,
+	STA2X11_PIN_M15,
+	STA2X11_PIN_P17,
+	STA2X11_PIN_P15,
+};
+
+static const unsigned can_a_1_pins[] = {
+	STA2X11_PIN_R18,
+	STA2X11_PIN_R17,
+};
+
+static const unsigned mlb_a_1_pins[] = {
+	STA2X11_PIN_T19,
+	STA2X11_PIN_R16,
+};
+
+static const unsigned spi0_a_1_pins[] = {
+	STA2X11_PIN_T18,
+	STA2X11_PIN_U17,
+	STA2X11_PIN_T17,
+	STA2X11_PIN_U16,
+};
+
+static const unsigned spi1_a_1_pins[] = {
+	STA2X11_PIN_T15,
+	STA2X11_PIN_T16,
+	STA2X11_PIN_R15,
+	STA2X11_PIN_T14,
+};
+
+static const unsigned spi2_a_1_pins[] = {
+	STA2X11_PIN_U18,
+	STA2X11_PIN_U19,
+	STA2X11_PIN_V19,
+	STA2X11_PIN_V18,
+};
+
+static const unsigned i2c0_a_1_pins[] = {
+	STA2X11_PIN_P18,
+	STA2X11_PIN_R19,
+};
+
+static const unsigned i2c1_a_1_pins[] = {
+	STA2X11_PIN_V17,
+	STA2X11_PIN_V16,
+};
+
+static const unsigned i2c2_a_1_pins[] = {
+	STA2X11_PIN_W17,
+	STA2X11_PIN_W16,
+};
+
+static const unsigned i2c3_a_1_pins[] = {
+	STA2X11_PIN_P13,
+	STA2X11_PIN_P14,
+};
+
+static const unsigned msp0_a_1_pins[] = {
+	STA2X11_PIN_R9,
+	STA2X11_PIN_R8,
+	STA2X11_PIN_P11,
+	STA2X11_PIN_R7,
+	STA2X11_PIN_P10,
+	STA2X11_PIN_P9,
+	STA2X11_PIN_P8,
+};
+
+static const unsigned msp1_a_1_pins[] = {
+	STA2X11_PIN_N6,
+	STA2X11_PIN_P5,
+	STA2X11_PIN_N5,
+	STA2X11_PIN_P6,
+};
+
+static const unsigned msp2_a_1_pins[] = {
+	STA2X11_PIN_R5,
+	STA2X11_PIN_R6,
+	STA2X11_PIN_T6,
+	STA2X11_PIN_T5,
+};
+
+static const unsigned msp3_a_1_pins[] = {
+	STA2X11_PIN_W6,
+	STA2X11_PIN_V6,
+	STA2X11_PIN_W5,
+	STA2X11_PIN_V5,
+};
+
+static const unsigned msp4_a_1_pins[] = {
+	STA2X11_PIN_V4,
+	STA2X11_PIN_U4,
+	STA2X11_PIN_U3,
+	STA2X11_PIN_T4,
+};
+
+static const unsigned msp5_a_1_pins[] = {
+	STA2X11_PIN_W4,
+	STA2X11_PIN_W3,
+	STA2X11_PIN_W2,
+	STA2X11_PIN_V3,
+};
+
+static const unsigned sdio3_a_1_pins[] = {
+	STA2X11_PIN_V2,
+	STA2X11_PIN_R4,
+	STA2X11_PIN_V1,
+	STA2X11_PIN_M5,
+	STA2X11_PIN_U2,
+	STA2X11_PIN_T2,
+};
+
+static const unsigned sdio2_a_1_pins[] = {
+	STA2X11_PIN_P4,
+	STA2X11_PIN_R2,
+	STA2X11_PIN_P2,
+	STA2X11_PIN_M6,
+	STA2X11_PIN_T1,
+	STA2X11_PIN_L5,
+};
+
+static const unsigned sdio1_a_1_pins[] = {
+	STA2X11_PIN_N4,
+	STA2X11_PIN_P3,
+	STA2X11_PIN_M4,
+	STA2X11_PIN_K5,
+	STA2X11_PIN_H2,
+	STA2X11_PIN_H1,
+};
+
+static const unsigned u2_a_1_pins[] = {
+	STA2X11_PIN_D3,
+	STA2X11_PIN_F4,
+};
+
+static const unsigned u3_a_1_pins[] = {
+	STA2X11_PIN_D4,
+};
+
+#define STA2X11_PIN_GROUP(a, b) { .name = #a, .pins = a##_pins,		\
+			.npins = ARRAY_SIZE(a##_pins), .altsetting = b }
+
+static const struct nmk_pingroup nmk_sta2x11_groups[] = {
+	STA2X11_PIN_GROUP(gpio07_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(rgbout_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(eth_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(can_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(mlb_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(spi0_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(spi1_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(spi2_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(i2c0_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(i2c1_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(i2c2_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(i2c3_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(msp0_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(msp1_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(msp2_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(msp3_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(msp4_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(msp5_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(sdio3_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(sdio2_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(sdio1_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(u2_a_1, NMK_GPIO_ALT_A),
+	STA2X11_PIN_GROUP(u3_a_1, NMK_GPIO_ALT_A),
+};
+
+/* We use this macro to define the groups applicable to a function */
+#define STA2X11_FUNC_GROUPS(a, b...)	   \
+static const char * const a##_groups[] = { b };
+
+STA2X11_FUNC_GROUPS(gpio07, "gpio07_a_1");
+STA2X11_FUNC_GROUPS(rgbout, "rgbout_a_1");
+STA2X11_FUNC_GROUPS(eth, "eth_a_1");
+STA2X11_FUNC_GROUPS(can, "can_a_1");
+STA2X11_FUNC_GROUPS(mlb, "mlb_a_1");
+STA2X11_FUNC_GROUPS(spi0, "spi0_a_1");
+STA2X11_FUNC_GROUPS(spi1, "spi1_a_1");
+STA2X11_FUNC_GROUPS(spi2, "spi2_a_1");
+STA2X11_FUNC_GROUPS(i2c0, "i2c0_a_1");
+STA2X11_FUNC_GROUPS(i2c1, "i2c1_a_1");
+STA2X11_FUNC_GROUPS(i2c2, "i2c2_a_1");
+STA2X11_FUNC_GROUPS(i2c3, "i2c3_a_1");
+STA2X11_FUNC_GROUPS(msp0, "msp0_a_1");
+STA2X11_FUNC_GROUPS(msp1, "msp1_a_1");
+STA2X11_FUNC_GROUPS(msp2, "msp2_a_1");
+STA2X11_FUNC_GROUPS(msp3, "msp3_a_1");
+STA2X11_FUNC_GROUPS(msp4, "msp4_a_1");
+STA2X11_FUNC_GROUPS(msp5, "msp5_a_1");
+STA2X11_FUNC_GROUPS(sdio3, "sdio3_a_1");
+STA2X11_FUNC_GROUPS(sdio2, "sdio2_a_1");
+STA2X11_FUNC_GROUPS(sdio1, "sdio1_a_1");
+STA2X11_FUNC_GROUPS(u2, "u2_a_1");
+STA2X11_FUNC_GROUPS(u3, "u3_a_1");
+
+
+#define FUNCTION(fname)					\
+	{						\
+		.name = #fname,				\
+		.groups = fname##_groups,		\
+		.ngroups = ARRAY_SIZE(fname##_groups),	\
+	}
+
+static const struct nmk_function nmk_sta2x11_functions[] = {
+	FUNCTION(gpio07),
+	FUNCTION(rgbout),
+	FUNCTION(eth),
+	FUNCTION(can),
+	FUNCTION(mlb),
+	FUNCTION(spi0),
+	FUNCTION(spi1),
+	FUNCTION(spi2),
+	FUNCTION(i2c0),
+	FUNCTION(i2c1),
+	FUNCTION(i2c2),
+	FUNCTION(i2c3),
+	FUNCTION(msp0),
+	FUNCTION(msp1),
+	FUNCTION(msp2),
+	FUNCTION(msp3),
+	FUNCTION(msp4),
+	FUNCTION(msp5),
+	FUNCTION(sdio3),
+	FUNCTION(sdio2),
+	FUNCTION(sdio1),
+	FUNCTION(u2),
+	FUNCTION(u3),
+};
+
+static const struct nmk_pinctrl_soc_data nmk_sta2x11_soc = {
+	.gpio_ranges = nmk_sta2x11_ranges,
+	.gpio_num_ranges = ARRAY_SIZE(nmk_sta2x11_ranges),
+	.pins = nmk_sta2x11_pins,
+	.npins = ARRAY_SIZE(nmk_sta2x11_pins),
+	.functions = nmk_sta2x11_functions,
+	.nfunctions = ARRAY_SIZE(nmk_sta2x11_functions),
+	.groups = nmk_sta2x11_groups,
+	.ngroups = ARRAY_SIZE(nmk_sta2x11_groups),
+};
+
+void nmk_pinctrl_sta2x11_init(const struct nmk_pinctrl_soc_data **soc)
+{
+	*soc = &nmk_sta2x11_soc;
+}
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 97fb020..d7d4b592 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -2131,6 +2131,10 @@ static const struct of_device_id nmk_pinctrl_match[] = {
 		.compatible = "stericsson,db8540-pinctrl",
 		.data = (void *)PINCTRL_NMK_DB8540,
 	},
+	{
+		.compatible = "stericsson,nmk-pinctrl-sta2x11",
+		.data = (void *)PINCTRL_NMK_STA2X11,
+	},
 	{},
 };
 
@@ -2188,6 +2192,8 @@ static int nmk_pinctrl_probe(struct platform_device *pdev)
 		nmk_pinctrl_db8500_init(&npct->soc);
 	if (version == PINCTRL_NMK_DB8540)
 		nmk_pinctrl_db8540_init(&npct->soc);
+	if (version == PINCTRL_NMK_STA2X11)
+		nmk_pinctrl_sta2x11_init(&npct->soc);
 
 	if (np) {
 		prcm_np = of_parse_phandle(np, "prcm", 0);
@@ -2262,6 +2268,7 @@ static const struct platform_device_id nmk_pinctrl_id[] = {
 	{ "pinctrl-stn8815", PINCTRL_NMK_STN8815 },
 	{ "pinctrl-db8500", PINCTRL_NMK_DB8500 },
 	{ "pinctrl-db8540", PINCTRL_NMK_DB8540 },
+	{ "pinctrl-sta2x11", PINCTRL_NMK_STA2X11 },
 	{ }
 };
 
diff --git a/drivers/pinctrl/pinctrl-nomadik.h b/drivers/pinctrl/pinctrl-nomadik.h
index bcd4191..8b072f8 100644
--- a/drivers/pinctrl/pinctrl-nomadik.h
+++ b/drivers/pinctrl/pinctrl-nomadik.h
@@ -7,6 +7,7 @@
 #define PINCTRL_NMK_STN8815	0
 #define PINCTRL_NMK_DB8500	1
 #define PINCTRL_NMK_DB8540	2
+#define PINCTRL_NMK_STA2X11	3
 
 #define PRCM_GPIOCR_ALTCX(pin_num,\
 	altc1_used, altc1_ri, altc1_cb,\
@@ -179,4 +180,17 @@ nmk_pinctrl_db8540_init(const struct nmk_pinctrl_soc_data **soc)
 
 #endif
 
+#ifdef CONFIG_PINCTRL_STA2X11
+
+void nmk_pinctrl_sta2x11_init(const struct nmk_pinctrl_soc_data **soc);
+
+#else
+
+static inline void
+nmk_pinctrl_sta2x11_init(const struct nmk_pinctrl_soc_data **soc)
+{
+}
+
+#endif
+
 #endif /* PINCTRL_PINCTRL_NOMADIK_H */
-- 
1.7.7.2
