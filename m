Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab3DBWwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:52:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab3DBWvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:51:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Degert <andreas.degert@googlemail.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [ 56/56] iommu/amd: Make sure dma_ops are set for hotplug devices
Date: Tue,  2 Apr 2013 15:50:23 -0700
Message-Id: <20130402224718.254613974@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/kernel/amd_iommu.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -53,6 +53,8 @@ static struct protection_domain *pt_doma
 
 static struct iommu_ops amd_iommu_ops;
 
+static struct dma_map_ops amd_iommu_dma_ops;
+
 /*
  * general struct to manage commands send to an IOMMU
  */
@@ -1778,18 +1780,20 @@ static int device_change_notifier(struct
 
 		domain = domain_for_device(dev);
 
-		/* allocate a protection domain if a device is added */
 		dma_domain = find_protection_domain(devid);
-		if (dma_domain)
-			goto out;
-		dma_domain = dma_ops_domain_alloc();
-		if (!dma_domain)
-			goto out;
-		dma_domain->target_dev = devid;
+		if (!dma_domain) {
+			/* allocate a protection domain if a device is added */
+			dma_domain = dma_ops_domain_alloc();
+			if (!dma_domain)
+				goto out;
+			dma_domain->target_dev = devid;
+
+			spin_lock_irqsave(&iommu_pd_list_lock, flags);
+			list_add_tail(&dma_domain->list, &iommu_pd_list);
+			spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+		}
 
-		spin_lock_irqsave(&iommu_pd_list_lock, flags);
-		list_add_tail(&dma_domain->list, &iommu_pd_list);
-		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
+		dev->archdata.dma_ops = &amd_iommu_dma_ops;
 
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:


