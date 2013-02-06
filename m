Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab3BFTua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:30 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64315 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082Ab3BFTuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:19 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 33/77] drm/i915: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:05 -0800
Message-Id: <1360179649-22465-34-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
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

