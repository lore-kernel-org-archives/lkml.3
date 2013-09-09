Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3IIWmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:42:49 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55879 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab3IIWmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:42:43 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 2/3] ARM: Renesas SoC cleanup, refactoring and more SMP support
Date: Mon,  9 Sep 2013 15:42:34 -0700
Message-Id: <1378766555-9679-3-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1378766555-9679-1-git-send-email-khilman@linaro.org>
References: <1378766555-9679-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of cleanup and refactoring and some SMP additions for Renesas
platforms.  Due to some inter-dependencies with other arm-soc
branches, this Renesas stuff was separated out for sending after the
other branches were merged.

Highlights:
- remove unused board support and cleanup of unused headers
- refactoring of init and device registration
- simplify IRQ initialization

Conflicts: Too many. Most of these are because Simon chose to send
some board updates through the V4L tree that ends up colliding with
the main platform changes. We'll work with him on sorting out his
workflow:

arch/arm/boot/dts/r8a7740.dtsi:
- Add/add conflict in a devicetree file (keep both)

arch/arm/mach-shmobile/Makefile:
- Splitting out of clock files collides with intc move to DT.
Keep HEAD version but remove intc-* files for R8A7740 and R8A7779.

arch/arm/mach-shmobile/board-bockw.c:
- Keep HEAD but remove i2c, hspi and mmc device init calls

arch/arm/mach-shmobile/board-marzen.c
- Remove mach/hardware.h include and r8a7779_add_usb_phy_device() call,
everything else stays.

arch/arm/mach-shmobile/include/mach/r8a7778.h:
- From HEAD, Keep camera-rcar.h include and r8a7778_add_vin_device()
- From branch, keep everything

arch/arm/mach-shmobile/include/mach/r8a7779.h:
- From HEAD, Keep only camera-rcar.h include and r8a7779_add_vin_device()

arch/arm/mach-shmobile/setup-r8a7778.c
- Keep HEAD, but drop the MMC section (struct resource + add_mmc_device())
- take the new function name from our side (r8a7778_add_dt_devices())

arch/arm/mach-shmobile/setup-r8a7779.c
- Keep HEAD, but drop r8a7779_add_usb_phy_device()

I've also pushed a test-merge2 branch where you can see how I resolved
them.

----------------------------------------------------------------

The following changes since commit b41cfc8c3745f729393af57400377997b484701c:

  Merge tag 'drivers-for-linus' into test-merge2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/renesas-for-linus

for you to fetch changes up to 25475030ec0e2c4c05f3ecb2c068f6e42944fd04:

  Merge tag 'renesas-smp-for-v3.12' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/renesas

----------------------------------------------------------------

Guennadi Liakhovetski (3):
      ARM: shmobile: ape6evm: add DT reference
      ARM: shmobile: ape6evm-reference: add CPUFreq support
      ARM: shmobile: ape6evm-reference: switch PFC to DT

Kuninori Morimoto (16):
      ARM: shmobile: bockw: add DT reference
      ARM: shmobile: r8a7779: cleanup registration of usb phy
      ARM: shmobile: armadillo800eva: Use DT for GIC
      ARM: shmobile: marzen: Use DT for GIC
      ARM: shmobile: r8a7778: cleanup registration of mmcif
      ARM: shmobile: r8a7778: cleanup registration of usb phy
      ARM: shmobile: r8a7778: cleanup registration of sdhi
      ARM: shmobile: r8a7778: cleanup registration of i2c
      ARM: shmobile: r8a7778: cleanup registration of hspi
      ARM: shmobile: r8a7779: add missing __initdata
      ARM: shmobile: r8a7790: add missing __initdata
      ARM: shmobile: bockw: add missing __initdata
      ARM: shmobile: r8a7740: move r8a7740_init_irq_of() to setup
      ARM: shmobile: r8a7779: move r8a7779_init_irq_xxx() to setup
      ARM: shmobile: armadillo800eva: remove nfsroot settings from bootargs
      ARM: shmobile: kzm9d: remove nfsroot settings from bootargs

Laurent Pinchart (4):
      ARM: shmobile: lager-reference: Add LED6-LED8 to the device tree
      ARM: shmobile: Mount root file systems in r/w mode for all DT platforms
      ARM: shmobile: r8a7740: Add TPU node to the device tree
      ARM: shmobile: sh73a0: Remove global GPIO_NR definition

Lee Jones (1):
      ARM: shmobile: r8a7779: Remove '0x's from R8A7779 DTS file

