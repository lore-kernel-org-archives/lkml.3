Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3AODiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:38:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319Ab3AODis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:38:48 -0500
Subject: [PATCH 1/3] vfio-pci: Cleanup read/write functions
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, david@gibson.dropbear.id.au
Date: Mon, 14 Jan 2013 20:38:40 -0700
Message-ID: <20130115033826.6894.66515.stgit@bling.home>
In-Reply-To: <20130115033101.6894.50292.stgit@bling.home>
References: <20130115033101.6894.50292.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The read and write functions are nearly identical, combine them
and convert to a switch statement.  This also makes it easy to
narrow the scope of when we use the io/mem accessors in case new
regions are added.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |   59 +++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6c11994..27f7665 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -355,8 +355,8 @@ static long vfio_pci_ioctl(void *device_data,
 	return -ENOTTY;
 }
 
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
-			     size_t count, loff_t *ppos)
+static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
+			   size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
 	struct vfio_pci_device *vdev = device_data;
@@ -365,42 +365,41 @@ static ssize_t vfio_pci_read(void *device_data, char __user *buf,
 	if (index >= VFIO_PCI_NUM_REGIONS)
 		return -EINVAL;
 
-	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
-		return vfio_pci_config_readwrite(vdev, buf, count, ppos, false);
-	else if (index == VFIO_PCI_ROM_REGION_INDEX)
-		return vfio_pci_mem_readwrite(vdev, buf, count, ppos, false);
-	else if (pci_resource_flags(pdev, index) & IORESOURCE_IO)
-		return vfio_pci_io_readwrite(vdev, buf, count, ppos, false);
-	else if (pci_resource_flags(pdev, index) & IORESOURCE_MEM)
+	switch (index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+		return vfio_pci_config_readwrite(vdev, buf, count,
+						 ppos, iswrite);
+	case VFIO_PCI_ROM_REGION_INDEX:
+		if (iswrite)
+			return -EINVAL;
 		return vfio_pci_mem_readwrite(vdev, buf, count, ppos, false);
 
+	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
+	{
+		unsigned long flags = pci_resource_flags(pdev, index);
+
+		if (flags & IORESOURCE_IO)
+			return vfio_pci_io_readwrite(vdev, buf, count,
+						     ppos, iswrite);
+		if (flags & IORESOURCE_MEM)
+			return vfio_pci_mem_readwrite(vdev, buf, count,
+						      ppos, iswrite);
+	}
+	}
+
 	return -EINVAL;
 }
 
+static ssize_t vfio_pci_read(void *device_data, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	return vfio_pci_rw(device_data, buf, count, ppos, false);
+}
+
 static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	struct vfio_pci_device *vdev = device_data;
-	struct pci_dev *pdev = vdev->pdev;
-
-	if (index >= VFIO_PCI_NUM_REGIONS)
-		return -EINVAL;
-
-	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
-		return vfio_pci_config_readwrite(vdev, (char __user *)buf,
-						 count, ppos, true);
-	else if (index == VFIO_PCI_ROM_REGION_INDEX)
-		return -EINVAL;
-	else if (pci_resource_flags(pdev, index) & IORESOURCE_IO)
-		return vfio_pci_io_readwrite(vdev, (char __user *)buf,
-					     count, ppos, true);
-	else if (pci_resource_flags(pdev, index) & IORESOURCE_MEM) {
-		return vfio_pci_mem_readwrite(vdev, (char __user *)buf,
-					      count, ppos, true);
-	}
-
-	return -EINVAL;
+	return vfio_pci_rw(device_data, buf, count, ppos, true);
 }
 
 static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)

