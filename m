Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab3LKVAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:00:16 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58135 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3LKVAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:00:10 -0500
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, a.rigo@virtualopensystems.com,
        B08248@freescale.com, kim.phillips@linaro.org,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvm@vger.kernel.org (open list:VFIO DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5/9] VFIO_PLATFORM: Read and write support for the device fd
Date: Wed, 11 Dec 2013 21:58:29 +0100
Message-Id: <1386795513-32426-6-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1386795513-32426-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO returns a file descriptor which we can use to manipulate the memory
regions of the device. Since some memory regions we cannot mmap due to
security concerns, we also allow to read and write to this file descriptor
directly.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
Tested-by: Alvise Rigo <a.rigo@virtualopensystems.com>
---
 drivers/vfio/platform/vfio_platform.c | 128 +++++++++++++++++++++++++++++++++-
 1 file changed, 125 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 4b402ea..d0b2941 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -55,7 +55,8 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 
 		region.addr = res->start;
 		region.size = resource_size(res);
-		region.flags = 0;
+		region.flags = VFIO_REGION_INFO_FLAG_READ
+				| VFIO_REGION_INFO_FLAG_WRITE;
 
 		vdev->region[i] = region;
 	}
@@ -150,13 +151,134 @@ static long vfio_platform_ioctl(void *device_data,
 static ssize_t vfio_platform_read(void *device_data, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
-	return 0;
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int *io;
+	int i;
+
+	for (i = 0; i < vdev->num_regions; i++) {
+		struct vfio_platform_region region = vdev->region[i];
+		unsigned int done = 0;
+		loff_t off;
+
+		if ((*ppos < region.addr)
+		     || (*ppos + count - 1) >= (region.addr + region.size))
+			continue;
+
+		io = ioremap_nocache(region.addr, region.size);
+
+		off = *ppos - region.addr;
+
+		while (count) {
+			size_t filled;
+
+			if (count >= 4 && !(off % 4)) {
+				u32 val;
+
+				val = ioread32(io + off);
+				if (copy_to_user(buf, &val, 4))
+					goto err;
+
+				filled = 4;
+			} else if (count >= 2 && !(off % 2)) {
+				u16 val;
+
+				val = ioread16(io + off);
+				if (copy_to_user(buf, &val, 2))
+					goto err;
+
+				filled = 2;
+			} else {
+				u8 val;
+
+				val = ioread8(io + off);
+				if (copy_to_user(buf, &val, 1))
+					goto err;
+
+				filled = 1;
+			}
+
+
+			count -= filled;
+			done += filled;
+			off += filled;
+			buf += filled;
+		}
+
+		iounmap(io);
+		return done;
+	}
+
+	return -EFAULT;
+
+err:
+	iounmap(io);
+	return -EFAULT;
 }
 
 static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	return 0;
+	struct vfio_platform_device *vdev = device_data;
+	unsigned int *io;
+	int i;
+
+	for (i = 0; i < vdev->num_regions; i++) {
+		struct vfio_platform_region region = vdev->region[i];
+		unsigned int done = 0;
+		loff_t off;
+
+		if ((*ppos < region.addr)
+		     || (*ppos + count - 1) >= (region.addr + region.size))
+			continue;
+
+		io = ioremap_nocache(region.addr, region.size);
+
+		off = *ppos - region.addr;
+
+		while (count) {
+			size_t filled;
+
+			if (count >= 4 && !(off % 4)) {
+				u32 val;
+
+				if (copy_from_user(&val, buf, 4))
+					goto err;
+				iowrite32(val, io + off);
+
+				filled = 4;
+			} else if (count >= 2 && !(off % 2)) {
+				u16 val;
+
+				if (copy_from_user(&val, buf, 2))
+					goto err;
+				iowrite16(val, io + off);
+
+				filled = 2;
+			} else {
+				u8 val;
+
+				if (copy_from_user(&val, buf, 1))
+					goto err;
+				iowrite8(val, io + off);
+
+				filled = 1;
+			}
+
+			count -= filled;
+			done += filled;
+			off += filled;
+			buf += filled;
+		}
+
+		iounmap(io);
+		return done;
+	}
+
+	return -EINVAL;
+
+err:
+	iounmap(io);
+	return -EFAULT;
 }
 
 static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
-- 
1.8.3.2

