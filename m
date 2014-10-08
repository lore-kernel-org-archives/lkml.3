Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaJHHuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:50:24 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38934 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbaJHHuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:50:19 -0400
MIME-Version: 1.0
Date: Wed, 8 Oct 2014 09:50:18 +0200
Message-ID: <CACRpkdYa1YKwPxL2CjWr4wnw8pV=GjJ9Yz-VS3+FvKNFdwMHRA@mail.gmail.com>
Subject: [GIT PULL] GPIO bulk changes for the v3.18 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the bulk of GPIO changes for the v3.18 cycle.

When I tested to pull this into your tree I found two conflicts that
also appeared in linux-next, one in the qualcomm driver which
is trivial and one in the gpiolib.c which is also kind of trivial (lower
hunk is the correct one).

The removal if the return value from gpiochip_remove() hits sites
a bit all over the kernel (showing how this API permeates platforms)
but they are mostly ACKed and have survived linux-next testing.

The feature details are in the tag.

Please pull this in! (And fix the glorious conflicts...)

Yours,
Linus Walleij


The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.18-1

for you to fetch changes up to a092e19b688be88f7329bd05f90cb92ebe1a4f5b:

  gpio: pch: Build context save/restore only for PM (2014-10-02 16:07:00 +0200)

----------------------------------------------------------------
This is the bulk of GPIO changes for the v3.18 development
cycle:

- Increase the default ARCH_NR_GPIO from 256 to 512. This
  was done to avoid having a custom <asm/gpio.h> header for
  the x86 architecture - GPIO is custom and complicated
  enough as it is already! We want to move to a radix to
  store the descriptors going forward, and finally get rid
  of this fixed array size altogether.

- Endgame patching of the gpio_remove() semantics initiated
  by Abdoulaye Berthe. It is not accepted by the system that
  the removal of a GPIO chip fails during e.g. reboot or
  shutdown, and therefore the return value has now painfully
  been refactored away. For special cases like GPIO expanders
  on a hot-pluggable bus like USB, we may later add some
  gpiochip_try_remove() call, but for the cases we have now,
  return values are moot.

- Some incremental refactoring of the gpiolib core and ACPI
  GPIO library for more descriptor usage.

- Refactor the chained IRQ handler set-up method to handle
  also threaded, nested interrupts and set up the parent IRQ
  correctly. Switch STMPE and TC3589x drivers to use this
  registration method.

- Add a .irq_not_threaded flag to the struct gpio_chip, so
  that also GPIO expanders that block but are still not
  using threaded IRQ handlers.

- New drivers for the ARM64 X-Gene SoC GPIO controller.

- The syscon GPIO driver has been improved to handle the
  "DSP GPIO" found on the TI Keystone 2 SoC:s.

- ADNP driver switched to use gpiolib irqchip helpers.

- Refactor the DWAPB driver to support being instantiated
  from and MFD cell (platform device).

- Incremental feature improvement in the Zynq, MCP23S08,
  DWAPB, OMAP, Xilinx and Crystalcove drivers.

- Various minor fixes.

----------------------------------------------------------------
Aaron Lu (1):
      gpio: crystalcove: support virtual GPIO

Alexander Shiyan (1):
      GPIO: gpiolib: trivial: Add missing carriage return

Alexandre Courbot (2):
      gpio: acpi: normalize use of gpiochip_get_desc()
      gpio: change gpiochip_request_own_desc() prototype

Axel Lin (3):
      gpio: xgene: Fix missing spin_lock_init()
      gpio: xgene: Remove unneeded forward declation for struct xgene_gpio
      gpio: xgene: Remove unneeded #ifdef CONFIG_OF guard

Behan Webster (1):
      gpio, bcm-kona, LLVMLinux: Remove use of __initconst

Daniel Mack (1):
      gpio: pxa: Documentation: provide example bindings for PXA3xx

Ezra Savard (2):
      gpio: zynq: Mask non-wakeup GPIO interrupts on suspend
      gpio: zynq: Fixed broken wakeup implementation

