Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3HUGZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:25:01 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:56053
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287Ab3HUGY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:24:57 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizea8Na1fflb922lzz1f42h1ee6h1ce5h1fdah201ch2073h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz1de098h17326ah1de096h5eeeK8275bh1de097hz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 1/3 v3] pinctrl: ADI PIN control driver for the GPIO controller on bf54x and bf60x.
Date: Wed, 21 Aug 2013 14:30:05 +0800
Message-ID: <1377066607-19061-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The new ADI GPIO2 controller was introduced since the BF548 and BF60x
processors. It differs a lot from the old one on BF5xx processors. So,
create a pinctrl driver under the pinctrl framework.

- Define gpio ports and pin interrupt controllers as individual platform
devices.
- Register a pinctrl driver for the whole GPIO ports and pin interrupt
devices.
- Probe pint devices before port devices. Put device instances into
the global gpio and pint lists.
- Define peripheral, irq and gpio reservation bit masks for each gpio
port as runtime resources.
- Save and restore gpio port and pint status MMRs in syscore PM functions.
- Create the plug-in subdrivers to hold the pinctrl soc data for bf54x
and bf60x. Add soc data into struct adi_pinctrl. Initialize the soc data
in pin controller probe function. Get the pin groups and functions via
the soc data reference.
- Call gpiochip_add_pin_range() in gpio device probe function to register
range cross reference between gpio device and pin control device.
- Get range by pinctrl_find_gpio_range_from_pin(), find gpio_port object
by container_of() and find adi_pinctrl by pin control device name.
- Handle peripheral and gpio requests in pinctrl operation functions.
- Demux gpio IRQs via the irq_domain created by each GPIO port.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

---
v2-changes:
- Remove unlinke() directive.

v3-changes:
- Rename struct adi_pmx to adi_pinctrl.
- Fix the comments of struct gpio_pint.
- Remove unused pin_base in struct gpio_port.
- Change pint_assign into bool type.
- Add comments about the relationship between pint device and port device
to the driver header.
- Use BIT macro to shift bit.
- Remove all bitmap reservation help functions. Inline reservation functions
into the actual code.
- Remove gpio and offset mutual reference help functions.
- Remove all help functions to find gpio_port and adi_pinctrl structs. Get
range by pinctrl_find_gpio_range_from_pin(), find gpio_port object by
container_of() and find adi_pinctrl by pin control device name.
- Pass bool type usage variable to port_setup help function.
- Separate long bit operations into several lines and add comments.
- Use debugfs to output all GPIO request information.
- Avoid to set drvdata to NULL
- Add explanation to function adi_gpio_init_int()
- Call gpiochip_add_pin_range() in gpio device probe function to register
range cross reference between gpio device and pin control device.
- Remove the reference to pin control device from the gpio_port struct.
Remove the reference list to gpio device from the adi_pinctrl struct.
Replace the global adi_pinctrl list with adi_gpio_port_list. Walk through
the gpio list to do power suspend and resume operations.
- Remove the global GPIO base from struct adi_pinctrl, define pin base in
the platform data for each GPIO port device.
- Initialize adi_pinctrl_setup in arch_initcall().
- print the status of triggers, whether it is in GPIO mode, if it is
flagged to be used as IRQ, etc in adi_pin_dbg_show().
- Create the plug-in subdrivers to hold the pinctrl soc data for bf54x
and bf60x. Add soc data into struct adi_pinctrl. Initialize the soc data
in pin controller probe function. Get the pin groups and functions via
the soc data reference.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/pinctrl/Kconfig                    |   17 +
 drivers/pinctrl/Makefile                   |    3 +
 drivers/pinctrl/pinctrl-adi2-bf54x.c       |  572 +++++++++++
 drivers/pinctrl/pinctrl-adi2-bf60x.c       |  454 +++++++++
 drivers/pinctrl/pinctrl-adi2.c             | 1501 ++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-adi2.h             |   75 ++
 include/linux/platform_data/pinctrl-adi2.h |   40 +
 7 files changed, 2662 insertions(+)
 create mode 100644 drivers/pinctrl/pinctrl-adi2-bf54x.c
 create mode 100644 drivers/pinctrl/pinctrl-adi2-bf60x.c
 create mode 100644 drivers/pinctrl/pinctrl-adi2.c
 create mode 100644 drivers/pinctrl/pinctrl-adi2.h
 create mode 100644 include/linux/platform_data/pinctrl-adi2.h

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 8f66924..08b8337 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -49,6 +49,23 @@ config PINCTRL_AB8505
 	bool "AB8505 pin controller driver"
 	depends on PINCTRL_ABX500 && ARCH_U8500
 
+config PINCTRL_ADI2
+	bool "ADI pin controller driver"
+	select PINMUX
+	select IRQ_DOMAIN
+	help
+	  This is the pin controller and gpio driver for ADI BF54x, BF60x and
+	  future processors. This option is selected automatically when specific
+	  machine and arch are selected to build.
+
+config PINCTRL_BF54x
+	def_bool y if BF54x
+	select PINCTRL_ADI2
+
+config PINCTRL_BF60x
+	def_bool y if BF60x
+	select PINCTRL_ADI2
+
 config PINCTRL_AT91
 	bool "AT91 pinctrl driver"
 	depends on OF
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 9bdaeb8..4701180 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -14,6 +14,9 @@ obj-$(CONFIG_PINCTRL_AB8500)	+= pinctrl-ab8500.o
 obj-$(CONFIG_PINCTRL_AB8540)	+= pinctrl-ab8540.o
 obj-$(CONFIG_PINCTRL_AB9540)	+= pinctrl-ab9540.o
 obj-$(CONFIG_PINCTRL_AB8505)	+= pinctrl-ab8505.o
+obj-$(CONFIG_PINCTRL_ADI2)	+= pinctrl-adi2.o
+obj-$(CONFIG_PINCTRL_BF54x)	+= pinctrl-adi2-bf54x.o
+obj-$(CONFIG_PINCTRL_BF60x)	+= pinctrl-adi2-bf60x.o
 obj-$(CONFIG_PINCTRL_AT91)	+= pinctrl-at91.o
 obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
 obj-$(CONFIG_PINCTRL_IMX)	+= pinctrl-imx.o
