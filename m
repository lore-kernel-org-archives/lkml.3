Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3JKIBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:01:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab3JKIBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:01:34 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/6] drm/qxl: support 64bit surface bar
Date: Fri, 11 Oct 2013 10:01:10 +0200
Message-Id: <1381478473-18159-4-git-send-email-kraxel@redhat.com>
In-Reply-To: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
References: <1381478473-18159-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qxl devices can have a 64bit surface bar, which is quite handy if
you need a bit more surface memory.  So try to use it if it is
present.  Note that this bar might be mapped above 4g.

QEMU command line to check that out:

    qemu-system-x86_64 -m 4g \
        -vga qxl -global qxl-vga.vram64_size_mb=512 \
        $otheroptions

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/qxl/qxl_kms.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_kms.c b/drivers/gpu/drm/qxl/qxl_kms.c
index 9e8da9e..e0ddd5b 100644
--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -120,7 +120,7 @@ int qxl_device_init(struct qxl_device *qdev,
 		    struct pci_dev *pdev,
 		    unsigned long flags)
 {
-	int r;
+	int r, sb;
 
 	qdev->dev = &pdev->dev;
 	qdev->ddev = ddev;
@@ -136,21 +136,39 @@ int qxl_device_init(struct qxl_device *qdev,
 	qdev->rom_base = pci_resource_start(pdev, 2);
 	qdev->rom_size = pci_resource_len(pdev, 2);
 	qdev->vram_base = pci_resource_start(pdev, 0);
-	qdev->surfaceram_base = pci_resource_start(pdev, 1);
-	qdev->surfaceram_size = pci_resource_len(pdev, 1);
 	qdev->io_base = pci_resource_start(pdev, 3);
 
 	qdev->vram_mapping = io_mapping_create_wc(qdev->vram_base, pci_resource_len(pdev, 0));
-	qdev->surface_mapping = io_mapping_create_wc(qdev->surfaceram_base, qdev->surfaceram_size);
-	DRM_DEBUG_KMS("qxl: vram %llx-%llx(%dM %dk), surface %llx-%llx(%dM %dk)\n",
+
+	if (pci_resource_len(pdev, 4) > 0) {
+		/* 64bit surface bar present */
+		sb = 4;
+		qdev->surfaceram_base = pci_resource_start(pdev, sb);
+		qdev->surfaceram_size = pci_resource_len(pdev, sb);
+		qdev->surface_mapping =
+			io_mapping_create_wc(qdev->surfaceram_base,
+					     qdev->surfaceram_size);
+	}
+	if (qdev->surface_mapping == NULL) {
+		/* 64bit surface bar not present (or mapping failed) */
+		sb = 1;
+		qdev->surfaceram_base = pci_resource_start(pdev, sb);
+		qdev->surfaceram_size = pci_resource_len(pdev, sb);
+		qdev->surface_mapping =
+			io_mapping_create_wc(qdev->surfaceram_base,
+					     qdev->surfaceram_size);
+	}
+
+	DRM_DEBUG_KMS("qxl: vram %llx-%llx(%dM %dk), surface %llx-%llx(%dM %dk, %s)\n",
 		 (unsigned long long)qdev->vram_base,
 		 (unsigned long long)pci_resource_end(pdev, 0),
 		 (int)pci_resource_len(pdev, 0) / 1024 / 1024,
 		 (int)pci_resource_len(pdev, 0) / 1024,
 		 (unsigned long long)qdev->surfaceram_base,
-		 (unsigned long long)pci_resource_end(pdev, 1),
+		 (unsigned long long)pci_resource_end(pdev, sb),
 		 (int)qdev->surfaceram_size / 1024 / 1024,
-		 (int)qdev->surfaceram_size / 1024);
+		 (int)qdev->surfaceram_size / 1024,
+		 (sb == 4) ? "64bit" : "32bit");
 
 	qdev->rom = ioremap(qdev->rom_base, qdev->rom_size);
 	if (!qdev->rom) {
-- 
1.8.3.1