Fabian Frederick (1):
      gpio: use container_of to resolve cs5535_gpio_chip from gpio_chip

Feng Kan (2):
      gpio: Add APM X-Gene SoC GPIO controller support
      Documentation: gpio: Add APM X-Gene SoC GPIO controller DTS binding

Gernot Vormayr (1):
      gpio: Fix ngpio in gpio-xilinx driver

Grygorii Strashko (4):
      gpio: syscon: add soc specific callback to assign output value
      gpio: syscon: retrive syscon node and regs offsets from dt
      gpio: syscon: reuse for keystone 2 socs
      gpiolib: irqchip: use irq_find_mapping while removing irqchip

Lars-Peter Clausen (2):
      gpio: zynq: Reduce level of indention in zynq_gpio_irqhandler()
      gpio: zynq: Take bank offset into account when reporting a IRQ

Linus Walleij (11):
      gpio: adnp: switch to use irqchip helpers
      pinctrl: remove remaining users of gpiochip_remove() retval
      gpio: remove remaining users of gpiochip_remove() retval
      tty: sc16is7xx: remove retval from gpiochip_remove()
      gpio: dwapb: fix pointer to integer cast
      gpio: set parent irq on chained handlers
      gpio: handle also nested irqchips in the chained handler set-up
      gpio: staticize xway_stp_init()
      gpio: stmpe: fix up interrupt enable logic
      gpio: stmpe: add verbose debug code
      pinctrl: abx500: get rid of unused variable

Markus Pargmann (2):
      gpio: pca953x: Drop deprecated DT bindings
      gpio: pca953x: Add DT binding documentation

Michal Simek (1):
      gpio: zynq: Remove .owner field for driver

Mika Westerberg (1):
      gpio: Increase ARCH_NR_GPIOs to 512

Nishanth Menon (1):
      gpio: omap: Fix interrupt names

Octavian Purdila (1):
      gpiolib: add irq_not_threaded flag to gpio_chip

Paul Bolle (1):
      gpio: samsung: Remove remaining check for CONFIG_S5P_GPIO_DRVSTR

Sonic Zhang (1):
      gpio: mcp23s08 to support both device tree and platform data

Thierry Reding (1):
      gpio: pch: Build context save/restore only for PM

Uwe Kleine-König (2):
      gpio: kona: enable only on BCM_MOBILE or for compile testing
      pinctrl: bcm281xx: make Kconfig dependency more strict

Varka Bhadram (2):
      gpio: ks8695: fix switch case indentation
      gpio: ks8695: fix 'else should follow close brace '}''

Wei Yongjun (1):
      gpio: Fix return value check in xgene_gpio_probe()

Weike Chen (4):
      GPIO: gpio-dwapb: Enable platform driver binding to MFD driver
      GPIO: gpio-dwapb: Change readl&writel to dwapb_read&dwapb_write
      GPIO: gpio-dwapb: Support Debounce
      GPIO: gpio-dwapb: Suspend & Resume PM enabling

