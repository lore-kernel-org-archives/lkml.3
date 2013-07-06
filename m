Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3GFPHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 11:07:40 -0400
Received: from mail-gg0-f179.google.com ([209.85.161.179]:41458 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3GFPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:07:34 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: [PATCH 3/8] vfio: add external user support
Date: Sun,  7 Jul 2013 01:07:02 +1000
Message-Id: <1373123227-22969-4-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO is designed to be used via ioctls on file descriptors
returned by VFIO.

However in some situations support for an external user is required.
The first user is KVM on PPC64 (SPAPR TCE protocol) which is going to
use the existing VFIO groups for exclusive access in real/virtual mode
on a host to avoid passing map/unmap requests to the user space which
would made things pretty slow.

The proposed protocol includes:

1. do normal VFIO init stuff such as opening a new container, attaching
group(s) to it, setting an IOMMU driver for a container. When IOMMU is
set for a container, all groups in it are considered ready to use by
an external user.

2. pass a fd of the group we want to accelerate to KVM. KVM calls
vfio_group_get_external_user() to verify if the group is initialized,
IOMMU is set for it and increment the container user counter to prevent
the VFIO group from disposal prior to KVM exit.
The current TCE IOMMU driver marks the whole IOMMU table as busy when
IOMMU is set for a container what prevents other DMA users from
allocating from it so it is safe to grant user space access to it.

3. KVM calls vfio_external_user_iommu_id() to obtian an IOMMU ID which
KVM uses to get an iommu_group struct for later use.

4. When KVM is finished, it calls vfio_group_put_external_user() to
release the VFIO group by decrementing the container user counter.
Everything gets released.

The "vfio: Limit group opens" patch is also required for the consistency.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c488da5..57aa191 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1370,6 +1370,62 @@ static const struct file_operations vfio_device_fops = {
 };
 
 /**
+ * External user API, exported by symbols to be linked dynamically.
+ *
+ * The protocol includes:
+ *  1. do normal VFIO init operation:
+ *	- opening a new container;
+ *	- attaching group(s) to it;
+ *	- setting an IOMMU driver for a container.
+ * When IOMMU is set for a container, all groups in it are
+ * considered ready to use by an external user.
+ *
+ * 2. The user space passed a group fd which we want to accelerate in
+ * KVM. KVM uses vfio_group_get_external_user() to verify that:
+ *	- the group is initialized;
+ *	- IOMMU is set for it.
+ * Then vfio_group_get_external_user() increments the container user
+ * counter to prevent the VFIO group from disposal prior to KVM exit.
+ *
+ * 3. KVM calls vfio_external_user_iommu_id() to know an IOMMU ID which
+ * KVM uses to get an iommu_group struct for later use.
+ *
+ * 4. When KVM is finished, it calls vfio_group_put_external_user() to
+ * release the VFIO group by decrementing the container user counter.
+ */
+struct vfio_group *vfio_group_get_external_user(struct file *filep)
+{
+	struct vfio_group *group = filep->private_data;
+
+	if (filep->f_op != &vfio_group_fops)
+		return NULL;
+
+	if (!atomic_inc_not_zero(&group->container_users))
+		return NULL;
+
+	if (!group->container->iommu_driver ||
+			!vfio_group_viable(group)) {
+		atomic_dec(&group->container_users);
+		return NULL;
+	}
+
+	return group;
+}
+EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
+
+void vfio_group_put_external_user(struct vfio_group *group)
+{
+	vfio_group_try_dissolve_container(group);
+}
+EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
+
+int vfio_external_user_iommu_id(struct vfio_group *group)
+{
+	return iommu_group_id(group->iommu_group);
+}
+EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
+
+/**
  * Module/class support
  */
 static char *vfio_devnode(struct device *dev, umode_t *mode)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ac8d488..24579a0 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -90,4 +90,11 @@ extern void vfio_unregister_iommu_driver(
 	TYPE tmp;						\
 	offsetof(TYPE, MEMBER) + sizeof(tmp.MEMBER); })		\
 
+/*
+ * External user API
+ */
+extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
+extern void vfio_group_put_external_user(struct vfio_group *group);
+extern int vfio_external_user_iommu_id(struct vfio_group *group);
+
 #endif /* VFIO_H */
-- 
1.8.3.2

