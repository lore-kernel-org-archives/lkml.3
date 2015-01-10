Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbbAJV07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:26:59 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:61142 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbAJV06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:26:58 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH] drm/i915: fix inconsistent brightness after resume
Date: Sat, 10 Jan 2015 13:25:35 -0800
Message-Id: <1420925135-1589-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <87fvbkz7nd.fsf@intel.com>
References: <87fvbkz7nd.fsf@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6dda730e55f4 introduced a bug which resulted in inconsistent
brightness levels on different machines. If a suspended was entered
with the screen off some machines would resume with the screen
at minimum brightness and others at maximum brightness.

The following commands can be used to produce this behavior.

  xset dpms force off
  sleep 1
  sudo systemctl suspend
  (resume ...)

The root cause of this problem is a comparison which checks to see if
the backlight level is zero when the panel is enabled.  If it is zero,
it is set to the maximum level.  Unfortunately, not all machines have a
minimum level of zero. On those machines the level is left at the
minimum instead of begin set to the maximum.

Fix the bug by updating the comparison to check for the minimum
backlight level instead of zero.

Fixes: 6dda730e55f4 ("respect the VBT minimum backlight brightness")
Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/gpu/drm/i915/intel_panel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 4d63839..4ef4d66 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -962,7 +962,7 @@ void intel_panel_enable_backlight(struct intel_connector *connector)
 
 	WARN_ON(panel->backlight.max == 0);
 
-	if (panel->backlight.level == 0) {
+	if (panel->backlight.level == panel->backlight.min) {
 		panel->backlight.level = panel->backlight.max;
 		if (panel->backlight.device)
 			panel->backlight.device->props.brightness =
-- 
2.1.4

