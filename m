Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaKWShp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:37:45 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49572 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaKWShm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:37:42 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, agraf@suse.de
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: [PATCH v3 5/8] VFIO: External user API device helpers
Date: Sun, 23 Nov 2014 19:35:57 +0100
Message-Id: <1416767760-14487-6-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VFIO external user API is enriched with 3 new functions that
allows a kernel user external to VFIO to retrieve some information
from a VFIO device.

- vfio_device_get_external_user enables to get a vfio device from
  its fd and increments its reference counter
- vfio_device_put_external_user decrements the reference counter
- vfio_external_base_device returns a handle to the struct device

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- reword the commit message

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
index 2fb2e30..08e33ec 100644
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

