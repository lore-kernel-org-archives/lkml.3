Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaI3LCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:02:12 -0400
Received: from 8bytes.org ([81.169.241.247]:58905 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaI3LCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:02:07 -0400
From: Joerg Roedel <joro@8bytes.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        joro@8bytes.org, jroedel@suse.de
Subject: [PATCH 2/2] iommu/vt-d: Only remove domain when device is removed
Date: Tue, 30 Sep 2014 13:02:03 +0200
Message-Id: <1412074923-6342-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412074923-6342-1-git-send-email-joro@8bytes.org>
References: <1412074923-6342-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This makes sure any RMRR mappings stay in place when the
driver is unbound from the device.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 5619f26..eaf825a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3865,16 +3865,7 @@ static int device_notifier(struct notifier_block *nb,
 	if (iommu_dummy(dev))
 		return 0;
 
-	if (action != BUS_NOTIFY_UNBOUND_DRIVER &&
-	    action != BUS_NOTIFY_DEL_DEVICE)
-		return 0;
-
-	/*
-	 * If the device is still attached to a device driver we can't
-	 * tear down the domain yet as DMA mappings may still be in use.
-	 * Wait for the BUS_NOTIFY_UNBOUND_DRIVER event to do that.
-	 */
-	if (action == BUS_NOTIFY_DEL_DEVICE && dev->driver != NULL)
+	if (action != BUS_NOTIFY_REMOVED_DEVICE)
 		return 0;
 
 	domain = find_domain(dev);
-- 
1.9.1

