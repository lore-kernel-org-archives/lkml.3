Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967406AbaFQWGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:06:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54747 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966985AbaFQVwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Lu <aaron.lu@intel.com>, Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 124/212] drm/i915: restore backlight precision when converting from ACPI
Date: Tue, 17 Jun 2014 14:43:38 -0700
Message-Id: <1403041506-13646-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_panel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index e6f782d..5e7db10 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -544,6 +544,7 @@ void intel_panel_set_backlight(struct intel_connector *connector, u32 level,
 	enum pipe pipe = intel_get_pipe_from_connector(connector);
 	u32 freq;
 	unsigned long flags;
+	u64 n;
 
 	if (pipe == INVALID_PIPE)
 		return;
@@ -557,10 +558,9 @@ void intel_panel_set_backlight(struct intel_connector *connector, u32 level,
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

