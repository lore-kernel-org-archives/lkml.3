Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3KHCYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:24:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34935 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab3KHCWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:22:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 54/91] drm/vmwgfx: Don't kill clients on VT switch
Date: Thu,  7 Nov 2013 18:15:09 -0800
Message-Id: <1383876946-2396-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit c4249855ac5b2a383704d31e040d3831d6a25c6f upstream.

DRI clients that tried to grab the TTM lock when the master (X server) was
switched away during a VT switch were sent the SIGTERM signal by the
kernel. Fix this so that they are only sent that signal when the master has
exited.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 161f8b2..099d8d4 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -740,9 +740,17 @@ static void vmw_postclose(struct drm_device *dev,
 	struct vmw_fpriv *vmw_fp;
 
 	vmw_fp = vmw_fpriv(file_priv);
-	ttm_object_file_release(&vmw_fp->tfile);
-	if (vmw_fp->locked_master)
+
+	if (vmw_fp->locked_master) {
+		struct vmw_master *vmaster =
+			vmw_master(vmw_fp->locked_master);
+
+		ttm_lock_set_kill(&vmaster->lock, true, SIGTERM);
+		ttm_vt_unlock(&vmaster->lock);
 		drm_master_put(&vmw_fp->locked_master);
+	}
+
+	ttm_object_file_release(&vmw_fp->tfile);
 	kfree(vmw_fp);
 }
 
@@ -942,14 +950,13 @@ static void vmw_master_drop(struct drm_device *dev,
 
 	vmw_fp->locked_master = drm_master_get(file_priv->master);
 	ret = ttm_vt_lock(&vmaster->lock, false, vmw_fp->tfile);
-	vmw_execbuf_release_pinned_bo(dev_priv);
-
 	if (unlikely((ret != 0))) {
 		DRM_ERROR("Unable to lock TTM at VT switch.\n");
 		drm_master_put(&vmw_fp->locked_master);
 	}
 
-	ttm_lock_set_kill(&vmaster->lock, true, SIGTERM);
+	ttm_lock_set_kill(&vmaster->lock, false, SIGTERM);
+	vmw_execbuf_release_pinned_bo(dev_priv);
 
 	if (!dev_priv->enable_fb) {
 		ret = ttm_bo_evict_mm(&dev_priv->bdev, TTM_PL_VRAM);
-- 
1.8.1.2

