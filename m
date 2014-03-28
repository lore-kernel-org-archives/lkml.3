Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaC1RtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:49:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaC1Ra4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.13 06/46] drm/i915: Disable stolen memory when DMAR is active
Date: Fri, 28 Mar 2014 10:31:50 -0700
Message-Id: <20140328173135.501262276@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_stolen.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -201,6 +201,13 @@ int i915_gem_init_stolen(struct drm_devi
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int bios_reserved = 0;
 
+#ifdef CONFIG_INTEL_IOMMU
+	if (intel_iommu_gfx_mapped) {
+		DRM_INFO("DMAR active, disabling use of stolen memory\n");
+		return 0;
+	}
+#endif
+
 	if (dev_priv->gtt.stolen_size == 0)
 		return 0;
 


