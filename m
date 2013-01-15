Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3AOEIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:08:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3AOEIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:08:15 -0500
Subject: [RFC PATCH 3/3] vfio-pci: Add support for legacy MMIO & I/O port
 towards VGA support
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, david@gibson.dropbear.id.au
Date: Mon, 14 Jan 2013 20:39:57 -0700
Message-ID: <20130115033914.6894.39067.stgit@bling.home>
In-Reply-To: <20130115033101.6894.50292.stgit@bling.home>
References: <20130115033101.6894.50292.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create two new legacy regions, one for MMIO space below 1MB and
another for 64k of I/O port space.  For devices of PCI class VGA
these ranges will be exposed and allow direct access to the device
at the PCI defined VGA addresses, 0xa0000, 0x3b0, 0x3c0.  VFIO
makes use of the host VGA arbiter to manage host chipset config
to route each access to the correct device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/Kconfig            |   10 ++++
 drivers/vfio/pci/vfio_pci.c         |   49 ++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |    9 ++++
 drivers/vfio/pci/vfio_pci_rdwr.c    |   85 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h           |    8 +++
 5 files changed, 160 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 5980758..559d807 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -6,3 +6,13 @@ config VFIO_PCI
 	  use of PCI drivers using the VFIO framework.
 
 	  If you don't know what to do here, say N.
+
+config VFIO_PCI_VGA
+	bool "VFIO PCI support for VGA devices"
+	depends on VFIO_PCI && X86 && VGA_ARB && EXPERIMENTAL
+	help
+	  Support for VGA extensions to VFIO PCI.  This exposes additional
+	  regions on VGA devices for accessing legacy VGA addresses used
+	  by BIOS and generic video drivers.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 781f900..61346bc 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -81,6 +81,11 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	if (ret)
 		goto out;
 
+#ifdef CONFIG_VFIO_PCI_VGA
+	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
+		vdev->has_vga = true;
+#endif
+
 	return ret;
 
 out:
