Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaLRJZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 04:25:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaLRJZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 04:25:35 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org, airlied@gmail.com
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bochs: ignore device if there isn't enougth memory
Date: Thu, 18 Dec 2014 10:24:09 +0100
Message-Id: <1418894649-11441-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The qemu stdvga can be configured with a wide range of video memory,
from 1 MB to 256 MB (default is 16 MB).  In case it is configured
with only 1 or 2 MB it isn't really usable with bochsdrm, due to
depths other than 32bpp not being supported so that isn't enough
memory for a reasonable sized framebuffer.  So skip the device
and let vgacon or vesafb+fbcon handle the it.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/bochs/bochs_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/bochs/bochs_drv.c b/drivers/gpu/drm/bochs/bochs_drv.c
index 98837bd..9874d4a 100644
--- a/drivers/gpu/drm/bochs/bochs_drv.c
+++ b/drivers/gpu/drm/bochs/bochs_drv.c
@@ -162,8 +162,15 @@ static int bochs_kick_out_firmware_fb(struct pci_dev *pdev)
 static int bochs_pci_probe(struct pci_dev *pdev,
 			   const struct pci_device_id *ent)
 {
+	unsigned long fbsize;
 	int ret;
 
+	fbsize = pci_resource_len(pdev, 0);
+	if (fbsize < 4 * 1024 * 1024) {
+		DRM_ERROR("less than 4 MB video memory, ignoring device\n");
+		return -ENOMEM;
+	}
+
 	ret = bochs_kick_out_firmware_fb(pdev);
 	if (ret)
 		return ret;
-- 
1.8.3.1

