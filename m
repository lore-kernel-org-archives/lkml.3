Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3G3PTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:19:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55339 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab3G3PSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Carsten Emde <C.Emde@osadl.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 10/75] Revert "drm/i915: Workaround incoherence between fences and LLC across multiple CPUs"
Date: Tue, 30 Jul 2013 08:16:39 -0700
Message-Id: <1375197464-27962-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 46a0b638f35b45fc13d3dc0deb6a7e17988170b2 upstream.

This reverts commit 25ff119 and the follow on for Valleyview commit 2dc8aae.

commit 25ff1195f8a0b3724541ae7bbe331b4296de9c06
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Apr 4 21:31:03 2013 +0100

    drm/i915: Workaround incoherence between fences and LLC across multiple CPUs

commit 2dc8aae06d53458dd3624dc0accd4f81100ee631
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed May 22 17:08:06 2013 +0100

    drm/i915: Workaround incoherence with fence updates on Valleyview

Jon Bloomfield came up with a plausible explanation and cheap fix
(drm/i915: Fix incoherence with fence updates on Sandybridge+) for the
race condition, so lets run with it.

This is a candidate for stable as the old workaround incurs a
significant cost (calling wbinvd on all CPUs before performing the
register write) for some workloads as noted by Carsten Emde.

Link: http://lists.freedesktop.org/archives/intel-gfx/2013-June/028819.html
References: https://www.osadl.org/?id=1543#c7602
References: https://bugs.freedesktop.org/show_bug.cgi?id=63825
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Cc: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: revert the 3.8.y-stable version of 25ff119:
  This reverts commit b578b3a82d830e2170d403b1fb29b649e26a48fb. ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 979d892..22b5784 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2671,35 +2671,17 @@ static inline int fence_number(struct drm_i915_private *dev_priv,
 	return fence - dev_priv->fence_regs;
 }
 
-static void i915_gem_write_fence__ipi(void *data)
-{
-	wbinvd();
-}
-
 static void i915_gem_object_update_fence(struct drm_i915_gem_object *obj,
 					 struct drm_i915_fence_reg *fence,
 					 bool enable)
 {
-	struct drm_device *dev = obj->base.dev;
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	int fence_reg = fence_number(dev_priv, fence);
-
-	/* In order to fully serialize access to the fenced region and
-	 * the update to the fence register we need to take extreme
-	 * measures on SNB+. In theory, the write to the fence register
-	 * flushes all memory transactions before, and coupled with the
-	 * mb() placed around the register write we serialise all memory
-	 * operations with respect to the changes in the tiler. Yet, on
-	 * SNB+ we need to take a step further and emit an explicit wbinvd()
-	 * on each processor in order to manually flush all memory
-	 * transactions before updating the fence register.
-	 */
-	if (HAS_LLC(obj->base.dev))
-		on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
-	i915_gem_write_fence(dev, fence_reg, enable ? obj : NULL);
+	struct drm_i915_private *dev_priv = obj->base.dev->dev_private;
+	int reg = fence_number(dev_priv, fence);
+
+	i915_gem_write_fence(obj->base.dev, reg, enable ? obj : NULL);
 
 	if (enable) {
-		obj->fence_reg = fence_reg;
+		obj->fence_reg = reg;
 		fence->obj = obj;
 		list_move_tail(&fence->lru_list, &dev_priv->mm.fence_list);
 	} else {
-- 
1.8.1.2

