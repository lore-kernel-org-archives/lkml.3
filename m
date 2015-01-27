Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbbA0VBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:01:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56501 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbbA0VBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:01:05 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <devicetree@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v5 0/8] PCI: get DMA configuration from parent device
Date: Tue, 27 Jan 2015 15:59:57 -0500
Message-ID: <1422392405-32196-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI devices on Keystone doesn't have correct dma_pfn_offset set. This patch
add capability to set the dma configuration such as dma-mask, dma_pfn_offset,
and dma ops etc using the information from DT. The prior RFCs and discussions
are available at [1] and [2] below.

[2] : https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg790244.html
[1] : http://www.gossamer-threads.com/lists/linux/kernel/2024591

Change history:
	v5 - moved the dma_mask update in device from ARM specific API to
	     of_dma_configure to allow this across other architecture as well
	   - improved sanity check for DT dma-range size in of_dma_configure()
	   - moved API to get parent bridge device to PCI (host-bridge.c)
	v4 - moved size adjustments in of_iommu_configure() to a separate patch
	   - consistent node name comment from Rob
	   - patch 6 added for dma_mask adjustment and iommu mapping size
	     limiting.
	v3 - addressed comments to re-use of_dma_configure() for PCI
	   - To help re-use, change of_iommu_configure() function argument
		- Move of_dma_configure to of/device.c
		- Limit the of_iommu_configure to non pci devices
	v2 - update size to coherent_dma_mask + 1 if dma-range info is missing
	   - also check the np for null.
	v1 - updates based on the comments against initial RFC.
	   - Added a helper function to get the OF node of the parent
	   - Added an API in of_pci.c to update DMA configuration of the pci
	     device.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Murali Karicheri <m-karicheri2@ti.com>

Murali Karicheri (8):
  of: iommu: add ptr to OF node arg to of_iommu_configure()
  of: move of_dma_configure() to device.c to help re-use
  of: fix size when dma-range is not used
  PCI: add helper functions pci_get[put]_host_bridge_device()
  of/pci: add of_pci_dma_configure() update dma configuration
  PCI: update dma configuration from DT
  arm: dma-mapping: limit iommu mapping size
  of: limit dma_mask of the device based on dma-range size

 arch/arm/mm/dma-mapping.c |    7 +++++
 drivers/iommu/of_iommu.c  |   10 +++++--
 drivers/of/device.c       |   69 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/of_pci.c       |   19 +++++++++++++
 drivers/of/platform.c     |   58 ++-----------------------------------
 drivers/pci/host-bridge.c |   14 +++++++++
 drivers/pci/probe.c       |    2 ++
 include/linux/of_device.h |    2 ++
 include/linux/of_iommu.h  |    6 ++--
 include/linux/of_pci.h    |    5 ++++
 include/linux/pci.h       |    3 ++
 11 files changed, 135 insertions(+), 60 deletions(-)

-- 
1.7.9.5

