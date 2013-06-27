Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab3F0FDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:03:21 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63879 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3F0FDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:03:15 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH 3/8] vfio: add external user support
Date: Thu, 27 Jun 2013 15:02:31 +1000
Message-Id: <1372309356-28320-4-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
References: <1372309356-28320-1-git-send-email-aik@ozlabs.ru>
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
 drivers/vfio/vfio.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c488da5..54192b2 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1370,6 +1370,59 @@ static const struct file_operations vfio_device_fops = {
 };
 
 /**
+ * External user API, exported by symbols to be linked dynamically.
+ */
+
+/* Allows an external user (for example, KVM) to lock an IOMMU group */
+static int vfio_group_add_external_user(struct file *filep)
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
+static void vfio_group_del_external_user(struct file *filep)
+{
+	struct vfio_group *group = filep->private_data;
+
+	BUG_ON(filep->f_op != &vfio_group_fops);
+
+	vfio_group_try_dissolve_container(group);
+}
+EXPORT_SYMBOL_GPL(vfio_group_del_external_user);
+
+/*
+ * Checks if a group for the specified file can be used by
+ * an external user and returns the IOMMU ID if external use is possible.
+ */
+static int vfio_group_iommu_id_from_file(struct file *filep)
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
-- 
1.7.10.4

