Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3CZWoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3CZWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 46/98] Revert "drm/i915: write backlight harder"
Date: Tue, 26 Mar 2013 15:42:35 -0700
Message-Id: <20130326224247.314504985@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit b1289371fcd580b4c412e6d05c4cb8ac8d277239 upstream.

This reverts commit cf0a6584aa6d382f802f2c3cacac23ccbccde0cd.

Turns out that cargo-culting breaks systems. Note that we can't revert
further, since

commit 770c12312ad617172b1a65b911d3e6564fc5aca8
Author: Takashi Iwai <tiwai@suse.de>
Date:   Sat Aug 11 08:56:42 2012 +0200

    drm/i915: Fix blank panel at reopening lid

fixed a regression in 3.6-rc kernels for which we've never figured out
the exact root cause. But some further inspection of the backlight
code reveals that it's seriously lacking locking. And especially the
asle backlight update is know to get fired (through some smm magic)
when writing specific backlight control registers. So the possibility
of suffering from races is rather real.

Until those races are fixed I don't think it makes sense to try
further hacks. Which sucks a bit, but sometimes that's how it is :(

References: http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg18788.html
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47941
Tested-by: Takashi Iwai <tiwai@suse.de>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_panel.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -321,9 +321,6 @@ void intel_panel_enable_backlight(struct
 	if (dev_priv->backlight_level == 0)
 		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
 
-	dev_priv->backlight_enabled = true;
-	intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
-
 	if (INTEL_INFO(dev)->gen >= 4) {
 		uint32_t reg, tmp;
 
@@ -359,12 +356,12 @@ void intel_panel_enable_backlight(struct
 	}
 
 set_level:
-	/* Check the current backlight level and try to set again if it's zero.
-	 * On some machines, BLC_PWM_CPU_CTL is cleared to zero automatically
-	 * when BLC_PWM_CPU_CTL2 and BLC_PWM_PCH_CTL1 are written.
+	/* Call below after setting BLC_PWM_CPU_CTL2 and BLC_PWM_PCH_CTL1.
+	 * BLC_PWM_CPU_CTL may be cleared to zero automatically when these
+	 * registers are set.
 	 */
-	if (!intel_panel_get_backlight(dev))
-		intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
+	dev_priv->backlight_enabled = true;
+	intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
 }
 
 static void intel_panel_init_backlight(struct drm_device *dev)


