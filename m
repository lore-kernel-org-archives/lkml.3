Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab3FEP30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:29:26 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:45593 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab3FEP3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:29:24 -0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Broken DM816x support in Linux 3.10-rc4
Date: Wed,  5 Jun 2013 19:29:11 +0400
Message-Id: <1370446156-11788-1-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not so long ago I tried to boot Linux 3.10-rc4 kernel on DM816x EVM
board. Unfortunately, my attempts were failed by reason of poor
support of DM81xx-based devices in new kernels.

Actually, on Linux 3.10-rc4 kernel early initialization of board
is failed when it tries to initialize power domains:

[    0.000000] Unhandled fault: external abort on non-linefetch (0x1028) 
at 0xfa17f8e4
[    0.000000] Internal error: : 1028 [#1] SMP ARM
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 
3.10.0-rc3-00001-g0e5443c-dirty #12
[    0.000000] task: c076fc50 ti: c0764000 task.ti: c0764000
[    0.000000] PC is at omap2_pwrdm_wait_transition+0x1c/0xac
[    0.000000] LR is at pwrdm_register_pwrdms+0x15c/0x1ac
[    0.000000] pc : [<c0031698>]    lr : [<c0036010>]    psr: 60000193
[    0.000000] sp : c0765f28  ip : c07bebe0  fp : 00000001
[    0.000000] r10: c07e6a90  r9 : 00000000  r8 : c07e6944
[    0.000000] r7 : c0754a50  r6 : c064f264  r5 : c0775298  r4 : c0773e9c
[    0.000000] r3 : fffff8e4  r2 : fa17f8e4  r1 : 00000004  r0 : c0775298
[    0.000000] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM 
Segment kernel
[    0.000000] Control: 10c5387d  Table: 80004019  DAC: 00000017
[    0.000000] Process swapper (pid: 0, stack limit = 0xc0764240)
[    0.000000] Stack: (0xc0765f28 to 0xc0766000)
[    0.000000] 5f20:                   c0773e9c c0775298 c064f264 
c0754a50 c0773ee4 c0036010
[    0.000000] 5f40: 35170034 81600134 c05125a8 fa180000 80000200 
c0771348 c07b1b48 c07475ac
[    0.000000] 5f60: c0771348 c07191fc c0647c40 c0711598 16c00000 
c0d24fb4 c06450ac c070c148
[    0.000000] 5f80: c0765f98 c0765f90 c0771134 c0765fdc 00000000 
00000000 00000000 00000000
[    0.000000] 5fa0: c0643878 00000001 00000000 c0748774 c0771134 
c076c880 413fc082 00000000
[    0.000000] 5fc0: 00000000 c07086fc 00000000 00000000 00000000 
00000000 00000000 c0748778
[    0.000000] 5fe0: 10c53c7d c076c910 c0748774 c0771134 80004059 
80008074 00000000 00000000
[    0.000000] [<c0031698>] (omap2_pwrdm_wait_transition+0x1c/0xac) from 
[<c0036010>] (pwrdm_register_pwrdms+0x15c/0x1ac)
[    0.000000] [<c0036010>] (pwrdm_register_pwrdms+0x15c/0x1ac) from 
[<c07191fc>] (omap3xxx_powerdomains_init+0x50/0x144)
[    0.000000] [<c07191fc>] (omap3xxx_powerdomains_init+0x50/0x144) from 
[<c0711598>] (ti81xx_init_early+0xcc/0x178)
[    0.000000] [<c0711598>] (ti81xx_init_early+0xcc/0x178) from 
[<c070c148>] (setup_arch+0x5ac/0x800)
[    0.000000] [<c070c148>] (setup_arch+0x5ac/0x800) from [<c07086fc>] 
(start_kernel+0x7c/0x330)
[    0.000000] [<c07086fc>] (start_kernel+0x7c/0x330) from [<80008074>] 
(0x80008074)
[    0.000000] Code: e1d030f8 e5982000 e28330e4 e0822003 (e5921000)
[    0.000000] ---[ end trace 1b75b31a2719ed1c ]---

So, I suggest you this patch series, which fixes that kernel crush and
adds new functions/structures, required for early initialization on
DM816x (power and clock domains, hwmods). After applying these patches
the kernel is able to successfully continue booting till clock
initialization (will be added later).

Thanks,

Aida

Aida Mynzhasova (5):
  ARM: OMAP: DM81xx: multiple renames for DM81xx platform
  ARM: OMAP: AM33xx: multiple renames for early initialization
  ARM: OMAP: DM816x: add powerdomains for DM816x
  ARM: OMAP: DM816x: add clock domain support for DM816x
  ARM: OMAP: DM816x: add hwmod support for DM81xx

 arch/arm/Kconfig.debug                           |   12 +-
 arch/arm/include/debug/omap2plus.S               |   20 +-
 arch/arm/mach-omap2/Kconfig                      |   16 +-
 arch/arm/mach-omap2/Makefile                     |   22 +-
 arch/arm/mach-omap2/am33xx-restart.c             |    4 +-
 arch/arm/mach-omap2/board-dm816x-evm.c           |   62 +
 arch/arm/mach-omap2/board-ti8168evm.c            |   62 -
 arch/arm/mach-omap2/cclock33xx_data.c            |  990 ------
 arch/arm/mach-omap2/cclock3xxx_data.c            |    6 +-
 arch/arm/mach-omap2/cclock_am33xx_data.c         |  990 ++++++
 arch/arm/mach-omap2/clock.h                      |    4 +-
 arch/arm/mach-omap2/clockdomain.h                |    3 +
 arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c |   10 +
 arch/arm/mach-omap2/clockdomains33xx_data.c      |  196 --
 arch/arm/mach-omap2/clockdomains_am33xx_data.c   |  196 ++
 arch/arm/mach-omap2/clockdomains_dm81xx_data.c   |  213 ++
 arch/arm/mach-omap2/cm-regbits-33xx.h            |  817 -----
 arch/arm/mach-omap2/cm-regbits-am33xx.h          |  817 +++++
 arch/arm/mach-omap2/cm-regbits-dm81xx.h          |   22 +
 arch/arm/mach-omap2/cm33xx.c                     |  364 ---
 arch/arm/mach-omap2/cm33xx.h                     |  417 ---
 arch/arm/mach-omap2/cm_am33xx.c                  |  364 +++
 arch/arm/mach-omap2/cm_am33xx.h                  |  417 +++
 arch/arm/mach-omap2/cm_dm81xx.h                  |   81 +
 arch/arm/mach-omap2/common.h                     |    8 +-
 arch/arm/mach-omap2/control.h                    |    8 +-
 arch/arm/mach-omap2/dm81xx.h                     |   62 +
 arch/arm/mach-omap2/dma.h                        |   12 +
 arch/arm/mach-omap2/id.c                         |   20 +-
 arch/arm/mach-omap2/include/mach/serial.h        |    8 +-
 arch/arm/mach-omap2/io.c                         |   32 +-
 arch/arm/mach-omap2/irq.c                        |    4 +-
 arch/arm/mach-omap2/omap_hwmod.c                 |    4 +-
 arch/arm/mach-omap2/omap_hwmod.h                 |    1 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c       | 3609 ----------------------
 arch/arm/mach-omap2/omap_hwmod_am33xx_data.c     | 3609 ++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_dm81xx_data.c     | 1209 ++++++++
 arch/arm/mach-omap2/omap_phy_internal.c          |   18 +-
 arch/arm/mach-omap2/powerdomain.h                |    4 +
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c |   43 +
 arch/arm/mach-omap2/powerdomains33xx_data.c      |  185 --
 arch/arm/mach-omap2/powerdomains3xxx_data.c      |   43 -
 arch/arm/mach-omap2/powerdomains_am33xx_data.c   |  185 ++
 arch/arm/mach-omap2/powerdomains_dm81xx_data.c   |  115 +
 arch/arm/mach-omap2/prm-regbits-33xx.h           |  357 ---
 arch/arm/mach-omap2/prm-regbits-am33xx.h         |  357 +++
 arch/arm/mach-omap2/prm-regbits-dm81xx.h         |   24 +
 arch/arm/mach-omap2/prm33xx.c                    |  338 --
 arch/arm/mach-omap2/prm33xx.h                    |  131 -
 arch/arm/mach-omap2/prm_am33xx.c                 |  338 ++
 arch/arm/mach-omap2/prm_am33xx.h                 |  131 +
 arch/arm/mach-omap2/prm_dm81xx.c                 |   79 +
 arch/arm/mach-omap2/prm_dm81xx.h                 |   44 +
 arch/arm/mach-omap2/soc.h                        |   54 +-
 arch/arm/mach-omap2/ti81xx.h                     |   36 -
 arch/arm/mach-omap2/usb-musb.c                   |    4 +-
 arch/arm/mach-omap2/usb.h                        |   12 +-
 arch/arm/mach-omap2/voltagedomains33xx_data.c    |   43 -
 arch/arm/mach-omap2/voltagedomains_am33xx_data.c |   43 +
 arch/arm/plat-omap/include/plat/dmtimer.h        |    6 +
 arch/arm/plat-omap/include/plat/irqs-dm81xx.h    |   43 +
 arch/arm/tools/mach-types                        |    4 +-
 drivers/pci/quirks.c                             |    6 +-
 drivers/usb/musb/musb_dsps.c                     |   12 +-
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c        |    2 +-
 include/linux/platform_data/davinci_asp.h        |    2 +-
 66 files changed, 9624 insertions(+), 7726 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-dm816x-evm.c
 delete mode 100644 arch/arm/mach-omap2/board-ti8168evm.c
 delete mode 100644 arch/arm/mach-omap2/cclock33xx_data.c
 create mode 100644 arch/arm/mach-omap2/cclock_am33xx_data.c
 delete mode 100644 arch/arm/mach-omap2/clockdomains33xx_data.c
 create mode 100644 arch/arm/mach-omap2/clockdomains_am33xx_data.c
 create mode 100644 arch/arm/mach-omap2/clockdomains_dm81xx_data.c
 delete mode 100644 arch/arm/mach-omap2/cm-regbits-33xx.h
 create mode 100644 arch/arm/mach-omap2/cm-regbits-am33xx.h
 create mode 100644 arch/arm/mach-omap2/cm-regbits-dm81xx.h
 delete mode 100644 arch/arm/mach-omap2/cm33xx.c
 delete mode 100644 arch/arm/mach-omap2/cm33xx.h
 create mode 100644 arch/arm/mach-omap2/cm_am33xx.c
 create mode 100644 arch/arm/mach-omap2/cm_am33xx.h
 create mode 100644 arch/arm/mach-omap2/cm_dm81xx.h
 create mode 100644 arch/arm/mach-omap2/dm81xx.h
 delete mode 100644 arch/arm/mach-omap2/omap_hwmod_33xx_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_am33xx_data.c
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_dm81xx_data.c
 delete mode 100644 arch/arm/mach-omap2/powerdomains33xx_data.c
 create mode 100644 arch/arm/mach-omap2/powerdomains_am33xx_data.c
 create mode 100644 arch/arm/mach-omap2/powerdomains_dm81xx_data.c
 delete mode 100644 arch/arm/mach-omap2/prm-regbits-33xx.h
 create mode 100644 arch/arm/mach-omap2/prm-regbits-am33xx.h
 create mode 100644 arch/arm/mach-omap2/prm-regbits-dm81xx.h
 delete mode 100644 arch/arm/mach-omap2/prm33xx.c
 delete mode 100644 arch/arm/mach-omap2/prm33xx.h
 create mode 100644 arch/arm/mach-omap2/prm_am33xx.c
 create mode 100644 arch/arm/mach-omap2/prm_am33xx.h
 create mode 100644 arch/arm/mach-omap2/prm_dm81xx.c
 create mode 100644 arch/arm/mach-omap2/prm_dm81xx.h
 delete mode 100644 arch/arm/mach-omap2/ti81xx.h
 delete mode 100644 arch/arm/mach-omap2/voltagedomains33xx_data.c
 create mode 100644 arch/arm/mach-omap2/voltagedomains_am33xx_data.c
 create mode 100644 arch/arm/plat-omap/include/plat/irqs-dm81xx.h

-- 
1.7.10.4

