Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab3KUIYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 03:24:04 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:10554 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3KUIYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 03:24:03 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Yijing Wang" <wangyijing@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH v2] Enhance dmar to support device hotplug
Date: Thu, 21 Nov 2013 16:21:55 +0800
Message-ID: <1385022116-228-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the v2 patch, the v1 link: http://marc.info/?l=linux-pci&m=138364004628824&w=2

v1->v2: keep (pci_dev *) pointer array in dmar_drhd_uni, only use pci device id
		to update pci_dev * pointer info during device hotplug in intel iommu 
		driver notifier.

Currently, DMAR driver save target pci devices pointers for drhd/rmrr/atsr
in (pci_dev *) array, but never update these info after initialization.
It's not safe, because pci devices maybe hot added or removed during 
system running. They will have new pci_dev * pointer. So if there have 
two IOMMUs or more in system, these devices will find a wrong drhd during 
DMA mapping. And DMAR faults will occur. This patch save pci device id 
as well as (pci_dev *) to fix this issue. Pci device id will be used to update
pci_dev * poninter during device hotplug in intel iommu driver notifier.
Other, here use list to manage target devices for IOMMU, 
we can easily use list helper.

Yijing Wang (1):
  IOMMU: enhance dmar to support device hotplug

 drivers/iommu/dmar.c        |   82 +++++++++++-----------
 drivers/iommu/intel-iommu.c |  161 +++++++++++++++++++++++++++++-------------
 include/linux/dmar.h        |   24 ++++--
 3 files changed, 167 insertions(+), 100 deletions(-)


