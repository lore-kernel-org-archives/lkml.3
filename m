Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaAUIgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 03:36:50 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:54530 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaAUIgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 03:36:47 -0500
MIME-Version: 1.0
Date: Tue, 21 Jan 2014 09:36:46 +0100
Message-ID: <CACRpkdY8Dk=i1-=rKU6gTM+3YHQ286r1u4z2WhLDQtcqLpyM2Q@mail.gmail.com>
Subject: [GIT PULL] GPIO bulk changes for v3.14
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is the big GPIO pull request for the v3.14 series. It's big this time
but has been brewing in linux-next for some time and it's all good stuff
IMO. The changes to other subsystems (notably a slew of ARM machines
as I am doing away with their custom APIs) have all been ACKed to the
extent possible.

Details are in the signed tag.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.14-1

for you to fetch changes up to de755c330512364d3396c7da0c20b1c20b3b08b2:

  gpio: mcp23s08: fix casting caused build warning (2014-01-20 09:10:03 +0100)

----------------------------------------------------------------
GPIO tree bulk changes for v3.14

A big set this merge window, as we have much going on in
this subsystem. Major changes this time:

- Some core improvements and cleanups to the new GPIO
  descriptor API. This seems to be working now so we can
  start the exodus to this API, moving gradually away from
  the global GPIO numberspace.

- Incremental improvements to the ACPI GPIO core, and move
  the few GPIO ACPI clients we have to the GPIO descriptor
  API right *now* before we go any further. We actually
  managed to contain this *before* we started to litter
  the kernel with yet another hackish global numberspace for
  the ACPI GPIOs, which is a big win.

- The RFkill GPIO driver and all platforms using it have
  been migrated to use the GPIO descriptors rather than
  fixed number assignments. Tegra machine has been migrated
  as part of this.

- New drivers for MOXA ART, Xtensa GPIO32 and SMSC SCH311x.
  Those should be really good examples of how I expect a
  nice GPIO driver to look these days.

- Do away with custom GPIO implementations on a major
  part of the ARM machines: ks8695, lpc32xx, mv78xx0.
  Make a first step towards the same in the horribly
  convoluted Samsung S3C include forest. We expect to
  continue to clean this up as we move forward.

- Flag GPIO lines used for IRQ on adnp, bcm-kona, em,
  intel-mid and lynxpoint.
  This makes the GPIOlib core aware that a certain GPIO line
  is used for IRQs and can then enforce some semantics such
  as disallowing a GPIO line marked as in use for IRQ to be
  switched to output mode.

- Drop all use of irq_set_chip_and_handler_name().
  The name provided in these cases were just unhelpful
  tags like "mux" or "demux".

- Extend the MCP23s08 driver to handle interrupts.

- Minor incremental improvements for rcar, lynxpoint, em
  74x164 and msm drivers.

- Some non-urgent bug fixes here and there, duplicate
  #includes and that usual kind of cleanups.

----------------------------------------------------------------
Alexander Shiyan (4):
      gpio: 74x164: Remove non-DT support
      gpio: 74x164: Driver cleanup
      gpio: clps711x: Use of_match_ptr()
      gpio: clps711x: Enable driver compilation with COMPILE_TEST

Alexandre Courbot (3):
      gpio: rewrite gpiochip_offset_to_desc()
      gpio: better lookup method for platform GPIOs
      gpiolib: return -ENOENT if no GPIO mapping exists

Andy Shevchenko (4):
      gpiolib: unify pr_* messages format
      gpiolib: introduce chip_* to print with chip->label prefix
      gpiolib: convert gpiod_lookup description to kernel-doc
      gpiolib: update inline documentation of gpiod_get_index()

Baruch Siach (2):
      gpio: driver for Xtensa GPIO32
      gpio: xtensa: depend on HAVE_XTENSA_GPIO32

Bruno Randolf (1):
      gpio: add GPIO support for SMSC SCH311x

