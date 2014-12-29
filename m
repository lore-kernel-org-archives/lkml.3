Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaL2Xfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:35:45 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:41059 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaL2Xc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:32:26 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        arnd@arndb.de, daniel.lezcano@linaro.org, tglx@linutronix.de,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        marc.zyngier@arm.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 00/12] ARM: vf610m4: Add Vybrid Cortex-M4 support
Date: Tue, 30 Dec 2014 00:32:03 +0100
Message-Id: <1419895935-22966-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version of the patchset does not contain the interrupt router
driver anymore (MSCM). The driver has been sent in a seperate
patchset with GIC (Cortex-A5) support only:
https://lkml.org/lkml/2014/12/16/454

This patchset extends the NVIC driver to support irq domain
hierarchy and the MSCM driver to support NVIC as a parent irq
controller.

I'm happy with the outcome of the MSCM driver, the irq domain
hierarchy support has proven to work with GIC and NVIC as
intendet.

This version also does not add any new architecture or SoC anymore.
Instead, it allows to select ARCH_MULTIPLATFORM in the !MMU case
and add ARCH_MULTI_V7M as a new CPU choice. This change is based
on patches found in Arnd's git tree, however, it tries to allow
MULTIPLATFORM with !MMU in a way which should not allow to make
other selections than before (except ARCH_MULTI_V7M of course).
This makes ARCH_MXC and SOC_VF610 available for the !MMU CPU V7M.
With a small change, SOC_VF610 is now useable for the Cortex-M4
CPU too.

The patchset has proven to be working on the Cortex-A5 as well as
on the Cortex-M4 of the Vybrid SoC.

Changes since v1:
- Remove MSCM driver
- Support irq domain hierarchy with NVIC irq controller
- Extend MSCM interrupt router with NVIC as parent in the irq
  domain hierarchy 
- Rebased on v3.19-rc1 with MSCM driver
- NVIC: Register only the amount of IRQ's which vectors are
  available for

Changes since RFC:
- Unified addruart calls for MMU/!MMU
- Add MSCM support along with routable IRQ support in NVIC
- Rebased on Shawns for-next tree which made some changes
  obsolete (mainly the Vybrid SoC device tree files in for-next
  are already prepared for Cortex-M4 support)
- Removed SRC_GPR3 hack, this is now part of a mini boot-loader:
  https://github.com/falstaff84/vf610m4bootldr

Arnd Bergmann (1):
  ARM: efm32: move into multiplatform

Stefan Agner (11):
  genirq: generic chip: support hierarchy domain
  irqchip: nvic: support hierarchy irq domain
  irqchip: vf610-mscm: support NVIC parent
  irqchip: nvic: increase number of external interrupts to 112
  clocksource: add dependencies for Vybrid pit clocksource
  ARM: unify MMU/!MMU addruart calls
  ARM: imx: depend MXC debug board on 3DS machines
  ARM: allow MULTIPLATFORM with !MMU
  ARM: vf610: enable Cortex-M4 on Vybrid SoC
  ARM: dts: add support for Vybrid running on Cortex-M4
  ARM: vf610m4: add defconfig for Linux on Vybrids Cortex-M4

 Documentation/devicetree/bindings/arm/fsl.txt |  3 ++
 arch/arm/Kconfig                              | 56 +++++++++++++--------------
 arch/arm/boot/dts/Makefile                    |  1 +
 arch/arm/boot/dts/vf610m4-colibri.dts         | 52 +++++++++++++++++++++++++
 arch/arm/boot/dts/vf610m4.dtsi                | 10 +++++
 arch/arm/configs/efm32_defconfig              |  2 +
 arch/arm/configs/vf610m4_defconfig            | 53 +++++++++++++++++++++++++
 arch/arm/include/debug/efm32.S                |  2 +-
 arch/arm/kernel/debug.S                       |  2 +-
 arch/arm/kernel/entry-v7m.S                   |  8 ++--
 arch/arm/mach-imx/Kconfig                     | 37 +++++++++++-------
 arch/arm/mach-imx/Makefile.boot               |  0
 arch/arm/mach-imx/mach-vf610.c                |  1 +
 drivers/clocksource/Kconfig                   |  2 +
 drivers/irqchip/irq-nvic.c                    | 37 +++++++++++++++++-
 drivers/irqchip/irq-vf610-mscm.c              | 31 ++++++++++++---
 kernel/irq/generic-chip.c                     |  5 +--
 17 files changed, 243 insertions(+), 59 deletions(-)
 create mode 100644 arch/arm/boot/dts/vf610m4-colibri.dts
 create mode 100644 arch/arm/boot/dts/vf610m4.dtsi
 create mode 100644 arch/arm/configs/vf610m4_defconfig
 create mode 100644 arch/arm/mach-imx/Makefile.boot

-- 
2.2.1

