Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaLEMRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:17:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:34247 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaLEMRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:17:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,522,1413270000"; 
   d="scan'208";a="633185131"
From: Jani Nikula <jani.nikula@intel.com>
To: intel-gfx@lists.freedesktop.org, Jeremiah Mahler <jmmahler@gmail.com>,
        weiyj_lk@163.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915: release struct_mutex on the i915_gem_init_hw fail path
Date: Fri,  5 Dec 2014 14:17:42 +0200
Message-Id: <1417781862-23368-2-git-send-email-jani.nikula@intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417781862-23368-1-git-send-email-jani.nikula@intel.com>
References: <20141205013911.GA1510@hudson.localdomain>
 <1417781862-23368-1-git-send-email-jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release struct_mutex if init_rings() fails.

This is a regression introduced in
commit 35a57ffbb10840af219eeaf64718434242bb7c76
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Nov 20 00:33:07 2014 +0100

    drm/i915: Only init engines once

Reported-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index c1c11418231b..e3ce4bef22a3 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4860,22 +4860,18 @@ int i915_gem_init(struct drm_device *dev)
 	}
 
 	ret = i915_gem_init_userptr(dev);
-	if (ret) {
-		mutex_unlock(&dev->struct_mutex);
-		return ret;
-	}
+	if (ret)
+		goto out_unlock;
 
 	i915_gem_init_global_gtt(dev);
 
 	ret = i915_gem_context_init(dev);
-	if (ret) {
-		mutex_unlock(&dev->struct_mutex);
-		return ret;
-	}
+	if (ret)
+		goto out_unlock;
 
 	ret = dev_priv->gt.init_rings(dev);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	ret = i915_gem_init_hw(dev);
 	if (ret == -EIO) {
@@ -4887,6 +4883,8 @@ int i915_gem_init(struct drm_device *dev)
 		atomic_set_mask(I915_WEDGED, &dev_priv->gpu_error.reset_counter);
 		ret = 0;
 	}
+
+out_unlock:
 	mutex_unlock(&dev->struct_mutex);
 
 	return ret;
-- 
2.1.3

