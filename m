Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbbA0AKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:10:25 -0500
Received: from 8bytes.org ([81.169.241.247]:51332 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411AbbA0AJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:09:17 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Will Deacon <will.deacon@arm.com>, Kukjin Kim <kgene@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <joro@8bytes.org>, jroedel@suse.de
Subject: [PATCH 3/5] iommu: Limit iommu_attach/detach_device to devices with their own group
Date: Tue, 27 Jan 2015 01:08:57 +0100
Message-Id: <1422317339-22620-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422317339-22620-1-git-send-email-joro@8bytes.org>
References: <1422317339-22620-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This patch changes the behavior of the iommu_attach_device
and iommu_detach_device functions. With this change these
functions only work on devices that have their own group.
For all other devices the iommu_group_attach/detach
functions must be used.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 8f33ddd3..b63a550 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -51,6 +51,7 @@ struct iommu_group {
 	void (*iommu_data_release)(void *iommu_data);
 	char *name;
 	int id;
+	unsigned dev_cnt;
 	struct iommu_domain *default_domain;
 };
 
@@ -380,6 +381,7 @@ rename:
 
 	mutex_lock(&group->mutex);
 	list_add_tail(&device->list, &group->devices);
+	group->dev_cnt += 1;
 	mutex_unlock(&group->mutex);
 
 	/* Notify any listeners about change to group. */
@@ -408,6 +410,7 @@ void iommu_group_remove_device(struct device *dev)
 				     IOMMU_GROUP_NOTIFY_DEL_DEVICE, dev);
 
 	mutex_lock(&group->mutex);
+	group->dev_cnt -= 1;
 	list_for_each_entry(tmp_device, &group->devices, list) {
 		if (tmp_device->dev == dev) {
 			device = tmp_device;
@@ -943,7 +946,8 @@ void iommu_domain_free(struct iommu_domain *domain)
 }
 EXPORT_SYMBOL_GPL(iommu_domain_free);
 
-int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
+static int __iommu_attach_device(struct iommu_domain *domain,
+				 struct device *dev)
 {
 	int ret;
 	if (unlikely(domain->ops->attach_dev == NULL))
@@ -954,9 +958,38 @@ int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
 		trace_attach_device_to_domain(dev);
 	return ret;
 }
+
+int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
+{
+	struct iommu_group *group;
+	int ret;
+
+	group = iommu_group_get(dev);
+	/* FIXME: Remove this when groups a mandatory for iommu drivers */
+	if (group == NULL)
+		return __iommu_attach_device(domain, dev);
+
+	/*
+	 * We have a group - lock it to make sure the device-count doesn't
+	 * change while we are attaching
+	 */
+	mutex_lock(&group->mutex);
+	ret = -EINVAL;
+	if (group->dev_cnt != 1)
+		goto out_unlock;
+
+	ret = iommu_attach_group(domain, group);
+
+out_unlock:
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(iommu_attach_device);
 
-void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
+static void __iommu_detach_device(struct iommu_domain *domain,
+				  struct device *dev)
 {
 	if (unlikely(domain->ops->detach_dev == NULL))
 		return;
@@ -964,6 +997,28 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 	domain->ops->detach_dev(domain, dev);
 	trace_detach_device_from_domain(dev);
 }
+
+void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
+{
+	struct iommu_group *group;
+
+	group = iommu_group_get(dev);
+	/* FIXME: Remove this when groups a mandatory for iommu drivers */
+	if (group == NULL)
+		return __iommu_detach_device(domain, dev);
+
+	mutex_lock(&group->mutex);
+	if (group->dev_cnt != 1) {
+		WARN_ON(1);
+		goto out_unlock;
+	}
+
+	iommu_detach_group(domain, group);
+
+out_unlock:
+	mutex_unlock(&group->mutex);
+	iommu_group_put(group);
+}
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
 /*
@@ -980,7 +1035,7 @@ static int iommu_group_do_attach_device(struct device *dev, void *data)
 {
 	struct iommu_domain *domain = data;
 
-	return iommu_attach_device(domain, dev);
+	return __iommu_attach_device(domain, dev);
 }
 
 int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
@@ -994,7 +1049,7 @@ static int iommu_group_do_detach_device(struct device *dev, void *data)
 {
 	struct iommu_domain *domain = data;
 
-	iommu_detach_device(domain, dev);
+	__iommu_detach_device(domain, dev);
 
 	return 0;
 }
-- 
1.9.1

