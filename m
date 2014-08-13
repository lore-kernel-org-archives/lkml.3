Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaHMLFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:05:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44411 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaHMLFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:05:41 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/4] VFIO: PLATFORM: DEVTREE: Return arrays of u32, u16, or u8
Date: Wed, 13 Aug 2014 13:02:19 +0200
Message-Id: <1407927740-14993-5-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407927740-14993-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1407927740-14993-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain properties of a device tree node are accessible as an array
of unsigned integers, either u32, u16, or u8. Let the VFIO user query
this type of device node properties.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/devtree.c | 99 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/vfio/platform/devtree.c b/drivers/vfio/platform/devtree.c
index 80c60d4..331cc34 100644
--- a/drivers/vfio/platform/devtree.c
+++ b/drivers/vfio/platform/devtree.c
@@ -98,6 +98,96 @@ static int devtree_get_full_name(struct device_node *np, void __user *datap,
 	return 0;
 }
 
+static int devtree_get_u32_arr(const struct device_node *np, const char *name,
+			       void __user *datap, unsigned long datasz)
+{
+	int ret;
+	int n;
+	u32 *out;
+
+	n = of_property_count_elems_of_size(np, name, sizeof(u32));
+	if (n < 0)
+		return n;
+
+	if (n * sizeof(u32) > datasz)
+		return -EAGAIN;
+
+	out = kcalloc(n, sizeof(u32), GFP_KERNEL);
+	if (!out)
+		return -EFAULT;
+
+	ret = of_property_read_u32_array(np, name, out, n);
+	if (ret)
+		goto out;
+
+	if (copy_to_user(datap, out, n * sizeof(u32)))
+		ret = -EFAULT;
+
+out:
+	kfree(out);
+	return ret;
+}
+
+static int devtree_get_u16_arr(const struct device_node *np, const char *name,
+			       void __user *datap, unsigned long datasz)
+{
+	int ret;
+	int n;
+	u16 *out;
+
+	n = of_property_count_elems_of_size(np, name, sizeof(u16));
+	if (n < 0)
+		return n;
+
+	if (n * sizeof(u16) > datasz)
+		return -EAGAIN;
+
+	out = kcalloc(n, sizeof(u16), GFP_KERNEL);
+	if (!out)
+		return -EFAULT;
+
+	ret = of_property_read_u16_array(np, name, out, n);
+	if (ret)
+		goto out;
+
+	if (copy_to_user(datap, out, n * sizeof(u16)))
+		ret = -EFAULT;
+
+out:
+	kfree(out);
+	return ret;
+}
+
+static int devtree_get_u8_arr(const struct device_node *np, const char *name,
+			       void __user *datap, unsigned long datasz)
+{
+	int ret;
+	int n;
+	u8 *out;
+
+	n = of_property_count_elems_of_size(np, name, sizeof(u8));
+	if (n < 0)
+		return n;
+
+	if (n * sizeof(u8) > datasz)
+		return -EAGAIN;
+
+	out = kcalloc(n, sizeof(u8), GFP_KERNEL);
+	if (!out)
+		return -EFAULT;
+
+	ret = of_property_read_u8_array(np, name, out, n);
+	if (ret)
+		goto out;
+
+	if (copy_to_user(datap, out, n * sizeof(u8)))
+		ret = -EFAULT;
+
+out:
+	kfree(out);
+	return ret;
+}
+
 long vfio_platform_devtree_ioctl(struct vfio_platform_device *vdev,
 				 unsigned long arg)
 {
@@ -143,6 +233,15 @@ long vfio_platform_devtree_ioctl(struct vfio_platform_device *vdev,
 	} else if (info.type == VFIO_DEVTREE_ARR_TYPE_STRING)
 		ret = devtree_get_strings(vdev->of_node, name, datap, datasz);
 
+	else if (info.type == VFIO_DEVTREE_ARR_TYPE_U32)
+		ret = devtree_get_u32_arr(vdev->of_node, name, datap, datasz);
+
+	else if (info.type == VFIO_DEVTREE_ARR_TYPE_U16)
+		ret = devtree_get_u16_arr(vdev->of_node, name, datap, datasz);
+
+	else if (info.type == VFIO_DEVTREE_ARR_TYPE_U8)
+		ret = devtree_get_u8_arr(vdev->of_node, name, datap, datasz);
+
 	kfree(name);
 
 out:
-- 
1.8.3.2

