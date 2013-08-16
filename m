Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab3HPWrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:47:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3HPWlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 033/133] drm/i915: initialize gt_lock early with other spin locks
Date: Fri, 16 Aug 2013 15:32:55 -0700
Message-Id: <1376692475-28413-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@linux.intel.com>

commit 14c5cec5d0cd73e7e9d4fbea2bbfeea8f3ade871 upstream.

commit 181d1b9e31c668259d3798c521672afb8edd355c
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Sun Jul 21 13:16:24 2013 +0200

    drm/i915: fix up gt init sequence fallout

moved dev_priv->gt_lock initialization after use. Do the initialization
much earlier with other spin lock initializations.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 1 +
 drivers/gpu/drm/i915/intel_pm.c | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 38254c0..565a889 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1469,6 +1469,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	spin_lock_init(&dev_priv->error_lock);
 	spin_lock_init(&dev_priv->rps.lock);
 	spin_lock_init(&dev_priv->dpio_lock);
+	spin_lock_init(&dev_priv->gt_lock);
 	mutex_init(&dev_priv->rps.hw_lock);
 
 	i915_dump_device_info(dev_priv);
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 7af828c..6538d3f 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4408,8 +4408,6 @@ void intel_gt_init(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	spin_lock_init(&dev_priv->gt_lock);
-
 	if (IS_VALLEYVIEW(dev)) {
 		dev_priv->gt.force_wake_get = vlv_force_wake_get;
 		dev_priv->gt.force_wake_put = vlv_force_wake_put;
-- 
1.8.1.2

