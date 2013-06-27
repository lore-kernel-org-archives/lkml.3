Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3F0HOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:14:34 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51082 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3F0HOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:14:31 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] vfio: add external user support
Date: Thu, 27 Jun 2013 17:14:20 +1000
Message-Id: <1372317260-6438-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130627164752.657c165ec4492e5248945a51@canb.auug.org.au>
References: <20130627164752.657c165ec4492e5248945a51@canb.auug.org.au>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO is designed to be used via ioctls on file descriptors
returned by VFIO.

However in some situations support for an external user is required.
The first user is KVM on PPC64 (SPAPR TCE protocol) which is going to
use the existing VFIO groups for exclusive access in real/virtual mode
in the host kernel to avoid passing map/unmap requests to the user
space which would made things pretty slow.

The proposed protocol includes:

1. do normal VFIO init stuff such as opening a new container, attaching
group(s) to it, setting an IOMMU driver for a container. When IOMMU is
set for a container, all groups in it are considered ready to use by
an external user.

2. pass a fd of the group we want to accelerate to KVM. KVM calls
vfio_group_iommu_id_from_file() to verify if the group is initialized
and IOMMU is set for it. The current TCE IOMMU driver marks the whole
IOMMU table as busy when IOMMU is set for a container what this prevents
other DMA users from allocating from it so it is safe to pass the group
to the user space.

3. KVM increases the container users counter via
vfio_group_add_external_user(). This prevents the VFIO group from
being disposed prior to exiting KVM.

4. When KVM is finished and doing cleanup, it releases the group file
and decrements the container users counter. Everything gets released.

5. KVM also keeps the group file as otherwise its fd might have been
closed at the moment of KVM finish so vfio_group_del_external_user()
call will not be possible.

The "vfio: Limit group opens" patch is also required for the consistency.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

v1->v2: added definitions to vfio.h :)
Should not compile but compiled. Hm.

---
 drivers/vfio/vfio.c  |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h |    7 +++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c488da5..40875d2 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1370,6 +1370,60 @@ static const struct file_operations vfio_device_fops = {
 };
 
 /**
+ * External user API, exported by symbols to be linked dynamically.
+ */
+
+/* Allows an external user (for example, KVM) to lock an IOMMU group */
+int vfio_group_add_external_user(struct file *filep)
+{
+	struct vfio_group *group = filep->private_data;
+
+	if (filep->f_op != &vfio_group_fops)
+		return -EINVAL;
+
+	if (!atomic_inc_not_zero(&group->container_users))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_group_add_external_user);
+
+/* Allows an external user (for example, KVM) to unlock an IOMMU group */
+void vfio_group_del_external_user(struct file *filep)
+{
+	struct vfio_group *group = filep->private_data;
+
+	if (WARN_ON(filep->f_op != &vfio_group_fops))
+		return;
+
+	vfio_group_try_dissolve_container(group);
+}
+EXPORT_SYMBOL_GPL(vfio_group_del_external_user);
+
+/*
+ * Checks if a group for the specified file can be used by
+ * an external user and returns the IOMMU ID if external use is possible.
+ */
+int vfio_group_iommu_id_from_file(struct file *filep)
+{
+	int ret;
+	struct vfio_group *group = filep->private_data;
+
+	if (WARN_ON(filep->f_op != &vfio_group_fops))
+		return -EINVAL;
+
+	if (0 == atomic_read(&group->container_users) ||
+			!group->container->iommu_driver ||
+			!vfio_group_viable(group))
+		return -EINVAL;
+
+	ret = iommu_group_id(group->iommu_group);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_group_iommu_id_from_file);
+
+/**
  * Module/class support
  */
 static char *vfio_devnode(struct device *dev, umode_t *mode)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ac8d488..7ee6575 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -90,4 +90,11 @@ extern void vfio_unregister_iommu_driver(
 	TYPE tmp;						\
 	offsetof(TYPE, MEMBER) + sizeof(tmp.MEMBER); })		\
 
+/*
+ * External user API
+ */
+int vfio_group_add_external_user(struct file *filep);
+void vfio_group_del_external_user(struct file *filep);
+int vfio_group_iommu_id_from_file(struct file *filep);
+
 #endif /* VFIO_H */
-- 
1.7.10.4

