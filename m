Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaHHJg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:36:27 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47720 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaHHJgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:36:24 -0400
MIME-Version: 1.0
Date: Fri, 8 Aug 2014 11:36:23 +0200
Message-ID: <CACRpkdYSybZbO-RRHdDBbQ944ZEDgq4MWcpNBQrhXzAVT9eA9A@mail.gmail.com>
Subject: [GIT PULL] GPIO bulk changes for v3.17
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        abdoulaye berthe <berthe.ab@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the bulk of GPIO changes for the v3.17 cycle. This time around
there is some action happening, and we will continue in v3.18. It is
mostly cleanup and refactoring as Alexandre, Abdoulaye and I are
working in parallell on cleanups, and then a single new driver.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.17-1

for you to fetch changes up to bdc6e95e1273b5cef01590273c1a240c53ceeea0:

  MAINTAINERS: update GPIO include files (2014-08-07 11:56:06 +0200)

----------------------------------------------------------------
This is the bulk of GPIO changes for the v3.17 development
cycle, and this time we got a lot of action going on and
it will continue:

- The core GPIO library implementation has been split up in
  three different files:
  - gpiolib.c for the latest and greatest and shiny GPIO
    library code using GPIO descriptors only
  - gpiolib-legacy.c for the old integer number space API
    that we are phasing out gradually
  - gpiolib-sysfs.c for the sysfs interface that we are
    not entirely happy with, but has to live on for
    ABI compatibility

- Add a flags argument to *gpiod_get* functions, with some
  backward-compatibility macros to ease transitions. We
  should have had the flags there from the beginning it
  seems, now we need to clean up the mess. There is a plan
  on how to move forward here devised by Alexandre Courbot
  and Mark Brown.

- Split off a special <linux/gpio/machine.h> header for the
  board gpio table registration, as per example from the
  regulator subsystem.

- Start to kill off the return value from gpiochip_remove()
  by removing the __must_check attribute and removing all
  checks inside the drivers/gpio directory. The rationale
  is: well what were we supposed to do if there is an error
  code? Not much: print an error message. And gpiolib already
  does that. So make this function return void eventually.

- Some cleanups of hairy gpiolib code, make some functions
  not to be used outside the library private and make sure
  they are not exported, remove gpiod_lock/unlock_as_irq()
  as the existing function is for driver-internal use and
  fine as it is, delete gpio_ensure_requested() as it is
  not meaningful anymore.

- Support the GPIOF_ACTIVE_LOW flag from gpio_request_one()
  function calls, which is logical since this is already
  supported when referencing GPIOs from e.g. device trees.

- Switch STMPE, intel-mid, lynxpoint and ACPI (!) to use
  the gpiolib irqchip helpers cutting down on GPIO irqchip
  boilerplate a bit more.

- New driver for the Zynq GPIO block.

- The usual incremental improvements around a bunch of
  drivers.

- Janitorial syntactic and semantic cleanups by Jingoo Han,
  and Rickard Strandqvist especially.

----------------------------------------------------------------
Alexandre Courbot (13):
      gpio: always compile label support
      gpio: move sysfs support to its own file
      gpio: move integer GPIO support to its own file
      gpio: remove export of private of_get_named_gpio_flags()
      gpio: simplify gpiochip_export()
      gpio: make gpiochip_get_desc() gpiolib-private
      gpio: remove gpiod_lock/unlock_as_irq()
      gpio: move gpio_ensure_requested() into legacy C file
      gpio: remove useless check in gpiolib_sysfs_init()
      gpio: remove gpio_ensure_requested()
      gpio: add flags argument to gpiod_get*() functions
      gpio: add missing includes in machine.h
      MAINTAINERS: update GPIO include files

Andrew Ruder (1):
      gpio-pxa: gpio0 and gpio1 support on dt

Guenter Roeck (2):
      gpio: Add support for GPIOF_ACTIVE_LOW to gpio_request_one functions
      gpiolib: Export gpiochip_request_own_desc and gpiochip_free_own_desc

