Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab3ERDOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:14:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab3ERDAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:16 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Bmaw6YZKMEcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=R2TdKipH9xcA:10 a=taGs_qngAAAA:8 a=e5mUnYsNAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=TBVoxVdAAAAA:8 a=7hXUw6Qm5162x0MzhM4A:9 a=n7Cch7CHiCMA:10 a=dGJ0OcVc7YAA:10 a=rW6DTWptwo0A:10 a=jeBq3FmKZ4MA:10 a=Em9o4q0NE7h1uoLJ:21 a=6-j2Jicdsjlq2uEc:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021659.659900835@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 112/136 ] drm/i915: Workaround incoherence between fences and LLC across
 multiple CPUs
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0112-drm-i915-Workaround-incoherence-between-fences-and-L.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 25ff1195f8a0b3724541ae7bbe331b4296de9c06 ]

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
Cc: stable@vger.kernel.org
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/i915_gem.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 97d4f4b..18da42c 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2525,17 +2525,35 @@ static inline int fence_number(struct drm_i915_private *dev_priv,
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
1.7.10.4