Magnus Damm (38):
      ARM: shmobile: Minor update for the Lager DT reference code
      ARM: shmobile: Remove sh73a0 use of <mach/hardware.h>
      ARM: shmobile: Remove sh7372 use of <mach/hardware.h>
      ARM: shmobile: Remove EMEV2 use of <mach/hardware.h>
      ARM: shmobile: Remove r8a7779 use of <mach/hardware.h>
      ARM: shmobile: Remove Marzen use of <mach/hardware.h>
      ARM: shmobile: Remove include <mach/hardware.h>
      ARM: shmobile: r8a73a4: Remove ->init_machine() special case
      ARM: shmobile: Use pm-rmobile on sh7372 and r8a7740 only
      ARM: shmobile: No need to use INTC demux on r8a7740
      ARM: shmobile: No need to use INTC header on r8a7779
      ARM: shmobile: sh73a0: Rely on DT for SMP CPU info
      ARM: shmobile: marzen: Switch to DT_MACHINE_START
      ARM: shmobile: r8a7740: add PMU information to r8a7740.dtsi
      ARM: shmobile: sh73a0: add PMU information to sh73a0.dtsi
      ARM: shmobile: emev2: add PMU information to emev2.dtsi
      ARM: shmobile: Use default ->init_time() on r8a73a4
      ARM: shmobile: Use default ->init_time() on r8a7740
      ARM: shmobile: Use default ->init_time() on r8a7778
      ARM: shmobile: Use default ->init_time() on r8a7779
      ARM: shmobile: Use default ->init_time() on Bockw
      ARM: shmobile: Use default ->init_time() on Bockw DT ref
      ARM: shmobile: Use default ->init_time() on Armadillo DT ref
      ARM: shmobile: Use default ->init_time() on APE6EVM
      ARM: shmobile: Use default ->init_time() on APE6EVM DT ref
      ARM: shmobile: Use default ->init_time() on Marzen DT ref
      ARM: shmobile: Use default ->init_time() on KZM9G DT ref
      ARM: shmobile: Use clocksource_of_init() on r8a7790
      ARM: shmobile: Remove unused shmobile_init_time()
      ARM: shmobile: Introduce shared SCU SMP boot code
      ARM: shmobile: Use shared SCU SMP boot code on sh73a0
      ARM: shmobile: Use shared SCU SMP boot code on r8a7779
      ARM: shmobile: Use shared SCU SMP boot code on emev2
      ARM: shmobile: Add shared SCU CPU Hotplug code
      ARM: shmobile: Use shared SCU CPU Hotplug code on sh73a0
      ARM: shmobile: Use shared SCU CPU Hotplug code on r8a7779
      ARM: shmobile: Introduce per-CPU SMP boot / sleep code
      ARM: shmobile: Per-CPU SMP boot / sleep code for SCU SoCs

Olof Johansson (3):
      Merge tag 'renesas-cleanup2-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/renesas
      Merge tag 'renesas-cleanup3-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/renesas
      Merge tag 'renesas-smp-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/renesas

