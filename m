Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab3EMX73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:59:29 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53535 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3EMX7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:59:25 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 9/9] drm: Don't leak phys_wc "handles" to userspace
Date: Mon, 13 May 2013 16:58:48 -0700
Message-Id: <49cb9bfb3edeaf86ec659f1722893ddbd31075c4.1368485053.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
In-Reply-To: <cover.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't fix this in the earlier patch -- it would have broken the
build due to the now-deleted garbage in drm_os_linux.h.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/gpu/drm/drm_bufs.c  |  9 +++++++++
 drivers/gpu/drm/drm_ioctl.c | 15 ++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index 0190fce..5a4dbb4 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -414,6 +414,15 @@ int drm_addmap_ioctl(struct drm_device *dev, void *data,
 
 	/* avoid a warning on 64-bit, this casting isn't very nice, but the API is set so too late */
 	map->handle = (void *)(unsigned long)maplist->user_token;
+
+	/*
+	 * It appears that there are no users of this value whatsoever --
+	 * drmAddMap just discards it.  Let's not encourage its use.
+	 * (Keeping drm_addmap_core's returned mtrr value would be wrong --
+	 *  it's not a real mtrr index anymore.)
+	 */
+	map->mtrr = -1;
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index e77bd8b..ffd7a7b 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -38,6 +38,9 @@
 
 #include <linux/pci.h>
 #include <linux/export.h>
+#ifdef CONFIG_X86
+#include <asm/mtrr.h>
+#endif
 
 /**
  * Get the bus id.
@@ -181,7 +184,17 @@ int drm_getmap(struct drm_device *dev, void *data,
 	map->type = r_list->map->type;
 	map->flags = r_list->map->flags;
 	map->handle = (void *)(unsigned long) r_list->user_token;
-	map->mtrr = r_list->map->mtrr;
+
+#ifdef CONFIG_X86
+	/*
+	 * There appears to be exactly one user of the mtrr index: dritest.
+	 * It's easy enough to keep it working on non-PAT systems.
+	 */
+	map->mtrr = phys_wc_to_mtrr_index(r_list->map->mtrr);
+#else
+	map->mtrr = -1;
+#endif
+
 	mutex_unlock(&dev->struct_mutex);
 
 	return 0;
-- 
1.8.1.4

