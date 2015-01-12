Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbbALSIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:08:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57829 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbbALSGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 112/216] drm/i915: Don't complain about stolen conflicts on gen3
Date: Mon, 12 Jan 2015 18:03:49 +0000
Message-Id: <1421085933-32536-113-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_stolen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index 7465ab0fd396..936571622b43 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -137,7 +137,11 @@ static unsigned long i915_stolen_to_physical(struct drm_device *dev)
 		r = devm_request_mem_region(dev->dev, base + 1,
 					    dev_priv->gtt.stolen_size - 1,
 					    "Graphics Stolen Memory");
-		if (r == NULL) {
+		/*
+		 * GEN3 firmware likes to smash pci bridges into the stolen
+		 * range. Apparently this works.
+		 */
+		if (r == NULL && !IS_GEN3(dev)) {
 			DRM_ERROR("conflict detected with stolen region: [0x%08x - 0x%08x]\n",
 				  base, base + (uint32_t)dev_priv->gtt.stolen_size);
 			base = 0;
-- 
2.1.4

