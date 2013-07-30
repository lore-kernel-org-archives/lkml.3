Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3G3SzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:55:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56539 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3G3Spe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 40/75] drm/i915: Serialize almost all register access
Date: Tue, 30 Jul 2013 11:44:44 -0700
Message-Id: <1375209919-1768-7-git-send-email-kamal@canonical.com>
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

commit a7cd1b8fea2f341b626b255d9898a5ca5fabbf0a upstream.

In theory, the different register blocks were meant to be only ever
touched when holding either the struct_mutex, mode_config.lock or even a
specific localised lock. This does not seem to be the case, and the
hardware reacts extremely badly if we attempt to concurrently access two
registers within the same cacheline.

The HSD suggests that we only need to do this workaround for display
range registers. However, upon review we need to serialize the multiple
stages in our register write functions - if only for preemption
protection.

Irrespective of the hardware requirements, the current io functions are
a little too loose with respect to the combination of pre- and
post-condition testing that we do in conjunction with the actual io. As
a result, we may be pre-empted and generate both false-postive and
false-negative errors.

Note well that this is a "90%" solution, there remains a few direct
users of ioread/iowrite which will be fixed up in the next few patches.
Since they are more invasive and that this simple change will prevent
almost all lockups on Haswell, we kept this patch simple to facilitate
backporting to stable.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=63914
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 41e02dc..5e50875 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -1247,23 +1247,23 @@ ilk_dummy_write(struct drm_i915_private *dev_priv)
 
 #define __i915_read(x, y) \
 u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg) { \
+	unsigned long irqflags; \
 	u##x val = 0; \
+	spin_lock_irqsave(&dev_priv->gt_lock, irqflags); \
 	if (IS_GEN5(dev_priv->dev)) \
 		ilk_dummy_write(dev_priv); \
 	if (NEEDS_FORCE_WAKE((dev_priv), (reg))) { \
-		unsigned long irqflags; \
-		spin_lock_irqsave(&dev_priv->gt_lock, irqflags); \
 		if (dev_priv->forcewake_count == 0) \
 			dev_priv->gt.force_wake_get(dev_priv); \
 		val = read##y(dev_priv->regs + reg); \
 		if (dev_priv->forcewake_count == 0) \
 			dev_priv->gt.force_wake_put(dev_priv); \
-		spin_unlock_irqrestore(&dev_priv->gt_lock, irqflags); \
 	} else if (IS_VALLEYVIEW(dev_priv->dev) && IS_DISPLAYREG(reg)) { \
 		val = read##y(dev_priv->regs + reg + 0x180000);		\
 	} else { \
 		val = read##y(dev_priv->regs + reg); \
 	} \
+	spin_unlock_irqrestore(&dev_priv->gt_lock, irqflags); \
 	trace_i915_reg_rw(false, reg, val, sizeof(val)); \
 	return val; \
 }
@@ -1276,8 +1276,10 @@ __i915_read(64, q)
 
 #define __i915_write(x, y) \
 void i915_write##x(struct drm_i915_private *dev_priv, u32 reg, u##x val) { \
+	unsigned long irqflags; \
 	u32 __fifo_ret = 0; \
 	trace_i915_reg_rw(true, reg, val, sizeof(val)); \
+	spin_lock_irqsave(&dev_priv->gt_lock, irqflags); \
 	if (NEEDS_FORCE_WAKE((dev_priv), (reg))) { \
 		__fifo_ret = __gen6_gt_wait_for_fifo(dev_priv); \
 	} \
@@ -1299,6 +1301,7 @@ void i915_write##x(struct drm_i915_private *dev_priv, u32 reg, u##x val) { \
 		DRM_ERROR("Unclaimed write to %x\n", reg); \
 		writel(ERR_INT_MMIO_UNCLAIMED, dev_priv->regs + GEN7_ERR_INT);	\
 	} \
+	spin_unlock_irqrestore(&dev_priv->gt_lock, irqflags); \
 }
 __i915_write(8, b)
 __i915_write(16, w)
-- 
1.8.1.2

