Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397AbaHZJg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:36:29 -0400
Received: from 8bytes.org ([81.169.241.247]:55282 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787AbaHZJgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:36:23 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 2/4] iommu/amd: Keep a list of devices in an alias group
Date: Tue, 26 Aug 2014 11:36:12 +0200
Message-Id: <1409045774-32000-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409045774-32000-1-git-send-email-joro@8bytes.org>
References: <1409045774-32000-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Some broken devices might use any request-id from the alias
group, so we need to set a DTE entry for every device in
there. This patch adds creation of those lists.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index fe6d7cc..8a15256 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -93,6 +93,7 @@ static struct dma_map_ops amd_iommu_dma_ops;
 struct iommu_dev_data {
 	struct list_head list;		  /* For domain->dev_list */
 	struct list_head dev_data_list;	  /* For global dev_data_list */
+	struct list_head alias_list;      /* Link alias-groups together */
 	struct iommu_dev_data *alias_data;/* The alias dev_data */
 	struct protection_domain *domain; /* Domain the device is bound to */
 	atomic_t bind;			  /* Domain attach reference count */
@@ -135,6 +136,8 @@ static struct iommu_dev_data *alloc_dev_data(u16 devid)
 	if (!dev_data)
 		return NULL;
 
+	INIT_LIST_HEAD(&dev_data->alias_list);
+
 	dev_data->devid = devid;
 	atomic_set(&dev_data->bind, 0);
 
@@ -383,6 +386,9 @@ static int iommu_init_device(struct device *dev)
 			return -ENOTSUPP;
 		}
 		dev_data->alias_data = alias_data;
+
+		/* Add device to the alias_list */
+		list_add(&dev_data->alias_list, &alias_data->alias_list);
 	}
 
 	ret = init_iommu_group(dev);
-- 
1.9.1

