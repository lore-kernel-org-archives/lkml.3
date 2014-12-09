Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbaLIJJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:09:11 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:51150 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaLIJJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:09:06 -0500
MIME-Version: 1.0
Date: Tue, 9 Dec 2014 10:09:05 +0100
Message-ID: <CACRpkda1EPMPTzW56GcCsMnBvn=s1gnp-pHu4cHP-+P-J2q52w@mail.gmail.com>
Subject: [GIT PULL] bulk GPIO changes for v3.19
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the bulk of GPIO changes for the v3.19 kernel series.
The major external change is the new API to driver several GPIOs
simultaneously, and the major internal change is that we're getting
rid of a static array of GPIO descriptors and again moving away,
slowly, from the global GPIO numberspace.

There is a patch hitting the TTY/serial subsystem, it has been
ACKed by Greg.

More details in the signed tag as usual.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.19-1

for you to fetch changes up to 256965d724347a9fa1cce42dc30987e7d92addb3:

  gpio: pl061: document gpio-ranges property for bindings file
(2014-12-03 14:46:27 +0100)

----------------------------------------------------------------
This is the bulk of GPIO changes for the v3.19 series:

- A new API that allows setting more than one GPIO at the
  time. This is implemented for the new descriptor-based
  API only and makes it possible to e.g. toggle a clock and
  data line at the same time, if the hardware can do this
  with a single register write. Both consumers and drivers
  need new calls, and the core will fall back to driving
  individual lines where needed. Implemented for the MPC8xxx
  driver initially.
- Patched the mdio-mux-gpio and the serial mctrl driver
  that drives modems to use the new multiple-setting API
  to set several signals simultaneously.
- Get rid of the global GPIO descriptor array, and instead
  allocate descriptors dynamically for each GPIO on a certain
  GPIO chip. This moves us closer to getting rid of the
  limitation of using the global, static GPIO numberspace.
- New driver and device tree bindings for 74xx ICs.
- New driver and device tree bindings for the VF610 Vybrid.
- Support the RCAR r8a7793 and r8a7794.
- Guidelines for GPIO device tree bindings trying to get
  things a bit more strict with the advent of combined
  device properties.
- Suspend/resume support for the MVEBU driver.
- A slew of minor fixes and improvements.

----------------------------------------------------------------
Alexander Shiyan (2):
      GPIO: Add driver for 74xx-ICs with MMIO access
      GPIO: 74xx-mmio: Add DT bindings documentation

Alexander Stein (4):
      gpio: mcp23s08: Do not free unrequested interrupt
      gpio: mcp23s08: request a shared interrupt
      gpio: mcp23s08: Add simple IRQ support for SPI devices
      gpio: mcp23s08: Add option to configure IRQ output polarity as active high

Alexandre Courbot (5):
      gpio: rename gpio_lock_as_irq to gpiochip_lock_as_irq
      Documentation: gpio: guidelines for bindings
      gpio: remove gpio_descs global array
      gpio: remove const modifier from gpiod_get_direction()
      gpio: fix deferred probe detection for legacy API

Daniel Thompson (1):
      gpio: msm-v1: Fix typo in function argument

Geert Uytterhoeven (2):
      gpio: Check if base is positive before calling gpio_is_valid()
      gpio: em: Use dynamic allocation of GPIOs

Hisashi Nakamura (1):
      gpio: rcar: Add r8a7793 and r8a7794 support

Janusz Uzycki (1):
      gpio: mxs: implement get_direction callback

Linus Walleij (1):
      gpio: dwapb: fix compile errors

Pramod Gurav (3):
      gpio: cs5535: Switch to using managed resources with devm_
      gpio: amd8111: unmap ioport on failure case
      gpio: grgpio: remove irq_domain resources on failure

Rojhalat Ibrahim (4):
      gpiolib: allow simultaneous setting of multiple GPIO outputs
      gpio-mpc8xxx: add mpc8xxx_gpio_set_multiple function
      mdio-mux-gpio: Use GPIO descriptor interface and new
