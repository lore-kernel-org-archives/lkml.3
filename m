Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaJPPzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:55:53 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:65232 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaJPPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:55:51 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: tech@virtualopensystems.com, christoffer.dall@linaro.org,
        eric.auger@linaro.org, kim.phillips@freescale.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v2 4/4] vfio: platform: devtree: return arrays of u32, u16, or u8 data
Date: Thu, 16 Oct 2014 17:54:36 +0200
Message-Id: <1413474876-28544-5-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413474876-28544-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1413474876-28544-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain properties of a device tree node are accessible as an array
of unsigned integers, either u32, u16, or u8. Let the VFIO user query
this type of device node properties. Accessing u64 arrays is not yet
implemented in this RFC.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/devtree.c | 55 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/devtree.c b/drivers/vfio/platform/devtree.c
index 6d25f97..17f55d4 100644
--- a/drivers/vfio/platform/devtree.c
+++ b/drivers/vfio/platform/devtree.c
@@ -97,7 +97,60 @@ static int devtree_get_uint(struct device_node *np, char *name,
 			    uint32_t type, unsigned *lenp,
 			    void __user *datap, unsigned long datasz)
 {
-	return -EINVAL;
+	int ret, n;
+	size_t sz;
+	u8 *out;
+	int (*func)(const struct device_node *, const char *, void *, size_t)
+		= NULL;
+
+	switch (type) {
+	case VFIO_DEVTREE_TYPE_U32:
+		sz = sizeof(u32);
+		func = (int (*)(const struct device_node *,
+				const char *, void *, size_t))
+			of_property_read_u32_array;
+		break;
+	case VFIO_DEVTREE_TYPE_U16:
+		sz = sizeof(u16);
+		func = (int (*)(const struct device_node *,
+				const char *, void *, size_t))
+			of_property_read_u16_array;
+		break;
+	case VFIO_DEVTREE_TYPE_U8:
+		sz = sizeof(u8);
+		func = (int (*)(const struct device_node *,
+				const char *, void *, size_t))
+			of_property_read_u8_array;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	n = of_property_count_elems_of_size(np, name, sz);
+	if (n < 0)
+		return n;
+
+	if (lenp)
+		*lenp = n * sz;
+
+	if (n * sz > datasz)
+		return -EAGAIN;
+
+	out = kcalloc(n, sz, GFP_KERNEL);
+	if (!out)
+		return -EFAULT;
+
+	ret = func(np, name, out, n);
+	if (ret)
+		goto out;
+
+	if (copy_to_user(datap, out, n * sz))
+		ret = -EFAULT;
+
+out:
+	kfree(out);
+	return ret;
 }
 
 int vfio_platform_devtree_info(struct device_node *np,
-- 
2.1.1

