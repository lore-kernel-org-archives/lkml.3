Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbaIFQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 12:25:27 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:49539 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaIFQZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 12:25:16 -0400
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, gnurou@gmail.com, shawn.guo@freescale.com,
        kernel@pengutronix.de
Cc: linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 0/4] vf610: Add GPIO support
Date: Sat,  6 Sep 2014 18:25:03 +0200
Message-Id: <cover.1410020458.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds GPIO support for Vybrid. The first patch is a
preparation patch which makes sure we can detect whether a pin is
initialized by the pinmux subsystem or not. This is required since
the gpio_request_enable/gpio_set_direction function need to know
if the pins mux register offsets are valid or not.

To get valid mux register offset for a pin, we need to have a pinmux
group configuration in the device tree. For the SD card detection pin
this is within the esdhc pingroup. Since the pingroup is used by the
driver, the mux and configuration register gets applied by the pinmux
subsystem.

However, the group does not need to be used anywhere, just the
configuration itself makes sure the mux register offset is known to
the pinmux driver. If a GPIO is requested then, the SoC's default pin
config is still in place. Is this the expected behaviour of a pinmux
driver? How can I make sure that a GPIO only pin (used by user-space
for instance) get a valid pin configuration applied?

To get the mux register offset, I also thought about calculating the
value in those two functions instead, however this seems not to be
consistent with the rest of the driver.

Other then that, the GPIO/IRQ chip driver is quite straight forward
and makes use of CONFIG_GPIOLIB_IRQCHIP. The only thing which is a
bit weird: There is no actual mask register for the GPIO interrupts.
There is only a configuration register, which, if configured, enables
the interrupt. Since the mask/unmask functions are requierd, the
driver writes/clears the configuration register in the mask/umask
functions.

Stefan Agner (4):
  pinctrl: imx: detect uninitialized pins
  pinctrl: imx: add gpio pinmux support for vf610
  gpio: vf610: add gpiolib/IRQ chip driver for Vybird
  ARM: dts: vf610: Use new GPIO support

 arch/arm/boot/dts/vf610-colibri.dtsi |   8 +
 arch/arm/boot/dts/vf610-twr.dts      |   1 +
 arch/arm/boot/dts/vf610.dtsi         |   1 +
 drivers/gpio/Kconfig                 |   7 +
 drivers/gpio/Makefile                |   1 +
 drivers/gpio/gpio-vf610.c            | 285 +++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-imx.c        |  63 +++++++-
 drivers/pinctrl/pinctrl-imx.h        |   8 +-
 drivers/pinctrl/pinctrl-vf610.c      |   4 +-
 9 files changed, 368 insertions(+), 10 deletions(-)
 create mode 100644 drivers/gpio/gpio-vf610.c

-- 
2.1.0

