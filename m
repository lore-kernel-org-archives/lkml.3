Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaGUVI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:08:57 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56779 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbaGUVIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:08:55 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Gregory Fong <gregory.0xf0@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v8 00/11] ARM: brcmstb: Add Broadcom STB SoC support
Date: Mon, 21 Jul 2014 14:07:55 -0700
Message-Id: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm taking over the latest resubmission of this patch series.
There are a few moderate changes for v8 (noted below), but we
are waiting mostly for an Ack for the reboot driver.

This patchset contains the board support package for the
Broadcom BCM7445 ARM-based SoC [1]. These changes contain a
minimal set of code needed for a BCM7445-based board to boot
the Linux kernel.

These changes heavily leverage the OF/devicetree framework. The
machine is also built into the multi-platform ARMv7 image.

Changes are also available here:

  https://github.com/brcm/linux/tree/brcmstb-v8
  git://github.com/brcm/linux.git +brcmstb-v8

v8:
- rebase to v3.16-rc6
- convert SMP bringup to use CPU_METHOD_OF_DECLARE
- add MAINTAINERS entries
- select a few new drivers for the ARCH_BRCMSTB platform

v7 (https://lkml.org/lkml/2014/2/26/133):
- rebase to v3.14-rc4
- detect and apply ARM erratum 798181 to Brahma15 CPUs
- split-up bcm7445.dts into a common dtsi and board-specific dts

v6 (https://lkml.org/lkml/2014/2/3/493):
- rebased to v3.14-rc1
- utilize common APIs for handling CPU power-down
- drop deprecated __cpuinit attributes

v5 (https://lkml.org/lkml/2014/1/21/640):
- rebased to v3.13 tag
- make UART DT node a child of 'rdb' node
- fix ordering of debug UART entries

v4 (https://lkml.org/lkml/2014/1/17/455):
- make a reboot driver and put it in the drivers folder
- rework DT bindings to leverage 'syscon'
- rework BSP code to use 'syscon' for all register mappings
- misc. tweaks per suggestions from v3

v3 (https://lkml.org/lkml/2014/1/14/696):
- rebased to v3.13-rc8
- switched to using 'multi_v7_defconfig'
- eliminated dependence on compile-time peripheral register access
- moved DT node iomap out from 'init_early'
- misc. minor cleanups from mailing-list discussion for v2

v2 (https://lkml.org/lkml/2013/11/26/570):
- rebased to v3.13-rc1
- moved implementation to 'mach-bcm' folder
- added CPU init for B16RM

v1:
- initial submission

[1] http://www.broadcom.com/products/Cable/Cable-Set-Top-Box-Solutions/BCM7445

Brian Norris (2):
  ARM: brcmstb: select GISB arbiter and interrupt drivers
  MAINTAINERS: add entry for Broadcom ARM STB architecture

Gregory Fong (1):
  ARM: Enable erratum 798181 for Broadcom Brahma-B15

Marc Carino (8):
  ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
  power: reset: Add reboot driver for brcmstb
  ARM: brcmstb: add debug UART for earlyprintk support
  ARM: do CPU-specific init for Broadcom Brahma15 cores
  ARM: brcmstb: add CPU binding for Broadcom Brahma15
  ARM: brcmstb: add misc. DT bindings for brcmstb
  ARM: brcmstb: gic: add compatible string for Broadcom Brahma15
  ARM: brcmstb: dts: add a reference DTS for Broadcom 7445

 .../devicetree/bindings/arm/brcm-brcmstb.txt       |  95 ++++++
 Documentation/devicetree/bindings/arm/cpus.txt     |   2 +
 Documentation/devicetree/bindings/arm/gic.txt      |   1 +
 MAINTAINERS                                        |   9 +
 arch/arm/Kconfig.debug                             |  16 +-
 arch/arm/boot/dts/Makefile                         |   2 +
 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts         |  14 +
 arch/arm/boot/dts/bcm7445.dtsi                     | 111 +++++++
 arch/arm/configs/multi_v7_defconfig                |   1 +
 arch/arm/kernel/smp_tlb.c                          |  20 +-
 arch/arm/mach-bcm/Kconfig                          |  17 +
 arch/arm/mach-bcm/Makefile                         |   5 +
 arch/arm/mach-bcm/brcmstb.c                        |  28 ++
 arch/arm/mach-bcm/brcmstb.h                        |  19 ++
 arch/arm/mach-bcm/headsmp-brcmstb.S                |  33 ++
 arch/arm/mach-bcm/platsmp-brcmstb.c                | 363 +++++++++++++++++++++
 arch/arm/mm/proc-v7.S                              |  11 +
 drivers/power/reset/Kconfig                        |  10 +
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/brcmstb-reboot.c               | 120 +++++++
 20 files changed, 869 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
 create mode 100644 arch/arm/boot/dts/bcm7445-bcm97445svmb.dts
 create mode 100644 arch/arm/boot/dts/bcm7445.dtsi
 create mode 100644 arch/arm/mach-bcm/brcmstb.c
 create mode 100644 arch/arm/mach-bcm/brcmstb.h
 create mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
 create mode 100644 arch/arm/mach-bcm/platsmp-brcmstb.c
 create mode 100644 drivers/power/reset/brcmstb-reboot.c

-- 
1.9.1

