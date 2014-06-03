Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaFCMAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:00:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795AbaFCLly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Lu <aaron.lu@intel.com>, Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 082/138] drm/i915: restore backlight precision when converting from ACPI
Date: Tue,  3 Jun 2014 12:38:48 +0100
Message-Id: <1401795584-22664-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 721e82c08c1afd6b47367b0e0c4a62140b0667f3 upstream.

When we set backlight on behalf of ACPI opregion, we will convert the
backlight value in the 0-255 range defined in opregion to the actual
hardware level. Commit 22505b82a2 (drm/i915: avoid brightness overflow
when doing scale) is meant to fix the overflow problem when doing the
conversion, but it also caused a problem that the converted hardware
level doesn't quite represent the intended value: say user wants maximum
backlight level(255 in opregion's range), then we will calculate the
actual hardware level to be: level = freq / max * level, where freq is
the hardware's max backlight level(937 on an user's box), and max and
level are all 255. The converted value should be 937 but the above
calculation will yield 765.

To fix this issue, just use 64 bits to do the calculation to keep the
precision and avoid overflow at the same time.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=72491
Reported-by: Nico Schottelius <nico-bugzilla.kernel.org@schottelius.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_panel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 5950888ae1d0..7a66423c93ab 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -488,6 +488,7 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level, u32 max)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 freq;
 	unsigned long flags;
+	u64 n;
 
 	spin_lock_irqsave(&dev_priv->backlight.lock, flags);
 
@@ -498,10 +499,9 @@ void intel_panel_set_backlight(struct drm_device *dev, u32 level, u32 max)
 	}
 
 	/* scale to hardware, but be careful to not overflow */
-	if (freq < max)
-		level = level * freq / max;
-	else
-		level = freq / max * level;
+	n = (u64)level * freq;
+	do_div(n, max);
+	level = n;
 
 	dev_priv->backlight.level = level;
 	if (dev_priv->backlight.device)
-- 
1.9.1

