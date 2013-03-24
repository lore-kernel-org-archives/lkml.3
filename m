Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3CXXYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 19:24:06 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43951 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab3CXXYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 19:24:04 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH] iommu: add a function to find an iommu group by id
Date: Mon, 25 Mar 2013 10:23:49 +1100
Message-Id: <1364167429-6432-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: 1363968462.24132.611.camel@bling.home
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As IOMMU groups are exposed to the user space by their numbers,
the user space can use them in various kernel APIs so the kernel
might need an API to find a group by its ID.

As an example, QEMU VFIO on PPC64 platform needs it to associate
a logical bus number (LIOBN) with a specific IOMMU group in order
to support in-kernel handling of DMA map/unmap requests.

The patch adds the iommu_group_get_by_id(id) function which performs
such search.

v2: fixed reference counting.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/iommu/iommu.c |   29 +++++++++++++++++++++++++++++
 include/linux/iommu.h |    1 +
 2 files changed, 30 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1065a1a..0de83eb 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -204,6 +204,35 @@ again:
 }
 EXPORT_SYMBOL_GPL(iommu_group_alloc);
 
+struct iommu_group *iommu_group_get_by_id(int id)
+{
+	struct kobject *group_kobj;
+	struct iommu_group *group;
+	const char *name;
+
+	if (!iommu_group_kset)
+		return NULL;
+
+	name = kasprintf(GFP_KERNEL, "%d", id);
+	if (!name)
+		return NULL;
+
+	group_kobj = kset_find_obj(iommu_group_kset, name);
+	kfree(name);
+
+	if (!group_kobj)
+		return NULL;
+
+	group = container_of(group_kobj, struct iommu_group, kobj);
+	BUG_ON(group->id != id);
+
+	kobject_get(group->devices_kobj);
+	kobject_put(&group->kobj);
+
+	return group;
+}
+EXPORT_SYMBOL_GPL(iommu_group_get_by_id);
+
 /**
  * iommu_group_get_iommudata - retrieve iommu_data registered for a group
  * @group: the group
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f3b99e1..00e5d7d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -113,6 +113,7 @@ struct iommu_ops {
 extern int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
+extern struct iommu_group *iommu_group_get_by_id(int id);
 extern void iommu_domain_free(struct iommu_domain *domain);
 extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
-- 
1.7.10.4

