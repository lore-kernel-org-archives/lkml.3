Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaBSGGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:06:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:46319 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaBSGGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:06:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,504,1389772800"; 
   d="scan'208";a="485626324"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V2 00/17] Enhance DMAR drivers to handle PCI/memory hotplug events
Date: Wed, 19 Feb 2014 14:07:20 +0800
Message-Id: <1392790057-32434-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel DMA/interrupt remapping drivers scan available PCI/memory devices
at startup and cache discovered hardware topologies. They don't update
cached information if PCI/memory hotplug event happens at runtime, then
the stale information may break DMA/interrupt remapping logic.

This patchset first (Patch 1-12) tries to introduces some helper
functions and fixes several bugs, then (Patch 13,14) uses a global
rwsem and RCU to protect global DMA/interrupt remapping data
structures, and finally (Patch 15-17) hook PCI/memory hotplug events
to update cached information.

It's also a preparation for supporting of DMA/interrupt remapping
hotplug.

V1->V2:
1) fix more bugs in dealing with identify mapping domain
2) address round 1 review comments

Jiang Liu (17):
  iommu/vt-d: avoid double free of g_iommus on error recovery path
  iommu/vt-d: avoid caching stale domain_device_info and fix memory
    leak
  iommu/vt-d: avoid caching stale domain_device_info when hot-removing
    PCI device
  iommu/vt-d: factor out dmar_alloc_dev_scope() for later reuse
  iommu/vt-d: move private structures and variables into intel-iommu.c
  iommu/vt-d: simplify function get_domain_for_dev()
  iommu/vt-d: free resources if failed to create domain for PCIe
    endpoint
  iommu/vt-d: reduce duplicated code to handle virtual machine domains
  iommu/vt-d: fix incorrect iommu_count for si_domain
  iommu/vt-d: check for NULL pointer when freeing IOMMU data structure
  iommu/vt-d: fix error in detect ATS capability
  iommu/vt-d: introduce macro for_each_dev_scope() to walk device scope
    entries
  iommu/vt-d: introduce a rwsem to protect global data structures
  iommu/vt-d: use RCU to protect global resources in interrupt context
  iommu/vt-d, PCI: update DRHD/RMRR/ATSR device scope caches when PCI
    hotplug happens
  iommu/vt-d, PCI: unify the way to process DMAR device scope array
  iommu/vt-d: update IOMMU state when memory hotplug happens

 drivers/iommu/dmar.c                |  412 +++++++++++++------
 drivers/iommu/intel-iommu.c         |  750 ++++++++++++++++++-----------------
 drivers/iommu/intel_irq_remapping.c |  108 +++--
 drivers/iommu/iova.c                |   64 ++-
 include/linux/dmar.h                |   74 ++--
 include/linux/iova.h                |    2 +
 6 files changed, 848 insertions(+), 562 deletions(-)

-- 
1.7.10.4

