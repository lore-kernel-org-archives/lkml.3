Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019AbaFQQXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:23:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50729 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965003AbaFQQXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:23:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 096/121] drm/vmwgfx: Make sure user-space can't DMA across buffer object boundaries v2
Date: Tue, 17 Jun 2014 09:17:54 -0700
Message-Id: <1403021899-16708-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit cbd75e97a525e3819c02dc18bc2d67aa544c9e45 upstream.

We already check that the buffer object we're accessing is registered with
the file. Now also make sure that we can't DMA across buffer object boundaries.

v2: Code commenting update.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 394e647..da068bd 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -834,14 +834,36 @@ static int vmw_cmd_dma(struct vmw_private *dev_priv,
 		SVGA3dCmdSurfaceDMA dma;
 	} *cmd;
 	int ret;
+	SVGA3dCmdSurfaceDMASuffix *suffix;
+	uint32_t bo_size;
 
 	cmd = container_of(header, struct vmw_dma_cmd, header);
+	suffix = (SVGA3dCmdSurfaceDMASuffix *)((unsigned long) &cmd->dma +
+					       header->size - sizeof(*suffix));
+
+	/* Make sure device and verifier stays in sync. */
+	if (unlikely(suffix->suffixSize != sizeof(*suffix))) {
+		DRM_ERROR("Invalid DMA suffix size.\n");
+		return -EINVAL;
+	}
+
 	ret = vmw_translate_guest_ptr(dev_priv, sw_context,
 				      &cmd->dma.guest.ptr,
 				      &vmw_bo);
 	if (unlikely(ret != 0))
 		return ret;
 
+	/* Make sure DMA doesn't cross BO boundaries. */
+	bo_size = vmw_bo->base.num_pages * PAGE_SIZE;
+	if (unlikely(cmd->dma.guest.ptr.offset > bo_size)) {
+		DRM_ERROR("Invalid DMA offset.\n");
+		return -EINVAL;
+	}
+
+	bo_size -= cmd->dma.guest.ptr.offset;
+	if (unlikely(suffix->maximumOffset > bo_size))
+		suffix->maximumOffset = bo_size;
+
 	ret = vmw_cmd_res_check(dev_priv, sw_context, vmw_res_surface,
 				user_surface_converter, &cmd->dma.host.sid,
 				NULL);
-- 
1.9.1

