Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaHXOvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:51:13 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43784 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaHXOvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:51:11 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Inki Dae <inki.dae@samsung.com>,
        Siarhei Siamashka <siarhei.siamashka@gmail.com>,
        =?UTF-8?q?G=C3=BCnther=20Noack?= <me@guenthernoack.de>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH] drm/exynos/fbdev: set smem_len for fbdev
Date: Sun, 24 Aug 2014 22:50:57 +0800
Message-Id: <1408891857-14258-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit [0] stopped setting fix.smem_start and fix.smem_len when creating
the fbdev.

[0] 2f1eab8d8ab59e799f7d51d62410b398607a7bc3
  drm/exynos/fbdev: don't set fix.smem/mmio_{start,len}

However, smem_len is used by some userland applications to calculate the
size for mmap.  In particular, it is used by xf86-video-fbdev:

http://cgit.freedesktop.org/xorg/xserver/tree/hw/xfree86/fbdevhw/fbdevhw.c?id=xorg-server-1.15.99.903#n571

So, let's restore setting the smem_len to unbreak things for these users.

Note: we are still leaving smem_start set to 0.

Reported-by: Siarhei Siamashka <siarhei.siamashka@gmail.com>
Reported-by: Günther Noack <me@guenthernoack.de>
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
I am able to compile test this change, but would appreciate help testing it
on a system that uses xf86-video-fbdev.

Thanks!

 drivers/gpu/drm/exynos/exynos_drm_fbdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
index 5a7cd8b..f865736 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
@@ -125,6 +125,7 @@ static int exynos_drm_fbdev_update(struct drm_fb_helper *helper,
 
 	fbi->screen_base = buffer->kvaddr;
 	fbi->screen_size = size;
+	fbi->fix.smem_len = size;
 
 	return 0;
 }
-- 
2.1.0.rc2.206.gedb03e5

