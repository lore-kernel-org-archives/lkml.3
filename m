Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab3DBW3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:29:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667Ab3DBWON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Degert <andreas.degert@googlemail.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [ 19/68] iommu/amd: Make sure dma_ops are set for hotplug devices
Date: Tue,  2 Apr 2013 15:13:08 -0700
Message-Id: <20130402221332.180553538@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joro@8bytes.org>

commit c2a2876e863356b092967ea62bebdb4dd663af80 upstream.

There is a bug introduced with commit 27c2127 that causes
devices which are hot unplugged and then hot-replugged to
not have per-device dma_ops set. This causes these devices
to not function correctly. Fixed with this patch.

Reported-by: Andreas Degert <andreas.degert@googlemail.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2270,18 +2270,16 @@ static int device_change_notifier(struct
 
 		/* allocate a protection domain if a device is added */
 		dma_domain = find_protection_domain(devid);
-		if (dma_domain)
-			goto out;
-		dma_domain = dma_ops_domain_alloc();
-		if (!dma_domain)
-			goto out;
-		dma_domain->target_dev = devid;
+		if (!dma_domain) {
+			dma_domain = dma_ops_domain_alloc();
+			if (!dma_domain)
+				goto out;
+			dma_domain->target_dev = devid;
 
-		spin_lock_irqsave(&iommu_pd_list_lock, flags);
-		list_add_tail(&dma_domain->list, &iommu_pd_list);
-		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
-
-		dev_data = get_dev_data(dev);
+			spin_lock_irqsave(&iommu_pd_list_lock, flags);
+			list_add_tail(&dma_domain->list, &iommu_pd_list);
+			spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+		}
 
 		dev->archdata.dma_ops = &amd_iommu_dma_ops;
 


