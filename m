Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbbA0AKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:10:23 -0500
Received: from 8bytes.org ([81.169.241.247]:51351 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbbA0AJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 4/5] iommu: Make sure a device is always attached to a domain
Date: Tue, 27 Jan 2015 01:08:58 +0100
Message-Id: <1422317339-22620-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422317339-22620-1-git-send-email-joro@8bytes.org>
References: <1422317339-22620-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Make use of the default domain and re-attach a device to it
when it is detached from another domain. Also enforce that a
device has to be in the default domain before it can be
attached to a different domain.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b63a550..5080759 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -53,6 +53,7 @@ struct iommu_group {
 	int id;
 	unsigned dev_cnt;
 	struct iommu_domain *default_domain;
+	struct iommu_domain *domain;
 };
 
 struct iommu_device {
@@ -1040,8 +1041,17 @@ static int iommu_group_do_attach_device(struct device *dev, void *data)
 
 int iommu_attach_group(struct iommu_domain *domain, struct iommu_group *group)
 {
-	return iommu_group_for_each_dev(group, domain,
-					iommu_group_do_attach_device);
+	int ret;
+
+	if (group->default_domain && group->domain != group->default_domain)
+		return -EBUSY;
+
+	ret = iommu_group_for_each_dev(group, domain,
+				       iommu_group_do_attach_device);
+	if (ret == 0)
+		group->domain = domain;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_attach_group);
 
@@ -1056,7 +1066,25 @@ static int iommu_group_do_detach_device(struct device *dev, void *data)
 
 void iommu_detach_group(struct iommu_domain *domain, struct iommu_group *group)
 {
-	iommu_group_for_each_dev(group, domain, iommu_group_do_detach_device);
+	int ret;
+
+	if (!group->default_domain) {
+		iommu_group_for_each_dev(group, domain,
+					 iommu_group_do_detach_device);
+		group->domain = NULL;
+		return;
+	}
+
+	if (group->domain == group->default_domain)
+		return;
+
+	/* Detach by re-attaching to the default domain */
+	ret = iommu_group_for_each_dev(group, group->default_domain,
+				       iommu_group_do_attach_device);
+	if (ret != 0)
+		WARN_ON(1);
+	else
+		group->domain = group->default_domain;
 }
 EXPORT_SYMBOL_GPL(iommu_detach_group);
 
-- 
1.9.1

