Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474Ab3B0A5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:57:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759877Ab3BZX6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 085/150] drm/i915: write backlight harder
Date: Tue, 26 Feb 2013 15:55:42 -0800
Message-Id: <20130226235532.934910414@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit cf0a6584aa6d382f802f2c3cacac23ccbccde0cd upstream.

770c12312ad617172b1a65b911d3e6564fc5aca8 is the first bad commit
commit 770c12312ad617172b1a65b911d3e6564fc5aca8
Author: Takashi Iwai <tiwai@suse.de>
Date:   Sat Aug 11 08:56:42 2012 +0200

    drm/i915: Fix blank panel at reopening lid

changed the register write sequence for restoring the backlight, which
helped prevent non-working backlights on some machines. Turns out that
the original sequence was the right thing to do for a different set of
machines. Worse, setting the backlight level _after_ enabling it seems
to reset it somehow. So we need to make that one conditional upon the
backlight having been reset to zero, and add the old one back.

Cargo-culting at it's best, but it seems to work.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47941
Cc: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_panel.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -321,6 +321,9 @@ void intel_panel_enable_backlight(struct
 	if (dev_priv->backlight_level == 0)
 		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
 
+	dev_priv->backlight_enabled = true;
+	intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
+
 	if (INTEL_INFO(dev)->gen >= 4) {
 		uint32_t reg, tmp;
 
@@ -356,12 +359,12 @@ void intel_panel_enable_backlight(struct
 	}
 
 set_level:
-	/* Call below after setting BLC_PWM_CPU_CTL2 and BLC_PWM_PCH_CTL1.
-	 * BLC_PWM_CPU_CTL may be cleared to zero automatically when these
-	 * registers are set.
+	/* Check the current backlight level and try to set again if it's zero.
+	 * On some machines, BLC_PWM_CPU_CTL is cleared to zero automatically
+	 * when BLC_PWM_CPU_CTL2 and BLC_PWM_PCH_CTL1 are written.
 	 */
-	dev_priv->backlight_enabled = true;
-	intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
+	if (!intel_panel_get_backlight(dev))
+		intel_panel_actually_set_backlight(dev, dev_priv->backlight_level);
 }
 
 static void intel_panel_init_backlight(struct drm_device *dev)


