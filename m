Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbaHZJhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:37:38 -0400
Received: from 8bytes.org ([81.169.241.247]:55281 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbaHZJgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:36:23 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/4] iommu/amd: Attach and detach complete alias group
Date: Tue, 26 Aug 2014 11:36:13 +0200
Message-Id: <1409045774-32000-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409045774-32000-1-git-send-email-joro@8bytes.org>
References: <1409045774-32000-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Change tha device attach and detach semantic to apply to all
devices in an alias group. This means all devices in an
alias group are now attached and detached at the same time.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu.c | 46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 8a15256..a5e6b0a 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2149,35 +2149,29 @@ static void do_detach(struct iommu_dev_data *dev_data)
 static int __attach_device(struct iommu_dev_data *dev_data,
 			   struct protection_domain *domain)
 {
+	struct iommu_dev_data *head, *entry;
 	int ret;
 
 	/* lock domain */
 	spin_lock(&domain->lock);
 
-	if (dev_data->alias_data != NULL) {
-		struct iommu_dev_data *alias_data = dev_data->alias_data;
-
-		/* Some sanity checks */
-		ret = -EBUSY;
-		if (alias_data->domain != NULL &&
-				alias_data->domain != domain)
-			goto out_unlock;
+	head = dev_data;
 
-		if (dev_data->domain != NULL &&
-				dev_data->domain != domain)
-			goto out_unlock;
+	if (head->alias_data != NULL)
+		head = head->alias_data;
 
-		/* Do real assignment */
-		if (alias_data->domain == NULL)
-			do_attach(alias_data, domain);
+	/* Now we have the root of the alias group, if any */
 
-		atomic_inc(&alias_data->bind);
-	}
+	ret = -EBUSY;
+	if (head->domain != NULL)
+		goto out_unlock;
 
-	if (dev_data->domain == NULL)
-		do_attach(dev_data, domain);
+	/* Attach alias group root */
+	do_attach(head, domain);
 
-	atomic_inc(&dev_data->bind);
+	/* Attach other devices in the alias group */
+	list_for_each_entry(entry, &head->alias_list, alias_list)
+		do_attach(entry, domain);
 
 	ret = 0;
 
@@ -2325,6 +2319,7 @@ static int attach_device(struct device *dev,
  */
 static void __detach_device(struct iommu_dev_data *dev_data)
 {
+	struct iommu_dev_data *head, *entry;
 	struct protection_domain *domain;
 	unsigned long flags;
 
@@ -2334,15 +2329,14 @@ static void __detach_device(struct iommu_dev_data *dev_data)
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	if (dev_data->alias_data != NULL) {
-		struct iommu_dev_data *alias_data = dev_data->alias_data;
+	head = dev_data;
+	if (head->alias_data != NULL)
+		head = head->alias_data;
 
-		if (atomic_dec_and_test(&alias_data->bind))
-			do_detach(alias_data);
-	}
+	list_for_each_entry(entry, &head->alias_list, alias_list)
+		do_detach(entry);
 
-	if (atomic_dec_and_test(&dev_data->bind))
-		do_detach(dev_data);
+	do_detach(head);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
-- 
1.9.1