abdoulaye berthe (2):
      driver:gpio remove all usage of gpio_remove retval in driver
      gpio: gpiolib: set gpiochip_remove retval to void

 .../devicetree/bindings/gpio/gpio-dsp-keystone.txt |  39 ++
 .../devicetree/bindings/gpio/gpio-pca953x.txt      |  39 ++
 .../devicetree/bindings/gpio/gpio-xgene.txt        |  22 ++
 .../devicetree/bindings/gpio/mrvl-gpio.txt         |  15 +-
 Documentation/gpio/driver.txt                      |   6 +-
 arch/arm/common/scoop.c                            |  10 +-
 arch/mips/txx9/generic/setup.c                     |   4 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c     |   3 +-
 arch/sh/boards/mach-x3proto/gpio.c                 |   6 +-
 drivers/bcma/driver_gpio.c                         |   3 +-
 drivers/gpio/Kconfig                               |  14 +-
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-adnp.c                           | 155 +++-----
 drivers/gpio/gpio-bcm-kona.c                       |   2 +-
 drivers/gpio/gpio-crystalcove.c                    |  28 +-
 drivers/gpio/gpio-cs5535.c                         |   9 +-
 drivers/gpio/gpio-dwapb.c                          | 410 +++++++++++++++++----
 drivers/gpio/gpio-ks8695.c                         |  30 +-
 drivers/gpio/gpio-mcp23s08.c                       |  64 ++--
 drivers/gpio/gpio-omap.c                           |  33 +-
 drivers/gpio/gpio-pca953x.c                        |  54 +--
 drivers/gpio/gpio-pch.c                            |   2 +
 drivers/gpio/gpio-samsung.c                        |  50 ---
 drivers/gpio/gpio-stmpe.c                          |  99 ++++-
 drivers/gpio/gpio-stp-xway.c                       |   2 +-
 drivers/gpio/gpio-syscon.c                         |  94 ++++-
 drivers/gpio/gpio-tc3589x.c                        |   5 +
 drivers/gpio/gpio-xgene.c                          | 244 ++++++++++++
 drivers/gpio/gpio-xilinx.c                         |  27 +-
 drivers/gpio/gpio-zynq.c                           |  89 +++--
 drivers/gpio/gpiolib-acpi.c                        |  30 +-
 drivers/gpio/gpiolib.c                             |  90 +++--
 drivers/hid/hid-cp2112.c                           |   6 +-
 drivers/input/keyboard/adp5588-keys.c              |   4 +-
 drivers/input/keyboard/adp5589-keys.c              |   4 +-
 drivers/input/touchscreen/ad7879.c                 |  10 +-
 drivers/leds/leds-pca9532.c                        |  10 +-
 drivers/leds/leds-tca6507.c                        |   7 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |  10 +-
 drivers/mfd/asic3.c                                |   3 +-
 drivers/mfd/htc-i2cpld.c                           |   8 +-
 drivers/mfd/sm501.c                                |  17 +-
 drivers/mfd/tc6393xb.c                             |  13 +-
 drivers/mfd/ucb1x00-core.c                         |   8 +-
 drivers/pinctrl/Kconfig                            |   2 +-
 drivers/pinctrl/nomadik/pinctrl-abx500.c           |  16 +-
 drivers/pinctrl/nomadik/pinctrl-nomadik.c          |   2 +-
 drivers/pinctrl/qcom/pinctrl-msm.c                 |   9 +-
 drivers/pinctrl/samsung/pinctrl-exynos5440.c       |   6 +-
 drivers/pinctrl/samsung/pinctrl-samsung.c          |  15 +-
 drivers/pinctrl/sirf/pinctrl-sirf.c                |   3 +-
 drivers/platform/x86/intel_pmic_gpio.c             |   3 +-
 drivers/ssb/driver_gpio.c                          |   3 +-
 drivers/staging/vme/devices/vme_pio2_gpio.c        |   4 +-
 drivers/tty/serial/max310x.c                       |  10 +-
 drivers/tty/serial/sc16is7xx.c                     |  13 +-
 drivers/video/fbdev/via/via-gpio.c                 |  10 +-
 include/asm-generic/gpio.h                         |   2 +-
 include/linux/gpio/driver.h                        |   8 +-
 include/linux/platform_data/gpio-dwapb.h           |  32 ++
 include/linux/spi/mcp23s08.h                       |  18 +
 sound/soc/codecs/wm5100.c                          |   5 +-
 sound/soc/codecs/wm8903.c                          |   6 +-
 sound/soc/codecs/wm8962.c                          |   5 +-
 sound/soc/codecs/wm8996.c                          |   6 +-
 65 files changed, 1297 insertions(+), 660 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-dsp-keystone.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pca953x.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-xgene.txt
 create mode 100644 drivers/gpio/gpio-xgene.c
 create mode 100644 include/linux/platform_data/gpio-dwapb.h
