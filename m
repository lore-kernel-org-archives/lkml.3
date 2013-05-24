Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3EXQXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:23:23 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59985 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab3EXQWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:22:25 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>
Subject: [PATCH v2 0/9] Add some TZ1090 SoC infrastructure
Date: Fri, 24 May 2013 17:21:07 +0100
Message-ID: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_24_17_22_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Toumaz Xenif TZ1090 SoC (AKA Comet) contains a 2-threaded
Linux-capable HTP (Meta 2), and is found in a number of development
boards and digital radios, such as the Minimorph Development Platform.

This patchset adds some core infrastructure for the TZ1090, including
drivers for the powerdown controller (PDC) irqchip, general/PDC pin
controllers, and general/PDC GPIO controllers. It's not yet enough to
get the UARTs going (no common clock framework) so JTAG/QEMU with DA TTY
is still needed to get a shell.

A QEMU with a Meta frontend and some TZ1090 emulation, and the SoC
Technical Reference Manual which documents the registers used by both
GPIO drivers and both pin control drivers can be downloaded from the
Minimorph SDK (registration of a Minimorph is currently required):
http://imgtec.com/meta_insider/metaflow-sdk.asp

Changes in v2:

There've been plenty of changes since v1 (thanks for all the feedback!)
so I think it's time for v2. I believe the only feedback not yet
addressed is changing irq-imgpdc driver to use generic irqchip.

 - rebased on v3.10-rc2
 - removed arch/metag/soc/ directory
 - removed arch/metag/include/asm/soc-tz1090/gpio.h
 - irq-imgpdc: use cached versions of irq_en and irq_route registers
 - irq-imgpdc: switch to using raw_spinlock
 - irq-imgpdc: (not had time to switch to generic irqchip yet)
 - add drive strength to generic pinconf debugfs output (patch 4)
 - add BIAS_BUS_HOLD generic pinconf (patch 5)
 - pinctrl-tz1090: switched to generic pinconf (a previous patch adds
   the BIAS_BUS_HOLD generic pinconf)
 - pinctrl-tz1090: changed device tree bindings to more closely match
   generic pinconf (separate tristate, pull-up, pull-down, bus-hold
   flags instead of pull=<X>, drive-strength measured in mA)
 - pinctrl-tz1090: removed "select" pinconf. Instead pins in a pin group
   have their own individual pin groups and can be individually muxed.
   Different pins in same pin mux group muxed to different functions is
   disallowed. Pin switched to peripheral mode when mux enabled.
 - pinctrl-tz1090: make use of BIT() from linux/bitops.h
 - pinctrl-tz1090: add a whole bunch of comments
 - gpio-tz1090: remove references to Linux flags in dt bindings
 - gpio-tz1090: make use of BIT() from linux/bitops.h
 - gpio-tz1090: make register accessors inline to match pinctrl
 - gpio-tz1090: update gpio-ranges to use 3 cells after recent ABI
   breakage
 - pinctrl-tz1090-pdc: switched to generic pinconf (a previous patch
   adds the BIAS_BUS_HOLD generic pinconf)
 - pinctrl-tz1090-pdc: changed device tree bindings to more closely
   match generic pinconf (separate tristate, pull-up, pull-down,
   bus-hold flags instead of pull=<X>, drive-strength measured in mA)
 - pinctrl-tz1090-pdc: make use of BIT() from linux/bitops.h
 - pinctrl-tz1090-pdc: add a whole bunch of comments
 - gpio-tz1090-pdc: remove references to Linux flags in dt bindings
 - gpio-tz1090-pdc: make use of BIT() from linux/bitops.h
 - gpio-tz1090-pdc: make register accessors inline to match pinctrl
 - gpio-tz1090-pdc: update gpio-ranges to use 3 cells after recent ABI
   breakage

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org

James Hogan (9):
  metag: of_platform_populate from arch generic code
  metag: minimal TZ1090 (Comet) SoC infrastructure
  irq-imgpdc: add ImgTec PDC irqchip driver
  pinconf-generic: add drive strength to debugfs output
  pinconf-generic: add BIAS_BUS_HOLD pinconf
  pinctrl-tz1090: add TZ1090 pinctrl driver
  gpio-tz1090: add TZ1090 gpio driver
  pinctrl-tz1090-pdc: add TZ1090 PDC pinctrl driver
  gpio-tz1090-pdc: add TZ1090 PDC gpio driver

 .../devicetree/bindings/gpio/gpio-tz1090-pdc.txt   |   41 +
 .../devicetree/bindings/gpio/gpio-tz1090.txt       |   83 +
 .../devicetree/bindings/metag/pdc-intc.txt         |  112 +
 .../bindings/pinctrl/img,tz1090-pdc-pinctrl.txt    |  128 ++
 .../bindings/pinctrl/img,tz1090-pinctrl.txt        |  223 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/metag/Kconfig.soc                             |   14 +
 arch/metag/Makefile                                |    2 +-
 arch/metag/boot/dts/Makefile                       |    2 +
 arch/metag/boot/dts/tz1090.dtsi                    |  106 +
 arch/metag/boot/dts/tz1090_generic.dts             |   10 +
 arch/metag/configs/tz1090_defconfig                |   42 +
 arch/metag/kernel/setup.c                          |    4 +
 drivers/gpio/Kconfig                               |   14 +
 drivers/gpio/Makefile                              |    2 +
 drivers/gpio/gpio-tz1090-pdc.c                     |  242 +++
 drivers/gpio/gpio-tz1090.c                         |  629 ++++++
 drivers/irqchip/Kconfig                            |    4 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-imgpdc.c                       |  541 +++++
 drivers/pinctrl/Kconfig                            |   12 +
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/pinconf-generic.c                  |    2 +
 drivers/pinctrl/pinctrl-tz1090-pdc.c               | 1105 ++++++++++
 drivers/pinctrl/pinctrl-tz1090.c                   | 2150 ++++++++++++++++++++
 include/linux/pinctrl/pinconf-generic.h            |    6 +
 26 files changed, 5477 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090-pdc.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
 create mode 100644 Documentation/devicetree/bindings/metag/pdc-intc.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
 create mode 100644 arch/metag/boot/dts/tz1090.dtsi
 create mode 100644 arch/metag/boot/dts/tz1090_generic.dts
 create mode 100644 arch/metag/configs/tz1090_defconfig
 create mode 100644 drivers/gpio/gpio-tz1090-pdc.c
 create mode 100644 drivers/gpio/gpio-tz1090.c
 create mode 100644 drivers/irqchip/irq-imgpdc.c
 create mode 100644 drivers/pinctrl/pinctrl-tz1090-pdc.c
 create mode 100644 drivers/pinctrl/pinctrl-tz1090.c

-- 
1.8.1.2


