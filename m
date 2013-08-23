Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab3HWBzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 21:55:23 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:59522 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3HWBzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 21:55:22 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: aik@ozlabs.ru, paulus@au1.ibm.com, benh@au1.ibm.com,
        Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH] iommu: WARN_ON when removing a device with no iommu_group associated
Date: Fri, 23 Aug 2013 09:55:11 +0800
Message-Id: <1377222911-12144-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082301-2000-0000-0000-00000D6CC83D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing a device from the system, iommu_group driver will try to
disconnect it from its group. While in some cases, one device may not
associated with any iommu_group. For example, not enough DMA address space.

In the generic bus notification, it will check dev->iommu_group before calling
iommu_group_remove_device(). While in some cases, developers may call
iommu_group_remove_device() in a different code path and without check. For
those devices with dev->iommu_group set to NULL, kernel will crash.

This patch gives a warning and return when trying to remove a device from an
iommu_group with dev->iommu_group set to NULL. This helps to indicate some bad
behavior and also guard the kernel.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 drivers/iommu/iommu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fbe9ca7..43396f0 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -379,6 +379,9 @@ void iommu_group_remove_device(struct device *dev)
 	struct iommu_group *group = dev->iommu_group;
 	struct iommu_device *tmp_device, *device = NULL;
 
+	if (WARN_ON(!group))
+		return;
+
 	/* Pre-notify listeners that a device is being removed. */
 	blocking_notifier_call_chain(&group->notifier,
 				     IOMMU_GROUP_NOTIFY_DEL_DEVICE, dev);
-- 
1.7.5.4

