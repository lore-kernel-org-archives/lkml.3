Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3CVGtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 02:49:18 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:44876 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab3CVGtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 02:49:17 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Joerg Roedel <joerg.roedel@amd.com>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] iommu: add a function to find an iommu group by id
Date: Fri, 22 Mar 2013 17:49:01 +1100
Message-Id: <1363934941-21020-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363883719.2747.13.camel@ul30vt.home>
References: <1363883719.2747.13.camel@ul30vt.home>
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

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/iommu/iommu.c |   28 ++++++++++++++++++++++++++++
 include/linux/iommu.h |    1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 1065a1a..531cbb5 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -204,6 +204,34 @@ again:
 }
 EXPORT_SYMBOL_GPL(iommu_group_alloc);
 
+struct iommu_group *iommu_group_get_by_id(int id)
+{
+	struct kobject *group_kobj;
+	struct iommu_group *grp;
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
+	grp = container_of(group_kobj, struct iommu_group, kobj);
+	BUG_ON(grp->id != id);
+
+	kobject_get(grp->devices_kobj);
+
+	return grp;
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

