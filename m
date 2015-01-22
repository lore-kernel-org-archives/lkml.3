Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbbAVPST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:18:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbbAVPSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:18:17 -0500
From: Colin King <colin.king@canonical.com>
To: David Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>,
        jakob Bornecrantz <jakob@vmware.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drm/vmwgfx: Correctly NULLify dma buffer pointer on failure
Date: Thu, 22 Jan 2015 15:17:07 +0000
Message-Id: <1421939827-14991-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

cppcheck on lines 917 and 977 show an ineffective assignment
to the dma buffer pointer:

[drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c:917]:
[drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c:977]:
  (warning) Assignment of function parameter has no effect
  outside the function. Did you forget dereferencing it?

On a successful DMA buffer lookup, the dma buffer pointer is
assigned, however, on failure it currently is left in an
undefined state.

The original intention in the error exit path was to nullify
the pointer on an error (which the original code failed to
do properly). This patch fixes this also ensures all failure
paths nullify the buffer pointer on the error return.

Fortunately the callers to vmw_translate_mob_ptr and
vmw_translate_guest_ptr are checking on a return status and not
on the dma buffer pointer, so the original code worked.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 33176d0..275149c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -890,7 +890,8 @@ static int vmw_translate_mob_ptr(struct vmw_private *dev_priv,
 	ret = vmw_user_dmabuf_lookup(sw_context->fp->tfile, handle, &vmw_bo);
 	if (unlikely(ret != 0)) {
 		DRM_ERROR("Could not find or use MOB buffer.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_no_reloc;
 	}
 	bo = &vmw_bo->base;
 
@@ -914,7 +915,7 @@ static int vmw_translate_mob_ptr(struct vmw_private *dev_priv,
 
 out_no_reloc:
 	vmw_dmabuf_unreference(&vmw_bo);
-	vmw_bo_p = NULL;
+	*vmw_bo_p = NULL;
 	return ret;
 }
 
@@ -951,7 +952,8 @@ static int vmw_translate_guest_ptr(struct vmw_private *dev_priv,
 	ret = vmw_user_dmabuf_lookup(sw_context->fp->tfile, handle, &vmw_bo);
 	if (unlikely(ret != 0)) {
 		DRM_ERROR("Could not find or use GMR region.\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_no_reloc;
 	}
 	bo = &vmw_bo->base;
 
@@ -974,7 +976,7 @@ static int vmw_translate_guest_ptr(struct vmw_private *dev_priv,
 
 out_no_reloc:
 	vmw_dmabuf_unreference(&vmw_bo);
-	vmw_bo_p = NULL;
+	*vmw_bo_p = NULL;
 	return ret;
 }
 
-- 
2.1.4

