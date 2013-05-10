Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3EJMNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:13:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:13936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab3EJMNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:13:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,647,1363158000"; 
   d="scan'208";a="331927016"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 03/11] drm/i915: take msecs_to_jiffies_min into use
Date: Fri, 10 May 2013 15:13:21 +0300
Message-Id: <1368188011-23661-3-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use msecs_to_jiffies_min instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/i915/intel_dp.c  |    2 +-
 drivers/gpu/drm/i915/intel_drv.h |    2 +-
 drivers/gpu/drm/i915/intel_i2c.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 92d1334..8be304d 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -276,7 +276,7 @@ intel_dp_aux_wait_done(struct intel_dp *intel_dp, bool has_aux_irq)
 #define C (((status = I915_READ_NOTRACE(ch_ctl)) & DP_AUX_CH_CTL_SEND_BUSY) == 0)
 	if (has_aux_irq)
 		done = wait_event_timeout(dev_priv->gmbus_wait_queue, C,
-					  msecs_to_jiffies(10) + 1);
+					  msecs_to_jiffies_min(10));
 	else
 		done = wait_for_atomic(C, 10) == 0;
 	if (!done && !(C))
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 388a394..f2e3409 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -42,7 +42,7 @@
  * we've never had a chance to check the condition before the timeout.
  */
 #define _wait_for(COND, MS, W) ({ \
-	unsigned long timeout__ = jiffies + msecs_to_jiffies(MS) + 1;	\
+	unsigned long timeout__ = jiffies + msecs_to_jiffies_min(MS);	\
 	int ret__ = 0;							\
 	while (!(COND)) {						\
 		if (time_after(jiffies, timeout__)) {			\
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 5d24503..447b4b0 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -228,7 +228,7 @@ gmbus_wait_hw_status(struct drm_i915_private *dev_priv,
 	 * need to wake up periodically and check that ourselves. */
 	I915_WRITE(GMBUS4 + reg_offset, gmbus4_irq_en);
 
-	for (i = 0; i < msecs_to_jiffies(50) + 1; i++) {
+	for (i = 0; i < msecs_to_jiffies_min(50); i++) {
 		prepare_to_wait(&dev_priv->gmbus_wait_queue, &wait,
 				TASK_UNINTERRUPTIBLE);
 
-- 
1.7.10.4

