Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaHRMVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:21:08 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:49831 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaHRMVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:21:06 -0400
Date: Mon, 18 Aug 2014 15:20:56 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: joro@8bytes.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] iommu: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818122056.GA29961@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/iommu/dmar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 9a4f05e..da9220b 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -246,7 +246,7 @@ int dmar_remove_dev_scope(struct dmar_pci_notify_info *info, u16 segment,
 
 	for_each_active_dev_scope(devices, count, index, tmp)
 		if (tmp == &info->dev->dev) {
-			rcu_assign_pointer(devices[index].dev, NULL);
+			RCU_INIT_POINTER(devices[index].dev, NULL);
 			synchronize_rcu();
 			put_device(tmp);
 			return 1;
-- 
1.9.1

