Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaFBIeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:34:24 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:45209 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFBIeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:34:21 -0400
MIME-Version: 1.0
Date: Mon, 2 Jun 2014 10:34:20 +0200
Message-ID: <CACRpkdY66mpCR857-Q=p__OXY04d0gHmpGtUFOm8DjnmfEtGgg@mail.gmail.com>
Subject: [GIT PULL] GPIO bulk changes for v3.16
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

I guess this can go into your desired "next" branch for v3.16 where
we start landing changes for the v3.16 merge window this week if
I understand your message correctly.

There is a lot of action in the GPIO subsystem doing refactorings
and cleanups, almost as many deletions as insertions and minor
feature growth and no new drivers this time. Which is actually
pretty nice. Some GPIO-related stuff will come in through the pin
control tree as well.

I merged in v3.15-rc4 at one time to get rid of nasty conmflicts
in -next.

Fine-grained details in the signed tag as usual.

The below is well tested in linux-next and should be in real nice
shape (famous last words), so please pull it in.

Yours,
Linus Walleij

The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-v3.16-1

for you to fetch changes up to fc346270124a1a05a5b3c47f277d467ff410b3ae:

  gpio: select IRQ_DOMAIN for gpiolib irqchip helpers (2014-05-29
16:52:46 +0200)

----------------------------------------------------------------
This is the bulk of GPIO changes for the v3.16 series:

- We are finalizing and fixing up the gpiochip irqchip helpers
  bringing a helpful irqchip implementation into the gpiolib
  core and avoiding duplicate code and, more importantly,
  duplicate bug fixes:

  - Support for using the helpers with threaded interrupt
    handlers as used on sleeping GPIO-irqchips

  - Do not set up hardware triggers for edges or levels if
    the default IRQ type is IRQ_TYPE_NONE - some drivers
    would exploit the fact that you could get default
    initialization of the IRQ type from the core at probe()
    but if no default type is set up from the helper, we
    should not call the driver to configure anything. Wait
    until a consumer requests the interrupt instead.

  - Make the irqchip helpers put the GPIO irqs into their
    own lock class. The GPIO irqchips can often emit
    (harmless, but annoying) lockdep warnings about recursions
    when they are in fact just cascaded IRQs. By putting
    them into their own lock class we help the lockdep core
    to keep track of things.

  - Switch the tc3589x GPIO expanders to use the irqchip
    helpers

  - Switch the OMAP GPIO driver to use the irqchip helpers

  - Add some documentation for the irqchip helpers

  - select IRQ_DOMAIN when using the helpers since some
    platforms may not be using this by default and it's a
    strict dependency.

- Continued GPIO descriptor refactoring:

  - Remove the one instance of gpio_to_desc() from the
    device tree code, making the OF GPIO code use GPIO
    descriptors only.

  - Introduce gpiod_get_optional() and
    gpiod_get_optional_index() akin to the similar
    regulator functions for cases where the use of GPIO
    is optional and not strictly required.

  - Make of_get_named_gpiod_flags() private - we do not
    want to unnecessarily expose APIs to drivers that
    make the gpiolib harder than necessary to maintain
    and refactor. Privatize this function.

- Support "-gpio" suffix for the OF GPIO retrieveal path.
  We used to look for "foo-gpios" or just "gpios" in device
  tree nodes, but it turns out that some drivers with a
  single GPIO line will just state "foo-gpio" (singularis).
  Sigh. Support this with a fallback looking for it, as
  this simplifies driver code and handles it in core code.

- Switch the ACPI GPIO core to fetch GPIOs with the
  *_cansleep function variants as the GPIO operation
  region handler can sleep, and shall be able to handle
  gpiochips that sleep.

- Tons of cleanups and janitorial work from Jingoo Han,
  Axel Lin, Javier Martinez Canillas and Abdoulaye Berthe.
  Notably Jingoo cut off a ton of pointless OOM messages.

- Incremental development and fixes for various drivers,
  nothing really special here.

----------------------------------------------------------------
Aaron Lu (1):
      gpio / ACPI: use *_cansleep version of gpiod_get/set APIs

Alexander Shiyan (1):
      gpio: ge: Convert to platform driver

Alexandre Courbot (1):
      gpio: make of_get_named_gpiod_flags() private

Anthony Fee (1):
      gpio: generic: add request function pointer

Arnd Bergmann (2):
      gpio: always enable GPIO_OMAP on ARCH_OMAP
      gpio: include linux/bug.h in interface header

