Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854Ab3FSAEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:04:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35475 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSAEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:04:45 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rohit Vaswani <rvaswani@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joerg Roedel <joro@8bytes.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 00/11] MSM DT based multi-platform support
Date: Tue, 18 Jun 2013 17:04:30 -0700
Message-Id: <1371600281-6118-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.448.gfb7dfaa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset allows me to compile and run the DT based MSM
platforms in the multi-platform ARM kernel. This is built on
top of a couple patches I've sent out already (specifically
the debug_ll patch series and the clocksource_of conversion)
as well a patch from Rohit that didn't seem to make it into 
MSM's for-next branch.

There is one problem though, the last two patches cause compile
failures if you turn on MSM's sdcc or USB_OTG driver. It seems
that the sdcc driver depends on the clk_reset() API and the custom
DMA interface provided by mach layers. And the USB_OTG driver depends
on clk_reset.

The simplest solution is to make these two drivers depend on the
non-dt based MSM support so that they can't be compiled in the
multi-platform config. Otherwise, we'll need to replace the clk_reset()
calls with the new reset controller API, but doing that would
require us to convert all MSM platforms over to devicetree or
we'll need to add support to the reset controller API for non-DT based
controllers. Even with that, the sdcc driver uses custom DMA things
so we may need to put that all behind some #ifdef.

Patches are based on David Brown's for-next tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git for-next

Rohit Vaswani (1):
  ARM: msm: Remove unused and unmapped MSM_TLMM_BASE for 8x60

Stephen Boyd (10):
  ARM: msm: Don't compile __msm_ioremap_caller() unless used
  ARM: msm: Move debug-macro.S to include/debug
  ARM: msm: Remove TMR and TMR0 static mappings
  ARM: msm: Migrate msm_timer to CLOCKSOURCE_OF_DECLARE
  ARM: msm: Move mach/board.h contents to common.h
  ARM: msm: Remove devices-iommu.c
  iommu/msm: Move mach includes to iommu directory
  ARM: msm: Only compile io.c on platforms that use it
  ARM: msm: Only build clock.c on proc_comm based platforms
  ARM: msm: Move MSM's DT based hardware to multi-platform support

 arch/arm/Kconfig                                   |   4 +-
 arch/arm/Kconfig.debug                             |   9 +-
 .../mach/debug-macro.S => include/debug/msm.S}     |  32 +-
 arch/arm/mach-msm/Kconfig                          |  55 +-
 arch/arm/mach-msm/Makefile                         |  11 +-
 arch/arm/mach-msm/board-dt-8660.c                  |   5 +-
 arch/arm/mach-msm/board-dt-8960.c                  |   4 +-
 arch/arm/mach-msm/board-halibut.c                  |   1 -
 arch/arm/mach-msm/board-mahimahi.c                 |   2 +-
 arch/arm/mach-msm/board-msm7x30.c                  |   1 -
 arch/arm/mach-msm/board-qsd8x50.c                  |   1 -
 arch/arm/mach-msm/board-sapphire.c                 |   2 +-
 arch/arm/mach-msm/board-trout.c                    |   1 -
 arch/arm/mach-msm/board-trout.h                    |   2 +-
 arch/arm/mach-msm/common.h                         |  18 +-
 arch/arm/mach-msm/devices-iommu.c                  | 912 ---------------------
 arch/arm/mach-msm/devices-msm7x30.c                |   2 +-
 arch/arm/mach-msm/devices-qsd8x50.c                |   2 +-
 arch/arm/mach-msm/include/mach/board.h             |  38 -
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |  46 --
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |  53 --
 arch/arm/mach-msm/include/mach/msm_iomap.h         |  17 -
 arch/arm/mach-msm/include/mach/uncompress.h        |  63 --
 arch/arm/mach-msm/io.c                             |  67 +-
 arch/arm/mach-msm/timer.c                          |  17 +-
 drivers/iommu/msm_iommu.c                          |   4 +-
 .../mach/iommu.h => drivers/iommu/msm_iommu.h      |   0
 drivers/iommu/msm_iommu_dev.c                      |   4 +-
 .../iommu/msm_iommu_hw-8xxx.h                      |   0
 drivers/video/msm/msm_fb.c                         |   1 -
 30 files changed, 132 insertions(+), 1242 deletions(-)
 rename arch/arm/{mach-msm/include/mach/debug-macro.S => include/debug/msm.S} (61%)
 delete mode 100644 arch/arm/mach-msm/devices-iommu.c
 delete mode 100644 arch/arm/mach-msm/include/mach/board.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8960.h
 delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
 delete mode 100644 arch/arm/mach-msm/include/mach/uncompress.h
 rename arch/arm/mach-msm/include/mach/iommu.h => drivers/iommu/msm_iommu.h (100%)
 rename arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h => drivers/iommu/msm_iommu_hw-8xxx.h (100%)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

