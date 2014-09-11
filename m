Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaIKM60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:58:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51567 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755401AbaIKMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marti Raudsepp" <marti@juffo.org>,
        "Joerg Roedel" <jroedel@suse.de>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.318712973@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 074/131] iommu/amd: Fix cleanup_domain for mass device
 removal
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <jroedel@suse.de>

commit 9b29d3c6510407d91786c1cf9183ff4debb3473a upstream.

When multiple devices are detached in __detach_device, they
are also removed from the domains dev_list. This makes it
unsafe to use list_for_each_entry_safe, as the next pointer
might also not be in the list anymore after __detach_device
returns. So just repeatedly remove the first element of the
list until it is empty.

Tested-by: Marti Raudsepp <marti@juffo.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/amd_iommu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2592,14 +2592,16 @@ free_domains:
 
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

