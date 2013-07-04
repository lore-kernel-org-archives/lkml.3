Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3GDM0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:26:33 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:60009 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab3GDM02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:28 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH v2 02/14] fbdev: simplefb: mark as fw and allocate apertures
Date: Thu,  4 Jul 2013 14:25:02 +0200
Message-Id: <1372940714-12470-3-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fbdev-core uses FBINFO_MISC_FIRMWARE to mark drivers that use firmware
framebuffers. Furthermore, we now allocate apertures for the fbinfo
device.
Both information is used by remove_conflicting_framebuffers() to remove a
fbdev device whenever a real driver is loaded. This is used heavily on x86
for VGA/vesa/EFI framebuffers, but is also of great use for all other
systems.

Especially with x86 support for simplefb, this information is needed to
unload simplefb before a real hw-driver (like i915, radeon, nouveau) is
loaded.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/simplefb.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
index 5886989..8d78106 100644
--- a/drivers/video/simplefb.c
+++ b/drivers/video/simplefb.c
@@ -202,8 +202,16 @@ static int simplefb_probe(struct platform_device *pdev)
 	info->var.blue = params.format->blue;
 	info->var.transp = params.format->transp;
 
+	info->apertures = alloc_apertures(1);
+	if (!info->apertures) {
+		framebuffer_release(info);
+		return -ENOMEM;
+	}
+	info->apertures->ranges[0].base = info->fix.smem_start;
+	info->apertures->ranges[0].size = info->fix.smem_len;
+
 	info->fbops = &simplefb_ops;
-	info->flags = FBINFO_DEFAULT;
+	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE;
 	info->screen_base = devm_ioremap(&pdev->dev, info->fix.smem_start,
 					 info->fix.smem_len);
 	if (!info->screen_base) {
-- 
1.8.3.2