Heikki Krogerus (2):
      ARM: tegra: add gpiod_lookup table for paz00
      net: rfkill: gpio: convert to descriptor-based GPIO interface

Jean Delvare (1):
      gpio-lynxpoint: Allow building as a module

Jingoo Han (1):
      gpio: remove DEFINE_PCI_DEVICE_TABLE macro

Jonas Jensen (2):
      gpio: Add MOXA ART GPIO driver
      gpio: MOXA ART: rename moxart_gpio_base to base

José Miguel Gonçalves (1):
      ARM: S3C24XX: Fix configuration of gpio port sizes on S3C24XX.

Lars Poeschel (1):
      gpio: mcp23s08: Add irq functionality for i2c chips

Laurent Pinchart (2):
      gpio: rcar: Support both edge trigger with DT
      gpio: rcar: Add r8a7791 support to the DT bindings

Linus Walleij (20):
      gpio: drop users of irq_set_chip_and_handler_name()
      ARM: ks8695: delete local <mach/gpio.h> header
      ARM: lpc32xx: delete local <mach/gpio.h> header
      ARM: lpc32xx: move custom GPIO header
      ARM: mv78xx0: delete local <mach/gpio.h> header
      gpio/pinctrl: make gpio_chip members typed boolean
      gpio: lock adnp IRQs when enabling them
      gpio: bcm-kona: lock IRQs when starting them
      gpio: em: lock IRQs when starting them
      gpio: intel-mid: lock IRQs when starting them
      gpio: lynxpoint: lock IRQs when starting them
      Merge branch 'mark-irqs' into devel
      Merge tag 'v3.13-rc3' into devel
      ARM: s3c24xx: get rid of custom <mach/gpio.h>
      ARM: s3c64xx: get rid of custom <mach/gpio.h>
      gpio: sch311x: fix compilation error
      ARM: s3c24xx: fix build error
      ARM: S3C[24|64]xx: move includes back under <mach/> scope
      ARM: s3c24xx: explicit dependency on <plat/gpio-cfg.h>
      gpio: mcp23s08: depend on OF_GPIO

Magnus Damm (5):
      gpio: rcar: Use lazy disable
      gpio: rcar: Enable mask on suspend
      gpio: em: Setup gpiochip->dev
      gpio: em: Use lazy disable
      gpio: em: Enable mask on suspend

Mika Westerberg (6):
      gpio/lynxpoint: add new ACPI ID
      gpio / ACPI: return -ENOENT when no mapping exists
      mmc: sdhci-acpi: convert to use GPIO descriptor API
      gpio / ACPI: register to ACPI events automatically
      gpio / ACPI: get rid of acpi_gpio.h
      Documentation / ACPI: update to GPIO descriptor API

Neil Zhang (1):
      gpio: pxa: clamp gpio get value to [0,1]

Sachin Kamat (7):
      gpio: max730x: Remove redundant dev_set_drvdata
      gpio: mxc: Do not hard code return value
      gpio: mvebu: Do not hard code error code
      gpio: tb10x: Remove redundant of_match_ptr helper
      gpio: samsung: Remove hardware.h inclusion
      gpio: samsung: Update documentation
      ARM: S5P[v210|c100|64x0]: Fix build error

SeongJae Park (1):
      gpio: mcp23s08: fix casting caused build warning

Simon Guinot (1):
      gpio: f7188x: set can_sleep attribute

Stephen Boyd (1):
      gpio: msm: Add module device table and mark table const

Stephen Warren (1):
      gpio: tegra: add missing error handling to probe

Tushar Behera (1):
      leds: s3c24xx: Fix build failure

Victor Kamensky (1):
      gpio/omap: raw read and write endian fix

Vishwanathrao Badarkhe, Manish (1):
      gpio: Remove duplicate include of errno.h

