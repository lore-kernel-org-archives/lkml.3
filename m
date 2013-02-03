Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3BCBWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:22:01 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:63566 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3BCBV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:57 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 20/62] drm/vmwgfx: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:21 -0800
Message-Id: <1359854463-2538-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

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

