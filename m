Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763226AbbA2Cxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:53:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47031 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965488AbbA2CiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 097/139] drm/i915: Don't complain about stolen conflicts on gen3
Date: Wed, 28 Jan 2015 14:20:40 -0800
Message-Id: <1422483682-15393-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 0b6d24c01932db99fc95304235e751e7f7625c41 upstream.

Apparently stuff works that way on those machines.

I agree with Chris' concern that this is a bit risky but imo worth a
shot in -next just for fun. Afaics all these machines have the pci
resources allocated like that by the BIOS, so I suspect that it's all
ok.

This regression goes back to

commit eaba1b8f3379b5d100bd146b9a41d28348bdfd09
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Jul 4 12:28:35 2013 +0100

    drm/i915: Verify that our stolen memory doesn't conflict

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76983
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71031
Tested-by: lu hua <huax.lu@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_stolen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index 6471872..59bc589 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -125,7 +125,11 @@ static unsigned long i915_stolen_to_physical(struct drm_device *dev)
 	 */
 	r = devm_request_mem_region(dev->dev, base, dev_priv->gtt.stolen_size,
 				    "Graphics Stolen Memory");
-	if (r == NULL) {
+	/*
+	 * GEN3 firmware likes to smash pci bridges into the stolen
+	 * range. Apparently this works.
+	 */
+	if (r == NULL && !IS_GEN3(dev)) {
 		DRM_ERROR("conflict detected with stolen region: [0x%08x - 0x%08x]\n",
 			  base, base + (uint32_t)dev_priv->gtt.stolen_size);
 		base = 0;
-- 
1.9.1

