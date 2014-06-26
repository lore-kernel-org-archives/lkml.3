Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaFZUt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:49:56 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:55134 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFZUtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:49:55 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>
Cc: Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        devicetree@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 00/10] Add NVIDIA Tegra124 IOMMU support
Date: Thu, 26 Jun 2014 22:49:40 +0200
Message-Id: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

This series adds support for the IOMMU found on Tegra124 SoCs. The SMMU
groups memory clients into SWGROUPs and each SWGROUP can be assigned to
one I/O virtual address space. Translation of virtual addresses can be
enabled per memory client.

Patch 1 adds an IOMMU device registry. The driver in patch 4 will add
the IOMMU device with this registry, which will in turn be used by the
client drivers to attach to the IOMMU device. Note that the API that is
introduced in this patch may not be sufficient in the long term (f.e.
when multiple master interfaces need to be supported).

Patch 2 is v3 of the generic IOMMU device tree binding that has been
discussed previously. Patch 3 defines the device tree binding for the
NVIDIA Tegra124 memory controller (and references the generic IOMMU
binding).

Patch 4 implements a memory controller driver for NVIDIA Tegra124. It
initializes the latency allowance programming to sensible defaults and
registers an IOMMU device. Note that this is still somewhat work in
progress. The page tables aren't properly cleaned up yet and other
features of the memory controller may be useful to implement
subsequently.

Patches 5 through 8 add the device tree node for the memory controller
and enable IOMMU support in the display and SDMMC controllers as
examples.

Patches 9 and 10 add support for IOMMU to the DRM and SDMMC drivers.
SDMMC uses the DMA mapping API, which will make use of ARM's DMA/IOMMU
integration. DRM has special needs (buffers that are mapped can be
scanned out by either display controller) and not a good fit for the
DMA mapping API, so it uses the IOMMU API directly.

This has been tested using both SDMMC and DRM drivers via the IOMMU. For
DRM when an IOMMU is detected it will use shmem as backing store, which
removes the need for CMA. Importing from gk20a via the Nouveau driver
also works, but buffers occasionally have some kind of offset that I
haven't been able to track down yet.

Thierry

Thierry Reding (10):
  iommu: Add IOMMU device registry
  devicetree: Add generic IOMMU device tree bindings
  of: Add NVIDIA Tegra124 memory controller binding
  memory: Add Tegra124 memory controller support
  ARM: tegra: Add memory controller on Tegra124
  ARM: tegra: tegra124: Enable IOMMU for display controllers
  ARM: tegra: tegra124: Enable IOMMU for SDMMC controllers
  ARM: tegra: Select ARM_DMA_USE_IOMMU
  drm/tegra: Add IOMMU support
  mmc: sdhci-tegra: Add IOMMU support

 Documentation/devicetree/bindings/iommu/iommu.txt  |  156 ++
 .../memory-controllers/nvidia,tegra124-mc.txt      |   12 +
 arch/arm/boot/dts/tegra124.dtsi                    |   18 +
 arch/arm/mach-tegra/Kconfig                        |    1 +
 drivers/gpu/drm/tegra/dc.c                         |   21 +
 drivers/gpu/drm/tegra/drm.c                        |   17 +
 drivers/gpu/drm/tegra/drm.h                        |    3 +
 drivers/gpu/drm/tegra/fb.c                         |   16 +-
 drivers/gpu/drm/tegra/gem.c                        |  236 ++-
 drivers/gpu/drm/tegra/gem.h                        |    4 +
 drivers/iommu/iommu.c                              |   93 +
 drivers/memory/Kconfig                             |    9 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/tegra124-mc.c                       | 1945 ++++++++++++++++++++
 drivers/mmc/host/sdhci-tegra.c                     |    8 +
 include/dt-bindings/memory/tegra124-mc.h           |   30 +
 include/linux/iommu.h                              |   27 +
 17 files changed, 2573 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/nvidia,tegra124-mc.txt
 create mode 100644 drivers/memory/tegra124-mc.c
 create mode 100644 include/dt-bindings/memory/tegra124-mc.h

-- 
2.0.0

