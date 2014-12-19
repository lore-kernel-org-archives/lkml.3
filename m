Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaLSVVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 16:21:39 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55218 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaLSVVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 16:21:36 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: kvmarm@lists.cs.columbia.edu, iommu@lists.linux-foundation.org,
        alex.williamson@redhat.com
Cc: tech@virtualopensystems.com, christoffer.dall@linaro.org,
        eric.auger@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v3 3/3] vfio: platform: return device properties as arrays of unsigned integers
Date: Fri, 19 Dec 2014 22:20:31 +0100
Message-Id: <1419024032-1269-4-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1419024032-1269-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain properties of a device are accessible as an array of unsigned
integers, either u64, u32, u16, or u8. Let the VFIO user query this
type of device properties.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/vfio/platform/properties.c | 62 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/properties.c b/drivers/vfio/platform/properties.c
index 39c6342..645f6e5c 100644
--- a/drivers/vfio/platform/properties.c
+++ b/drivers/vfio/platform/properties.c
@@ -55,7 +55,67 @@ static int dev_property_get_uint(struct device *dev, char *name,
 				 uint32_t type, unsigned *lenp,
 				 void __user *datap, unsigned long datasz)
 {
-	return -EINVAL;
+	int ret, n;
+	u8 *out;
+	size_t sz;
+	int (*func)(const struct device *, const char *, void *, size_t)
+		= NULL;
+
+	switch (type) {
+	case VFIO_DEV_PROPERTY_TYPE_U64:
+		sz = sizeof(u64);
+		func = (int (*)(const struct device *,
+				const char *, void *, size_t))
+			device_property_read_u64_array;
+		break;
+	case VFIO_DEV_PROPERTY_TYPE_U32:
+		sz = sizeof(u32);
+		func = (int (*)(const struct device *,
+				const char *, void *, size_t))
+			device_property_read_u32_array;
+		break;
+	case VFIO_DEV_PROPERTY_TYPE_U16:
+		sz = sizeof(u16);
+		func = (int (*)(const struct device *,
+				const char *, void *, size_t))
+			device_property_read_u16_array;
+		break;
+	case VFIO_DEV_PROPERTY_TYPE_U8:
+		sz = sizeof(u8);
+		func = (int (*)(const struct device *,
+				const char *, void *, size_t))
+			device_property_read_u8_array;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/* get size of array */
+	n = func(dev, name, NULL, 0);
+	if (n < 0)
+		return n;
+
+	if (lenp)
+		*lenp = n * sz;
+
+	if (n * sz > datasz)
+		return -EOVERFLOW;
+
+	out = kcalloc(n, sz, GFP_KERNEL);
+	if (!out)
+		return -EFAULT;
+
+	ret = func(dev, name, out, n);
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
 
 int vfio_platform_dev_properties(struct device *dev,
-- 
2.1.3

