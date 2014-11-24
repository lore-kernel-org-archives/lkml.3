Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaKXCkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:40:52 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34712 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKXCkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:40:49 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: ralf@linux-mips.org
Cc: f.fainelli@gmail.com, jfraser@broadcom.com, dtor@chromium.org,
        tglx@linutronix.de, jason@lakedaemon.net, jogo@openwrt.org,
        arnd@arndb.de, computersforpeace@gmail.com, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 00/11] Multiplatform BMIPS kernel
Date: Sun, 23 Nov 2014 18:40:35 -0800
Message-Id: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series REPLACES the following commits in Ralf's
mips-for-linux-next branch:

ab3e5d0647e3 Documentation: DT: Add entries for BCM3384 and its peripherals
1251d9964de5 MIPS: bcm3384: Initial commit of bcm3384 platform support
aff366c68e5c MAINTAINERS: Add entry for BCM33xx cable chips

(Ralf, if you just want to drop the above commits and target the new
platform for 3.20+, that's fine.)


V2->V3:

 - Omit the BMIPS updates that have already been accepted into Ralf's tree.
   They are still needed, but not reposted.

 - Make USB endian swap options conditional on "if CPU_BIG_ENDIAN".

 - Remove board listing from Documentation/devicetree/bindings/mips/brcm/soc.txt

 - Remove legacy device autodetection and chip ID decoding.  Legacy
   boards/bootloaders will be supported by selecting a single DTB file
   to compile into the kernel.

 - Refactor quirks code to match against DT "compatible" strings, not chip IDs.

 - Fix CPU1 boot (missing DT node) on 6329.

 - Remove @0 / addressing properties on non-reg nodes.

 - Remove bogus "brcm,bmips" bus registration.

 - Move UBUS peripherals onto a "simple-bus" and set DMA ranges for this
   bus on bcm3384_zephyr.

 - Fix base addresses on 6328/6368 for "periph_intc@10000020".

 - Change the MIPS_L1_CACHE_SHIFT calculation so as to minimize the impact
   on other builds (like bcm63xx).


This series is based on mips-for-linux-next, minus the three 3384 patches
listed above, plus these non-MIPS patches:

http://patchwork.linux-mips.org/bundle/cernekee/bmips-multi-v3-deps/?state=%2a
http://marc.info/?l=linux-usb&m=141305106215886&w=2 (all 3/3)

These are queued for tty-next / irqchip-next / usb-next.


Re: irqchip patches in this series

These apply cleanly on top of earlier bcm7120/brcmstb commits currently
in irqchip-next.  The BMIPS commit in this series depends on both the
irqchip-next updates, and the irqchip updates in this series.


Re: syscon/reset

I have some patches ready for the brcmstb syscon/reset drivers, but will
submit them separately so we can get the basic platform support stuff
nailed down first.

I don't have a patch ready for gisb-arb support yet, but I have prototyped
the change.

These patches will also have interdependencies between the
arch/mips/boot/dts changes and the drivers/ changes.


Re: external (non-MIPS) timers:

I left this problem for a future submission.  There are a couple of
elements to consider:

 - Do we want to completely eliminate CSRC_R4K and CEVT_R4K in favor of an
   external timer, and leave mips_hpt_frequency unset?

 - If so, do all platforms have a suitable timer, and is it hooked up to an
   IRQ?  On STB we saw conflicts with other software when taking over one
   of the UPG timers; the alternative (WKTMR) doesn't have a suitable
   alarm/IRQ.

 - Or do we want to use another timer to calibrate mips_hpt_frequency?  In
   this case we may need to add part of that timer's driver under
   arch/mips/bmips instead of under drivers/, so it is available early in the
   boot process.  Unfortunately that might cause problems or redundancy
   sharing the code with ARM platforms.

 - And if we do wind up using CSRC_R4K / CEVT_R4K, we'll need a way to
   handle the complications caused by frequency scaling.  The brcmstb
   kernel sources posted on github do this, but it did require changes to
   other files under arch/mips/kernel/.


Re: dma-ranges

dma.c implements a minimal remapping scheme just for the current UBUS
peripherals.  The remapping is global, and it isn't the same mapping
needed for PCI(e).  A more comprehensive solution will be needed before
PCI support can be added.

On chips OTHER than 3384, remapping is only required on PCI (not UBUS or
"rdb").  Notably, BCM7445, an ARM platform currently supported upstream,
doesn't require dma-ranges for non-PCI devices.

I am hoping we can piggyback on top of the ARM dma-ranges code once it
is merged.  This will allow for eliminating my dma.c.


Brian Norris (1):
  irqchip: brcmstb-l2: don't clear wakeable interrupts at init time

Dmitry Torokhov (2):
  irqchip: brcmstb-l2: fix error handling of irq_of_parse_and_map
  irqchip: bcm7120-l2: fix error handling of irq_of_parse_and_map

Kevin Cernekee (8):
  irqchip: Update docs regarding irq_domain_add_tree()
  irqchip: bcm7120-l2: Refactor driver for arbitrary IRQEN/IRQSTAT
    offsets
  irqchip: bcm7120-l2: Change DT binding to allow non-contiguous
    IRQEN/IRQSTAT
  irqchip: Add new driver for BCM7038-style level 1 interrupt
    controllers
  MIPS: Let __dt_register_buses accept a single bus type
  MIPS: Fall back to the generic restart notifier
  MIPS: Reorder MIPS_L1_CACHE_SHIFT priorities
  MIPS: Add multiplatform BMIPS target

 Documentation/IRQ-domain.txt                       |   3 +-
 .../interrupt-controller/brcm,bcm7038-l1-intc.txt  |  52 ++++
 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |   5 +-
 .../devicetree/bindings/mips/brcm/bmips.txt        |   8 +
 .../devicetree/bindings/mips/brcm/soc.txt          |  12 +
 arch/mips/Kbuild.platforms                         |   1 +
 arch/mips/Kconfig                                  |  42 ++-
 arch/mips/bmips/Kconfig                            |  50 +++
 arch/mips/bmips/Makefile                           |   1 +
 arch/mips/bmips/Platform                           |   7 +
 arch/mips/bmips/dma.c                              | 141 +++++++++
 arch/mips/bmips/irq.c                              |  38 +++
 arch/mips/bmips/setup.c                            | 195 ++++++++++++
 arch/mips/boot/dts/Makefile                        |   9 +
 arch/mips/boot/dts/bcm3384_viper.dtsi              | 108 +++++++
 arch/mips/boot/dts/bcm3384_zephyr.dtsi             | 126 ++++++++
 arch/mips/boot/dts/bcm6328.dtsi                    |  87 ++++++
 arch/mips/boot/dts/bcm6368.dtsi                    |  94 ++++++
 arch/mips/boot/dts/bcm7125.dtsi                    | 107 +++++++
 arch/mips/boot/dts/bcm7346.dtsi                    | 192 ++++++++++++
 arch/mips/boot/dts/bcm7360.dtsi                    | 129 ++++++++
 arch/mips/boot/dts/bcm7420.dtsi                    | 151 ++++++++++
 arch/mips/boot/dts/bcm7425.dtsi                    | 191 ++++++++++++
 arch/mips/boot/dts/bcm93384wvg.dts                 |  25 ++
 arch/mips/boot/dts/bcm93384wvg_viper.dts           |  25 ++
 arch/mips/boot/dts/bcm96368mvwg.dts                |  31 ++
 arch/mips/boot/dts/bcm97125cbmb.dts                |  31 ++
 arch/mips/boot/dts/bcm97346dbsmb.dts               |  58 ++++
 arch/mips/boot/dts/bcm97360svmb.dts                |  34 +++
 arch/mips/boot/dts/bcm97420c.dts                   |  45 +++
 arch/mips/boot/dts/bcm97425svmb.dts                |  60 ++++
 arch/mips/boot/dts/bcm9ejtagprb.dts                |  22 ++
 arch/mips/configs/bmips_be_defconfig               |  86 ++++++
 arch/mips/configs/bmips_stb_defconfig              |  86 ++++++
 arch/mips/include/asm/mach-bmips/dma-coherence.h   |  45 +++
 arch/mips/include/asm/mach-bmips/spaces.h          |  17 ++
 arch/mips/include/asm/mach-bmips/war.h             |  24 ++
 arch/mips/kernel/prom.c                            |   5 +-
 arch/mips/kernel/reset.c                           |   2 +
 drivers/irqchip/Kconfig                            |   5 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-bcm7038-l1.c                   | 335 +++++++++++++++++++++
 drivers/irqchip/irq-bcm7120-l2.c                   | 105 +++++--
 drivers/irqchip/irq-brcmstb-l2.c                   |  13 +-
 44 files changed, 2768 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7038-l1-intc.txt
 create mode 100644 Documentation/devicetree/bindings/mips/brcm/bmips.txt
 create mode 100644 Documentation/devicetree/bindings/mips/brcm/soc.txt
 create mode 100644 arch/mips/bmips/Kconfig
 create mode 100644 arch/mips/bmips/Makefile
 create mode 100644 arch/mips/bmips/Platform
 create mode 100644 arch/mips/bmips/dma.c
 create mode 100644 arch/mips/bmips/irq.c
 create mode 100644 arch/mips/bmips/setup.c
 create mode 100644 arch/mips/boot/dts/bcm3384_viper.dtsi
 create mode 100644 arch/mips/boot/dts/bcm3384_zephyr.dtsi
 create mode 100644 arch/mips/boot/dts/bcm6328.dtsi
 create mode 100644 arch/mips/boot/dts/bcm6368.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7125.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7346.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7360.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7420.dtsi
 create mode 100644 arch/mips/boot/dts/bcm7425.dtsi
 create mode 100644 arch/mips/boot/dts/bcm93384wvg.dts
 create mode 100644 arch/mips/boot/dts/bcm93384wvg_viper.dts
 create mode 100644 arch/mips/boot/dts/bcm96368mvwg.dts
 create mode 100644 arch/mips/boot/dts/bcm97125cbmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97346dbsmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97360svmb.dts
 create mode 100644 arch/mips/boot/dts/bcm97420c.dts
 create mode 100644 arch/mips/boot/dts/bcm97425svmb.dts
 create mode 100644 arch/mips/boot/dts/bcm9ejtagprb.dts
 create mode 100644 arch/mips/configs/bmips_be_defconfig
 create mode 100644 arch/mips/configs/bmips_stb_defconfig
 create mode 100644 arch/mips/include/asm/mach-bmips/dma-coherence.h
 create mode 100644 arch/mips/include/asm/mach-bmips/spaces.h
 create mode 100644 arch/mips/include/asm/mach-bmips/war.h
 create mode 100644 drivers/irqchip/irq-bcm7038-l1.c

-- 
2.1.1

