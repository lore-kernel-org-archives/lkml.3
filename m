Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaBUMtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:49:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46805 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbaBUMtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 023/121] drm/vmwgfx: Fix regression caused by "drm/ttm: make ttm reservation calls behave like reservation calls"
Date: Fri, 21 Feb 2014 12:47:27 +0000
Message-Id: <1392986945-9693-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit cf5e3413337309050c05e13dcebe85b7194a21e5 upstream.

The call to ttm_eu_backoff_reservation() as part of an error path would cause
a lock imbalance if the reservation ticket was not initialized. This error is
easily triggered from user-space by submitting a bogus command stream.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 599f646..8b059eb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1483,11 +1483,11 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	ret = vmw_cmd_check_all(dev_priv, sw_context, kernel_commands,
 				command_size);
 	if (unlikely(ret != 0))
-		goto out_err;
+		goto out_err_nores;
 
 	ret = vmw_resources_reserve(sw_context);
 	if (unlikely(ret != 0))
-		goto out_err;
+		goto out_err_nores;
 
 	ret = ttm_eu_reserve_buffers(&ticket, &sw_context->validate_nodes);
 	if (unlikely(ret != 0))
@@ -1569,10 +1569,11 @@ int vmw_execbuf_process(struct drm_file *file_priv,
 	return 0;
 
 out_err:
-	vmw_resource_relocations_free(&sw_context->res_relocations);
-	vmw_free_relocations(sw_context);
 	ttm_eu_backoff_reservation(&ticket, &sw_context->validate_nodes);
+out_err_nores:
 	vmw_resource_list_unreserve(&sw_context->resource_list, true);
+	vmw_resource_relocations_free(&sw_context->res_relocations);
+	vmw_free_relocations(sw_context);
 	vmw_clear_validations(sw_context);
 	if (unlikely(dev_priv->pinned_bo != NULL &&
 		     !dev_priv->query_cid_valid))
-- 
1.9.0