Axel Lin (7):
      gpio: zevio: Remove of_match_ptr around zevio_gpio_of_match
      gpio: zevio: Get correct gpio output value
      gpio: max730x: Remove kfree(ts) in __max730x_remove()
      gpio: pl061/sx150x: Remove unneeded include of linux/workqueue.h
      gpio: sch311x: Slightly refactor sch311x_detect for better readability
      gpio: kempld: Fix autoloading of module
      gpio: rdc321x: Convert to use devm_kzalloc

Daniel Krueger (1):
      gpio-sch: set output level after configuration of direction

Ezequiel Garcia (1):
      gpio: mvebu: Remove initcall-based driver initialization

Geert Uytterhoeven (2):
      gpio: rcar: Add optional functional clock to bindings
      gpio: rcar: Add minimal runtime PM support

George Cherian (2):
      gpio: pcf857x: Avoid calling irq_domain_cleanup twice
      gpio: pcf857x: Add IRQF_SHARED when request irq

Jarkko Nikula (1):
      Documentation / ACPI: Fix location of GPIO documentation

Javier Martinez Canillas (9):
      gpio: omap: convert to use irq_domain_add_simple()
      gpio: omap: check gpiochip_add() return value
      gpio: omap: add a GPIO_OMAP option instead of using ARCH_OMAP
      gpio: omap: convert driver to use gpiolib irqchip
      MAINTAINERS: update GPIO OMAP driver entry
      gpio: em: use BIT() macro instead of shifting bits
      gpio: kempld: use BIT() macro instead of shifting bits
      gpio: omap: use BIT() macro instead of shifting bits
      gpio: pl061: use BIT() macro instead of shifting bits

Jean Delvare (3):
      gpio: timberdale: simplify dependencies
      gpio-pch: Fix Kconfig dependencies
      gpio: Add run-time dependencies to R-Car driver

Jingoo Han (25):
      gpio: adp5520: remove unnecessary OOM messages
      gpio: adp5588: remove unnecessary OOM messages
      gpio: davinci: remove unnecessary OOM messages
      gpio: em: remove unnecessary OOM messages
      gpio: janz-ttl: remove unnecessary OOM messages
      gpio: lynxpoint: remove unnecessary OOM messages
      gpio: moxart: remove unnecessary OOM messages
      gpio: mvebu: remove unnecessary OOM messages
      gpio: palmas: remove unnecessary OOM messages
      gpio: rc5t583: remove unnecessary OOM messages
      gpio: rcar: remove unnecessary OOM messages
      gpio: rdc321x: remove unnecessary OOM messages
      gpio: SPEAr: remove unnecessary OOM messages
      gpio: tegra: remove unnecessary OOM messages
      gpio: tps6586x: remove unnecessary OOM messages
      gpio: tps65910: remove unnecessary OOM messages
      gpio: zevio: remove unnecessary OOM messages
      gpio: grgpio: Make of_device_id array const
      gpio: mcp23s08: Make of_device_id array const
      gpio: mvebu: Make of_device_id array const
      gpio: palmas: Make of_device_id array const
      gpio: tegra: Make of_device_id array const
      gpio: xilinx: Make of_device_id array const
      gpio: zevio: Make of_device_id array const
      gpio: ep93xx: Use devm_ioremap_resource()

Linus Walleij (13):
      gpio: support threaded interrupts in irqchip helpers
      gpio: tc3589x: use managed resources
      gpio: tc3589x: get rid of static IRQ base
      gpio: tc3589x: use gpiolib irqchip helpers
      gpio: document gpio irqchips a bit more, describe helpers
      gpio: put GPIO IRQs into their own lock class
      gpiolib: of: remove gpio_to_desc() usage
      gpio: do not set up hardware for IRQ_TYPE_NONE
      Merge tag 'v3.15-rc4' into devel
      gpio: pch: add slab include
      gpio: mcp23s08: switch chip count to int
      gpio: pca953x: use gpiolib irqchip helpers
      gpio: select IRQ_DOMAIN for gpiolib irqchip helpers

Michael Stickel (1):
      gpio: mcp23s08: fixed count variable for devicetree probing

Rajendra Nayak (1):
      gpio: omap: prepare and unprepare the debounce clock

Sebastian Andrzej Siewior (2):
      gpio: dwapb: drop irq_setup_generic_chip()
      gpio: dwapb: use a second irq chip

