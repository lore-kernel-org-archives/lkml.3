Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaGCNW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:22:59 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51805 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaGCNW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:22:57 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 00/11] MIPS: Alchemy: clock framework support
Date: Thu,  3 Jul 2014 15:22:31 +0200
Message-Id: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here's another round of patches which expose the configurable parts
of the onchip clocktree of Alchemy SoCs to the common clock framework.

v2: split original patch #2 into a clock framework patch and multiple
    driver adjustment patches, suggested by Mike Turquette.

patch #1 is a big(ger) cleanup of the au1000.h header which presented
         itself during preparation of the other patches.  It's required
         for the others to compile.
patch #2 adds the clock framework integration,
patches #3-#11 adjust various setup files and drivers to use the clock
         framework to get at required clocks and frequencies.

The whole series has been tested on DB1300 and DB1500 boards (i.e. the
 newest variant and an older one with the inflexible dividers), every-
 thing works as before.

Example clock tree dumps:  All clocks listed here have been set up by
firmware.

db1300 ~ # cat /sys/kernel/debug/clk/clk_summary
   clock                         enable_cnt  prepare_cnt        rate   accuracy
--------------------------------------------------------------------------------
 root_clk                                 3            3    12000000          0
    auxpll2_clk                           1            1   756000000          0
       fg5_clk                            0            0   252000000          0
          maebsa_clk                      0            0   252000000          0
       fg4_clk                            0            0   189000000          0
          maempe_clk                      0            0   189000000          0
       fg3_clk                            0            0   252000000          0
          gpemgp_clk                      0            0   252000000          0
       fg2_clk                            1            1   189000000          0
          EXTCLK1                         1            1    47250000          0
       fg1_clk                            0            0   756000000          0
       fg0_clk                            0            0   756000000          0
    auxpll_clk                            1            1   192000000          0
       EXTCLK0                            0            0   192000000          0
       lcd_intclk                         1            1    96000000          0
    cpu_clk                               1            1   660000000          0
       sysbus_clk                         1            1   330000000          0
          mem_clk                         0            0   330000000          0
          periph_clk                      3            3   165000000          0
             lr_clk                       0            0   165000000          0


db1500 ~ # cat /sys/kernel/debug/clk/clk_summary
   clock                         enable_cnt  prepare_cnt        rate   accuracy
--------------------------------------------------------------------------------
 root_clk                                 2            2    12000000          0 
    auxpll_clk                            2            2   384000000          0 
       EXTCLK1                            0            0   384000000          0 
       EXTCLK0                            0            0   384000000          0 
       fg2_clk                            1            1    64000000          0 
          pci_clko                        1            1    64000000          0 
       fg1_clk                            1            1    96000000          0 
          usbh_clk                        1            1    48000000          0 
          usbd_clk                        0            0    48000000          0 
    cpu_clk                               1            1   396000000          0 
       fg5_clk                            0            0   198000000          0 
       fg4_clk                            0            0   198000000          0 
       fg3_clk                            0            0   198000000          0 
       fg0_clk                            0            0   198000000          0 
       sysbus_clk                         1            1   198000000          0 
          mem_clk                         0            0    99000000          0 
          periph_clk                      1            1    99000000          0 
             lr_clk                       0            0    99000000          0 


Feedback very much appreciated!

Thank you,
        Manuel Lauss

Manuel Lauss (11):
  MIPS: Alchemy: au1000 header file cleanup
  MIPS: Alchemy: clock framework integration of onchip clocks
  MIPS: Alchemy: platform: use clk framework for uarts
  MIPS: Alchemy: usb: use clk framework
  MIPS: Alchemy: pci: use clk framework to enable PCI clock
  MIPS: Alchemy: db1200: use clk framework
  MIPS: Alchemy: irda: use clk framework
  MIPS: Alchemy: au1100fb: use clk framework
  MIPS: Alchemy: au1200fb: use clk framework
  MIPS: Alchemy: au1xmmc: use clk framework
  MIPS: Alchemy: remove old clock support

 arch/mips/Kconfig                               |    1 +
 arch/mips/alchemy/board-mtx1.c                  |    4 +-
 arch/mips/alchemy/board-xxs1500.c               |    4 +-
 arch/mips/alchemy/common/Makefile               |    4 +-
 arch/mips/alchemy/common/clock.c                | 1097 ++++++++++
 arch/mips/alchemy/common/clocks.c               |  105 -
 arch/mips/alchemy/common/dbdma.c                |   22 +-
 arch/mips/alchemy/common/dma.c                  |   15 +-
 arch/mips/alchemy/common/irq.c                  |    4 +-
 arch/mips/alchemy/common/platform.c             |   15 +-
 arch/mips/alchemy/common/power.c                |   88 +-
 arch/mips/alchemy/common/setup.c                |   18 +-
 arch/mips/alchemy/common/time.c                 |   25 +-
 arch/mips/alchemy/common/usb.c                  |   47 +-
 arch/mips/alchemy/devboards/db1000.c            |   19 +-
 arch/mips/alchemy/devboards/db1200.c            |   64 +-
 arch/mips/alchemy/devboards/db1300.c            |   10 +-
 arch/mips/alchemy/devboards/db1550.c            |   25 +-
 arch/mips/alchemy/devboards/pm.c                |   39 +-
 arch/mips/include/asm/mach-au1x00/au1000.h      | 2515 ++++++++++-------------
 arch/mips/include/asm/mach-au1x00/au1000_dma.h  |   51 +-
 arch/mips/include/asm/mach-au1x00/gpio-au1000.h |   66 +-
 arch/mips/pci/pci-alchemy.c                     |   88 +-
 drivers/mmc/host/au1xmmc.c                      |  197 +-
 drivers/mtd/nand/au1550nd.c                     |   52 +-
 drivers/net/ethernet/amd/au1000_eth.c           |  155 +-
 drivers/net/irda/au1k_ir.c                      |   48 +-
 drivers/rtc/rtc-au1xxx.c                        |   18 +-
 drivers/spi/spi-au1550.c                        |   66 +-
 drivers/video/fbdev/au1100fb.c                  |   39 +-
 drivers/video/fbdev/au1100fb.h                  |    1 +
 drivers/video/fbdev/au1200fb.c                  |   47 +-
 sound/soc/au1x/psc-ac97.c                       |  140 +-
 sound/soc/au1x/psc-i2s.c                        |  100 +-
 sound/soc/au1x/psc.h                            |   22 +-
 35 files changed, 3064 insertions(+), 2147 deletions(-)
 create mode 100644 arch/mips/alchemy/common/clock.c
 delete mode 100644 arch/mips/alchemy/common/clocks.c

-- 
2.0.0