Harini Katakam (2):
      gpio: Add driver for Zynq GPIO controller
      devicetree: Add Zynq GPIO devicetree bindings documentation

Javier Martinez Canillas (3):
      gpio: omap: Remove unnecessary lockdep class
      gpio: omap: Remove unneeded include
      gpio: omap: Add an omap prefix to all functions

Jingoo Han (2):
      gpio: lpc32xx: Make of_device_id array const
      gpio: pxa: Make of_device_id array const

Jürg Billeter (1):
      gpio: rcar: clamp returned value to [0,1]

Lars-Peter Clausen (1):
      gpio: zynq: Clear pending interrupt when enabling a IRQ

Linus Walleij (5):
      gpio: stmpe: switch to use gpiolib irqchip helpers
      gpio: intel-mid: switch to using gpiolib irqchip helpers
      gpio: vr41xx: fix up errorpath on probe()
      gpio: drop retval check enforcing from gpiochip_remove()
      gpio: split gpiod board registration into machine header

Mika Westerberg (2):
      gpio: lynxpoint: Convert to use gpiolib irqchip
      gpio / ACPI: Move event handling registration to gpiolib irqchip helpers

Rickard Strandqvist (2):
      gpio: gpio-twl4030.c: Cleaning up null pointer checks that could
never happen
      gpio: gpio-ucb1400.c: Cleaning up null pointer checks that could
never happen

Sachin Kamat (1):
      MAINTAINERS: Update Samsung pin control entry

Tushar Behera (1):
      gpiolib: of: Update debug messages for of_get_named_gpiod_flags

