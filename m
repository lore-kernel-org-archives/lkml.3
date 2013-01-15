Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab3AODjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:39:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456Ab3AODjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:39:14 -0500
Subject: [PATCH 2/3] vfio-pci: Cleanup BAR access
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, david@gibson.dropbear.id.au
Date: Mon, 14 Jan 2013 20:39:08 -0700
Message-ID: <20130115033849.6894.8787.stgit@bling.home>
In-Reply-To: <20130115033101.6894.50292.stgit@bling.home>
References: <20130115033101.6894.50292.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can actually handle MMIO and I/O port from the same access function
since PCI already does abstraction of this.  The ROM BAR only requires
a minor difference, so it gets included too.  vfio_pci_config_readwrite
gets renamed for consistency.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c         |   26 ++--
 drivers/vfio/pci/vfio_pci_config.c  |    5 -
 drivers/vfio/pci/vfio_pci_private.h |   15 +-
 drivers/vfio/pci/vfio_pci_rdwr.c    |  231 ++++++++++-------------------------
 4 files changed, 88 insertions(+), 189 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 27f7665..781f900 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -360,31 +360,21 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	struct vfio_pci_device *vdev = device_data;
-	struct pci_dev *pdev = vdev->pdev;
 
 	if (index >= VFIO_PCI_NUM_REGIONS)
 		return -EINVAL;
 
 	switch (index) {
 	case VFIO_PCI_CONFIG_REGION_INDEX:
-		return vfio_pci_config_readwrite(vdev, buf, count,
-						 ppos, iswrite);
+		return vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
+
 	case VFIO_PCI_ROM_REGION_INDEX:
 		if (iswrite)
 			return -EINVAL;
-		return vfio_pci_mem_readwrite(vdev, buf, count, ppos, false);
+		return vfio_pci_bar_rw(vdev, buf, count, ppos, false);
 
 	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
-	{
-		unsigned long flags = pci_resource_flags(pdev, index);
-
-		if (flags & IORESOURCE_IO)
-			return vfio_pci_io_readwrite(vdev, buf, count,
-						     ppos, iswrite);
-		if (flags & IORESOURCE_MEM)
-			return vfio_pci_mem_readwrite(vdev, buf, count,
-						      ppos, iswrite);
-	}
+		return vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
 	}
 
 	return -EINVAL;
@@ -393,13 +383,19 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 static ssize_t vfio_pci_read(void *device_data, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
+	if (!count)
+		return 0;
+
 	return vfio_pci_rw(device_data, buf, count, ppos, false);
 }
 
 static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	return vfio_pci_rw(device_data, buf, count, ppos, true);
+	if (!count)
+		return 0;
+
+	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
 
 static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 8b8f7d1..6985149 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1501,9 +1501,8 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return ret;
 }
 
-ssize_t vfio_pci_config_readwrite(struct vfio_pci_device *vdev,
-				  char __user *buf, size_t count,
-				  loff_t *ppos, bool iswrite)
+ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev, char __user *buf,
+			   size_t count, loff_t *ppos, bool iswrite)
 {
 	size_t done = 0;
 	int ret = 0;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 611827c..00d19b9 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -70,15 +70,12 @@ extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
 				   uint32_t flags, unsigned index,
 				   unsigned start, unsigned count, void *data);
 
-extern ssize_t vfio_pci_config_readwrite(struct vfio_pci_device *vdev,
-					 char __user *buf, size_t count,
-					 loff_t *ppos, bool iswrite);
-extern ssize_t vfio_pci_mem_readwrite(struct vfio_pci_device *vdev,
-				      char __user *buf, size_t count,
-				      loff_t *ppos, bool iswrite);
-extern ssize_t vfio_pci_io_readwrite(struct vfio_pci_device *vdev,
-				     char __user *buf, size_t count,
-				     loff_t *ppos, bool iswrite);
+extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
+				  char __user *buf, size_t count,
+				  loff_t *ppos, bool iswrite);
+
+extern ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite);
 
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index f72323e..cdb13a9 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -20,250 +20,157 @@
 
 #include "vfio_pci_private.h"
 
