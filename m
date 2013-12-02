Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3LBTSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:18:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab3LBTST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>
Subject: [PATCH 3.12 124/212] drm/vmwgfx: Resource evict fixes
Date: Mon,  2 Dec 2013 11:15:15 -0800
Message-Id: <20131202191300.909482761@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit ea029c28deadc33d2af4baf26810dd5fc44d4926 upstream.

Fix an error message that was incorrectly blaming device resource id
shortage.

Also make sure we correctly catch resource eviction errors, that
could otherwise lead to evictable resources temporarily not being on the
LRU list.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c |   42 ++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -32,6 +32,8 @@
 #include <drm/drmP.h>
 #include "vmwgfx_resource_priv.h"
 
+#define VMW_RES_EVICT_ERR_COUNT 10
+
 struct vmw_user_dma_buffer {
 	struct ttm_base_object base;
 	struct vmw_dma_buffer dma;
@@ -1091,8 +1093,9 @@ vmw_resource_backoff_reservation(struct
  *                         to a backup buffer.
  *
  * @res:            The resource to evict.
+ * @interruptible:  Whether to wait interruptible.
  */
-int vmw_resource_do_evict(struct vmw_resource *res)
+int vmw_resource_do_evict(struct vmw_resource *res, bool interruptible)
 {
 	struct ttm_validate_buffer val_buf;
 	const struct vmw_res_func *func = res->func;
@@ -1102,7 +1105,8 @@ int vmw_resource_do_evict(struct vmw_res
 	BUG_ON(!func->may_evict);
 
 	val_buf.bo = NULL;
-	ret = vmw_resource_check_buffer(res, &ticket, true, &val_buf);
+	ret = vmw_resource_check_buffer(res, &ticket, interruptible,
+					&val_buf);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1141,6 +1145,7 @@ int vmw_resource_validate(struct vmw_res
 	struct vmw_private *dev_priv = res->dev_priv;
 	struct list_head *lru_list = &dev_priv->res_lru[res->func->res_type];
 	struct ttm_validate_buffer val_buf;
+	unsigned err_count = 0;
 
 	if (likely(!res->func->may_evict))
 		return 0;
@@ -1155,7 +1160,7 @@ int vmw_resource_validate(struct vmw_res
 
 		write_lock(&dev_priv->resource_lock);
 		if (list_empty(lru_list) || !res->func->may_evict) {
-			DRM_ERROR("Out of device device id entries "
+			DRM_ERROR("Out of device device resources "
 				  "for %s.\n", res->func->type_name);
 			ret = -EBUSY;
 			write_unlock(&dev_priv->resource_lock);
@@ -1168,7 +1173,19 @@ int vmw_resource_validate(struct vmw_res
 		list_del_init(&evict_res->lru_head);
 
 		write_unlock(&dev_priv->resource_lock);
-		vmw_resource_do_evict(evict_res);
+
+		ret = vmw_resource_do_evict(evict_res, true);
+		if (unlikely(ret != 0)) {
+			write_lock(&dev_priv->resource_lock);
+			list_add_tail(&evict_res->lru_head, lru_list);
+			write_unlock(&dev_priv->resource_lock);
+			if (ret == -ERESTARTSYS ||
+			    ++err_count > VMW_RES_EVICT_ERR_COUNT) {
+				vmw_resource_unreference(&evict_res);
+				goto out_no_validate;
+			}
+		}
+
 		vmw_resource_unreference(&evict_res);
 	} while (1);
 
@@ -1253,13 +1270,15 @@ bool vmw_resource_needs_backup(const str
  * @type:           The resource type to evict
  *
  * To avoid thrashing starvation or as part of the hibernation sequence,
- * evict all evictable resources of a specific type.
+ * try to evict all evictable resources of a specific type.
  */
 static void vmw_resource_evict_type(struct vmw_private *dev_priv,
 				    enum vmw_res_type type)
 {
 	struct list_head *lru_list = &dev_priv->res_lru[type];
 	struct vmw_resource *evict_res;
+	unsigned err_count = 0;
+	int ret;
 
 	do {
 		write_lock(&dev_priv->resource_lock);
@@ -1272,7 +1291,18 @@ static void vmw_resource_evict_type(stru
 					 lru_head));
 		list_del_init(&evict_res->lru_head);
 		write_unlock(&dev_priv->resource_lock);
-		vmw_resource_do_evict(evict_res);
+
+		ret = vmw_resource_do_evict(evict_res, false);
+		if (unlikely(ret != 0)) {
+			write_lock(&dev_priv->resource_lock);
+			list_add_tail(&evict_res->lru_head, lru_list);
+			write_unlock(&dev_priv->resource_lock);
+			if (++err_count > VMW_RES_EVICT_ERR_COUNT) {
+				vmw_resource_unreference(&evict_res);
+				return;
+			}
+		}
+
 		vmw_resource_unreference(&evict_res);
 	} while (1);
 