abdoulaye berthe (1):
      gpio: remove all usage of gpio_remove retval in driver/gpio

 .../devicetree/bindings/gpio/gpio-zynq.txt         |   26 +
 Documentation/gpio/board.txt                       |    2 +-
 Documentation/gpio/consumer.txt                    |   26 +-
 Documentation/gpio/driver.txt                      |   25 +-
 MAINTAINERS                                        |    7 +-
 arch/arm/mach-at91/at91rm9200_devices.c            |    2 +-
 arch/arm/mach-tegra/board-paz00.c                  |    2 +-
 arch/mips/jz4740/board-qi_lb60.c                   |    1 +
 drivers/gpio/Kconfig                               |   10 +-
 drivers/gpio/Makefile                              |    3 +
 drivers/gpio/devres.c                              |   40 +-
 drivers/gpio/gpio-74x164.c                         |    8 +-
 drivers/gpio/gpio-adnp.c                           |    9 +-
 drivers/gpio/gpio-adp5520.c                        |    8 +-
 drivers/gpio/gpio-adp5588.c                        |    6 +-
 drivers/gpio/gpio-amd8111.c                        |    3 +-
 drivers/gpio/gpio-arizona.c                        |    3 +-
 drivers/gpio/gpio-cs5535.c                         |    8 +-
 drivers/gpio/gpio-da9052.c                         |    3 +-
 drivers/gpio/gpio-da9055.c                         |    3 +-
 drivers/gpio/gpio-dwapb.c                          |    2 +-
 drivers/gpio/gpio-em.c                             |    5 +-
 drivers/gpio/gpio-f7188x.c                         |   18 +-
 drivers/gpio/gpio-generic.c                        |    3 +-
 drivers/gpio/gpio-grgpio.c                         |    4 +-
 drivers/gpio/gpio-ich.c                            |    9 +-
 drivers/gpio/gpio-intel-mid.c                      |   86 +-
 drivers/gpio/gpio-it8761e.c                        |    6 +-
 drivers/gpio/gpio-janz-ttl.c                       |    8 +-
 drivers/gpio/gpio-kempld.c                         |    3 +-
 drivers/gpio/gpio-lp3943.c                         |    3 +-
 drivers/gpio/gpio-lpc32xx.c                        |    2 +-
 drivers/gpio/gpio-lynxpoint.c                      |   98 +-
 drivers/gpio/gpio-max730x.c                        |   13 +-
 drivers/gpio/gpio-max732x.c                        |    7 +-
 drivers/gpio/gpio-mc33880.c                        |   11 +-
 drivers/gpio/gpio-mc9s08dz60.c                     |    3 +-
 drivers/gpio/gpio-mcp23s08.c                       |   26 +-
 drivers/gpio/gpio-ml-ioh.c                         |    8 +-
 drivers/gpio/gpio-msm-v2.c                         |    5 +-
 drivers/gpio/gpio-mxc.c                            |    2 +-
 drivers/gpio/gpio-octeon.c                         |    3 +-
 drivers/gpio/gpio-omap.c                           |  275 ++--
 drivers/gpio/gpio-palmas.c                         |    3 +-
 drivers/gpio/gpio-pca953x.c                        |    7 +-
 drivers/gpio/gpio-pcf857x.c                        |    4 +-
 drivers/gpio/gpio-pch.c                            |   10 +-
 drivers/gpio/gpio-pxa.c                            |    7 +-
 drivers/gpio/gpio-rc5t583.c                        |    3 +-
 drivers/gpio/gpio-rcar.c                           |    9 +-
 drivers/gpio/gpio-rdc321x.c                        |    7 +-
 drivers/gpio/gpio-sch.c                            |   16 +-
 drivers/gpio/gpio-sch311x.c                        |    6 +-
 drivers/gpio/gpio-sodaville.c                      |    4 +-
 drivers/gpio/gpio-stmpe.c                          |  119 +-
 drivers/gpio/gpio-sx150x.c                         |    7 +-
 drivers/gpio/gpio-syscon.c                         |    3 +-
 drivers/gpio/gpio-tb10x.c                          |    5 +-
 drivers/gpio/gpio-tc3589x.c                        |    8 +-
 drivers/gpio/gpio-timberdale.c                     |    5 +-
 drivers/gpio/gpio-tps6586x.c                       |    3 +-
 drivers/gpio/gpio-tps65910.c                       |    3 +-
 drivers/gpio/gpio-tps65912.c                       |    3 +-
 drivers/gpio/gpio-ts5500.c                         |    6 +-
 drivers/gpio/gpio-twl4030.c                        |    6 +-
 drivers/gpio/gpio-twl6040.c                        |    3 +-
 drivers/gpio/gpio-ucb1400.c                        |    4 +-
 drivers/gpio/gpio-viperboard.c                     |   10 +-
 drivers/gpio/gpio-vr41xx.c                         |    8 +-
 drivers/gpio/gpio-vx855.c                          |    3 +-
 drivers/gpio/gpio-wm831x.c                         |    3 +-
 drivers/gpio/gpio-wm8350.c                         |    3 +-
 drivers/gpio/gpio-wm8994.c                         |    3 +-
 drivers/gpio/gpio-zynq.c                           |  692 ++++++++++
 drivers/gpio/gpiolib-acpi.c                        |   44 +-
 drivers/gpio/gpiolib-legacy.c                      |  102 ++
 drivers/gpio/gpiolib-of.c                          |   10 +-
 drivers/gpio/gpiolib-sysfs.c                       |  827 ++++++++++++
 drivers/gpio/gpiolib.c                             | 1421 +++-----------------
 drivers/gpio/gpiolib.h                             |  105 +-
 include/asm-generic/gpio.h                         |    3 -
 include/linux/gpio/consumer.h                      |   81 +-
 include/linux/gpio/driver.h                        |   66 +-
 include/linux/gpio/machine.h                       |   61 +
 84 files changed, 2485 insertions(+), 2003 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-zynq.txt
 create mode 100644 drivers/gpio/gpio-zynq.c
 create mode 100644 drivers/gpio/gpiolib-legacy.c
 create mode 100644 drivers/gpio/gpiolib-sysfs.c
 create mode 100644 include/linux/gpio/machine.h