diff --git a/drivers/pinctrl/pinctrl-adi2-bf54x.c b/drivers/pinctrl/pinctrl-adi2-bf54x.c
new file mode 100644
index 0000000..78757e0
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-adi2-bf54x.c
@@ -0,0 +1,572 @@
+/*
+ * Pinctrl Driver for ADI GPIO2 controller
+ *
+ * Copyright 2007-2013 Analog Devices Inc.
+ *
+ * Licensed under the GPLv2 or later
+ */
+
+#include <asm/portmux.h>
+#include "pinctrl-adi2.h"
+
+static const struct pinctrl_pin_desc adi_pads[] = {
+	PINCTRL_PIN(0, "PA0"),
+	PINCTRL_PIN(1, "PA1"),
+	PINCTRL_PIN(2, "PA2"),
+	PINCTRL_PIN(3, "PG3"),
+	PINCTRL_PIN(4, "PA4"),
+	PINCTRL_PIN(5, "PA5"),
+	PINCTRL_PIN(6, "PA6"),
+	PINCTRL_PIN(7, "PA7"),
+	PINCTRL_PIN(8, "PA8"),
+	PINCTRL_PIN(9, "PA9"),
+	PINCTRL_PIN(10, "PA10"),
+	PINCTRL_PIN(11, "PA11"),
+	PINCTRL_PIN(12, "PA12"),
+	PINCTRL_PIN(13, "PA13"),
+	PINCTRL_PIN(14, "PA14"),
+	PINCTRL_PIN(15, "PA15"),
+	PINCTRL_PIN(16, "PB0"),
+	PINCTRL_PIN(17, "PB1"),
+	PINCTRL_PIN(18, "PB2"),
+	PINCTRL_PIN(19, "PB3"),
+	PINCTRL_PIN(20, "PB4"),
+	PINCTRL_PIN(21, "PB5"),
+	PINCTRL_PIN(22, "PB6"),
+	PINCTRL_PIN(23, "PB7"),
+	PINCTRL_PIN(24, "PB8"),
+	PINCTRL_PIN(25, "PB9"),
+	PINCTRL_PIN(26, "PB10"),
+	PINCTRL_PIN(27, "PB11"),
+	PINCTRL_PIN(28, "PB12"),
+	PINCTRL_PIN(29, "PB13"),
+	PINCTRL_PIN(30, "PB14"),
+	PINCTRL_PIN(32, "PC0"),
+	PINCTRL_PIN(33, "PC1"),
+	PINCTRL_PIN(34, "PC2"),
+	PINCTRL_PIN(35, "PC3"),
+	PINCTRL_PIN(36, "PC4"),
+	PINCTRL_PIN(37, "PC5"),
+	PINCTRL_PIN(38, "PC6"),
+	PINCTRL_PIN(39, "PC7"),
+	PINCTRL_PIN(40, "PC8"),
+	PINCTRL_PIN(41, "PC9"),
+	PINCTRL_PIN(42, "PC10"),
+	PINCTRL_PIN(43, "PC11"),
+	PINCTRL_PIN(44, "PC12"),
+	PINCTRL_PIN(45, "PC13"),
+	PINCTRL_PIN(48, "PD0"),
+	PINCTRL_PIN(49, "PD1"),
+	PINCTRL_PIN(50, "PD2"),
+	PINCTRL_PIN(51, "PD3"),
+	PINCTRL_PIN(52, "PD4"),
+	PINCTRL_PIN(53, "PD5"),
+	PINCTRL_PIN(54, "PD6"),
+	PINCTRL_PIN(55, "PD7"),
+	PINCTRL_PIN(56, "PD8"),
+	PINCTRL_PIN(57, "PD9"),
+	PINCTRL_PIN(58, "PD10"),
+	PINCTRL_PIN(59, "PD11"),
+	PINCTRL_PIN(60, "PD12"),
+	PINCTRL_PIN(61, "PD13"),
+	PINCTRL_PIN(62, "PD14"),
+	PINCTRL_PIN(63, "PD15"),
+	PINCTRL_PIN(64, "PE0"),
+	PINCTRL_PIN(65, "PE1"),
+	PINCTRL_PIN(66, "PE2"),
+	PINCTRL_PIN(67, "PE3"),
+	PINCTRL_PIN(68, "PE4"),
+	PINCTRL_PIN(69, "PE5"),
+	PINCTRL_PIN(70, "PE6"),
+	PINCTRL_PIN(71, "PE7"),
+	PINCTRL_PIN(72, "PE8"),
+	PINCTRL_PIN(73, "PE9"),
+	PINCTRL_PIN(74, "PE10"),
+	PINCTRL_PIN(75, "PE11"),
+	PINCTRL_PIN(76, "PE12"),
+	PINCTRL_PIN(77, "PE13"),
+	PINCTRL_PIN(78, "PE14"),
+	PINCTRL_PIN(79, "PE15"),
+	PINCTRL_PIN(80, "PF0"),
+	PINCTRL_PIN(81, "PF1"),
+	PINCTRL_PIN(82, "PF2"),
+	PINCTRL_PIN(83, "PF3"),
+	PINCTRL_PIN(84, "PF4"),
+	PINCTRL_PIN(85, "PF5"),
+	PINCTRL_PIN(86, "PF6"),
+	PINCTRL_PIN(87, "PF7"),
+	PINCTRL_PIN(88, "PF8"),
+	PINCTRL_PIN(89, "PF9"),
+	PINCTRL_PIN(90, "PF10"),
+	PINCTRL_PIN(91, "PF11"),
+	PINCTRL_PIN(92, "PF12"),
+	PINCTRL_PIN(93, "PF13"),
+	PINCTRL_PIN(94, "PF14"),
+	PINCTRL_PIN(95, "PF15"),
+	PINCTRL_PIN(96, "PG0"),
+	PINCTRL_PIN(97, "PG1"),
+	PINCTRL_PIN(98, "PG2"),
+	PINCTRL_PIN(99, "PG3"),
+	PINCTRL_PIN(100, "PG4"),
+	PINCTRL_PIN(101, "PG5"),
+	PINCTRL_PIN(102, "PG6"),
+	PINCTRL_PIN(103, "PG7"),
+	PINCTRL_PIN(104, "PG8"),
+	PINCTRL_PIN(105, "PG9"),
+	PINCTRL_PIN(106, "PG10"),
+	PINCTRL_PIN(107, "PG11"),
+	PINCTRL_PIN(108, "PG12"),
+	PINCTRL_PIN(109, "PG13"),
+	PINCTRL_PIN(110, "PG14"),
+	PINCTRL_PIN(111, "PG15"),
+	PINCTRL_PIN(112, "PH0"),
+	PINCTRL_PIN(113, "PH1"),
+	PINCTRL_PIN(114, "PH2"),
+	PINCTRL_PIN(115, "PH3"),
+	PINCTRL_PIN(116, "PH4"),
+	PINCTRL_PIN(117, "PH5"),
+	PINCTRL_PIN(118, "PH6"),
+	PINCTRL_PIN(119, "PH7"),
+	PINCTRL_PIN(120, "PH8"),
+	PINCTRL_PIN(121, "PH9"),
+	PINCTRL_PIN(122, "PH10"),
+	PINCTRL_PIN(123, "PH11"),
+	PINCTRL_PIN(124, "PH12"),
+	PINCTRL_PIN(125, "PH13"),
+	PINCTRL_PIN(128, "PI0"),
+	PINCTRL_PIN(129, "PI1"),
+	PINCTRL_PIN(130, "PI2"),
+	PINCTRL_PIN(131, "PI3"),
+	PINCTRL_PIN(132, "PI4"),
+	PINCTRL_PIN(133, "PI5"),
+	PINCTRL_PIN(134, "PI6"),
+	PINCTRL_PIN(135, "PI7"),
+	PINCTRL_PIN(136, "PI8"),
+	PINCTRL_PIN(137, "PI9"),
+	PINCTRL_PIN(138, "PI10"),
+	PINCTRL_PIN(139, "PI11"),
+	PINCTRL_PIN(140, "PI12"),
+	PINCTRL_PIN(141, "PI13"),
+	PINCTRL_PIN(142, "PI14"),
+	PINCTRL_PIN(143, "PI15"),
+	PINCTRL_PIN(144, "PJ0"),
+	PINCTRL_PIN(145, "PJ1"),
+	PINCTRL_PIN(146, "PJ2"),
+	PINCTRL_PIN(147, "PJ3"),
+	PINCTRL_PIN(148, "PJ4"),
+	PINCTRL_PIN(149, "PJ5"),
+	PINCTRL_PIN(150, "PJ6"),
+	PINCTRL_PIN(151, "PJ7"),
+	PINCTRL_PIN(152, "PJ8"),
+	PINCTRL_PIN(153, "PJ9"),
+	PINCTRL_PIN(154, "PJ10"),
+	PINCTRL_PIN(155, "PJ11"),
+	PINCTRL_PIN(156, "PJ12"),
+	PINCTRL_PIN(157, "PJ13"),
+};
+
+static const unsigned uart0_pins[] = {
+	GPIO_PE7, GPIO_PE8,
+};
+
+static const unsigned uart1_pins[] = {
+	GPIO_PH0, GPIO_PH1,
+#ifdef CONFIG_BFIN_UART1_CTSRTS
+	GPIO_PE9, GPIO_PE10,
+#endif
+};
+
+static const unsigned uart2_pins[] = {
+	GPIO_PB4, GPIO_PB5,
+};
+
+static const unsigned uart3_pins[] = {
+	GPIO_PB6, GPIO_PB7,
+#ifdef CONFIG_BFIN_UART3_CTSRTS
+	GPIO_PB2, GPIO_PB3,
+#endif
+};
+
+static const unsigned rsi0_pins[] = {
+	GPIO_PC8, GPIO_PC9, GPIO_PC10, GPIO_PC11, GPIO_PC12, GPIO_PC13,
+};
+
+static const unsigned spi0_pins[] = {
+	GPIO_PE0, GPIO_PE1, GPIO_PE2,
+};
+
+static const unsigned spi1_pins[] = {
+	GPIO_PG8, GPIO_PG9, GPIO_PG10,
+};
+
+static const unsigned twi0_pins[] = {
+	GPIO_PE14, GPIO_PE15,
+};
+
+static const unsigned twi1_pins[] = {
+	GPIO_PB0, GPIO_PB1,
+};
+
+static const unsigned rotary_pins[] = {
+	GPIO_PH4, GPIO_PH3, GPIO_PH5,
+};
+
+static const unsigned can0_pins[] = {
+	GPIO_PG13, GPIO_PG12,
+};
+
+static const unsigned can1_pins[] = {
+	GPIO_PG14, GPIO_PG15,
+};
+
+static const unsigned smc0_pins[] = {
+	GPIO_PH8, GPIO_PH9, GPIO_PH10, GPIO_PH11, GPIO_PH12, GPIO_PH13,
+	GPIO_PI0, GPIO_PI1, GPIO_PI2, GPIO_PI3, GPIO_PI4, GPIO_PI5, GPIO_PI6,
+	GPIO_PI7, GPIO_PI8, GPIO_PI9, GPIO_PI10, GPIO_PI11,
+	GPIO_PI12, GPIO_PI13, GPIO_PI14, GPIO_PI15,
+};
+
+static const unsigned sport0_pins[] = {
+	GPIO_PC0, GPIO_PC2, GPIO_PC3, GPIO_PC4, GPIO_PC6, GPIO_PC7,
+};
+
+static const unsigned sport1_pins[] = {
+	GPIO_PD0, GPIO_PD2, GPIO_PD3, GPIO_PD4, GPIO_PD6, GPIO_PD7,
+};
+
+static const unsigned sport2_pins[] = {
+	GPIO_PA0, GPIO_PA2, GPIO_PA3, GPIO_PA4, GPIO_PA6, GPIO_PA7,
+};
+
+static const unsigned sport3_pins[] = {
+	GPIO_PA8, GPIO_PA10, GPIO_PA11, GPIO_PA12, GPIO_PA14, GPIO_PA15,
+};
+
+static const unsigned ppi0_8b_pins[] = {
+	GPIO_PF0, GPIO_PF1, GPIO_PF2, GPIO_PF3, GPIO_PF4, GPIO_PF5, GPIO_PF6,
+	GPIO_PF7, GPIO_PF13, GPIO_PG0, GPIO_PG1, GPIO_PG2,
+};
+
+static const unsigned ppi0_16b_pins[] = {
+	GPIO_PF0, GPIO_PF1, GPIO_PF2, GPIO_PF3, GPIO_PF4, GPIO_PF5, GPIO_PF6,
+	GPIO_PF7, GPIO_PF9, GPIO_PF10, GPIO_PF11, GPIO_PF12,
+	GPIO_PF13, GPIO_PF14, GPIO_PF15,
+	GPIO_PG0, GPIO_PG1, GPIO_PG2,
+};
+
+static const unsigned ppi0_24b_pins[] = {
+	GPIO_PF0, GPIO_PF1, GPIO_PF2, GPIO_PF3, GPIO_PF4, GPIO_PF5, GPIO_PF6,
+	GPIO_PF7, GPIO_PF8, GPIO_PF9, GPIO_PF10, GPIO_PF11, GPIO_PF12,
+	GPIO_PF13, GPIO_PF14, GPIO_PF15, GPIO_PD0, GPIO_PD1, GPIO_PD2,
+	GPIO_PD3, GPIO_PD4, GPIO_PD5, GPIO_PG3, GPIO_PG4,
+	GPIO_PG0, GPIO_PG1, GPIO_PG2,
+};
+
+static const unsigned ppi1_8b_pins[] = {
+	GPIO_PD0, GPIO_PD1, GPIO_PD2, GPIO_PD3, GPIO_PD4, GPIO_PD5, GPIO_PD6,
+	GPIO_PD7, GPIO_PE11, GPIO_PE12, GPIO_PE13,
+};
+
+static const unsigned ppi1_16b_pins[] = {
+	GPIO_PD0, GPIO_PD1, GPIO_PD2, GPIO_PD3, GPIO_PD4, GPIO_PD5, GPIO_PD6,
+	GPIO_PD7, GPIO_PD8, GPIO_PD9, GPIO_PD10, GPIO_PD11, GPIO_PD12,
+	GPIO_PD13, GPIO_PD14, GPIO_PD15,
+	GPIO_PE11, GPIO_PE12, GPIO_PE13,
+};
+
+static const unsigned ppi2_8b_pins[] = {
+	GPIO_PD8, GPIO_PD9, GPIO_PD10, GPIO_PD11, GPIO_PD12,
+	GPIO_PD13, GPIO_PD14, GPIO_PD15,
+	GPIO_PA7, GPIO_PB0, GPIO_PB1, GPIO_PB2, GPIO_PB3,
+};
+
+static const unsigned atapi_pins[] = {
+	GPIO_PH2, GPIO_PJ3, GPIO_PJ4, GPIO_PJ5, GPIO_PJ6,
+	GPIO_PJ7, GPIO_PJ8, GPIO_PJ9, GPIO_PJ10,
+	GPIO_PG5, GPIO_PG6, GPIO_PG7,
+#ifdef CONFIG_BF548_ATAPI_ALTERNATIVE_PORT
+	GPIO_PF0, GPIO_PF1, GPIO_PF2, GPIO_PF3, GPIO_PF4, GPIO_PF5, GPIO_PF6,
+	GPIO_PF7, GPIO_PF8, GPIO_PF9, GPIO_PF10, GPIO_PF11, GPIO_PF12,
+	GPIO_PF13, GPIO_PF14, GPIO_PF15, GPIO_PG2, GPIO_PG3, GPIO_PG4,
+#endif
+};
+
+static const unsigned nfc0_pins[] = {
+	GPIO_PJ1, GPIO_PJ2,
+};
+
+static const unsigned keys_4x4_pins[] = {
+	GPIO_PD8, GPIO_PD9, GPIO_PD10, GPIO_PD11,
+	GPIO_PD12, GPIO_PD13, GPIO_PD14, GPIO_PD15,
+};
+
+static const unsigned keys_8x8_pins[] = {
+	GPIO_PD8, GPIO_PD9, GPIO_PD10, GPIO_PD11,
+	GPIO_PD12, GPIO_PD13, GPIO_PD14, GPIO_PD15,
+	GPIO_PE0, GPIO_PE1, GPIO_PE2, GPIO_PE3,
+	GPIO_PE4, GPIO_PE5, GPIO_PE6, GPIO_PE7,
+};
+
+static const struct adi_pin_group adi_pin_groups[] = {
+	ADI_PIN_GROUP("uart0grp", uart0_pins),
+	ADI_PIN_GROUP("uart1grp", uart1_pins),
+	ADI_PIN_GROUP("rsi0grp", rsi0_pins),
+	ADI_PIN_GROUP("spi0grp", spi0_pins),
+	ADI_PIN_GROUP("spi1grp", spi1_pins),
+	ADI_PIN_GROUP("twi0grp", twi0_pins),
+	ADI_PIN_GROUP("twi1grp", twi1_pins),
+	ADI_PIN_GROUP("rotarygrp", rotary_pins),
+	ADI_PIN_GROUP("can0grp", can0_pins),
+	ADI_PIN_GROUP("can1grp", can1_pins),
+	ADI_PIN_GROUP("smc0grp", smc0_pins),
+	ADI_PIN_GROUP("sport0grp", sport0_pins),
+	ADI_PIN_GROUP("sport1grp", sport1_pins),
+	ADI_PIN_GROUP("sport2grp", sport2_pins),
+	ADI_PIN_GROUP("sport3grp", sport3_pins),
+	ADI_PIN_GROUP("ppi0_8bgrp", ppi0_8b_pins),
+	ADI_PIN_GROUP("ppi0_16bgrp", ppi0_16b_pins),
+	ADI_PIN_GROUP("ppi0_24bgrp", ppi0_24b_pins),
+	ADI_PIN_GROUP("ppi1_8bgrp", ppi1_8b_pins),
+	ADI_PIN_GROUP("ppi1_16bgrp", ppi1_16b_pins),
+	ADI_PIN_GROUP("ppi2_8bgrp", ppi2_8b_pins),
+	ADI_PIN_GROUP("atapigrp", atapi_pins),
+	ADI_PIN_GROUP("nfc0grp", nfc0_pins),
+	ADI_PIN_GROUP("keys_4x4grp", keys_4x4_pins),
+	ADI_PIN_GROUP("keys_8x8grp", keys_8x8_pins),
+};
+
+static const unsigned short uart0_mux[] = {
+	P_UART0_TX, P_UART0_RX,
+	0
+};
+
+static const unsigned short uart1_mux[] = {
+	P_UART1_TX, P_UART1_RX,
+#ifdef CONFIG_BFIN_UART1_CTSRTS
+	P_UART1_RTS, P_UART1_CTS,
+#endif
+	0
+};
+
+static const unsigned short uart2_mux[] = {
+	P_UART2_TX, P_UART2_RX,
+	0
+};
+
+static const unsigned short uart3_mux[] = {
+	P_UART3_TX, P_UART3_RX,
+#ifdef CONFIG_BFIN_UART3_CTSRTS
+	P_UART3_RTS, P_UART3_CTS,
+#endif
+	0
+};
+
+static const unsigned short rsi0_mux[] = {
+	P_SD_D0, P_SD_D1, P_SD_D2, P_SD_D3, P_SD_CLK, P_SD_CMD,
+	0
+};
+
+static const unsigned short spi0_mux[] = {
+	P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0
+};
+
+static const unsigned short spi1_mux[] = {
+	P_SPI1_SCK, P_SPI1_MISO, P_SPI1_MOSI, 0
+};
+
+static const unsigned short twi0_mux[] = {
+	P_TWI0_SCL, P_TWI0_SDA, 0
+};
+
+static const unsigned short twi1_mux[] = {
+	P_TWI1_SCL, P_TWI1_SDA, 0
+};
+
+static const unsigned short rotary_mux[] = {
+	P_CNT_CUD, P_CNT_CDG, P_CNT_CZM, 0
+};
+
+static const unsigned short sport0_mux[] = {
+	P_SPORT0_TFS, P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS,
+	P_SPORT0_DRPRI, P_SPORT0_RSCLK, 0
+};
+
+static const unsigned short sport1_mux[] = {
+	P_SPORT1_TFS, P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS,
+	P_SPORT1_DRPRI, P_SPORT1_RSCLK, 0
+};
+
+static const unsigned short sport2_mux[] = {
+	P_SPORT2_TFS, P_SPORT2_DTPRI, P_SPORT2_TSCLK, P_SPORT2_RFS,
+	P_SPORT2_DRPRI, P_SPORT2_RSCLK, 0
+};
+
+static const unsigned short sport3_mux[] = {
+	P_SPORT3_TFS, P_SPORT3_DTPRI, P_SPORT3_TSCLK, P_SPORT3_RFS,
+	P_SPORT3_DRPRI, P_SPORT3_RSCLK, 0
+};
+
+static const unsigned short can0_mux[] = {
+	P_CAN0_RX, P_CAN0_TX, 0
+};
+
+static const unsigned short can1_mux[] = {
+	P_CAN1_RX, P_CAN1_TX, 0
+};
+
+static const unsigned short smc0_mux[] = {
+	P_A4, P_A5, P_A6, P_A7, P_A8, P_A9, P_A10, P_A11, P_A12,
+	P_A13, P_A14, P_A15, P_A16, P_A17, P_A18, P_A19, P_A20, P_A21,
+	P_A22, P_A23, P_A24, P_A25, P_NOR_CLK, 0,
+};
+
+static const unsigned short ppi0_8b_mux[] = {
+	P_PPI0_D0, P_PPI0_D1, P_PPI0_D2, P_PPI0_D3,
+	P_PPI0_D4, P_PPI0_D5, P_PPI0_D6, P_PPI0_D7,
+	P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
+	0,
+};
+
+static const unsigned short ppi0_16b_mux[] = {
+	P_PPI0_D0, P_PPI0_D1, P_PPI0_D2, P_PPI0_D3,
+	P_PPI0_D4, P_PPI0_D5, P_PPI0_D6, P_PPI0_D7,
+	P_PPI0_D8, P_PPI0_D9, P_PPI0_D10, P_PPI0_D11,
+	P_PPI0_D12, P_PPI0_D13, P_PPI0_D14, P_PPI0_D15,
+	P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
+	0,
+};
+
+static const unsigned short ppi0_24b_mux[] = {
+	P_PPI0_D0, P_PPI0_D1, P_PPI0_D2, P_PPI0_D3,
+	P_PPI0_D4, P_PPI0_D5, P_PPI0_D6, P_PPI0_D7,
+	P_PPI0_D8, P_PPI0_D9, P_PPI0_D10, P_PPI0_D11,
+	P_PPI0_D12, P_PPI0_D13, P_PPI0_D14, P_PPI0_D15,
+	P_PPI0_D16, P_PPI0_D17, P_PPI0_D18, P_PPI0_D19,
+	P_PPI0_D20, P_PPI0_D21, P_PPI0_D22, P_PPI0_D23,
+	P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
+	0,
+};
+
+static const unsigned short ppi1_8b_mux[] = {
+	P_PPI1_D0, P_PPI1_D1, P_PPI1_D2, P_PPI1_D3,
+	P_PPI1_D4, P_PPI1_D5, P_PPI1_D6, P_PPI1_D7,
+	P_PPI1_CLK, P_PPI1_FS1, P_PPI1_FS2,
+	0,
+};
+
+static const unsigned short ppi1_16b_mux[] = {
+	P_PPI1_D0, P_PPI1_D1, P_PPI1_D2, P_PPI1_D3,
+	P_PPI1_D4, P_PPI1_D5, P_PPI1_D6, P_PPI1_D7,
+	P_PPI1_D8, P_PPI1_D9, P_PPI1_D10, P_PPI1_D11,
+	P_PPI1_D12, P_PPI1_D13, P_PPI1_D14, P_PPI1_D15,
+	P_PPI1_CLK, P_PPI1_FS1, P_PPI1_FS2,
+	0,
+};
+
+static const unsigned short ppi2_8b_mux[] = {
+	P_PPI2_D0, P_PPI2_D1, P_PPI2_D2, P_PPI2_D3,
+	P_PPI2_D4, P_PPI2_D5, P_PPI2_D6, P_PPI2_D7,
+	P_PPI2_CLK, P_PPI2_FS1, P_PPI2_FS2,
+	0,
+};
+
+static const unsigned short atapi_mux[] = {
+	P_ATAPI_RESET, P_ATAPI_DIOR, P_ATAPI_DIOW, P_ATAPI_CS0, P_ATAPI_CS1,
+	P_ATAPI_DMACK, P_ATAPI_DMARQ, P_ATAPI_INTRQ, P_ATAPI_IORDY,
+	P_ATAPI_D0A, P_ATAPI_D1A, P_ATAPI_D2A, P_ATAPI_D3A, P_ATAPI_D4A,
+	P_ATAPI_D5A, P_ATAPI_D6A, P_ATAPI_D7A, P_ATAPI_D8A, P_ATAPI_D9A,
+	P_ATAPI_D10A, P_ATAPI_D11A, P_ATAPI_D12A, P_ATAPI_D13A, P_ATAPI_D14A,
+	P_ATAPI_D15A, P_ATAPI_A0A, P_ATAPI_A1A, P_ATAPI_A2A,
+	0
+};
+
+static const unsigned short nfc0_mux[] = {
+	P_NAND_CE, P_NAND_RB,
+	0
+};
+
+static const unsigned short keys_4x4_mux[] = {
+	P_KEY_ROW3, P_KEY_ROW2, P_KEY_ROW1, P_KEY_ROW0,
+	P_KEY_COL3, P_KEY_COL2, P_KEY_COL1, P_KEY_COL0,
+	0
+};
+
+static const unsigned short keys_8x8_mux[] = {
+	P_KEY_ROW7, P_KEY_ROW6, P_KEY_ROW5, P_KEY_ROW4,
+	P_KEY_ROW3, P_KEY_ROW2, P_KEY_ROW1, P_KEY_ROW0,
+	P_KEY_COL7, P_KEY_COL6, P_KEY_COL5, P_KEY_COL4,
+	P_KEY_COL3, P_KEY_COL2, P_KEY_COL1, P_KEY_COL0,
+	0
+};
+
+static const char * const uart0grp[] = { "uart0grp" };
+static const char * const uart1grp[] = { "uart1grp" };
+static const char * const uart2grp[] = { "uart2grp" };
+static const char * const uart3grp[] = { "uart3grp" };
+static const char * const rsi0grp[] = { "rsi0grp" };
+static const char * const spi0grp[] = { "spi0grp" };
+static const char * const spi1grp[] = { "spi1grp" };
+static const char * const twi0grp[] = { "twi0grp" };
+static const char * const twi1grp[] = { "twi1grp" };
+static const char * const rotarygrp[] = { "rotarygrp" };
+static const char * const can0grp[] = { "can0grp" };
+static const char * const can1grp[] = { "can1grp" };
+static const char * const smc0grp[] = { "smc0grp" };
+static const char * const sport0grp[] = { "sport0grp" };
+static const char * const sport1grp[] = { "sport1grp" };
+static const char * const sport2grp[] = { "sport2grp" };
+static const char * const sport3grp[] = { "sport3grp" };
+static const char * const ppi0_8bgrp[] = { "ppi0_8bgrp" };
+static const char * const ppi0_16bgrp[] = { "ppi0_16bgrp" };
+static const char * const ppi0_24bgrp[] = { "ppi0_24bgrp" };
+static const char * const ppi1_8bgrp[] = { "ppi1_8bgrp" };
+static const char * const ppi1_16bgrp[] = { "ppi1_16bgrp" };
+static const char * const ppi2_8bgrp[] = { "ppi2_8bgrp" };
+static const char * const atapigrp[] = { "atapigrp" };
+static const char * const nfc0grp[] = { "nfc0grp" };
+static const char * const keys_4x4grp[] = { "keys_4x4grp" };
+static const char * const keys_8x8grp[] = { "keys_8x8grp" };
+
+static const struct adi_pmx_func adi_pmx_functions[] = {
+	ADI_PMX_FUNCTION("uart0", uart0grp, uart0_mux),
+	ADI_PMX_FUNCTION("uart1", uart1grp, uart1_mux),
+	ADI_PMX_FUNCTION("uart2", uart0grp, uart2_mux),
+	ADI_PMX_FUNCTION("uart3", uart1grp, uart3_mux),
+	ADI_PMX_FUNCTION("rsi0", rsi0grp, rsi0_mux),
+	ADI_PMX_FUNCTION("spi0", spi0grp, spi0_mux),
+	ADI_PMX_FUNCTION("spi1", spi1grp, spi1_mux),
+	ADI_PMX_FUNCTION("twi0", twi0grp, twi0_mux),
+	ADI_PMX_FUNCTION("twi1", twi1grp, twi1_mux),
+	ADI_PMX_FUNCTION("rotary", rotarygrp, rotary_mux),
+	ADI_PMX_FUNCTION("can0", can0grp, can0_mux),
+	ADI_PMX_FUNCTION("can1", can1grp, can1_mux),
+	ADI_PMX_FUNCTION("smc0", smc0grp, smc0_mux),
+	ADI_PMX_FUNCTION("sport0", sport0grp, sport0_mux),
+	ADI_PMX_FUNCTION("sport1", sport1grp, sport1_mux),
+	ADI_PMX_FUNCTION("sport2", sport2grp, sport2_mux),
+	ADI_PMX_FUNCTION("sport3", sport3grp, sport3_mux),
+	ADI_PMX_FUNCTION("ppi0_8b", ppi0_8bgrp, ppi0_8b_mux),
+	ADI_PMX_FUNCTION("ppi0_16b", ppi0_16bgrp, ppi0_16b_mux),
+	ADI_PMX_FUNCTION("ppi0_24b", ppi0_24bgrp, ppi0_24b_mux),
+	ADI_PMX_FUNCTION("ppi1_8b", ppi1_8bgrp, ppi1_8b_mux),
+	ADI_PMX_FUNCTION("ppi1_16b", ppi1_16bgrp, ppi1_16b_mux),
+	ADI_PMX_FUNCTION("ppi2_8b", ppi2_8bgrp, ppi2_8b_mux),
+	ADI_PMX_FUNCTION("atapi", atapigrp, atapi_mux),
+	ADI_PMX_FUNCTION("nfc0", nfc0grp, nfc0_mux),
+	ADI_PMX_FUNCTION("keys_4x4", keys_4x4grp, keys_4x4_mux),
+	ADI_PMX_FUNCTION("keys_8x8", keys_8x8grp, keys_8x8_mux),
+};
+
+static const struct adi_pinctrl_soc_data adi_bf54x_soc = {
+	.functions = adi_pmx_functions,
+	.nfunctions = ARRAY_SIZE(adi_pmx_functions),
+	.groups = adi_pin_groups,
+	.ngroups = ARRAY_SIZE(adi_pin_groups),
+	.pins = adi_pads,
+	.npins = ARRAY_SIZE(adi_pads),
+};
+
+void adi_pinctrl_soc_init(const struct adi_pinctrl_soc_data **soc)
+{
+	*soc = &adi_bf54x_soc;
+}
diff --git a/drivers/pinctrl/pinctrl-adi2-bf60x.c b/drivers/pinctrl/pinctrl-adi2-bf60x.c
new file mode 100644
index 0000000..b5ca703
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-adi2-bf60x.c
@@ -0,0 +1,454 @@
+/*
+ * Pinctrl Driver for ADI GPIO2 controller
+ *
+ * Copyright 2007-2013 Analog Devices Inc.
+ *
+ * Licensed under the GPLv2 or later
+ */
+
+#include <asm/portmux.h>
+#include "pinctrl-adi2.h"
+
+static const struct pinctrl_pin_desc adi_pads[] = {
+	PINCTRL_PIN(0, "PA0"),
+	PINCTRL_PIN(1, "PA1"),
+	PINCTRL_PIN(2, "PA2"),
+	PINCTRL_PIN(3, "PG3"),
+	PINCTRL_PIN(4, "PA4"),
+	PINCTRL_PIN(5, "PA5"),
+	PINCTRL_PIN(6, "PA6"),
+	PINCTRL_PIN(7, "PA7"),
+	PINCTRL_PIN(8, "PA8"),
+	PINCTRL_PIN(9, "PA9"),
+	PINCTRL_PIN(10, "PA10"),
+	PINCTRL_PIN(11, "PA11"),
+	PINCTRL_PIN(12, "PA12"),
+	PINCTRL_PIN(13, "PA13"),
+	PINCTRL_PIN(14, "PA14"),
+	PINCTRL_PIN(15, "PA15"),
+	PINCTRL_PIN(16, "PB0"),
+	PINCTRL_PIN(17, "PB1"),
+	PINCTRL_PIN(18, "PB2"),
+	PINCTRL_PIN(19, "PB3"),
+	PINCTRL_PIN(20, "PB4"),
+	PINCTRL_PIN(21, "PB5"),
+	PINCTRL_PIN(22, "PB6"),
+	PINCTRL_PIN(23, "PB7"),
+	PINCTRL_PIN(24, "PB8"),
+	PINCTRL_PIN(25, "PB9"),
+	PINCTRL_PIN(26, "PB10"),
+	PINCTRL_PIN(27, "PB11"),
+	PINCTRL_PIN(28, "PB12"),
+	PINCTRL_PIN(29, "PB13"),
+	PINCTRL_PIN(30, "PB14"),
+	PINCTRL_PIN(31, "PB15"),
+	PINCTRL_PIN(32, "PC0"),
+	PINCTRL_PIN(33, "PC1"),
+	PINCTRL_PIN(34, "PC2"),
+	PINCTRL_PIN(35, "PC3"),
+	PINCTRL_PIN(36, "PC4"),
+	PINCTRL_PIN(37, "PC5"),
+	PINCTRL_PIN(38, "PC6"),
+	PINCTRL_PIN(39, "PC7"),
+	PINCTRL_PIN(40, "PC8"),
+	PINCTRL_PIN(41, "PC9"),
+	PINCTRL_PIN(42, "PC10"),
+	PINCTRL_PIN(43, "PC11"),
+	PINCTRL_PIN(44, "PC12"),
+	PINCTRL_PIN(45, "PC13"),
+	PINCTRL_PIN(46, "PC14"),
+	PINCTRL_PIN(47, "PC15"),
+	PINCTRL_PIN(48, "PD0"),
+	PINCTRL_PIN(49, "PD1"),
+	PINCTRL_PIN(50, "PD2"),
+	PINCTRL_PIN(51, "PD3"),
+	PINCTRL_PIN(52, "PD4"),
+	PINCTRL_PIN(53, "PD5"),
+	PINCTRL_PIN(54, "PD6"),
+	PINCTRL_PIN(55, "PD7"),
+	PINCTRL_PIN(56, "PD8"),
+	PINCTRL_PIN(57, "PD9"),
+	PINCTRL_PIN(58, "PD10"),
+	PINCTRL_PIN(59, "PD11"),
+	PINCTRL_PIN(60, "PD12"),
+	PINCTRL_PIN(61, "PD13"),
+	PINCTRL_PIN(62, "PD14"),
+	PINCTRL_PIN(63, "PD15"),
+	PINCTRL_PIN(64, "PE0"),
+	PINCTRL_PIN(65, "PE1"),
+	PINCTRL_PIN(66, "PE2"),
+	PINCTRL_PIN(67, "PE3"),
+	PINCTRL_PIN(68, "PE4"),
+	PINCTRL_PIN(69, "PE5"),
+	PINCTRL_PIN(70, "PE6"),
+	PINCTRL_PIN(71, "PE7"),
+	PINCTRL_PIN(72, "PE8"),
+	PINCTRL_PIN(73, "PE9"),
+	PINCTRL_PIN(74, "PE10"),
+	PINCTRL_PIN(75, "PE11"),
+	PINCTRL_PIN(76, "PE12"),
+	PINCTRL_PIN(77, "PE13"),
+	PINCTRL_PIN(78, "PE14"),
+	PINCTRL_PIN(79, "PE15"),
+	PINCTRL_PIN(80, "PF0"),
+	PINCTRL_PIN(81, "PF1"),
+	PINCTRL_PIN(82, "PF2"),
+	PINCTRL_PIN(83, "PF3"),
+	PINCTRL_PIN(84, "PF4"),
+	PINCTRL_PIN(85, "PF5"),
+	PINCTRL_PIN(86, "PF6"),
+	PINCTRL_PIN(87, "PF7"),
+	PINCTRL_PIN(88, "PF8"),
+	PINCTRL_PIN(89, "PF9"),
+	PINCTRL_PIN(90, "PF10"),
+	PINCTRL_PIN(91, "PF11"),
+	PINCTRL_PIN(92, "PF12"),
+	PINCTRL_PIN(93, "PF13"),
+	PINCTRL_PIN(94, "PF14"),
+	PINCTRL_PIN(95, "PF15"),
+	PINCTRL_PIN(96, "PG0"),
+	PINCTRL_PIN(97, "PG1"),
+	PINCTRL_PIN(98, "PG2"),
+	PINCTRL_PIN(99, "PG3"),
+	PINCTRL_PIN(100, "PG4"),
+	PINCTRL_PIN(101, "PG5"),
+	PINCTRL_PIN(102, "PG6"),
+	PINCTRL_PIN(103, "PG7"),
+	PINCTRL_PIN(104, "PG8"),
+	PINCTRL_PIN(105, "PG9"),
+	PINCTRL_PIN(106, "PG10"),
+	PINCTRL_PIN(107, "PG11"),
+	PINCTRL_PIN(108, "PG12"),
+	PINCTRL_PIN(109, "PG13"),
+	PINCTRL_PIN(110, "PG14"),
+	PINCTRL_PIN(111, "PG15"),
+};
+
+static const unsigned uart0_pins[] = {
+	GPIO_PD7, GPIO_PD8,
+#ifdef CONFIG_BFIN_UART0_CTSRTS
+	GPIO_PD9, GPIO_PD10,
+#endif
+};
+
+static const unsigned uart1_pins[] = {
+	GPIO_PG15, GPIO_PG14,
+#ifdef CONFIG_BFIN_UART1_CTSRTS
+	GPIO_PG10, GPIO_PG13,
+#endif
+};
+
+static const unsigned rsi0_pins[] = {
+	GPIO_PG3, GPIO_PG2, GPIO_PG0, GPIO_PE15, GPIO_PG5, GPIO_PG6,
+};
+
+static const unsigned eth0_pins[] = {
+	GPIO_PC6, GPIO_PC7, GPIO_PC2, GPIO_PC0, GPIO_PC3, GPIO_PC1,
+	GPIO_PB13, GPIO_PD6, GPIO_PC5, GPIO_PC4, GPIO_PB14,
+};
+
+static const unsigned eth1_pins[] = {
+	GPIO_PE10, GPIO_PE11, GPIO_PG3, GPIO_PG0, GPIO_PG2, GPIO_PE15,
+	GPIO_PG5, GPIO_PE12, GPIO_PE13, GPIO_PE14, GPIO_PG6,
+};
+
+static const unsigned spi0_pins[] = {
+	GPIO_PD4, GPIO_PD2, GPIO_PD3,
+};
+
+static const unsigned spi1_pins[] = {
+	GPIO_PD5, GPIO_PD14, GPIO_PD13,
+};
+
+static const unsigned twi0_pins[] = {
+};
+
+static const unsigned twi1_pins[] = {
+};
+
+static const unsigned rotary_pins[] = {
+	GPIO_PG7, GPIO_PG11, GPIO_PG12,
+};
+
+static const unsigned can0_pins[] = {
+	GPIO_PG1, GPIO_PG4,
+};
+
+static const unsigned smc0_pins[] = {
+	GPIO_PA0, GPIO_PA1, GPIO_PA2, GPIO_PA3, GPIO_PA4, GPIO_PA5, GPIO_PA6,
+	GPIO_PA7, GPIO_PA8, GPIO_PA9, GPIO_PB2, GPIO_PA10, GPIO_PA11,
+	GPIO_PB3, GPIO_PA12, GPIO_PA13, GPIO_PA14, GPIO_PA15, GPIO_PB6,
+	GPIO_PB7, GPIO_PB8, GPIO_PB10, GPIO_PB11, GPIO_PB0,
+};
+
+static const unsigned sport0_pins[] = {
+	GPIO_PB5, GPIO_PB4, GPIO_PB9, GPIO_PB8, GPIO_PB7, GPIO_PB11,
+};
+
+static const unsigned sport1_pins[] = {
+	GPIO_PE2, GPIO_PE5, GPIO_PD15, GPIO_PE4, GPIO_PE3, GPIO_PE1,
+};
+
+static const unsigned sport2_pins[] = {
+	GPIO_PG4, GPIO_PG1, GPIO_PG9, GPIO_PG10, GPIO_PG7, GPIO_PB12,
+};
+
+static const unsigned ppi0_8b_pins[] = {
+	GPIO_PF0, GPIO_PF1, GPIO_PF2, GPIO_PF3, GPIO_PF4, GPIO_PF5, GPIO_PF6,
+	GPIO_PF7, GPIO_PF13, GPIO_PF14, GPIO_PF15,
+	GPIO_PE6, GPIO_PE7, GPIO_PE8, GPIO_PE9,
+};
+
+static const unsigned ppi0_16b_pins[] = {
+	GPIO_PF0, GPIO_PF1, GPIO_PF2, GPIO_PF3, GPIO_PF4, GPIO_PF5, GPIO_PF6,
+	GPIO_PF7, GPIO_PF9, GPIO_PF10, GPIO_PF11, GPIO_PF12,
+	GPIO_PF13, GPIO_PF14, GPIO_PF15,
+	GPIO_PE6, GPIO_PE7, GPIO_PE8, GPIO_PE9,
+};
+
+static const unsigned ppi0_24b_pins[] = {
+	GPIO_PF0, GPIO_PF1, GPIO_PF2, GPIO_PF3, GPIO_PF4, GPIO_PF5, GPIO_PF6,
+	GPIO_PF7, GPIO_PF8, GPIO_PF9, GPIO_PF10, GPIO_PF11, GPIO_PF12,
+	GPIO_PF13, GPIO_PF14, GPIO_PF15, GPIO_PE0, GPIO_PE1, GPIO_PE2,
+	GPIO_PE3, GPIO_PE4, GPIO_PE5, GPIO_PE6, GPIO_PE7, GPIO_PE8,
+	GPIO_PE9, GPIO_PD12, GPIO_PD15,
+};
+
+static const unsigned ppi1_8b_pins[] = {
+	GPIO_PC0, GPIO_PC1, GPIO_PC2, GPIO_PC3, GPIO_PC4, GPIO_PC5, GPIO_PC6,
+	GPIO_PC7, GPIO_PC8, GPIO_PB13, GPIO_PB14, GPIO_PB15, GPIO_PD6,
+};
+
+static const unsigned ppi1_16b_pins[] = {
+	GPIO_PC0, GPIO_PC1, GPIO_PC2, GPIO_PC3, GPIO_PC4, GPIO_PC5, GPIO_PC6,
+	GPIO_PC7, GPIO_PC9, GPIO_PC10, GPIO_PC11, GPIO_PC12,
+	GPIO_PC13, GPIO_PC14, GPIO_PC15,
+	GPIO_PB13, GPIO_PB14, GPIO_PB15, GPIO_PD6,
+};
+
+static const unsigned ppi2_8b_pins[] = {
+	GPIO_PA0, GPIO_PA1, GPIO_PA2, GPIO_PA3, GPIO_PA4, GPIO_PA5, GPIO_PA6,
+	GPIO_PA7, GPIO_PB0, GPIO_PB1, GPIO_PB2, GPIO_PB3,
+};
+
+static const unsigned ppi2_16b_pins[] = {
+	GPIO_PA0, GPIO_PA1, GPIO_PA2, GPIO_PA3, GPIO_PA4, GPIO_PA5, GPIO_PA6,
+	GPIO_PA7, GPIO_PA8, GPIO_PA9, GPIO_PA10, GPIO_PA11, GPIO_PA12,
+	GPIO_PA13, GPIO_PA14, GPIO_PA15,
+	GPIO_PA7, GPIO_PB0, GPIO_PB1, GPIO_PB2, GPIO_PB3,
+};
+
+static const struct adi_pin_group adi_pin_groups[] = {
+	ADI_PIN_GROUP("uart0grp", uart0_pins),
+	ADI_PIN_GROUP("uart1grp", uart1_pins),
+	ADI_PIN_GROUP("rsi0grp", rsi0_pins),
+	ADI_PIN_GROUP("eth0grp", eth0_pins),
+	ADI_PIN_GROUP("eth1grp", eth1_pins),
+	ADI_PIN_GROUP("spi0grp", spi0_pins),
+	ADI_PIN_GROUP("spi1grp", spi1_pins),
+	ADI_PIN_GROUP("twi0grp", twi0_pins),
+	ADI_PIN_GROUP("twi1grp", twi1_pins),
+	ADI_PIN_GROUP("rotarygrp", rotary_pins),
+	ADI_PIN_GROUP("can0grp", can0_pins),
+	ADI_PIN_GROUP("smc0grp", smc0_pins),
+	ADI_PIN_GROUP("sport0grp", sport0_pins),
+	ADI_PIN_GROUP("sport1grp", sport1_pins),
+	ADI_PIN_GROUP("sport2grp", sport2_pins),
+	ADI_PIN_GROUP("ppi0_8bgrp", ppi0_8b_pins),
+	ADI_PIN_GROUP("ppi0_16bgrp", ppi0_16b_pins),
+	ADI_PIN_GROUP("ppi0_24bgrp", ppi0_24b_pins),
+	ADI_PIN_GROUP("ppi1_8bgrp", ppi1_8b_pins),
+	ADI_PIN_GROUP("ppi1_16bgrp", ppi1_16b_pins),
+	ADI_PIN_GROUP("ppi2_8bgrp", ppi2_8b_pins),
+	ADI_PIN_GROUP("ppi2_16bgrp", ppi2_16b_pins),
+};
+
+static const unsigned short uart0_mux[] = {
+	P_UART0_TX, P_UART0_RX,
+#ifdef CONFIG_BFIN_UART0_CTSRTS
+	P_UART0_RTS, P_UART0_CTS,
+#endif
+	0
+};
+
+static const unsigned short uart1_mux[] = {
+	P_UART1_TX, P_UART1_RX,
+#ifdef CONFIG_BFIN_UART1_CTSRTS
+	P_UART1_RTS, P_UART1_CTS,
+#endif
+	0
+};
+
+static const unsigned short rsi0_mux[] = {
+	P_RSI_DATA0, P_RSI_DATA1, P_RSI_DATA2, P_RSI_DATA3,
+	P_RSI_CMD, P_RSI_CLK, 0
+};
+
+static const unsigned short eth0_mux[] = P_RMII0;
+static const unsigned short eth1_mux[] = P_RMII1;
+
+static const unsigned short spi0_mux[] = {
+	P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0
+};
+
+static const unsigned short spi1_mux[] = {
+	P_SPI1_SCK, P_SPI1_MISO, P_SPI1_MOSI, 0
+};
+
+static const unsigned short twi0_mux[] = {
+	P_TWI0_SCL, P_TWI0_SDA, 0
+};
+
+static const unsigned short twi1_mux[] = {
+	P_TWI1_SCL, P_TWI1_SDA, 0
+};
+
+static const unsigned short rotary_mux[] = {
+	P_CNT_CUD, P_CNT_CDG, P_CNT_CZM, 0
+};
+
+static const unsigned short sport0_mux[] = {
+	P_SPORT0_ACLK, P_SPORT0_AFS, P_SPORT0_AD0, P_SPORT0_BCLK,
+	P_SPORT0_BFS, P_SPORT0_BD0, 0,
+};
+
+static const unsigned short sport1_mux[] = {
+	P_SPORT1_ACLK, P_SPORT1_AFS, P_SPORT1_AD0, P_SPORT1_BCLK,
+	P_SPORT1_BFS, P_SPORT1_BD0, 0,
+};
+
+static const unsigned short sport2_mux[] = {
+	P_SPORT2_ACLK, P_SPORT2_AFS, P_SPORT2_AD0, P_SPORT2_BCLK,
+	P_SPORT2_BFS, P_SPORT2_BD0, 0,
+};
+
+static const unsigned short can0_mux[] = {
+	P_CAN0_RX, P_CAN0_TX, 0
+};
+
+static const unsigned short smc0_mux[] = {
+	P_A3, P_A4, P_A5, P_A6, P_A7, P_A8, P_A9, P_A10, P_A11, P_A12,
+	P_A13, P_A14, P_A15, P_A16, P_A17, P_A18, P_A19, P_A20, P_A21,
+	P_A22, P_A23, P_A24, P_A25, P_NORCK, 0,
+};
+
+static const unsigned short ppi0_8b_mux[] = {
+	P_PPI0_D0, P_PPI0_D1, P_PPI0_D2, P_PPI0_D3,
+	P_PPI0_D4, P_PPI0_D5, P_PPI0_D6, P_PPI0_D7,
+	P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
+	0,
+};
+
+static const unsigned short ppi0_16b_mux[] = {
+	P_PPI0_D0, P_PPI0_D1, P_PPI0_D2, P_PPI0_D3,
+	P_PPI0_D4, P_PPI0_D5, P_PPI0_D6, P_PPI0_D7,
+	P_PPI0_D8, P_PPI0_D9, P_PPI0_D10, P_PPI0_D11,
+	P_PPI0_D12, P_PPI0_D13, P_PPI0_D14, P_PPI0_D15,
+	P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
+	0,
+};
+
+static const unsigned short ppi0_24b_mux[] = {
+	P_PPI0_D0, P_PPI0_D1, P_PPI0_D2, P_PPI0_D3,
+	P_PPI0_D4, P_PPI0_D5, P_PPI0_D6, P_PPI0_D7,
+	P_PPI0_D8, P_PPI0_D9, P_PPI0_D10, P_PPI0_D11,
+	P_PPI0_D12, P_PPI0_D13, P_PPI0_D14, P_PPI0_D15,
+	P_PPI0_D16, P_PPI0_D17, P_PPI0_D18, P_PPI0_D19,
+	P_PPI0_D20, P_PPI0_D21, P_PPI0_D22, P_PPI0_D23,
+	P_PPI0_CLK, P_PPI0_FS1, P_PPI0_FS2,
+	0,
+};
+
+static const unsigned short ppi1_8b_mux[] = {
+	P_PPI1_D0, P_PPI1_D1, P_PPI1_D2, P_PPI1_D3,
+	P_PPI1_D4, P_PPI1_D5, P_PPI1_D6, P_PPI1_D7,
+	P_PPI1_CLK, P_PPI1_FS1, P_PPI1_FS2,
+	0,
+};
+
+static const unsigned short ppi1_16b_mux[] = {
+	P_PPI1_D0, P_PPI1_D1, P_PPI1_D2, P_PPI1_D3,
+	P_PPI1_D4, P_PPI1_D5, P_PPI1_D6, P_PPI1_D7,
+	P_PPI1_D8, P_PPI1_D9, P_PPI1_D10, P_PPI1_D11,
+	P_PPI1_D12, P_PPI1_D13, P_PPI1_D14, P_PPI1_D15,
+	P_PPI1_CLK, P_PPI1_FS1, P_PPI1_FS2,
+	0,
+};
+
+static const unsigned short ppi2_8b_mux[] = {
+	P_PPI2_D0, P_PPI2_D1, P_PPI2_D2, P_PPI2_D3,
+	P_PPI2_D4, P_PPI2_D5, P_PPI2_D6, P_PPI2_D7,
+	P_PPI2_CLK, P_PPI2_FS1, P_PPI2_FS2,
+	0,
+};
+
+static const unsigned short ppi2_16b_mux[] = {
+	P_PPI2_D0, P_PPI2_D1, P_PPI2_D2, P_PPI2_D3,
+	P_PPI2_D4, P_PPI2_D5, P_PPI2_D6, P_PPI2_D7,
+	P_PPI2_D8, P_PPI2_D9, P_PPI2_D10, P_PPI2_D11,
+	P_PPI2_D12, P_PPI2_D13, P_PPI2_D14, P_PPI2_D15,
+	P_PPI2_CLK, P_PPI2_FS1, P_PPI2_FS2,
+	0,
+};
+
+static const char * const uart0grp[] = { "uart0grp" };
+static const char * const uart1grp[] = { "uart1grp" };
+static const char * const rsi0grp[] = { "rsi0grp" };
+static const char * const eth0grp[] = { "eth0grp" };
+static const char * const eth1grp[] = { "eth1grp" };
+static const char * const spi0grp[] = { "spi0grp" };
+static const char * const spi1grp[] = { "spi1grp" };
+static const char * const twi0grp[] = { "twi0grp" };
+static const char * const twi1grp[] = { "twi1grp" };
+static const char * const rotarygrp[] = { "rotarygrp" };
+static const char * const can0grp[] = { "can0grp" };
+static const char * const smc0grp[] = { "smc0grp" };
+static const char * const sport0grp[] = { "sport0grp" };
+static const char * const sport1grp[] = { "sport1grp" };
+static const char * const sport2grp[] = { "sport2grp" };
+static const char * const ppi0_8bgrp[] = { "ppi0_8bgrp" };
+static const char * const ppi0_16bgrp[] = { "ppi0_16bgrp" };
+static const char * const ppi0_24bgrp[] = { "ppi0_24bgrp" };
+static const char * const ppi1_8bgrp[] = { "ppi1_8bgrp" };
+static const char * const ppi1_16bgrp[] = { "ppi1_16bgrp" };
+static const char * const ppi2_8bgrp[] = { "ppi2_8bgrp" };
+static const char * const ppi2_16bgrp[] = { "ppi2_16bgrp" };
+
+static const struct adi_pmx_func adi_pmx_functions[] = {
+	ADI_PMX_FUNCTION("uart0", uart0grp, uart0_mux),
+	ADI_PMX_FUNCTION("uart1", uart1grp, uart1_mux),
+	ADI_PMX_FUNCTION("rsi0", rsi0grp, rsi0_mux),
+	ADI_PMX_FUNCTION("eth0", eth0grp, eth0_mux),
+	ADI_PMX_FUNCTION("eth1", eth1grp, eth1_mux),
+	ADI_PMX_FUNCTION("spi0", spi0grp, spi0_mux),
+	ADI_PMX_FUNCTION("spi1", spi1grp, spi1_mux),
+	ADI_PMX_FUNCTION("twi0", twi0grp, twi0_mux),
+	ADI_PMX_FUNCTION("twi1", twi1grp, twi1_mux),
+	ADI_PMX_FUNCTION("rotary", rotarygrp, rotary_mux),
+	ADI_PMX_FUNCTION("can0", can0grp, can0_mux),
+	ADI_PMX_FUNCTION("smc0", smc0grp, smc0_mux),
+	ADI_PMX_FUNCTION("sport0", sport0grp, sport0_mux),
+	ADI_PMX_FUNCTION("sport1", sport1grp, sport1_mux),
+	ADI_PMX_FUNCTION("sport2", sport2grp, sport2_mux),
+	ADI_PMX_FUNCTION("ppi0_8b", ppi0_8bgrp, ppi0_8b_mux),
+	ADI_PMX_FUNCTION("ppi0_16b", ppi0_16bgrp, ppi0_16b_mux),
+	ADI_PMX_FUNCTION("ppi0_24b", ppi0_24bgrp, ppi0_24b_mux),
+	ADI_PMX_FUNCTION("ppi1_8b", ppi1_8bgrp, ppi1_8b_mux),
+	ADI_PMX_FUNCTION("ppi1_16b", ppi1_16bgrp, ppi1_16b_mux),
+	ADI_PMX_FUNCTION("ppi2_8b", ppi2_8bgrp, ppi2_8b_mux),
+	ADI_PMX_FUNCTION("ppi2_16b", ppi2_16bgrp, ppi2_16b_mux),
+};
+
+static const struct adi_pinctrl_soc_data adi_bf60x_soc = {
+	.functions = adi_pmx_functions,
+	.nfunctions = ARRAY_SIZE(adi_pmx_functions),
+	.groups = adi_pin_groups,
+	.ngroups = ARRAY_SIZE(adi_pin_groups),
+	.pins = adi_pads,
+	.npins = ARRAY_SIZE(adi_pads),
+};
+
+void adi_pinctrl_soc_init(const struct adi_pinctrl_soc_data **soc)
+{
+	*soc = &adi_bf60x_soc;
+}
diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
new file mode 100644
index 0000000..3fa2b65
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-adi2.c
@@ -0,0 +1,1501 @@
+/*
+ * Pinctrl Driver for ADI GPIO2 controller
+ *
+ * Copyright 2007-2013 Analog Devices Inc.
+ *
+ * Licensed under the GPLv2 or later
+ */
+
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/irq.h>
+#include <linux/platform_data/pinctrl-adi2.h>
+#include <linux/irqdomain.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/machine.h>
+#include <linux/syscore_ops.h>
+#include <linux/gpio.h>
+#include <asm/portmux.h>
+#include "pinctrl-adi2.h"
+#include "core.h"
+
+/*
+According to the BF54x HRM, pint means "pin interrupt".
+http://www.analog.com/static/imported-files/processor_manuals/ADSP-BF54x_hwr_rev1.2.pdf
+
+ADSP-BF54x processor Blackfin processors have four SIC interrupt chan-
+nels dedicated to pin interrupt purposes. These channels are managed by
+four hardware blocks, called PINT0, PINT1, PINT2, and PINT3. Every PINTx
+block can sense to up to 32 pins. While PINT0 and PINT1 can sense the
+pins of port A and port B, PINT2 and PINT3 manage all the pins from port
+C to port J as shown in Figure 9-2.
+
+n BF54x HRM:
+The ten GPIO ports are subdivided into 8-bit half ports, resulting in lower and
+upper half 8-bit units. The PINTx_ASSIGN registers control the 8-bit multi-
+plexers shown in Figure 9-3. Lower half units of eight pins can be
+forwarded to either byte 0 or byte 2 of either associated PINTx block.
+Upper half units can be forwarded to either byte 1 or byte 3 of the pin
+interrupt blocks, without further restrictions.
+
+All MMR registers in the pin interrupt module are 32 bits wide. To simply the
+mapping logic, this driver only maps a 16-bit gpio port to the upper or lower
+16 bits of a PINTx block. You can find the Figure 9-3 on page 583.
+
+Each IRQ domain is binding to a GPIO bank device. 2 GPIO bank devices can map
+to one PINT device. Two in "struct gpio_pint" are used to ease the PINT
+interrupt handler.
+
+The GPIO bank mapping to the lower 16 bits of the PINT device set its IRQ
+domain pointer in domain[0]. The IRQ domain pointer of the other bank is set
+to domain[1]. PINT interrupt handler adi_gpio_handle_pint_irq() finds out
+the current domain pointer according to whether the interrupt request mask
+is in lower 16 bits (domain[0]) or upper 16bits (domain[1]).
+
+A PINT device is not part of a GPIO port device in Blackfin. Multiple GPIO
+port devices can be mapped to the same PINT device.
+
+*/
+
+static LIST_HEAD(adi_pint_list);
+static LIST_HEAD(adi_gpio_port_list);
+
+#define DRIVER_NAME "pinctrl-adi2"
+
+#define RESOURCE_LABEL_SIZE	16
+#define PINT_HI_OFFSET		16
+
+/**
+ * struct gpio_reserve_map - a GPIO map structure containing the
+ * reservation status of each PIN.
+ *
+ * @owner: who request the reservation
+ * @rsv_gpio: if this pin is reserved as GPIO
+ * @rsv_int: if this pin is reserved as interrupt
+ * @rsv_peri: if this pin is reserved as part of a peripheral device
+ */
+struct gpio_reserve_map {
+	unsigned char owner[RESOURCE_LABEL_SIZE];
+	bool rsv_gpio;
+	bool rsv_int;
+	bool rsv_peri;
+};
+
+/**
+ * struct gpio_port_saved - GPIO port registers that should be saved between
+ * power suspend and resume operations.
+ *
+ * @fer: PORTx_FER register
+ * @data: PORTx_DATA register
+ * @dir: PORTx_DIR register
+ * @inen: PORTx_INEN register
+ * @mux: PORTx_MUX register
+ */
+struct gpio_port_saved {
+	u16 fer;
+	u16 data;
+	u16 dir;
+	u16 inen;
+	u32 mux;
+};
+
+/**
+ * struct gpio_pint - Pin interrupt controller device. Multiple ADI GPIO
+ * banks can be mapped into one Pin interrupt controller.
+ *
+ * @node: All gpio_pint instances are added to a global list.
+ * @base: PINT device register base address
+ * @irq: IRQ of the PINT device, it is the parent IRQ of all
+ *       GPIO IRQs mapping to this device.
+ * @domain: [0] irq domain of the gpio port, whose hardware interrupts are
+ *		mapping to the low 16-bit of the pint registers.
+ *          [1] irq domain of the gpio port, whose hardware interrupts are
+ *		mapping to the high 16-bit of the pint registers.
+ * @regs: address pointer to the PINT device
+ * @map_count: No more than 2 GPIO banks can be mapped to this PINT device.
+ * @lock: This lock make sure the irq_chip operations to one PINT device
+ *        for different GPIO interrrupts are atomic.
+ * @pint_map_port: Set up the mapping between one PINT device and
+ *                 multiple GPIO banks.
+ */
+struct gpio_pint {
+	struct list_head node;
+	void __iomem *base;
+	int irq;
+	struct irq_domain *domain[2];
+	struct gpio_pint_regs *regs;
+	struct adi_pm_pint_save saved_data;
+	int map_count;
+	spinlock_t lock;
+
+	int (*pint_map_port)(struct gpio_pint *pint, bool assign,
+				u8 map, struct irq_domain *domain);
+};
+
+/**
+ * ADI pin controller
+ *
+ * @dev: a pointer back to containing device
+ * @pctl: the pinctrl device
+ * @soc: SoC data for this specific chip
+ */
+struct adi_pinctrl {
+	struct device *dev;
+	struct pinctrl_dev *pctl;
+	const struct adi_pinctrl_soc_data *soc;
+};
+
+/**
+ * struct gpio_port - GPIO bank device. Multiple ADI GPIO banks can be mapped
+ * into one pin interrupt controller.
+ *
+ * @node: All gpio_port instances are added to a list.
+ * @base: GPIO bank device register base address
+ * @irq_base: base IRQ of the GPIO bank device
+ * @width: PIN number of the GPIO bank device
+ * @regs: address pointer to the GPIO bank device
+ * @saved_data: registers that should be saved between PM operations.
+ * @dev: device structure of this GPIO bank
+ * @pint: GPIO PINT device that this GPIO bank mapped to
+ * @pint_map: GIOP bank mapping code in PINT device
+ * @pint_assign: The 32-bit PINT registers can be divided into 2 parts. A
+ *               GPIO bank can be mapped into either low 16 bits[0] or high 16
+ *               bits[1] of each PINT register.
+ * @lock: This lock make sure the irq_chip operations to one PINT device
+ *        for different GPIO interrrupts are atomic.
+ * @chip: abstract a GPIO controller
+ * @domain: The irq domain owned by the GPIO port.
+ * @rsvmap: Reservation map array for each pin in the GPIO bank
+ */
+struct gpio_port {
+	struct list_head node;
+	void __iomem *base;
+	unsigned int irq_base;
+	unsigned int width;
+	struct gpio_port_t *regs;
+	struct gpio_port_saved saved_data;
+	struct device *dev;
+
+	struct gpio_pint *pint;
+	u8 pint_map;
+	bool pint_assign;
+
+	spinlock_t lock;
+	struct gpio_chip chip;
+	struct irq_domain *domain;
+
+	struct gpio_reserve_map rsvmap[];
+};
+
+static inline u8 pin_to_offset(struct pinctrl_gpio_range *range, unsigned pin)
+{
+	return pin - range->pin_base;
+}
+
+static inline u32 hwirq_to_pintbit(struct gpio_port *port, int hwirq)
+{
+	return port->pint_assign ? BIT(hwirq) << PINT_HI_OFFSET : BIT(hwirq);
+}
+
+static void set_label(struct gpio_port *port, unsigned offset,
+	const char *label)
+{
+	char *pch = port->rsvmap[offset].owner;
+
+	if (label) {
+		strncpy(pch, label, RESOURCE_LABEL_SIZE);
+		pch[RESOURCE_LABEL_SIZE - 1] = 0;
+	}
+}
+
+static char *get_label(struct gpio_port *port, unsigned offset)
+{
+	char *pch = port->rsvmap[offset].owner;
+
+	return *pch ? pch : "UNKNOWN";
+}
+
+static struct gpio_pint *find_gpio_pint(unsigned id)
+{
+	struct gpio_pint *pint;
+	int i = 0;
+
+	list_for_each_entry(pint, &adi_pint_list, node) {
+		if (id == i)
+			return pint;
+		i++;
+	}
+
+	return NULL;
+}
+
+static inline void port_setup(struct gpio_port *port, unsigned offset,
+	bool use_for_gpio)
+{
+	struct gpio_port_t *regs = port->regs;
+
+	if (use_for_gpio)
+		writew(readw(&regs->port_fer) & ~BIT(offset),
+			&regs->port_fer);
+	else
+		writew(readw(&regs->port_fer) | BIT(offset), &regs->port_fer);
+}
+
+static inline void portmux_setup(struct gpio_port *port, unsigned offset,
+	unsigned short function)
+{
+	struct gpio_port_t *regs = port->regs;
+	u32 pmux;
+
+	pmux = readl(&regs->port_mux);
+
+	/* The function field of each pin has 2 consecutive bits in
+	 * the mux register.
+	 */
+	pmux &= ~(0x3 << (2 * offset));
+	pmux |= (function & 0x3) << (2 * offset);
+
+	writel(pmux, &regs->port_mux);
+}
+
+static inline u16 get_portmux(struct gpio_port *port, unsigned offset)
+{
+	struct gpio_port_t *regs = port->regs;
+	u32 pmux = readl(&regs->port_mux);
+
+	/* The function field of each pin has 2 consecutive bits in
+	 * the mux register.
+	 */
+	return pmux >> (2 * offset) & 0x3;
+}
+
+
+static void __adi_gpio_irq_prepare(struct gpio_port *port, unsigned offset)
+{
+	struct gpio_port_t *regs = port->regs;
+
+	port_setup(port, offset, true);
+
+	writew(BIT(offset), &regs->dir_clear);
+	writew(readw(&regs->inen) | BIT(offset), &regs->inen);
+}
+
+static int __adi_gpio_irq_request(struct gpio_port *port, unsigned offset,
+	const char *label)
+{
+	if (port->rsvmap[offset].rsv_peri) {
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
+
+		dev_err(port->dev,
+		       "GPIO %d is already reserved as Peripheral by %s !\n",
+			port->chip.base + offset, get_label(port, offset));
+		return -EBUSY;
+	}
+	if (port->rsvmap[offset].rsv_gpio)
+		dev_err(port->dev,
+			"GPIO %d is already reserved by %s!\n",
+			port->chip.base + offset, get_label(port, offset));
+
+	port->rsvmap[offset].rsv_int = true;
+	set_label(port, offset, label);
+	port_setup(port, offset, true);
+
+	return 0;
+}
+
+static void __adi_gpio_irq_free(struct gpio_port *port, unsigned offset)
+{
+	if (!port->rsvmap[offset].rsv_int) {
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
+
+		dev_err(port->dev, "GPIO %d wasn't requested!\n",
+			port->chip.base + offset);
+		return;
+	}
+
+	port->rsvmap[offset].rsv_int = false;
+	set_label(port, offset, "free");
+}
+
+static void adi_gpio_ack_irq(struct irq_data *d)
+{
+	unsigned long flags;
+	struct gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct gpio_pint_regs *regs = port->pint->regs;
+	unsigned pintbit = hwirq_to_pintbit(port, d->hwirq);
+
+	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->pint->lock, flags);
+
+	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
+		if (readl(&regs->invert_set) & pintbit)
+			writel(pintbit, &regs->invert_clear);
+		else
+			writel(pintbit, &regs->invert_set);
+	}
+
+	writel(pintbit, &regs->request);
+
+	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static void adi_gpio_mask_ack_irq(struct irq_data *d)
+{
+	unsigned long flags;
+	struct gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct gpio_pint_regs *regs = port->pint->regs;
+	unsigned pintbit = hwirq_to_pintbit(port, d->hwirq);
+
+	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->pint->lock, flags);
+
+	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
+		if (readl(&regs->invert_set) & pintbit)
+			writel(pintbit, &regs->invert_clear);
+		else
+			writel(pintbit, &regs->invert_set);
+	}
+
+	writel(pintbit, &regs->request);
+	writel(pintbit, &regs->mask_clear);
+
+	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static void adi_gpio_mask_irq(struct irq_data *d)
+{
+	unsigned long flags;
+	struct gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct gpio_pint_regs *regs = port->pint->regs;
+
+	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->pint->lock, flags);
+
+	writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_clear);
+
+	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static void adi_gpio_unmask_irq(struct irq_data *d)
+{
+	unsigned long flags;
+	struct gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct gpio_pint_regs *regs = port->pint->regs;
+
+	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->pint->lock, flags);
+
+	writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_set);
+
+	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static unsigned int adi_gpio_irq_startup(struct irq_data *d)
+{
+	unsigned long flags;
+	struct gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct gpio_pint_regs *regs = port->pint->regs;
+
+	if (!port) {
+		dev_err(port->dev, "GPIO IRQ %d :Not exist\n", d->irq);
+		return -ENODEV;
+	}
+
+	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->pint->lock, flags);
+
+	__adi_gpio_irq_prepare(port, d->hwirq);
+	writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_set);
+
+	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return 0;
+}
+
+static void adi_gpio_irq_shutdown(struct irq_data *d)
+{
+	unsigned long flags;
+	struct gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct gpio_pint_regs *regs = port->pint->regs;
+
+	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->pint->lock, flags);
+
+	writel(hwirq_to_pintbit(port, d->hwirq), &regs->mask_clear);
+	__adi_gpio_irq_free(port, d->hwirq);
+
+	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static int adi_gpio_irq_type(struct irq_data *d, unsigned int type)
+{
+	unsigned long flags;
+	struct gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct gpio_pint_regs *pint_regs = port->pint->regs;
+	unsigned pintmask;
+	unsigned int irq = d->irq;
+	int ret = 0;
+	char buf[16];
+
+	if (!port) {
+		dev_err(port->dev, "GPIO IRQ %d :Not exist\n", irq);
+		return -ENODEV;
+	}
+
+	pintmask = hwirq_to_pintbit(port, d->hwirq);
+
+	spin_lock_irqsave(&port->lock, flags);
+	spin_lock_irqsave(&port->pint->lock, flags);
+
+	if (type == IRQ_TYPE_PROBE)
+		type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
+
+	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
+		    IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+		snprintf(buf, 16, "gpio-irq%d", irq);
+		ret = __adi_gpio_irq_request(port, d->hwirq, buf);
+		if (ret)
+			goto out;
+	} else
+		goto out;
+
+	if ((type & (IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_LEVEL_LOW)))
+		/* low or falling edge denoted by one */
+		writel(pintmask, &pint_regs->invert_set);
+	else
+		/* high or rising edge denoted by zero */
+		writel(pintmask, &pint_regs->invert_clear);
+
+	if ((type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH) {
+		if (gpio_get_value(port->chip.base + d->hwirq))
+			writel(pintmask, &pint_regs->invert_set);
+		else
+			writel(pintmask, &pint_regs->invert_clear);
+	}
+
+	if (type & (IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING)) {
+		writel(pintmask, &pint_regs->edge_set);
+		__irq_set_handler_locked(irq, handle_edge_irq);
+	} else {
+		writel(pintmask, &pint_regs->edge_clear);
+		__irq_set_handler_locked(irq, handle_level_irq);
+	}
+
+out:
+	spin_unlock_irqrestore(&port->pint->lock, flags);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int adi_gpio_set_wake(struct irq_data *d, unsigned int state)
+{
+	struct gpio_port *port = irq_data_get_irq_chip_data(d);
+
+	if (!port || !port->pint || port->pint->irq != d->irq)
+		return -EINVAL;
+
+#ifndef SEC_GCTL
+	adi_internal_set_wake(port->pint->irq, state);
+#endif
+
+	return 0;
+}
+
+static int adi_pint_suspend(void)
+{
+	struct gpio_pint *pint;
+
+	list_for_each_entry(pint, &adi_pint_list, node) {
+		writel(0xffffffff, &pint->regs->mask_clear);
+		pint->saved_data.assign = readl(&pint->regs->assign);
+		pint->saved_data.edge_set = readl(&pint->regs->edge_set);
+		pint->saved_data.invert_set = readl(&pint->regs->invert_set);
+	}
+
+	return 0;
+}
+
+static void adi_pint_resume(void)
+{
+	struct gpio_pint *pint;
+
+	list_for_each_entry(pint, &adi_pint_list, node) {
+		writel(pint->saved_data.assign, &pint->regs->assign);
+		writel(pint->saved_data.edge_set, &pint->regs->edge_set);
+		writel(pint->saved_data.invert_set, &pint->regs->invert_set);
+	}
+}
+
+static int adi_gpio_suspend(void)
+{
+	struct gpio_port *port;
+
+	list_for_each_entry(port, &adi_gpio_port_list, node) {
+		port->saved_data.fer = readw(&port->regs->port_fer);
+		port->saved_data.mux = readl(&port->regs->port_mux);
+		port->saved_data.data = readw(&port->regs->data);
+		port->saved_data.inen = readw(&port->regs->inen);
+		port->saved_data.dir = readw(&port->regs->dir_set);
+	}
+
+	return adi_pint_suspend();
+}
+
+static void adi_gpio_resume(void)
+{
+	struct gpio_port *port;
+
+	adi_pint_resume();
+
+	list_for_each_entry(port, &adi_gpio_port_list, node) {
+		writel(port->saved_data.mux, &port->regs->port_mux);
+		writew(port->saved_data.fer, &port->regs->port_fer);
+		writew(port->saved_data.inen, &port->regs->inen);
+		writew(port->saved_data.data & port->saved_data.dir,
+					&port->regs->data_set);
+		writew(port->saved_data.dir, &port->regs->dir_set);
+	}
+
+}
+
+static struct syscore_ops gpio_pm_syscore_ops = {
+	.suspend = adi_gpio_suspend,
+	.resume = adi_gpio_resume,
+};
+#else /* CONFIG_PM */
+#define adi_gpio_set_wake NULL
+#endif /* CONFIG_PM */
+
+#ifdef CONFIG_IRQ_PREFLOW_FASTEOI
+static inline void preflow_handler(struct irq_desc *desc)
+{
+	if (desc->preflow_handler)
+		desc->preflow_handler(&desc->irq_data);
+}
+#else
+static inline void preflow_handler(struct irq_desc *desc) { }
+#endif
+
+static void adi_gpio_handle_pint_irq(unsigned int inta_irq,
+			struct irq_desc *desc)
+{
+	u32 request;
+	u32 level_mask, hwirq;
+	bool umask = false;
+	struct gpio_pint *pint = irq_desc_get_handler_data(desc);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	struct gpio_pint_regs *regs = pint->regs;
+	struct irq_domain *domain;
+
+	preflow_handler(desc);
+	chained_irq_enter(chip, desc);
+
+	request = readl(&regs->request);
+	level_mask = readl(&regs->edge_set) & request;
+
+	hwirq = 0;
+	domain = pint->domain[0];
+	while (request) {
+		/* domain pointer need to be changed only once at IRQ 16 when
+		 * we go through IRQ requests from bit 0 to bit 31.
+		 */
+		if (hwirq == PINT_HI_OFFSET)
+			domain = pint->domain[1];
+
+		if (request & 1) {
+			if (level_mask & BIT(hwirq)) {
+				umask = true;
+				chained_irq_exit(chip, desc);
+			}
+			generic_handle_irq(irq_find_mapping(domain,
+					hwirq % PINT_HI_OFFSET));
+		}
+
+		hwirq++;
+		request >>= 1;
+	}
+
+	if (!umask)
+		chained_irq_exit(chip, desc);
+}
+
+static struct irq_chip adi_gpio_irqchip = {
+	.name = "GPIO",
+	.irq_ack = adi_gpio_ack_irq,
+	.irq_mask = adi_gpio_mask_irq,
+	.irq_mask_ack = adi_gpio_mask_ack_irq,
+	.irq_unmask = adi_gpio_unmask_irq,
+	.irq_disable = adi_gpio_mask_irq,
+	.irq_enable = adi_gpio_unmask_irq,
+	.irq_set_type = adi_gpio_irq_type,
+	.irq_startup = adi_gpio_irq_startup,
+	.irq_shutdown = adi_gpio_irq_shutdown,
+	.irq_set_wake = adi_gpio_set_wake,
+};
+
+#if defined(CONFIG_DEBUG_FS)
+static inline unsigned short get_gpio_dir(struct gpio_port *port,
+	unsigned offset)
+{
+	struct gpio_port_t *regs = port->regs;
+
+	return !!(readw(&regs->dir_clear) & BIT(offset));
+}
+
+static void adi_gpio_dbg_show_one(struct seq_file *s,
+	struct pinctrl_dev *pctldev, struct gpio_chip *chip,
+	unsigned offset, unsigned gpio)
+{
+	int rsv_irq, rsv_gpio;
+	struct gpio_port *port;
+
+	port = container_of(chip, struct gpio_port, chip);
+
+	rsv_irq = port->rsvmap[offset].rsv_int;
+	rsv_gpio = port->rsvmap[offset].rsv_gpio;
+	if (rsv_gpio || rsv_irq)
+		seq_printf(s, "GPIO_%d: \t%s%s \t\tGPIO %s\n",
+			gpio, get_label(port, offset),
+			(rsv_gpio && rsv_irq) ? " *" : "",
+			get_gpio_dir(port, offset) ?
+			"OUTPUT" : "INPUT");
+	else if (port->rsvmap[offset].rsv_peri)
+		seq_printf(s, "GPIO_%d: \t%s \t\tPeripheral\n",
+			gpio, get_label(port, offset));
+}
+
+static void adi_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	unsigned i;
+	unsigned gpio = chip->base;
+
+	for (i = 0; i < chip->ngpio; i++, gpio++)
+		adi_gpio_dbg_show_one(s, NULL, chip, i, gpio);
+}
+#else
+#define adi_gpio_dbg_show_one	NULL
+#define adi_gpio_dbg_show       NULL
+#endif
+
+static int adi_get_groups_count(struct pinctrl_dev *pctldev)
+{
+	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pinctrl->soc->ngroups;
+}
+
+static const char *adi_get_group_name(struct pinctrl_dev *pctldev,
+				       unsigned selector)
+{
+	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pinctrl->soc->groups[selector].name;
+}
+
+static int adi_get_group_pins(struct pinctrl_dev *pctldev, unsigned selector,
+			       const unsigned **pins,
+			       unsigned *num_pins)
+{
+	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	*pins = pinctrl->soc->groups[selector].pins;
+	*num_pins = pinctrl->soc->groups[selector].num;
+	return 0;
+}
+
+static struct pinctrl_gpio_range *
+adi_match_gpio_range(struct pinctrl_dev *pctldev, unsigned gpio)
+{
+	struct pinctrl_gpio_range *range = NULL;
+
+	mutex_lock(&pctldev->mutex);
+	list_for_each_entry(range, &pctldev->gpio_ranges, node) {
+		if (gpio >= range->base &&
+			gpio < range->base + range->npins) {
+			mutex_unlock(&pctldev->mutex);
+			return range;
+		}
+	}
+	mutex_unlock(&pctldev->mutex);
+
+	return NULL;
+}
+
+static void adi_pin_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
+		   unsigned offset)
+{
+	struct pinctrl_gpio_range *range;
+	struct gpio_chip *chip;
+
+	range = adi_match_gpio_range(pctldev, offset);
+	if (!range || !range->gc) {
+		seq_puts(s, "invalid pin offset");
+		return;
+	}
+	chip = range->gc;
+	adi_gpio_dbg_show_one(s, pctldev, chip, offset - chip->base, offset);
+}
+
+static struct pinctrl_ops adi_pctrl_ops = {
+	.get_groups_count = adi_get_groups_count,
+	.get_group_name = adi_get_group_name,
+	.get_group_pins = adi_get_group_pins,
+	.pin_dbg_show = adi_pin_dbg_show,
+};
+
+static int adi_pinmux_request(struct pinctrl_dev *pctldev, unsigned pin)
+{
+	struct gpio_port *port;
+	struct pinctrl_gpio_range *range;
+	unsigned long flags;
+	struct pin_desc *desc;
+	u8 offset;
+
+	range = pinctrl_find_gpio_range_from_pin(pctldev, pin);
+	if (range == NULL) {
+		dev_err(pctldev->dev,
+		       "%s: Peripheral PIN %d doesn't exist!\n",
+		       __func__, pin);
+		return -ENODEV;
+	}
+
+	port = container_of(range->gc, struct gpio_port, chip);
+
+	offset = pin_to_offset(range, pin);
+	desc = radix_tree_lookup(&pctldev->pin_desc_tree, pin);
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	/* If a pin can be muxed as either GPIO or peripheral, make
+	 * sure it is not already a GPIO pin when we request it.
+	 */
+	if (port->rsvmap[offset].rsv_gpio) {
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
+		dev_err(pctldev->dev,
+		       "%s: Peripheral PIN %d is already reserved as GPIO by %s!\n",
+		       __func__, pin, get_label(port, offset));
+		spin_unlock_irqrestore(&port->lock, flags);
+		return -EBUSY;
+	}
+
+	if (port->rsvmap[offset].rsv_peri) {
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
+		dev_err(pctldev->dev,
+			"%s: Peripheral PIN %d is already reserved by %s!\n",
+			__func__, pin, get_label(port, offset));
+		spin_unlock_irqrestore(&port->lock, flags);
+		return -EBUSY;
+	}
+
+	port->rsvmap[offset].rsv_peri = true;
+	set_label(port, offset, desc->mux_owner);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return 0;
+}
+
+static int adi_pinmux_free(struct pinctrl_dev *pctldev, unsigned pin)
+{
+	struct gpio_port *port;
+	struct pinctrl_gpio_range *range;
+	unsigned long flags;
+	u8 offset;
+
+	range = pinctrl_find_gpio_range_from_pin(pctldev, pin);
+	if (range == NULL)
+		return 0;
+
+	port = container_of(range->gc, struct gpio_port, chip);
+
+	offset = pin_to_offset(range, pin);
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (!port->rsvmap[offset].rsv_peri) {
+		spin_unlock_irqrestore(&port->lock, flags);
+		return 0;
+	}
+
+	port->rsvmap[offset].rsv_peri = false;
+	set_label(port, offset, "free");
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return 0;
+}
+
+static int adi_pinmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
+	unsigned group)
+{
+	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
+	struct gpio_port *port;
+	struct pinctrl_gpio_range *range;
+	unsigned long flags;
+	unsigned short *mux, pin;
+
+	mux = (unsigned short *)pinctrl->soc->functions[selector].mux;
+
+	while (*mux) {
+		pin = P_IDENT(*mux);
+
+		range = pinctrl_find_gpio_range_from_pin(pctldev, pin);
+		if (range == NULL) /* should not happen */
+			return -ENODEV;
+
+		port = container_of(range->gc, struct gpio_port, chip);
+
+		spin_lock_irqsave(&port->lock, flags);
+
+		portmux_setup(port, pin_to_offset(range, pin),
+				 P_FUNCT2MUX(*mux));
+		port_setup(port, pin_to_offset(range, pin), false);
+		mux++;
+
+		spin_unlock_irqrestore(&port->lock, flags);
+	}
+
+	return 0;
+}
+
+static void adi_pinmux_disable(struct pinctrl_dev *pctldev, unsigned selector,
+	unsigned group)
+{
+	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
+	struct gpio_port *port;
+	struct pinctrl_gpio_range *range;
+	unsigned long flags;
+	unsigned short *mux, pin;
+
+	mux = (unsigned short *)pinctrl->soc->functions[selector].mux;
+
+	while (*mux) {
+		pin = P_IDENT(*mux);
+
+		range = pinctrl_find_gpio_range_from_pin(pctldev, pin);
+		if (range == NULL) /* should not happen */
+			return;
+
+		port = container_of(range->gc, struct gpio_port, chip);
+
+		spin_lock_irqsave(&port->lock, flags);
+
+		port_setup(port, pin_to_offset(range, pin), true);
+		mux++;
+
+		spin_unlock_irqrestore(&port->lock, flags);
+	}
+}
+
+static int adi_pinmux_get_funcs_count(struct pinctrl_dev *pctldev)
+{
+	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pinctrl->soc->nfunctions;
+}
+
+static const char *adi_pinmux_get_func_name(struct pinctrl_dev *pctldev,
+					  unsigned selector)
+{
+	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	return pinctrl->soc->functions[selector].name;
+}
+
+static int adi_pinmux_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
+			       const char * const **groups,
+			       unsigned * const num_groups)
+{
+	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
+
+	*groups = pinctrl->soc->functions[selector].groups;
+	*num_groups = pinctrl->soc->functions[selector].num_groups;
+	return 0;
+}
+
+static int adi_pinmux_request_gpio(struct pinctrl_dev *pctldev,
+	struct pinctrl_gpio_range *range, unsigned pin)
+{
+	struct gpio_port *port;
+	unsigned long flags;
+	u8 offset;
+
+	port = container_of(range->gc, struct gpio_port, chip);
+	offset = pin_to_offset(range, pin);
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (port->rsvmap[offset].rsv_gpio) {
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
+		dev_err(pctldev->dev,
+			"GPIO %d is already reserved by %s !\n",
+			port->chip.base + offset, get_label(port, offset));
+		spin_unlock_irqrestore(&port->lock, flags);
+		return -EBUSY;
+	}
+	if (port->rsvmap[offset].rsv_peri) {
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
+		dev_err(pctldev->dev,
+			"GPIO %d is already reserved as peripheral by %s !\n",
+			port->chip.base + offset, get_label(port, offset));
+		spin_unlock_irqrestore(&port->lock, flags);
+		return -EBUSY;
+	}
+	if (port->rsvmap[offset].rsv_int) {
+		dev_err(pctldev->dev,
+			"GPIO %d is already reserved as gpio-irq!\n",
+			port->chip.base + offset);
+	}
+
+	port->rsvmap[offset].rsv_gpio = true;
+	set_label(port, offset, port->chip.label);
+	port_setup(port, offset, true);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return 0;
+}
+
+static void adi_pinmux_free_gpio(struct pinctrl_dev *pctldev,
+	struct pinctrl_gpio_range *range, unsigned pin)
+{
+	struct gpio_port *port;
+	unsigned long flags;
+	u8 offset;
+
+	port = container_of(range->gc, struct gpio_port, chip);
+	offset = pin_to_offset(range, pin);
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (!port->rsvmap[offset].rsv_gpio) {
+		if (system_state == SYSTEM_BOOTING)
+			dump_stack();
+
+		dev_err(pctldev->dev,
+			"GPIO %d wasn't requested!\n",
+			port->chip.base + offset);
+		spin_unlock_irqrestore(&port->lock, flags);
+		return;
+	}
+
+	port->rsvmap[offset].rsv_gpio = false;
+	set_label(port, offset, "free");
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return;
+}
+
+static struct pinmux_ops adi_pinmux_ops = {
+	.request = adi_pinmux_request,
+	.free = adi_pinmux_free,
+	.enable = adi_pinmux_enable,
+	.disable = adi_pinmux_disable,
+	.get_functions_count = adi_pinmux_get_funcs_count,
+	.get_function_name = adi_pinmux_get_func_name,
+	.get_function_groups = adi_pinmux_get_groups,
+	.gpio_request_enable = adi_pinmux_request_gpio,
+	.gpio_disable_free = adi_pinmux_free_gpio,
+};
+
+
+static struct pinctrl_desc adi_pinmux_desc = {
+	.name = DRIVER_NAME,
+	.pctlops = &adi_pctrl_ops,
+	.pmxops = &adi_pinmux_ops,
+	.owner = THIS_MODULE,
+};
+
+static int adi_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void adi_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+}
+
+static int adi_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpio_port *port;
+	unsigned long flags;
+
+	port = container_of(chip, struct gpio_port, chip);
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (!port->rsvmap[offset].rsv_gpio) {
+		dev_err(port->dev, "GPIO %d wasn't requested!\n",
+			chip->base + offset);
+		spin_unlock_irqrestore(&port->lock, flags);
+		return -EINVAL;
+	}
+
+	writew(BIT(offset), &port->regs->dir_clear);
+	writew(readw(&port->regs->inen) | BIT(offset), &port->regs->inen);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return 0;
+}
+
+static void adi_gpio_set_value(struct gpio_chip *chip, unsigned offset,
+	int value)
+{
+	struct gpio_port *port = container_of(chip, struct gpio_port, chip);
+	struct gpio_port_t *regs = port->regs;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (value)
+		writew(1 << offset, &regs->data_set);
+	else
+		writew(1 << offset, &regs->data_clear);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static int adi_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+	int value)
+{
+	struct gpio_port *port = container_of(chip, struct gpio_port, chip);
+	struct gpio_port_t *regs = port->regs;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (!port->rsvmap[offset].rsv_gpio) {
+		dev_err(port->dev, "GPIO %d wasn't requested!\n",
+			chip->base + offset);
+		spin_unlock_irqrestore(&port->lock, flags);
+		return -EINVAL;
+	}
+
+	writew(readw(&regs->inen) & ~(1 << offset), &regs->inen);
+	adi_gpio_set_value(chip, offset, value);
+	writew(1 << offset, &regs->dir_set);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return 0;
+}
+
+static int adi_gpio_get_value(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpio_port *port = container_of(chip, struct gpio_port, chip);
+	struct gpio_port_t *regs = port->regs;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	ret = !!(readw(&regs->data) & BIT(offset));
+
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return ret;
+}
+
+static int adi_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpio_port *port = container_of(chip, struct gpio_port, chip);
+
+	if (port->irq_base >= 0)
+		return irq_find_mapping(port->domain, offset);
+	else
+		return irq_create_mapping(port->domain, offset);
+}
+
+static int adi_pint_map_port(struct gpio_pint *pint, bool assign, u8 map,
+	struct irq_domain *domain)
+{
+	struct gpio_pint_regs *regs = pint->regs;
+	u32 map_mask;
+
+	if (pint->map_count > 1)
+		return -EINVAL;
+
+	pint->map_count++;
+
+	/* The map_mask of each gpio port is a 16-bit duplicate
+	 * of the 8-bit map. It can be set to either high 16 bits or low
+	 * 16 bits of the pint assignment register.
+	 */
+	map_mask = (map << 8) | map;
+	if (assign) {
+		map_mask <<= PINT_HI_OFFSET;
+		writel((readl(&regs->assign) & 0xFFFF) | map_mask,
+			&regs->assign);
+	} else
+		writel((readl(&regs->assign) & 0xFFFF0000) | map_mask,
+			&regs->assign);
+
+	pint->domain[assign] = domain;
+
+	return 0;
+}
+
+static int adi_gpio_pint_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct gpio_pint *pint;
+
+	pint = devm_kzalloc(dev, sizeof(struct gpio_pint), GFP_KERNEL);
+	if (!pint) {
+		dev_err(dev, "Memory alloc failed\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "Invalid mem resource\n");
+		return -ENODEV;
+	}
+
+	if (!devm_request_mem_region(dev, res->start, resource_size(res),
+				     pdev->name)) {
+		dev_err(dev, "Region already claimed\n");
+		return -EBUSY;
+	}
+
+	pint->base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!pint->base) {
+		dev_err(dev, "Could not ioremap\n");
+		return -ENOMEM;
+	}
+
+	pint->regs = (struct gpio_pint_regs *)pint->base;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "Invalid IRQ resource\n");
+		return -ENODEV;
+	}
+
+	spin_lock_init(&pint->lock);
+
+	pint->irq = res->start;
+	pint->pint_map_port = adi_pint_map_port;
+	platform_set_drvdata(pdev, pint);
+
+	irq_set_chained_handler(pint->irq, adi_gpio_handle_pint_irq);
+	irq_set_handler_data(pint->irq, pint);
+
+	list_add_tail(&pint->node, &adi_pint_list);
+
+	return 0;
+}
+
+static int adi_gpio_pint_remove(struct platform_device *pdev)
+{
+	struct gpio_pint *pint = platform_get_drvdata(pdev);
+
+	list_del(&pint->node);
+	irq_set_handler(pint->irq, handle_simple_irq);
+
+	return 0;
+}
+
+static int adi_gpio_irq_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hwirq)
+{
+	struct gpio_port *port = d->host_data;
+
+	if (!port)
+		return -EINVAL;
+
+	irq_set_chip_data(irq, port);
+	irq_set_chip_and_handler(irq, &adi_gpio_irqchip,
+				handle_level_irq);
+
+	return 0;
+}
+
+const struct irq_domain_ops adi_gpio_irq_domain_ops = {
+	.map = adi_gpio_irq_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
+static int adi_gpio_init_int(struct gpio_port *port)
+{
+	struct device_node *node = port->dev->of_node;
+	struct gpio_pint *pint = port->pint;
+	int ret;
+
+	port->domain = irq_domain_add_linear(node, port->width,
+				&adi_gpio_irq_domain_ops, port);
+	if (!port->domain) {
+		dev_err(port->dev, "Failed to create irqdomain\n");
+		return -ENOSYS;
+	}
+
+	/* According to BF54x and BF60x HRM, pin interrupt devices are not
+	 * part of the GPIO port device. in GPIO interrupt mode, the GPIO
+	 * pins of multiple port devices can be routed into one pin interrupt
+	 * device. The mapping can be configured by setting pint assignment
+	 * register with the mapping value of different GPIO port. This is
+	 * done via function pint_map_port().
+	 */
+	ret = pint->pint_map_port(port->pint, port->pint_assign,
+			port->pint_map,	port->domain);
+	if (ret)
+		return ret;
+
+	if (port->irq_base >= 0) {
+		ret = irq_create_strict_mappings(port->domain, port->irq_base,
+					0, port->width);
+		if (ret) {
+			dev_err(port->dev, "Couldn't associate to domain\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int adi_gpio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const struct adi_pinctrl_gpio_platform_data *pdata;
+	struct resource *res;
+	struct gpio_port *port;
+	char pinctrl_devname[RESOURCE_LABEL_SIZE];
+	static int gpio;
+	int ret = 0, ret1;
+
+	pdata = dev->platform_data;
+	if (!pdata)
+		return -EINVAL;
+
+	port = devm_kzalloc(dev, sizeof(struct gpio_port) +
+		sizeof(struct gpio_reserve_map) * pdata->port_width,
+		GFP_KERNEL);
+	if (!port) {
+		dev_err(dev, "Memory alloc failed\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "Invalid mem resource\n");
+		return -ENODEV;
+	}
+
+	if (!devm_request_mem_region(dev, res->start, resource_size(res),
+				     pdev->name)) {
+		dev_err(dev, "Region already claimed\n");
+		return -EBUSY;
+	}
+
+	port->base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!port->base) {
+		dev_err(dev, "Could not ioremap\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res)
+		port->irq_base = -1;
+	else
+		port->irq_base = res->start;
+
+	port->width = pdata->port_width;
+	port->dev = dev;
+	port->regs = (struct gpio_port_t *)port->base;
+	port->pint_assign = pdata->pint_assign;
+	port->pint_map = pdata->pint_map;
+
+	port->pint = find_gpio_pint(pdata->pint_id);
+	if (port->pint) {
+		ret = adi_gpio_init_int(port);
+		if (ret)
+			return ret;
+	}
+
+	spin_lock_init(&port->lock);
+
+	platform_set_drvdata(pdev, port);
+
+	port->chip.label		= "adi-gpio";
+	port->chip.direction_input	= adi_gpio_direction_input;
+	port->chip.get			= adi_gpio_get_value;
+	port->chip.direction_output	= adi_gpio_direction_output;
+	port->chip.set			= adi_gpio_set_value;
+	port->chip.request		= adi_gpio_request;
+	port->chip.free			= adi_gpio_free;
+	port->chip.to_irq		= adi_gpio_to_irq;
+	port->chip.dbg_show		= adi_gpio_dbg_show;
+	if (pdata->port_gpio_base > 0)
+		port->chip.base		= pdata->port_gpio_base;
+	else
+		port->chip.base		= gpio;
+	port->chip.ngpio		= port->width;
+	gpio = port->chip.base + port->width;
+
+	ret = gpiochip_add(&port->chip);
+	if (ret) {
+		dev_err(&pdev->dev, "Fail to add GPIO chip.\n");
+		goto out_remove_domain;
+	}
+
+	/* Add gpio pin range */
+	snprintf(pinctrl_devname, RESOURCE_LABEL_SIZE, "pinctrl-adi2.%d",
+		pdata->pinctrl_id);
+	pinctrl_devname[RESOURCE_LABEL_SIZE - 1] = 0;
+	ret = gpiochip_add_pin_range(&port->chip, pinctrl_devname,
+		0, pdata->port_pin_base, port->width);
+	if (ret) {
+		dev_err(&pdev->dev, "Fail to add pin range to %s.\n",
+				pinctrl_devname);
+		goto out_remove_gpiochip;
+	}
+
+	list_add_tail(&port->node, &adi_gpio_port_list);
+
+	return 0;
+
+out_remove_gpiochip:
+	ret1 = gpiochip_remove(&port->chip);
+out_remove_domain:
+	if (port->pint)
+		irq_domain_remove(port->domain);
+
+	return ret;
+}
+
+static int adi_gpio_remove(struct platform_device *pdev)
+{
+	struct gpio_port *port = platform_get_drvdata(pdev);
+	int ret;
+	u8 offset;
+
+	list_del(&port->node);
+	gpiochip_remove_pin_ranges(&port->chip);
+	ret = gpiochip_remove(&port->chip);
+	if (port->pint) {
+		for (offset = 0; offset < port->width; offset++)
+			irq_dispose_mapping(irq_find_mapping(port->domain,
+				offset));
+		irq_domain_remove(port->domain);
+	}
+
+	return ret;
+}
+
+static int adi_pinctrl_probe(struct platform_device *pdev)
+{
+	struct adi_pinctrl *pinctrl;
+
+	pinctrl = devm_kzalloc(&pdev->dev, sizeof(*pinctrl), GFP_KERNEL);
+	if (!pinctrl)
+		return -ENOMEM;
+
+	pinctrl->dev = &pdev->dev;
+
+	adi_pinctrl_soc_init(&pinctrl->soc);
+
+	adi_pinmux_desc.pins = pinctrl->soc->pins;
+	adi_pinmux_desc.npins = pinctrl->soc->npins;
+
+	/* Now register the pin controller and all pins it handles */
+	pinctrl->pctl = pinctrl_register(&adi_pinmux_desc, &pdev->dev, pinctrl);
+	if (!pinctrl->pctl) {
+		dev_err(&pdev->dev, "could not register pinctrl ADI2 driver\n");
+		return -EINVAL;
+	}
+
+	platform_set_drvdata(pdev, pinctrl);
+
+	return 0;
+}
+
+static int adi_pinctrl_remove(struct platform_device *pdev)
+{
+	struct adi_pinctrl *pinctrl = platform_get_drvdata(pdev);
+
+	pinctrl_unregister(pinctrl->pctl);
+
+	return 0;
+}
+
+static struct platform_driver adi_pinctrl_driver = {
+	.probe		= adi_pinctrl_probe,
+	.remove		= adi_pinctrl_remove,
+	.driver		= {
+		.name	= DRIVER_NAME,
+	},
+};
+
+static struct platform_driver adi_gpio_pint_driver = {
+	.probe		= adi_gpio_pint_probe,
+	.remove		= adi_gpio_pint_remove,
+	.driver		= {
+		.name	= "adi-gpio-pint",
+	},
+};
+
+static struct platform_driver adi_gpio_driver = {
+	.probe		= adi_gpio_probe,
+	.remove		= adi_gpio_remove,
+	.driver		= {
+		.name	= "adi-gpio",
+	},
+};
+
+static int __init adi_pinctrl_setup(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&adi_pinctrl_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&adi_gpio_pint_driver);
+	if (ret)
+		goto pint_error;
+
+	ret = platform_driver_register(&adi_gpio_driver);
+	if (ret)
+		goto gpio_error;
+
+#ifdef CONFIG_PM
+	register_syscore_ops(&gpio_pm_syscore_ops);
+#endif
+	return ret;
+gpio_error:
+	platform_driver_unregister(&adi_gpio_pint_driver);
+pint_error:
+	platform_driver_unregister(&adi_pinctrl_driver);
+
+	return ret;
+}
+arch_initcall(adi_pinctrl_setup);
+
+MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
+MODULE_DESCRIPTION("ADI gpio2 pin control driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/pinctrl/pinctrl-adi2.h b/drivers/pinctrl/pinctrl-adi2.h
new file mode 100644
index 0000000..1f06f8d
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-adi2.h
@@ -0,0 +1,75 @@
+/*
+ * Pinctrl Driver for ADI GPIO2 controller
+ *
+ * Copyright 2007-2013 Analog Devices Inc.
+ *
+ * Licensed under the GPLv2 or later
+ */
+
+#ifndef PINCTRL_PINCTRL_ADI2_H
+#define PINCTRL_PINCTRL_ADI2_H
+
+#include <linux/pinctrl/pinctrl.h>
+
+ /**
+ * struct adi_pin_group - describes a pin group
+ * @name: the name of this pin group
+ * @pins: an array of pins
+ * @num: the number of pins in this array
+ */
+struct adi_pin_group {
+	const char *name;
+	const unsigned *pins;
+	const unsigned num;
+};
+
+#define ADI_PIN_GROUP(n, p)  \
+	{			\
+		.name = n,	\
+		.pins = p,	\
+		.num = ARRAY_SIZE(p),	\
+	}
+
+ /**
+ * struct adi_pmx_func - describes function mux setting of pin groups
+ * @name: the name of this function mux setting
+ * @groups: an array of pin groups
+ * @num_groups: the number of pin groups in this array
+ * @mux: the function mux setting array, end by zero
+ */
+struct adi_pmx_func {
+	const char *name;
+	const char * const *groups;
+	const unsigned num_groups;
+	const unsigned short *mux;
+};
+
+#define ADI_PMX_FUNCTION(n, g, m)		\
+	{					\
+		.name = n,			\
+		.groups = g,			\
+		.num_groups = ARRAY_SIZE(g),	\
+		.mux = m,			\
+	}
+
+/**
+ * struct adi_pinctrl_soc_data - ADI pin controller per-SoC configuration
+ * @functions:  The functions supported on this SoC.
+ * @nfunction:  The number of entries in @functions.
+ * @groups:     An array describing all pin groups the pin SoC supports.
+ * @ngroups:    The number of entries in @groups.
+ * @pins:       An array describing all pins the pin controller affects.
+ * @npins:      The number of entries in @pins.
+ */
+struct adi_pinctrl_soc_data {
+	const struct adi_pmx_func *functions;
+	int nfunctions;
+	const struct adi_pin_group *groups;
+	int ngroups;
+	const struct pinctrl_pin_desc *pins;
+	int npins;
+};
+
+void adi_pinctrl_soc_init(const struct adi_pinctrl_soc_data **soc);
+
+#endif /* PINCTRL_PINCTRL_ADI2_H */
diff --git a/include/linux/platform_data/pinctrl-adi2.h b/include/linux/platform_data/pinctrl-adi2.h
new file mode 100644
index 0000000..8f91300
--- /dev/null
+++ b/include/linux/platform_data/pinctrl-adi2.h
@@ -0,0 +1,40 @@
+/*
+ * Pinctrl Driver for ADI GPIO2 controller
+ *
+ * Copyright 2007-2013 Analog Devices Inc.
+ *
+ * Licensed under the GPLv2 or later
+ */
+
+
+#ifndef PINCTRL_ADI2_H
+#define PINCTRL_ADI2_H
+
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+/**
+ * struct adi_pinctrl_gpio_platform_data - Pinctrl gpio platform data
+ * for ADI GPIO2 device.
+ *
+ * @port_gpio_base: Optional global GPIO index of the GPIO bank.
+ *                 0 means driver decides.
+ * @port_pin_base: Pin index of the pin controller device.
+ * @port_width: PIN number of the GPIO bank device
+ * @pint_id: GPIO PINT device id that this GPIO bank should map to.
+ * @pint_assign: The 32-bit GPIO PINT registers can be divided into 2 parts. A
+ *               GPIO bank can be mapped into either low 16 bits[0] or high 16
+ *               bits[1] of each PINT register.
+ * @pint_map: GIOP bank mapping code in PINT device
+ */
+struct adi_pinctrl_gpio_platform_data {
+	unsigned int port_gpio_base;
+	unsigned int port_pin_base;
+	unsigned int port_width;
+	u8 pinctrl_id;
+	u8 pint_id;
+	bool pint_assign;
+	u8 pint_map;
+};
+
+#endif
-- 
1.8.2.3


