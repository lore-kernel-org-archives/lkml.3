Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbaFEAku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:40:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaFDXVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>, Egbert Eich <eich@suse.de>,
        bitlord <bitlord0xff@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.14 064/228] drm/i915: Dont WARN nor handle unexpected hpd interrupts on gmch platforms
Date: Wed,  4 Jun 2014 16:21:33 -0700
Message-Id: <20140604232350.111431164@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_irq.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -1252,10 +1252,20 @@ static inline void intel_hpd_irq_handler
 	spin_lock(&dev_priv->irq_lock);
 	for (i = 1; i < HPD_NUM_PINS; i++) {
 
-		WARN_ONCE(hpd[i] & hotplug_trigger &&
-			  dev_priv->hpd_stats[i].hpd_mark == HPD_DISABLED,
-			  "Received HPD interrupt (0x%08x) on pin %d (0x%08x) although disabled\n",
-			  hotplug_trigger, i, hpd[i]);
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