@@ -193,6 +198,7 @@ static long vfio_pci_ioctl(void *device_data,
 
 	if (cmd == VFIO_DEVICE_GET_INFO) {
 		struct vfio_device_info info;
+		bool legacy_io = false, legacy_mem = false;
 
 		minsz = offsetofend(struct vfio_device_info, num_irqs);
 
@@ -207,9 +213,24 @@ static long vfio_pci_ioctl(void *device_data,
 		if (vdev->reset_works)
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
-		info.num_regions = VFIO_PCI_NUM_REGIONS;
+		info.num_regions = VFIO_PCI_CONFIG_REGION_INDEX + 1;
 		info.num_irqs = VFIO_PCI_NUM_IRQS;
 
+		if (vdev->has_vga) {
+			info.flags |= VFIO_DEVICE_FLAGS_PCI_VGA;
+			legacy_io = legacy_mem = true;
+		}
+
+		if (legacy_io) {
+			info.flags |= VFIO_DEVICE_FLAGS_PCI_LEGACY_IOPORT;
+			info.num_regions++;
+		}
+
+		if (legacy_mem) {
+			info.flags |= VFIO_DEVICE_FLAGS_PCI_LEGACY_MMIO;
+			info.num_regions++;
+		}
+
 		return copy_to_user((void __user *)arg, &info, minsz);
 
 	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
@@ -269,6 +290,26 @@ static long vfio_pci_ioctl(void *device_data,
 			info.flags = VFIO_REGION_INFO_FLAG_READ;
 			break;
 		}
+		case VFIO_PCI_LEGACY_MMIO_REGION_INDEX:
+			if (!vdev->has_vga)
+				return -EINVAL;
+
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 1024 * 1024;
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+				     VFIO_REGION_INFO_FLAG_WRITE;
+
+			break;
+		case VFIO_PCI_LEGACY_IOPORT_REGION_INDEX:
+			if (!vdev->has_vga)
+				return -EINVAL;
+
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 64 * 1024;
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+				     VFIO_REGION_INFO_FLAG_WRITE;
+
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -375,6 +416,12 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 
 	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
 		return vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
+
+	case VFIO_PCI_LEGACY_MMIO_REGION_INDEX:
+		return vfio_pci_legacy_mem_rw(vdev, buf, count, ppos, iswrite);
+
+	case VFIO_PCI_LEGACY_IOPORT_REGION_INDEX:
+		return vfio_pci_legacy_io_rw(vdev, buf, count, ppos, iswrite);
 	}
 
 	return -EINVAL;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 00d19b9..453ea69 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -53,6 +53,7 @@ struct vfio_pci_device {
 	bool			reset_works;
 	bool			extended_caps;
 	bool			bardirty;
+	bool			has_vga;
 	struct pci_saved_state	*pci_saved_state;
 	atomic_t		refcnt;
 };
@@ -77,6 +78,14 @@ extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
 extern ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
 
+extern ssize_t vfio_pci_legacy_mem_rw(struct vfio_pci_device *vdev,
+				      char __user *buf, size_t count,
+				      loff_t *ppos, bool iswrite);
+
+extern ssize_t vfio_pci_legacy_io_rw(struct vfio_pci_device *vdev,
+				     char __user *buf, size_t count,
+				     loff_t *ppos, bool iswrite);
+
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index cdb13a9..a24ad94 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/vgaarb.h>
 
 #include "vfio_pci_private.h"
 
@@ -174,3 +175,87 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 
 	return done;
 }
+
+ssize_t vfio_pci_legacy_mem_rw(struct vfio_pci_device *vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite)
+{
+	int ret;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (vdev->has_vga && pos >= 0xa0000 && pos < 0xc0000) {
+		void __iomem *mem;
+		size_t done;
+
+		count = min(count, (size_t)(0xc0000 - pos));
+
+		mem = ioremap_nocache(0xa0000, 0xc0000 - 0xa0000);
+		if (!mem)
+			return -ENOMEM;
+
+		ret = vga_get_interruptible(vdev->pdev, VGA_RSRC_LEGACY_MEM);
+		if (ret) {
+			iounmap(mem);
+			return ret;
+		}
+
+		done = do_io_rw(mem, buf, pos - 0xa0000, count, 0, 0, iswrite);
+
+		vga_put(vdev->pdev, VGA_RSRC_LEGACY_MEM);
+		iounmap(mem);
+
+		if (done >= 0)
+			*ppos += done;
+
+		return done;
+	}
+
+	return -EINVAL;
+}
+
+ssize_t vfio_pci_legacy_io_rw(struct vfio_pci_device *vdev, char __user *buf,
+			      size_t count, loff_t *ppos, bool iswrite)
+{
+	int ret;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (vdev->has_vga &&
+	    ((pos >= 0x3b0 && pos < 0x3bc) || (pos >= 0x3c0 && pos < 0x3e0))) {
+		void __iomem *io = NULL;
+		loff_t off;
+		size_t done;
+
+		switch (pos) {
+		case 0x3b0 ... 0x3bb:
+			count = min(count, (size_t)(0x3bc - pos));
+			io = ioport_map(0x3b0, 0x3bc - 0x3b0);
+			off = pos - 0x3b0;
+			break;
+		case 0x3c0 ... 0x3df:
+			count = min(count, (size_t)(0x3e0 - pos));
+			io = ioport_map(0x3c0, 0x3e0 - 0x3c0);
+			off = pos - 0x3c0;
+			break;
+		}
+
+		if (!io)
+			return -ENOMEM;
+
+		ret = vga_get_interruptible(vdev->pdev, VGA_RSRC_LEGACY_IO);
+		if (ret) {
+			ioport_unmap(io);
+			return ret;
+		}
+
+		done = do_io_rw(io, buf, off, count, 0, 0, iswrite);
+
+		vga_put(vdev->pdev, VGA_RSRC_LEGACY_IO);
+		ioport_unmap(io);
+
+		if (done >= 0)
+			*ppos += done;
+
+		return done;
+	}
+
+	return -EINVAL;
+}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4758d1b..19a90c0 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -147,6 +147,12 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+/* Legacy MMIO 0x0 - 0xfffff via VFIO_PCI_LEGACY_MMIO_REGION_INDEX */
+#define VFIO_DEVICE_FLAGS_PCI_LEGACY_MMIO	(1 << 2)
+/* Legacy I/O Port 0x0 - 0xffff via VFIO_PCI_LEGACY_IOPORT_REGION_INDEX */
+#define VFIO_DEVICE_FLAGS_PCI_LEGACY_IOPORT	(1 << 3)
+/* Supports VGA regions 0xa0000-0xbffff, 0x3b0-0x3bb, and 0x3c0-0x3df */
+#define VFIO_DEVICE_FLAGS_PCI_VGA		(1 << 4)
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
@@ -303,6 +309,8 @@ enum {
 	VFIO_PCI_BAR5_REGION_INDEX,
 	VFIO_PCI_ROM_REGION_INDEX,
 	VFIO_PCI_CONFIG_REGION_INDEX,
+	VFIO_PCI_LEGACY_MMIO_REGION_INDEX,
+	VFIO_PCI_LEGACY_IOPORT_REGION_INDEX,
 	VFIO_PCI_NUM_REGIONS
 };
 

