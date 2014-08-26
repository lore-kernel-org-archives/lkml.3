Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251AbaHZJg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:36:26 -0400
Received: from 8bytes.org ([81.169.241.247]:55285 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbaHZJgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:36:23 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4/4] iommu/amd: Remove device binding reference count
Date: Tue, 26 Aug 2014 11:36:14 +0200
Message-Id: <1409045774-32000-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409045774-32000-1-git-send-email-joro@8bytes.org>
References: <1409045774-32000-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This reference count is not used anymore, as all devices in
an alias group are now attached and detached together.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a5e6b0a..989c1ae 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -96,7 +96,6 @@ struct iommu_dev_data {
 	struct list_head alias_list;      /* Link alias-groups together */
 	struct iommu_dev_data *alias_data;/* The alias dev_data */
 	struct protection_domain *domain; /* Domain the device is bound to */
-	atomic_t bind;			  /* Domain attach reference count */
 	u16 devid;			  /* PCI Device ID */
 	bool iommu_v2;			  /* Device can make use of IOMMUv2 */
 	bool passthrough;		  /* Default for device is pt_domain */
@@ -139,7 +138,6 @@ static struct iommu_dev_data *alloc_dev_data(u16 devid)
 	INIT_LIST_HEAD(&dev_data->alias_list);
 
 	dev_data->devid = devid;
-	atomic_set(&dev_data->bind, 0);
 
 	spin_lock_irqsave(&dev_data_list_lock, flags);
 	list_add_tail(&dev_data->dev_data_list, &dev_data_list);
@@ -3179,7 +3177,6 @@ static void cleanup_domain(struct protection_domain *domain)
 		entry = list_first_entry(&domain->dev_list,
 					 struct iommu_dev_data, list);
 		__detach_device(entry);
-		atomic_set(&entry->bind, 0);
 	}
 
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
-- 
1.9.1

