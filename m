Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab3KYN17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:27:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56994 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3KYNH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 11/78] drm/vmwgfx: Don't kill clients on VT switch
Date: Mon, 25 Nov 2013 13:05:58 +0000
Message-Id: <1385384825-21681-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - adjusted context
  - vmw_execbuf_release_pinned_bo() takes 3 parameters ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index db50604..40cefd4 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -748,9 +748,17 @@ static void vmw_postclose(struct drm_device *dev,
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
 
@@ -953,14 +961,13 @@ static void vmw_master_drop(struct drm_device *dev,
 
 	vmw_fp->locked_master = drm_master_get(file_priv->master);
 	ret = ttm_vt_lock(&vmaster->lock, false, vmw_fp->tfile);
-	vmw_execbuf_release_pinned_bo(dev_priv, false, 0);
-
 	if (unlikely((ret != 0))) {
 		DRM_ERROR("Unable to lock TTM at VT switch.\n");
 		drm_master_put(&vmw_fp->locked_master);
 	}
 
-	ttm_lock_set_kill(&vmaster->lock, true, SIGTERM);
+	ttm_lock_set_kill(&vmaster->lock, false, SIGTERM);
+	vmw_execbuf_release_pinned_bo(dev_priv, false, 0);
 
 	if (!dev_priv->enable_fb) {
 		ret = ttm_bo_evict_mm(&dev_priv->bdev, TTM_PL_VRAM);
-- 
1.8.3.2

