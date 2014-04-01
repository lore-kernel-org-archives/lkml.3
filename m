Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaDAQcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:32:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44582 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaDAQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 76/86] drm/i915: Disable stolen memory when DMAR is active
Date: Tue,  1 Apr 2014 09:08:29 -0700
Message-Id: <1396368519-12728-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 0f4706d2740f2a221cd502922b22e522009041d9 upstream.

We have reports of heavy screen corruption if we try to use the stolen
memory reserved by the BIOS whilst the DMA-Remapper is active. This
quirk may be only specific to a few machines or BIOSes, but first lets
apply the big hammer and always disable use of stolen memory when DMAR
is active.

v2 by Jani: Rebase on -fixes, only look at intel_iommu_gfx_mapped.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=68535
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_stolen.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index be24312..af92fea 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -174,6 +174,13 @@ int i915_gem_init_stolen(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	unsigned long prealloc_size = dev_priv->mm.gtt->stolen_size;
 
+#ifdef CONFIG_INTEL_IOMMU
+	if (intel_iommu_gfx_mapped) {
+		DRM_INFO("DMAR active, disabling use of stolen memory\n");
+		return 0;
+	}
+#endif
+
 	dev_priv->mm.stolen_base = i915_stolen_to_physical(dev);
 	if (dev_priv->mm.stolen_base == 0)
 		return 0;
-- 
1.8.3.2

