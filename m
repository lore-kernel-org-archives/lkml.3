Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3G3PZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:25:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55327 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab3G3PSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 08/75] drm/i915: merge {i965, sandybridge}_write_fence_reg()
Date: Tue, 30 Jul 2013 08:16:37 -0700
Message-Id: <1375197464-27962-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 56c844e539f1f6f5768c5f73f119e6f4aed9d320 upstream.

The two functions are rather similar, so merge them.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: 3.8.y-stable prereq for d18b9619 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 44 ++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 919cc5c..2aef3d2 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2523,52 +2523,38 @@ int i915_gpu_idle(struct drm_device *dev)
 	return 0;
 }
 
-static void sandybridge_write_fence_reg(struct drm_device *dev, int reg,
-					struct drm_i915_gem_object *obj)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-	uint64_t val;
-
-	if (obj) {
-		u32 size = obj->gtt_space->size;
-
-		val = (uint64_t)((obj->gtt_offset + size - 4096) &
-				 0xfffff000) << 32;
-		val |= obj->gtt_offset & 0xfffff000;
-		val |= (uint64_t)((obj->stride / 128) - 1) <<
-			SANDYBRIDGE_FENCE_PITCH_SHIFT;
-
-		if (obj->tiling_mode == I915_TILING_Y)
-			val |= 1 << I965_FENCE_TILING_Y_SHIFT;
-		val |= I965_FENCE_REG_VALID;
-	} else
-		val = 0;
-
-	I915_WRITE64(FENCE_REG_SANDYBRIDGE_0 + reg * 8, val);
-	POSTING_READ(FENCE_REG_SANDYBRIDGE_0 + reg * 8);
-}
-
 static void i965_write_fence_reg(struct drm_device *dev, int reg,
 				 struct drm_i915_gem_object *obj)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
+	int fence_reg;
+	int fence_pitch_shift;
 	uint64_t val;
 
+	if (INTEL_INFO(dev)->gen >= 6) {
+		fence_reg = FENCE_REG_SANDYBRIDGE_0;
+		fence_pitch_shift = SANDYBRIDGE_FENCE_PITCH_SHIFT;
+	} else {
+		fence_reg = FENCE_REG_965_0;
+		fence_pitch_shift = I965_FENCE_PITCH_SHIFT;
+	}
+
 	if (obj) {
 		u32 size = obj->gtt_space->size;
 
 		val = (uint64_t)((obj->gtt_offset + size - 4096) &
 				 0xfffff000) << 32;
 		val |= obj->gtt_offset & 0xfffff000;
-		val |= ((obj->stride / 128) - 1) << I965_FENCE_PITCH_SHIFT;
+		val |= (uint64_t)((obj->stride / 128) - 1) << fence_pitch_shift;
 		if (obj->tiling_mode == I915_TILING_Y)
 			val |= 1 << I965_FENCE_TILING_Y_SHIFT;
 		val |= I965_FENCE_REG_VALID;
 	} else
 		val = 0;
 
-	I915_WRITE64(FENCE_REG_965_0 + reg * 8, val);
-	POSTING_READ(FENCE_REG_965_0 + reg * 8);
+	fence_reg += reg * 8;
+	I915_WRITE64(fence_reg, val);
+	POSTING_READ(fence_reg);
 }
 
 static void i915_write_fence_reg(struct drm_device *dev, int reg,
@@ -2652,7 +2638,7 @@ static void i915_gem_write_fence(struct drm_device *dev, int reg,
 {
 	switch (INTEL_INFO(dev)->gen) {
 	case 7:
-	case 6: sandybridge_write_fence_reg(dev, reg, obj); break;
+	case 6:
 	case 5:
 	case 4: i965_write_fence_reg(dev, reg, obj); break;
 	case 3: i915_write_fence_reg(dev, reg, obj); break;
-- 
1.8.1.2

