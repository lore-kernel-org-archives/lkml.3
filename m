Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaB1VUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:20:35 -0500
Received: from mail.ispras.ru ([83.149.199.45]:55383 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaB1VUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:20:34 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: David Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jakob Bornecrant <jakob@vmware.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] drm/vmwgfx: avoid null pointer dereference at failure paths
Date: Sat,  1 Mar 2014 01:20:18 +0400
Message-Id: <1393622418-6515-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmw_takedown_otable_base() and vmw_mob_unbind() check for
potential vmw_fifo_reserve() failure and print error message,
but then immediately dereference NULL pointer.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_mob.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
index d4a5a19cb8c3..04a64b8cd3cd 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_mob.c
@@ -188,18 +188,20 @@ static void vmw_takedown_otable_base(struct vmw_private *dev_priv,
 
 	bo = otable->page_table->pt_bo;
 	cmd = vmw_fifo_reserve(dev_priv, sizeof(*cmd));
-	if (unlikely(cmd == NULL))
-		DRM_ERROR("Failed reserving FIFO space for OTable setup.\n");
-
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->header.id = SVGA_3D_CMD_SET_OTABLE_BASE;
-	cmd->header.size = sizeof(cmd->body);
-	cmd->body.type = type;
-	cmd->body.baseAddress = 0;
-	cmd->body.sizeInBytes = 0;
-	cmd->body.validSizeInBytes = 0;
-	cmd->body.ptDepth = SVGA3D_MOBFMT_INVALID;
-	vmw_fifo_commit(dev_priv, sizeof(*cmd));
+	if (unlikely(cmd == NULL)) {
+		DRM_ERROR("Failed reserving FIFO space for OTable "
+			  "takedown.\n");
+	} else {
+		memset(cmd, 0, sizeof(*cmd));
+		cmd->header.id = SVGA_3D_CMD_SET_OTABLE_BASE;
+		cmd->header.size = sizeof(cmd->body);
+		cmd->body.type = type;
+		cmd->body.baseAddress = 0;
+		cmd->body.sizeInBytes = 0;
+		cmd->body.validSizeInBytes = 0;
+		cmd->body.ptDepth = SVGA3D_MOBFMT_INVALID;
+		vmw_fifo_commit(dev_priv, sizeof(*cmd));
+	}
 
 	if (bo) {
 		int ret;
@@ -562,11 +564,12 @@ void vmw_mob_unbind(struct vmw_private *dev_priv,
 	if (unlikely(cmd == NULL)) {
 		DRM_ERROR("Failed reserving FIFO space for Memory "
 			  "Object unbinding.\n");
+	} else {
+		cmd->header.id = SVGA_3D_CMD_DESTROY_GB_MOB;
+		cmd->header.size = sizeof(cmd->body);
+		cmd->body.mobid = mob->id;
+		vmw_fifo_commit(dev_priv, sizeof(*cmd));
 	}
-	cmd->header.id = SVGA_3D_CMD_DESTROY_GB_MOB;
-	cmd->header.size = sizeof(cmd->body);
-	cmd->body.mobid = mob->id;
-	vmw_fifo_commit(dev_priv, sizeof(*cmd));
 	if (bo) {
 		vmw_fence_single_bo(bo, NULL);
 		ttm_bo_unreserve(bo);
-- 
1.8.3.2