Thierry Reding (5):
      gpio: of: Remove unneeded dummy function
      gpio: of: Allow -gpio suffix for property names
      gpio: Fix gpio_get -> gpiod_get typo in kernel-doc
      gpio: Add missing device-managed documentation
      gpio: Add helpers for optional GPIOs

Toby Smith (2):
      gpio: pca953x: return IRQ_NONE when appropriate
      gpio: pca953x: request a shared interrupt

Yegor Yefremov (1):
      gpio: omap: implement get_direction

abdoulaye berthe (4):
      gpio: bt8xx: use devm function for memory allocation
      gpio: timberdale: use devm functions
      gpio: janzttl: use devm function
      gpio: gpioep93xx: use devm functions

 Documentation/acpi/enumeration.txt                 |   2 +-
 .../devicetree/bindings/gpio/renesas,gpio-rcar.txt |   6 +
 Documentation/driver-model/devres.txt              |   7 +
 Documentation/gpio/driver.txt                      |  59 ++++++
 MAINTAINERS                                        |   1 +
 drivers/gpio/Kconfig                               |  20 +-
 drivers/gpio/Makefile                              |   2 +-
 drivers/gpio/devres.c                              |  43 +++++
 drivers/gpio/gpio-adp5520.c                        |   4 +-
 drivers/gpio/gpio-adp5588.c                        |   4 +-
 drivers/gpio/gpio-bt8xx.c                          |  19 +-
 drivers/gpio/gpio-davinci.c                        |   4 +-
 drivers/gpio/gpio-dwapb.c                          |  38 ++--
 drivers/gpio/gpio-em.c                             |   3 +-
 drivers/gpio/gpio-ep93xx.c                         |  34 +---
 drivers/gpio/gpio-ge.c                             | 174 ++++++-----------
 drivers/gpio/gpio-generic.c                        |   9 +
 drivers/gpio/gpio-grgpio.c                         |   2 +-
 drivers/gpio/gpio-janz-ttl.c                       |  38 +---
 drivers/gpio/gpio-kempld.c                         |   4 +-
 drivers/gpio/gpio-lynxpoint.c                      |   4 +-
 drivers/gpio/gpio-max730x.c                        |   5 +-
 drivers/gpio/gpio-mcp23s08.c                       |  17 +-
 drivers/gpio/gpio-moxart.c                         |   4 +-
 drivers/gpio/gpio-mvebu.c                          |  13 +-
 drivers/gpio/gpio-omap.c                           | 205 +++++++++++----------
 drivers/gpio/gpio-palmas.c                         |   6 +-
 drivers/gpio/gpio-pca953x.c                        | 102 ++++------
 drivers/gpio/gpio-pcf857x.c                        |  11 +-
 drivers/gpio/gpio-pch.c                            |   1 +
 drivers/gpio/gpio-pl061.c                          |  27 ++-
 drivers/gpio/gpio-rc5t583.c                        |   4 +-
 drivers/gpio/gpio-rcar.c                           |   9 +-
 drivers/gpio/gpio-rdc321x.c                        |  23 +--
 drivers/gpio/gpio-sch.c                            |  26 ++-
 drivers/gpio/gpio-sch311x.c                        |  16 +-
 drivers/gpio/gpio-spear-spics.c                    |   4 +-
 drivers/gpio/gpio-sx150x.c                         |   1 -
 drivers/gpio/gpio-tc3589x.c                        | 148 ++++-----------
 drivers/gpio/gpio-tegra.c                          |   6 +-
 drivers/gpio/gpio-timberdale.c                     |  47 ++---
 drivers/gpio/gpio-tps6586x.c                       |   4 +-
 drivers/gpio/gpio-tps65910.c                       |   4 +-
 drivers/gpio/gpio-xilinx.c                         |   2 +-
 drivers/gpio/gpio-zevio.c                          |  18 +-
 drivers/gpio/gpiolib-acpi.c                        |   5 +-
 drivers/gpio/gpiolib-of.c                          |  16 +-
 drivers/gpio/gpiolib.c                             | 101 ++++++++--
 drivers/gpio/gpiolib.h                             |   5 +
 include/linux/gpio/consumer.h                      |  41 +++++
 include/linux/gpio/driver.h                        |   5 +-
 include/linux/mfd/tc3589x.h                        |   1 -
 include/linux/of_gpio.h                            |  35 +---
 53 files changed, 705 insertions(+), 684 deletions(-)
