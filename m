Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab3KIGxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:53:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab3KIGwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.11 78/94] drm/vmwgfx: Dont kill clients on VT switch
Date: Fri,  8 Nov 2013 22:52:24 -0800
Message-Id: <20131109065209.762825950@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -738,9 +738,17 @@ static void vmw_postclose(struct drm_dev
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
 
@@ -940,14 +948,13 @@ static void vmw_master_drop(struct drm_d
 
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