-/* I/O Port BAR access */
-ssize_t vfio_pci_io_readwrite(struct vfio_pci_device *vdev, char __user *buf,
-			      size_t count, loff_t *ppos, bool iswrite)
+/*
+ * Read or write from an __iomem region (MMIO or I/O port) with an excluded
+ * range which is inaccessible.  The excluded range drops writes and fills
+ * reads with -1.  This is intended for handling MSI-X vector tables and
+ * leftover space for ROM BARs.
+ */
+static size_t do_io_rw(void __iomem *io, char __user *buf, loff_t off,
+		       size_t count, size_t x_start, size_t x_end, bool iswrite)
 {
-	struct pci_dev *pdev = vdev->pdev;
-	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-	int bar = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	void __iomem *io;
 	size_t done = 0;
 
-	if (!pci_resource_start(pdev, bar))
-		return -EINVAL;
-
-	if (pos + count > pci_resource_len(pdev, bar))
-		return -EINVAL;
-
-	if (!vdev->barmap[bar]) {
-		int ret;
-
-		ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
-		if (ret)
-			return ret;
-
-		vdev->barmap[bar] = pci_iomap(pdev, bar, 0);
-
-		if (!vdev->barmap[bar]) {
-			pci_release_selected_regions(pdev, 1 << bar);
-			return -EINVAL;
-		}
-	}
-
-	io = vdev->barmap[bar];
-
 	while (count) {
-		int filled;
+		size_t fillable, filled;
+
+		if (off < x_start)
+			fillable = min(count, (size_t)(x_start - off));
+		else if (off >= x_end)
+			fillable = count;
+		else
+			fillable = 0;
 
-		if (count >= 3 && !(pos % 4)) {
+		if (fillable >= 4 && !(off % 4)) {
 			__le32 val;
 
 			if (iswrite) {
 				if (copy_from_user(&val, buf, 4))
 					return -EFAULT;
 
-				iowrite32(le32_to_cpu(val), io + pos);
+				iowrite32(le32_to_cpu(val), io + off);
 			} else {
-				val = cpu_to_le32(ioread32(io + pos));
+				val = cpu_to_le32(ioread32(io + off));
 
 				if (copy_to_user(buf, &val, 4))
 					return -EFAULT;
 			}
 
 			filled = 4;
-
-		} else if ((pos % 2) == 0 && count >= 2) {
+		} else if (fillable >= 2 && !(off % 2)) {
 			__le16 val;
 
 			if (iswrite) {
 				if (copy_from_user(&val, buf, 2))
 					return -EFAULT;
 
-				iowrite16(le16_to_cpu(val), io + pos);
+				iowrite16(le16_to_cpu(val), io + off);
 			} else {
-				val = cpu_to_le16(ioread16(io + pos));
+				val = cpu_to_le16(ioread16(io + off));
 
 				if (copy_to_user(buf, &val, 2))
 					return -EFAULT;
 			}
 
 			filled = 2;
-		} else {
+		} else if (fillable) {
 			u8 val;
 
 			if (iswrite) {
 				if (copy_from_user(&val, buf, 1))
 					return -EFAULT;
 
-				iowrite8(val, io + pos);
+				iowrite8(val, io + off);
 			} else {
-				val = ioread8(io + pos);
+				val = ioread8(io + off);
 
 				if (copy_to_user(buf, &val, 1))
 					return -EFAULT;
 			}
 
 			filled = 1;
+		} else {
+			/* Fill reads with -1, drop writes */
+			filled = min(count, (size_t)(x_end - off));
+			if (!iswrite) {
+				u8 val = 0xFF;
+				size_t i;
+
+				for (i = 0; i < filled; i++)
+					if (copy_to_user(buf + i, &val, 1))
+						return -EFAULT;
+			}
 		}
 
 		count -= filled;
 		done += filled;
+		off += filled;
 		buf += filled;
-		pos += filled;
 	}
 
-	*ppos += done;
-
 	return done;
 }
 
-/*
- * MMIO BAR access
- * We handle two excluded ranges here as well, if the user tries to read
- * the ROM beyond what PCI tells us is available or the MSI-X table region,
- * we return 0xFF and writes are dropped.
- */
-ssize_t vfio_pci_mem_readwrite(struct vfio_pci_device *vdev, char __user *buf,
-			       size_t count, loff_t *ppos, bool iswrite)
+ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
+			size_t count, loff_t *ppos, bool iswrite)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	int bar = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	void __iomem *io;
+	size_t x_start = 0, x_end = 0;
 	resource_size_t end;
