Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbbAOVZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:25:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbbAOVZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:25:32 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: airlied@gmail.com, dri-devel@lists.freedesktop.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RESEND PATCH] bochs: ignore device if there isn't enougth memory
Date: Thu, 15 Jan 2015 22:24:54 +0100
Message-Id: <1421357094-6517-1-git-send-email-kraxel@redhat.com>
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