Simon Horman (8):
      ARM: shmobile: lager: Add DT reference
      Merge branches 'tpu-pwm', 'backlight' and 'soc' into cleanup2-base
      ARCH: ARM: shmobile: Remove kota2 board support
      ARCH: ARM: shmobile: Remove ag5evm board support
      ARM: shmobile: marzen: Add  r8a7779-marzen.dtb
      ARM: shmobile: r8a7779: Rely on DT for SMP CPU info
      ARM: shmobile: lager: enable nfsroot in DTS
      Merge branch 'dt2' into cleanup3-base


 arch/arm/boot/dts/Makefile                      |   4 +
 arch/arm/boot/dts/emev2-kzm9d-reference.dts     |   2 +-
 arch/arm/boot/dts/emev2-kzm9d.dts               |   2 +-
 arch/arm/boot/dts/emev2.dtsi                    |   6 +
 arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts |  65 ++
 arch/arm/boot/dts/r8a73a4-ape6evm.dts           |   2 +-
 .../dts/r8a7740-armadillo800eva-reference.dts   |   2 +-
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts   |   2 +-
 arch/arm/boot/dts/r8a7740.dtsi                  |  12 +
 arch/arm/boot/dts/r8a7778-bockw-reference.dts   |  32 +
 arch/arm/boot/dts/r8a7778-bockw.dts             |   2 +-
 arch/arm/boot/dts/r8a7779-marzen-reference.dts  |   2 +-
 arch/arm/boot/dts/r8a7779-marzen.dts            |  27 +
 arch/arm/boot/dts/r8a7779.dtsi                  |   8 +-
 arch/arm/boot/dts/r8a7790-lager-reference.dts   |  45 ++
 arch/arm/boot/dts/r8a7790-lager.dts             |   2 +-
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts    |   2 +-
 arch/arm/boot/dts/sh73a0-kzm9g.dts              |   2 +-
 arch/arm/boot/dts/sh73a0.dtsi                   |   6 +
 arch/arm/configs/ag5evm_defconfig               |  83 ---
 arch/arm/configs/kota2_defconfig                | 121 ----
 arch/arm/mach-shmobile/Kconfig                  |  50 +-
 arch/arm/mach-shmobile/Makefile                 |  23 +-
 arch/arm/mach-shmobile/Makefile.boot            |   5 +-
 arch/arm/mach-shmobile/board-ag5evm.c           | 639 -------------------
 .../arm/mach-shmobile/board-ape6evm-reference.c |  63 ++
 arch/arm/mach-shmobile/board-ape6evm.c          |   1 -
 .../board-armadillo800eva-reference.c           |   1 -
 arch/arm/mach-shmobile/board-armadillo800eva.c  |   2 +-
 arch/arm/mach-shmobile/board-bockw-reference.c  |  61 ++
 arch/arm/mach-shmobile/board-bockw.c            |  49 +-
 arch/arm/mach-shmobile/board-kota2.c            | 550 ----------------
 arch/arm/mach-shmobile/board-kzm9g-reference.c  |   1 -
 arch/arm/mach-shmobile/board-kzm9g.c            |  16 +-
 arch/arm/mach-shmobile/board-lager-reference.c  |  45 ++
 arch/arm/mach-shmobile/board-marzen-reference.c |   1 -
 arch/arm/mach-shmobile/board-marzen.c           |  36 +-
 arch/arm/mach-shmobile/headsmp.S                |  49 ++
 arch/arm/mach-shmobile/include/mach/common.h    |  10 +-
 arch/arm/mach-shmobile/include/mach/hardware.h  |   4 -
 arch/arm/mach-shmobile/include/mach/r8a73a4.h   |   1 +
 arch/arm/mach-shmobile/include/mach/r8a7740.h   |   1 -
 arch/arm/mach-shmobile/include/mach/r8a7778.h   |   9 +-
 arch/arm/mach-shmobile/include/mach/r8a7779.h   |   3 -
 arch/arm/mach-shmobile/include/mach/r8a7790.h   |   1 +
 arch/arm/mach-shmobile/include/mach/sh73a0.h    |   2 -
 arch/arm/mach-shmobile/intc-r8a7740.c           |  68 --
 arch/arm/mach-shmobile/intc-r8a7779.c           | 131 ----
 arch/arm/mach-shmobile/platsmp-scu.c            |  81 +++
 arch/arm/mach-shmobile/platsmp.c                |  18 +
 arch/arm/mach-shmobile/setup-emev2.c            |   1 -
 arch/arm/mach-shmobile/setup-r8a73a4.c          |  16 +-
 arch/arm/mach-shmobile/setup-r8a7740.c          |  33 +-
 arch/arm/mach-shmobile/setup-r8a7778.c          |  71 +--
 arch/arm/mach-shmobile/setup-r8a7779.c          | 102 ++-
 arch/arm/mach-shmobile/setup-r8a7790.c          |  16 +-
 arch/arm/mach-shmobile/setup-sh7372.c           |   1 -
 arch/arm/mach-shmobile/setup-sh73a0.c           |   1 -
 arch/arm/mach-shmobile/smp-emev2.c              |  19 +-
 arch/arm/mach-shmobile/smp-r8a7779.c            |  70 +-
 arch/arm/mach-shmobile/smp-sh73a0.c             |  72 +--
 arch/arm/mach-shmobile/timer.c                  |   4 -
 62 files changed, 856 insertions(+), 1900 deletions(-)
 create mode 100644 arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts
 create mode 100644 arch/arm/boot/dts/r8a7778-bockw-reference.dts
 create mode 100644 arch/arm/boot/dts/r8a7779-marzen.dts
 create mode 100644 arch/arm/boot/dts/r8a7790-lager-reference.dts
 delete mode 100644 arch/arm/configs/ag5evm_defconfig
 delete mode 100644 arch/arm/configs/kota2_defconfig
 delete mode 100644 arch/arm/mach-shmobile/board-ag5evm.c
 create mode 100644 arch/arm/mach-shmobile/board-ape6evm-reference.c
 create mode 100644 arch/arm/mach-shmobile/board-bockw-reference.c
 delete mode 100644 arch/arm/mach-shmobile/board-kota2.c
 create mode 100644 arch/arm/mach-shmobile/board-lager-reference.c
 delete mode 100644 arch/arm/mach-shmobile/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-shmobile/intc-r8a7740.c
 delete mode 100644 arch/arm/mach-shmobile/intc-r8a7779.c
 create mode 100644 arch/arm/mach-shmobile/platsmp-scu.c