-	size_t done = 0;
-	size_t x_start = 0, x_end = 0; /* excluded range */
+	void __iomem *io;
+	size_t done;
 
 	if (!pci_resource_start(pdev, bar))
 		return -EINVAL;
 
 	end = pci_resource_len(pdev, bar);
 
-	if (pos > end)
+	if (pos >= end)
 		return -EINVAL;
 
-	if (pos == end)
-		return 0;
-
-	if (pos + count > end)
-		count = end - pos;
+	count = min(count, (size_t)(end - pos));
 
 	if (bar == PCI_ROM_RESOURCE) {
+		/*
+		 * The ROM can fill less space than the BAR, so we start the
+		 * excluded range at the end of the actual ROM.  This makes
+		 * filling large ROM BARs much faster.
+		 */
 		io = pci_map_rom(pdev, &x_start);
+		if (!io)
+			return -ENOMEM;
 		x_end = end;
-	} else {
-		if (!vdev->barmap[bar]) {
-			int ret;
-
-			ret = pci_request_selected_regions(pdev, 1 << bar,
-							   "vfio");
-			if (ret)
-				return ret;
+	} else if (!vdev->barmap[bar]) {
+		int ret;
 
-			vdev->barmap[bar] = pci_iomap(pdev, bar, 0);
+		ret = pci_request_selected_regions(pdev, 1 << bar, "vfio");
+		if (ret)
+			return ret;
 
-			if (!vdev->barmap[bar]) {
-				pci_release_selected_regions(pdev, 1 << bar);
-				return -EINVAL;
-			}
+		io = pci_iomap(pdev, bar, 0);
+		if (!io) {
+			pci_release_selected_regions(pdev, 1 << bar);
+			return -ENOMEM;
 		}
 
+		vdev->barmap[bar] = io;
+	} else
 		io = vdev->barmap[bar];
 
-		if (bar == vdev->msix_bar) {
-			x_start = vdev->msix_offset;
-			x_end = vdev->msix_offset + vdev->msix_size;
-		}
+	if (bar == vdev->msix_bar) {
+		x_start = vdev->msix_offset;
+		x_end = vdev->msix_offset + vdev->msix_size;
 	}
 
-	if (!io)
-		return -EINVAL;
+	done = do_io_rw(io, buf, pos, count, x_start, x_end, iswrite);
 
-	while (count) {
-		size_t fillable, filled;
+	if (done >= 0)
+		*ppos += done;
 
-		if (pos < x_start)
-			fillable = x_start - pos;
-		else if (pos >= x_end)
-			fillable = end - pos;
-		else
-			fillable = 0;
-
-		if (fillable >= 4 && !(pos % 4) && (count >= 4)) {
-			__le32 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 4))
-					goto out;
-
-				iowrite32(le32_to_cpu(val), io + pos);
-			} else {
-				val = cpu_to_le32(ioread32(io + pos));
-
-				if (copy_to_user(buf, &val, 4))
-					goto out;
-			}
-
-			filled = 4;
-		} else if (fillable >= 2 && !(pos % 2) && (count >= 2)) {
-			__le16 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 2))
-					goto out;
-
-				iowrite16(le16_to_cpu(val), io + pos);
-			} else {
-				val = cpu_to_le16(ioread16(io + pos));
-
-				if (copy_to_user(buf, &val, 2))
-					goto out;
-			}
-
-			filled = 2;
-		} else if (fillable) {
-			u8 val;
-
-			if (iswrite) {
-				if (copy_from_user(&val, buf, 1))
-					goto out;
-
-				iowrite8(val, io + pos);
-			} else {
-				val = ioread8(io + pos);
-
-				if (copy_to_user(buf, &val, 1))
-					goto out;
-			}
-
-			filled = 1;
-		} else {
-			/* Drop writes, fill reads with FF */
-			filled = min((size_t)(x_end - pos), count);
-			if (!iswrite) {
-				char val = 0xFF;
-				size_t i;
-
-				for (i = 0; i < filled; i++) {
-					if (put_user(val, buf + i))
-						goto out;
-				}
-			}
-
-		}
-
-		count -= filled;
-		done += filled;
-		buf += filled;
-		pos += filled;
-	}
-
-	*ppos += done;
-
-out:
 	if (bar == PCI_ROM_RESOURCE)
 		pci_unmap_rom(pdev, io);
 
-	return count ? -EFAULT : done;
+	return done;
 }

