Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaFWIgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:36:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55640 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/111] drm/i915: restrict vt-d stolen memory workaround to pre-gen8
Date: Mon, 23 Jun 2014 10:30:39 +0200
Message-Id: <ce4a258420cd5444a32694af21bf708bd4e91d12.1403512280.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fcc9fe1a5ad2b826c6ac58c03cdc0cf17a63c7a1 upstream.

We want future generations to at least attempt to use all features, so
restrict the stolen memory disabling when vt-d is enabled to the
latest generation we have reports for. Which is a HSW per the original
report.

Also once we get a bit a hold of some of the mysterious framebuffer in
stolen memory issues that still haunt bugzilla, we should probably
drop this hack again and see what happens.

This was introduced in

commit 0f4706d2740f2a221cd502922b22e522009041d9
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Mar 18 14:50:50 2014 +0200

    drm/i915: Disable stolen memory when DMAR is active

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
References: https://bugs.freedesktop.org/show_bug.cgi?id=68535
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/i915_gem_stolen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index c077df094ae5..c60cdf9e581e 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -202,7 +202,7 @@ int i915_gem_init_stolen(struct drm_device *dev)
 	int bios_reserved = 0;
 
 #ifdef CONFIG_INTEL_IOMMU
-	if (intel_iommu_gfx_mapped) {
+	if (intel_iommu_gfx_mapped && INTEL_INFO(dev)->gen < 8) {
 		DRM_INFO("DMAR active, disabling use of stolen memory\n");
 		return 0;
 	}
-- 
2.0.0

