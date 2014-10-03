Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbaJCVmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:42:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbaJCVc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Mark Sheldon <markshel@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>
Subject: [PATCH 3.16 084/357] drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle
Date: Fri,  3 Oct 2014 14:27:50 -0700
Message-Id: <20141003212936.005726057@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit f01ea0c3d9db536c64d47922716d8b3b8f21d850 upstream.

The code waiting for fifo idle was incorrect and could possibly spin
forever under certain circumstances.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reported-by: Mark Sheldon <markshel@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Reivewed-by: Mark Sheldon <markshel@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
@@ -180,8 +180,9 @@ void vmw_fifo_release(struct vmw_private
 
 	mutex_lock(&dev_priv->hw_mutex);
 
+	vmw_write(dev_priv, SVGA_REG_SYNC, SVGA_SYNC_GENERIC);
 	while (vmw_read(dev_priv, SVGA_REG_BUSY) != 0)
-		vmw_write(dev_priv, SVGA_REG_SYNC, SVGA_SYNC_GENERIC);
+		;
 
 	dev_priv->last_read_seqno = ioread32(fifo_mem + SVGA_FIFO_FENCE);
 


