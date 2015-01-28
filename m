Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbbA2JGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:06:34 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44866 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752384AbbA2JGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:06:22 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Akash Goel <akash.goel@intel.com>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 070/176] drm/i915: Resolving the memory region conflict for Stolen area
Date: Wed, 28 Jan 2015 15:28:20 +0100
Message-Id: <b743bb06c114ab8964e2f2313163b7ab10468743.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akash Goel <akash.goel@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3617dc9675f0184b7bb210cfa34f3cac928d8055 upstream.

There is a conflict seen when requesting the kernel to reserve
the physical space used for the stolen area. This is because
some BIOS are wrapping the stolen area in the root PCI bus, but have
an off-by-one error. As a workaround we retry the reservation with an
offset of 1 instead of 0.

v2: updated commit message & the comment in source file (Daniel)

Signed-off-by: Akash Goel <akash.goel@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/i915_gem_stolen.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_stolen.c b/drivers/gpu/drm/i915/i915_gem_stolen.c
index 5cd69a7cc241..b6d73fee7aec 100644
--- a/drivers/gpu/drm/i915/i915_gem_stolen.c
+++ b/drivers/gpu/drm/i915/i915_gem_stolen.c
@@ -126,9 +126,22 @@ static unsigned long i915_stolen_to_physical(struct drm_device *dev)
 	r = devm_request_mem_region(dev->dev, base, dev_priv->gtt.stolen_size,
 				    "Graphics Stolen Memory");
 	if (r == NULL) {
-		DRM_ERROR("conflict detected with stolen region: [0x%08x - 0x%08x]\n",
-			  base, base + (uint32_t)dev_priv->gtt.stolen_size);
-		base = 0;
+		/*
+		 * One more attempt but this time requesting region from
+		 * base + 1, as we have seen that this resolves the region
+		 * conflict with the PCI Bus.
+		 * This is a BIOS w/a: Some BIOS wrap stolen in the root
+		 * PCI bus, but have an off-by-one error. Hence retry the
+		 * reservation starting from 1 instead of 0.
+		 */
+		r = devm_request_mem_region(dev->dev, base + 1,
+					    dev_priv->gtt.stolen_size - 1,
+					    "Graphics Stolen Memory");
+		if (r == NULL) {
+			DRM_ERROR("conflict detected with stolen region: [0x%08x - 0x%08x]\n",
+				  base, base + (uint32_t)dev_priv->gtt.stolen_size);
+			base = 0;
+		}
 	}
 
 	return base;
-- 
2.2.2

