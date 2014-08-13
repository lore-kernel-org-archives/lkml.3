Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaHMLGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:06:18 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:49254 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaHMLFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:05:31 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, stuart.yoder@freescale.com,
        eric.auger@linaro.org, marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/4] VFIO: PLATFORM: DEVTREE: Return available property names
Date: Wed, 13 Aug 2014 13:02:17 +0200
Message-Id: <1407927740-14993-3-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407927740-14993-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1407927740-14993-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For various reasons, the available properties of the platform device
node in the device tree node should be referred to by the property name.
Passing type = VFIO_DEVTREE_PROP_NAMES to VFIO_DEVICE_GET_DEVTREE_INFO,
returns a list of strings with the available properties that the VFIO
user can access.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/devtree.c | 68 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/devtree.c b/drivers/vfio/platform/devtree.c
index 91cab88..b8fd4138 100644
--- a/drivers/vfio/platform/devtree.c
+++ b/drivers/vfio/platform/devtree.c
@@ -20,8 +20,74 @@ bool vfio_platform_has_devtree(struct vfio_platform_device *vdev)
 	return !!vdev->of_node;
 }
 
+static int devtree_get_prop_names(struct device_node *np, void __user *datap,
+				  unsigned long datasz, int *lenp)
+{
+	struct property *prop;
+	int len = 0, sz;
+	int ret = 0;
+
+	for_each_property_of_node(np, prop) {
+		sz = strlen(prop->name) + 1;
+
+		if (datasz < sz) {
+			ret = -EAGAIN;
+			break;
+		}
+
+		if (copy_to_user(datap, prop->name, sz))
+			return -EFAULT;
+
+		datap += sz;
+		datasz -= sz;
+		len += sz;
+	}
+
+	/* if overflow occurs, calculate remaining length */
+	while (prop) {
+		len += strlen(prop->name) + 1;
+		prop = prop->next;
+	}
+
+	/* we expose the full_name in addition to the usual properties */
+	len += sz = strlen("full_name") + 1;
+	if (datasz < sz) {
+		ret = -EAGAIN;
+	} else if (copy_to_user(datap, "full_name", sz))
+		return -EFAULT;
+
+	*lenp = len;
+
+	return ret;
+}
+
 long vfio_platform_devtree_ioctl(struct vfio_platform_device *vdev,
 				 unsigned long arg)
 {
-	return -EINVAL; /* not implemented yet */
+	struct vfio_devtree_info info;
+	unsigned long minsz = offsetofend(struct vfio_devtree_info, length);
+	void __user *datap = (void __user *) arg + minsz;
+	unsigned long int datasz;
+	int ret = -EINVAL;
+
+	if (!vfio_platform_has_devtree(vdev))
+		return -EINVAL;
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	datasz = info.argsz - minsz;
+
+	if (info.type == VFIO_DEVTREE_PROP_NAMES) {
+		ret = devtree_get_prop_names(vdev->of_node, datap, datasz,
+								&info.length);
+	}
+
+	if (copy_to_user((void __user *)arg, &info, minsz))
+		ret = -EFAULT;
+
+	return ret;
 }
-- 
1.8.3.2

