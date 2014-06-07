Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaFGB1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:27:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36152 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Hellstrom" <thellstrom@vmware.com>,
        "Jakob Bornecrantz" <jakob@vmware.com>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.15437572@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 30/92] drm/vmwgfx: Make sure user-space can't DMA
 across buffer object boundaries v2
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit cbd75e97a525e3819c02dc18bc2d67aa544c9e45 upstream.

We already check that the buffer object we're accessing is registered with
the file. Now also make sure that we can't DMA across buffer object boundaries.

v2: Code commenting update.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -558,14 +558,36 @@ static int vmw_cmd_dma(struct vmw_privat
 	} *cmd;
 	int ret;
 	struct vmw_resource *res;
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
 	bo = &vmw_bo->base;
 	ret = vmw_user_surface_lookup_handle(dev_priv, sw_context->tfile,
 					     cmd->dma.host.sid, &srf);

