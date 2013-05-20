Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3ETKxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55992 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab3ETKw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 016/115] drm/i915: Workaround incoherence between fences and LLC across multiple CPUs
Date: Mon, 20 May 2013 11:50:16 +0100
Message-Id: <1369047116-9378-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 25ff1195f8a0b3724541ae7bbe331b4296de9c06 upstream.

In order to fully serialize access to the fenced region and the update
to the fence register we need to take extreme measures on SNB+, and
manually flush writes to memory prior to writing the fence register in
conjunction with the memory barriers placed around the register write.

Fixes i-g-t/gem_fence_thrash

v2: Bring a bigger gun
v3: Switch the bigger gun for heavier bullets (Arjan van de Ven)
v4: Remove changes for working generations.
v5: Reduce to a per-cpu wbinvd() call prior to updating the fences.
v6: Rewrite comments to ellide forgotten history.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=62191
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Tested-by: Jon Bloomfield <jon.bloomfield@intel.com> (v2)
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 7605f40..19e9f33 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2332,17 +2332,35 @@ static inline int fence_number(struct drm_i915_private *dev_priv,
 	return fence - dev_priv->fence_regs;
 }
 
+static void i915_gem_write_fence__ipi(void *data)
+{
+	wbinvd();
+}
+
 static void i915_gem_object_update_fence(struct drm_i915_gem_object *obj,
 					 struct drm_i915_fence_reg *fence,
 					 bool enable)
 {
-	struct drm_i915_private *dev_priv = obj->base.dev->dev_private;
-	int reg = fence_number(dev_priv, fence);
-
-	i915_gem_write_fence(obj->base.dev, reg, enable ? obj : NULL);
+	struct drm_device *dev = obj->base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int fence_reg = fence_number(dev_priv, fence);
+
+	/* In order to fully serialize access to the fenced region and
+	 * the update to the fence register we need to take extreme
+	 * measures on SNB+. In theory, the write to the fence register
+	 * flushes all memory transactions before, and coupled with the
+	 * mb() placed around the register write we serialise all memory
+	 * operations with respect to the changes in the tiler. Yet, on
+	 * SNB+ we need to take a step further and emit an explicit wbinvd()
+	 * on each processor in order to manually flush all memory
+	 * transactions before updating the fence register.
+	 */
+	if (HAS_LLC(obj->base.dev))
+		on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
+	i915_gem_write_fence(dev, fence_reg, enable ? obj : NULL);
 
 	if (enable) {
-		obj->fence_reg = reg;
+		obj->fence_reg = fence_reg;
 		fence->obj = obj;
 		list_move_tail(&fence->lru_list, &dev_priv->mm.fence_list);
 	} else {
-- 
1.8.1.2

