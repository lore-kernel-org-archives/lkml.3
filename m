Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3HMGru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:47:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab3HMGdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Zhouping Liu <zliu@redhat.com>
Subject: [ 54/60] drm/i915: initialize gt_lock early with other spin locks
Date: Mon, 12 Aug 2013 23:34:21 -0700
Message-Id: <20130813063338.716215685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Zhouping Liu <zliu@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_dma.c |    1 +
 drivers/gpu/drm/i915/intel_pm.c |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1514,6 +1514,7 @@ int i915_driver_load(struct drm_device *
 	spin_lock_init(&dev_priv->irq_lock);
 	spin_lock_init(&dev_priv->gpu_error.lock);
 	spin_lock_init(&dev_priv->rps.lock);
+	spin_lock_init(&dev_priv->gt_lock);
 	mutex_init(&dev_priv->dpio_lock);
 	mutex_init(&dev_priv->rps.hw_lock);
 	mutex_init(&dev_priv->modeset_restore_lock);
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4507,8 +4507,6 @@ void intel_gt_init(struct drm_device *de
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
-	spin_lock_init(&dev_priv->gt_lock);
-
 	if (IS_VALLEYVIEW(dev)) {
 		dev_priv->gt.force_wake_get = vlv_force_wake_get;
 		dev_priv->gt.force_wake_put = vlv_force_wake_put;