Wei Yongjun (3):
      gpio: moxart: add missing .owner to struct gpio_chip
      gpio: moxart: remove redundant dev_err call in moxart_gpio_probe()
      gpio: sodaville: fix some error return code on error path

 Documentation/acpi/enumeration.txt                 |  36 +-
 Documentation/arm/Samsung-S3C24XX/GPIO.txt         |  13 +-
 .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |  28 +-
 .../devicetree/bindings/gpio/moxa,moxart-gpio.txt  |  19 +
 .../devicetree/bindings/gpio/renesas,gpio-rcar.txt |   3 +-
 Documentation/gpio/board.txt                       |  28 +-
 Documentation/gpio/consumer.txt                    |   6 +-
 arch/arm/Kconfig                                   |   4 +-
 arch/arm/mach-ks8695/include/mach/gpio.h           |  19 -
 arch/arm/mach-lpc32xx/include/mach/gpio.h          |   6 -
 arch/arm/mach-lpc32xx/phy3250.c                    |   2 +-
 arch/arm/mach-mv78xx0/include/mach/gpio.h          |   9 -
 arch/arm/mach-s3c24xx/Kconfig                      |  21 -
 arch/arm/mach-s3c24xx/common-smdk.c                |   2 +-
 arch/arm/mach-s3c24xx/h1940-bluetooth.c            |   2 +
 .../include/mach/{gpio.h => gpio-samsung.h}        |  26 +-
 arch/arm/mach-s3c24xx/mach-amlm5900.c              |   1 +
 arch/arm/mach-s3c24xx/mach-anubis.c                |   1 +
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |   1 +
 arch/arm/mach-s3c24xx/mach-bast.c                  |   1 +
 arch/arm/mach-s3c24xx/mach-gta02.c                 |   1 +
 arch/arm/mach-s3c24xx/mach-h1940.c                 |   1 +
 arch/arm/mach-s3c24xx/mach-jive.c                  |   1 +
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   1 +
 arch/arm/mach-s3c24xx/mach-n30.c                   |   1 +
 arch/arm/mach-s3c24xx/mach-nexcoder.c              |   1 +
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c            |   1 +
 arch/arm/mach-s3c24xx/mach-osiris.c                |   1 +
 arch/arm/mach-s3c24xx/mach-qt2410.c                |   1 +
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   2 +
 arch/arm/mach-s3c24xx/mach-rx3715.c                |   1 +
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |   1 +
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |   1 +
 arch/arm/mach-s3c24xx/mach-vr1000.c                |   1 +
 arch/arm/mach-s3c24xx/pm-s3c2410.c                 |   2 +
 arch/arm/mach-s3c24xx/pm.c                         |   1 +
 arch/arm/mach-s3c24xx/s3c2410.c                    |   1 +
 arch/arm/mach-s3c24xx/s3c2416.c                    |   1 +
 arch/arm/mach-s3c24xx/s3c2440.c                    |   1 +
 arch/arm/mach-s3c24xx/s3c2442.c                    |   1 +
 arch/arm/mach-s3c24xx/s3c2443.c                    |   1 +
 arch/arm/mach-s3c24xx/setup-i2c.c                  |   1 +
 arch/arm/mach-s3c24xx/setup-sdhci-gpio.c           |   1 +
 arch/arm/mach-s3c24xx/setup-ts.c                   |   2 +
 arch/arm/mach-s3c24xx/simtec-usb.c                 |   1 +
 arch/arm/mach-s3c64xx/Kconfig                      |   3 -
 arch/arm/mach-s3c64xx/common.c                     |   1 +
 arch/arm/mach-s3c64xx/crag6410.h                   |   2 +-
 arch/arm/mach-s3c64xx/dev-audio.c                  |   1 +
 .../include/mach/{gpio.h => gpio-samsung.h}        |   9 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c               |   1 +
 arch/arm/mach-s3c64xx/mach-crag6410.c              |   2 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |   1 +
 arch/arm/mach-s3c64xx/mach-mini6410.c              |   1 +
 arch/arm/mach-s3c64xx/mach-real6410.c              |   1 +
 arch/arm/mach-s3c64xx/mach-smartq.c                |   1 +
 arch/arm/mach-s3c64xx/mach-smartq5.c               |   1 +
 arch/arm/mach-s3c64xx/mach-smartq7.c               |   1 +
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |   1 +
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |   1 +
 arch/arm/mach-s3c64xx/pm.c                         |   1 +
 arch/arm/mach-s3c64xx/setup-fb-24bpp.c             |   1 +
 arch/arm/mach-s3c64xx/setup-i2c0.c                 |   1 +
 arch/arm/mach-s3c64xx/setup-i2c1.c                 |   1 +
 arch/arm/mach-s3c64xx/setup-ide.c                  |   1 +
 arch/arm/mach-s3c64xx/setup-keypad.c               |   1 +
 arch/arm/mach-s3c64xx/setup-sdhci-gpio.c           |   1 +
 arch/arm/mach-s3c64xx/setup-spi.c                  |   1 +
 arch/arm/mach-tegra/board-paz00.c                  |  11 +
 arch/arm/plat-samsung/pm-gpio.c                    |   4 +
 arch/arm/plat-samsung/setup-camif.c                |   1 +
 arch/xtensa/Kconfig                                |   6 +
 drivers/gpio/Kconfig                               |  38 +-
 drivers/gpio/Makefile                              |   3 +
 drivers/gpio/gpio-74x164.c                         |  59 +--
 drivers/gpio/gpio-adnp.c                           |  25 +-
 drivers/gpio/gpio-adp5520.c                        |   2 +-
 drivers/gpio/gpio-adp5588.c                        |   2 +-
 drivers/gpio/gpio-amd8111.c                        |   2 +-
 drivers/gpio/gpio-arizona.c                        |   2 +-
 drivers/gpio/gpio-bcm-kona.c                       |  22 ++
 drivers/gpio/gpio-bt8xx.c                          |   4 +-
 drivers/gpio/gpio-clps711x.c                       |   4 +-
 drivers/gpio/gpio-da9052.c                         |   2 +-
 drivers/gpio/gpio-da9055.c                         |   2 +-
 drivers/gpio/gpio-em.c                             |  28 +-
 drivers/gpio/gpio-f7188x.c                         |   1 +
 drivers/gpio/gpio-ich.c                            |   2 +-
 drivers/gpio/gpio-intel-mid.c                      |  30 +-
 drivers/gpio/gpio-kempld.c                         |   2 +-
 drivers/gpio/gpio-ks8695.c                         |   2 +-
 drivers/gpio/gpio-lpc32xx.c                        |  14 +-
 drivers/gpio/gpio-lynxpoint.c                      |  39 +-
 drivers/gpio/gpio-max730x.c                        |   5 +-
 drivers/gpio/gpio-max732x.c                        |   2 +-
 drivers/gpio/gpio-mc33880.c                        |   2 +-
 drivers/gpio/gpio-mc9s08dz60.c                     |   2 +-
 drivers/gpio/gpio-mcp23s08.c                       | 252 +++++++++++-
 drivers/gpio/gpio-ml-ioh.c                         |   4 +-
 drivers/gpio/gpio-moxart.c                         | 156 ++++++++
 drivers/gpio/gpio-msic.c                           |   9 +-
 drivers/gpio/gpio-msm-v2.c                         |   3 +-
 drivers/gpio/gpio-mvebu.c                          |   4 +-
 drivers/gpio/gpio-mxc.c                            |   2 +-
 drivers/gpio/gpio-octeon.c                         |   2 +-
 drivers/gpio/gpio-omap.c                           | 188 ++++-----
 drivers/gpio/gpio-palmas.c                         |   2 +-
 drivers/gpio/gpio-pca953x.c                        |   2 +-
 drivers/gpio/gpio-pcf857x.c                        |   2 +-
 drivers/gpio/gpio-pch.c                            |   4 +-
 drivers/gpio/gpio-pxa.c                            |   3 +-
 drivers/gpio/gpio-rc5t583.c                        |   2 +-
 drivers/gpio/gpio-rcar.c                           |  61 ++-
 drivers/gpio/gpio-samsung.c                        |  11 +-
 drivers/gpio/gpio-sch311x.c                        | 432 +++++++++++++++++++++
 drivers/gpio/gpio-sodaville.c                      |  10 +-
 drivers/gpio/gpio-sta2x11.c                        |   2 +-
 drivers/gpio/gpio-stmpe.c                          |   2 +-
 drivers/gpio/gpio-sx150x.c                         |   2 +-
 drivers/gpio/gpio-tb10x.c                          |   4 +-
 drivers/gpio/gpio-tc3589x.c                        |   2 +-
 drivers/gpio/gpio-tegra.c                          |   7 +-
 drivers/gpio/gpio-timberdale.c                     |   6 +-
 drivers/gpio/gpio-tnetv107x.c                      |   2 +-
 drivers/gpio/gpio-tps6586x.c                       |   2 +-
 drivers/gpio/gpio-tps65910.c                       |   2 +-
 drivers/gpio/gpio-tps65912.c                       |   2 +-
 drivers/gpio/gpio-twl4030.c                        |   2 +-
 drivers/gpio/gpio-twl6040.c                        |   2 +-
 drivers/gpio/gpio-ucb1400.c                        |   2 +-
 drivers/gpio/gpio-viperboard.c                     |   4 +-
 drivers/gpio/gpio-vx855.c                          |   2 +-
 drivers/gpio/gpio-wm831x.c                         |   2 +-
 drivers/gpio/gpio-wm8350.c                         |   2 +-
 drivers/gpio/gpio-wm8994.c                         |   2 +-
 drivers/gpio/gpio-xtensa.c                         | 163 ++++++++
 drivers/gpio/gpiolib-acpi.c                        |  23 +-
 drivers/gpio/gpiolib.c                             | 251 ++++++------
 drivers/gpio/gpiolib.h                             |  46 +++
 drivers/leds/leds-s3c24xx.c                        |   1 +
 drivers/mmc/host/s3cmci.c                          |   2 +
 drivers/mmc/host/sdhci-acpi.c                      |  29 +-
 drivers/pinctrl/pinctrl-as3722.c                   |   2 +-
 drivers/pinctrl/pinctrl-at91.c                     |   2 +-
 drivers/pinctrl/pinctrl-baytrail.c                 |   6 +-
 drivers/pinctrl/pinctrl-bcm2835.c                  |   2 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |   2 +-
 drivers/pinctrl/pinctrl-sunxi.c                    |   2 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c               |   2 +-
 include/linux/acpi_gpio.h                          |  51 ---
 include/linux/gpio.h                               |   1 -
 include/linux/gpio/driver.h                        |  56 ++-
 .../linux/platform_data}/gpio-lpc32xx.h            |   0
 include/linux/spi/74x164.h                         |   9 -
 net/rfkill/rfkill-gpio.c                           |  77 ++--
 155 files changed, 1859 insertions(+), 677 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/moxa,moxart-gpio.txt
 delete mode 100644 arch/arm/mach-ks8695/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/gpio.h
 rename arch/arm/mach-s3c24xx/include/mach/{gpio.h => gpio-samsung.h} (85%)
 rename arch/arm/mach-s3c64xx/include/mach/{gpio.h => gpio-samsung.h} (95%)
 create mode 100644 drivers/gpio/gpio-moxart.c
 create mode 100644 drivers/gpio/gpio-sch311x.c
 create mode 100644 drivers/gpio/gpio-xtensa.c
 create mode 100644 drivers/gpio/gpiolib.h
 delete mode 100644 include/linux/acpi_gpio.h
 rename {arch/arm/mach-lpc32xx/include/mach =>
include/linux/platform_data}/gpio-lpc32xx.h (100%)
 delete mode 100644 include/linux/spi/74x164.h
