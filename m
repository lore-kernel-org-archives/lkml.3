Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3EZP7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:59:19 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42605 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab3EZP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:59:14 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@kernel.org>,
        Donald Dutile <ddutile@redhat.com>, Hannes Reinecke <hare@suse.de>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>, iommu@lists.linux-foundation.org
Subject: [PATCH v3, part2 17/20] PCI, iommu: use hotplug-safe iterators to walk PCI buses
Date: Sun, 26 May 2013 23:53:14 +0800
Message-Id: <1369583597-3801-18-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance iommu drviers to use hotplug-safe iterators to walk
PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Donald Dutile <ddutile@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/iommu/amd_iommu.c | 4 +++-
 drivers/iommu/dmar.c      | 6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 21d02b0..eef7a7e 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -352,6 +352,7 @@ static int init_iommu_group(struct device *dev)
 	struct iommu_dev_data *dev_data;
 	struct iommu_group *group;
 	struct pci_dev *dma_pdev;
+	struct pci_bus *b = NULL;
 	int ret;
 
 	group = iommu_group_get(dev);
@@ -388,7 +389,7 @@ static int init_iommu_group(struct device *dev)
 		 * the alias.  Be careful to also test the parent device if
 		 * we think the alias is the root of the group.
 		 */
-		bus = pci_find_bus(0, alias >> 8);
+		b = bus = pci_get_bus(0, alias >> 8);
 		if (!bus)
 			goto use_group;
 
@@ -408,6 +409,7 @@ static int init_iommu_group(struct device *dev)
 	dma_pdev = get_isolation_root(pci_dev_get(to_pci_dev(dev)));
 use_pdev:
 	ret = use_pdev_iommu_group(dma_pdev, dev);
+	pci_bus_put(b);
 	pci_dev_put(dma_pdev);
 	return ret;
 use_group:
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index a7967ce..7162787 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -67,12 +67,12 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 					   struct pci_dev **dev, u16 segment)
 {
-	struct pci_bus *bus;
+	struct pci_bus *b, *bus;
 	struct pci_dev *pdev = NULL;
 	struct acpi_dmar_pci_path *path;
 	int count;
 
-	bus = pci_find_bus(segment, scope->bus);
+	b = bus = pci_get_bus(segment, scope->bus);
 	path = (struct acpi_dmar_pci_path *)(scope + 1);
 	count = (scope->length - sizeof(struct acpi_dmar_device_scope))
 		/ sizeof(struct acpi_dmar_pci_path);
@@ -97,6 +97,8 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 		count --;
 		bus = pdev->subordinate;
 	}
+	pci_bus_put(b);
+
 	if (!pdev) {
 		pr_warn("Device scope device [%04x:%02x:%02x.%02x] not found\n",
 			segment, scope->bus, path->dev, path->fn);
-- 
1.8.1.2

