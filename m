Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3BCBde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:33:34 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40933 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3BCBVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:51 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 17/62] drm/i915: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:18 -0800
Message-Id: <1359854463-2538-18-git-send-email-tj@kernel.org>
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
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/gpu/drm/i915/i915_gem_context.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915/i915_gem_context.c
index a3f06bc..27e586a 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -144,7 +144,7 @@ create_hw_context(struct drm_device *dev,
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct i915_hw_context *ctx;
-	int ret, id;
+	int ret;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (ctx == NULL)
@@ -169,22 +169,11 @@ create_hw_context(struct drm_device *dev,
 
 	ctx->file_priv = file_priv;
 
-again:
-	if (idr_pre_get(&file_priv->context_idr, GFP_KERNEL) == 0) {
-		ret = -ENOMEM;
-		DRM_DEBUG_DRIVER("idr allocation failed\n");
-		goto err_out;
-	}
-
-	ret = idr_get_new_above(&file_priv->context_idr, ctx,
-				DEFAULT_CONTEXT_ID + 1, &id);
-	if (ret == 0)
-		ctx->id = id;
-
-	if (ret == -EAGAIN)
-		goto again;
-	else if (ret)
+	ret = idr_alloc(&file_priv->context_idr, ctx, DEFAULT_CONTEXT_ID + 1, 0,
+			GFP_KERNEL);
+	if (ret < 0)
 		goto err_out;
+	ctx->id = ret;
 
 	return ctx;
 
-- 
1.8.1

