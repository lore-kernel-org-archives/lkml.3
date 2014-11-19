Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaKSL2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:28:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbaKSL2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:28:22 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, Gerd Hoffmann <kraxel@redhat.com>,
        David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/4] bochs: add endian switching support
Date: Wed, 19 Nov 2014 12:28:10 +0100
Message-Id: <1416396492-23214-3-git-send-email-kraxel@redhat.com>
In-Reply-To: <1416396492-23214-1-git-send-email-kraxel@redhat.com>
References: <1416396492-23214-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently (qemu 2.2+) the qemu stdvga got a register to switch the vga
framebuffer endianness.  This patch adds code to explicitly set the
endianness of the framebuffer.  In most cases this has no effect as
the default is guest architecture endianness.  It is needed though in
case a architecture supports both big and little endian, i.e. for
ppc64le.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/bochs/bochs_hw.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bochs/bochs_hw.c b/drivers/gpu/drm/bochs/bochs_hw.c
index e8b1dac..4603897 100644
--- a/drivers/gpu/drm/bochs/bochs_hw.c
+++ b/drivers/gpu/drm/bochs/bochs_hw.c
@@ -51,7 +51,7 @@ int bochs_hw_init(struct drm_device *dev, uint32_t flags)
 {
 	struct bochs_device *bochs = dev->dev_private;
 	struct pci_dev *pdev = dev->pdev;
-	unsigned long addr, size, mem, ioaddr, iosize;
+	unsigned long addr, size, mem, ioaddr, iosize, qext_size;
 	u16 id;
 
 	if (pdev->resource[2].flags & IORESOURCE_MEM) {
@@ -115,6 +115,24 @@ int bochs_hw_init(struct drm_device *dev, uint32_t flags)
 		 size / 1024, addr,
 		 bochs->ioports ? "ioports" : "mmio",
 		 ioaddr);
+
+	if (bochs->mmio && pdev->revision >= 2) {
+		qext_size = readl(bochs->mmio + 0x600);
+		if (qext_size < 4 || qext_size > iosize)
+			goto noext;
+		DRM_DEBUG("Found qemu ext regs, size %ld\n", qext_size);
+		if (qext_size >= 8) {
+#ifdef __BIG_ENDIAN
+			writel(0xbebebebe, bochs->mmio + 0x604);
+#else
+			writel(0x1e1e1e1e, bochs->mmio + 0x604);
+#endif
+			DRM_DEBUG("  qext endian: 0x%x\n",
+				  readl(bochs->mmio + 0x604));
+		}
+	}
+
+noext:
 	return 0;
 }
 
-- 
1.8.3.1

