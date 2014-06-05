Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaFEMbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:31:06 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7219 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaFEMbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:31:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jun 2014 05:23:01 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] efuse driver for Tegra
Date: Thu, 5 Jun 2014 15:30:42 +0300
Message-ID: <1401971448-18448-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver allows userspace to read the raw efuse data. Its userspace
interface is modelled after the sunxi_sid driver which provides similar
functionality for some Allwinner SoCs. It has been tested on
Tegra20 (ventana), Tegra30 (beaverboard), Tegra114 (dalmore) and
Tegra124 (jetson TK1).

Changes since v1:

* Add documentation for sysfs interface
* Cleanup messages

Changes since v2:

* Incorporate early fuse code
* Remove module support
* Make driver always build when Tegra platform is selected
* Add DT binding document
* Address comments on v2

Changes since v3:

* Document sysfs file format
* Added apbmisc DT node for access to the apbmisc registers
* Address comments on v3

Changes since v4:

* Provide fallback to hardcoded 0x70000800 in case the apbmisc DT node is
  missing. This is exactly what the current code does and prevents a system
  crash in that case due to an invalid memory access by tegra_read_chipid()
* Added tegra_fuse_readl() function for drivers to read calibration data

Changes since v5:

* Fix kernel panic when booting onm Tegra20 A03 with a missing fuse DT node
* Incorporate review comments

Peter De Schrijver (5):
  ARM: tegra: export apb dma readl/writel
  ARM: tegra: move fuse exports to tegra-soc.h
  misc: fuse: Add efuse driver for Tegra
  ARM: tegra: Add efuse and apbmisc bindings
  ARM: tegra: build new fuse driver in drivers/misc

 Documentation/ABI/testing/sysfs-driver-tegra-fuse  |   11 +
 .../bindings/fuse/nvidia,tegra20-fuse.txt          |   40 +++
 .../bindings/misc/nvidia,tegra20-apbmisc.txt       |   13 +
 arch/arm/boot/dts/tegra114.dtsi                    |   15 +
 arch/arm/boot/dts/tegra124.dtsi                    |   15 +
 arch/arm/boot/dts/tegra20.dtsi                     |   15 +
 arch/arm/boot/dts/tegra30.dtsi                     |   15 +
 arch/arm/mach-tegra/Makefile                       |    4 -
 arch/arm/mach-tegra/apbio.c                        |   51 ++--
 arch/arm/mach-tegra/cpuidle.c                      |    2 +-
 arch/arm/mach-tegra/flowctrl.c                     |    2 +-
 arch/arm/mach-tegra/fuse.c                         |  252 -----------------
 arch/arm/mach-tegra/fuse.h                         |   79 ------
 arch/arm/mach-tegra/hotplug.c                      |    2 +-
 arch/arm/mach-tegra/platsmp.c                      |    2 +-
 arch/arm/mach-tegra/pm.c                           |    2 +-
 arch/arm/mach-tegra/pmc.c                          |    2 +-
 arch/arm/mach-tegra/powergate.c                    |    2 +-
 arch/arm/mach-tegra/reset-handler.S                |    2 +-
 arch/arm/mach-tegra/reset.c                        |    2 +-
 arch/arm/mach-tegra/sleep-tegra30.S                |    2 +-
 arch/arm/mach-tegra/tegra.c                        |    2 +-
 arch/arm/mach-tegra/tegra114_speedo.c              |  104 -------
 arch/arm/mach-tegra/tegra20_speedo.c               |  109 --------
 arch/arm/mach-tegra/tegra30_speedo.c               |  292 -------------------
 drivers/misc/Makefile                              |    1 +
 drivers/misc/fuse/Makefile                         |    1 +
 drivers/misc/fuse/tegra/Makefile                   |    7 +
 drivers/misc/fuse/tegra/fuse-tegra.c               |  250 +++++++++++++++++
 drivers/misc/fuse/tegra/fuse-tegra20.c             |  134 +++++++++
 drivers/misc/fuse/tegra/fuse-tegra30.c             |  177 ++++++++++++
 drivers/misc/fuse/tegra/fuse.h                     |   82 ++++++
 drivers/misc/fuse/tegra/speedo-tegra114.c          |  110 ++++++++
 drivers/misc/fuse/tegra/speedo-tegra124.c          |  180 ++++++++++++
 drivers/misc/fuse/tegra/speedo-tegra20.c           |  110 ++++++++
 drivers/misc/fuse/tegra/speedo-tegra30.c           |  294 ++++++++++++++++++++
 include/linux/tegra-soc.h                          |   42 +++
 37 files changed, 1554 insertions(+), 871 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-tegra-fuse
 create mode 100644 Documentation/devicetree/bindings/fuse/nvidia,tegra20-fuse.txt
 create mode 100644 Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
 delete mode 100644 arch/arm/mach-tegra/fuse.c
 delete mode 100644 arch/arm/mach-tegra/fuse.h
 delete mode 100644 arch/arm/mach-tegra/tegra114_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra20_speedo.c
 delete mode 100644 arch/arm/mach-tegra/tegra30_speedo.c
 create mode 100644 drivers/misc/fuse/Makefile
 create mode 100644 drivers/misc/fuse/tegra/Makefile
 create mode 100644 drivers/misc/fuse/tegra/fuse-tegra.c
 create mode 100644 drivers/misc/fuse/tegra/fuse-tegra20.c
 create mode 100644 drivers/misc/fuse/tegra/fuse-tegra30.c
 create mode 100644 drivers/misc/fuse/tegra/fuse.h
 create mode 100644 drivers/misc/fuse/tegra/speedo-tegra114.c
 create mode 100644 drivers/misc/fuse/tegra/speedo-tegra124.c
 create mode 100644 drivers/misc/fuse/tegra/speedo-tegra20.c
 create mode 100644 drivers/misc/fuse/tegra/speedo-tegra30.c

-- 
1.7.7.rc0.72.g4b5ea.dirty

