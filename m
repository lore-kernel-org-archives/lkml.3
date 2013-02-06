Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab3BFUBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:01:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53914 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253Ab3BFUBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:01:46 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 36/77] drm/vmwgfx: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:08 -0800
Message-Id: <1360179649-22465-37-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
index e01a17b..c9d0676 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_resource.c
@@ -177,17 +177,16 @@ int vmw_resource_alloc_id(struct vmw_resource *res)
 
 	BUG_ON(res->id != -1);
 
-	do {
-		if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
-			return -ENOMEM;
-
-		write_lock(&dev_priv->resource_lock);
-		ret = idr_get_new_above(idr, res, 1, &res->id);
-		write_unlock(&dev_priv->resource_lock);
+	idr_preload(GFP_KERNEL);
+	write_lock(&dev_priv->resource_lock);
 
-	} while (ret == -EAGAIN);
+	ret = idr_alloc(idr, res, 1, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		res->id = ret;
 
-	return ret;
+	write_unlock(&dev_priv->resource_lock);
+	idr_preload_end();
+	return ret < 0 ? ret : 0;
 }
 
 /**
-- 
1.8.1

