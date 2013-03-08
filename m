Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab3CHNs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:48:27 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9502 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab3CHNsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:48:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 08 Mar 2013 05:48:18 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv6 0/9] Support for Tegra 2D hardware
Date: Fri, 8 Mar 2013 15:46:52 +0200
Message-ID: <1362750421-18080-1-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds support for Tegra20 and Tegra30 host1x and
2D. It is based on linux-next-20130307.

Changes in this version:
 * Rebased on latest tegradrm
 * Renamed tegradrm's host1x to host1x_drm
 * Indentation and line split fixed to follow tegradrm convention
 * Pointers to platform_device replaced with pointers to device
 * Added host1x allocator, and wired it in
 * Debug spew code fixed to access mem handles from host1x_job
 * CDMA code doesn't keep the mem handles anymore
 * Push buffer ops have been made generic code
 * Removed the pin_array optimization in host1x_job to simplify code
 * Large number of smaller changes

The driver implements an allocator using the DRM CMA helper. Each buffer is
assigned an ops structure to operate on it. In future the DRM CMA helper will
be replaced with an own allocator to implement IOMMU support.

host1x is the driver that controls host1x hardware. It supports
host1x command channels, synchronization, and memory management. It
is sectioned into logical driver under drivers/gpu/host1x and
physical driver under drivers/host1x/hw. The physical driver is
compiled with the hardware headers of the particular host1x version.

The hardware units are described (briefly) in the Tegra2 TRM. Wiki
page http://http.download.nvidia.com/tegra-public-appnotes/host1x.html
also contains a short description of the functionality.

The patch set merges tegradrm into host1x and adds 2D driver, which
uses host1x channels and sync points. The patch set also adds user
space API to tegradrm for accessing host1x and 2D.

The changes to add support to libdrm are in
git@gitorious.org:linux-host1x/libdrm-host1x.git

Arto Merilainen (2):
  gpu: host1x: drm: Rename host1x to host1x_drm
  gpu: host1x: drm: Add CMA ops for host1x driver

