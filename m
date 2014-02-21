Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaBUE7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:59:19 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58830
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbaBUE65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:58:57 -0500
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH v2,2/2] hyperv_fb: Add support for Gen2 VM
Date: Thu, 20 Feb 2014 21:50:11 -0800
Message-Id: <1392961811-11960-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1392961811-11960-1-git-send-email-haiyangz@microsoft.com>
References: <1392961811-11960-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables Hyper-V FB driver to run on Gen2 VM.

The Gen2 VM provides MMIO area for synthetic video from ACPI module,
which is exported by vmbus. The generic video is provided by UEFI. PCI
video in Gen1 is no longer available.

To support synthetic video on Hyper-V Gen2 VM, this patch updated
code related to the changes above.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/video/hyperv_fb.c |   60 ++++++++++++++++++++++++++++++--------------
 1 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
index bbcc8c0..5db1f20 100644
--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -42,6 +42,7 @@
 #include <linux/completion.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
+#include <linux/efi.h>
 
 #include <linux/hyperv.h>
 
@@ -461,13 +462,13 @@ static int synthvid_connect_vsp(struct hv_device *hdev)
 		goto error;
 	}
 
-	if (par->synthvid_version == SYNTHVID_VERSION_WIN7) {
+	if (par->synthvid_version == SYNTHVID_VERSION_WIN7)
 		screen_depth = SYNTHVID_DEPTH_WIN7;
-		screen_fb_size = SYNTHVID_FB_SIZE_WIN7;
-	} else {
+	else
 		screen_depth = SYNTHVID_DEPTH_WIN8;
-		screen_fb_size = SYNTHVID_FB_SIZE_WIN8;
-	}
+
+	screen_fb_size = hdev->channel->offermsg.offer.
+				mmio_megabytes * 1024 * 1024;
 
 	return 0;
 
@@ -635,22 +636,33 @@ static void hvfb_get_option(struct fb_info *info)
 /* Get framebuffer memory from Hyper-V video pci space */
 static int hvfb_getmem(struct fb_info *info)
 {
-	struct pci_dev *pdev;
+	struct pci_dev *pdev  = NULL;
 	ulong fb_phys;
 	void __iomem *fb_virt;
+	int gen2vm = efi_enabled(EFI_BOOT);
 
-	pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
+	if (gen2vm) {
+		if (!hyperv_mmio_start || hyperv_mmio_size < screen_fb_size) {
+			pr_err("Unable to find ACPI MMIO area\n");
+			return -ENODEV;
+		}
+
+		fb_phys = hyperv_mmio_start;
+	} else {
+		pdev = pci_get_device(PCI_VENDOR_ID_MICROSOFT,
 			      PCI_DEVICE_ID_HYPERV_VIDEO, NULL);
-	if (!pdev) {
-		pr_err("Unable to find PCI Hyper-V video\n");
-		return -ENODEV;
-	}
+		if (!pdev) {
+			pr_err("Unable to find PCI Hyper-V video\n");
+			return -ENODEV;
+		}
 
-	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
-	    pci_resource_len(pdev, 0) < screen_fb_size)
-		goto err1;
+		if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
+		    pci_resource_len(pdev, 0) < screen_fb_size)
+			goto err1;
+
+		fb_phys = pci_resource_end(pdev, 0) - screen_fb_size + 1;
+	}
 
-	fb_phys = pci_resource_end(pdev, 0) - screen_fb_size + 1;
 	if (!request_mem_region(fb_phys, screen_fb_size, KBUILD_MODNAME))
 		goto err1;
 
@@ -662,14 +674,22 @@ static int hvfb_getmem(struct fb_info *info)
 	if (!info->apertures)
 		goto err3;
 
-	info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
-	info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
+	if (gen2vm) {
+		info->apertures->ranges[0].base = screen_info.lfb_base;
+		info->apertures->ranges[0].size = screen_info.lfb_size;
+	} else {
+		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
+		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
+	}
+
 	info->fix.smem_start = fb_phys;
 	info->fix.smem_len = screen_fb_size;
 	info->screen_base = fb_virt;
 	info->screen_size = screen_fb_size;
 
-	pci_dev_put(pdev);
+	if (!gen2vm)
+		pci_dev_put(pdev);
+
 	return 0;
 
 err3:
@@ -677,7 +697,9 @@ err3:
 err2:
 	release_mem_region(fb_phys, screen_fb_size);
 err1:
-	pci_dev_put(pdev);
+	if (!gen2vm)
+		pci_dev_put(pdev);
+
 	return -ENOMEM;
 }
 
-- 
1.7.4.1

