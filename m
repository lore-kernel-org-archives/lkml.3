Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaKAXGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:06:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Hellstrom" <thellstrom@vmware.com>,
        "Jakob Bornecrantz" <jakob@vmware.com>,
        "Mark Sheldon" <markshel@vmware.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.534547697@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 018/102] drm/vmwgfx: Fix a potential infinite spin
 waiting for fifo idle
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit f01ea0c3d9db536c64d47922716d8b3b8f21d850 upstream.

The code waiting for fifo idle was incorrect and could possibly spin
forever under certain circumstances.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reported-by: Mark Sheldon <markshel@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Reivewed-by: Mark Sheldon <markshel@vmware.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
@@ -163,8 +163,9 @@ void vmw_fifo_release(struct vmw_private
 
 	mutex_lock(&dev_priv->hw_mutex);
 
+	vmw_write(dev_priv, SVGA_REG_SYNC, SVGA_SYNC_GENERIC);
 	while (vmw_read(dev_priv, SVGA_REG_BUSY) != 0)
-		vmw_write(dev_priv, SVGA_REG_SYNC, SVGA_SYNC_GENERIC);
+		;
 
 	dev_priv->last_read_seqno = ioread32(fifo_mem + SVGA_FIFO_FENCE);
 

