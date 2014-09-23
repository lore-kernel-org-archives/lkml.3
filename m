Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaIWCf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:35:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:37604 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaIWCfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:35:23 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 10/45] iommu/amd: Fix cleanup_domain for mass device removal
Date: Tue, 23 Sep 2014 10:31:12 +0800
Message-Id: <1411439507-30391-10-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 9b29d3c6510407d91786c1cf9183ff4debb3473a upstream.

When multiple devices are detached in __detach_device, they
are also removed from the domains dev_list. This makes it
unsafe to use list_for_each_entry_safe, as the next pointer
might also not be in the list anymore after __detach_device
returns. So just repeatedly remove the first element of the
list until it is empty.

Tested-by: Marti Raudsepp <marti@juffo.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/iommu/amd_iommu.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c0536ed..a55353c3 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3028,14 +3028,16 @@ free_domains:
 
 static void cleanup_domain(struct protection_domain *domain)
 {
-	struct iommu_dev_data *dev_data, *next;
+	struct iommu_dev_data *entry;
 	unsigned long flags;
 
 	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
 
-	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
-		__detach_device(dev_data);
-		atomic_set(&dev_data->bind, 0);
+	while (!list_empty(&domain->dev_list)) {
+		entry = list_first_entry(&domain->dev_list,
+					 struct iommu_dev_data, list);
+		__detach_device(entry);
+		atomic_set(&entry->bind, 0);
 	}
 
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
-- 
1.7.9.5

