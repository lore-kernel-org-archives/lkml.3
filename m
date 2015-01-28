Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbbA1ENr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:13:47 -0500
Received: from mail.kernel.org ([198.145.29.136]:36719 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760375AbbA1ENo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:13:44 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 05/91] drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle
Date: Wed, 28 Jan 2015 12:06:17 +0800
Message-Id: <1422418236-12852-10-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit f01ea0c3d9db536c64d47922716d8b3b8f21d850 upstream.

The code waiting for fifo idle was incorrect and could possibly spin
forever under certain circumstances.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reported-by: Mark Sheldon <markshel@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Reivewed-by: Mark Sheldon <markshel@vmware.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
index a0c2f12..decca82 100644
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

