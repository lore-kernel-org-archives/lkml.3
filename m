Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaFJTve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:51:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbaFJTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@linux.intel.com>, Egbert Eich <eich@suse.de>,
        bitlord <bitlord0xff@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 108/160] drm/i915: Don't WARN nor handle unexpected hpd interrupts on gmch platforms
Date: Tue, 10 Jun 2014 12:45:48 -0700
Message-Id: <1402429600-20477-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 3ff04a160a891e56cdcee5c198d4c764d1c8c78b upstream.

The status bits are unconditionally set, the control bits only enable
the actual interrupt generation. Which means if we get some random
other interrupts we'll bogusly complain about them.

So restrict the WARN to platforms with a sane hotplug interrupt
handling scheme. And even more important also don't attempt to process
the hpd bit since we've detected a storm already. Instead just clear
the bit silently.

This WARN has been introduced in

commit b8f102e8bf71cacf33326360fdf9dcfd1a63925b
Author: Egbert Eich <eich@suse.de>
Date:   Fri Jul 26 14:14:24 2013 +0200

    drm/i915: Add messages useful for HPD storm detection debugging (v2)

before that we silently handled the hpd event and so partially
defeated the storm detection.

v2: Pimp commit message (Jani)

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Egbert Eich <eich@suse.de>
Cc: bitlord <bitlord0xff@gmail.com>
Reported-by: bitlord <bitlord0xff@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_irq.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 9702704..4ad5cc5 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1234,9 +1234,20 @@ static inline void intel_hpd_irq_handler(struct drm_device *dev,
 	spin_lock(&dev_priv->irq_lock);
 	for (i = 1; i < HPD_NUM_PINS; i++) {
 
-		WARN(((hpd[i] & hotplug_trigger) &&
-		      dev_priv->hpd_stats[i].hpd_mark != HPD_ENABLED),
-		     "Received HPD interrupt although disabled\n");
+		if (hpd[i] & hotplug_trigger &&
+		    dev_priv->hpd_stats[i].hpd_mark == HPD_DISABLED) {
+			/*
+			 * On GMCH platforms the interrupt mask bits only
+			 * prevent irq generation, not the setting of the
+			 * hotplug bits itself. So only WARN about unexpected
+			 * interrupts on saner platforms.
+			 */
+			WARN_ONCE(INTEL_INFO(dev)->gen >= 5 && !IS_VALLEYVIEW(dev),
+				  "Received HPD interrupt (0x%08x) on pin %d (0x%08x) although disabled\n",
+				  hotplug_trigger, i, hpd[i]);
+
+			continue;
+		}
 
 		if (!(hpd[i] & hotplug_trigger) ||
 		    dev_priv->hpd_stats[i].hpd_mark != HPD_ENABLED)
-- 
1.9.1

