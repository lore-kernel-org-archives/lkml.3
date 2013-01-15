Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3AOLjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:39:01 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6347 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3AOLi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:38:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 15 Jan 2013 03:38:07 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <amerilainen@nvidia.com>, <airlied@linux.ie>,
        <thierry.reding@avionic-design.de>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv5,RESEND 0/8] Support for Tegra 2D hardware
Date: Tue, 15 Jan 2013 13:43:56 +0200
Message-ID: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds support for Tegra20 and Tegra30 host1x and
2D. It is based on linux-next-20130114. The set was regenerated with
git format-patch -M.

The fifth version merges DRM and host1x drivers into one driver. This
allowed moving include/linux/host1x.h back into the driver and removed
the need for a dummy platform device. This version also uses the code
from tegradrm driver almost as is, so there are a lot less actual code
changes.

This patch set does not have the host1x allocator, but it uses CMA
helpers for memory management.

host1x is the driver that controls host1x hardware. It supports
host1x command channels, synchronization, and memory management. It
is sectioned into logical driver under drivers/gpu/host1x and
physical driver under drivers/host1x/hw. The physical driver is
compiled with the hardware headers of the particular host1x version.

The hardware units are described (briefly) in the Tegra2 TRM. Wiki
page https://gitorious.org/linux-tegra-drm/pages/Host1xIntroduction
also contains a short description of the functionality.

The patch set merges tegradrm into host1x and adds 2D driver, which
uses host1x channels and sync points. The patch set also adds user
space API to tegradrm for accessing host1x and 2D.


