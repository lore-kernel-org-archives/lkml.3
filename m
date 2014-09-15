Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbaIOThF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:37:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaIOThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marti Raudsepp <marti@juffo.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3.14 008/114] iommu/amd: Fix cleanup_domain for mass device removal
Date: Mon, 15 Sep 2014 12:25:08 -0700
Message-Id: <20140915192641.686703154@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3227,14 +3227,16 @@ free_domains:
 
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


