Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341AbbA2KHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:07:42 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44749 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757685AbbA2JBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:45 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 077/176] drm/i915: Don't complain about stolen conflicts on gen3
Date: Wed, 28 Jan 2015 15:28:27 +0100
Message-Id: <c5fb31ccb41fa355e3cb996b045e5bd3e0b36c28.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/i915_gem_stolen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index b6d73fee7aec..c052e1e49d75 100644
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
2.2.2

