Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3HPKIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:08:21 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47891 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab3HPKIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:08:17 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: aik@ozlabs.ru, benh@au1.ibm.com, paulus@au1.ibm.com,
        Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH 1/2] iommu: Don't remove device when no iommu_group associated
Date: Fri, 16 Aug 2013 18:08:06 +0800
Message-Id: <1376647687-20550-2-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1376647687-20550-1-git-send-email-weiyang@linux.vnet.ibm.com>
References: <1376647687-20550-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081609-9574-0000-0000-000009353906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases, one device may not associated with any iommu_group.
For example, not enough DMA address space.

For those devices, kernel will crash when try to remove it from an iommu_group.

This patch do the check before remove it.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 drivers/iommu/iommu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fbe9ca7..fe41946 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -379,6 +379,9 @@ void iommu_group_remove_device(struct device *dev)
 	struct iommu_group *group = dev->iommu_group;
 	struct iommu_device *tmp_device, *device = NULL;
 
+	if (!group)
+		return;
+
 	/* Pre-notify listeners that a device is being removed. */
 	blocking_notifier_call_chain(&group->notifier,
 				     IOMMU_GROUP_NOTIFY_DEL_DEVICE, dev);
-- 
1.7.5.4

