Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbaLCAMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:12:31 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:33422 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319AbaLCAMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:12:24 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH 00/12] ARM: vf610m4: Add Vybrid Cortex-M4 support
Date: Wed,  3 Dec 2014 01:11:59 +0100
Message-Id: <1417565531-4507-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second version (first was RFC) of this patchset. It
contains feedback from RFC and mainly grew by the support for the
interrupt router which is part of the MSCM IP contained in Vybrid.
MSCM provides a simple router for the pheriperal interrupts which
allows to select which CPU should receive a certain interrupt.
Hence it is crucrial for Linux. Right now, the boot loader enables
all interrupts for the Cortex-A5. To make Linux on Cortex-M4
working, the interrupts of the peripherals have been manually
remapped. A proper driver would automate this, along with a "poor
mans resource controller" (WARN_ON when the interrupt is routed).
This IP appears only to be part of Vybrid, the somewhat similar
SoC i.MX6SoloX does not contain this IP, hence I made it rather
Vybrid specific.

I think some patches are already merge ready (unified addruart),
while some need likely more discussion (NVIC irq router support,
MSCM stuff).

Especially I did not solved the multiplatform problem. Arnd, I
read your patches and started to think about it, but I'm not sure
I'm the right person doing that since my view of the ARM world
is still rather limited... But for Vybrid, it would be very useful
and simplify Kconfig (would avoid the additional arch ARCH_MXCM4).

With the m4boot utility (https://github.com/falstaff84/m4boot), a
XIP kernel image with its dtb and a initramfs, the Cortex-M4 can
be booted on a mainline kernel using:

./m4boot xipImage initramfs.cpio.lzo vf610m4-colibri.dtb

(some U-Boot fiddling needed, ask for details if you really want
to test that)

Changes since RFC:
- Unified addruart calls for MMU/!MMU
- Add MSCM support along with routable IRQ support in NVIC
- Rebased on Shawns for-next tree which made some changes
  obsolete (mainly the Vybrid SoC device tree files in for-next
  are already prepared for Cortex-M4 support)
- Removed SRC_GPR3 hack, this is now part of a mini boot-loader:
  https://github.com/falstaff84/vf610m4bootldr

Stefan Agner (12):
  ARM: dts: vf610: add routable-irqs property for gic node
  ARM: dts: vf610: add Miscellaneous System Control Module (MSCM)
  irqchip: gic: define register_routable_domain_ops conditional
  irqchip: nvic: support routable irq domain ops
  irqchip: nvic: increase number of external interrupts to 112
  ARM: imx: add support for MSCM interrupt router
  Documentation: dt: imx: add MSCM documentation
  clocksource: add dependencies for Vybrid pit clocksource
  ARM: unify MMU/!MMU addruart calls
  ARM: vf610m4: add new machine and SoC for Vybrid on Cortex-M4
  ARM: dts: add support for Vybrid running on Cortex-M4
  ARM: vf610m4: add defconfig for Linux on Vybrids Cortex-M4

 .../bindings/arm/freescale/fsl,vf610-mscm.txt      |  14 ++
 arch/arm/Kconfig                                   |  12 ++
 arch/arm/Kconfig.debug                             |   4 +-
 arch/arm/Makefile                                  |   1 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/vf500.dtsi                       |   1 +
 arch/arm/boot/dts/vf610m4-colibri.dts              |  52 ++++++++
 arch/arm/boot/dts/vf610m4.dtsi                     |  33 +++++
 arch/arm/boot/dts/vfxxx.dtsi                       |   5 +
 arch/arm/configs/vf610m4_defconfig                 |  49 +++++++
 arch/arm/include/debug/efm32.S                     |   2 +-
 arch/arm/kernel/debug.S                            |   2 +-
 arch/arm/kernel/entry-v7m.S                        |   6 +-
 arch/arm/mach-imx/Kconfig                          |  27 ++++
 arch/arm/mach-imx/Makefile                         |   2 +
 arch/arm/mach-imx/Makefile.boot                    |   0
 arch/arm/mach-imx/common.h                         |   1 +
 arch/arm/mach-imx/mach-vf610.c                     |   7 +
 arch/arm/mach-imx/mach-vf610m4.c                   |  31 +++++
 arch/arm/mach-imx/mscm-vf610.c                     | 141 +++++++++++++++++++++
 drivers/clocksource/Kconfig                        |   2 +
 drivers/irqchip/irq-nvic.c                         |  72 ++++++++++-
 drivers/mmc/host/Kconfig                           |   2 +-
 drivers/pinctrl/freescale/Kconfig                  |   2 +-
 include/linux/irqchip/arm-gic.h                    |   3 +
 include/linux/irqchip/arm-nvic.h                   |  25 ++++
 26 files changed, 487 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
 create mode 100644 arch/arm/boot/dts/vf610m4-colibri.dts
 create mode 100644 arch/arm/boot/dts/vf610m4.dtsi
 create mode 100644 arch/arm/configs/vf610m4_defconfig
 create mode 100644 arch/arm/mach-imx/Makefile.boot
 create mode 100644 arch/arm/mach-imx/mach-vf610m4.c
 create mode 100644 arch/arm/mach-imx/mscm-vf610.c
 create mode 100644 include/linux/irqchip/arm-nvic.h

-- 
2.1.3

