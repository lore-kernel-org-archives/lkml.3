Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab3EIWwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:52:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab3EIWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 40/73] drm/i915: Workaround incoherence between fences and LLC across multiple CPUs
Date: Thu,  9 May 2013 15:32:03 -0700
Message-Id: <20130509222802.317214242@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2662,17 +2662,35 @@ static inline int fence_number(struct dr
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
+	struct drm_device *dev = obj->base.dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	int fence_reg = fence_number(dev_priv, fence);
 
-	i915_gem_write_fence(obj->base.dev, reg, enable ? obj : NULL);
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


