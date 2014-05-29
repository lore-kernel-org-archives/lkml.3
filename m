Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbaE2F0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:26:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbaE2EfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>
Subject: [PATCH 3.14 056/140] drm/vmwgfx: Fix query buffer locking order violation
Date: Wed, 28 May 2014 21:33:15 -0700
Message-Id: <20140529043056.663345016@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit c8e5e010ef12df6707a1d711a5279a22f67a355e upstream.

The query buffers were reserved while holding the binding mutex, which
caused a circular locking dependency.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Brian Paul <brianp@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_context.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_context.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_context.c
@@ -117,10 +117,10 @@ static void vmw_hw_context_destroy(struc
 		(void) vmw_context_binding_state_kill
 			(&container_of(res, struct vmw_user_context, res)->cbs);
 		(void) vmw_gb_context_destroy(res);
+		mutex_unlock(&dev_priv->binding_mutex);
 		if (dev_priv->pinned_bo != NULL &&
 		    !dev_priv->query_cid_valid)
 			__vmw_execbuf_release_pinned_bo(dev_priv, NULL);
-		mutex_unlock(&dev_priv->binding_mutex);
 		mutex_unlock(&dev_priv->cmdbuf_mutex);
 		return;
 	}