Terje Bergstrom (7):
  gpu: host1x: Add host1x driver
  gpu: host1x: Add syncpoint wait and interrupts
  gpu: host1x: Add channel support
  gpu: host1x: Add debug support
  drm: tegra: Move drm to live under host1x
  gpu: host1x: Remove second host1x driver
  drm: tegra: Add gr2d device

 drivers/gpu/Makefile                           |    1 +
 drivers/gpu/drm/Kconfig                        |    2 -
 drivers/gpu/drm/Makefile                       |    1 -
 drivers/gpu/drm/tegra/Makefile                 |    7 -
 drivers/gpu/drm/tegra/drm.c                    |  217 --------
 drivers/gpu/drm/tegra/host1x.c                 |  327 ------------
 drivers/gpu/host1x/Kconfig                     |   23 +
 drivers/gpu/host1x/Makefile                    |   21 +
 drivers/gpu/host1x/cdma.c                      |  491 ++++++++++++++++++
 drivers/gpu/host1x/cdma.h                      |  102 ++++
 drivers/gpu/host1x/channel.c                   |  120 +++++
 drivers/gpu/host1x/channel.h                   |   52 ++
 drivers/gpu/host1x/debug.c                     |  210 ++++++++
 drivers/gpu/host1x/debug.h                     |   51 ++
 drivers/gpu/host1x/dev.c                       |  248 +++++++++
 drivers/gpu/host1x/dev.h                       |  317 ++++++++++++
 drivers/gpu/{drm/tegra => host1x/drm}/Kconfig  |    2 +-
 drivers/gpu/host1x/drm/cma.c                   |   87 ++++
 drivers/gpu/host1x/drm/cma.h                   |   26 +
 drivers/gpu/{drm/tegra => host1x/drm}/dc.c     |    5 +-
 drivers/gpu/{drm/tegra => host1x/drm}/dc.h     |    0
 drivers/gpu/host1x/drm/drm.c                   |  661 ++++++++++++++++++++++++
 drivers/gpu/{drm/tegra => host1x/drm}/drm.h    |   51 +-
 drivers/gpu/{drm/tegra => host1x/drm}/fb.c     |    6 +-
 drivers/gpu/host1x/drm/gr2d.c                  |  325 ++++++++++++
 drivers/gpu/{drm/tegra => host1x/drm}/hdmi.c   |    5 +-
 drivers/gpu/{drm/tegra => host1x/drm}/hdmi.h   |    0
 drivers/gpu/{drm/tegra => host1x/drm}/output.c |    0
 drivers/gpu/{drm/tegra => host1x/drm}/rgb.c    |    0
 drivers/gpu/host1x/host1x.h                    |   29 ++
 drivers/gpu/host1x/host1x_client.h             |   35 ++
 drivers/gpu/host1x/hw/Makefile                 |    6 +
 drivers/gpu/host1x/hw/cdma_hw.c                |  327 ++++++++++++
 drivers/gpu/host1x/hw/channel_hw.c             |  167 ++++++
 drivers/gpu/host1x/hw/debug_hw.c               |  322 ++++++++++++
 drivers/gpu/host1x/hw/host1x01.c               |   42 ++
 drivers/gpu/host1x/hw/host1x01.h               |   25 +
 drivers/gpu/host1x/hw/host1x01_hardware.h      |  143 +++++
 drivers/gpu/host1x/hw/hw_host1x01_channel.h    |  120 +++++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h       |  243 +++++++++
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h     |  174 +++++++
 drivers/gpu/host1x/hw/intr_hw.c                |  143 +++++
 drivers/gpu/host1x/hw/syncpt_hw.c              |  114 ++++
 drivers/gpu/host1x/intr.c                      |  354 +++++++++++++
 drivers/gpu/host1x/intr.h                      |  102 ++++
 drivers/gpu/host1x/job.c                       |  598 +++++++++++++++++++++
 drivers/gpu/host1x/job.h                       |  158 ++++++
 drivers/gpu/host1x/memmgr.c                    |   82 +++
 drivers/gpu/host1x/memmgr.h                    |   64 +++
 drivers/gpu/host1x/syncpt.c                    |  387 ++++++++++++++
 drivers/gpu/host1x/syncpt.h                    |  165 ++++++
 drivers/video/Kconfig                          |    2 +
 include/drm/tegra_drm.h                        |  131 +++++
 include/trace/events/host1x.h                  |  272 ++++++++++
 54 files changed, 6987 insertions(+), 576 deletions(-)
 delete mode 100644 drivers/gpu/drm/tegra/Makefile
 delete mode 100644 drivers/gpu/drm/tegra/drm.c
 delete mode 100644 drivers/gpu/drm/tegra/host1x.c
 create mode 100644 drivers/gpu/host1x/Kconfig
 create mode 100644 drivers/gpu/host1x/Makefile
 create mode 100644 drivers/gpu/host1x/cdma.c
 create mode 100644 drivers/gpu/host1x/cdma.h
 create mode 100644 drivers/gpu/host1x/channel.c
 create mode 100644 drivers/gpu/host1x/channel.h
 create mode 100644 drivers/gpu/host1x/debug.c
 create mode 100644 drivers/gpu/host1x/debug.h
 create mode 100644 drivers/gpu/host1x/dev.c
 create mode 100644 drivers/gpu/host1x/dev.h
 rename drivers/gpu/{drm/tegra => host1x/drm}/Kconfig (94%)
 create mode 100644 drivers/gpu/host1x/drm/cma.c
 create mode 100644 drivers/gpu/host1x/drm/cma.h
 rename drivers/gpu/{drm/tegra => host1x/drm}/dc.c (99%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/dc.h (100%)
 create mode 100644 drivers/gpu/host1x/drm/drm.c
 rename drivers/gpu/{drm/tegra => host1x/drm}/drm.h (82%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/fb.c (89%)
 create mode 100644 drivers/gpu/host1x/drm/gr2d.c
 rename drivers/gpu/{drm/tegra => host1x/drm}/hdmi.c (99%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/hdmi.h (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/output.c (100%)
 rename drivers/gpu/{drm/tegra => host1x/drm}/rgb.c (100%)
 create mode 100644 drivers/gpu/host1x/host1x.h
 create mode 100644 drivers/gpu/host1x/host1x_client.h
 create mode 100644 drivers/gpu/host1x/hw/Makefile
 create mode 100644 drivers/gpu/host1x/hw/cdma_hw.c
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