gpiod_set_array function
      serial: mctrl_gpio: use gpiod_set_array function

Stefan Agner (2):
      gpio: vf610: add gpiolib/IRQ chip driver for Vybrid
      Documentation: dts: add bindings for Vybrid GPIO/PORT module

Thomas Petazzoni (1):
      gpio: mvebu: add suspend/resume support

Varka Bhadram (3):
      gpio: gpio-stp-xway: remove duplicate check on resource
      gpio: gpio-tb10x: remove duplicate check on resource
      gpio: gpio-davinci: remove duplicate check on resource

Yunlei He (2):
      gpio: pl061: hook request if gpio-ranges avaiable
      gpio: pl061: document gpio-ranges property for bindings file

 .../devicetree/bindings/gpio/gpio-74xx-mmio.txt    |  30 +++
 .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |   2 +
 .../devicetree/bindings/gpio/gpio-vf610.txt        |  55 ++++
 Documentation/devicetree/bindings/gpio/gpio.txt    |  40 ++-
 .../devicetree/bindings/gpio/pl061-gpio.txt        |   2 +-
 .../devicetree/bindings/gpio/renesas,gpio-rcar.txt |   4 +-
 Documentation/gpio/consumer.txt                    |  27 ++
 Documentation/gpio/driver.txt                      |   4 +-
 drivers/gpio/Kconfig                               |  23 ++
 drivers/gpio/Makefile                              |   2 +
 drivers/gpio/gpio-74xx-mmio.c                      | 170 ++++++++++++
 drivers/gpio/gpio-amd8111.c                        |   1 +
 drivers/gpio/gpio-bcm-kona.c                       |   4 +-
 drivers/gpio/gpio-cs5535.c                         |  11 +-
 drivers/gpio/gpio-davinci.c                        |   5 -
 drivers/gpio/gpio-dwapb.c                          |   4 +-
 drivers/gpio/gpio-em.c                             |  11 +-
 drivers/gpio/gpio-grgpio.c                         |   1 +
 drivers/gpio/gpio-mcp23s08.c                       |  40 ++-
 drivers/gpio/gpio-mpc8xxx.c                        |  27 ++
 drivers/gpio/gpio-msm-v1.c                         |   2 +-
 drivers/gpio/gpio-mvebu.c                          |  99 +++++++
 drivers/gpio/gpio-mxs.c                            |  13 +
 drivers/gpio/gpio-omap.c                           |   2 +-
 drivers/gpio/gpio-pl061.c                          |  20 +-
 drivers/gpio/gpio-rcar.c                           |  27 +-
 drivers/gpio/gpio-stp-xway.c                       |   8 +-
 drivers/gpio/gpio-tb10x.c                          |   7 +-
 drivers/gpio/gpio-tegra.c                          |   4 +-
 drivers/gpio/gpio-vf610.c                          | 295 +++++++++++++++++++++
 drivers/gpio/gpio-vr41xx.c                         |   4 +-
 drivers/gpio/gpiolib-acpi.c                        |   6 +-
 drivers/gpio/gpiolib-legacy.c                      |  12 +-
 drivers/gpio/gpiolib-sysfs.c                       |   6 +-
 drivers/gpio/gpiolib.c                             | 241 +++++++++++++++--
 drivers/net/phy/mdio-mux-gpio.c                    |  37 +--
 drivers/pinctrl/pinctrl-at91.c                     |   4 +-
 drivers/pinctrl/samsung/pinctrl-exynos.c           |   4 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   6 +-
 drivers/tty/serial/serial_mctrl_gpio.c             |  12 +-
 include/linux/gpio.h                               |   7 +-
 include/linux/gpio/consumer.h                      |  40 ++-
 include/linux/gpio/driver.h                        |   8 +-
 43 files changed, 1165 insertions(+), 162 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-74xx-mmio.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-vf610.txt
 create mode 100644 drivers/gpio/gpio-74xx-mmio.c
 create mode 100644 drivers/gpio/gpio-vf610.c
