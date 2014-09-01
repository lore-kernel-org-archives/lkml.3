Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaIAM4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:56:45 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:38240 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaIAMxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:53:48 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: [RFC v2 6/9] VFIO: Extend external user API
Date: Mon,  1 Sep 2014 14:52:45 +0200
Message-Id: <1409575968-5329-7-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New functions are added to be called from ARM KVM-VFIO device.

- vfio_device_get_external_user enables to get a vfio device from
  its fd
- vfio_device_put_external_user puts the vfio device
- vfio_external_base_device returns the struct device*,
  useful to access the platform_device

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:

- vfio_external_get_base_device renamed into vfio_external_base_device
- vfio_external_get_type removed
---
 drivers/vfio/vfio.c  | 24 ++++++++++++++++++++++++
 include/linux/vfio.h |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 8e84471..282814e 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1401,6 +1401,30 @@ void vfio_group_put_external_user(struct vfio_group *group)
 }
 EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
 
+struct vfio_device *vfio_device_get_external_user(struct file *filep)
+{
+	struct vfio_device *vdev = filep->private_data;
+
+	if (filep->f_op != &vfio_device_fops)
+		return ERR_PTR(-EINVAL);
+
+	vfio_device_get(vdev);
+	return vdev;
+}
+EXPORT_SYMBOL_GPL(vfio_device_get_external_user);
+
+void vfio_device_put_external_user(struct vfio_device *vdev)
+{
+	vfio_device_put(vdev);
+}
+EXPORT_SYMBOL_GPL(vfio_device_put_external_user);
+
+struct device *vfio_external_base_device(struct vfio_device *vdev)
+{
+	return vdev->dev;
+}
+EXPORT_SYMBOL_GPL(vfio_external_base_device);
+
 int vfio_external_user_iommu_id(struct vfio_group *group)
 {
 	return iommu_group_id(group->iommu_group);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ffe04ed..bd4b6cb 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -99,6 +99,9 @@ extern void vfio_group_put_external_user(struct vfio_group *group);
 extern int vfio_external_user_iommu_id(struct vfio_group *group);
 extern long vfio_external_check_extension(struct vfio_group *group,
 					  unsigned long arg);
+extern struct vfio_device *vfio_device_get_external_user(struct file *filep);
+extern void vfio_device_put_external_user(struct vfio_device *vdev);
+extern struct device *vfio_external_base_device(struct vfio_device *vdev);
 
 struct pci_dev;
 #ifdef CONFIG_EEH
-- 
1.9.1

