Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaI3VjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:39:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaI3VjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 091/103] drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle
Date: Tue, 30 Sep 2014 14:31:36 -0700
Message-Id: <1412112708-27356-92-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit f01ea0c3d9db536c64d47922716d8b3b8f21d850 upstream.

The code waiting for fifo idle was incorrect and could possibly spin
forever under certain circumstances.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reported-by: Mark Sheldon <markshel@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Reivewed-by: Mark Sheldon <markshel@vmware.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
index 3eb1486..8966493 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
@@ -163,8 +163,9 @@ void vmw_fifo_release(struct vmw_private *dev_priv, struct vmw_fifo_state *fifo)
 
 	mutex_lock(&dev_priv->hw_mutex);
 
+	vmw_write(dev_priv, SVGA_REG_SYNC, SVGA_SYNC_GENERIC);
 	while (vmw_read(dev_priv, SVGA_REG_BUSY) != 0)
-		vmw_write(dev_priv, SVGA_REG_SYNC, SVGA_SYNC_GENERIC);
+		;
 
 	dev_priv->last_read_seqno = ioread32(fifo_mem + SVGA_FIFO_FENCE);
 
-- 
1.9.1