Terje Bergstrom (8):
  gpu: host1x: Add host1x driver
  gpu: host1x: Add syncpoint wait and interrupts
  gpu: host1x: Add channel support
  gpu: host1x: Add debug support
  drm: tegra: Move drm to live under host1x
  gpu: host1x: Remove second host1x driver
  ARM: tegra: Add board data and 2D clocks
  drm: tegra: Add gr2d device

 arch/arm/mach-tegra/board-dt-tegra20.c         |    1 +
 arch/arm/mach-tegra/board-dt-tegra30.c         |    1 +
 arch/arm/mach-tegra/tegra20_clocks_data.c      |    2 +-
 arch/arm/mach-tegra/tegra30_clocks_data.c      |    1 +
 drivers/gpu/Makefile                           |    1 +
 drivers/gpu/drm/Kconfig                        |    2 -
 drivers/gpu/drm/Makefile                       |    1 -
 drivers/gpu/drm/tegra/Makefile                 |    7 -
 drivers/gpu/drm/tegra/drm.c                    |  115 -----
 drivers/gpu/host1x/Kconfig                     |   32 ++
 drivers/gpu/host1x/Makefile                    |   22 +
 drivers/gpu/host1x/cdma.c                      |  473 ++++++++++++++++++
 drivers/gpu/host1x/cdma.h                      |  107 +++++
 drivers/gpu/host1x/channel.c                   |  140 ++++++
 drivers/gpu/host1x/channel.h                   |   58 +++
 drivers/gpu/host1x/cma.c                       |  116 +++++
 drivers/gpu/host1x/cma.h                       |   43 ++
 drivers/gpu/host1x/debug.c                     |  215 +++++++++
 drivers/gpu/host1x/debug.h                     |   50 ++
 drivers/gpu/host1x/dev.c                       |  251 ++++++++++
 drivers/gpu/host1x/dev.h                       |  170 +++++++
 drivers/gpu/{drm/tegra => host1x/drm}/Kconfig  |    2 +-
 drivers/gpu/{drm/tegra => host1x/drm}/dc.c     |    7 +-
 drivers/gpu/{drm/tegra => host1x/drm}/dc.h     |    0
 drivers/gpu/host1x/drm/drm.c                   |  548 +++++++++++++++++++++
 drivers/gpu/{drm/tegra => host1x/drm}/drm.h    |   37 +-
 drivers/gpu/{drm/tegra => host1x/drm}/fb.c     |    0
 drivers/gpu/host1x/drm/gr2d.c                  |  325 +++++++++++++
 drivers/gpu/{drm/tegra => host1x/drm}/hdmi.c   |    7 +-
 drivers/gpu/{drm/tegra => host1x/drm}/hdmi.h   |    0
 drivers/gpu/{drm/tegra => host1x/drm}/host1x.c |    0
 drivers/gpu/{drm/tegra => host1x/drm}/output.c |    0
 drivers/gpu/{drm/tegra => host1x/drm}/rgb.c    |    0
 drivers/gpu/host1x/host1x.h                    |   29 ++
 drivers/gpu/host1x/host1x_client.h             |   34 ++
 drivers/gpu/host1x/hw/Makefile                 |    6 +
 drivers/gpu/host1x/hw/cdma_hw.c                |  478 ++++++++++++++++++
 drivers/gpu/host1x/hw/cdma_hw.h                |   37 ++
 drivers/gpu/host1x/hw/channel_hw.c             |  148 ++++++
 drivers/gpu/host1x/hw/debug_hw.c               |  400 ++++++++++++++++
 drivers/gpu/host1x/hw/host1x01.c               |   45 ++
 drivers/gpu/host1x/hw/host1x01.h               |   25 +
 drivers/gpu/host1x/hw/host1x01_hardware.h      |  150 ++++++
 drivers/gpu/host1x/hw/hw_host1x01_channel.h    |  120 +++++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h       |  241 ++++++++++
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h     |  168 +++++++
 drivers/gpu/host1x/hw/intr_hw.c                |  178 +++++++
 drivers/gpu/host1x/hw/syncpt_hw.c              |  157 ++++++
 drivers/gpu/host1x/intr.c                      |  383 +++++++++++++++
 drivers/gpu/host1x/intr.h                      |  109 +++++
 drivers/gpu/host1x/job.c                       |  612 ++++++++++++++++++++++++
 drivers/gpu/host1x/job.h                       |  164 +++++++
 drivers/gpu/host1x/memmgr.c                    |  173 +++++++
 drivers/gpu/host1x/memmgr.h                    |   72 +++
 drivers/gpu/host1x/syncpt.c                    |  399 +++++++++++++++
 drivers/gpu/host1x/syncpt.h                    |  165 +++++++
 drivers/video/Kconfig                          |    2 +
 include/drm/tegra_drm.h                        |  131 +++++
 include/trace/events/host1x.h                  |  272 +++++++++++
 59 files changed, 7295 insertions(+), 137 deletions(-)
 delete mode 100644 drivers/gpu/drm/tegra/Makefile
 delete mode 100644 drivers/gpu/drm/tegra/drm.c
 create mode 100644 drivers/gpu/host1x/Kconfig
 create mode 100644 drivers/gpu/host1x/Makefile
 create mode 100644 drivers/gpu/host1x/cdma.c
 create mode 100644 drivers/gpu/host1x/cdma.h
 create mode 100644 drivers/gpu/host1x/channel.c
 create mode 100644 drivers/gpu/host1x/channel.h
 create mode 100644 drivers/gpu/host1x/cma.c
 create mode 100644 drivers/gpu/host1x/cma.h
 create mode 100644 drivers/gpu/host1x/debug.c
 create mode 100644 drivers/gpu/host1x/debug.h
 create mode 100644 drivers/gpu/host1x/dev.c
 create mode 100644 drivers/gpu/host1x/dev.h
 rename drivers/gpu/{drm/tegra => host1x/drm}/Kconfig (94%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/dc.c (99%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/dc.h (100%)
 create mode 100644 drivers/gpu/host1x/drm/drm.c
 rename drivers/gpu/{drm/tegra => host1x/drm}/drm.h (86%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/fb.c (100%)
 create mode 100644 drivers/gpu/host1x/drm/gr2d.c
 rename drivers/gpu/{drm/tegra => host1x/drm}/hdmi.c (99%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/hdmi.h (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/host1x.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/output.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/rgb.c (100%)
 create mode 100644 drivers/gpu/host1x/host1x.h
 create mode 100644 drivers/gpu/host1x/host1x_client.h
 create mode 100644 drivers/gpu/host1x/hw/Makefile
 create mode 100644 drivers/gpu/host1x/hw/cdma_hw.c
 create mode 100644 drivers/gpu/host1x/hw/cdma_hw.h
 create mode 100644 drivers/gpu/host1x/hw/channel_hw.c
 create mode 100644 drivers/gpu/host1x/hw/debug_hw.c
 create mode 100644 drivers/gpu/host1x/hw/host1x01.c
 create mode 100644 drivers/gpu/host1x/hw/host1x01.h
 create mode 100644 drivers/gpu/host1x/hw/host1x01_hardware.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_channel.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_sync.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_uclass.h
 create mode 100644 drivers/gpu/host1x/hw/intr_hw.c
 create mode 100644 drivers/gpu/host1x/hw/syncpt_hw.c
 create mode 100644 drivers/gpu/host1x/intr.c
 create mode 100644 drivers/gpu/host1x/intr.h
 create mode 100644 drivers/gpu/host1x/job.c
 create mode 100644 drivers/gpu/host1x/job.h
 create mode 100644 drivers/gpu/host1x/memmgr.c
 create mode 100644 drivers/gpu/host1x/memmgr.h
 create mode 100644 drivers/gpu/host1x/syncpt.c
 create mode 100644 drivers/gpu/host1x/syncpt.h
 create mode 100644 include/drm/tegra_drm.h
 create mode 100644 include/trace/events/host1x.h

-- 
1.7.9.5

