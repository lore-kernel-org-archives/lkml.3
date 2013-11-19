Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3KSJeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:34:11 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5088 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KSJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:34:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Nov 2013 01:32:03 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <swarren@nvidia.com>, <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <swarren@wwwdotorg.org>,
        <galak@codeaurora.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lorenzo.pieralisi@arm.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv5 0/9] Unifying Tegra IOMMU(SMMU) driver among Tegra SoCs
Date: Tue, 19 Nov 2013 11:33:04 +0200
Message-ID: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series provide:

(1) Unified IOMMU(SMMU) driver among Tegra SoCs
(2) Multiple Address Space support(MASID) in IOMMU(SMMMU)
(3) Tegra IOMMU'able devices, most of platform devices are IOMMU'able.

There's been some discussion[1] about device population order, and for
the solution I implemented an IOMMU hook in driver core:

  [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs

which is based on:
  http://lists.linuxfoundation.org/pipermail/iommu/2013-November/006933.html

The main problem here is,

IOMMU devices on the bus need to be poplulated first, then iommu
master devices are done later.

With CONFIG_OF_IOMMU, "iommus=" DT binding would be used to identify
whether a device can be an iommu msater or not. If a device can, we'll
defer to populate that device till an iommu device is populated. Once
an iommu device is populated, "dev->bus->iommu_ops" is set in the
bus. Then, those defered iommu master devices are populated and
configured for IOMMU with help of the already populated iommu device
via iommu_ops->add_device(). Multiple IOMMUs can be listed on this
"iommus" binding so that a device can have multiple IOMMUs attached.

Currenly this "iommus=" binding is used as the global binding.

Tested IOMMU functionality with T30 SD/MMC. Any further testing with
T114 and/or other devices would be really appreciated.

v4:
Add a hook in driver core to control device populatin order.
Introduced arm,smmu "mmu-master" binding instead of tegra own.
Removed DT patches from this series.
  http://lists.linuxfoundation.org/pipermail/iommu/2013-November/006931.html

v3:
Updated based on Stephen Warren's feedback
  http://lists.linuxfoundation.org/pipermail/iommu/2013-October/006724.html

v2:
Updated based on Thierry Reding's and Stephen Warren's feedback
  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181888.html

v1:
  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/180267.html

Available in the git repository at:

  git://git@nv-tegra.nvidia.com/user/hdoyu/linux.git smmu-upstreaming@20131119


Hiroshi Doyu (9):
  of: introduce of_property_for_earch_phandle_with_args()
  driver/core: populate devices in order for IOMMUs
  ARM: tegra: create a DT header defining SWGROUP ID
  iommu/tegra: smmu: register device to iommu dynamically
  iommu/tegra: smmu: calculate ASID register offset by ID
  iommu/tegra: smmu: get swgroups from DT "iommus="
  iommu/tegra: smmu: allow duplicate ASID wirte
  iommu/tegra: smmu: Rename hwgrp -> swgroups
  [FOR TEST] ARM: dt: tegra30: add "iommus" binding

 .../bindings/iommu/nvidia,tegra30-smmu.txt         |  17 +-
 arch/arm/boot/dts/tegra30.dtsi                     |  23 +-
 drivers/base/dd.c                                  |   5 +
 drivers/iommu/Kconfig                              |   1 +
 drivers/iommu/of_iommu.c                           |  22 ++
 drivers/iommu/tegra-smmu.c                         | 334 +++++++++++++--------
 include/dt-bindings/memory/tegra-swgroup.h         |  50 +++
 include/linux/of.h                                 |   3 +
 include/linux/of_iommu.h                           |   7 +
 9 files changed, 336 insertions(+), 126 deletions(-)
 create mode 100644 include/dt-bindings/memory/tegra-swgroup.h

[1] https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/thread.html#36542
-- 
1.8.1.5

