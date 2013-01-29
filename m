Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab3A2U4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:56:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3A2Uz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:55:58 -0500
Subject: [PATCH v2] vfio-pci: Add support for VGA region access
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: vijaymohan.pandarathil@hp.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 29 Jan 2013 13:55:56 -0700
Message-ID: <20130129204219.5769.6102.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI defines display class VGA regions at I/O port address 0x3b0, 0x3c0
and MMIO address 0xa0000.  As these are non-overlapping, we can ignore
the I/O port vs MMIO difference and expose them both in a single
region.  We make use of the VGA arbiter around each access to
configure chipset access as necessary.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2: Revise the region access based on VFIO AER discussion.  We don't
need to add flags for everything or over-engineer generic legacy
resources.  GET_REGION_INFO.num_regions should return the the highest
index, as the documentation specifies, not a count.  Thus we always
return VFIO_PCI_NUM_REGIONS and userspace can probe for interesting
things within that.  The existence of VFIO_PCI_VGA_REGION_INDEX
therefore indicates the presense of PCI VGA support and due to the VGA
I/O port and MMIO being non-overlapping, we can expose them in a
single region.

VFIO PCI AER can follow this lead for an IRQ and region for describing
AER events and data with VFIO_PCI_AER_IRQ_INDEX and
VFIO_PCI_AER_REGION_INDEX.

 drivers/vfio/pci/Kconfig            |   10 ++++++
 drivers/vfio/pci/vfio_pci.c         |   18 ++++++++++
 drivers/vfio/pci/vfio_pci_private.h |    4 ++
 drivers/vfio/pci/vfio_pci_rdwr.c    |   61 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h           |    9 +++++
 5 files changed, 102 insertions(+)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 5980758..e84300b 100644
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
+	  Support for VGA extension to VFIO PCI.  This exposes an additional
+	  region on VGA devices for accessing legacy VGA addresses used by
+	  BIOS and generic video drivers.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index bb8c8c2..8189cb6 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -84,6 +84,11 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	} else
 		vdev->msix_bar = 0xFF;
 
+#ifdef CONFIG_VFIO_PCI_VGA
+	if ((pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
+		vdev->has_vga = true;
+#endif
+
 	return 0;
 }
 
@@ -285,6 +290,16 @@ static long vfio_pci_ioctl(void *device_data,
 			info.flags = VFIO_REGION_INFO_FLAG_READ;
 			break;
 		}
+		case VFIO_PCI_VGA_REGION_INDEX:
+			if (!vdev->has_vga)
+				return -EINVAL;
+
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+			info.size = 0xc0000;
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+				     VFIO_REGION_INFO_FLAG_WRITE;
+
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -386,6 +401,9 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 
 	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
 		return vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
+
+	case VFIO_PCI_VGA_REGION_INDEX:
+		return vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
 	}
 
 	return -EINVAL;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 00d19b9..d7e55d0 100644
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
@@ -77,6 +78,9 @@ extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
 extern ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
 
+extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite);
+
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e9d78eb..210db24 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
+#include <linux/vgaarb.h>
 
 #include "vfio_pci_private.h"
 
@@ -175,3 +176,63 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 
 	return done;
 }
+
+ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite)
+{
+	int ret;
+	loff_t off, pos = *ppos & VFIO_PCI_OFFSET_MASK;
+	void __iomem *iomem = NULL;
+	unsigned int rsrc;
+	bool is_ioport;
+	ssize_t done;
+
+	if (!vdev->has_vga)
+		return -EINVAL;
+
+	switch (pos) {
+	case 0xa0000 ... 0xbffff:
+		count = min(count, (size_t)(0xc0000 - pos));
+		iomem = ioremap_nocache(0xa0000, 0xbffff - 0xa0000 + 1);
+		off = pos - 0xa0000;
+		rsrc = VGA_RSRC_LEGACY_MEM;
+		is_ioport = false;
+		break;
+	case 0x3b0 ... 0x3bb:
+		count = min(count, (size_t)(0x3bc - pos));
+		iomem = ioport_map(0x3b0, 0x3bb - 0x3b0 + 1);
+		off = pos - 0x3b0;
+		rsrc = VGA_RSRC_LEGACY_IO;
+		is_ioport = true;
+		break;
+	case 0x3c0 ... 0x3df:
+		count = min(count, (size_t)(0x3e0 - pos));
+		iomem = ioport_map(0x3c0, 0x3df - 0x3c0 + 1);
+		off = pos - 0x3c0;
+		rsrc = VGA_RSRC_LEGACY_IO;
+		is_ioport = true;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!iomem)
+		return -ENOMEM;
+
+	ret = vga_get_interruptible(vdev->pdev, rsrc);
+	if (ret) {
+		is_ioport ? ioport_unmap(iomem) : iounmap(iomem);
+		return ret;
+	}
+
+	done = do_io_rw(iomem, buf, off, count, 0, 0, iswrite);
+
+	vga_put(vdev->pdev, rsrc);
+
+	is_ioport ? ioport_unmap(iomem) : iounmap(iomem);
+
+	if (done >= 0)
+		*ppos += done;
+
+	return done;
+}
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4758d1b..4f41f30 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -303,6 +303,15 @@ enum {
 	VFIO_PCI_BAR5_REGION_INDEX,
 	VFIO_PCI_ROM_REGION_INDEX,
 	VFIO_PCI_CONFIG_REGION_INDEX,
+	/*
+	 * Expose VGA regions defined for PCI base class 03, subclass 00.
+	 * This includes I/O port ranges 0x3b0 to 0x3bb and 0x3c0 to 0x3df
+	 * as well as the MMIO range 0xa0000 to 0xbffff.  Each implemented
+	 * range is found at it's identity mapped offset from the region
+	 * offset, for example 0x3b0 is region_info.offset + 0x3b0.  Areas
+	 * between described ranges are unimplemented.
+	 */
+	VFIO_PCI_VGA_REGION_INDEX,
 	VFIO_PCI_NUM_REGIONS
 };
 

