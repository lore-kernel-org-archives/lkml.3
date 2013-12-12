Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3LLIBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 03:01:09 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15479 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3LLH6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 00:01:01 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 05/12] iommu/core: add ops->{bound,unbind}_driver()
Date: Thu, 12 Dec 2013 09:57:06 +0200
Message-ID: <1386835033-4701-6-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ops->{bound,unbind}_driver() functions are called at
BUS_NOTIFY_{BOUND,UNBIND}_DRIVER respectively.

This is necessary to control the device population order. IOMMU master
devices depend on an IOMMU device instanciation. IOMMU master devices
can be registered to an IOMMU only after it's successfully
populated. This IOMMU registration is done via
ops->bound_driver(). Currently this population can be deferred if
depending IOMMU device hasn't yet been populated in driver core. This
cannot be done via ops->add_device() since after add_device() device's
population/instanciation can be still deferred via probe().

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v6:
New for v6.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/iommu/iommu.c | 13 +++++++++++--
 include/linux/iommu.h |  4 ++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e5555fc..5469d36 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -540,14 +540,23 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 	 * ADD/DEL call into iommu driver ops if provided, which may
 	 * result in ADD/DEL notifiers to group->notifier
 	 */
-	if (action == BUS_NOTIFY_ADD_DEVICE) {
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
 		if (ops->add_device)
 			return ops->add_device(dev);
-	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+	case BUS_NOTIFY_DEL_DEVICE:
 		if (ops->remove_device && dev->iommu_group) {
 			ops->remove_device(dev);
 			return 0;
 		}
+	case BUS_NOTIFY_BOUND_DRIVER:
+		if (ops->bound_driver)
+			ops->bound_driver(dev);
+		break;
+	case BUS_NOTIFY_UNBIND_DRIVER:
+		if (ops->unbind_driver)
+			ops->unbind_driver(dev);
+		break;
 	}
 
 	/*
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a444c79..a0e92be 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -96,6 +96,8 @@ enum iommu_attr {
  * @domain_has_cap: domain capabilities query
  * @add_device: add device to iommu grouping
  * @remove_device: remove device from iommu grouping
+ * @bound_driver: called at BUS_NOTIFY_BOUND_DRIVER
+ * @unbind_driver: called at BUS_NOTIFY_UNBIND_DRIVER
  * @domain_get_attr: Query domain attributes
  * @domain_set_attr: Change domain attributes
  * @pgsize_bitmap: bitmap of supported page sizes
@@ -114,6 +116,8 @@ struct iommu_ops {
 			      unsigned long cap);
 	int (*add_device)(struct device *dev);
 	void (*remove_device)(struct device *dev);
+	int (*bound_driver)(struct device *dev);
+	void (*unbind_driver)(struct device *dev);
 	int (*device_group)(struct device *dev, unsigned int *groupid);
 	int (*domain_get_attr)(struct iommu_domain *domain,
 			       enum iommu_attr attr, void *data);
-- 
1.8.1.5

