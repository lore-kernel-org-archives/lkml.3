Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494AbaE2N7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:59:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59467 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933440AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 053/103] drm/vmwgfx: Make sure user-space can't DMA across buffer object boundaries v2
Date: Thu, 29 May 2014 15:48:38 +0200
Message-Id: <e826b6c6640660db799f6c8344f40447e76036e8.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cbd75e97a525e3819c02dc18bc2d67aa544c9e45 upstream.

We already check that the buffer object we're accessing is registered with
the file. Now also make sure that we can't DMA across buffer object boundaries.

v2: Code commenting update.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 8b059eb09d9b..1b9aa982257e 100644
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
1.9.3

