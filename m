Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3LLH5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:57:35 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15420 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab3LLH5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:57:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 00:00:13 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>,
        <gregkh@linuxfoundation.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 00/12] Unifying SMMU driver among Tegra SoCs
Date: Thu, 12 Dec 2013 09:57:01 +0200
Message-ID: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series provide:

(0) IOMMU standard DT binding("iommus")
(1) Unified IOMMU(SMMU) driver among Tegra SoCs
(2) Multiple Address Space support(MASID) in IOMMU(SMMMU)
(3) Tegra IOMMU'able devices, most of platform devices are IOMMU'able.

There's been some discussion[1] about device population order. Some
devices needs to be populated earlier than other devices regardless of
their bus topology. For the solution I implemented an IOMMU hook in
driver core:

  [PATCHv7 04/13] driver/core: populate devices in order for IOMMUs

which is based on:
  http://lists.linuxfoundation.org/pipermail/iommu/2013-November/006933.html

The main problem here is,

IOMMU devices on the bus need to be poplulated first, then iommu
master devices are done later.

With CONFIG_OF_IOMMU, "iommus=" DT binding would be used to identify
whether a device can be an iommu msater or not. If a device can, we'll
defer to populate that device till an iommu device is populated. Then,
those defered iommu master devices are populated and configured with
help of the already populated iommu device via a new IOMMU API
iommu_ops->driver_bound().

This "iommus=" binding is expected used as the global/standard binding.

Tested IOMMU functionality with T30 SD/MMC. Any further testing with
T114 and/or other devices would be really appreciated.

v6:
Minior fixes.
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/213082.html

v5:
Use "iommus=" DT bindings as a standard IOMMU binding.
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/212331.html

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

  git://git@nv-tegra.nvidia.com/user/hdoyu/linux.git smmu-upstreaming@20131212

Hiroshi Doyu (12):
  of: introduce of_property_for_each_phandle_with_args()
  iommu/of: introduce a global iommu device list
  iommu/of: check if dependee iommu is ready or not
  driver/core: populate devices in order for IOMMUs
  iommu/core: add ops->{bound,unbind}_driver()
  ARM: tegra: create a DT header defining SWGROUP ID
  iommu/tegra: smmu: register device to iommu dynamically
  iommu/tegra: smmu: calculate ASID register offset by ID
  iommu/tegra: smmu: get swgroups from DT "iommus="
  iommu/tegra: smmu: allow duplicate ASID wirte
  iommu/tegra: smmu: Rename hwgrp -> swgroups
  iommu/tegra: smmu: add SMMU to an global iommu list

 .../bindings/iommu/nvidia,tegra30-smmu.txt         |  30 +-
 drivers/base/dd.c                                  |   5 +
 drivers/iommu/Kconfig                              |   1 +
 drivers/iommu/iommu.c                              |  13 +-
 drivers/iommu/of_iommu.c                           |  51 +++
 drivers/iommu/tegra-smmu.c                         | 383 +++++++++++++--------
 drivers/of/base.c                                  |  46 +++
 include/dt-bindings/memory/tegra-swgroup.h         |  50 +++
 include/linux/iommu.h                              |   4 +
 include/linux/of.h                                 |  32 ++
 include/linux/of_iommu.h                           |  22 ++
 11 files changed, 487 insertions(+), 150 deletions(-)
 create mode 100644 include/dt-bindings/memory/tegra-swgroup.h

-- 
1.8.1.5

[1]
  "[RFC] early init and DT platform devices allocation/registration"
    https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/thread.html#36542
  "Report from 2013 ARM kernel summit"
    http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/210426.html
  "[RFC PATCH] Documentation: devicetree: add description for generic bus properties"
    http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/215042.html

